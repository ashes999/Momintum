namespace :db do
  desc "Checks for any violations of (non-DB-existant) foreign key constraints"
  task check_foreign_keys: :environment do
    
    # TODO: figure out how to generalize this if possible
    ### Spark.owner_id references User.id (below)
    # Activities: check user_id or spark_id appropriately (source/target)
    # Likes: user id and spark id
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
