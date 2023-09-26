Class EMRservice.Ajax.getLinkLocByLocID Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	s LocID = $Get(%request.Data("LocID",1),"")
	w ..getLinkLocByLocID(LocID)
	Quit $$$OK
}

/// w ##Class(EMRservice.Ajax.getLinkLocByLocID).getLinkLocByLocID("6")
ClassMethod getLinkLocByLocID(ALocID As %String)
{
	s json = "["
	//s count = 0
	s locIDStr = ##class(EMRservice.HISInterface.PatientInfoAssist).CurDeptLinkLocByDept(ALocID)
	s locIDCount = $L(locIDStr,"^")
	for i=3:1:locIDCount-1
	{
		s LocID = $p(locIDStr,"^",i)
		if (LocID '= "")
		{
			s LocDesc = $p($g(^CTLOC(LocID)),"^",2)
			s json = json_"{""LocID"":"""_LocID_""","
			s json = json_"""LocDesc"":"""_LocDesc_"""}"
		 	s json = json_"," 
		}
		//s count = count + 1
	}
	s json = $tr(json,$c(10),"")
	s json = $tr(json,$c(13),"")
	s json = $e(json,1,$l(json)-1)
	s json = json_"]"
	 
	q json
}

}
