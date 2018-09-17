class Application

  @@items = ["Apples","Carrots","Pears"]

  @@cart = ["Gucci", "Gang", "gucci", "gang"]

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)   # this is a separate route
      search_term = req.params["q"]
      resp.write handle_search(search_term)

    elsif  req.path.match(/cart/)       # my new "cart" Route
      if @@cart.empty?                  # 19 - 25 new - for "cart"
        resp.write "Your cart is empty"
      else
        @@cart.each do |cart_item|
          resp.write "#{cart_item}\n"
        end
      end
    elsif req.path.match(/add/)
      item_to_add = req.params["item"]   # The HTTP Request - reading teaches on GET Params
      if @@items.include? item_to_add
        @@cart << item_to_add
        resp.write "added #{item_to_add}"
      else
        resp.write "We don't have that item"
      end
    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
end
