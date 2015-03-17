
  Piggybak::Cart.class_eval do
    def count
      self.sellables.sum { |item| item[:quantity] }
    end
  end
