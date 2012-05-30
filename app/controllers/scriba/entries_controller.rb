class Scriba::EntriesController < Scriba::ApplicationController
  def index
    @from = begin
              Time.parse(params[:from])
            rescue Exception => e
              nil
            end

    @to = begin
            Time.parse(params[:to])
          rescue Exception => e
            nil
          end

    @entries = Scriba::Entry.order_by([:created_at, :desc])

    if @from
      @entries = @entries.where("created_at" => {"$gt" => @from})
    end

    if @to
      @entries = @entries.where("created_at" => {"$gt" => @to})
    end

    @user_id = if params[:user_id].present?
                 params[:user_id].to_i
               else
                 nil
               end

    if @user_id
      @entries = @entries.where("user_id" => @user_id)
    end

    @severity = params[:severity] if params[:severity].present?

    if @severity
      @entries = @entries.where("severity" => @severity)
      if @severity == "ERROR"
        selector = @entries.selector
        map = 'function() { emit(this.message, {count: 1}) };'
        reduce = 'function(message, values) { var result = 0; values.forEach(function(value) { result += 1 }); return result};'
        Scriba::Entry.collection.map_reduce map, reduce,
          query: selector,
          out: {replace: "scriba_report_items"}
        @report = Scriba::Entry.db.collection("scriba_report_items").find().to_a.map { |item|
          unless item["value"].is_a?(Hash)
            item["value"] = {"count" => item["value"]}
          end
          item
        }.sort {|a,b|
          b["value"]["count"] <=> a["value"]["count"]}
      end
    end

    @entries = @entries.paginate(page: params[:page], per_page: 200)
  end
end
