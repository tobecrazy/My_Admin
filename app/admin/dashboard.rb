# frozen_string_literal: true

require "json"

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { "Dashboard v3" }

  content title: proc { "Dashboard v3" } do
    data = JSON.parse(File.read(Rails.root.join("db/mock/dashboard_v3.json")))

    polar = lambda do |cx, cy, radius, angle_deg|
      rad = (angle_deg - 90) * Math::PI / 180.0
      [cx + (radius * Math.cos(rad)), cy + (radius * Math.sin(rad))]
    end

    pie_wedge = lambda do |cx, cy, radius, start_deg, end_deg|
      sx, sy = polar.call(cx, cy, radius, start_deg)
      ex, ey = polar.call(cx, cy, radius, end_deg)
      large_arc = (end_deg - start_deg) > 180 ? 1 : 0
      format(
        "M %.2f %.2f L %.2f %.2f A %.2f %.2f 0 %d 1 %.2f %.2f Z",
        cx, cy, sx, sy, radius, radius, large_arc, ex, ey
      )
    end

    columns class: "dashboard-v3-row" do
      column min_width: "48%", max_width: "48%" do
        panel data.dig("online_store_visitors", "title"), class: "dashboard-v3-panel" do
          visitors = data.fetch("online_store_visitors")
          summary = visitors.fetch("summary")

          div class: "dashboard-v3-header" do
            a visitors.fetch("report_label"), href: helpers.admin_reports_path, class: "dashboard-v3-report-link"
          end

          div class: "dashboard-v3-metric" do
            h3 summary.fetch("value")
            span summary.fetch("label")
          end

          div class: "dashboard-v3-trend up" do
            strong summary.fetch("trend")
            span summary.fetch("trend_note")
          end

          div class: "dashboard-v3-chart-lines" do
            labels = visitors.dig("series", "labels")
            this_week = visitors.dig("series", "this_week")
            last_week = visitors.dig("series", "last_week")
            max_value = [this_week.max, last_week.max].max.to_f
            width = 560.0
            height = 180.0

            series_to_points = lambda do |series|
              series.each_with_index.map do |value, idx|
                x = labels.size == 1 ? 0 : (idx * (width / (labels.size - 1)))
                y = height - ((value / max_value) * height)
                "#{x.round(2)},#{y.round(2)}"
              end.join(" ")
            end

            line_svg = helpers.content_tag(:svg, class: "dashboard-v3-line-svg", viewBox: "0 0 #{width.to_i} #{height.to_i}") do
              helpers.tag.polyline(points: series_to_points.call(last_week), class: "line last-week") +
                helpers.tag.polyline(points: series_to_points.call(this_week), class: "line this-week")
            end
            text_node line_svg

            ul class: "dashboard-v3-axis-labels" do
              labels.each do |label|
                li label
              end
            end
          end
        end
      end

      column min_width: "48%", max_width: "48%" do
        panel data.dig("sales", "title"), class: "dashboard-v3-panel" do
          sales = data.fetch("sales")
          summary = sales.fetch("summary")

          div class: "dashboard-v3-header" do
            a sales.fetch("report_label"), href: helpers.admin_reports_path, class: "dashboard-v3-report-link"
          end

          div class: "dashboard-v3-metric" do
            h3 summary.fetch("value")
            span summary.fetch("label")
          end

          div class: "dashboard-v3-trend up" do
            strong summary.fetch("trend")
            span summary.fetch("trend_note")
          end

          div class: "dashboard-v3-chart-bars" do
            labels = sales.dig("series", "labels")
            this_year = sales.dig("series", "this_year")
            last_year = sales.dig("series", "last_year")
            max_value = [this_year.max, last_year.max].max.to_f
            bar_w = 18
            gap = 12
            group_gap = 20
            chart_h = 180
            chart_w = (labels.size * ((bar_w * 2) + gap + group_gap)) - group_gap

            bar_svg = helpers.content_tag(:svg, class: "dashboard-v3-bar-svg", viewBox: "0 0 #{chart_w} #{chart_h}") do
              bars = +""
              labels.each_with_index do |_label, idx|
                group_x = idx * ((bar_w * 2) + gap + group_gap)
                ty = this_year[idx]
                ly = last_year[idx]
                ty_h = ((ty / max_value) * chart_h).round(2)
                ly_h = ((ly / max_value) * chart_h).round(2)

                bars << helpers.tag.rect(
                  x: group_x, y: (chart_h - ty_h), width: bar_w, height: ty_h, rx: 3, ry: 3, class: "bar this-year"
                )
                bars << helpers.tag.rect(
                  x: (group_x + bar_w + gap), y: (chart_h - ly_h), width: bar_w, height: ly_h, rx: 3, ry: 3, class: "bar last-year"
                )
              end
              bars.html_safe
            end
            text_node bar_svg

            ul class: "dashboard-v3-axis-labels" do
              labels.each do |label|
                li label
              end
            end
          end
        end
      end
    end

    columns class: "dashboard-v3-row" do
      column min_width: "48%", max_width: "48%" do
        panel "Products", class: "dashboard-v3-panel" do
          table_for data.fetch("products"), class: "dashboard-v3-table" do
            column("Product") { |product| product.fetch("name") }
            column("Price") { |product| product.fetch("price") }
            column("Sales") do |product|
              status = product.fetch("trend_type") == "up" ? "up" : "down"
              span product.fetch("trend"), class: "trend #{status}"
              text_node " #{product.fetch("sales")}"
            end
          end
        end
      end

      column min_width: "48%", max_width: "48%" do
        panel data.dig("pie_chart", "title") || "Pie Chart", class: "dashboard-v3-panel dashboard-v3-pie-panel" do
          pie = data.fetch("pie_chart")
          segments = pie.fetch("segments")
          total = segments.sum { |segment| segment.fetch("value").to_f }
          angle = 0.0

          div class: "dashboard-v3-pie-legend" do
            segments.each do |segment|
              span class: "legend-item" do
                legend_color = helpers.content_tag(:svg, class: "legend-color-svg", viewBox: "0 0 28 10") do
                  helpers.tag.rect(x: 0, y: 0, width: 28, height: 10, rx: 1, ry: 1, fill: segment.fetch("color"))
                end
                text_node legend_color
                span segment.fetch("label"), class: "legend-label"
              end
            end
          end

          div class: "dashboard-v3-pie-wrap" do
            pie_svg = helpers.content_tag(:svg, class: "dashboard-v3-pie-svg", viewBox: "0 0 220 220") do
              slices = +""
              segments.each do |segment|
                delta = (segment.fetch("value").to_f / total) * 360.0
                percent = ((segment.fetch("value").to_f / total) * 100).round(1)
                tooltip = "#{segment.fetch("label")}: #{segment.fetch("value")} (#{percent}%)"
                slices << helpers.content_tag(
                  :path,
                  helpers.tag.title(tooltip),
                  d: pie_wedge.call(110, 110, 100, angle, angle + delta),
                  fill: segment.fetch("color"),
                  stroke: "#fff",
                  "stroke-width": 2,
                  "stroke-linejoin": "round",
                  class: "pie-slice"
                )
                angle += delta
              end
              slices.html_safe
            end
            text_node pie_svg
          end
        end
      end
    end
  end
end
