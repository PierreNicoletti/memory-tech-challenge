class PagesController < ApplicationController

  def dashboard
    if params[:country]
      selected_country = params[:country] if params[:country] != "All"
    end

    @countries = countries_list
    @number_of_customers = number_of_customers(selected_country)
    @total_revenue = total_revenue(selected_country).fdiv(1_000).round(0)
    @average_revenue = (@total_revenue * 1_000).fdiv(number_of_orders(selected_country)).round(1)
    @months = data_for_graph(selected_country)[0]
    @revenues_per_month = data_for_graph(selected_country)[1]
  end

  private

  # Return the list of customers' countries
  def countries_list
    countries = []
    Customer.all.each do |customer|
      countries << customer.country unless countries.include?(customer.country)
    end
    return countries
  end

  # Return the number of customers for a given country
  def number_of_customers(country)
    country ? Customer.where(country: country).size : Customer.count
  end

  # Return the total revenue in euros for a given country
  def total_revenue(country)
    total_revenue = 0
    if country
      Customer.where(country: country).each do |customer|
        customer.orders.each do |order|
          total_revenue += order.total_amount
        end
      end
    else
      OrderItem.all.each { |item| total_revenue += item.quantity * item.unit_price }
    end
    return total_revenue
  end

  # Return the number of orders for a given country
  def number_of_orders(country)
    count = 0
    if country
      Customer.where(country: country).each do |customer|
        count += customer.orders.size
      end
    else
      count = Order.count
    end
    return count
  end

  # Return an array of 2 arrays, the first array contains the names of the 12 last month
  # of orders, the second contains the corresponding revenues
  def data_for_graph(country)

    orders = []
    if country
      Customer.where(country: country).each { |customer| orders += customer.orders }
    else
      orders = Order.all
    end

    last_order = orders.max_by { |order| order.date }
    last_order_m = last_order.date.month
    last_order_y = last_order.date.year

    months = []
    revenues = []

    (0..11).each do |i|
      month = (last_order_m + i) % 12 + 1
      month_orders = orders.select { |order| order.date.month == month }
      revenues << month_orders.reduce(0) { |sum, o| sum + o.total_amount.fdiv(1_000).round(0)}
      months << Date.new(2020, month, 1).strftime("%B")
    end

    return [months, revenues]
  end
end
