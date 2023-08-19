require 'sqlite3'
require 'active_record'
require 'byebug'


ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'customers.sqlite3')
# Show queries in the console.
# Comment this line to turn off seeing the raw SQL queries.
ActiveRecord::Base.logger = Logger.new(STDOUT)

class Customer < ActiveRecord::Base
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.

  # 1) ActiveRecord practice to find using .where: anyone with first name Candice
  def self.any_candice
    Customer.where(first: "Candice")
  end

  # 2) ActiveRecord practice to find using .where: with valid email (email addr contains "@") (HINT: look up SQL LIKE operator)
  def self.with_valid_email
    Customer.where("email LIKE ?", "%@%")
  end

  # 3) ActiveRecord practice to find using .where: with .org emails
  def self.with_dot_org_email
    Customer.where("email LIKE ?", "%.org%")
  end

  # 4) ActiveRecord practice to find using .where: with invalid but nonblank email (does not contain "@")
  def self.with_invalid_email
    Customer.where("email NOT LIKE ?", "%@%")
  end

  # 5) ActiveRecord practice to find using .where: with blank email
  def self.with_blank_email
    Customer.where(email: nil)
  end

  # 6) ActiveRecord practice to find using .where: born before 1 Jan 1980
  def self.born_before_1980
    Customer.where("birthdate < ?", Date.new(1980,1,1))
  end

  # 7) ActiveRecord practice to find using .where: with valid email AND born before 1/1/1980
  def self.with_valid_email_and_born_before_1980
    Customer.where(
    "email LIKE ? AND DATE( birthdate ) < DATE( ? )",
    "%@%", "1980-01-01"
    )
  end

  # 8) ActiveRecord practice to find using .where: with last names starting with "B", sorted by birthdate
  def self.last_names_starting_with_b
    Customer.where("last LIKE ?", "B%").order(birthdate: :asc)
  end
  
  # 9) ActiveRecord practice to find without needing .where 20 youngest customers, in any order (hint: lookup ActiveRecord `order` and `limit`)
  def self.twenty_youngest
    Customer.order(birthdate: :desc).limit(20)
  end

  # 10) ActiveRecord practice to update the birthdate of Gussie Murray to February 8,2004 (HINT: lookup `Time.parse`)
  def self.update_gussie_murray_birthdate
    Customer.find_by(first: "Gussie", last: "Murray")
      .update(birthdate: Time.parse("February 8,2004"))
  end

  # 11) ActiveRecord practice to update all invalid emails to be blank
  def self.change_all_invalid_emails_to_blank
    Customer.where.not("email LIKE ?", "%@%")
      .update_all(email: "")
  end

  # 12) ActiveRecord practice to update database by deleting customer Meggie Herman
  def self.delete_meggie_herman
    Customer.find_by(first: "Meggie", last: "Herman").destroy
  end

  # 13) ActiveRecord practice to update database by deleting all customers born on or before 31 Dec 1977
  def self.delete_everyone_born_before_1978
    Customer.destroy_by("birthdate < ?",Date.new(1978,1,1))
  end

end
