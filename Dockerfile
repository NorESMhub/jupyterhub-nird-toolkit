FROM quay.io/uninett/jupyterhub-singleuser:20191012-5691f5c

MAINTAINER Anne Fouilloux <annefou@geo.uio.no>

# Install packages
USER root
RUN apt-get update && apt-get install -y vim

# Install requirements for Python 3
ADD jupyterhub_environment.yml jupyterhub_environment.yml

RUN conda env create -f jupyterhub_environment.yml

RUN source activate esmvaltool && \
    /opt/conda/bin/ipython kernel install --user --name esmvaltool && \
    /opt/conda/bin/python -m ipykernel install --user --name=esmvaltool && \
    /opt/conda/bin/jupyter labextension install @jupyterlab/hub-extension \
                           @jupyter-widgets/jupyterlab-manager && \
    /opt/conda/bin/jupyter labextension install jupyterlab-datawidgets && \
    /opt/conda/bin/jupyter labextension install @jupyter-widgets/jupyterlab-sidecar && \
    /opt/conda/bin/jupyter labextension install @pyviz/jupyterlab_pyviz \
                           jupyter-leaflet

# Fix hub failure
RUN fix-permissions $HOME

# Install other packages
USER notebook
