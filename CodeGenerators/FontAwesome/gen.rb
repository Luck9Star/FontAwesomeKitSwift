require '../CodeGenerator.rb'
codesName = {}

File.read("_variables.scss").each_line do |line|
  parts = line.split(' ')
  name = parts[0]
  if name && name.start_with?('$fa-var-')
    name = name['$fa-var-'.length..(name.length) -2]

    nameParts = name.split('-')
    nameParts = nameParts.each_with_index.map do |p, i|
      p = p.capitalize
    end

    name = nameParts.join

    code = parts[1]
    code = code[2..5]
    code = "\\u{#{code}}"
    if codesName.has_key?(code)
      codesName[code].push name
    else
      codesName[code] = [name]
    end
  end
end

generator = CodeGenerator.new('FontAwesome', codesName)
generator.generate
