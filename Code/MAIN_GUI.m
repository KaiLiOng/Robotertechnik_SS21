%% COMPULSORY HOMEWORK ROBOT TECHNOLOGY SS21
    % Lecturer: Prof. Martin Kipfmüeller
    % Group member:
                   % Danial Hawari (67252)
                   % Kai Li Ong    (67254)
                   % Davin Lukito  (75420)
    % Task list:
    % To Create an algorithm using the Denavit-Hartenberg convention that,
    % 1) User specifies the vector to the origin of the i-th 
    %    coordinate system in base coordinates
    % 2) Specifies the orientation of the i-th coordinate system relative 
    %    to the base in terms of quaternions (Euler-Rodrigues parameters)
    % 3) Data is to be requested from the user in the form of a prompt
    % 4) Compute Denavit-Hartenberg parameters
    % 5) Plot 2D or 3D figure
    % 6) Check whether the user insert sensible input

%% Procedures taken to solve the homework
    % Create the GUI with Mathlab App Designer
    % Prompt user for the vector in base coordinate system
    % Prompt user for the quaternion relative to the base coordinate system
    % Check user input for vector and quaternion with:
        % 1) baseVectorPlausibilityCheck function that examines
        % whether at least one of the input vector variable inside (x,y,z) 
        % base coordinate is equal to the previous input vector.
        % If equal, the two links can be connected to the same joint.
        
        % 2) quaternionPlausibilityCheck function that examines
            % a. q0^2+q1^2+q2^2+q3^2 == 1
            % b. |q0|<= 1 && |q1|<=1 && |q2|<=1 && |q3|<=1
    % Calculate the Denavit Hartenberg parameter by
        % converting quaternion to rotation matrix
        % getting theta and alpha from RotMat
        % getting distance d and a from the input vector
    % Connect all links together
    % Plot figure
    
