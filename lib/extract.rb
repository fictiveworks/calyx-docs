require 'nokogiri'

doc = Nokogiri::HTML(File.open('api/index.html'))
content = doc.css('#content')

output = [
  '---',
  'title: Calyx API',
  'layout: page',
  '---',
  content.to_s
]

File.write('docs/api.html', output.join("\n"))
