Class DHCEPRFS.BL.BLMRMedRecord Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRMedRecord","GetMRMedRecordInfo","Z113935","DHC")
Query GetMRMedRecordInfo(AMedRecordNo As %String, ASysCode As %String) As %Query(ROWSPEC = "IsHIS:%String,MRMedRecordNo:%String,MedRecordNo:%String,MRPatientID:%String,Name:%String,Birthday:%String,Age:%String,Gender:%String,HouseAddress:%String,LinkName:%String,LinkRelation:%String")
{
}

ClassMethod GetMRMedRecordInfoExecute(ByRef qHandle As %Binary, AMedRecordNo As %String, ASysCode As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	q:(AMedRecordNo="") $$$OK
	s AMedRecordNo = $zcvt(AMedRecordNo,"U")
 	
 	s rowID = ""

		s rowID = $o(^DHCEPRFS.INST.MRMedRecordI("IdxMedRecordNo", " "_ASysCode, " "_AMedRecordNo, rowID))
		if (rowID = "")
		{
			//同步查询下HIS	
			s patientID = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPapmiInfo(AMedRecordNo)
			if (patientID '= "")
			{
				//HIS中存在此病案号
				s mrPatientID = ##class(DHCEPRFS.BL.BLMRPatient).RegMRPatByMedRecord(patientID,AMedRecordNo,ASysCode)
				s mrMedRecordID	= ..RegMRMedRecord(mrPatientID, AMedRecordNo,ASysCode)	
				s obj = ##class(DHCEPRFS.INST.MRMedRecord).%OpenId(mrMedRecordID)
			}
			else
			{
				q ""	
			}	
		}
		else
		{
			s mrMedRecordID = rowID	
			s obj = ##class(DHCEPRFS.INST.MRMedRecord).%OpenId(mrMedRecordID)						
		}
		

		s IsHIS = obj.IsHISMedRecord
		s mrPatientID = obj.MRPatientID
		s medRecordNo = obj.MedRecordNo
		s objMRPatient = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
		s Name = objMRPatient.Name
		s Birthday = objMRPatient.Birthday
		if (Birthday '= "")
		{
			s Birthday = $zd(Birthday,3)	
		}
		s Age = objMRPatient.Age
		s Gender = objMRPatient.Gender
		s HouseAddress = objMRPatient.HouseAddress
		s LinkName = objMRPatient.LinkName
		s LinkRelation = objMRPatient.LinkRelation
    	s data = $lb(IsHIS,mrMedRecordID,medRecordNo,mrPatientID,Name,Birthday,Age,Gender,HouseAddress,LinkName,LinkRelation)
		s ^CacheTemp(repid,ind)=data
		s ind=ind+1

	Quit $$$OK
}

ClassMethod GetMRMedRecordInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMRMedRecordInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetMRMedRecordInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMRMedRecordInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

ClassMethod RegMRMedRecord(AMRPatientID As %String, AMedRecordNo As %String, ASysCode As %String = "DHC") As %String
{
	s mrMedRecordID = ""
	s mrMedRecordID = ..GetMRMedRecord(AMedRecordNo, ASysCode)
	
	if (mrMedRecordID = "")
	{
		s mrMedRecordID = ..CreateMRMedRecord(AMRPatientID, AMedRecordNo, ASysCode)
	}
	
	q mrMedRecordID
}

ClassMethod GetMRMedRecord(AMedRecordNo As %String, ASysCode As %String = "DHC") As %String
{
	q:(AMedRecordNo="") ""
	s AMedRecordNo = $zcvt(AMedRecordNo,"U")
	s ret = ""
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.MRMedRecordI("IdxMedRecordNo", " "_ASysCode, " "_AMedRecordNo, rowID))
		q:(rowID = "")
		if (ret = "")
		{
			s ret = rowID	
		}
		else
		{
			s ret = ret_"^"_rowID	
		}
	}
	q ret
}

