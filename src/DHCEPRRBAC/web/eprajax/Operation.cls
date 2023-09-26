Class DHCEPRRBAC.web.eprajax.Operation Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $g(%request.Data("Action",1),"")
	
	if (action = "getop")
	{
		d ..GetOperationJSON()
	}
	
	Quit $$$OK
}

ClassMethod GetOperationJSON()
{
	s result = ##Class(%ResultSet).%New("DHCEPRRBAC.BL.BLOperation:GetOperation")
	s sc = result.Execute()
	
	s count = 0
	s first = 1
	w "["
	
	While (result.Next())
	{
		s count = count + 1
		if ((count > 1)&&(first '= 1)) w ","
		w "{"
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""OperationID"":"""_$g(result.Data("OperationID"))_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""OpName"":"""_$g(result.Data("OpName"))_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""OpCode"":"""_$g(result.Data("OpCode"))_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""OpDesc"":"""_$g(result.Data("OpDesc"))_"""")
		w "}"
		s first = 0
	}
	w "]"
}

}
