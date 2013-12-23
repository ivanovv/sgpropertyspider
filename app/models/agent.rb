class Agent < ActiveRecord::Base


  def self.csv_header
    CSV::Row.new(
        [:name, :company, :position, :phone, :fax, :email, :cea_lic],
        ['Name', 'Company', 'Position', 'Phone', 'Fax', 'Email', 'License'],
        true
    )
  end

  def clear_phone_number phone_number
    return nil unless phone_number
    matches = phone_number.to_s.gsub(/\s/, '').match(/\d\d(\d{8,8})/)
    return phone_number if !matches || matches.count == 0
    local_number = matches.first
    %w(or fax).each do |search_string|
      local_number = "#{search_string} #{local_number}" if phone_number.include? search_string
    end
    local_number
  end

  def to_csv_row

    processed_numbers = []
    [phone, fax].each_with_index do |number, index|
      begin
        processed_numbers[index] = clear_phone_number number
      rescue
        puts number
        raise
      end
    end

    CSV::Row.new(
        [:name, :company, :position, :phone, :fax, :email, :cea_lic],
        [name, company, position, processed_numbers[0] || phone, processed_numbers[1] || fax, email, "#{cea_license_number}/#{cea_reg_number}"]
    )
  end

end