class Order < ActiveRecord::Base
  default_scope { order('id DESC') }  
  POSSIBLE_STATES = ['in progress', 'completed', 'in delivery', 'delivered', 'canceled']

  belongs_to :customer
  belongs_to :credit_card
  belongs_to :delivery_type
  belongs_to :billing_address, class_name: "Address"
  belongs_to :shipping_address, class_name: "Address"
  
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items

  validates_presence_of :completed_date, if: -> {self.state == POSSIBLE_STATES[1]}
  validates :state, inclusion: { in: POSSIBLE_STATES }, presence: true

  after_initialize do
    self.state ||= POSSIBLE_STATES[0]
  end

  scope :in_progress, -> {where(state: POSSIBLE_STATES[0])}
  scope :completed, -> {where(state: POSSIBLE_STATES[1])}
  scope :in_delivery, -> {where(state: POSSIBLE_STATES[2])}
  scope :delivered, -> {where(state: POSSIBLE_STATES[3])}

  def add_to_order(book, quantity=1)  
    if order_item = self.order_items.find_by(book: book)
      order_item.quantity += quantity.to_i
      order_item.save
    else 
      self.order_items.create(price: book.price, quantity: quantity, book: book)
    end
    self.calc_and_set_total_price
  end

  def remove_from_order(item_id)
    OrderItem.find(item_id).destroy if self.order_items.ids.include?(item_id.to_i)
    self.destroy if self.order_items.empty?
  end

  def calc_and_set_total_price
    if self.order_items.any?
      item_total = self.order_items.inject(0) {|sum, i| sum + i.price*i.quantity} 
      shipping_price = self.delivery_type ? self.delivery_type.price : 0 
      self.total_price = item_total + shipping_price
    else 
      self.total_price = 0
    end
    self.save
  end

  def items_qty
    self.order_items.inject(0) {|sum, i| sum + i.quantity} if self.order_items.any?
  end

  def state_enum
    POSSIBLE_STATES
  end
end
