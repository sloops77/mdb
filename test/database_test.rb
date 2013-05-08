require "test_helper"

class MdbTest < ActiveSupport::TestCase
  
  
  { "Access 2000" => "Example2000.mdb",
    "Acesss 2003" => "Example2003.mdb" }.each do |format, file|
    path = "#{File.dirname(__FILE__)}/data/#{file}"
    
    test "should identify three tables in #{file} (#{format})" do
      database = Mdb.open(path)
      assert_equal %w{Actors EmptyTable Movies}, database.tables.sort
    end
    
    test "should find all the rows in each table (#{format})" do
      database = Mdb.open(path)
      
      expected_counts = {
        :Actors => 4,
        :Movies => 7 }
      expected_counts.each do |table, expected_count|
        assert_equal expected_count, database[table].count, "The count of '#{table}' is off"
      end
    end
  end
  
  
  
  test "should raise an exception when instatiated with a missing database" do
    assert_raises(Mdb::FileDoesNotExistError) do
      Mdb.open "#{File.dirname(__FILE__)}/data/nope.mdb"
    end
  end
  
  test "should raise an exception if a table is not found" do
    database = Mdb.open "#{File.dirname(__FILE__)}/data/Example2000.mdb"
    assert_raises(Mdb::TableDoesNotExistError) do
      database.read :Villains
    end
  end
  
  test "should return an empty array if a table is empty" do
    database = Mdb.open "#{File.dirname(__FILE__)}/data/Example2000.mdb"
    assert_equal [], database.read(:EmptyTable)
  end
  
  
  
end