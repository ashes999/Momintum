namespace :db do
  desc "Checks for any violations of (non-DB-existant) foreign key constraints"
  task check_foreign_keys: :environment do
    ### Spark.owner_id references User.id
    results = ''
    count = 0
    users = User.all
    Spark.all.each do |s|
      if !s.owner_id.nil? && users.find_by_id(s.owner_id).nil?
        results += "#{s.name} (#{s.id}) references user #{s.owner_id}, " 
        count += 1
      end
    end
    if count > 0
      puts "#{count} sparks reference a non-existing user: #{results}" 
    else
      puts 'Everything looks good.'
    end
  end
end
