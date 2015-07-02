class Order < ActiveRecord::Base
  POSSIBLE_STATES = ['in progress','completed','shipped']

  belongs_to :customer
  belongs_to :credit_card
  has_many :order_items
  belongs_to :billing_address, class_name: "Address"
  belongs_to :shipping_address, class_name: "Address"

  validates_presence_of :total_price
  validates_presence_of :completed_date, if: -> {self.state == POSSIBLE_STATES[1]}
  validates :state, inclusion: { in: POSSIBLE_STATES }, presence: true

  after_initialize :set_default_state
  after_initialize :set_default_total_price
  before_save :calc_and_set_total_price

  scope :in_progress, -> {where(state: POSSIBLE_STATES[0])}

  def add_to_order(book, quantity=1)
  order_item = self.order_items.find_by(book: book)
    if order_item
      order_item.quantity += quantity
      order_item.save
    else 
      self.order_items.create(price: book.price, quantity: quantity, book: book)
    end
    self.save
  end

  private
  def calc_and_set_total_price
    if self.order_items.any?
      self.total_price = self.order_items.inject(0.0) {|sum, i| sum + i.price*i.quantity} 
    else 
      self.total_price = 0.0
    end
  end

  def set_default_total_price
    self.total_price ||= 0.0
  end

  def set_default_state
    self.state ||= POSSIBLE_STATES[0]
  end
end
