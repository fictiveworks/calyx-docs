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
        <symbol id="petals">
          {petals}
        </symbol>
        <symbol id="corolla">
          <use xlink:href="#petals" />
          <use xlink:href="#petals" transform="rotate(22.5 200 200)" />
          <use xlink:href="#petals" transform="rotate(45 200 200)" />
          <use xlink:href="#petals" transform="rotate(-22.5 200 200)" />
        </symbol>
      </defs>
      <use xlink:href="#corolla" fill="{$swatch_fill}" stroke="{swatch_fill}" stroke-width="{stroke_width}"/>
      <use xlink:href="#corolla" fill="{$swatch_fill}" stroke="{swatch_fill}" stroke-width="{stroke_width}" transform="scale(0.80 0.80) translate(50 50)" />
      <use xlink:href="#corolla" fill="{$swatch_fill}" stroke="{swatch_fill}" stroke-width="{stroke_width}" transform="scale(0.40 0.40) translate(300 300)" />
    </svg>
  '
  petals '{petal_north}{petal_south}{petal_east}{petal_west}'

  swatch_fill '#218764', '#1BDE81', '#76FABB'
  swatch_stroke '#2F5E52'

  petal_north '<ellipse cx="200" cy="120" rx="{@rx}" ry="80" />'
  petal_south '<ellipse cx="200" cy="280" rx="{@rx}" ry="80" />'
  petal_east '<ellipse cx="280" cy="200" rx="80" ry="{@rx}" />'
  petal_west '<ellipse cx="120" cy="200" rx="80" ry="{@rx}" />'

  stroke_width :@stroke_width_m, :stroke_width_r

  stroke_width_r *(4..18).to_a
  stroke_width_m *(4..18).to_a
  rx *(18..44).map { |step| "#{step}" }
end

body = "<body>"
21.times do
  logo = Logo.new
  body << logo.generate
end
body << "</body>"

File.write("logo-marks.html", body)
