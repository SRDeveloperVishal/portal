#!/bin/bash

# Check if Docker is installed
if command -v docker &> /dev/null; then
    # Docker is installed
    echo "Docker is installed."
    docker --version



   
   # clone tutor from github
    git clone https://github.com/SRDeveloperVishal/tutor_13_clone.git

    # change into tutor dic
    mv tutor_13_clone tutor

    # remove exisitng tutor 
    sudo rm -rf .local/share/tutor

# Now you can safely move or copy 'tutor/' to the destination directory
    mv tutor .local/share/

    # take input from user
    echo "Enter LMS_HOST Name:"
    read LMS_HOST
    echo "Enter Course Email:"
    read COURSE_EMAIL
    echo "Enter SMTP HOST:"
    read SMTP_HOST
    echo "Enter SMTP USERNAME:"
    read SMTP_USERNAME
    echo "Enter SMTP PASSWORD:"
    read SMTP_PASSWORD
    echo "Enter CONTACT EMAIL:"
    read CONTACT_EMAIL
  # tutor config for portel
    

   tutor config save --set CMS_HOST="studio.$LMS_HOST.rcmoocs.in"  \
   --set LMS_HOST="$LMS_HOST.rcmoocs.in"\
   --set COURSE_EMAIL=$COURSE_EMAIL \
   --set SMTP_HOST="$SMTP_HOST" \
   --set SMTP_PORT=587 \
   --set SMTP_USE_TLS=true \
   --set SMTP_USERNAME="$SMTP_USERNAME" \
   --set SMTP_PASSWORD="$SMTP_PASSWORD" \
   --set CONTACT_EMAIL="$CONTACT_EMAIL"

   #tutor build 
   tutor local start -d

   # tutor migrate
   tutor local init 

   # tutor settheme 
   tutor local settheme edx-reborn-indigo

else
    # Docker is not installed
    echo "Docker is not installed."
    
    # Update the package cache
    sudo apt-get update

    # Install the packages using line continuation
    sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
    
    # downloading docker for ubutnu
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
    # install docker 
    sudo apt install docker.io -y
    
    # give permission to docker user
    sudo usermod -aG docker $USER
    
    # install docker compose
    sudo curl -SL https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose

    # give permission to docker compose 
    sudo chmod +x /usr/local/bin/docker-compose


    # clone tutor from github
    git clone https://github.com/SRDeveloperVishal/tutor_13_clone.git

    # change into tutor dic
    mv tutor_13_clone tutor

    # move tutor to share
    mv tutor .local/share/

    # install tutor binary
    sudo curl -L "https://github.com/overhangio/tutor/releases/download/v13.1.5/tutor-$(uname -s)_$(uname -m)" -o /usr/local/bin/tutor
    
    # give permission to tutor user
    sudo chmod 0755 /usr/local/bin/tutor

    # take input from user
    echo "Enter LMS HOST Name:"
    read LMS_HOST
    echo "Enter Course Email:"
    read COURSE_EMAIL
    echo "Enter SMTP HOST:"
    read SMTP_HOST
    echo "Enter SMTP USERNAME:"
    read SMTP_USERNAME
    echo "Enter SMTP PASSWORD:"
    read SMTP_PASSWORD
    echo "Enter CONTACT EMAIL:"
    read CONTACT_EMAIL


    # tutor config for portel
   tutor config save --set CMS_HOST="studio.$LMS_HOST.rcmoocs.in"  \
   --set LMS_HOST="$LMS_HOST.rcmoocs.in"\
   --set COURSE_EMAIL=$COURSE_EMAIL \
   --set SMTP_HOST="$SMTP_HOST" \
   --set SMTP_PORT=587 \
   --set SMTP_USE_TLS=true \
   --set SMTP_USERNAME="$SMTP_USERNAME" \
   --set SMTP_PASSWORD="$SMTP_PASSWORD" \
   --set CONTACT_EMAIL="$CONTACT_EMAIL"



  
   # tutor build 
   tutor local start -d

   # tutor migrate
   tutor local init 

   # tutor settheme 
   tutor local settheme edx-reborn-indigo

fi


