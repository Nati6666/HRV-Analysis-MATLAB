   classdef HRVAnalysisApp < matlab.apps.AppBase
    properties (Access = public)
        % UI Components
        UIFigure                matlab.ui.Figure
        TitleLabel              matlab.ui.control.Label
        DataSourceDrop          matlab.ui.control.DropDown
        PhysiologicalStateDrop  matlab.ui.control.DropDown
        FilePathEdit            matlab.ui.control.EditField
        NumBeatsEdit            matlab.ui.control.NumericEditField
        DistTypeDrop            matlab.ui.control.DropDown
        RunButton               matlab.ui.control.Button
        HRVWaveformAxis        matlab.ui.control.UIAxes  
        TimeSeriesAxis          matlab.ui.control.UIAxes
        ScatterAxis            matlab.ui.control.UIAxes
        SpectralAxis           matlab.ui.control.UIAxes
        MetricsLabel           matlab.ui.control.Label
        DataTable              matlab.ui.control.Table
    end

    properties (Access = private)
        % Data
        RR_intervals            double  
        HRV                     double  
    end

    methods (Access = public)
        function app = HRVAnalysisApp()
            
            createComponents(app);
        end
    end

    methods (Access = private)
        function createComponents(app)
            
            app.UIFigure = uifigure('Position', [100 100 1000 700], 'Color', '#f0f0f0', 'Name', 'HRV Analysis App');

            app.TitleLabel = uilabel(app.UIFigure, 'Position', [20 680 960 50], 'Text', 'HRV Analysis Application', ...
                'FontSize', 24, 'FontWeight', 'bold', 'HorizontalAlignment', 'center', ...
                'BackgroundColor', '#0984e3', 'FontColor', 'white', 'FontName', 'Arial');

          
            app.DataSourceDrop = uidropdown(app.UIFigure, 'Position', [20 590 250 30], ...
                'Items', {'Real Data', 'Synthetic Data'}, 'FontSize', 12, 'FontName', 'Arial', ...
                'BackgroundColor', '#ffffff', 'FontColor', '#333333');

            app.PhysiologicalStateDrop = uidropdown(app.UIFigure, 'Position', [20 540 250 30], ...
                'Items', {'Rest', 'Exercise', 'Stress'}, 'FontSize', 12, 'FontName', 'Arial', ...
                'BackgroundColor', '#ffffff', 'FontColor', '#333333');

            app.FilePathEdit = uieditfield(app.UIFigure, 'text', 'Position', [20 490 300 30], ...
                'Placeholder', 'Enter HRV file path', 'FontSize', 12, 'FontName', 'Arial', ...
                'BackgroundColor', '#ffffff', 'FontColor', '#333333');

            app.NumBeatsEdit = uieditfield(app.UIFigure, 'numeric', 'Position', [20 440 100 30], ...
                'Limits', [10 Inf], 'Value', 1000, 'FontSize', 12, 'FontName', 'Arial', ...
                'BackgroundColor', '#ffffff', 'FontColor', '#333333');

            app.DistTypeDrop = uidropdown(app.UIFigure, 'Position', [20 390 250 30], ...
                'Items', {'Gaussian', 'Exponential'}, 'FontSize', 12, 'FontName', 'Arial', ...
                'BackgroundColor', '#ffffff', 'FontColor', '#333333');

            % Run Button
            app.RunButton = uibutton(app.UIFigure, 'push', 'Text', 'Run Analysis', ...
                'Position', [20 340 120 40], 'ButtonPushedFcn', @(~,~)runAnalysis(app), ...
                'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'Arial', ...
                'BackgroundColor', '#00b894', 'FontColor', 'white');

            % Axes for Plots
            app.HRVWaveformAxis = uiaxes(app.UIFigure, 'Position', [350 380 600 250], ...
                'Box', 'on', 'XGrid', 'on', 'YGrid', 'on', 'FontName', 'Arial', ...
                'Color', '#ffffff', 'XColor', '#333333', 'YColor', '#333333');

            app.TimeSeriesAxis = uiaxes(app.UIFigure, 'Position', [350 120 600 250], ...
                'Box', 'on', 'XGrid', 'on', 'YGrid', 'on', 'FontName', 'Arial', ...
                'Color', '#ffffff', 'XColor', '#333333', 'YColor', '#333333');

            app.ScatterAxis = uiaxes(app.UIFigure, 'Position', [20 120 300 250], ...
                'Box', 'on', 'XGrid', 'on', 'YGrid', 'on', 'FontName', 'Arial', ...
                'Color', '#ffffff', 'XColor', '#333333', 'YColor', '#333333');

            app.SpectralAxis = uiaxes(app.UIFigure, 'Position', [20 50 300 50], ...
                'Box', 'on', 'XGrid', 'on', 'YGrid', 'on', 'FontName', 'Arial', ...
                'Color', '#ffffff', 'XColor', '#333333', 'YColor', '#333333');

            % Metrics Label
            app.MetricsLabel = uilabel(app.UIFigure, 'Position', [350 10 600 40], ...
                'Text', 'HRV Metrics will be displayed here.', 'FontSize', 14, 'FontWeight', 'bold', ...
                'FontName', 'Arial', 'HorizontalAlignment', 'center', 'BackgroundColor', '#0984e3', ...
                'FontColor', 'white');

            % Data Table
            app.DataTable = uitable(app.UIFigure, 'Position', [350 50 600 70], ...
                'ColumnName', {'RR Interval'}, 'RowName', [], 'Data', [], 'FontSize', 12, ...
                'FontName', 'Arial', 'BackgroundColor', '#ffffff');
        end

        function runAnalysis(app)
            % Get user inputs
            choice = app.DataSourceDrop.Value;
            physiologicalState = app.PhysiologicalStateDrop.Value;

            % Load or generate RR intervals
            if strcmp(choice, 'Real Data')
                % Load real data from file
                filePath = app.FilePathEdit.Value;
                if ~isfile(filePath)
                    uialert(app.UIFigure, 'File path does not exist!', 'Error');
                    return;
                end
                hrData = load(filePath);
                if ~isfield(hrData, 'RR')
                    uialert(app.UIFigure, 'File does not contain RR data!', 'Error');
                    return;
                end
                app.RR_intervals = hrData.RR;  
            else
                % Generate synthetic data
                n = app.NumBeatsEdit.Value;
                distType = app.DistTypeDrop.Value;

                switch physiologicalState
                    case 'Rest'
                        rng(1);  
                        mu = 0.8; sigma = 0.1;  % Longer RR intervals, lower heart rate
                    case 'Exercise'
                        rng(2);  
                        mu = 0.5; sigma = 0.05;  % Shorter RR intervals, higher heart rate
                    case 'Stress'
                        rng(3);  
                        mu = 0.7; sigma = 0.15;  % Intermediate RR intervals
                end

                if strcmp(distType, 'Gaussian')
                    app.RR_intervals = mu + sigma * randn(n, 1);
                else
                    lambda = 1.2;  
                    if strcmp(physiologicalState, 'Exercise')
                        lambda = 2.0;  
                    end
                    app.RR_intervals = -log(rand(n, 1)) / lambda;
                end
            end

            if isempty(app.RR_intervals) || ~isnumeric(app.RR_intervals)
                uialert(app.UIFigure, 'Invalid RR intervals data!', 'Error');
                return;
            end

            app.DataTable.Data = app.RR_intervals;  

            % Calculate HRV (successive differences)
            app.HRV = diff(app.RR_intervals);  % HRV = ΔRR = RR(i+1) - RR(i)

            % Calculate HRV Metrics
            SDNN = std(app.RR_intervals);
            RMSSD = sqrt(mean(app.HRV.^2));  % RMSSD is calculated from HRV
            LF_HF_ratio = calcLFHF(app, app.RR_intervals);
            app.MetricsLabel.Text = sprintf('SDNN: %.4f s | RMSSD: %.4f s | LF/HF Ratio: %.4f', SDNN, RMSSD, LF_HF_ratio);

            % Plot HRV Waveform
            plot(app.HRVWaveformAxis, app.HRV, '-b', 'LineWidth', 1.5);
            title(app.HRVWaveformAxis, 'HRV Waveform (ΔRR)', 'FontSize', 14, 'FontWeight', 'bold', 'Color', '#333333');
            xlabel(app.HRVWaveformAxis, 'Beat Number', 'FontSize', 12, 'FontWeight', 'bold', 'Color', '#333333');
            ylabel(app.HRVWaveformAxis, 'HRV (ΔRR in seconds)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', '#333333');
            grid(app.HRVWaveformAxis, 'on');

            % Plot Time Series (RR Intervals)
            plot(app.TimeSeriesAxis, app.RR_intervals, '-o', 'Color', '#00b894', 'LineWidth', 1.5);
            title(app.TimeSeriesAxis, 'RR Interval Time Series', 'FontSize', 14, 'FontWeight', 'bold', 'Color', '#333333');
            xlabel(app.TimeSeriesAxis, 'Beat Number', 'FontSize', 12, 'FontWeight', 'bold', 'Color', '#333333');
            ylabel(app.TimeSeriesAxis, 'RR Interval (s)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', '#333333');
            grid(app.TimeSeriesAxis, 'on');

            % Plot Scatter Plot: HRV vs. RR Interval
            RR_for_scatter = app.RR_intervals(1:end-1);  % Exclude the last RR interval
            scatter(app.ScatterAxis, RR_for_scatter, app.HRV, 'filled', 'MarkerFaceColor', '#0984e3');
            title(app.ScatterAxis, 'HRV vs. RR Interval', 'FontSize', 14, 'FontWeight', 'bold', 'Color', '#333333');
            xlabel(app.ScatterAxis, 'RR Interval (s)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', '#333333');
            ylabel(app.ScatterAxis, 'HRV (ΔRR in seconds)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', '#333333');
            grid(app.ScatterAxis, 'on');

            % Linear Regression
            p = polyfit(RR_for_scatter, app.HRV, 1);  % Fit a linear regression line
            y_fit = polyval(p, RR_for_scatter);
            hold(app.ScatterAxis, 'on');
            plot(app.ScatterAxis, RR_for_scatter, y_fit, '-r', 'LineWidth', 2);
            hold(app.ScatterAxis, 'off');

            % Plot Power Spectral Density
            [pxx, f] = fft_psd(app.RR_intervals);  % Use FFT-based PSD
            plot(app.SpectralAxis, f, 10*log10(pxx), 'Color', '#d63031', 'LineWidth', 1.5);
            title(app.SpectralAxis, 'Power Spectral Density', 'FontSize', 14, 'FontWeight', 'bold', 'Color', '#333333');
            xlabel(app.SpectralAxis, 'Frequency (Hz)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', '#333333');
            ylabel(app.SpectralAxis, 'Power (dB)', 'FontSize', 12, 'FontWeight', 'bold', 'Color', '#333333');
            grid(app.SpectralAxis, 'on');
        end

        function LF_HF_ratio = calcLFHF(app, RR_intervals)
            % Calculate LF/HF ratio using FFT
            N = length(RR_intervals);
            fft_result = fft(RR_intervals - mean(RR_intervals));
            Pxx = abs(fft_result(1:N/2+1)).^2 / N;  % Power spectrum
            f = (0:N/2) / N;  % Frequency vector
            LF_power = sum(Pxx(f >= 0.04 & f <= 0.15));  % Low-frequency power
            HF_power = sum(Pxx(f >= 0.15 & f <= 0.4));   % High-frequency power
            LF_HF_ratio = LF_power / HF_power;
        end

        function [Pxx, f] = fft_psd(RR_intervals)
            % Calculate Power Spectral Density using FFT
            N = length(RR_intervals);
            fft_result = fft(RR_intervals - mean(RR_intervals));
            Pxx = abs(fft_result(1:N/2+1)).^2 / N;
            f = (0:N/2) / N;
        end
    end
end