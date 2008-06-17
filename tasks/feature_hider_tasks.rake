namespace :hider do
  namespace :config do  
    desc "Generate feature config file"
    task :generate do
      plugin_root = File.join(File.dirname(__FILE__), '..')
      target_path = File.join(RAILS_ROOT, 'config', 'features.yml')
      tmplte_path = File.join(plugin_root, 'lib', 'features.yml')
    
      if File.exists?(target_path)
        raise "features.yml already exists: #{target_path}"
      else
        print "Adding features.yml into config/ directory... "
        `cp #{tmplte_path} #{target_path}`
        puts "done."
        puts "Edit #{target_path} to add features."
      end
    end
    
    desc "Delete features config file"
    task :clobber do
      target_path = File.join(RAILS_ROOT, 'config', 'features.yml')
      
      if File.exists?(target_path)            
        print "Are you sure you wish to delete your feature config file? (N/y): "
        confirmed = $stdin.gets.chomp
        if confirmed.match(/^y/i)
          `rm #{target_path}`
          puts "features.yml removed"
        else
          puts 'operation canceled'
        end
      else
        puts "features.yml doesn't exist. aborting..."
      end
    end 
  end
end