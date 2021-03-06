require 'pry'
require_relative 'person_display'
require_relative 'books_display'

class RentalDisplay
  include Instructions

  attr_accessor :people1, :booky

  def initialize(book, person)
    @rentals = []

    self.people1 = person

    self.booky = book
  end

  def showbooks
    booky.books
  end

  def showpeople
    people1.people
  end

  def create_rental
    puts 'Select a book from the following list by number'
    puts(showbooks.each_with_index.map { |b, i| "#{i + 1}) Title: #{b.title}, Author: #{b.author}" })
    book_index = gets.chomp.to_i

    puts 'Select a person from the following list by number (not id)'
    puts(showpeople.each_with_index.map do |p, i|
           "#{i + 1}) [#{p.class.name}] Name: #{p.name}, ID: #{p.id}, Age: #{p.age}"
         end)
    person_index = gets.chomp.to_i

    date = one_line_prompt('Date [YYYY/MM/DD]: ')
    @rentals.push(Rental.new(date, showpeople[person_index - 1], showbooks[book_index - 1]))
    # binding.pry
    f = File.new('./data/rentals.json', 'w')
    jjn = @rentals.map do |r|
      { Date: r.date, Book: r.book.title, Author: r.book.author, person_index: person_index - 1,
        book_index: book_index - 1 }
    end
    f.puts(JSON.pretty_generate(jjn))
    f.close
    puts 'RENTAL CREATED SUCCESSFULLY'.yellow
  end

  def load_rentals
    return unless File.exist?('./data/rentals.json')

    file = File.read('./data/rentals.json')
    data_hash = JSON.parse(file)
    data_hash.map do |rental|
      @rentals.push(Rental.new(rental['Date'], showpeople[rental['person_index']], showbooks[rental['book_index']]))
    end
  end

  def list_rentals
    id = one_line_prompt('ID of person: ').to_i
    person = showpeople.filter { |p| p.id == id }.first
    puts 'Rentals:'
    puts(person.rentals.map { |r| "Date: #{r.date}, Book #{r.book.title} by #{r.book.author}".yellow })
  end
end
