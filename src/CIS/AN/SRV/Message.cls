Class CIS.AN.SRV.Message Extends %CSP.WebSocket
{

Method Server() As %Status
{
   Set timeout=10
   For  {
      Set len=32656
      Set data=..Read(.len, .status, timeout)
      If $$$ISERR(status) {
		If $$$GETERRORCODE(status) = $$$CSPWebSocketClosed {
			Quit
		}
        If $$$GETERRORCODE(status) = $$$CSPWebSocketTimeout {
            Set status=..Write("Server timed-out at "_$Horolog)
        }
      }
      else {
         If data="exit" Quit
         Set status=..Write(data_"test")
      }
   }
   Set status=..EndServer()
   Quit $$$OK
}

}
