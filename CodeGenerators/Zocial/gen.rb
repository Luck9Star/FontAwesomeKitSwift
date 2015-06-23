require '../CodeGenerator.rb'

codesName = {}


# .zocial.macstore:before {content: "^";}
File.read("zocial.css").each_line do |line|
  name = ''
  line.gsub(/(?<=\.zocial\.).*(?=:before)/i) { |match| name = match }
  nameParts = name.split('-')
  nameParts = nameParts.each_with_index.map do |p, i|
    p = p.capitalize
  end
  name = nameParts.join
  # names.push name

  code = ''
  line.gsub(/".*"/) { |match| code = match[1..(match.length-2)] }
  code = code.gsub(/\\(\w{4})/, "\\u{\\1}")
  # codes.push code
  # code = "\\u{#{code}}"
  if codesName.has_key?(code)
    codesName[code].push name
  else
    codesName[code] = [name]
  end
end

generator = CodeGenerator.new('Zocial', codesName)
generator.generate
