module ApplicationHelper

  def shipping_method_options
    Piggybak::ShippingMethod.all.collect{|m| [ m.description,m.id ]}
  end
end
