Class DHCEPRFS.SelfPrint.web.eprajax.AjaxSelfPrint Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $Get(%request.Data("Action",1),"")
	
	s idCardNo = $Get(%request.Data("IDCardNo",1),"")
	s mrPatientID = $Get(%request.Data("MRPatientID",1),"")
	s mrEpisodeID = $Get(%request.Data("MREpisodeID",1),"")
	s medRecordNo = $Get(%request.Data("MedRecordNo",1),"")
	s regNo = $Get(%request.Data("RegNo",1),"")
	
	if (action = "checkidcard")
	{
		d ..CheckIDCard(idCardNo)
	}
	elseif (action = "getpatientinfo")
	{
		d ..GetPatientInfo(mrPatientID)
	}
	elseif (action = "episodelist")
	{
		d ..GetEpisodeListJSON(mrPatientID)
	}
	elseif (action = "getprintpurposes")
	{
		d ..GetPrintPurposes()	
	}
	elseif (action = "mrveritemlist")
	{
		d ..GetMRVerItemListJSON(mrEpisodeID)	
	}	
	elseif (action = "getmrpatient")
	{
		d ..GetMRPatient(regNo)	
	}
	elseif (action = "getPhoneNo")
	{
		d ..GetPhoneNo(idCardNo)	
	}		
					
	Quit $$$OK
}

/// Debug:	d ##Class(DHCEPRFS.SelfPrint.web.eprajax.AjaxSelfPrint).GetMRPatient("500301")
ClassMethod GetMRPatient(ARegNo As %String)
{
	s ret = ##class(DHCEPRFS.SelfPrint.BL.BLSelfPrint).GetMRPatient(ARegNo)
	w ret
}

/// Debug:	d ##Class(DHCEPRFS.SelfPrint.web.eprajax.AjaxSelfPrint).GetPhoneNo("110105198601265063")
ClassMethod GetPhoneNo(AIDCardNo As %String)
{
	s ret = ##class(DHCEPRFS.SelfPrint.BL.BLSelfPrint).GetPhoneNo(AIDCardNo)
	w ret
}

