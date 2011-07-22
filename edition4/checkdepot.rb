require 'rubygems'
require 'gorp/test'

class DepotTest < Gorp::TestCase

  input 'makedepot'
  output 'checkdepot'

  section 2, 'Instant Gratification' do
    ticket 4147,
      :title =>  "link_to generates incorrect hrefs",
      :match => /say\/hello\/say\/goodbye/

    assert_select 'h1', 'Hello from Rails!'
    assert_select "p", 'Find me in app/views/say/hello.html.erb'
    assert_select "a[href=http://localhost:#{$PORT}/say/goodbye]"
    assert_select "a[href=http://localhost:#{$PORT}/say/hello]"
    if RUBY_VERSION =~ /^1.8/
      assert_select 'p', /^It is now \w+ \w+ \d\d \d\d:\d\d:\d\d [+-]\d+ \d+/
    else
      assert_select 'p', /^It is now \d+-\d\d-\d\d \d\d:\d\d:\d\d [+-]\d+/
    end
  end

  section 6.1, 'Iteration A1: Creating the Products Maintenance Application' do
    ticket 3562,
      :list => :ruby,
      :title =>  "regression in respond_to?",
      :match => /I18n::UnknownFileType/
    assert_select '.stderr', :minimum => 0 do |errors|
      errors.each do |err|
        assert_match /\d+ tests, \d+ assertions, 0 failures, 0 errors/, err.to_s
      end
    end

    assert_select 'th', 'Image url'
    assert_select 'input#product_title[value=Web Design for Developers]'
    assert_select "a[href=http://localhost:#{$PORT}/products/1]", 'redirected'
    assert_select 'pre', /(1|0) tests, (1|0) assertions, 0 failures, 0 errors/,
      '(1|0) tests, (1|0) assertions, 0 failures, 0 errors'
    assert_select 'pre', /7 tests, 10 assertions, 0 failures, 0 errors/,
      '7 tests, 10 assertions, 0 failures, 0 errors'
  end

  section 6.2, "Iteration A2: Prettier Listings" do
    ticket 3570,
      :title =>  "Intermittent reloading issue: view",
      :match => /\.list_line_even/
    assert_select '.list_line_even'
  end

  section 6.3, "Playtime" do
    # assert_select '.stdout', /CreateProducts: reverted/
    # assert_select '.stdout', /CreateProducts: migrated/
    assert_select '.stdout', /user.email/
    assert_select '.stdout', /Initialized empty Git repository/
    assert_select '.stdout', /(Created initial |root-)commit.*Depot Scaffold/
  end

  section 7.1, "Iteration B1: Validate!" do
    assert_select 'h2', /4 errors\s+prohibited this product from being saved/
    assert_select 'li', "Image url can't be blank"
    assert_select 'li', 'Price is not a number'
    assert_select '.field_with_errors input[id=product_price]'
  end

  section 7.2, 'Iteration B2: Unit Testing' do
    ticket 3555,
      :list => :ruby,
      :title =>  "segvs since r28570",
      :match => /active_support\/dependencies.rb:\d+: \[BUG\] Segmentation fault/
    assert_select 'pre', /(1|0) tests, (1|0) assertions, 0 failures, 0 errors/,
      '(1|0) tests, (1|0) assertions, 0 failures, 0 errors'
    assert_select 'pre', /7 tests, 10 assertions, 0 failures, 0 errors/,
      '7 tests, 10 assertions, 0 failures, 0 errors'
    assert_select 'pre', /5 tests, 23 assertions, 0 failures, 0 errors/,
      '5 tests, 23 assertions, 0 failures, 0 errors'
  end

  section 8.1, "Iteration C1: Create the Catalog Listing" do
    assert_select 'p', 'Find me in app/views/store/index.html.erb'
    assert_select 'h1', 'Your Pragmatic Catalog'
    assert_select 'span.price', '49.5'
  end

  section 8.2, "Iteration C2: Add a Page Layout" do
    assert_select '#banner', /Pragmatic Bookshelf/
  end

  section 8.3, "Iteration C3: Use a Helper to Format the Price" do
    assert_select 'span.price', '$49.50'
  end

  section 8.4, "Iteration C4: Functional Testing" do
    assert_select 'pre', /5 tests, 23 assertions, 0 failures, 0 errors/
    assert_select 'pre', /8 tests, 11 assertions, 0 failures, 0 errors/
    assert_select 'pre', /8 tests, 15 assertions, 0 failures, 0 errors/
  end

  section 9.3, "Iteration D3: Adding a button" do
    assert_select 'input[type=submit][value=Add to Cart]'
    assert_select "a[href=http://localhost:#{$PORT}/carts/1]", 'redirected'
    assert_select '#notice', 'Line item was successfully created.'
    assert_select 'li', 'Programming Ruby 1.9'
  end

  section 9.4, "Playtime" do
    assert_select 'pre', /\d tests, 2\d assertions, 0 failures, 0 errors/,
      '\d tests, 2\d assertions, 0 failures, 0 errors'
    assert_select 'pre', /22 tests, 35 assertions, 0 failures, 0 errors/,
      '22 tests, 35 assertions, 0 failures, 0 errors'
  end

  section 10.1, "Iteration E1: Creating A Smarter Cart" do
    assert_select 'li', /3 (.|&#?\w+;) Programming Ruby 1.9/u
    assert_select 'pre', /Couldn't find Cart with ID=wibble/i
  end

  section 10.2, "Iteration E2: Handling Errors" do
    assert_select "a[href=http://localhost:#{$PORT}/]", 'redirected'
    assert_select '.hilight', 'Attempt to access invalid cart wibble'
    assert_select '#notice', 'Invalid cart'
  end

  section 10.3, "Iteration E3: Finishing the Cart" do
    assert_select '#notice', 'Your cart is currently empty'
    assert_select '.total_cell', '$121.50'
    assert_select 'input[type=submit][value=Empty cart]'
  end

  section 10.4, "Playtime" do
    assert_select 'pre', /\d tests, 2\d assertions, 0 failures, 0 errors/,
      '7 tests, 25 assertions, 0 failures, 0 errors'
    assert_select 'pre', /23 tests, 37 assertions, 0 failures, 0 errors/,
      '23 tests, 37 assertions, 0 failures, 0 errors'
    assert_select '.stdout', /AddPriceToLineItem: migrated/
  end

  section 11.1, "Iteration F1: Moving the Cart" do
    assert_select '.cart_title', 'Your Cart'
    assert_select '.total_cell', '$121.50'
    assert_select 'input[type=submit][value=Empty cart]'
  end

  section 11.4, "Iteration F4: Hide an Empty Cart" do
    assert_select '#cart[style=display: none]'
    assert_select '.total_cell', '$171.00'
  end

  section 11.5, "Testing AJAX changes" do
    ticket 4786,
      :title =>  "render with a partial in rjs fails ",
      :match => /Template::Error: Missing partial.* with.* :formats=&gt;\[:js\]/

    assert_select 'pre', /\d tests, 2\d assertions, 0 failures, 0 errors/,
      '\d tests, 2\d assertions, 0 failures, 0 errors'
    assert_select 'code', "undefined method `line_items' for nil:NilClass"
    assert_select 'pre', /2\d tests, 4\d assertions, 0 failures, 0 errors/,
      '2\d tests, 4\d assertions, 0 failures, 0 errors'
  end

  section 12.1, "Iteration G1: Capturing an Order" do
    assert_select 'input[type=submit][value=Place Order]'
    assert_select 'h2', /5 errors\s+prohibited this order from being saved/
    assert_select '#notice', 'Thank you for your order.'
  end

  section 12.2, "Iteration G2: Atom Feeds" do
    # raw xml
    assert_select '.stdout', /&lt;email&gt;customer@example.com&lt;\/email&gt;/,
      'Missing <email>customer@example.com</email>'
    assert_select '.stdout', /&lt;id type="integer"&gt;1&lt;\/id&gt;/,
      'Missing <id type="integer">1</id>'

    # html
    assert_select '.stdout', /&lt;a href="mailto:customer@example.com"&gt;/,
      'Missing <a href="mailto:customer@example.com">'

    # atom
    assert_select '.stdout', /&lt;summary type="xhtml"&gt;/,
      'Missing <summary type="xhtml">'
    assert_select '.stdout', /&lt;td&gt;Programming Ruby 1.9&lt;\/td&gt;/,
      'Missing <td>Programming Ruby 1.9</td>'

    # json
    assert_select '.stdout', /, ?"title": ?"Programming Ruby 1.9"/,
      'Missing "title": "Programming Ruby 1.9"'

    # custom xml
    assert_select '.stdout', /&lt;order_list for_product=.*&gt;/,
      'Missing <order_list for_product=.*>'
  end

  section 12.3, "Iteration G3: Pagination" do
    next unless File.exist? 'public/images'
    assert_select 'td', 'Customer 100'
    assert_select "a[href=http://localhost:#{$PORT}/orders?page=4]"
  end

  section 12.4, "Playtime" do
    ticket 4786,
      :title =>  "render with a partial in rjs fails ",
      :match => /Template::Error: Missing partial.* with.* :formats=&gt;\[:js\]/

    assert_select 'pre', 
      /\d tests, [23]\d assertions, 0 failures, 0 errors/,
      '\d tests, [23]\d assertions, 0 failures, 0 errors'
    assert_select 'pre', 
      /3\d tests, [45]\d assertions, 0 failures, 0 errors/,
      '3\d tests, [45]\d assertions, 0 failures, 0 errors'
  end

  section 12.7, "Iteration J2: Email Notifications" do
    assert_select 'pre', /2 tests, \d+ assertions, 0 failures, 0 errors/
  end

  section 12.8, "Iteration J3: Integration Tests" do
    ticket 4786,
      :title =>  "render with a partial in rjs fails ",
      :match => /Template::Error: Missing partial.* with.* :formats=&gt;\[:js\]/

    ticket 4213,
      :title =>  "undefined method `named_routes' in integration test",
      :match => /NoMethodError: undefined method `named_routes' for nil:NilClass/
    assert_select 'pre', /3 tests, \d+ assertions, 0 failures, 0 errors/
  end

  section 13.1, "Iteration H1: Adding Users" do
    assert_select 'legend', 'Enter User Details'
    # assert_select 'td', 'User dave was successfully created.'
    assert_select 'h1', 'Listing users'
    assert_select 'td', 'dave'
  end

  section 13.2, "Iteration H2: Authenticating Users" do
  end

  section 13.3, "Iteration H3: Limiting Access" do
    assert_select 'legend', 'Please Log In'
    assert_select 'input[type=submit][value=Login]'
    assert_select 'h1', 'Welcome'
    assert_select "a[href=http://localhost:#{$PORT}/login]", 'redirected'
    assert_select 'h1', 'Listing products'
  end

  section 13.4, "Iteration H4: Adding a Sidebar" do
  end

  section 13.5, "Playtime" do
    ticket 4786,
      :title =>  "render with a partial in rjs fails ",
      :match => /Template::Error: Missing partial.* with.* :formats=&gt;\[:js\]/

    assert_select 'pre',
      /1?\d tests, [23]\d assertions, 0 failures, 0 errors/,
      '1?\d tests, [23]\d assertions, 0 failures, 0 errors'
    assert_select 'pre', 
      /46 tests, [78]\d assertions, 0 failures, 0 errors/
      '46 tests, [78]\d assertions, 0 failures, 0 errors'

    assert_select '.stdout', /login"&gt;redirected/
    assert_select '.stdout', /customer@example.com/
  end

  section 15.1, "Task I1: i18n for the store front" do
    assert_select '#notice', 'es translation not available'
    assert_select '.price', /49,50(.|&#?\w+;)\$US/u
    assert_select 'h1', /Su Cat(.|&#?\w+;)logo de Pragmatic/u
    assert_select 'input[type=submit][value$=dir al Carrito]'
  end

  section 15.2, "Task I2: i18n for the cart" do
    assert_select 'td', /1(.|&#?\w+;)/u
    assert_select 'td', 'CoffeeScript'
  end

  section 15.3, "Task I3: i18n for the order page" do
    # ticket 5971,
    #   :title =>  "labels don't treat I18n name_html as html_safe",
    #   :match => /Direcci&amp;oacute;n/
    # ticket 5971,
    #   :title =>  "labels don't treat I18n name_html as html_safe",
    #   :match => /&lt;span class=&quot;translation_missing&quot;&gt;/

    assert_select 'input[type=submit][value$=Comprar]'
    assert_select '#error_explanation',
      /5 errores han impedido que este pedido se guarde/
    assert_select '#notice', 'Gracias por su pedido'
  end

  section 15.4, "Task I4: Add a locale switcher" do
    ticket 4786,
      :title =>  "render with a partial in rjs fails ",
      :match => /Template::Error: Missing partial.* with.* :formats=&gt;\[:js\]/

    assert_select 'option[value=es]'
    assert_select 'h1', 'Your Pragmatic Catalog'
    assert_select 'h1', /Su Cat(.|&#?\w+;)logo de Pragmatic/u
    assert_select 'pre', 
      /1?\d tests, [23]\d assertions, 0 failures, 0 errors/,
      '1?\d tests, [23]\d assertions, 0 failures, 0 errors'
    assert_select 'pre', 
      /46 tests, [78]\d assertions, 0 failures, 0 errors/,
      '46 tests, [78]\d assertions, 0 failures, 0 errors'
    assert_select 'pre', 
      /3 tests, \d+ assertions, 0 failures, 0 errors/,
      '3 tests, \d+ assertions, 0 failures, 0 errors'
  end

  section 16, "Deployment" do
    assert_select '.stderr', /depot_production already exists/
    assert_select '.stdout', /assume_migrated_upto_version/
    assert_select '.stdout', '[done] capified!'
    assert_select '.stdout', /depot\/log\/production.log/
  end

  section 18, "Finding Your Way Around" do
    assert_select '.stdout', 'Current version: 20110711000009'
  end

  section 20.1, "Testing Routing" do
    assert_select 'pre', 
      /1\d tests, 4\d assertions, 0 failures, 0 errors/,
      '1\d tests, 4\d assertions, 0 failures, 0 errors'
  end

  section 21.1, "Views" do
    assert_select '.stdout', /&lt;price currency="USD"&gt;49.5&lt;\/price&gt;/
    assert_select '.stdout', /"1 minute"/
    assert_select '.stdout', /"half a minute"/
    assert_select '.stdout', /"CAN\$235"/
    assert_select '.stdout', /"66\.667%"/
    assert_select '.stdout', /"66\.7%"/
    assert_select '.stdout', /"212-555-1212"/
    assert_select '.stdout', /"\(212\) 555 1212"/
    assert_select '.stdout', /"12,345,678"/
    assert_select '.stdout', /"12_345_678"/
    assert_select '.stdout', /"16.67"/
  end

  section '22', 'Caching' do
    assert_select '.stdout', /304 Not Modified/
    assert_select '.stdout', /Etag:/i
    assert_select '.stdout', /Cache-Control: max-age=\d+, public/i
    unless File.exist? "#{$WORK}/depot/public/images"
      assert_select '.stdout', /X-Rack-Cache: fresh/
    end

    # not exactly a good test of the function in question...
    # assert_select "p", 'There are a total of 4 articles.'
  end

  section 24.3, "Active Resources" do
    # assert_select '.stdout', /ActiveResource::Redirection: Failed.* 302/
    assert_select '.stdout', '36.0'
    assert_select '.stdout', '=&gt; true'
    assert_select '.price', '$31.00'
    assert_select 'p', /31\.0/
    assert_select '.stdout', '=&gt; "Dave Thomas"'
    assert_select '.stdout', /NoMethodError: undefined method `line_items'/
    if File.exist? "#{$WORK}/depot/public/images"
      assert_select '.stdout', /&lt;id type="integer"&gt;\d+&lt;\/id&gt;/
    else
      assert_select '.body', /[{,]"id":\d+[,}]/
    end
    assert_select '.stdout', /"product_id"=&gt;3/
    assert_select '.stdout', /=&gt; 39.6/
  end

  section 25.1, 'rack' do
    assert_select 'p', '43.75'
    assert_select 'h2', 'Programming Ruby 1.9'
  end

  section 25.2, 'rake' do
    assert_select '.stderr', /^mkdir -p .*db\/backup$/
    assert_select '.stderr', 
      /^sqlite3 .*?db\/production\.db \.dump &gt; .*\/production.backup$/
  end

  section 26.1, 'Active Merchant' do
    assert_select '.stdout', 'Is 4111111111111111 valid?  false'
  end

  section 26.2, 'Asset Packager' do
    next unless File.exist? 'public/images'
    assert_select '.stdout', 'config/asset_packages.yml example file created!'
    assert_select '.stdout', '  - depot'
    assert_select '.stdout', 
      /Created .*\/public\/javascripts\/base_packaged\.js/
  end

  section 26.3, 'HAML' do
    assert_select 'h1', 'Your Pragmatic Catalog'
    assert_select 'span.price', '$49.50'
  end

  section 26.4, 'JQuery' do
    next unless File.exist? 'public/images'
    assert_select '.logger', /force\s+public\/javascripts\/rails\.js/
    assert_select '.stdout', /No RJS statement/
    assert_select '.stdout', /4\d tests, 7\d assertions, 0 failures, 0 errors/
  end
end
