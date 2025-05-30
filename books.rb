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
        book.count=1
        @books << "#{book.ISBN},#{book.title},#{book.author},#{book.count}"
        # puts @books
        File.open("books.txt", "a") do |file|
            @books.each { |book| file.puts(book) }
        end
        puts "Book added successfully"
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

end

# book1= Book.new(1011,"IQ","chris")
# book2= Book.new(123,"Pyhton","Aly")
# inv.add_book(book1)
# inv.add_book(book2)
# inv.list_books
# inv.remove_by_isbn(123)

puts "----------------WELCOME-----------------------------"
puts "choose One of these options
 1- list all books 
 2- add new book
 3- remove new book"
inv=Inventory.new

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
else
    exit()
end



