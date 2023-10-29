#!/bin/bash

  #remove docker images
  docker rm -vf $(docker ps -aq)
  docker rmi -f $(docker images -aq)

  #uninstall docker 
  sudo apt purge docker.io -y

  #remove docker compose
  sudo rm -rf /usr/local/bin/docker-compose
  
  #remove tutor file
  sudo rm -rf "$(tutor config printroot)"

  sudo rm -rf /usr/local/bin/tutor

  # apt auto remove
  sudo apt autoremove -y
  
   # Update the package cache
    sudo apt-get update

    # Install the packages using line continuation
    sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y
    
    # downloading docker for ubutnu
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg -y
    
    # install docker 
    sudo apt install docker.io -y
    
    # give permission to docker user
    sudo usermod -aG docker $USER

    sudo chown $USER:docker /var/run/docker.sock

    # install docker compose
    sudo curl -SL https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose 

    # give permission to docker compose 
    sudo chmod +x /usr/local/bin/docker-compose
   
    # git clone tutor binary
    sudo curl -L "https://github.com/overhangio/tutor/releases/download/v13.1.5/tutor-$(uname -s)_$(uname -m)" -o /usr/local/bin/tutor
   
     # give permission to tutor user
    sudo chmod 0755 /usr/local/bin/tutor
    
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
   --set ENABLE_HTTPS=true \
   --set COURSE_EMAIL=$COURSE_EMAIL \
   --set SMTP_HOST="$SMTP_HOST" \
   --set SMTP_PORT=587 \
   --set SMTP_USE_TLS=true \
   --set SMTP_USERNAME="$SMTP_USERNAME" \
   --set SMTP_PASSWORD="$SMTP_PASSWORD" \
   --set CONTACT_EMAIL="$CONTACT_EMAIL" \

  

  #tutor build 
   tutor local start -d

  # tutor migrate
   tutor local init 

  # update lms and lms worker docker image
  YAML_FILE=".local/share/tutor/env/local/docker-compose.yml"
  NEW_IMAGE="7503444967/maple-edx-server"

 # Use sed to replace the image line for the 'lms' service
  sed -i "/^ *lms:/,/^ *[^ ]/ s|image: docker.io/overhangio/openedx:13.1.5|image: $NEW_IMAGE|" "$YAML_FILE"  
  sed -i "/^ *lms-worker:/,/^ *[^ ]/ s|image: docker.io/overhangio/openedx:13.1.5|image: $NEW_IMAGE|" "$YAML_FILE" 

   # tutor settheme 
   tutor local settheme edx-reborn-indigo 

  # tutor restart
  tutor local stop && tutor local start -d


  echo "Work complete your $LMS_HOST portal is ready"
  echo "Thank you !!"
