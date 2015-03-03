class Item < ActiveRecord::Base
  acts_as_sellable

  def method_missing(name, args=nil)
    if (piggybak_sellable && piggybak_sellable.respond_to?(name))
      if args
        piggybak_sellable.send(name,args)
      else
        piggybak_sellable.send(name)
      end
    else
      super
    end
  end
end
