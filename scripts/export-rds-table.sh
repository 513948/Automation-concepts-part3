# Script thats makes a bulk export of a table from an RDS instance to an S3 bucket
# bcp database_name.schema_name.table_name out data_file -n -S aws_rds_sql_endpoint -U username -P password
# bcp world.dbo.city out C:\Users\JohnDoe\city.dat -n -S sql-jdoe.1234abcd.us-west-2.rds.amazonaws.com,1433 -U JohnDoe -P ClearTextPassword
# bcp world.dbo.city out /mnt/c/assignment1_CA-v1/Cloudshirtlogs.dat -n -S cloudshirt-db-instance.calfb8ypi1lz.us-east-1.rds.amazonaws.com,1433 -U TestTest -P TestTest
# sqlcmd -S cloudshirt-db-instance.calfb8ypi1lz.us-east-1.rds.amazonaws.com,1433 -U TestTest -P TestTest -d cloudshirt-db-instance
#!/bin/bash

# Configuration Variables (MODIFY THESE)
DB_SERVER="cloudshirt-db-instance.calfb8ypi1lz.us-east-1.rds.amazonaws.com"
DB_NAME="cloudshirt-db-instance"
DB_USER="TestTest"
DB_PASSWORD="TestTest"

# Export Directory
EXPORT_DIR="/tmp/db_exports"
mkdir -p "$EXPORT_DIR"

# Create timestamp for unique filename
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
EXPORT_FILENAME="${TABLE_NAME}_${TIMESTAMP}.bcp"
EXPORT_PATH="${EXPORT_DIR}/${EXPORT_FILENAME}"

# S3 Bucket Configuration
S3_BUCKET="your-s3-bucket-name"
S3_PATH="database-exports/"

# Log file
LOG_FILE="${EXPORT_DIR}/export_log_${TIMESTAMP}.log"

# Function to log messages
log_message() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# Export Database Table
export_database() {
    log_message "Starting database export for table: $TABLE_NAME"
    
    # BCP Export Command (modify as needed for your specific database)
    bcp "$DB_NAME"."$TABLE_NAME" out "$EXPORT_PATH" \
        -S "$DB_SERVER" \
        -U "$DB_USER" \
        -P "$DB_PASSWORD" \
        -c \
        -t',' \
        || { log_message "Export failed"; exit 1; }
    
    log_message "Export completed successfully"
}

# Compress exported file
compress_export() {
    log_message "Compressing export file"
    gzip "$EXPORT_PATH" || { log_message "Compression failed"; exit 1; }
    EXPORT_PATH="${EXPORT_PATH}.gz"
}

# # Upload to S3
# upload_to_s3() {
#     log_message "Uploading to S3 bucket: $S3_BUCKET"
    
#     # AWS CLI S3 Upload
#     aws s3 cp "$EXPORT_PATH" "s3://$S3_BUCKET/$S3_PATH$EXPORT_FILENAME.gz" \
#         || { log_message "S3 upload failed"; exit 1; }
    
#     log_message "S3 upload completed successfully"
# }

# # Cleanup function
# cleanup() {
#     log_message "Cleaning up temporary files"
#     rm -f "$EXPORT_PATH"
# }

# Main execution
main() {
    log_message "Starting RDS Export and S3 Upload Process"
    
    export_database
    compress_export
    # upload_to_s3
    # cleanup
    
    log_message "Process completed successfully"
}

# Error handling trap
trap 'log_message "Error occurred. Check log file: $LOG_FILE"' ERR

# Run main function
main

log_message "Script execution finished"