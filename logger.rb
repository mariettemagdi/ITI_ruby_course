module Logger
    def log_info(message,type="info")
        timestamp=Time.now
        log="#{timestamp} -- #{type} -- #{message}"
        File.open("apps.logs","a") do |file|
            file.puts(log)
        end
    end

    def log_warning(message,type="warning")
        timestamp=Time.now
        log="#{timestamp} -- #{type} -- #{message}"
        File.open("apps.logs","a") do |file|
            file.puts(log)
        end
    end

    def log_error(message,type="error")
        timestamp=Time.now
        log="#{timestamp} -- #{type} -- #{message}"
        File.open("apps.logs","a") do |file|
            file.puts(log)
        end
    end
end

class User
    attr_accessor :name
    attr_accessor :balance

    def initialize(name,balance)
        @name = name
        @balance = balance
    end
end

class Transaction
    attr_reader :user
    attr_reader :value

    def initialize(user,value)
        @user=user
        @value=value
    end
end

class Bank
    def process_transactions(transactions,callback_proc)
        raise "This Method #{__method__} is abstract, Override"
    end
end

class CBABank < Bank
    include Logger
    def initialize(users)
        @users=users
    end
    def process_transactions(transactions,&callback_proc)
        #check user belong to bank or not 
        transactions.each do |transaction|
            puts transaction.value
            info="Processing Transactions User #{transaction.user.name} transaction with value #{transaction.value}"
            log_info(info)
            if(!@users.include?(transaction.user))
                message="#{transaction.user.name} not exist in the bank"
                error_log="User #{transaction.user.name} transaction with value #{transaction.value} failed with reason #{message}"
                log_error(error_log)
                callback_proc.call("Failure",transaction.user.name,message)
                raise message
            else
                if(transaction.user.balance + transaction.value == 0)
                    transaction.user.balance = transaction.user.balance + transaction.value 
                    message="#{transaction.user.name} has 0 balance"
                    log_warning(message)
                elsif(transaction.user.balance + transaction.value < 0)
                    message = "User #{transaction.user.name} transaction with value #{transaction.value} Failed Not enough balance"
                    log_error(message)
                    callback_proc.call("Failure",transaction.user.name,message)
                else
                    message="User #{transaction.user.name} with value #{transaction.value} succeeded"
                    transaction.user.balance = transaction.user.balance + transaction.value 
                    log_info(message)
                    callback_proc.call("Success",transaction.user.name,message)
                end
            end
        end
    end
end


users = [
  User.new("Ali", 200),
  User.new("Peter", 500),
  User.new("Manda", 100)
]

out_side_bank_users = [
  User.new("Menna", 400),
]

transactions = [
  Transaction.new(users[0], -20),
  Transaction.new(users[0], -30),
  Transaction.new(users[0], -50),
  Transaction.new(users[0], -100),
  Transaction.new(users[0], -100),
  Transaction.new(out_side_bank_users[0], -100)
]

bank=CBABank.new(users)
bank.process_transactions(transactions) do |status,transaction,message|
    puts "Call endpoint for #{status} of User #{transaction} with message #{message}"
end
