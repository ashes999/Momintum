json.array!(@canvas_sections) do |canvas_section|
  json.extract! canvas_section, :id, :spark_id, :name, :x, :y, :width, :height
  json.url canvas_section_url(canvas_section, format: :json)
end
