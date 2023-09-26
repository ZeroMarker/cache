Class DHCEPRFS.BL.BLNameAlias Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:获得符合拼音的名字
/// Debug:do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLNameAlias","GetNameByAlias","")
/// Modify 2023-03-03:增加输出字段病案号(MedRecordNo)，住院次数(AdmNum)，性别(Gender)，年龄(Age)，出院病区(DisWard)，出院日期(DisDate)
Query GetNameByAlias(AAlias As %String) As %Query(ROWSPEC = "Name:%String,Alias:%String,AliasInitial:%String,MedRecordNo:%String,AdmCount:%String,Gender:%String,Age:%String,DisWard:%String,DisDate:%String")
{
}

ClassMethod GetNameByAliasExecute(ByRef qHandle As %Binary, AAlias As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s AAlias = $zcvt(AAlias,"U")
	Set (medRecNo,admCnt,gender,age,disWard,disDate) = ""
	
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.MRPatientI("IdxAliasName", " "_AAlias,rowID))
		q:(rowID = "")
		s obj = ##class(DHCEPRFS.INST.MRPatient).%OpenId(rowID)
		s name = obj.Name
		s alias = AAlias
		s aliasInital = obj.AliasNameInitial
		//s data = $lb(name,alias,aliasInital)
		//s ^CacheTemp(repid,ind)=data
		//s ind=ind+1
		Set medRecNo = obj.MedRecordNo
		Set gender   = obj.Gender
		Set age      = obj.Age
		Set MEpisodeID = ""
		For {
			Set MEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_rowID,MEpisodeID))
			Quit:(MEpisodeID = "")
			Set flag = $$GetEpisodeInfo()
			Continue:(flag '= "1")
			Do OutPutInfo
		}
	}
	
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRFS.INST.MRPatientI("IdxAliasNameInitial", " "_AAlias,rowID))
		q:(rowID = "")
		s obj = ##class(DHCEPRFS.INST.MRPatient).%OpenId(rowID)
		s name = obj.Name
		s alias = obj.AliasName
		s aliasInital = AAlias
		//s data = $lb(name,alias,aliasInital)
		//s ^CacheTemp(repid,ind)=data
		//s ind=ind+1
		Set medRecNo = obj.MedRecordNo
		Set gender   = obj.Gender
		Set age      = obj.Age
		Set MEpisodeID = ""
		For {
			Set MEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_rowID,MEpisodeID))
			Quit:(MEpisodeID = "")
			Set flag = $$GetEpisodeInfo()
			Continue:(flag '= "1")
			Do OutPutInfo
		}
	}

	Quit $$$OK
	
GetEpisodeInfo()
	Set flag = "-1"
	Set objEpisode = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(MEpisodeID)
	Set EpisodeID = objEpisode.EpisodeID
	Set admCnt    = objEpisode.InNum
	Set disWard   = objEpisode.DisWard
	//Set PatientID = ..GetPapmiDR(EpisodeID)
	/*
	if (MedRecordNo = "")
	{
		s MedRecordNo = objEpisode.MedRecordNo
	}*/
	//Set admDate = objEpisode.AdmDate
	//Set admTime = objEpisode.AdmTime   
	Set disDate = objEpisode.DisDate
	Set:(disDate'= "") disDate = $ZDATE(disDate,3)
	//Set disTime = objEpisode.DisTime
	Do objEpisode.%Close()
	Set flag = "1"
	Quit flag
OutPutInfo
	Set data = $LISTBUILD(name,alias,aliasInital,medRecNo,admCnt,gender,age,disWard,disDate)
	Set ^CacheTemp(repid,ind)=data
	Set ind=ind+1
	Quit
}

ClassMethod GetNameByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNameByAliasExecute ]
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

ClassMethod GetNameByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNameByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc:获得符合拼音的出院科室
/// Debug:w ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLNameAlias","GetDisLocByAlias","")
Query GetDisLocByAlias(AAlias As %String) As %Query(ROWSPEC = "Name:%String,Alias:%String,AliasInitial:%String,ID:%String")
{
}

ClassMethod GetDisLocByAliasExecute(ByRef qHandle As %Binary, AAlias As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	
 	s AAlias = $zcvt(AAlias,"U")
 	s oldRowIds = "^"
 	s rowID = ""
 	for {
	 	s rowID = $o(^DHCEPRFS.META.B.DepartmentI("IdxAliasName", " "_AAlias,rowID))
	 	q:(rowID = "")
	 	s oldRowIds = oldRowIds_rowID_"^"
	 	s obj = ##class(DHCEPRFS.META.B.Department).%OpenId(rowID)
	 	s name = obj.Name
	 	s alias = AAlias
	 	s aliasInital = obj.AliasNameInitial
	 	s id = obj.DepartmentID
		s data = $lb(name,alias,aliasInital,id)
	    s ^CacheTemp(repid,ind)=data
	    s ind=ind+1
 	}
 	
 	s rowID = ""
 	for {
	 	s rowID = $o(^DHCEPRFS.META.B.DepartmentI("IdxAliasNameInitial", " "_AAlias,rowID))
	 	q:(rowID = "")
	 	continue:(oldRowIds[("^"_rowID_"^"))
	 	s obj = ##class(DHCEPRFS.META.B.Department).%OpenId(rowID)
	 	s name = obj.Name
	 	s alias = obj.AliasName
	 	s aliasInital = AAlias
	 	s id = obj.DepartmentID
		s data = $lb(name,alias,aliasInital,id)
	    s ^CacheTemp(repid,ind)=data
	    s ind=ind+1
 	}

	Quit $$$OK
}

ClassMethod GetDisLocByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDisLocByAliasExecute ]
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

ClassMethod GetDisLocByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDisLocByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
