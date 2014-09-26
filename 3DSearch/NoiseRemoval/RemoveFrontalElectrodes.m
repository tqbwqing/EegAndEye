function RemoveFrontalElectrodes(input_filename,output_filename,filetype)

% Gets rid of frontal electrodes, then saves the result as a new file.
%
% RemoveFrontalElectrodes(input_filename,output_filename,filetype)
%
% INPUTS:
% -input_filename is a string of the input .set file.
% -output_filename is a string of the .set file you want to save.
% -filetype is a string specifying the EEG systme used (currently 
% supported: 'Biosemi' or 'Sensorium').
%
% Created 10/26/10 by DJ.
% Updated 11/2/10 by DJ - removed re-referencing.
% Updated 11/29/10 by DJ - uses RemoveElectrodes now.
% Updated 2/23/11 by DJ - made a function.
% Updated 7/28/11 by DJ - added option for new Sensorium cap (filetype =
% 'Sensorium-2011').
% Updated 10/28/11 by DJ - capitalized all Sensorium-2011 channel names
% Updated 11/8/11 by DJ - added filetype not found error
% Updated 3/29/13 by DJ - added Sensorium-2013 option

%% Select (filetype-specific) frontal electrodes
switch filetype
    case 'Biosemi'
        % chans_toremove = [1 2 34]; % frontmost electrodes only
        % chans_toremove = [1:3 33:37]; % front two rows
        chans_toremove = [1:7 33:42]; % front three rows
    case 'Sensorium-2008'
        chans_toremove = {'Fp1' 'Fpz' 'Fp2' 'AF7' 'AF3' 'AFz' 'AF4' 'AF8' 'F9' 'F7' 'F5' 'F3' 'F1' 'Fz' 'F2' 'F4' 'F6' 'F8' 'F10'}; % front three rows
        %chans_toremove = [1 78 2 61 32 3 33 62 63 4 34 5 35 6 36 7 37 8 64]; % front three rows
    case {'Sensorium-2011' 'Sensorium-2011-50Hz' 'Sensorium-2011-1000Hz' 'Sensorium-2013'}
        chans_toremove = {'NZ' 'FP1' 'FPZ' 'FP2' 'AF7' 'AF5' 'AF3' 'AF1' 'AFZ' 'AF2' 'AF4' 'AF6' 'AF8' 'F9' 'F7' 'F5' 'F3' 'F1' 'FZ' 'F2' 'F4' 'F6' 'F8' 'F10'}; % front three rows
        %chans_toremove = [1 78 2 61 32 3 33 62 63 4 34 5 35 6 36 7 37 8 64]; % front three rows
    otherwise
        error('Filetype %s not recognized!',filetype);
end

%% Remove selected electrodes
RemoveElectrodes(input_filename, output_filename, chans_toremove);