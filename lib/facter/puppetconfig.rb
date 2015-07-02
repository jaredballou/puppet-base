    puppetconfig_array = Facter::Core::Execution.exec('puppet config print | sort -u')
    puppetconfig_hash = {}

    puppetconfig_array.each_line.each_with_index do |line, index|
      key,value = line.strip.split(/[\s]*=[\s]*/)
      puppetconfig_hash[key] = value
    end
    puppetconfig_hash.keys.sort.each do |k|
      Facter.add("puppetconfig_" + k) do
        setcode do
          puppetconfig_hash[k]
        end
      end
    end
