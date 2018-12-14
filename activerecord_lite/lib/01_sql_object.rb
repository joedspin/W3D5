require_relative 'db_connection'
require 'active_support/inflector'
require 'byebug'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  attr_reader :table_name
  
  def self.columns
    # ...
    @arr_cols ||= DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL
    @arr_cols[0].map { |col| col.to_sym }
  end

  def self.finalize!
    self.columns.each do |col|
      define_method("#{col}") do
        attributes[col]
      end
      define_method("#{col}=") do |value|
        attributes[col] = value
      end
    end
  end

  def self.table_name=(table_name)
    # ...
    @table_name = table_name
  end

  def self.table_name
    # ...
    name_t = name.demodulize
    unless ['Human', 'Person'].include?(name_t)
      name_t.tableize
    else
      return 'people' if name_t == 'Person'
      return 'humans' if name_t == 'Human'
    end
  end

  def self.all
    # ...
    arr_row_hashes = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL
    arr_rows = []
    arr_row_hashes.each do |row_hash|
      arr_rows << row_hash
    end
    parse_all(arr_rows)
  end

  def self.parse_all(results)
    # ...
    results.map { |row| Cat.new(row)}
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    # ...
    params.each do |col, val|
      col_sym = col.to_sym
      raise "unknown attribute '#{col}'" unless self.class.columns.include?(col_sym)
      self.send("#{col_sym}=", val)
    end
  end

  def attributes
    # ...
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