ClassMethod CreateMRMedRecord(AMRPatientID As %String, AMedRecordNo As %String, ASysCode As %String = "DHC") As %String
{
	s obj = ##class(DHCEPRFS.INST.MRMedRecord).%New()
	s obj.CreateDate = $p($h,",",1)
	s obj.CreateTime = $p($h,",",2)
	s obj.LastModifyDate = $p($h,",",1)
	s obj.LastModifyTime = $p($h,",",2)
	s obj.MedRecordNo = AMedRecordNo
	s obj.MRPatientID = AMRPatientID
	s obj.SysCode = ASysCode
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

/// Desc:病人病案信息列表
/// debug:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMRMedRecord","GetMedRecordInfo")
Query GetMedRecordInfo(AParam As DHCEPRFS.Entity.EPatientInfoQueryPara) As %Query(ROWSPEC = "MRPatientID:%String,PatientID:%String,MRMedRecordID:%String,MedRecordNo:%String,Name:%String,Birthday:%String,Age:%String,Sex:%String,HouseAddress:%String,LinkName:%String,LinkRelation:%String")
{
}

ClassMethod GetMedRecordInfoExecute(ByRef qHandle As %Binary, AParam As DHCEPRFS.Entity.EPatientInfoQueryPara) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	q:(AParam = "") $$$OK

	d GetParam
	if (PName '= "")
	{
		s tmpName = " "_$zcvt(PName,"U")
		while ((tmpName'="")&&(tmpName[PName)) 
		{
		    s MRPatientID = ""
		    for {
		        s MRPatientID = $o(^DHCEPRFS.INST.MRPatientI("IdxName",tmpName,MRPatientID))
	            q:(MRPatientID = "")
	            s flag = $$GetPatientInfo()
	            continue:(flag '= "1")
	            s MRMedRecordID = ""
                for {
	                s MRMedRecordID = $o(^DHCEPRFS.INST.MRMedRecordI("IdxMRPatientID"," "_MRPatientID,MRMedRecordID))
	                q:(MRMedRecordID = "")
	                d GetMedRecordInfo
	                d OutPutInfo
                }  
		    }
		    s tmpName=$o(^DHCEPRFS.INST.MRPatientI("IdxName",tmpName))
		}
	}
	elseif (PIDCard '="")
	{
		s MRPatientID = ""
		for {
			s MRPatientID = $o(^DHCEPRFS.INST.MRPatientI("IdxIDCard"," "_PIDCard,MRPatientID))
		    q:(MRPatientID = "")
		    s flag = $$GetPatientInfo()
	        continue:(flag '= "1")
	        s MRMedRecordID = ""
	        for {
	            s MRMedRecordID = $o(^DHCEPRFS.INST.MRMedRecordI("IdxMRPatientID"," "_MRPatientID,MRMedRecordID))
	            q:(MRMedRecordID = "")
	            d GetMedRecordInfo
	            d OutPutInfo
            }  
		}
	}
	elseif(PNo'="")
	{
		s MRPatientID = ""
		for {
			s MRPatientID = $o(^DHCEPRFS.INST.MRPatientI("IdxRegNo"," "_PNo,MRPatientID))
		    q:(MRPatientID = "")
		    s flag = $$GetPatientInfo()
	        continue:(flag '= "1")
	        s MRMedRecordID = ""
	        for {
	            s MRMedRecordID = $o(^DHCEPRFS.INST.MRMedRecordI("IdxMRPatientID"," "_MRPatientID,MRMedRecordID))
	            q:(MRMedRecordID = "")
	            d GetMedRecordInfo
	            d OutPutInfo
            }   
		}
	}
	elseif(PMedRecordNo'= "")
	{
		s MRMedRecordID = ""
		for {
			s MRMedRecordID = $o(^DHCEPRFS.INST.MRMedRecordI("IdxMedRecordNo"," DHC"," "_PMedRecordNo,MRMedRecordID))
			q:(MRMedRecordID = "")
			s objMRMedRecord = ##class(DHCEPRFS.INST.MRMedRecord).%OpenId(MRMedRecordID)
			s MRPatientID = objMRMedRecord.MRPatientID
			s flag = $$GetPatientInfo()
	    	q:(flag '= "1")
	   		d GetMedRecordInfo
	 		d OutPutInfo	
		}
	}
	
	Quit $$$OK
	
GetPatientInfo()
    s flag = "-1"
    s objPatient = ##Class(DHCEPRFS.INST.MRPatient).%OpenId(MRPatientID)
    s PatientID = objPatient.PatientID
    s Name = objPatient.Name
    q:((PName '="") && ($zcvt(Name,"U") '[ PName)) flag 
    s Birthday = objPatient.Birthday
    q:(AParam.Birthday '= "")&&(AParam.Birthday '= Birthday) flag
    s:(Birthday '= "") Birthday = $zd(Birthday,3)
    s Age = objPatient.Age	
    s Sex = objPatient.Gender
    s HouseAddress = objPatient.HouseAddress
    s LinkName = objPatient.LinkName	
    s LinkRelation = objPatient.LinkRelation
    d objPatient.%Close()
    s flag = "1"
    q flag
GetMedRecordInfo
	if (PMedRecordNo = "")
	{
		s objMRMedRecord = ##class(DHCEPRFS.INST.MRMedRecord).%OpenId(MRMedRecordID)
		s MedRecordNo = objMRMedRecord.MedRecordNo
		d objMRMedRecord.%Close()
	}
	else
	{
		s MedRecordNo = PMedRecordNo	
	}
	q
OutPutInfo 
    s data = $lb(MRPatientID,PatientID,MRMedRecordID,MedRecordNo,Name,Birthday,Age,Sex,HouseAddress,LinkName,LinkRelation)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
    q
GetParam
  	s PName = $zcvt(AParam.Name,"U")
	s PMedRecordNo =  AParam.MedRecordNo
	s PNo = AParam.PatientID
	s PIDCard = AParam.IDCard
	s PAStartDate = AParam.AdmStratDate
	s PAEndDate = AParam.AdmEndDate
	s PDStartDate = AParam.DisStratDate
	s PDEndDate = AParam.DisEndDate
	q
}

ClassMethod GetMedRecordInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMedRecordInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetMedRecordInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMedRecordInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 		kill ^CacheTemp(repid)
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)	
	Quit $$$OK
}

/// debug: w ##class(DHCEPRFS.BL.BLMRMedRecord).AssignExistMRMedRecord("S10000")
ClassMethod AssignExistMRMedRecord(AMedRecordNo As %String)
{
	s $ZTRAP = "OnAssignExistMRMedRecordError"
	TSTART
	s AMedRecordNo = $zcvt(AMedRecordNo,"U")
	s mrPatientID = ##class(DHCEPRFS.BL.BLMRPatient).CreateFSMRPatient()

	if ((+mrPatientID < 0) || (mrPatientID = ""))
	{
		TROLLBACK	
		q "-1"
	}
	
	s ret = ..CreateExistMedRecord(mrPatientID,AMedRecordNo)
	if ((ret = "-1")  || (ret = ""))
	{
		TROLLBACK	
		q "-1"
	}
	
	TCOMMIT
	q mrPatientID_"^"_ret
OnAssignExistMRMedRecordError
	TROLLBACK
	q "-1"
}

ClassMethod AssignMRMedRecord() As %String
{
	s $ZTRAP = "OnAssignMRMedRecordError"
	TSTART
	s mrPatientID = ##class(DHCEPRFS.BL.BLMRPatient).CreateFSMRPatient()
	if ((+mrPatientID < 0) || (mrPatientID = ""))
	{
		TROLLBACK	
		q "-1"
	}
	
	s ret = ..CreateFSMRMedRecord(mrPatientID)
	if ((ret = "-1") || (ret = ""))
	{
		TROLLBACK	
		q "-1"
	}
	
	TCOMMIT
	q mrPatientID_"^"_ret
OnAssignMRMedRecordError
	TROLLBACK
	q "-1"
}

/// debug: w ##class(DHCEPRFS.BL.BLMRMedRecord).AssignNext()
ClassMethod AssignNext() As %String
{
	s rowID = $o(^DHCEPRFS.META.HistoryMPRD(""))
	//需要先初始化分配前缀
	q:(rowID = "") "-3"
	s objPrefix = ##class(DHCEPRFS.META.HistoryMedRecordPrefix).%OpenId(rowID)
	s APrefix = objPrefix.Prefix
	
	s $ZTRAP = "OnAssignNextError"
	TSTART
	s mrPatientID = ##class(DHCEPRFS.BL.BLMRPatient).CreateFSMRPatient()
	if ((+mrPatientID < 0) || (mrPatientID = ""))
	{
		TROLLBACK	
		q "-4"
	}
	
	s ret = ..CreateNext(mrPatientID,APrefix)
	if (ret = "-2")
	{
		//不存在当前病案号，请先分配一个起始号
		TROLLBACK
		q "-2"	
	}
	elseif (ret = "-1")
	{
		//因为唯一锁MedRecordNo不唯一导致（多个用户同时提交分配下一个，当前一个用户已分配并写入表后导致）
		//返回前台处理，随机延时后重新尝试
		TROLLBACK	
		q "-1"
	}
	else
	{
		TCOMMIT
		//mrPatientID^mrMedRecordID^MedRecordNo
		q mrPatientID_"^"_ret
	}
OnAssignNextError
	TROLLBACK
	q "-4"
}

ClassMethod CreateExistMedRecord(AMRPatientID As %String, AMedRecordNo As %String) As %String
{

	s obj = ##class(DHCEPRFS.INST.MRMedRecord).%New()
	s obj.SysCode = "DHC"
	s obj.MRPatientID = AMRPatientID
	s obj.CreateDate = $p($h,",",1)
	s obj.CreateTime = $p($h,",",2)
	s obj.LastModifyDate = $p($h,",",1)
	s obj.LastModifyTime = $p($h,",",2)
	s obj.MedRecordNo = AMedRecordNo
	s obj.IsHISMedRecord = "N"
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()_"^"_AMedRecordNo
	}
	else
	{
		q "-1"
	}
}

ClassMethod CreateFSMRMedRecord(AMRPatientID As %String) As %String
{
	s obj = ##class(DHCEPRFS.INST.MRMedRecord).%New()
	s obj.SysCode = "DHC"
	s obj.MRPatientID = AMRPatientID
	s obj.CreateDate = $p($h,",",1)
	s obj.CreateTime = $p($h,",",2)
	s obj.LastModifyDate = $p($h,",",1)
	s obj.LastModifyTime = $p($h,",",2)
	s obj.IsHISMedRecord = "N"
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		s id =  obj.%Id()
		s medRecordNo = "VM"_id
		s obj.MedRecordNo = medRecordNo
		s status = obj.%Save()
		if ($$$ISOK(status))
		{
			q obj.%Id()_"^"_medRecordNo
		}
		else
		{
			q "-2"	
		}
	}
	else
	{
		q "-1"
	}
}

ClassMethod CreateNext(AMRPatientID As %String, APrefix As %String) As %String
{
	b "s"
	//取上一次最后一个病案号
	s MedRecordNo = ""
	for {
		s MedRecordNo = $o(^DHCEPRFS.INST.MRMedRecordI("IdxMain"," DHC"," N",MedRecordNo),-1)
		//不存在上一个病案号
		q:(MedRecordNo = "")
		//是否前缀一致
		s MedRecordNoTrim = $tr(MedRecordNo," ","")
		s MedRecordNoTrim = $tr(MedRecordNoTrim,$c(0),"")
		continue:($e(MedRecordNoTrim,1,$l(APrefix)) '= APrefix)
		s MedRecordNo = MedRecordNoTrim
		q
	}
	q:(MedRecordNo = "") "-2"
	s Num = $e(MedRecordNoTrim,$l(APrefix)+1,$l(MedRecordNoTrim))
	s NumInteger = +Num + 1
	
	s obj = ##class(DHCEPRFS.INST.MRMedRecord).%New()
	s obj.SysCode = "DHC"
	s obj.MRPatientID = AMRPatientID
	s obj.CreateDate = $p($h,",",1)
	s obj.CreateTime = $p($h,",",2)
	s obj.LastModifyDate = $p($h,",",1)
	s obj.LastModifyTime = $p($h,",",2)
	s obj.IsHISMedRecord = "N"
	s obj.MedRecordNo = APrefix_NumInteger
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()_"^"_APrefix_NumInteger
	}
	else
	{
		q "-1"	
	}
}

/// do ##Class(DHCEPRFS.BL.BLMRMedRecord).DeleteMedRecord("J344356")
ClassMethod DeleteMedRecord(AMedRecordNo As %String) As %String
{
	q:(AMedRecordNo = "") "-1"
	s AMedRecordNo = $zcvt(AMedRecordNo,"u")
	
	s MRMedRecordID = ""
	s MRMedRecordID = $o(^DHCEPRFS.INST.MRMedRecordI("IdxMain"," DHC", " N"," "_AMedRecordNo,MRMedRecordID))
	q:(MRMedRecordID = "") "-1"
	
	s objMRMedRecord = ##class(DHCEPRFS.INST.MRMedRecord).%OpenId(MRMedRecordID)
	s mrPatientID = objMRMedRecord.MRPatientID
	
	s mrEpisodeID = ""
	for {
		s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRMedRecordID"," "_MRMedRecordID,mrEpisodeID))
		q:(mrEpisodeID = "")	
		
		s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
		s EpisodeID = objMREpisode.EpisodeID
		
		d ##class(DHCEPRFS.BL.BLMREpisode).DeleteEpisode(EpisodeID)
		d ##class(DHCEPRFS.INST.MREpisode).%DeleteId(mrEpisodeID)
	}
	
	d ##class(DHCEPRFS.INST.MRMedRecord).%DeleteId(MRMedRecordID)
	
	q:(mrPatientID = "") "-1"
	s objMRPatient = ##class(DHCEPRFS.INST.MRPatient).%OpenId(mrPatientID)
	s PatientID = objMRPatient.PatientID
	if ($e(PatientID,1,2) = "VP")
	{
		d ##class(DHCEPRFS.INST.MRPatient).%DeleteId(mrPatientID)
	}
	
	&sql(delete from DHCEPRFS_INST.InputMedLog where MRMedRecordNo = :MRMedRecordID)
	
	q "1"
}

/// do ##Class(DHCEPRFS.BL.BLMRMedRecord).Test()
ClassMethod Test()
{
	s EP = ##Class(DHCEPRFS.Entity.EPatientInfoQueryPara).%New()
	s EP.MedRecordNo = 500224
	//s EP.Name = "dfd"
	s obj = ##Class(%ResultSet).%New("DHCEPRFS.BL.BLMRMedRecord:GetMedRecordInfo")
	d obj.Execute(EP)
	while (obj.Next())
	{
		w obj.Data("MRMedRecordNo")
	}
}

}
