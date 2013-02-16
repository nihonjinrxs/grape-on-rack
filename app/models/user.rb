class User < ActiveRecord::Base
  validates :name, :presence => true

  alias_method :base_to_s, :to_s
  def to_s
    "#{base_to_s}: id=#{@id}, name=#{@name}"
  end
end