require 'csv'

Piggybak::Country.delete_all
CSV.foreach("#{Rails.root}/db/countries.csv", col_sep: "\t") do |row|
  Piggybak::Country.create!(id: row[0], name: row[1], abbr: row[2], active_shipping: row[3], active_billing: row[4])
end

ActiveRecord::Base.connection.execute('SELECT pg_catalog.setval(\'piggybak_countries_id_seq\', 421, true)')



Piggybak::State.delete_all
CSV.foreach("#{Rails.root}/db/states.csv", col_sep: "\t") do |row|
  Piggybak::State.create!(id: row[0], abbr: row[1], name: row[2], country_id: row[3])
end

ActiveRecord::Base.connection.execute('SELECT pg_catalog.setval(\'piggybak_states_id_seq\', 7125, true)')

Piggybak::PaymentMethodValue.delete_all
ActiveRecord::Base.connection.execute('SELECT pg_catalog.setval(\'piggybak_payment_method_values_id_seq\', 2, true)')


Piggybak::PaymentMethod.delete_all
Piggybak::PaymentMethod.create!(id: 1, description: 'Fake Credit Card',klass: '::Piggybak::PaymentCalculator::Fake', active: 't' )
ActiveRecord::Base.connection.execute('SELECT pg_catalog.setval(\'piggybak_payment_methods_id_seq\', 2, true)')


Piggybak::ShippingMethodValue.delete_all
Piggybak::ShippingMethodValue.create!(id: 4,	shipping_method_id: 4, 	key: 'rate',	value: 10.00)
Piggybak::ShippingMethodValue.create!(id: 5,	shipping_method_id: 5, 	key: 'rate',	value: 20.00)
Piggybak::ShippingMethodValue.create!(id: 7,	shipping_method_id: 6, 	key: 'rate',	value: 0.00)
Piggybak::ShippingMethodValue.create!(id: 6,	shipping_method_id: 6, 	key: 'state_id',	value: 6907)
ActiveRecord::Base.connection.execute('SELECT pg_catalog.setval(\'piggybak_shipping_method_values_id_seq\', 8, true)')

Piggybak::ShippingMethod.delete_all
Piggybak::ShippingMethod.create!(id: 4, description: 'Standard Shipping',klass: '::Piggybak::ShippingCalculator::FlatRate', active: 't' )
Piggybak::ShippingMethod.create!(id: 5, description: 'Express Shipping',klass: '::Piggybak::ShippingCalculator::FlatRate', active: 't' )
ActiveRecord::Base.connection.execute('SELECT pg_catalog.setval(\'piggybak_shipping_methods_id_seq\', 6, true)')



