classdef Newton_Raphson < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        NewtonRaphsonPanel              matlab.ui.container.Panel
        InitialguessEditField           matlab.ui.control.NumericEditField
        InitialguessEditFieldLabel      matlab.ui.control.Label
        x_maxEditField                  matlab.ui.control.NumericEditField
        x_maxEditFieldLabel             matlab.ui.control.Label
        x_minEditField                  matlab.ui.control.NumericEditField
        x_minEditFieldLabel             matlab.ui.control.Label
        EnterthefunctionEditField       matlab.ui.control.EditField
        EnterthefunctionEditFieldLabel  matlab.ui.control.Label
        theapproximatevalueLabel        matlab.ui.control.Label
        therootLabel                    matlab.ui.control.Label
        ClearButton                     matlab.ui.control.Button
        EvaluateButton                  matlab.ui.control.Button
        UIAxes                          matlab.ui.control.UIAxes
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: EvaluateButton
        function EvaluateButtonPushed(app, event)
            real_zeros = [];
            flag = 0;
            y = app.EnterthefunctionEditField.Value;
            if isempty(y)
                errordlg('Input function has to be specified', 'Input Error');
            f   lag = 1;
            else
                assignin('base','y',y);
            end
            xmin = app.x_minEditField.Value;
            m = double(xmin);
            if isnan(m)
                errordlg('x_min has to be specified', 'Input Error');
                flag = 1;
            else
                assignin('base','x_min',xmin);
            end
            xmax = app.x_maxEditField.Value;
            n = double(xmax);
            if isnan(n)
                errordlg('x_max has to be specified', 'Input Error');
                flag = 1;
            else
                assignin('base','x_max',xmax);
            end
            if flag == 0
                xx = m:(n-m)/100:n;
                app.UIAxes.YLim = [-2 2];
                app.UIAxes.XLim = [m n];
                yy = str2func(strcat('@(x) ',y));
                z = yy(xx);
                plot(app.UIAxes,xx,z);
            end
            syms x ysym
            ysym(x) = str2sym(y);
            dydx(x) = diff(ysym,x);
            tol = 1e-6;
            xg = app.InitialguessEditField.Value;
            for k = 1:100
                x0 = xg;
                xg = x0 - vpa(ysym(x0))/vpa(dydx(x0));
                if abs(xg-x0) < tol
                    break
                end
            end
            if (k==100)
                h = msgbox('the sequence does not converge')
            else
                real_zeros = [real_zeros xg];
            end
            root = vpa(xg);
            app.theapproximatevalueLabel.Text = num2str(double(root));
        end

        % Button pushed function: ClearButton
        function ClearButtonPushed(app, event)
            app.EnterthefunctionEditField.Value = '';
            app.x_minEditField.Value = 0;
            app.x_maxEditField.Value = 0;
            app.theapproximatevalueLabel.Text = 'the approximate value';
            app.initialguessEditField.Value = 0;
            cla(app.UIAxes);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 736 490];
            app.UIFigure.Name = 'MATLAB App';

            % Create NewtonRaphsonPanel
            app.NewtonRaphsonPanel = uipanel(app.UIFigure);
            app.NewtonRaphsonPanel.Title = 'Newton Raphson';
            app.NewtonRaphsonPanel.Position = [25 24 694 458];

            % Create UIAxes
            app.UIAxes = uiaxes(app.NewtonRaphsonPanel);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.Position = [23 18 534 243];

            % Create EvaluateButton
            app.EvaluateButton = uibutton(app.NewtonRaphsonPanel, 'push');
            app.EvaluateButton.ButtonPushedFcn = createCallbackFcn(app, @EvaluateButtonPushed, true);
            app.EvaluateButton.Position = [132 276 100 23];
            app.EvaluateButton.Text = 'Evaluate';

            % Create ClearButton
            app.ClearButton = uibutton(app.NewtonRaphsonPanel, 'push');
            app.ClearButton.ButtonPushedFcn = createCallbackFcn(app, @ClearButtonPushed, true);
            app.ClearButton.Position = [300 276 100 23];
            app.ClearButton.Text = 'Clear';

            % Create therootLabel
            app.therootLabel = uilabel(app.NewtonRaphsonPanel);
            app.therootLabel.Position = [330 326 46 22];
            app.therootLabel.Text = 'the root';

            % Create theapproximatevalueLabel
            app.theapproximatevalueLabel = uilabel(app.NewtonRaphsonPanel);
            app.theapproximatevalueLabel.Position = [454 326 123 22];
            app.theapproximatevalueLabel.Text = 'the approximate value';

            % Create EnterthefunctionEditFieldLabel
            app.EnterthefunctionEditFieldLabel = uilabel(app.NewtonRaphsonPanel);
            app.EnterthefunctionEditFieldLabel.HorizontalAlignment = 'right';
            app.EnterthefunctionEditFieldLabel.Position = [59 393 99 22];
            app.EnterthefunctionEditFieldLabel.Text = 'Enter the function';

            % Create EnterthefunctionEditField
            app.EnterthefunctionEditField = uieditfield(app.NewtonRaphsonPanel, 'text');
            app.EnterthefunctionEditField.Position = [173 393 100 22];

            % Create x_minEditFieldLabel
            app.x_minEditFieldLabel = uilabel(app.NewtonRaphsonPanel);
            app.x_minEditFieldLabel.HorizontalAlignment = 'right';
            app.x_minEditFieldLabel.Position = [121 364 37 22];
            app.x_minEditFieldLabel.Text = 'x_min';

            % Create x_minEditField
            app.x_minEditField = uieditfield(app.NewtonRaphsonPanel, 'numeric');
            app.x_minEditField.Position = [173 364 100 22];

            % Create x_maxEditFieldLabel
            app.x_maxEditFieldLabel = uilabel(app.NewtonRaphsonPanel);
            app.x_maxEditFieldLabel.HorizontalAlignment = 'right';
            app.x_maxEditFieldLabel.Position = [336 364 40 22];
            app.x_maxEditFieldLabel.Text = 'x_max';

            % Create x_maxEditField
            app.x_maxEditField = uieditfield(app.NewtonRaphsonPanel, 'numeric');
            app.x_maxEditField.Position = [391 364 100 22];

            % Create InitialguessEditFieldLabel
            app.InitialguessEditFieldLabel = uilabel(app.NewtonRaphsonPanel);
            app.InitialguessEditFieldLabel.HorizontalAlignment = 'right';
            app.InitialguessEditFieldLabel.Position = [90 326 68 22];
            app.InitialguessEditFieldLabel.Text = 'Initial guess';

            % Create InitialguessEditField
            app.InitialguessEditField = uieditfield(app.NewtonRaphsonPanel, 'numeric');
            app.InitialguessEditField.Position = [173 326 100 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Newton_Raphson

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
