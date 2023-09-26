Class DHCEPRRBAC.web.eprajax.AjaxOutPatientEpisodeView Extends %CSP.Page [ ClassType = "", ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	s action = $g(%request.Data("Action",1),"")
    
    s admNo = $g(%request.Data("AdmNo",1),"")
	s regNo = $g(%request.Data("RegNo",1),"")
	s userID = $g(%request.Data("UserID",1),"")
	s ctLocID = $g(%request.Data("CTLocID",1),"")
	s ssGroupID = $g(%request.Data("SSGroupID",1),"")
	
	if (action = "episodelist")
	{
		//s ^CacheTemp("debug-yang-2016-8-4","1") = regNo_","_admNo_","_userID_","_ctLocID_","_ssGroupID
		d ..GetEPREpisodeListJSON(regNo,admNo,userID,ctLocID,ssGroupID)
	}	
	elseif (action = "getviewparam")
	{
		d ..GetViewParam(admNo)	
	}	
	elseif (action = "patinfo")
	{
		d ..GetPatInfo(regNo)	
	}
	elseif (action = "episodeinfo")
	{
		d ..GetEpisodeInfo(regNo,admNo)	
	}
	Quit $$$OK
}

/// debug: d ##class(DHCEPRRBAC.web.eprajax.AjaxOutPatientEpisodeView).GetPatInfo("00539881")
ClassMethod GetPatInfo(ARegNo As %String)
{
	s ret = ##class(DHCEPRRBAC.BL.HISInfo.BLEpisodeInfo).GetPatientInfo(ARegNo)	
	w ret
}

ClassMethod GetEpisodeInfo(ARegNo As %String, AEpisodeID As %String)
{
	s ret = ##class(DHCEPRRBAC.BL.HISInfo.BLEpisodeInfo).GetPatientInfo(ARegNo,AEpisodeID)	
	w ret
}

/// Debug: d ##Class(DHCEPRRBAC.web.eprajax.AjaxOutPatientEpisodeView).GetViewParam("01962586","")
ClassMethod GetViewParam(AAdmNo As %String) As %String
{
	s MREpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AAdmNo,"DHC")
	
	s roleDID = ""
	s roleDID = $o(^DHCEPRRBAC.INST.OPDRoleI("IdxActive"," Y",roleDID))
	
	s objRoleD = ##class(DHCEPRRBAC.INST.OutPatientDefaultRole).%OpenId(roleDID)
	s roleID = objRoleD.RoleID
	
	s operationID = $o(^DHCEPRRBAC.META.OperDFI("IdxDefaultOp"," Y",""))
	q:(operationID = "") "-3"
	
	s opObj = ##class(DHCEPRRBAC.META.OperationDefinition).%OpenId(operationID)
	s operationCode = opObj.OpCode
	
	s itemIDs = ""
	s sequence = ""
	for {
		s sequence = $o(^DHCEPRRBAC.INST.ResourceRItemI("IdxRoleItem"," "_roleID," "_operationID,sequence))	
		q:(sequence = "")
		s itemID = ""
		for {
			s itemID = $o(^DHCEPRRBAC.INST.ResourceRItemI("IdxRoleItem"," "_roleID," "_operationID,sequence,itemID))
			q:(itemID = "")

			s rowID = ##class(DHCEPRRBAC.Util.Utilization).TrimBlankSpace(itemID)
			s objRI = ##class(DHCEPRRBAC.INST.ResourceItem).%OpenId(rowID)
			s privacyID = objRI.PrivateDomainID
			s itemDID = objRI.ItemID
			s objID = ##class(DHCEPRRBAC.META.ItemDefinition).%OpenId(itemDID)
			s param = objID.ItemCode
			s type = objID.ItemType
			s objP = ##class(DHCEPRRBAC.META.PrivateDomainDefinition).%OpenId(privacyID)
			s privacyLevel = objP.RPDLevel
			
			if (itemIDs = "")
			{
				s itemIDs = privacyLevel_"@"_param_"@"_type
			}	
			else
			{
				s itemIDs = itemIDs_"^"_privacyLevel_"@"_param_"@"_type
			}
		}
	}
	
	s ret = ##class(DHCEPRRBAC.BL.FSInfo.BLScheme).GetVerItemByVersionItemsString(AAdmNo,itemIDs)
	w ret
}

/// Debug: d ##Class(DHCEPRRBAC.web.eprajax.AjaxOutPatientEpisodeView).GetEPREpisodeListJSON("00539881","","2776","1673","1")
ClassMethod GetEPREpisodeListJSON(ARegNo As %String, AAdmNo As %String, AUserID As %String, ACTLocID As %String, ASSGroupID As %String) As %String
{
	s result = ##class(%ResultSet).%New("DHCEPRRBAC.BL.HISInfo.BLEpisodeInfo:GetEpisodeList")
	s sc= result.Execute(ARegNo,AAdmNo,"Y","Y",AUserID,ACTLocID,ASSGroupID)
	
	s count = 0
	s first = 1
	w "{""rows"":["
	
	While (result.Next())
	{
		s count=count+1
		if ((count>1)&&(first '=1)) w ","
		w "{"
		w ..TrimEnter("""EpisodeID"":"""_$g(result.Data("EpisodeID"))_""",")
		w ..TrimEnter("""IsApply"":"""_$g(result.Data("IsApply"))_""",")
		w ..TrimEnter("""IsApplyDesc"":"""_$g(result.Data("IsApplyDesc"))_""",")
		w ..TrimEnter("""PAType"":"""_$g(result.Data("PAAdmType"))_""",")
		w ..TrimEnter("""PAAdmDate"":"""_$g(result.Data("PAAdmDateTime"))_""",")
		s admLoc = ""
		if ($l($g(result.Data("PAAdmLoc")),"-")=1)
		{
			s admLoc=$g(result.Data("PAAdmLoc"))
		}
		else
		{
			s admLoc=$p($g(result.Data("PAAdmLoc")),"-",2)
		}
		w ..TrimEnter("""PAAdmLoc"":"""_admLoc_""",")
		w ..TrimEnter("""PADischgeDate"":"""_$g(result.Data("PADischgeDateTime"))_""",")
		w ..TrimEnter("""PAAdmDoc"":"""_$g(result.Data("PAAdmDoc"))_"""")	
		w "}"
		
		s first = 0
	}
	w "],""total"":"_count_"}"
}

ClassMethod TrimEnter(AInput As %String) As %String
{
	s ret = $TR(AInput,$C(13),"")
	s ret = $TR(ret,$C(10),"")
	q ret
}

}
