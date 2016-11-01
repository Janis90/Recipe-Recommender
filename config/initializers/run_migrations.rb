Rails.logger.info "Running migration"

ActiveRecord::Migrator.migrate(Rails.root.join("db/migrate"),nil)
