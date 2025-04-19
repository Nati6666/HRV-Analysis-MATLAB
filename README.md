# HRV Analysis App

The HRV (Heart Rate Variability) Analysis App is a MATLAB-based graphical user interface (GUI) application designed to analyze heart rate variability using RR interval data. The app allows users to load real or synthetic HRV data, perform HRV calculations, and visualize the results in various graphical formats such as waveforms, time series, scatter plots, and power spectral density plots.

## Features

- **Data Input**:

  - Select between real HRV data (from a file) or synthetic data.
  - works best for the synthetic data.......
  - its perfect for the real datase
  -

  Input for the file path and other configuration options like the number of beats and distribution type (Gaussian/Exponential).

- **HRV Calculations**:

  - Calculates HRV using the difference between successive RR intervals.
  - Displays HRV metrics such as SDNN, RMSSD, and LF/HF Ratio.

- **Data Visualization**:

  - HRV Waveform (ΔRR)
  - Time Series of RR intervals
  - Scatter plot of HRV vs. RR Interval
  - Power Spectral Density (FFT-based)

- **Physiological States**:

  - Analyze HRV data for different physiological states: Rest, Exercise, and Stress.

## Requirements

- MATLAB R2020b or higher
- Signal Processing Toolbox (for FFT-based PSD)

## Installation

1. Clone the repository or download the app files.
2. Open the app by running `HRVAnalysisApp.m` in MATLAB.
3. Ensure the necessary toolboxes (Signal Processing Toolbox) are installed.

## Usage

1. **Select Data Source**: Choose between "Real Data" (load from a file) or "Synthetic Data".
2. **Choose Physiological State**: Select from Rest, Exercise, or Stress.
3. **Enter File Path** (if "Real Data" is selected): Input the full path to the HRV data file (must contain `RR` data).
4. **Number of Beats**: Set the number of beats (RR intervals) to generate if using synthetic data.
5. **Run Analysis**: Click the "Run Analysis" button to process the data and display results.
6. **View Results**:
   - HRV metrics (SDNN, RMSSD, LF/HF ratio) are displayed at the top.
   - Visualizations of HRV waveform, RR interval time series, scatter plot, and power spectral density will be generated in separate axes.

## HRV Metrics

- **SDNN**: Standard deviation of RR intervals.
- **RMSSD**: Root mean square of successive differences of RR intervals.
- **LF/HF Ratio**: Ratio of low-frequency to high-frequency components in the power spectral density of RR intervals.

## Example Output

- **HRV Waveform**: Plot of successive RR intervals (HRV).
- **Time Series**: RR interval values plotted over time.
- **Scatter Plot**: Relationship between RR intervals and HRV.
- **Power Spectral Density**: Frequency-based analysis of RR intervals.

## Authors

- Nati Melkamu
- MATLAB App Developed by [Nati Melkamu]

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgements

This app uses the Signal Processing Toolbox for FFT-based calculations and power spectral density analysis. Special thanks to the developers of MATLAB for providing the tools to build this app.

