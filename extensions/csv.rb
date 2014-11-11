class CSV
  def self.array_of_hashes_to_csv(path, array_of_hashes)
    raise "Must pass in array!" if array_of_hashes.class != Array
    array_of_hashes.collect{|r| raise "All elements must be hashes in the array" if Hash != r.class}
    keys = array_of_hashes.collect(&:keys).flatten.uniq
    csv = CSV.open(path, "w")
    csv << keys
    array_of_hashes.each do |row|
      csv << keys.collect{|k| row[k]}
    end
    csv.close
  end
end