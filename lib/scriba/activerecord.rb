ActiveRecord::Base.class_eval do
  after_validation :log_errors, if: Proc.new {|m| m.errors.present?}

  private

  def log_errors
    Rails.logger.error "[validation] [#{self.class.to_s}] #{self.errors.full_messages.join("\n")}"
  end
end
