function ts_events = get_objectevents(text_file)

% [ts_events] = get_objectevents(text_file);
%
% - This function takes an events text file (the result of a Unity
% "replay") and extracts the times of each important event.
% - The INPUT text_file should be the filename of the events text file.
% It is usually something like "post-3DS-1-1.txt".
% - To create the events text file, open the .edf file created during a
% 3D Search (3DS) experiment and select "Generate Report --> Recording
% event sequence data" from the menu, then use that text file as input to
% the Unity ReplayScene.
% - The OUTPUT ts_events will be an nx2 matrix, where n is the number of
% events.  The first column is the timestamp of the event, and the second
% column is the event number (see Numbers.js for the meaning of these
% codes).
% - The OUTPUT starttime will be the timestamp of the start of recording.
% Events viewed in DataViewer will have times <timestamp> - <starttime>.
%
% Created 7/22/10 by DJ.

GetNumbers;

% Setup
fid = fopen(text_file);
fseek(fid,0,'eof'); % find end of file
eof = ftell(fid);
fseek(fid,0,'bof'); % rewind to beginning

word = 'time'; % the word we check for to find real events
ts_events = [];%repmat(NaN,1000,2); %each row is timestamp, event
i = 0;          % number of messages found so far

% Get the event messages
while ftell(fid) < eof % if we haven't reached the end of the text file
    str = fgetl(fid); % read in next line of text file
    if findstr(str,word); % check for the code-word indicating a message was written
        i = i+1; % increment number of messages found
        values = textscan(str,'%s\t%d\t%*s\t%d','Delimiter','\t'); % read timestamp and message numbers into ts_events
        msg_type = values{1}{1};
        obj_num = values{2};
        ts_events(i,1) = values{3}; %event timestamp
        if strcmp(msg_type,'Enter Object')
            ts_events(i,2) = Numbers.ENTERS + obj_num;
        elseif strcmp(msg_type,'Exit Object')
            ts_events(i,2) = Numbers.EXITS + obj_num;    
        elseif strcmp(msg_type,'Saccade to Object')
            ts_events(i,2) = Numbers.SACCADE_TO + obj_num;
        else % unknown event - forget this happened!
            warning(sprintf('Unknown event found at time %d - check format!',values{3}));
            ts_events(i,:) = [];
            i=i-1;
        end
    end
end

%ts_events = ts_events(1:i,:);

% Did we find any messages?
if numel(ts_events) == 0 % if no
    warning(sprintf('Couldn''t find ''%s'' anywhere in document ''%s''!'...
        ,word,text_file))
end

% Clean up
fclose(fid);
