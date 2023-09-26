Class web.eprajax.query.globalcleaner Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s guids = $g(%request.Data("GUIDs",1),"")
	d ..ClearTempGlobal(guids)
	Quit $$$OK
}

ClassMethod ClearTempGlobal(AGUIDs As %String)
{
	q:(AGUIDs = "")
	
	s count = $L(AGUIDs, "^")
	for i = 1:1:count
	{
		s guid = $P(AGUIDs, "^", i)
		continue:(guid = "")
		d ##Class(EPRservice.BLL.Query.BLQueryGlobalMgr).ClearGlobalByGUID(guid)
	}
}

}
