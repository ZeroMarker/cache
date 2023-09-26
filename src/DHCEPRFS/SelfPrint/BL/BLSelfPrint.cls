Class DHCEPRFS.SelfPrint.BL.BLSelfPrint Extends %RegisteredObject [ ProcedureBlock ]
{

/// w ##Class(DHCEPRFS.SelfPrint.BL.BLSelfPrint).GetPrintPurpose()
ClassMethod GetPrintPurpose(APrintPurposeID As %String) As %String
{
	q:(APrintPurposeID = "") ""
	s ret = ""
	s obj = ##Class(DHCEPRFS.SelfPrint.META.PrintPurposes).%OpenId(APrintPurposeID)
	s printPurposeDesc = obj.Name
	s printPurposeCode = obj.Code
	s ret = printPurposeCode_"^"_printPurposeDesc
	q ret
}

/// w ##Class(DHCEPRFS.SelfPrint.BL.BLSelfPrint).SaveTextCode()
ClassMethod SaveTextCode(ACode As %String, APhoneNo As %String, AIDCardNo As %String, ARegNo As %String, AMRPatientID As %String, AClientIP As %String, ATerminalName As %String) As %String
{
	s obj = ##Class(DHCEPRFS.SelfPrint.INST.TextCode).%New()
	s obj.ClientIP = AClientIP
	s obj.Code = ACode
	s obj.IDCardNo = AIDCardNo
	s obj.RegNo = ARegNo
	s obj.MRPatientID = AMRPatientID
	s obj.PhoneNo = APhoneNo
	s obj.ServerDate = $p($h,",",1)
	s obj.ServerTime = $p($h,",",2)
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q obj.%Id()		
	}
	else
	{
		q "-1"
	}
}

/// Debug:	w ##Class(DHCEPRFS.SelfPrint.BL.BLSelfPrint).GetMRPatient("500301")
ClassMethod GetMRPatient(ARegNo As %String)
{
	s mrPatientID =""
	s mrPatientID =$o(^DHCEPRFS.INST.MRPatientI("IdxRegNo"," "_ARegNo,""))
	q:(mrPatientID ="") "-1"
	s obj = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
	s regNo = obj.RegNo
	s phoneNo = obj.PhoneNo
	q:(phoneNo ="") "-1"
	
	q mrPatientID_"^"_phoneNo_"^"_regNo
}

/// w ##Class(DHCEPRFS.SelfPrint.BL.BLSelfPrint).SaveClientLog()
ClassMethod SaveClientLog(ALogType As %String, AClientIP As %String, AClientOS As %String, ACode As %String, AErrMsg As %String, AInfoMsg As %String, ALocalDateTime As %String, AMachineName As %String, ASource As %String, AStackTrace As %String, ATargetSite As %String, AVersion As %String, AWorkDirectory As %String) As %String
{
	s obj = ##Class(DHCEPRFS.SelfPrint.INST.ClientLog).%New()
	s obj.LogType = ALogType
	s obj.ClientIP = AClientIP
	s obj.ClientOS = AClientOS
	s obj.Code = ACode
	s obj.ErrMsg = AErrMsg
	s obj.InfoMsg = AInfoMsg
	s obj.LocalDateTime = ALocalDateTime
	s obj.MachineName = AMachineName
	s obj.ServerDate = $p($h,",",1)
	s obj.ServerTime = $p($h,",",2)
	s obj.Source = ASource
	s obj.StackTrace = AStackTrace
	s obj.TargetSite = ATargetSite
	s obj.Version = AVersion
	s obj.WorkDirectory = AWorkDirectory
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q obj.%Id()		
	}
	else
	{
		q "-1"
	}
}

/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.SelfPrint.BL.BLSelfPrint","GetMRVerItemList","6")
Query GetMRVerItemList(AMREpisodeID As %String) As %Query(ROWSPEC = "MRVerItemID:%String,MRItemName:%String,MRItemCode:%String,MRItemDescription:%String,MRItemType:%String,MRItemTypeParams:%String,MRVersionID:%String,MRItemID:%String,TotCount:%String,CreateDate:%String,CreateTime:%String,ModifyDate:%String,ModifyTime:%String")
{
}

