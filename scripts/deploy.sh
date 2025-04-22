# Set project root directory
PROJECT_ROOT=$(dirname "$(dirname "$(readlink -f "$0")")")
PROD_DIR="$PROJECT_ROOT/production"
BLUE_DIR="$PROD_DIR/blue"
GREEN_DIR="$PROD_DIR/green"
ACTIVE_LINK="$PROD_DIR/active"
LOGS_DIR="$PROJECT_ROOT/logs"

# Make sure directories exist
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

echo "$(date): Starting deployment to $NEW_ENV_NAME environment..." | tee -a "$LOGS_DIR/deploy.log"

# Copy the updated application files to the new environment
echo "Copying application files..." | tee -a "$LOGS_DIR/deploy.log"
rsync -av --delete "$PROJECT_ROOT/app/" "$NEW_ENV/app/"
cp "$PROJECT_ROOT/run.py" "$NEW_ENV/"
cp "$PROJECT_ROOT/requirements.txt" "$NEW_ENV/"

# Install dependencies in the new environment
echo "Installing dependencies..." | tee -a "$LOGS_DIR/deploy.log"
cd "$NEW_ENV"
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
deactivate

# Run tests in the new environment
echo "Running tests..." | tee -a "$LOGS_DIR/deploy.log"
cd "$NEW_ENV"
source venv/bin/activate
python -m pytest
TEST_RESULT=$?
deactivate

# If tests passed, switch the active link to the new environment
if [ $TEST_RESULT -eq 0 ]; then
    echo "Tests passed! Switching to $NEW_ENV_NAME environment..." | tee -a "$LOGS_DIR/deploy.log"
    ln -sf "$NEW_ENV" "$ACTIVE_LINK"
    
    # Kill any existing app processes
    pkill -f "python run.py" || true
    
    # Start the application in the background
    cd "$ACTIVE_LINK"
    source venv/bin/activate
    nohup python run.py > "$LOGS_DIR/app.log" 2>&1 &
    deactivate
    
    echo "Deployment completed successfully!" | tee -a "$LOGS_DIR/deploy.log"
    echo "Application is now running on http://localhost:5000"
else
    echo "Tests failed! Deployment aborted." | tee -a "$LOGS_DIR/deploy.log"
    exit 1
fi