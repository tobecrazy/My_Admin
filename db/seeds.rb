# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
admin = AdminUser.find_or_initialize_by(email: "admin@example.com")
admin.password = "password"
admin.password_confirmation = "password"
admin.save!

reports_path = Rails.root.join("db/mock/reports.json")
if File.exist?(reports_path)
  reports = JSON.parse(File.read(reports_path)).fetch("reports", [])
  reports.each do |attrs|
    report = Report.find_or_initialize_by(row_index: attrs.fetch("index"))
    report.item_name = attrs["item_name"]
    report.start_date = attrs["start_date"]
    report.status = attrs["status"]
    report.comments = attrs["comments"]
    report.save!
  end
end