ClassMethod GetMRVerItemListExecute(ByRef qHandle As %Binary, AMREpisodeID As %String) As %Status
{
    set repid=$I(^CacheTemp)
    set ind = 1
    set qHandle = $lb(0,repid,0)
    
	s:(AMREpisodeID = $c(0)) AMREpisodeID = ""
	q:(AMREpisodeID = "") $$$OK
	
	s mrVersionID = ""
	s mrVersionID = $o(^DHCEPRFS.INST.MRVersionI("IdxMain"," "_AMREpisodeID,"0", mrVersionID))
	q:(mrVersionID = "") $$$OK
	
	s schemeID = ##Class(DHCEPRFS.BL.BLSysOption).GetValueByName("SelfPrintSchemeID")
	s scheme = ##Class(DHCEPRFS.META.PrintScheme).%OpenId(schemeID)
	q:(scheme = "") $$$OK
	s mrItemIDs = scheme.SchemeItems

	for index=1:1:$l(mrItemIDs,"^")
	{
		s mrItemID = $p($p(mrItemIDs,"^",index),"#",3)
		
		s mrVerItemID = $O(^DHCEPRFS.INST.MRVerItemI("IdxMain", " "_mrVersionID, " "_mrItemID, ""))
		continue:(mrVerItemID = "")
		
		s objMRVerItem = ##Class(DHCEPRFS.INST.MRVerItem).%OpenId(mrVerItemID)
		continue:(objMRVerItem = "")
		
		s MRVersionID = mrVersionID
		s MRItemID = objMRVerItem.MRItemID
		s MRVerItemID = mrVerItemID
		s TotCount = objMRVerItem.TotCount
		s CreateDate = $zd( objMRVerItem.CreateDate,3)
		s CreateDTime = $zt( objMRVerItem.CreateTime,1)
		s ModifyDate = $zd( objMRVerItem.ModifyDate,3)
		s ModifyTime = $zt( objMRVerItem.ModifyTime,1)
		
		s MRItemEntity = ##class(DHCEPRFS.BL.BLMRItem).GetItemByID(MRItemID)
		s MRItemName = MRItemEntity.Name
		s MRItemCode = MRItemEntity.Code
		s MRItemDescription = MRItemEntity.Description
		s MRItemType = MRItemEntity.Type
		s MRItemTypeParams = MRItemEntity.TypeParams
	
		s ^CacheTemp(repid,ind) = $lb(MRVerItemID,MRItemName,MRItemCode,MRItemDescription,MRItemType,MRItemTypeParams,MRVersionID,MRItemID,TotCount,CreateDate,CreateTime,ModifyDate,ModifyTime)
		s ind=ind+1 
	}
    
    q $$$OK
}

ClassMethod GetMRVerItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRVerItemListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMRVerItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRVerItemListExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.SelfPrint.BL.BLSelfPrint","GetPrintPurposes")
Query GetPrintPurposes() As %Query(ROWSPEC = "PPID:%String,Code:%String,Name:%String,Order:%String")
{
}

ClassMethod GetPrintPurposesExecute(ByRef qHandle As %Binary) As %Status
{
    set repid=$I(^CacheTemp)
    set ind = 1
    set qHandle = $lb(0,repid,0)
 
	s order = ""
	for {
		s order = $o(^DHCEPRFS.META.SP.PrintPurposesI("IdxOrder",order))
		q:(order = "")
		
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.META.SP.PrintPurposesI("IdxOrder",order,rowID))
			q:(rowID = "")	
				
			s obj = ##class(DHCEPRFS.SelfPrint.META.PrintPurposes).%OpenId(rowID)
			s code = obj.Code
			s name = obj.Name
			s orderNum = obj.OrderNum
			s active = obj.IsActive
			continue:(active '= "Y")
			
			s ^CacheTemp(repid,ind) = $lb(rowID,code,name,orderNum)
			s ind = ind + 1
		}
	}
    
    q $$$OK
}

ClassMethod GetPrintPurposesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPrintPurposesExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPrintPurposesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPrintPurposesExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##Class(DHCEPRFS.SelfPrint.BL.BLSelfPrint).CheckIDCard()
ClassMethod CheckIDCard(AIDCardNo As %String) As %String
{
	s ret = ""
	s mrPatientID = ""
	for {
		s mrPatientID = $o(^DHCEPRFS.INST.MRPatientI("IdxIDCard"," "_$zcvt(AIDCardNo,"U"),mrPatientID))
		q:(mrPatientID = "")
		if (ret = "")
		{
			s ret = mrPatientID	
		}
		else
		{
			s ret = ret_"^"_mrPatientID	
		}
	}
	q ret
}

/// w ##Class(DHCEPRFS.SelfPrint.BL.BLSelfPrint).GetPatientInfo("11")
ClassMethod GetPatientInfo(AMRPatientID As %String)
{
	s length = $l(AMRPatientID,"^")
	if (length >1)
	{
		s AMRPatientID = $p(AMRPatientID,"^",length)	
	}
	
	s objMRPatient = ##class(DHCEPRFS.INST.MRPatient).%OpenId(AMRPatientID)
	s Name = objMRPatient.Name
	s idCardNo = objMRPatient.IDCard
	s phoneNo = objMRPatient.PhoneNo
	q Name_"^"_idCardNo_"^"_phoneNo
}

