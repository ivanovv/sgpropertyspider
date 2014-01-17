module UrlToSymbol

  def pseudoname_to_realname(pseudo)
    return case pseudo
             when 'guru'
               'Propertyguru'
             when 'iproperty'
               'Iproperty'
             when 'stproperty'
               'Stproperty'
           end
  end
end