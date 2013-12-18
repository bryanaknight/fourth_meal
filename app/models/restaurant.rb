
class Restaurant < ActiveRecord::Base
  validates :title, :description, presence: true
  validates :title, uniqueness: true
  has_many  :items
  has_many  :orders
  has_many  :jobs
  belongs_to :region

  after_create :set_defaults

  def self.form_statuses
    ["pending", "approved", "active", "inactive", "rejected"].freeze
  end

  def self.active
    where(:status => "active")
  end

  def self.rejected
    where(:status => 'rejected')
  end

  def self.admin_visible
    where("status IS NOT 'rejected'")
  end

  def approve
    self.update(:status => "approved")
  end

  def activate
    self.update(:status => "active")
  end

  def reject
    self.update(:status => "rejected")
  end

  def set_defaults
    self.update(slug: title.parameterize)
  end

end

