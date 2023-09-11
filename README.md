# Dockerfile for OnnxStream

This is a Dockerfile to run [OnnxStream](https://github.com/vitoplantamura/OnnxStream) to run Stable Diffusion on less powerful computers.

## Build
```bash
docker build -t onnxstream .
```

## Run
```bash
mkdir output
docker run --rm -it \
  --mount type=bind,source=$(pwd)/output,target=/app/out \
  onnxstream:latest sd --models-path /weights/SD --output /app/out/out.png --prompt "a penguin standing in a forest" <additional parameters>
                                                                                                                       
# Parameters
# --models-path       Sets the folder containing the Stable Diffusion models. Weights are extracted to /weights/SD in the Docker container
# --ops-printf        During inference, writes the current operation to stdout.
# --output            Sets the output PNG file. This should be inside of a volume to make the file accessible to the host computer.
# --decode-latents    Skips the diffusion, and decodes the specified latents file.
# --prompt            Sets the positive prompt.
# --neg-prompt        Sets the negative prompt.
# --steps             Sets the number of diffusion steps.
# --save-latents      After the diffusion, saves the latents in the specified file.
# --decoder-calibrate Calibrates the quantized version of the VAE decoder.
# --decoder-fp16      During inference, uses the FP16 version of the VAE decoder.
# --rpi               Configures the models to run on a Raspberry Pi Zero 2.
```
