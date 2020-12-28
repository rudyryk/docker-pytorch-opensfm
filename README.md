docker-pytorch-opensfm
======================

Docker image containing `PyTorch` and `OpenSFM` with some useful extras:

- Jypyter
- Faiss
- scipy
- numpy
- sklearn
- h5py
- tensorboardX

## Building

```bash
docker build -t pytorch-opensfm:latest ./main
docker tag pytorch-opensfm:latest rudyryk/pytorch-opensfm:latest
docker push rudyryk/pytorch-opensfm:latest
```

Test run:

```bash
docker run -it --rm -p 8888:8888 pytorch-opensfm:latest \
    jupyter lab --allow-root --ip=0.0.0.0 --port 8888 --no-browser
```
