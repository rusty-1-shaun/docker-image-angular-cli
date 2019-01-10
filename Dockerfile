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
    dirmngr

RUN AZ_REPO=$(lsb_release -cs); echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    tee /etc/apt/sources.list.d/azure-cli.list

RUN apt-key --keyring /etc/apt/trusted.gpg.d/Microsoft.gpg adv \
     --keyserver packages.microsoft.com \
     --recv-keys BC528686B50D79E339D3721CEB3E94ADBE1229CF


RUN apt-get update -y
RUN apt-get install -y \
    zip \
    curl \
    vim \
    zsh \
    azure-cli

RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh; \
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

RUN cp -r ~/.oh-my-zsh /home/node; \
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template /home/node/.zshrc; \
    chown node:node /home/node/.zshrc; \
    chown -R node:node /home/node/.oh-my-zsh; \
    chown -R node:node /home/node/site; \
    chsh -s /bin/zsh;

# Angular
RUN npm install -g @angular/cli

USER node

WORKDIR /home/node/site


ENTRYPOINT ["/bin/zsh"]


