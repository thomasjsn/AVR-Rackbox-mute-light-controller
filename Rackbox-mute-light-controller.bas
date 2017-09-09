'--------------------------------------------------------------
'                   Thomas Jensen | uCtrl.io
'--------------------------------------------------------------
'  file: AVR_MUTE_LIGHT_CONTROLLER_v1.0
'  date: 20/04/2006
'--------------------------------------------------------------

$regfile = "attiny2313.dat"
$crystal = 4000000
Config Portd = Input
Config Portb = Output
Config Watchdog = 1024

Dim Lifesignal As Integer
Dim Lystimer As Integer
Dim Muteled As Integer
Dim Door As Integer
Dim A As Byte

Lifesignal = 21
Lystimer = 0
Muteled = 0
Door = 0

Portb = 0                                                   'boot

For A = 1 To 20
    Portb.4 = Not Portb.4
    Portb.6 = Not Portb.6
    Waitms 250
Next A

Waitms 1000
Start Watchdog
Portb = 0

Main:
Portb.2 = Pind.3                                            'door switch
Portb.3 = Not Pind.3

If Pind.2 = 0 And Lystimer = 0 Then Lystimer = 18000        'lights timer
If Pind.2 = 0 And Lystimer < 17975 Then Lystimer = 15
If Pind.3 = 0 Then Lystimer = 0

If Pind.3 = 1 Then
   If Door = 0 Then
      Lystimer = 3000
      Door = 1
      End If
   End If
If Door = 1 And Pind.3 = 0 Then Door = 0

If Lystimer > 0 Then                                        'set light
   Lystimer = Lystimer - 1
   Portb.1 = 1
   End If
If Lystimer = 0 Then Portb.1 = 0

If Pind.1 = 0 Then                                          'mute relay
   If Muteled = 0 Then Muteled = 10
   Portb.0 = 1
   End If
If Pind.0 = 0 Then
   If Muteled = 0 Then Muteled = 5
   Portb.0 = 1
   End If

If Pind.0 = 1 And Pind.1 = 1 Then
   Portb.0 = 0
   End If

If Muteled = 3 Then Portb.4 = 1                             'mute led
If Muteled = 1 Then Portb.4 = 0
If Muteled > 0 Then Muteled = Muteled - 1

If Lifesignal > 0 Then Lifesignal = Lifesignal - 1          'lifesignal
If Lifesignal = 6 Then Portb.5 = 1
If Lifesignal = 1 Then Portb.5 = 0
If Lifesignal = 0 Then Lifesignal = 21

Reset Watchdog                                              'loop cycle
Portb.6 = 1
Waitms 25
Portb.6 = 0
Waitms 75
Goto Main
End