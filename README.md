# DevOps Midterm Project

A simple Flask application with a complete DevOps pipeline set up in a local environment.

## Project Description

This project demonstrates DevOps principles including version control, CI/CD, Infrastructure as Code, and blue-green deployment in a local environment. The application is a simple Flask web app that allows users to submit messages and view them.

## Tools and Technologies Used

- **Web Application**: Flask (Python)
- **Version Control**: Git, GitHub
- **CI/CD**: GitHub Actions
- **Infrastructure as Code**: Ansible
- **Deployment Strategy**: Blue-Green Deployment
- **Health Monitoring**: Custom bash script

## CI/CD Pipeline

The CI/CD pipeline consists of the following steps:

1. **Continuous Integration**:
   - Automated tests run on each push to the main and dev branches
   - Code linting to ensure code quality
   - All steps are executed via GitHub Actions

2. **Continuous Deployment**:
   - Automated deployment using the `deploy.sh` script
   - Blue-Green deployment strategy for zero-downtime deployments
   - Rollback capability in case of failed deployments

## Infrastructure as Code (IaC)

Ansible is used to automate the setup of the local environment:

- Creates necessary directory structure
- Installs dependencies
- Sets up the Blue-Green deployment environments

## Workflow Diagram

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Developer  │────▶│  Git Push   │────▶│    CI/CD    │
└─────────────┘     └─────────────┘     └─────────────┘
                                              │
                                              ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ Health Check│◀────│  Deployment │◀────│   Ansible   │
└─────────────┘     └─────────────┘     └─────────────┘
      │                                        ▲  
      │                                        │
      ▼                                        │
┌─────────────┐                         ┌─────────────┐
│  Rollback   │────────────────────────▶│  Tests Pass?│
│ (if needed) │                         └─────────────┘
└─────────────┘
```

## Getting Started

### Prerequisites

- Python 3.8+
- Git
- Ansible

### Installation and Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/devops-midterm.git
   cd devops-midterm
   ```

2. Set up a Python virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install -r requirements.txt
   ```

3. Run the application locally for development:
   ```bash
   python run.py
   ```

4. Run the unit tests:
   ```bash
   python -m pytest
   ```

### Deploying with Ansible

1. Make the scripts executable:
   ```bash
   chmod +x scripts/*.sh
   ```

2. Run the Ansible playbook:
   ```bash
   ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
   ```

3. Deploy the application:
   ```bash
   ./scripts/deploy.sh
   ```

4. Check the application health:
   ```bash
   ./scripts/health_check.sh
   ```

5. Rollback if needed:
   ```bash
   ./scripts/rollback.sh
   ```

## Application Access

Once deployed, the application will be accessible at: http://localhost:5000

## Screenshots

[Screenshots will be added here]

## License

This project is licensed under the MIT License - see the LICENSE file for details.