/// Debug:	d ##Class(DHCEPRFS.SelfPrint.web.eprajax.AjaxSelfPrint).GetMRVerItemListJSON("6")
ClassMethod GetMRVerItemListJSON(AMREpisodeID As %String)
{
	s ^CacheTemp("dhceprfs-debug","2018-06-08","2") = AMREpisodeID
	s result = ##Class(%ResultSet).%New("DHCEPRFS.SelfPrint.BL.BLSelfPrint:GetMRVerItemList")
	s sc = result.Execute(AMREpisodeID)
	
 	s count = 0
 	s first = 1
 	w "{""rows"":["
 	
	While (result.Next())
 	{
	 	s count = count + 1		

		if ((count > 1)&&(first '= 1)) w ","
		w "{"
		w ..TrimEnter("""MRVerItemID"":"""_$g(result.Data("MRVerItemID"))_""",")
		w ..TrimEnter("""MRItemName"":"""_$g(result.Data("MRItemName"))_""",")
		w ..TrimEnter("""MRItemCode"":"""_$g(result.Data("MRItemCode"))_""",")
		w ..TrimEnter("""MRItemDescription"":"""_$g(result.Data("MRItemDescription"))_""",")
		w ..TrimEnter("""MRItemType"":"""_$g(result.Data("MRItemType"))_""",")
		w ..TrimEnter("""MRItemTypeParams"":"""_$g(result.Data("MRItemTypeParams"))_""",")
		w ..TrimEnter("""MRVersionID"":"""_$g(result.Data("MRVersionID"))_""",")
		w ..TrimEnter("""MRItemID"":"""_$g(result.Data("MRItemID"))_""",")
		w ..TrimEnter("""TotCount"":"""_$g(result.Data("TotCount"))_""",")
		w ..TrimEnter("""CreateDate"":"""_$g(result.Data("CreateDate"))_""",")
		w ..TrimEnter("""CreateTime"":"""_$g(result.Data("CreateTime"))_""",")
		w ..TrimEnter("""ModifyDate"":"""_$g(result.Data("ModifyDate"))_""",")
		w ..TrimEnter("""ModifyTime"":"""_$g(result.Data("ModifyTime"))_"""")
		w "}"
		s first = 0
	}
	w "],""total"":"_count_"}"
}

/// Debug:	d ##Class(DHCEPRFS.SelfPrint.web.eprajax.AjaxSelfPrint).GetPrintPurposes()
ClassMethod GetPrintPurposes()
{
	s result = ##Class(%ResultSet).%New("DHCEPRFS.SelfPrint.BL.BLSelfPrint:GetPrintPurposes")
	s sc = result.Execute()
	
 	s count = 0
 	s first = 1
 	w "["
 	
	While (result.Next())
 	{
	 	s count = count + 1		

		if ((count > 1)&&(first '= 1)) w ","
		w "{"
		w ..TrimEnter("""PPID"":"""_$g(result.Data("PPID"))_""",")
		w ..TrimEnter("""Code"":"""_$g(result.Data("Code"))_""",")
		w ..TrimEnter("""Name"":"""_$g(result.Data("Name"))_""",")
		w ..TrimEnter("""Order"":"""_$g(result.Data("Order"))_"""")
		w "}"
		s first = 0
	}
	w "]"
}

/// Debug:	d ##Class(DHCEPRFS.SelfPrint.web.eprajax.AjaxSelfPrint).GetEpisodeListJSON("11")
ClassMethod GetEpisodeListJSON(AMRPatientID As %String)
{
	s result = ##Class(%ResultSet).%New("DHCEPRFS.SelfPrint.BL.BLSelfPrint:GetEpisodeList")
	s sc = result.Execute(AMRPatientID)
	
 	s count = 0
 	s first = 1
 	w "{""rows"":["
 	
	While (result.Next())
 	{
	 	s count = count + 1		

		if ((count > 1)&&(first '= 1)) w ","
		w "{"
		w ..TrimEnter("""MedRecordNo"":"""_$g(result.Data("MedRecordNo"))_""",")
		w ..TrimEnter("""DisLoc"":"""_$g(result.Data("DisLoc"))_""",")
		w ..TrimEnter("""DisDate"":"""_$g(result.Data("DisDate"))_""",")
		w ..TrimEnter("""AdmLoc"":"""_$g(result.Data("AdmLoc"))_""",")
		w ..TrimEnter("""AdmDate"":"""_$g(result.Data("AdmDate"))_""",")
		w ..TrimEnter("""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""",")
		w ..TrimEnter("""PrintFlag"":"""_$g(result.Data("PrintFlag"))_""",")
		w ..TrimEnter("""MREpisodeID"":"""_$g(result.Data("MREpisodeID"))_"""")
		w "}"
		s first = 0
	}
	w "],""total"":"_count_"}"
}

/// Debug:	d ##Class(DHCEPRFS.SelfPrint.web.eprajax.AjaxSelfPrint).CheckIDCard("230103193201190914")
ClassMethod CheckIDCard(AIDCardNo As %String)
{
	//s ^CacheTemp("dhceprfs-debug","2018-06-08","1") = AIDCardNo
	s ret = ##class(DHCEPRFS.SelfPrint.BL.BLSelfPrint).CheckIDCard(AIDCardNo)
	w ret
}

/// Debug:	d ##Class(DHCEPRFS.SelfPrint.web.eprajax.AjaxSelfPrint).GetPatientInfo("11")
ClassMethod GetPatientInfo(AMRPatientID As %String)
{
	s ret = ##class(DHCEPRFS.SelfPrint.BL.BLSelfPrint).GetPatientInfo(AMRPatientID)
	w ret
}

ClassMethod TrimEnter(AInput As %String) As %String
{
	s ret = $TR(AInput,$C(13),"")
	s ret = $TR(ret,$C(10),"")
	q ret
}

}
