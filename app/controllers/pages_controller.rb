class PagesController < ApplicationController
  def dashboard
    if params[:country]
      selected_country = params[:country]
    end

    @countries = countries_list
    @number_of_customers = number_of_customers(selected_country)
    @total_revenue = total_revenue(selected_country)
  end

  private

  def countries_list
    countries = []
    Customer.all.each do |customer|
      countries << customer.country unless countries.include?(customer.country)
    end
    return countries
  end

  def number_of_customers(country)
    country ? Customer.where(country: country).size : Customer.count
  end

  def total_revenue(country)
    customers = country ? Customer.where(country: country) : Customer.all
    total_revenue = 0
    customers.each do |customer|
      customer.orders.each do |order|
        total_revenue = order.total_amount
      end
    end
    return total_revenue
  end

end