%% Main code:
classdef MAIN_GUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        Panel_5                     matlab.ui.container.Panel
        Knob                        matlab.ui.control.Knob
        DropDown                    matlab.ui.control.DropDown
        LinkControlLabel            matlab.ui.control.Label
        Panel_4                     matlab.ui.container.Panel
        %LinkFigureLabel             matlab.ui.control.Label
        %UIAxes                      matlab.ui.control.UIAxes
        InsertthevalueforbasecoordinatesystemvectorxyzLabel_2  matlab.ui.control.Label
        Image                       matlab.ui.control.Image
        InsertthevalueforbasecoordinatesystemvectorxyzLabel  matlab.ui.control.Label
        HOWTOUSELabel               matlab.ui.control.Label
        AboutLabel                  matlab.ui.control.Label
        Panel_3                     matlab.ui.container.Panel
        DHTable                     matlab.ui.control.Table
        DHTableLabel                matlab.ui.control.Label
        Panel_2                     matlab.ui.container.Panel
        LinkTable                   matlab.ui.control.Table
        LinkDataTableLabel          matlab.ui.control.Label
        Panel                       matlab.ui.container.Panel
        RemoveLinkButton            matlab.ui.control.Button
        AddLinkButton               matlab.ui.control.Button
        q3EditField                 matlab.ui.control.NumericEditField
        q3EditFieldLabel            matlab.ui.control.Label
        q2EditField                 matlab.ui.control.NumericEditField
        q2EditFieldLabel            matlab.ui.control.Label
        q1EditField                 matlab.ui.control.NumericEditField
        q1EditFieldLabel            matlab.ui.control.Label
        q0EditField                 matlab.ui.control.NumericEditField
        q0EditFieldLabel            matlab.ui.control.Label
        QuaternionOrientationLabel  matlab.ui.control.Label
        zEditField                  matlab.ui.control.NumericEditField
        zEditFieldLabel             matlab.ui.control.Label
        yEditField                  matlab.ui.control.NumericEditField
        yEditFieldLabel             matlab.ui.control.Label
        xEditField                  matlab.ui.control.NumericEditField
        xEditFieldLabel             matlab.ui.control.Label
        baseVectorLabel             matlab.ui.control.Label
    end

    
    properties (Access = private)
        base_vector         % List of vector in base coordinate system
        quaternion_0        % List of quaternion q0
        quaternion_vector   % List of quaternion q1.i, q2.j, q3.k
        dh_alpha            % List of D-H Alpha
        dh_tetha            % List of D-H Tetha
        dh_a                % List of D-H a
        dh_d                % List of D-H d
        move_link
        index = 0;
        input_data = [];
        output_data = [];  
        ax
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: AddLinkButton
        function AddLinkButtonPushed(app, event)
           app.index = app.index + 1;
           app.base_vector(app.index,:) = [app.xEditField.Value, app.yEditField.Value, app.zEditField.Value];
           
           % Check input vector in base coordinate system whether it is plausible
           % If not plausible, the data will not be stored
           if baseVectorPlausibilityCheck(app.base_vector) == 0
               warndlg (sprintf("Link cannot be connected together! \nPlease check your input!"), "Warning");
               app.base_vector = app.base_vector(1:end-1,:);
               app.index = app.index - 1;   
           end
           
           app.quaternion_0(app.index) = app.q0EditField.Value;
           app.quaternion_vector(app.index,:) = [app.q1EditField.Value, app.q2EditField.Value, app.q3EditField.Value];
           
           % Check input quaternion orientation whether it is plausible
           % If not plausible, the data will not be stored
           [quaternion_check, msg] = quaternionPlausibilityCheck (app.quaternion_0, app.quaternion_vector);
           if quaternion_check == 0
               app.base_vector = app.base_vector(1:end-1,:);
               app.quaternion_0 = app.quaternion_0(1:end-1,:);
               app.quaternion_vector = app.quaternion_vector(1:end-1,:);
               warndlg(sprintf(msg), "Warning!");
               app.index = app.index - 1;
               return
           end
           
           % Dump data into the Link Data Table
           app.input_data(app.index,:) = [app.base_vector(app.index,:), app.quaternion_0(app.index), app.quaternion_vector(app.index,:)];
           app.LinkTable.Data = app.input_data;
           
           % Calculate DH
           [app.dh_a, app.dh_alpha, app.dh_d, app.dh_tetha] = calculateDHParameter(app.base_vector, app.quaternion_0, app.quaternion_vector);
           app.output_data =  [app.dh_a, app.dh_alpha, app.dh_d, app.dh_tetha];
           app.DHTable.Data = app.output_data;
           
           % Add function to control link
           dropdown_value = app.DropDown.Items;
           for i = 1:app.index
               dropdown_value{i+1} = convertStringsToChars(string("Link ") + string(i));
           end
           app.DropDown.Items = dropdown_value;
           
           %Plot robot
           if app.index < 2
                warndlg("At least 2 links are needed to plot the robot figure!","Warning");
           else
                app.move_link = zeros(1, app.index);
                plotLink(app, app.dh_a, app.dh_alpha, app.dh_d, app.dh_tetha, app.move_link);
            end
            
        end

        % Button pushed function: RemoveLinkButton
        function RemoveLinkButtonPushed(app, event)
            % Warn user if there is no data inside the tables
            if app.index == 0 
                warndlg("The table is empty!","Warning");
              
            else
                % Warn user if the links are below than two and close the
                % robot figure
                if app.index < 2
                    warndlg("At least 2 links are needed to plot the robot figure!","Warning");
                    %figHandles = findobj('type', 'figure', '-not', 'name', 'Figure 1');
                    close(figure(1));
                end
                
                % Remove last row from table and in data
                app.base_vector = app.base_vector(1:end-1,:);
                app.quaternion_0 = app.quaternion_0(1:end-1,:);
                app.quaternion_vector = app.quaternion_vector(1:end-1,:);
                app.input_data = app.input_data(1:end-1,:);
                app.LinkTable.Data = app.input_data;
                app.DHTable.Data = app.input_data;
                app.index = app.index - 1;
                
                % Add function to control link
                app.DropDown.Items = app.DropDown.Items(1:end-1);
                
                % Update robot figure if the links are >= 2 
                if app.index > 1
                app.move_link = zeros(1, app.index);
                plotLink(app, app.dh_a, app.dh_alpha, app.dh_d, app.dh_tetha, app.move_link);
                end
            end
        end
        
        % Callback function

        % Value changed function: Knob
        function KnobValueChanged(app, event) 
            value = app.Knob.Value;
            if app.DropDown.Value ~= "none"
                x = find(contains(app.DropDown.Items, app.DropDown.Value)) - 1;
                app.move_link(x) = value;
                plotLink(app, app.dh_a, app.dh_alpha, app.dh_d, app.dh_tetha, app.move_link);
            end
            
        end

        % Value changing function: Knob
        function KnobValueChanging(app, event)
            changingValue = event.Value;
            if app.DropDown.Value ~= "none"
                x = find(contains(app.DropDown.Items, app.DropDown.Value)) - 1;
                app.move_link(x) = changingValue;
                plotLink(app, app.dh_a, app.dh_alpha, app.dh_d, app.dh_tetha, app.move_link);
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.902 0.902 0.902];
            app.UIFigure.Position = [100 100 1181 975];
            app.UIFigure.Name = 'Denavit Hartenberg App';
            app.UIFigure.WindowStyle = 'modal';
            app.UIFigure.Resize = 'on';
            app.UIFigure.Scrollable = 'on';

            % Create Panel
            app.Panel = uipanel(app.UIFigure);
            app.Panel.Position = [11 443 309 523];

            % Create baseVectorLabel
            app.baseVectorLabel = uilabel(app.Panel);
            app.baseVectorLabel.HorizontalAlignment = 'center';
            app.baseVectorLabel.FontWeight = 'bold';
            app.baseVectorLabel.Position = [40 491 230 22];
            app.baseVectorLabel.Text = 'BASE COORDINATE SYSTEM VECTOR';

            % Create xEditFieldLabel
            app.xEditFieldLabel = uilabel(app.Panel);
            app.xEditFieldLabel.FontWeight = 'bold';
            app.xEditFieldLabel.Position = [33 441 25 22];
            app.xEditFieldLabel.Text = 'x :';

            % Create xEditField
            app.xEditField = uieditfield(app.Panel, 'numeric');
            app.xEditField.Position = [73 441 194 22];

            % Create yEditFieldLabel
            app.yEditFieldLabel = uilabel(app.Panel);
            app.yEditFieldLabel.FontWeight = 'bold';
            app.yEditFieldLabel.Position = [33 391 25 22];
            app.yEditFieldLabel.Text = 'y :';

            % Create yEditField
            app.yEditField = uieditfield(app.Panel, 'numeric');
            app.yEditField.Position = [73 391 194 22];

            % Create zEditFieldLabel
            app.zEditFieldLabel = uilabel(app.Panel);
            app.zEditFieldLabel.FontWeight = 'bold';
            app.zEditFieldLabel.Position = [32 341 25 22];
            app.zEditFieldLabel.Text = 'z :';

            % Create zEditField
            app.zEditField = uieditfield(app.Panel, 'numeric');
            app.zEditField.Position = [72 341 194 22];

            % Create QuaternionOrientationLabel
            app.QuaternionOrientationLabel = uilabel(app.Panel);
            app.QuaternionOrientationLabel.HorizontalAlignment = 'center';
            app.QuaternionOrientationLabel.FontWeight = 'bold';
            app.QuaternionOrientationLabel.Position = [71 291 169 22];
            app.QuaternionOrientationLabel.Text = 'QUATERNION ORIENTATION';

            % Create q0EditFieldLabel
            app.q0EditFieldLabel = uilabel(app.Panel);
            app.q0EditFieldLabel.FontWeight = 'bold';
            app.q0EditFieldLabel.Position = [32 241 27 22];
            app.q0EditFieldLabel.Text = 'q0 :';

            % Create q0EditField
            app.q0EditField = uieditfield(app.Panel, 'numeric');
            app.q0EditField.Position = [72 241 195 22];

            % Create q1EditFieldLabel
            app.q1EditFieldLabel = uilabel(app.Panel);
            app.q1EditFieldLabel.FontWeight = 'bold';
            app.q1EditFieldLabel.Position = [33 191 27 22];
            app.q1EditFieldLabel.Text = 'q1 :';

            % Create q1EditField
            app.q1EditField = uieditfield(app.Panel, 'numeric');
            app.q1EditField.Position = [73 191 194 22];

            % Create q2EditFieldLabel
            app.q2EditFieldLabel = uilabel(app.Panel);
            app.q2EditFieldLabel.FontWeight = 'bold';
            app.q2EditFieldLabel.Position = [33 141 27 22];
            app.q2EditFieldLabel.Text = 'q2 :';

            % Create q2EditField
            app.q2EditField = uieditfield(app.Panel, 'numeric');
            app.q2EditField.Position = [73 141 194 22];

            % Create q3EditFieldLabel
            app.q3EditFieldLabel = uilabel(app.Panel);
            app.q3EditFieldLabel.FontWeight = 'bold';
            app.q3EditFieldLabel.Position = [32 91 27 22];
            app.q3EditFieldLabel.Text = 'q3 :';

            % Create q3EditField
            app.q3EditField = uieditfield(app.Panel, 'numeric');
            app.q3EditField.Position = [72 91 195 22];

            % Create AddLinkButton
            app.AddLinkButton = uibutton(app.Panel, 'push');
            app.AddLinkButton.ButtonPushedFcn = createCallbackFcn(app, @AddLinkButtonPushed, true);
            app.AddLinkButton.FontWeight = 'bold';
            app.AddLinkButton.Position = [29 13 108 45];
            app.AddLinkButton.Text = 'ADD LINK';

            % Create RemoveLinkButton
            app.RemoveLinkButton = uibutton(app.Panel, 'push');
            app.RemoveLinkButton.ButtonPushedFcn = createCallbackFcn(app, @RemoveLinkButtonPushed, true);
            app.RemoveLinkButton.FontWeight = 'bold';
            app.RemoveLinkButton.Position = [167 14 103 45];
            app.RemoveLinkButton.Text = 'REMOVE LINK';

            % Create Panel_2
            app.Panel_2 = uipanel(app.UIFigure);
            app.Panel_2.Position = [330 715 841 251];

            % Create LinkDataTableLabel
            app.LinkDataTableLabel = uilabel(app.Panel_2);
            app.LinkDataTableLabel.FontWeight = 'bold';
            app.LinkDataTableLabel.Position = [12 219 110 22];
            app.LinkDataTableLabel.Text = 'LINK DATA TABLE';

            % Create LinkTable
            app.LinkTable = uitable(app.Panel_2);
            app.LinkTable.ColumnName = {'x'; 'y'; 'z'; 'q0'; 'q1'; 'q2'; 'q3'};
            app.LinkTable.RowName = 'numbered';
            app.LinkTable.Position = [12 19 820 185];

            % Create Panel_3
            app.Panel_3 = uipanel(app.UIFigure);
            app.Panel_3.Position = [330 442 841 262];

            % Create DHTableLabel
            app.DHTableLabel = uilabel(app.Panel_3);
            app.DHTableLabel.FontWeight = 'bold';
            app.DHTableLabel.Position = [12 230 269 22];
            app.DHTableLabel.Text = 'DENAVIT HARTENBERG PARAMETER TABLE';

            % Create DHTable
            app.DHTable = uitable(app.Panel_3);
            app.DHTable.ColumnName = {'a'; 'alpha'; 'd'; 'theta'};
            app.DHTable.RowName = 'numbered';
            app.DHTable.Position = [12 14 820 201];

            % Create Panel_4
            app.Panel_4 = uipanel(app.UIFigure);
            app.Panel_4.Position = [331 13 841 417];
            
            % Create UIAxes
            %app.UIAxes = uiaxes(app.Panel_4);
            %xlabel(app.UIAxes, 'X')
            %ylabel(app.UIAxes, 'Y')
            %zlabel(app.UIAxes, 'Z')
            %app.UIAxes.Position = [11 4 823 488];

            % Create LinkFigureLabel
            %app.LinkFigureLabel = uilabel(app.Panel_4);
            %app.LinkFigureLabel.FontWeight = 'bold';
            %app.LinkFigureLabel.Position = [387 484 100 22];
            %app.LinkFigureLabel.Text = 'ROBOT FIGURE';
            
            % Create HOWTOUSELabel
            app.HOWTOUSELabel = uilabel(app.Panel_4);
            app.HOWTOUSELabel.FontWeight = 'bold';
            app.HOWTOUSELabel.Position = [383 375 83 22];
            app.HOWTOUSELabel.Text = 'HOW TO USE';

            % Create InsertthevalueforbasecoordinatesystemvectorxyzLabel
            app.InsertthevalueforbasecoordinatesystemvectorxyzLabel = uilabel(app.Panel_4);
            app.InsertthevalueforbasecoordinatesystemvectorxyzLabel.VerticalAlignment = 'top';
            app.InsertthevalueforbasecoordinatesystemvectorxyzLabel.Position = [38 283 768 75];
            app.InsertthevalueforbasecoordinatesystemvectorxyzLabel.Text = {'1. Insert the value for base coordinate system vector (x, y, and z).'; '2. Insert the value for quaternion orientation (q0, q1, q2, and q3).'; '3. Then, click the "ADD LINK" button to insert the new link.'; '4. To remove the unwanted link, click the "REMOVE LINK" button.'; '5. To control the listed link, please select the desired link from drop down list, then adjust the knob to the desired value.'};

            % Create Image
            app.Image = uiimage(app.Panel_4);
            app.Image.Position = [38 81 745 186];
            app.Image.ImageSource = 'InputSample.JPG';

            % Create InsertthevalueforbasecoordinatesystemvectorxyzLabel_2
            app.InsertthevalueforbasecoordinatesystemvectorxyzLabel_2 = uilabel(app.Panel_4);
            app.InsertthevalueforbasecoordinatesystemvectorxyzLabel_2.VerticalAlignment = 'top';
            app.InsertthevalueforbasecoordinatesystemvectorxyzLabel_2.Position = [38 34 780 27];
            app.InsertthevalueforbasecoordinatesystemvectorxyzLabel_2.Text = {'Developed by: '; 'Danial Haris Limi Hawari, Davin Farrell Lukito, Ong Kai Li.'};
            
            % Create Panel_5
            app.Panel_5 = uipanel(app.UIFigure);
            app.Panel_5.Position = [11 13 309 417];

            % Create LinkControlLabel
            app.LinkControlLabel = uilabel(app.Panel_5);
            app.LinkControlLabel.FontWeight = 'bold';
            app.LinkControlLabel.Position = [107 375 96 22];
            app.LinkControlLabel.Text = 'LINK CONTROL';

            % Create DropDown
            app.DropDown = uidropdown(app.Panel_5);
            app.DropDown.Items = {'none'};
            app.DropDown.Position = [32 323 236 22];
            app.DropDown.Value = 'none';

            % Create Knob
            app.Knob = uiknob(app.Panel_5, 'continuous');
            app.Knob.Limits = [-3.142 3.142];
            app.Knob.MajorTicks = [-3.142 -2.442 -1.742 -1.042 -0.342 0 0.358 1.058 1.758 2.458 3.142];
            app.Knob.ValueChangedFcn = createCallbackFcn(app, @KnobValueChanged, true);
            app.Knob.ValueChangingFcn = createCallbackFcn(app, @KnobValueChanging, true);
            app.Knob.Position = [67 81 164 164];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = MAIN_GUI

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            %runStartupFcn(app, @startupFcn)

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

