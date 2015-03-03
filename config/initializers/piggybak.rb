Piggybak.config do |config|
  # Add calculators with the following method
  #config.shipping_calculators << "Pickup"

  # Or, Override calculatores with the following override
  #config.payment_calculators = ["BeanstreamGateway"]

  # Override the default country
 # config.default_country = "CA"

  # Override the activemerchant billing mode
  config.activemerchant_mode = :test

  # You may add additional order logging via the following configs
  # logging (defaults to false)
  # logging_file (defaults to /log/orders.log)

  # Other configuration options include:
  # activemerchant_mode
  # email_sender
  # order_cc
  # whois_url

  # The following options are advanced plugin configuration options:
  # line_item_types
  # secure_checkout
  # secure_prefix
  # extra_secure_paths
  # manage_classes
  # extra_abilities
end