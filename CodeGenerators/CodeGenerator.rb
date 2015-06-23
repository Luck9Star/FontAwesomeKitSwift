class CodeGenerator
  # attr_accessor :font_name, :names, :codes
  attr_accessor  :codes_name
  # def initialize(font_name, names, codes)
  #   @font_name = font_name
  #
  #   @names = names.map do |name|
  #     name.gsub(/[^0-9a-z]/i, '')
  #   end
  #
  #   @codes = codes
  #
  #   if names.length != codes.length
  #     raise 'names should be match to codes'
  #   end
  # end

  def initialize(font_name, codes_name)
    @font_name = font_name
    @codes_name = codes_name
  end

  def generate
    # File.open("FAK#{@font_name}.fakgen.h", 'w+') { |f| f.write(generate_header) }
    File.open("#{@font_name}.swift", 'w+') { |f| f.write(generate_implementation) }
  end

#   def generate_header
#     header = "// Generated Code\n"
#     @names.each do |name|
#       header_template = <<EOT
# + (instancetype)#{name}IconWithSize:(CGFloat)size;
# EOT
#       header << header_template;
#     end
#     return header
#   end

  def generate_implementation
    implementation = "// Generated Code\npublic enum #{@font_name}: String {\n"
    @codes_name.each do |key, value|
      implementation_template = ""
      fix = 'A'.upto('Z').to_a
      value.each_with_index do |name, index|
        if index == 0
          implementation_template << <<EOT
  case #{name} = "#{key}"
EOT
        else
          # puts "#{key} #{value.count} #{name} #{index} index "
          implementation_template << <<EOT
  case #{name} = "#{key}#{fix[index-1]}"
EOT
        end
      end
      implementation << implementation_template
    end
    return implementation + '}'
  end

  # def generate_icon_map
  #   icon_map = ''
#     @names.each_with_index do |name, index|
#       icon_map_template = <<EOT
#       @"#{@codes[index]}" : @"#{name}",
# EOT
#       icon_map << icon_map_template
#     end
#     icon_map = <<EOT
# + (NSDictionary *)allIcons {
#     return @{
#         #{icon_map}
#     };
# }
# EOT
#     icon_map = <<EOT
#   }
# EOT
#     return icon_map
#   end

end
