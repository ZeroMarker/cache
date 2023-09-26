Class DHCEPRFS.web.eprajax.AjaxEstimatePages Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("Action",1),"")
	s episodeID = $Get(%request.Data("EpisodeID",1),"")
	s cardNo = $Get(%request.Data("CardNo",1),"")
	s regNo = $Get(%request.Data("RegNo",1),"")
	s medRecordID = $Get(%request.Data("MedRecordID",1),"")
	s userID = $Get(%request.Data("UserID",1),"") 
	s unitPrice = $Get(%request.Data("UnitPrice",1),"") 
	s totalPages = $Get(%request.Data("TotalPages",1),"") 
	s totalPrice = $Get(%request.Data("TotalPrice",1),"") 
	s estimatePagesDetail = $Get(%request.Data("EstimatePagesDetail",1),"") 
	
	if (action = "itemlist")
	{
		do ..GetItemList(episodeID)
	}
	elseif (action = "getpatinfo")
	{
		do ..GetPatInfoByCardNo(cardNo)
	}
	elseif (action = "episodelist")
	{
		d ..GetEPREpisodeListJSON(regNo, medRecordID)
	}
	elseif (action = "savelog")
	{
		d ..SaveLog(episodeID,userID,unitPrice,totalPages,totalPrice,estimatePagesDetail)
	}

	Quit $$$OK
}

ClassMethod SaveLog(AEpisodeID As %String, AUserID As %String, AUnitPrice As %String, ATotalPages As %String, ATotalPrice As %String, AEstimatePagesDetail As %String)
{
	s ret = ##class(DHCEPRFS.BL.BLEstimatePages).SaveLog(AEpisodeID,AUserID,AUnitPrice,ATotalPages,ATotalPrice,AEstimatePagesDetail)
	w ret
}

/// Debug:	d ##Class(DHCEPRFS.web.eprajax.AjaxEstimatePages).GetEPREpisodeListJSON("","C999000")
ClassMethod GetEPREpisodeListJSON(ARegNo As %String, AMedRecordNo As %String)
{
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLEstimatePages:GetPatientList")
	s sc = result.Execute(ARegNo,AMedRecordNo)
	
 	s count = 0
 	s first = 1
 	w "{""rows"":["
 	
	While (result.Next())
 	{
	 	s count = count + 1		

		if ((count > 1)&&(first '= 1)) w ","
		w "{"
		w ..TrimEnter("""PAStatusType"":"""_$g(result.Data("PAStatusType"))_""",")
		w ..TrimEnter("""PAStatusTypeDesc"":"""_$g(result.Data("PAStatusTypeDesc"))_""",")
		w ..TrimEnter("""PAAdmType"":"""_$g(result.Data("PAAdmType"))_""",")
		w ..TrimEnter("""PAPMIName"":"""_$g(result.Data("PAPMIName"))_""",")
		w ..TrimEnter("""PAPMINO"":"""_$g(result.Data("PAPMINO"))_""",")			
		w ..TrimEnter("""PAPMIDOB"":"""_$g(result.Data("PAPMIDOB"))_""",")
		w ..TrimEnter("""PAPMIAge"":"""_$g(result.Data("PAPMIAge"))_""",")
		w ..TrimEnter("""PAPMISex"":"""_$g(result.Data("PAPMISex"))_""",")
		w ..TrimEnter("""PAAdmDateTime"":"""_$g(result.Data("PAAdmDateTime"))_""",")
		w ..TrimEnter("""PAAdmWard"":"""_$g(result.Data("PAAdmWard"))_""",")
		w ..TrimEnter("""PAAdmRoom"":"""_$g(result.Data("PAAdmRoom"))_""",")
		w ..TrimEnter("""PAAdmBed"":"""_$g(result.Data("PAAdmBed"))_""",")
		w ..TrimEnter("""PAAdmLoc"":"""_$g(result.Data("PAAdmLoc"))_""",")			
		w ..TrimEnter("""PADischgeDateTime"":"""_$g(result.Data("PADischgeDateTime"))_""",")
		w ..TrimEnter("""PAAdmDoc"":"""_$g(result.Data("PAAdmDoc"))_""",")
		w ..TrimEnter("""PayMode"":"""_$g(result.Data("PayMode"))_""",")
		w ..TrimEnter("""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""",")
		w ..TrimEnter("""PatientID"":"""_$g(result.Data("PatientID"))_"""")
		w "}"
		s first = 0
	}
	w "],""total"":"_count_"}"
}

/// debug: d ##class(DHCEPRFS.web.eprajax.AjaxEstimatePages).GetPatInfoByCardNo(286577879)
ClassMethod GetPatInfoByCardNo(ACardNo As %String)
{
	s ret =  ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPatientIDByCardNo(ACardNo)
	s code = $p(ret,"^",1)
	if (code '= "-200")
	{
		s patientID = $p(ret,"^",2)
		s regNo = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetRegNo(patientID)
		s medRecordNo = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetMedRecordNo(patientID)
		w code_"^"_patientID_"^"_regNo_"^"_medRecordNo
	}
	else
	{
		w code	
	}
}

/// debug: d ##class(DHCEPRFS.web.eprajax.AjaxEstimatePages).GetItemList(524)
ClassMethod GetItemList(AEpisodeID) As %String
{
	s result = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLEstimatePages:GetItem")
	s sc = result.Execute(AEpisodeID)
	
 	s count = 0
 	s first = 1
 	
 	s totalPages = 0
 	s totalPrice = 0
 	s unitPrice = 0 
 	w "{""rows"":["
 	
	While (result.Next())
 	{
	 	s count = count + 1		

		if ((count > 1)&&(first '= 1)) w ","
		w "{"
		w ..TrimEnter("""ItemID"":"""_$g(result.Data("ItemID"))_""",")
		w ..TrimEnter("""ItemCode"":"""_$g(result.Data("ItemCode"))_""",")
		w ..TrimEnter("""ItemName"":"""_$g(result.Data("ItemName"))_""",")
		w ..TrimEnter("""ItemDesc"":"""_$g(result.Data("ItemDesc"))_""",")
		w ..TrimEnter("""TypeParam"":"""_$g(result.Data("TypeParam"))_""",")
		w ..TrimEnter("""Type"":"""_$g(result.Data("Type"))_""",")
		w ..TrimEnter("""UnitPrice"":"""_$g(result.Data("UnitPrice"))_""",")
		w ..TrimEnter("""Pages"":"""_$g(result.Data("Pages"))_""",")
		w ..TrimEnter("""SubTotal"":"""_$g(result.Data("SubTotal"))_"""")
		w "}"
		
		s unitPrice = $g(result.Data("UnitPrice"))
		s totalPages = totalPages + (+$g(result.Data("Pages")))
		s totalPrice = totalPrice + (+$g(result.Data("SubTotal")))
		s first = 0
	}
	w "],""total"":"_count_",""footer"":[{""ItemCode"":""Summary"",""ItemName"":""总计"",""UnitPrice"":"""_unitPrice_""",""Pages"":"""_totalPages_""",""SubTotal"":"""_totalPrice_"""}]}"
}

ClassMethod TrimEnter(AInput As %String) As %String
{
	s ret = $TR(AInput,$C(13),"")
	s ret = $TR(ret,$C(10),"")
	q ret
}

}
