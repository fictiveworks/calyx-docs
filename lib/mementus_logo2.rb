$LOAD_PATH.unshift File.expand_path('./lib', __dir__)

require 'calyx'

class Logo < Calyx::Grammar
  start '<?xml version="1.0" encoding="utf-8"?>{document}'
  document '
    <svg width="400px"
         height="400px"
         version="1.1"
         xmlns="http://www.w3.org/2000/svg"
         xmlns:xlink="http://www.w3.org/1999/xlink">
      <defs>
        <symbol id="vertices">
          {vertices}{vertex_centre}
        </symbol>
        <symbol id="subgraph">
          <use xlink:href="#vertices" />
        </symbol>
        <symbol id="cardinal">
          {cardinal_vertices}{vertex_centre}
        </symbol>
        <symbol id="ordinal">
          {ordinal_vertices}{vertex_centre}
        </symbol>
      </defs>
      <use xlink:href="#subgraph" fill="{$swatch_fill}" stroke="{swatch_stroke}" stroke-width="{stroke_width}"/>
      <use xlink:href="#subgraph" fill="{$swatch_fill}" stroke="{swatch_fill}" stroke-width="{stroke_width}" transform="scale(0.80 0.80) translate(50 50) rotate(45 200 200)" />
      <use xlink:href="#subgraph" fill="{$swatch_fill}" stroke="{swatch_fill}" stroke-width="{stroke_width}" transform="scale(0.40 0.40) translate(300 300) rotate(45 200 200)" />
    </svg>
  '
  vertices '{vertex_centre}{vertex_north}{vertex_nw}{vertex_west}{vertex_sw}{vertex_south}{vertex_se}{vertex_east}{vertex_ne}'

  cardinal_vertices '{vertex_north}{vertex_south}{vertex_east}{vertex_west}'

  ordinal_vertices '{vertex_nw}{vertex_ne}{vertex_sw}{vertex_se}'

  swatch_fill '#634242', '#F86868', '#FFB1B1'
  swatch_stroke '#634242'

  vertex_centre '<circle cx="200" cy="200" r="{@rx}" />'

  vertex_north '<circle cx="200" cy="140" r="{@rx}" />'
  vertex_south '<circle cx="200" cy="260" r="{@rx}" />'
  vertex_east '<circle cx="260" cy="200" r="{@rx}" />'
  vertex_west '<circle cx="140" cy="200" r="{@rx}" />'

  vertex_nw '<circle cx="160" cy="160" r="{@rx}" />'
  vertex_sw '<circle cx="160" cy="240" r="{@rx}" />'
  vertex_ne '<circle cx="240" cy="160" r="{@rx}" />'
  vertex_se '<circle cx="240" cy="240" r="{@rx}" />'

  stroke_width :@stroke_width_m, :stroke_width_r

  stroke_width_r *(8..18).to_a
  stroke_width_m *(8..18).to_a
  rx *(12..56).map { |step| "#{step}" }
end

body = "<body>"
21.times do
  logo = Logo.new
  body << logo.generate
end
body << "</body>"

File.write("mem-logo-marks.html", body)
