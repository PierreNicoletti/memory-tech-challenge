class PagesController < ApplicationController

  def dashboard
    if params[:country]
      selected_country = params[:country] if params[:country] != "All"
    end

    @countries = countries_list
    @number_of_customers = number_of_customers(selected_country)
    @total_revenue = total_revenue(selected_country).fdiv(1_000).round(0)
    @average_revenue = (@total_revenue * 1_000).fdiv(number_of_orders(selected_country)).round(1)
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
end
