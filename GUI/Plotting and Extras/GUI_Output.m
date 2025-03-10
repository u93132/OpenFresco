function GUI_Output(text,title,figtitle,width,height)
%GUI_OUTPUT graphical user interface to display any output
% GUI_Output(text,title,figtitle,width,height)
%
% text     : text to be displayed
% title    : title (optional)
% figtitle : figure title (optional)
% width    : width of window (optional)
% height   : height of window (optional)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                          OpenSees Navigator                          %%
%% Matlab Engineering Toolbox for Analysis of Structures using OpenSees %%
%%                                                                      %%
%%                   Andreas Schellenberg & Tony Yang                   %%
%%        andreas.schellenberg@gmail.com, yangtony2004@gmail.com        %%
%%                                                                      %%
%%    Department of Civil and Environmental Engineering, UC Berkeley    %%
%%   (C) Copyright 2004, The Regents of the University of California    %%
%%                         All Rights Reserved                          %%
%%                                                                      %%
%%   Commercial use of this program without express permission of the   %%
%%     University of California, Berkeley, is strictly prohibited.      %%
%%     See Help -> OpenSees Navigator Disclaimer for information on     %%
%%  usage and redistribution,  and for a DISCLAIMER OF ALL WARRANTIES.  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% $Revision: 409 $
% $Date: 2010-09-22 22:52:11 -0700 (Wed, 22 Sep 2010) $
% $URL: $ 

% set some default parameters
if nargin<2
   title    = 'Output';
   figtitle = 'Output';
   width    = 0.60;
   height   = 0.50;
elseif nargin<3
   figtitle = 'Output';
   width    = 0.60;
   height   = 0.50;
elseif nargin<4
   width    = 0.60;
   height   = 0.50;
elseif nargin<5
   width    = 0.60;
end

% load the preferences from file
load(which('OSNPreferences.mat'));

%%%%%%%%%%%%%%%%%%%%%%
% Figure properties
%%%%%%%%%%%%%%%%%%%%%%
SS = get(0,'screensize');
CreateWindow('cen',width*SS(4)/3*4,height*SS(4));
set(gcf,'Color',Preferences.Global.Window.Color, ...
   'MenuBar','none', ...
   'NumberTitle','off', ...
   'Name',figtitle, ...
   'Tag','GUIOutput');

% define some normalized parameters to partition the figure
dy = 0.04;  % distance between each block
dx = 0.02;
Y = 0.9;

%%%%%%%%%%%%%%%%%%%%%%
% Title text
%%%%%%%%%%%%%%%%%%%%%%
width = 1; height = 0.05;
uicontrol('Style','text', ...
   'Units','normalized', ...
   'Position',[0.5-width/2 Y+0.02 width height], ...
   'String',title, ...
   'FontUnits','normalized','FontWeight','bold','FontSize',0.6, ...
   'Horizontal','center', ...
   'BackgroundColor',Preferences.Global.Window.Color, ...
   'ForegroundColor',Preferences.Global.Window.TextColor);

% generate a line to divide the frame
height = 0.001;
uicontrol('Style','frame', ...
   'Units','normalized', ...
   'Position',[0.00 Y 1.00 height], ...
   'BackgroundColor',Preferences.Global.Window.TextColor, ...
   'ForegroundColor',Preferences.Global.Window.TextColor);
Y = Y - height;

%%%%%%%%%%%%%%%%%%%%%%
% Output window
%%%%%%%%%%%%%%%%%%%%%%
width = 1.0-4*dx; height = 0.7;
Control(1) = uicontrol( ...
   'Style','edit', ...
   'Units','normalized', ...
   'Position',[2*dx Y-height-dy width height], ...
   'String',text, ...
   'Max',10,'Min',1, ...
   'FontUnits','normalized','FontSize',0.04,'FontName','FixedWidth', ...
   'Horizontal','left', ...
   'BackgroundColor',Preferences.Global.UIControl.Color, ...
   'ForegroundColor',Preferences.Global.UIControl.TextColor);

%%%%%%%%%%%%%%%%%%%%%%
% OK button
%%%%%%%%%%%%%%%%%%%%%%
width2 = 0.1; height = 0.05;
callbackStr = 'close(findobj(''Tag'',''GUIOutput'')); clc;';
uicontrol('Style','pushbutton', ...
   'Units','normalized', ...
   'Position',[0.5-width2/2 dy width2 height], ...
   'String','OK', ...
   'FontUnits','normalized','FontWeight','bold','FontSize',0.5, ...
   'Horizontal','left', ...
   'Callback',callbackStr, ...
   'BackgroundColor',Preferences.Global.UIControl.Color, ...
   'ForegroundColor',Preferences.Global.UIControl.TextColor);

%%%%%%%%%%%%%%%%%%%%%%%
% Save handles 
%%%%%%%%%%%%%%%%%%%%%%%
% create the structure of handles
handles = guihandles(gcf);
handles.Control = Control;

% save the structure of handles
guidata(gcf,handles);
