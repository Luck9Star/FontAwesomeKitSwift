require '../CodeGenerator.rb'

# names = []
# codes = []
codesName = {}

File.read("ionicons.css").each_line do |line|
  name = ''
  line.gsub(/(?<=ion-).*(?=:before)/i) { |match| name = match }
  nameParts = name.split('-')
  nameParts = nameParts.each_with_index.map do |p, i|
    p = p.capitalize
  end
  name = nameParts.join
  # names.push name

  code = ''
  line.gsub(/".*"/) { |match| code = match[2..(match.length-2)] }
  # codes.push "\\u#{code}"
  code = "\\u{#{code}}"
  if codesName.has_key?(code)
    codesName[code].push name
  else
    codesName[code] = [name]
  end
end

generator = CodeGenerator.new('IonIcons', codesName)
generator.generate
