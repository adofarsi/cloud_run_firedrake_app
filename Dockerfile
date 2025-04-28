# Dockerfile for a Firedrake container including Jupyter.

FROM firedrakeproject/firedrake:latest

# Install an iPython kernel for Firedrake
RUN pip install --verbose jupyterlab nbclassic nbformat nbconvert ipympl \
    && jupyter nbclassic --generate-config

# Move the notebooks and strip their output
RUN mkdir /opt/firedrake-notebooks \
    && cp -r /opt/firedrake/docs/notebooks/* /opt/firedrake-notebooks/ \
    && for file in /opt/firedrake-notebooks/*.ipynb; do \
        jupyter nbconvert --ClearOutputPreprocessor.enabled=True --inplace $file; \
    done

# Now do the same for thetis.
RUN mkdir /opt/thetis-notebooks \
    && cp -r /opt/thetis/demos/* /opt/thetis-notebooks/ \
    && rm /opt/thetis-notebooks/*.py \
    && for file in /opt/thetis-notebooks/*.ipynb; do \
        jupyter nbconvert --ClearOutputPreprocessor.enabled=True --inplace $file; \
    done

# Expose streamlit port
EXPOSE 7860

# Start Jupyter Lab on port 7860, listening on all interfaces
CMD ["jupyter", "lab", "--ip", "0.0.0.0", "--port", "7860", "--no-browser", "--allow-root"]