#!/bin/bash


set -e  # Exit on any error

echo "🚀 Starting Azure VM setup..."
echo "================================"

echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install essential packages
echo "🔧 Installing essential packages..."
sudo apt install -y \
    curl \
    wget \
    gnupg \
    lsb-release \
    ca-certificates \
    apt-transport-https \
    software-properties-common \
    build-essential \
    unzip \
    vim \
    nano \
    htop \
    tree \
    jq \
    net-tools


echo "📝 Installing Git..."
sudo apt install -y git
git --version

echo "⚙️ Configuring Git..."
git config --global user.name "HIJOdelIDANII"
git config --global user.email "ahmed.idani@insat.ucar.tn"
git config --global init.defaultBranch main


echo "🐳 Installing Docker..."
# Remove old versions if they exist
sudo apt remove -y docker docker-engine docker.io containerd runc || true


sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg


echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


sudo apt update

sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin

sudo usermod -aG docker $USER

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

echo "Docker version:"
sudo docker --version

echo "🐙 Installing Docker Compose..."
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Docker Compose version:"
docker-compose --version

echo "🟢 Installing Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs
echo "Node.js version: $(node --version)"
echo "npm version: $(npm --version)"

echo "🐍 Installing Python 3 and pip..."
sudo apt install -y python3 python3-pip python3-venv
echo "Python version: $(python3 --version)"
echo "pip version: $(pip3 --version)"

echo "☁️ Installing Azure CLI..."
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
echo "Azure CLI version:"
az --version | head -1


echo "🧹 Cleaning up..."
sudo apt autoremove -y
sudo apt autoclean


echo "📋 Setting up useful aliases..."
cat >> ~/.bashrc << 'EOF'

# Custom aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias docker-clean='docker system prune -af'
alias docker-stop-all='docker stop $(docker ps -aq)'
alias docker-remove-all='docker rm $(docker ps -aq)'
EOF

echo ""
echo "✅ Setup completed successfully!"
echo "================================"
echo ""
echo "📋 Installed software:"
echo "• Git: $(git --version)"
echo "• Docker: $(sudo docker --version)"
echo "• Docker Compose: $(docker-compose --version)"
echo "• Node.js: $(node --version)"
echo "• Python: $(python3 --version)"
echo "• Azure CLI: $(az --version | head -1)"
echo "• code-server: Available"
echo ""
echo "🔄 Next steps:"
echo "1. Logout and login again (or run 'newgrp docker') to use Docker without sudo"
echo "2. Add your SSH public key to GitHub/GitLab (displayed above)"
echo "3. Test SSH connection: ssh -T git@github.com"
echo "4. Login to Azure CLI: az login"
echo "5. Test Docker: docker run hello-world"
echo ""
echo "🎉 Your Azure VM is ready for development!"