/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.SelfPrint.BL.BLSelfPrint","GetEpisodeList","11")
Query GetEpisodeList(AMRPatientID As %String) As %Query(ROWSPEC = "MedRecordNo:%String,DisLoc:%String,DisDate:%String,AdmLoc:%String,AdmDate:%String,EpisodeID:%String,MREpisodeID:%String,PrintFlag:%String")
{
}

ClassMethod GetEpisodeListExecute(ByRef qHandle As %Binary, AMRPatientID As %String) As %Status
{
  	set repid=$I(^CacheTemp)
    set ind = 1
    set qHandle = $lb(0,repid,0)
    
    k ^CacheTemp(repid,"dhceprfs","selfprint","GetEpisodeList")
    
	s:(AMRPatientID = $c(0)) AMRPatientID = ""
	q:(AMRPatientID = "") $$$OK
	s standardDate = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("PrintStandardDate")
	s:(standardDate="") standardDate= "2017-01-01"
	s standardDate = $zdh(standardDate,3)
		
	s length = $l(AMRPatientID,"^")
	
	for index=1:1:length
	{
		s mrPatientID = $p(AMRPatientID,"^",index)
		
		s mrEpisodeID = ""
		for {
			s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_mrPatientID,mrEpisodeID))
			q:(mrEpisodeID = "")
		
			s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
			q:(objMREpisode = "")
		
			s printFlag="0"
			s medRecordNo = objMREpisode.MedRecordNo
			s admDate = objMREpisode.AdmDate
			s:(admDate '= "") admDate = $zd(admDate,3)
			s disDate = objMREpisode.DisDate
			if (disDate '="")
			{
				if (disDate < standardDate)
				{
					s printFlag ="0"
				}
				else
				{
					s printFlag ="1"
				}
			}
			s:(disDate '= "") disDate = $zd(disDate,3)
			s admLoc = objMREpisode.AdmLoc	
			s disLoc = objMREpisode.DisLoc
			s episodeID = objMREpisode.EpisodeID
			
			if (disDate ="")
			{
				s ^CacheTemp(repid,"dhceprfs","selfprint","GetEpisodeList",standardDate,episodeID) = $lb(medRecordNo,disLoc,"",admLoc,admDate,episodeID,mrEpisodeID,printFlag)
			}
			else
			{
				s ^CacheTemp(repid,"dhceprfs","selfprint","GetEpisodeList",disDate,episodeID) = $lb(medRecordNo,disLoc,disDate,admLoc,admDate,episodeID,mrEpisodeID,printFlag)
			}
			//s ^CacheTemp(repid,ind) = $lb(medRecordNo,disLoc,disDate,admLoc,admDate,episodeID,mrEpisodeID)
			//s ind = ind + 1
		}
	}
	
	s date = ""
	for {
		s date = $o(^CacheTemp(repid,"dhceprfs","selfprint","GetEpisodeList",date),-1)
		q:(date = "")
			
		s episodeID = ""
		for {
			s episodeID = $o(^CacheTemp(repid,"dhceprfs","selfprint","GetEpisodeList",date,episodeID))
			q:(episodeID = "")	
				
			s ^CacheTemp(repid,ind) = ^CacheTemp(repid,"dhceprfs","selfprint","GetEpisodeList",date,episodeID)
			s ind = ind + 1		
		}	
	}
	
	 k ^CacheTemp(repid,"dhceprfs","selfprint","GetEpisodeList")
    
    q $$$OK
}

ClassMethod GetEpisodeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEpisodeListExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
 	Set repid = $LIST(qHandle,2)
 	Set ind = $LIST(qHandle,3)
 	Set ind = $o(^CacheTemp(repid,ind))
 	If ind = "" {				// if there are no more rows, finish fetching
 		Set AtEnd = 1
 		Set Row = ""
 	}
 	Else      {				// fetch row
 		Set Row = ^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetEpisodeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEpisodeListExecute ]
{
	Set repid = $LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Debug:	w ##Class(DHCEPRFS.SelfPrint.BL.BLSelfPrint).GetPhoneNo("110105198601265063")
ClassMethod GetPhoneNo(AIDCardNo As %String)
{
	s mrPatientID =""
	s mrPatientID =$o(^DHCEPRFS.INST.MRPatientI("IdxIDCard"," "_AIDCardNo,""))
	q:(mrPatientID ="") "-1"
	s obj = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
	s regNo = obj.RegNo
	s phoneNo = obj.PhoneNo
	q:(phoneNo ="") "-1"
	
	q mrPatientID_"^"_phoneNo_"^"_regNo
}

}
