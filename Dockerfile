FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN su - && apt-get upgrade -y
RUN su - && apt-get install -y wget vim git

# Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && bash ~/miniconda.sh -b -p $HOME/miniconda && $HOME/miniconda/bin/conda init

# Installing packages
RUN $HOME/miniconda/bin/conda install -y tensorflow-gpu matplotlib pandas jupyter -n base

RUN $HOME/miniconda/bin/jupyter notebook --generate-config \
  && echo "c = get_config()" >> ~/.jupyter/jupyter_notebook_config.py \
  && echo "c.NotebookApp.ip = '0.0.0.0'" >> ~/.jupyter/jupyter_notebook_config.py \
  && echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py \
  && echo "c.NotebookApp.port = 8888" >> ~/.jupyter/jupyter_notebook_config.py \
  && echo "c.NotebookApp.password = 'sha1:e0bbf67da8b9:6b86ddf8dc63701729c25b66a800476ed8a90669'" >> ~/.jupyter/jupyter_notebook_config.py

RUN mkdir $HOME/notebooks
WORKDIR /root/notebooks

EXPOSE 8888
CMD ["/root/miniconda/bin/jupyter", "notebook", "--allow-root"]

