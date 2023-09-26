Class web.eprajax.restoreChart Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s EpisodeID = $Get(%request.Data("EpisodeID", 1), "-1")	
	s PatientID = $Get(%request.Data("PatientID", 1), "-1")
	s ListChartItemID = $Get(%request.Data("ListChartItemID", 1), "-1")
	s action = $g(%request.Data("Action",1),"")
	s ID = $g(%request.Data("ID",1),"")
	 
	if action=""
	{
		d ..GetDumpedList(EpisodeID)
	}
	
	if action="IsRestore" 
	{
		w ..AddRestore(ID)
	}
    	
	Quit $$$OK
}

//w ##Class(web.eprajax.Restore).AddRestore("1737||1^1")

ClassMethod GetDumpedList(AEpisodeID As %String) As %String
{
	q:(AEpisodeID="")
	s count=0
	w "["
    s retJson = ..GetDumpedListByEID(AEpisodeID)
    w retJson
	w "]"
	
	//q "1"
}

ClassMethod GetDumpedListByEID(AEpisodeID As %String) As %String
{
	s retJson="" 
	
	s ind = ""
	for  
	{
		s ind = $o(^DHCEPRI.RecInstanceDataI("IdxEpisodeID"," "_AEpisodeID,ind))
		q:ind=""
		s obj = ##Class(EPRinstance.RecInstanceData).%OpenId(ind)
		
		if obj.Status="Restored" CONTINUE
		
		if (retJson '= "") {s retJson = retJson_","}
		
		s retJson = retJson_"{ID:'"_obj.InstanceID_"^"_obj.SeqNo_"'"
		s retJson = retJson_",Title:'"_obj.Title_"'"
		s retJson = retJson_",DumpedDate:'"_$zd(obj.ModifyDate,3)_"'"
		s retJson = retJson_",DumpedTime:'"_$zt(obj.ModifyTime,2)_"'"
		if obj.Status = "Dumped"
		{
			s retJson = retJson_",Status:'"_"已删除"_"'"
		}
		s retJson = retJson_",User:'"_##class(EPRmeta.Privilege.PowerUser).GetUserName(obj.ModifyUser)_"'}"
	}
	
	s retJson = $TR(retJson,$C(13),"")
	s retJson = $TR(retJson,$C(10),"")
		
	Quit retJson
}

ClassMethod AddRestore(ID As %String)
{
	s InstanceID = $p(ID,"^",1)
	s SeqNo = $p(ID,"^",2)
	
	d ##class(EPRservice.BLRecInstanceData).RestoreData(InstanceID,SeqNo)
	Quit 1
}

}
