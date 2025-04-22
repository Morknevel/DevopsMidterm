# Set project root directory
PROJECT_ROOT=$(dirname "$(dirname "$(readlink -f "$0")")")
PROD_DIR="$PROJECT_ROOT/production"
BLUE_DIR="$PROD_DIR/blue"
GREEN_DIR="$PROD_DIR/green"
ACTIVE_LINK="$PROD_DIR/active"
LOGS_DIR="$PROJECT_ROOT/logs"

# Make sure logs directory exists
mkdir -p "$LOGS_DIR"

# Determine current active environment
if [ "$(readlink -f "$ACTIVE_LINK")" = "$BLUE_DIR" ]; then
    NEW_ENV="$GREEN_DIR"
    OLD_ENV="$BLUE_DIR"
    NEW_ENV_NAME="GREEN"
else
    NEW_ENV="$BLUE_DIR"
    OLD_ENV="$GREEN_DIR"
    NEW_ENV_NAME="BLUE"
fi

echo "$(date): Rolling back to $NEW_ENV_NAME environment..." | tee -a "$LOGS_DIR/deploy.log"

# Switch the active link to the rollback environment
ln -sf "$NEW_ENV" "$ACTIVE_LINK"

# Kill any existing app processes
pkill -f "python run.py" || true

# Start the application in the background
cd "$ACTIVE_LINK"
source venv/bin/activate
nohup python run.py > "$LOGS_DIR/app.log" 2>&1 &
deactivate

echo "Rollback completed successfully!" | tee -a "$LOGS_DIR/deploy.log"
echo "Application is now running on http://localhost:5000"