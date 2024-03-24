# Manages operations on the Rails log file.
class LogManager
    # Path to the Rails log file.
    LOG_FILE_PATH = Rails.root.join('log', 'development.log')

    # Deletes all lines except for the last 10 in the log file.
    #
    # Side Effects:
    #   - Reads the contents of the log file.
    #   - Checks if there are more than 10 lines in the log file.
    #   - If there are more than 10 lines, keeps only the last 10 lines and overwrites the log file.
    #
    # Returns: None.
    def self.keep_last_10_lines
        # Read the contents of the log file
        log_contents = File.readlines(LOG_FILE_PATH)
    
        # Check if there are more than 10 lines in the log file
        return if log_contents.length <= 10
    
        # Keep only the last 10 lines
        last_10_lines = log_contents.last(10)
    
        # Open the log file in write mode and overwrite its contents with the last 10 lines
        File.open(LOG_FILE_PATH, 'w') do |file|
          file.puts(last_10_lines)
        end
    end

end