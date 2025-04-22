# Set project root directory
PROJECT_ROOT=$(dirname "$(dirname "$(readlink -f "$0")")")
LOGS_DIR="$PROJECT_ROOT/logs"
HEALTH_LOG="$LOGS_DIR/health.log"

# Make sure logs directory exists
mkdir -p "$LOGS_DIR"

# Health check endpoint
HEALTH_ENDPOINT="http://localhost:5000/health"
MAX_RETRIES=3
RETRY_DELAY=2

echo "$(date): Running health check..." | tee -a "$HEALTH_LOG"

# Function to check if the application is running
check_health() {
    for i in $(seq 1 $MAX_RETRIES); do
        response=$(curl -s -o /dev/null -w "%{http_code}" $HEALTH_ENDPOINT)
        
        if [ "$response" = "200" ]; then
            echo "$(date): Health check passed! Application is running." | tee -a "$HEALTH_LOG"
            return 0
        else
            echo "$(date): Health check attempt $i failed with status $response. Retrying in $RETRY_DELAY seconds..." | tee -a "$HEALTH_LOG"
            sleep $RETRY_DELAY
        fi
    done
    
    echo "$(date): Health check failed after $MAX_RETRIES attempts. Application might be down!" | tee -a "$HEALTH_LOG"
    return 1
}

# Run the health check
if check_health; then
    exit 0
else
    # Optionally, you can trigger automatic rollback if health check fails
    # Uncomment the following line to enable auto-rollback
    # $PROJECT_ROOT/scripts/rollback.sh
    
    # For now, we'll just exit with error code
    exit 1
fi