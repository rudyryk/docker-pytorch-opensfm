docker-pytorch-faiss
====================

Docker image containing `PyTorch` and `Faiss` with some useful extras:

- Faiss
- scipy
- numpy
- sklearn
- h5py
- tensorboardX

## Building

```bash
docker build -t pytorch-faiss-tools:latest .
docker tag pytorch-faiss-tools:latest rudyryk/pytorch-faiss-tools:latest
docker push rudyryk/pytorch-faiss-tools:latest
```

Test run:

```bash
docker run -it --rm -p 8888:8888 pytorch-faiss-tools:latest \
    jupyter lab --allow-root --ip=0.0.0.0 --port 8888 --no-browser
```
