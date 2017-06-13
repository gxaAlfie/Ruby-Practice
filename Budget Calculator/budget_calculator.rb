require 'json'

class ExpenseList
  attr_accessor :expenses

  def initialize(list_of_expenses = {})
    @expenses = if list_of_expenses.empty?
      []
    else
      list_of_expenses.inject([]) do |output, (type, values)|
        values.each { |cost| output << Expense.new(type, cost) }
        output
      end
    end
  end

  def add_expense(type, cost)
    if matching_key = Expense::TYPES.key(type)
      @expenses << Expense.new(matching_key, cost)
      puts "\n#{matching_key.capitalize} expense worth #{@expenses.last.cost} added\n"
    else
      puts "\nExpense Type not Found\n"
    end
  end

  def calculate_expenses(specific_expense_type=nil)
    selected_expenses = specific_expense_type.nil? ? expenses : expenses.select{|expense| specific_expense_type == expense.type}
    expense_total = if computed_expenses = selected_expenses.map(&:cost).inject(:+)
      computed_expenses
    else
      0
    end
  end

  def list_expenses
    Expense::TYPES.keys.each { |expense_type| puts "#{expense_type.to_s.capitalize} expenses: #{calculate_expenses(expense_type)}\n" }
    puts "Total expenses: #{calculate_expenses}\n"
  end
end

class Expense
  TYPES = {allowance: 1, utilities: 2, others: 3}
  attr_accessor :type
  attr_accessor :cost

  def initialize(type, cost = 0)
    @type = type
    @cost = cost
  end
end

class Budget
  attr_accessor :stipend

  def initialize(stipend)
    @stipend = stipend || 0
  end

  def set_stipend(new_stipend)
    if check_for_negative(new_stipend)
      puts "\nCannot set to negative budget\n"
    else
      initialize(new_stipend)
    end
  end

  def increase_budget(increased_amount)
    @stipend+=increased_amount if !(check_for_negative(increased_amount))
  end

  def check_for_negative(amount)
    amount < 0
  end

  def decrease_budget(decreased_amount)
    if !(stipend.zero? || check_for_negative(stipend - decreased_amount))
      @stipend-=decreased_amount
    else
      puts "\nDecreasing budget results in number less than 0\n"
    end
  end
end

class BudgetCalculator
  ACTIONS       = {"set budget" => 1, "increase budget" => 2, "decrease budget" => 3, "add expense" => 4, "list expenses" => 5, "exit" => 6}
  attr_accessor :budget
  attr_accessor :expense_list

  def initialize
    action_title("BUDGET CALCULATOR")
    gathered_data  = gather_records
    @budget        = Budget.new(gathered_data.delete(:budget))
    @expense_list  = gathered_data.empty? ? ExpenseList.new : ExpenseList.new(gathered_data)
  end

  def action_title(action)
    puts "\n---------------#{action}---------------\n\n"
  end

  def add_expense
    expense_options
    expense_type = get_option
    print "Cost: "
    expense_cost = get_parsed_money
    @expense_list.add_expense(expense_type, expense_cost)
  end

  def denote_options(options_list)
    options_list.each { |key, value| puts "[#{value}] #{key.capitalize}\n" }
    print "OPTION: "
  end

  def decrease_budget
    print "Amount to Decrease: "
    @budget.decrease_budget(get_parsed_money)
  end

  def display_remaining_budget
    unless @budget.stipend == 0
      if @budget.stipend > @expense_list.calculate_expenses
        puts "Remaining Budget: #{@budget.stipend - @expense_list.calculate_expenses}\n"
      elsif @budget.stipend == @expense_list.calculate_expenses
        puts "You are now out of budget.\n"
      else
        puts "You have exceeded budget by: #{@expense_list.calculate_expenses - @budget.stipend}\n"
      end
    end
  end

  def expense_options
    action_title("EXPENSE TYPE")
    denote_options(Expense::TYPES)
  end

  def gather_records
    if File.exist?('calculator.txt')
      array_of_lines = []
      action_title('RETRIEVING DATA FROM FILE')
      details = File.read('calculator.txt').split(/\n/).map { |line| line.split(' - ') }
      action_title('FINISHED')
      hash_data = details.group_by { |grouping| grouping.first.to_sym }.map {|key, value| [key, value.map { |val| JSON.parse(val.flatten.last) }]}.to_h
      hash_data.each { |key, value| hash_data[key] = value.first if key.to_s == 'budget' } unless hash_data.empty?
      hash_data
    end
  end

  def get_option
    option = gets.chomp.to_i
  end

  def increase_budget
    print "Amount to Increase: "
    @budget.increase_budget(get_parsed_money)
  end

  def list_expenses
    action_title("LIST OF EXPENSES")
    @expense_list.list_expenses
  end

  def options
    action_title("OPTIONS")
    display_remaining_budget
    denote_options(ACTIONS)
    get_option
  end

  def get_parsed_money
    parsed_money = gets.chomp.to_f.round(2)
  end

  def save_records
    if File.exist?('calculator.txt')
      action_title('SAVING')
      File.open('calculator.txt', 'w') do |line|
        line.puts "budget - #{@budget.stipend}"
        @expense_list.expenses.each { |expense| line.puts "#{expense.type} - #{expense.cost}" }
      end
      action_title('STOPPING')
    end
  end

  def set_budget
    print "Set Budget: "
    new_budget = get_parsed_money
    @budget.set_stipend(new_budget)
    puts "\nUpdated Budget: #{@budget.stipend}\n"
  end
end

calculator = BudgetCalculator.new
actions    = BudgetCalculator::ACTIONS
loop do
  case calculator.options
  when actions["set budget"]
    calculator.set_budget
  when actions["increase budget"]
    calculator.increase_budget
  when actions["decrease budget"]
    calculator.decrease_budget
  when actions["add expense"]
    calculator.add_expense
  when actions["list expenses"]
    calculator.list_expenses
  when actions["exit"]
    calculator.save_records
    break
  else
    puts "\n---------------INVALID INPUT---------------\n"
  end
end
