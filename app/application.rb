class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = []

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    puts req.path
    puts req.params
    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    elsif req.path.match(/cart/)
      resp.write "Your cart is empty" if @@cart.empty?
      resp.write @@cart.join("\n")
    elsif req.path.match(/add/)
      item_req = req.params["item"]
      if @@items.include? item_req
        @@cart << item_req
        resp.write "added #{item_req} to your cart.\n"
        resp.write "Your cart now contains #{@@cart.join("\n")}."
      else
        resp.write "We don't have that item."
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
