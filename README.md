# Webstore

This webstore application is a basic implementation of the [Piggybak](http://www.piggybak.org) mountable Rails engine.
This project is meant to be a quickly "cloneable" starter project that you can then modify to your needs.

 Piggybak makes use of the following projects, and some knowledge of each is beneficial to the developer:
 * [RailsAdmin](https://github.com/sferik/rails_admin): Handles basic management of users, items and a few other models.
 * [Devise](https://github.com/plataformatec/devise): Handles user authentication.
 * [CanCan](https://github.com/ryanb/cancan): Handles user authorization.

 In addition I have added the [Foundation](http://foundation.zurb.com/) css framework to give the store that slick
 responsive design.  I am gradually overriding most of the user facing views with foundation enabled haml views.

 ## Get Started!
 to get started simply clone this repo:


```
git clone https://github.com/datadude/webstore
```

Once you have this repo cloned, have a look at some of the docs listed above and customize to your heart's content!

## To Do
Here is a list of suggested improvments left up to you to implement.

1. Add pagination to list of products on home page.
2. Implement item "detail" pages with slugs
3. Implement a full palette of purchase options (only the  FakeCreditcard option has been implmented) including:
    * Credit Card (using [Active Merchant](https://github.com/Shopify/active_merchant) and your chosen gateway.)
    * [Amazon Checkout](https://payments.amazon.com/developer)
    * [Google Wallet](https://developers.google.com/wallet/)
    * PayPal (using [Active Merchant](https://github.com/Shopify/active_merchant).)

