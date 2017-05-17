#TLV
def parser(code,length)
#-----------------------------------------------  
  i = 0
  flag = 0
 
  while i < length
    tag = code[i]
    if ( tag & 0x20 ) == 0x20
      flag = 1
    end 

    i += 1
    if (tag  & 0x1F) == 0x1F 
       loop do
          tag = (tag << 8)
          tag = tag | code[i] 
          i += 1
          #flag = 1 
          break if (tag & 0x80 ) == 0
       end
    end

    print "[tag] = #{tag.to_s(16).upcase}" 
    puts " "

    #----------------------------------------------------
    len = code[i]
    i+=1
    if (len & 0x80) == 0x80 
        if (len & 0x81) == 0x81 
           len = code[i]
            i += 1 
          end
        elsif (len & 0x82) == 0x82 
            len = code[i]
            i+=1
            len = (len << 8) | code[i]
            i+=1
            break
    end

    print "[length] = #{len.to_s(16)}"
    puts " " 

    #----------------------------------------------------
    value = code.slice(i, len)

    print value.pack('C*').unpack('H*').first.upcase.scan(/../)
    puts " "

    i = i + len
    if (flag > 0) 
      parser(value, len)  
    end
  end  
end
#----------------------------------------------------
puts "Enter code: "
data = gets.chomp
data.gsub!(/\s+/, '')
code = data.scan(/../)

i = 0
code.each do
  code[i] = code[i].to_i(16)
  i +=1
end
parser(code,code.length)