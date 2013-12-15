class Agent < ActiveRecord::Base


  def self.csv_header
    CSV::Row.new(
        [:name, :company, :position, :phone, :fax, :email, :cea_lic],
        ['Name', 'Company', 'Position', 'Phone', 'Fax', 'Email', 'License'],
        true
    )
  end

  def to_csv_row
    CSV::Row.new(
        [:name, :company, :position, :phone, :fax, :email, :cea_lic],
        [name, company, position, phone, fax, email, "#{cea_license_number}/#{cea_reg_number}"]
    )
  end

end