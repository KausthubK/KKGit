function sendCommand(t,command)

%     fprintf(command);
    %Send command to TCPIP port
    fprintf(t,command)

%     %Pause until a message is received
    while(~t.BytesAvailable)
    end
%     %Then flush the input buffer
    flushinput(t)
end