Class DHCEPRRBAC.web.eprajax.PrivateDomain Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $g(%request.Data("Action",1),"")
	s pageSize = $g(%request.Data("rows",1),"")
	s pageNum = $g(%request.Data("page",1),"")
	s startRow = (pageNum -1)*pageSize + 1
	s endRow = startRow + pageSize -1
	
	s privateDomainID = $g(%request.Data("PrivateDomainID",1),"")
	
	if (action = "getprivatelevel")
	{
		d ..GetPrivateDomainJSON()
	}
	elseif (action = "getitem")
	{
		d ..GetItemByPDDIDJSON(privateDomainID,startRow,endRow)
	}
	
	Quit $$$OK
}

ClassMethod GetItemByPDDIDJSON(APrivateDomainID As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
	s result = ##Class(%ResultSet).%New("DHCEPRRBAC.BL.BLPrivateDomain:GetItemByPDDID")
	s sc = result.Execute(APrivateDomainID)
	
	s count = 0
	s first = 1
	w "{""rows"":["
	
	While (result.Next())
	{
		s count = count + 1
		if (count >= AIdxStart) && (count <= AIdxLast)
		{
			if ((count > 1)&&(first '= 1)) w ","
			w "{"
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PrivateDomainID"":"""_$g(result.Data("PrivateDomainID"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PrivateDomainDesc"":"""_$g(result.Data("PrivateDomainDesc"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PrivateDomainLevel"":"""_$g(result.Data("PrivateDomainLevel"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ResourceItemID"":"""_$g(result.Data("ResourceItemID"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ItemID"":"""_$g(result.Data("ItemID"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ItemName"":"""_$g(result.Data("ItemName"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ItemCode"":"""_$g(result.Data("ItemCode"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ItemDesc"":"""_$g(result.Data("ItemDesc"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ItemType"":"""_$g(result.Data("ItemType"))_""",")
			w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""ItemTypeDesc"":"""_$g(result.Data("ItemTypeDesc"))_"""")
			w "}"
			s first = 0
		}
	}
	w "],""total"":"_count_"}"
}

ClassMethod GetPrivateDomainJSON()
{
	s result = ##Class(%ResultSet).%New("DHCEPRRBAC.BL.BLPrivateDomain:GetPrivateDomain")
	s sc = result.Execute()
	
	s count = 0
	s first = 1
	w "["
	
	While (result.Next())
	{
		s count = count + 1
	 	if ((count > 1)&&(first '= 1)) w ","
		w "{"
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PrivateDomainID"":"""_$g(result.Data("PrivateDomainID"))_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PDDName"":"""_$g(result.Data("PDDName"))_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PDDCode"":"""_$g(result.Data("PDDCode"))_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PDDDesc"":"""_$g(result.Data("PDDDesc"))_""",")
		w ##class(DHCEPRRBAC.Util.Utilization).TrimEnter("""PDDLevel"":"""_$g(result.Data("PDDLevel"))_"""")
		w "}"
		s first = 0
	}
	w "]"
}

}
