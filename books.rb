class Book
    attr_accessor :ISBN
    attr_accessor :title
    attr_accessor :author
    attr_accessor :count
    
    def initialize(book_ISBN,book_title,book_author)
        @ISBN = book_ISBN
        @title = book_title
        @author = book_author
        @count = 1 
    end
end
class Inventory
    attr_accessor :books
    def initialize()
        @books=[]
    end
    
    def read_file()
        @books=File.readlines("books.txt")
        return @books
    end

    def write_file
        file=File.open("books.txt","w") do |file|
            @books.each do |book|
            file.puts(book)
            end
        end
    end
    
    def list_books()
        # pp(read_file.readlines)
        puts read_file
    end
    def add_book(book)
        @books=read_file
        existing_book=@books.find_index{|line| line.start_with?("#{book.ISBN},")}
        if existing_book
            isbn, title, author, count = @books[existing_book].chomp.split(',')
            count=count.to_i+1
            @books[existing_book]="#{isbn},#{book.title},#{book.author},#{count}"
            puts "Book already exists"
        else
            book.count=1
            @books << "#{book.ISBN},#{book.title},#{book.author},#{book.count}"
            puts "Book added successfully"
        end
        # puts @books
        File.open("books.txt", "w") do |file|
            @books.each { |book| file.puts(book) }
        end
    end

    def remove_by_isbn(isbn)
        @books=read_file
        # search if array has isbn 
        found_books=@books.select {|book| book.include?(isbn.to_s)}
        # if yes remove 
        if !found_books.empty?
            @books.reject! {|book| book.include?(isbn.to_s)}
            # write array in file 
            write_file
            book_title=found_books.map{|book| book.split(",")[1]}.join(", ")
            puts "Removed #{book_title}"
        else
            puts "Book not found"
        end
    
    end

    def sort_by_isbn()
        readings=read_file
        sortBooks=readings.sort_by do |book|
            book.split(",")[0].to_i
        end
        sortBooks.each { |book| puts book}
    end
    def search_books()
        @books=read_file
        puts "Search by: 1-ISBN 2-title 3-Author"
        option=gets.chomp

        puts "Enter Search Term:"
        term=gets.chomp.downcase

        result= case option
        when "1"
            @books.select{|book| book.split(",")[0].downcase.include?(term)}
        when "2"
            @books.select{|book| book.split(",")[1].downcase.include?(term) }
        when "3"
            @books.select{|book| book.split(",")[2].downcase.include?(term)}
        else
            puts "Invalid Option"
            return
        end
        if result.empty?
            puts "No matching books"
        else
            puts "Search Results"
            result.each {|book| puts book}
        end
    end

end

# book1= Book.new(1011,"IQ","chris")
# book2= Book.new(123,"Pyhton","Aly")
# inv.add_book(book1)
# inv.add_book(book2)
# inv.list_books
# inv.remove_by_isbn(123)

inv=Inventory.new
input=""

until false
    puts "----------------WELCOME-----------------------------"
    puts "choose One of these options
    1- list all books (NOT sorted)
    2- add new book
    3- remove new book
    4- sort by ISBN
    5- Seach Book
    6- Exit"

    input = gets.chomp
    case input
        when "1"
            inv.list_books
        when "2"
            puts "Enter book details"
            puts "Book ISBN:"
            ISBN=gets.chomp
            puts "Book Title"
            title=gets.chomp
            puts "Author Name"
            author=gets.chomp
            book=Book.new(ISBN,title,author)
            inv.add_book(book)
        when "3" 
            puts "Enter book ISBN to Remove"
            remove_isbn=gets.chomp
            inv.remove_by_isbn(remove_isbn)
        when "4"
            puts "sorted by ISBN"
            inv.sort_by_isbn()
        when "5"
            inv.search_books()
        when "6"
            puts "bye bye program"
            break
        else
            puts "Invalid Option try again "
    end
end


