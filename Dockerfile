FROM node:10.10
LABEL maintainer="Rusty <rusty.shaun@gmail.com>"
LABEL version="1.0.0"


# Mount projects as /home/node/site
RUN mkdir -p /home/node/site

# Setp Azure CLI repo
# See: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest
RUN apt-get update -y
RUN apt-get install -y \
    apt-transport-https \
    lsb-release \
    software-properties-common \
    dirmngr \
    net-tools

RUN AZ_REPO=$(lsb_release -cs); echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    tee /etc/apt/sources.list.d/azure-cli.list

RUN apt-key --keyring /etc/apt/trusted.gpg.d/Microsoft.gpg adv \
     --keyserver packages.microsoft.com \
     --recv-keys BC528686B50D79E339D3721CEB3E94ADBE1229CF

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - & \
    echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list

RUN apt-get update -y
RUN apt-get install -y --force-yes \
    zip \
    curl \
    vim \
    zsh \
    azure-cli \
    nginx \
    google-chrome-stable

RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh; \
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

RUN cp -r ~/.oh-my-zsh /home/node; \
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template /home/node/.zshrc; \
    chown node:node /home/node/.zshrc; \
    chown -R node:node /home/node/.oh-my-zsh; \
    chown -R node:node /home/node/site; \
    chsh -s /bin/zsh;


# See: https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally
# RUN mkdir ~/.npm-global & \
#     npm config set prefix '~/.npm-global'


# Angular
RUN npm install -g @angular/cli pm2 hammerjs

RUN npm install node-sass

WORKDIR /home/node/site

USER node
ENV CHROME_BIN=/usr/bin/google-chrome
#ENV NPM_CONFIG_PREFIX=~/.npm-global

ENTRYPOINT ["/bin/zsh"]


