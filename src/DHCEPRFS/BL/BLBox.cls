Class DHCEPRFS.BL.BLBox Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 箱满，封箱操作
ClassMethod SealBox(ABoxID As %String, AActUserID As %String) As %String
{
	q:(ABoxID = "") "-1"
	s obj = ##class(DHCEPRFS.META.Box).%OpenId(ABoxID)
	s obj.SealDate = $p($h,",",1)
	s obj.SealTime = $p($h,",",2)
	s obj.SealUserID = AActUserID
	s obj.Status = "F"
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q "-1"
	}
}

/// 修改就诊所在箱
/// debug: w ##class(DHCEPRFS.BL.BLBox).ModifyEpisode2Box("7","12","128")
ClassMethod ModifyEpisode2Box(ABoxID As %String, AMREpisodeID As %String, AActUserID As %String) As %String
{
	q:(AMREpisodeID = "") "-1"
	s rowID = ""
	s rowID = $o(^DHCEPRFS.INST.BoxI("IdxMREpisode"," "_AMREpisodeID,rowID))
	q:(rowID = "") "-2"
	
	TSTART
	s preObj = ##class(DHCEPRFS.INST.BoxInstance).%OpenId(rowID)
	s preBoxID = preObj.BoxID
	if (preBoxID = "")
	{
		TROLLBACK
		q "-1"	
	}
	//修改原先箱中总就诊数和总病案数
	s objPreBox = ##class(DHCEPRFS.META.Box).%OpenId(preBoxID)
	s objPreBox.TotalEpisodeCount = objPreBox.TotalEpisodeCount - 1
	
	s needMinus = "1"
	s medRecordNo = ""
	s medRecordNo = $o(^DHCEPRFS.INST.BoxI("IdxMedRecordNo"," "_preBoxID,medRecordNo))
	s medRecordNoTR = $TR(medRecordNo," ","")
	if (medRecordNoTR '= "")
	{
		s mrEpisodeID = ""
		for {
			s mrEpisodeID = $o(^DHCEPRFS.INST.BoxI("IdxMedRecordNo"," "_preBoxID,medRecordNo,mrEpisodeID))
			q:(mrEpisodeID = "")
			s mrEpisodeIDTR = $TR(mrEpisodeID," ","")
			if (mrEpisodeIDTR = AMREpisodeID)
			{
				s needMinus = "0"
				q	
			}
		}
	}
	if (needMinus = "1")
	{
		s objPreBox.TotalMedRecordCount = objPreBox.TotalMedRecordCount - 1	
	}
	s status = objPreBox.%Save()
	if ('$$$ISOK(status))
	{
		TROLLBACK
		q "-1"
	}
	//删除原箱中此次就诊
	s status = ##class(DHCEPRFS.INST.BoxInstance).%DeleteId(rowID)
	if ('$$$ISOK(status))
	{
		TROLLBACK
		q ""
	}

	//在新箱中增加此次就诊	
	s objBox = ##class(DHCEPRFS.META.Box).%OpenId(ABoxID)
	s objBox.Status = "N"
	s objBox.TotalEpisodeCount = objBox.TotalEpisodeCount + 1

	s exist = "0"
	s medRecordNo = ""
	s medRecordNo = $o(^DHCEPRFS.INST.BoxI("IdxMedRecordNo"," "_ABoxID,medRecordNo))
	s medRecordNoTR = $TR(medRecordNo," ","")
	if (medRecordNoTR '= "")
	{
		s mrEpisodeID = ""
		for {
			s mrEpisodeID = $o(^DHCEPRFS.INST.BoxI("IdxMedRecordNo"," "_ABoxID,medRecordNo,mrEpisodeID))
			q:(mrEpisodeID = "")
			s mrEpisodeIDTR = $TR(mrEpisodeID," ","")
			if (mrEpisodeIDTR = AMREpisodeID)
			{
				s exist = "1"
				q	
			}
		}
	}
	if (exist = "0")
	{
		s objBox.TotalMedRecordCount = objBox.TotalMedRecordCount + 1	
	}
	s status = objBox.%Save()
	if ('$$$ISOK(status))
	{
		TROLLBACK
		q "-1"
	}
	
	s obj = ##class(DHCEPRFS.INST.BoxInstance).%New()
	s obj.ActDate = $p($h,",",1)
	s obj.ActTime = $p($h,",",2)
	s obj.ActUserID = AActUserID
	s obj.BoxID = ABoxID
	s obj.MREpisodeID = AMREpisodeID
	
	s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
	s obj.DisDate = objMREpisode.DisDate
	s obj.DisTime = objMREpisode.DisTime
	s obj.EpisodeID = objMREpisode.EpisodeID
	s obj.MedRecordNo = objMREpisode.MedRecordNo
	
	s sequence = ""
	s sequence = $o(^DHCEPRFS.INST.BoxI("IdxBoxSequence"," "_ABoxID,sequence),-1)
	if (sequence = "")
	{
		s sequence = 0	
	}
	s obj.Sequence = sequence + 1

	s status = obj.%Save()
	if ('$$$ISOK(status))
	{
		TROLLBACK
		q "-1"
	}	
	else
	{
		d ##class(DHCEPRFS.BL.BLMRLog).ModifyAdm2BoxLogDetail(AMREpisodeID,AActUserID)
		TCOMMIT
		q obj.%Id()	
	}
}

/// 将就诊装到箱中
/// debug: w ##class(DHCEPRFS.BL.BLBox).AddEpisode2Box("12","12","128")
ClassMethod AddEpisode2Box(ABoxID As %String, AMREpisodeID As %String, AActUserID As %String) As %String
{
	q:(AMREpisodeID = "") "-1"
	s exist = ""
	s exist = $o(^DHCEPRFS.INST.BoxI("IdxMREpisode"," "_AMREpisodeID,exist))
	q:(exist '= "") "-2"
	
	TSTART
	s objBox = ##class(DHCEPRFS.META.Box).%OpenId(ABoxID)
	s objBox.Status = "N"
	s objBox.TotalEpisodeCount = objBox.TotalEpisodeCount + 1
	
	s exist = "0"
	s medRecordNo = ""
	s medRecordNo = $o(^DHCEPRFS.INST.BoxI("IdxMedRecordNo"," "_ABoxID,medRecordNo))
	s medRecordNoTR = $TR(medRecordNo," ","")
	if (medRecordNoTR '= "")
	{
		s mrEpisodeID = ""
		for {
			s mrEpisodeID = $o(^DHCEPRFS.INST.BoxI("IdxMedRecordNo"," "_ABoxID,medRecordNo,mrEpisodeID))
			q:(mrEpisodeID = "")
			s mrEpisodeIDTR = $TR(mrEpisodeID," ","")
			if (mrEpisodeIDTR = AMREpisodeID)
			{
				s exist = "1"
				q	
			}
		}
	}
	if (exist = "0")
	{
		s objBox.TotalMedRecordCount = objBox.TotalMedRecordCount + 1	
	}

	s status = objBox.%Save()
	if ('$$$ISOK(status))
	{
		TROLLBACK
		q "-1"
	}
	
	s obj = ##class(DHCEPRFS.INST.BoxInstance).%New()
	s obj.ActDate = $p($h,",",1)
	s obj.ActTime = $p($h,",",2)
	s obj.ActUserID = AActUserID
	s obj.BoxID = ABoxID
	s obj.MREpisodeID = AMREpisodeID
	
	s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
	s obj.DisDate = objMREpisode.DisDate
	s obj.DisTime = objMREpisode.DisTime
	s obj.EpisodeID = objMREpisode.EpisodeID
	s obj.MedRecordNo = objMREpisode.MedRecordNo
	
	s sequence = ""
	s sequence = $o(^DHCEPRFS.INST.BoxI("IdxBoxSequence"," "_ABoxID,sequence),-1)
	if (sequence = "")
	{
		s sequence = 0	
	}
	s obj.Sequence = sequence + 1
	s status = obj.%Save()
	if ('$$$ISOK(status))
	{
		TROLLBACK
		q "-1"
	}	
	else
	{
		d ##class(DHCEPRFS.BL.BLMRLog).AddAdm2BoxLogDetail(AMREpisodeID,AActUserID)
		TCOMMIT
		q obj.%Id()	
	}
}

/// 修改箱信息
/// debug: w ##class(DHCEPRFS.BL.BLBox).ModifyBox("箱2","Box001","箱2","","","","","")
ClassMethod ModifyBox(ABoxName As %String, ABoxCode As %String, ABoxDesc As %String, ABoxLocationCode As %String, ABoxLocationDesc As %String, ABoxTag As %String, ABoxBarCode As %String, AUserID As %String) As %String
{
	s rowID = $o(^DHCEPRFS.META.BoxI("IdxBoxCode"," "_$zcvt(ABoxCode,"U"),""))
	q:(rowID = "") "-2"
	s obj = ##class(DHCEPRFS.META.Box).%OpenId(rowID)
	s obj.BoxName = ABoxName
	s obj.BoxCode = ABoxCode
	s obj.BoxDesc = ABoxDesc
	s obj.BoxBarCode = ABoxBarCode
	s obj.BoxLocationCode = ABoxLocationCode
	s obj.BoxLocationDesc = ABoxLocationDesc
	s obj.BoxTag = ABoxTag
	s obj.LastModifyDate = $p($h,",",1)
	s obj.LastModifyTime = $p($h,",",2) 
	s obj.LastModifyUserID = AUserID
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q "-1"
	}
}

/// 新建箱
/// debug: w ##class(DHCEPRFS.BL.BLBox).AddNewBox("箱1","Box00000001","箱1","","","","","")
ClassMethod AddNewBox(ABoxName As %String, ABoxCode As %String, ABoxDesc As %String, ABoxLocationCode As %String, ABoxLocationDesc As %String, ABoxTag As %String, ABoxBarCode As %String, AUserID As %String) As %String
{
	s:(ABoxCode = $c(0)) ABoxCode = ""
	q:(ABoxCode = "") "-1"
	
	s ABoxCode = $zcvt(ABoxCode,"U")
	
	s exist = 0
	&sql(select count(*) into exist from DHCEPRFS_META.Box where BoxCode = :ABoxCode)
	q:(+exist > 0) "-2"
	
	s boxNumber = ""
	s boxNumber = $o(^DHCEPRFS.META.BoxI("IdxBoxNumber",""),-1)
	s:(boxNumber = "") boxNumber = 0
	
	s obj = ##class(DHCEPRFS.META.Box).%New()
	s obj.BoxName = ABoxName
	s obj.BoxCode = ABoxCode
	s obj.BoxDesc = ABoxDesc
	s obj.BoxBarCode = ABoxBarCode
	s obj.BoxLocationCode = ABoxLocationCode
	s obj.BoxLocationDesc = ABoxLocationDesc
	s obj.BoxNumber = boxNumber + 1
	s obj.BoxTag = ABoxTag
	s obj.CreateDate = $p($h,",",1)
	s obj.CreateTime = $p($h,",",2) 
	s obj.CreateUserID = AUserID
	s obj.Status = "E"
	s obj.TotalEpisodeCount = 0
	s obj.TotalMedRecordCount = 0
	s status = obj.%Save()
	if ($$$ISOK(status))
	{
		q obj.%Id()
	}
	else
	{
		q "-1"
	}
}

/// 根据箱状态获取箱列表
/// AStatus: E-空，F-满，N-正在装，C-作废
/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLBox","GetBoxListByStatus","")
Query GetBoxListByStatus(AStatus As %String = "") As %Query(ROWSPEC = "ID:%String,BoxName:%String,BoxCode:%String,BoxDesc:%String,BoxNumber:%String,BoxBarCode:%String,BoxLocationCode:%String,BoxLocationDesc:%String,BoxTag:%String,CreateUserID:%String,CreateUserName:%String,SealUserID:%String,SealUserName:%String,LastModifyUserID:%String,LastModifyUserName:%String,CreateDateTime:%String,SealDateTime:%String,LastModifyDateTime:%String,Status:%String,StatusDesc:%String,TotalMedRecordCount:%String,TotalEpisodeCount:%String")
{
}

ClassMethod GetBoxListByStatusExecute(ByRef qHandle As %Binary, AStatus As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1

	s:(AStatus = $c(0)) AStatus = ""
	if (AStatus = "")
	{
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.META.BoxD(rowID))
			q:(rowID = "")
			s obj = ##class(DHCEPRFS.META.Box).%OpenId(rowID)
			d OutPutRow	
		}
	}
	else
	{
		s count = $l(AStatus,"+")
		for index=1:1:count
		{
			s status = $p(AStatus,"+",index)
			s boxNumber = ""
			for {
				s boxNumber = $o(^DHCEPRFS.META.BoxI("IdxBoxStatus"," "_status,boxNumber))
				q:(boxNumber = "")
				s rowID = ""
				for {
					s rowID = $o(^DHCEPRFS.META.BoxI("IdxBoxStatus"," "_status,boxNumber,rowID))
					q:(rowID = "")
					s obj = ##class(DHCEPRFS.META.Box).%OpenId(rowID)
					d OutPutRow		
				}
			}
		}
	}
	Quit $$$OK
OutPutRow
	s ID = rowID
	s BoxName = obj.BoxName
	s BoxCode = obj.BoxCode
	s BoxDesc = obj.BoxDesc
	s BoxNumber = obj.BoxNumber
	s BoxBarCode = obj.BoxBarCode
	s BoxLocationCode = obj.BoxLocationCode
	s BoxLocationDesc = obj.BoxLocationDesc
	s BoxTag = obj.BoxTag
	s CreateUserID = obj.CreateUserID
	s CreateUserName = ""
	if ((CreateUserID '= "") && (CreateUserID '= $c(0)) )
	{
		s CreateUserName = ##class(DHCEPRFS.BL.BLQueryUser).GetUserNameByUserID(CreateUserID)
	}
	s SealUserID = obj.SealUserID
	s SealUserName = ""
	if ((SealUserID '= "") && (SealUserID '= $c(0)) ) 
	{
		s SealUserName = ##class(DHCEPRFS.BL.BLQueryUser).GetUserNameByUserID(SealUserID)
	}
	s LastModifyUserID = obj.LastModifyUserID
	s LastModifyUserName = ""
	if ((LastModifyUserID '= "") && (LastModifyUserID '= $c(0)) )
	{
		s LastModifyUserName = ##class(DHCEPRFS.BL.BLQueryUser).GetUserNameByUserID(LastModifyUserID)
	}
	s CreateDate = obj.CreateDate
	s CreateTime = obj.CreateTime
	s CreateDateTime = ""
	if ((CreateDate '= "") && (CreateDate '= $c(0)))
	{
		s CreateDateTime =  $zd(CreateDate,3)_" "_$zt(CreateTime,1)
	}
	s SealDate = obj.SealDate
	s SealTime = obj.SealTime
	s SealDateTime = ""
	if ((SealDate '= "") && (SealDate '= $c(0)))
	{
		s SealDateTime =  $zd(SealDate,3)_" "_$zt(SealTime,1)
	}
	s LastModifyDate = obj.LastModifyDate
	s LastModifyTime = obj.LastModifyTime
	s LastModifyDateTime = ""
	if ((LastModifyDate '= "") && (LastModifyDate '= $c(0)))
	{
		s LastModifyDateTime =  $zd(LastModifyDate,3)_" "_$zt(LastModifyTime,1)
	}
	s Status = obj.Status
	s StatusDesc = ""
	if (Status = "E")
	{
		s StatusDesc = "空"	
	}
	elseif (Status = "F")
	{
		s StatusDesc = "满"	
	}
	elseif (Status = "N")
	{
		s StatusDesc = "正在装"	
	}
	elseif (Status = "C")
	{
		s StatusDesc = "作废"	
	}
	s TotalMedRecordCount = obj.TotalMedRecordCount
	s TotalEpisodeCount = obj.TotalEpisodeCount
	
 	s data = $lb(ID,BoxName,BoxCode,BoxDesc,BoxNumber,BoxBarCode,BoxLocationCode,BoxLocationDesc,BoxTag,CreateUserID,CreateUserName,SealUserID,SealUserName,LastModifyUserID,LastModifyUserName,CreateDateTime,SealDateTime,LastModifyDateTime,Status,StatusDesc,TotalMedRecordCount,TotalEpisodeCount)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q
}

ClassMethod GetBoxListByStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBoxListByStatusExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetBoxListByStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBoxListByStatusExecute ]
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

/// 根据箱ID获取箱中就诊信息
/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLBox","GetMREpisodeListByBoxID","20")
Query GetMREpisodeListByBoxID(ABoxID As %String) As %Query(ROWSPEC = "ID:%String,Sequence:%String,MRPatientID:%String,MREpisodeID:%String,PatientID:%String,EpisodeID:%String,MedRecordNo:%String,Name:%String,Birthday:%String,Age:%String,Sex:%String,HouseAddress:%String,LinkName:%String,LinkRelation:%String,AdmDateTime:%String,DisDateTime:%String,AdmLoc:%String,DisLoc:%String,MainDiagDesc:%String,DeathDate:%String")
{
}

ClassMethod GetMREpisodeListByBoxIDExecute(ByRef qHandle As %Binary, ABoxID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	
	s sequence = 0
	for {
		s sequence = $o(^DHCEPRFS.INST.BoxI("IdxBoxSequence"," "_ABoxID,sequence))
		q:(sequence = "")
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.INST.BoxI("IdxBoxSequence"," "_ABoxID,sequence,rowID))
			q:(rowID = "")
			s obj = ##class(DHCEPRFS.INST.BoxInstance).%OpenId(rowID)
			d MREpisodeListOutPutRow
		}
	}
	Quit $$$OK
MREpisodeListOutPutRow
	s ID = rowID
	s Sequence = sequence
	s MREpisodeID = obj.MREpisodeID
	s ObjMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(MREpisodeID)
	s MRPatientID = ObjMREpisode.MRPatientID
	s ObjMRPatient = ##class(DHCEPRFS.INST.MRPatient).%OpenId(MRPatientID)

	//患者信息
    s Name = ObjMRPatient.Name
    s Birthday = ObjMRPatient.Birthday
    s:(Birthday '= "") Birthday = $zd(Birthday,3)
    s Age = ObjMRPatient.Age	
    s Sex = ObjMRPatient.Gender
    s HouseAddress = ObjMRPatient.HouseAddress
    s LinkName = ObjMRPatient.LinkName	
    s LinkRelation = ObjMRPatient.LinkRelation
    s MedRecordNo = ObjMRPatient.MedRecordNo
	
	//就诊信息
	s EpisodeID = ObjMREpisode.EpisodeID
	s PatientID = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPapmiDR(EpisodeID)
	s AdmDate = ObjMREpisode.AdmDate
	s AdmTime = ObjMREpisode.AdmTime 
	s AdmDateTime = $zd(AdmDate,3)   
	s DisDate = ObjMREpisode.DisDate
	s DisTime = ObjMREpisode.DisTime
    s DisDateTime = $zd(DisDate,3)   
    s AdmLoc = ObjMREpisode.AdmLoc
    s DisLoc = ObjMREpisode.DisLoc
    
    s MedRecordNo = $g(MedRecordNo)
    if (MedRecordNo="")||(MedRecordNo=$c(0))
    {
	    s MedRecordNo = ObjMREpisode.MedRecordNo
    }
    	
    s DeathDateTime = ##class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).DeathDateTime(PatientID)
    if (DeathDateTime = "")
    {
		s DeathDate = ""    
	}
	else
	{
		//只有最后一次就诊死亡
		if ((DisDate '= "") && ($zdh(DisDate,3) < $p(DeathDateTime,",",1)))
		{
			//出院日期小于死亡日期，此次就诊未死亡	
			s DeathDate = ""
		}
		elseif ((DisDate '= "") && ($zdh(DisDate,3) = $p(DeathDateTime,",",1)))
		{
			//出院日期等于死亡日期，判断此次就诊是否是最后一次就诊	
			s mrEpisodeID = ""
			s lastDisDate = $zdh(DisDate,3)
			s lastDisTime = $zth(DisTime,3)
			s tempMREpisodeID = MEpisodeID
			for {
				s mrEpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxMRPatientID"," "_MRPatientID,mrEpisodeID))
				q:(mrEpisodeID = "")
				s objTemp = ##Class(DHCEPRFS.INST.MREpisode).%OpenId(mrEpisodeID)
				if ($zdh(objTemp.DisDate,3) > lastDisDate)
				{
					s lastDisDate = $zdh(objTemp.DisDate,3)
					s lastDisTime = $zth(objTemp.DisTime,3)
					s tempMREpisodeID = mrEpisodeID
					continue
				}
				
				if (($zdh(objTemp.DisDate,3) = lastDisDate) && ($zth(objTemp.DisTime,3) > lastDisTime))
								{
					s lastDisDate = $zdh(objTemp.DisDate,3)
					s lastDisTime = $zth(objTemp.DisTime,3)
					s tempMREpisodeID = mrEpisodeID
					continue
				}
			}
			//此次为最后一次就诊
			if (tempMREpisodeID = MEpisodeID)
			{
				s DeathDate = $zd($p(DeathDateTime,",",1),3)_" "_$zt($p(DeathDateTime,",",2),3)
			}
			else
			{
				s DeathDate = ""
			}
		}
		else
		{
    		s DeathDate = $zd($p(DeathDateTime,",",1),3)_" "_$zt($p(DeathDateTime,",",2),3)
		}
	}
	
	s MREpisodeFPID = $o(^DHCEPRFS.INST.MREpisodeFPI("IdxMrEpisodeID"," "_MREpisodeID,""))
	s ObjMREpisodeFP = ##class(DHCEPRFS.INST.MREpisodeFP).%OpenId(MREpisodeFPID)
	s MainDiagDesc = ObjMREpisodeFP.DiagMainDesc

    s data = $lb(ID,Sequence,MRPatientID,MREpisodeID,PatientID,EpisodeID,MedRecordNo,Name,Birthday,Age,Sex,HouseAddress,LinkName,LinkRelation,AdmDateTime,DisDateTime,AdmLoc,DisLoc,MainDiagDesc,DeathDate)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q
}

ClassMethod GetMREpisodeListByBoxIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMREpisodeListByBoxIDExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetMREpisodeListByBoxIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMREpisodeListByBoxIDExecute ]
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

/// 根据就诊号或者病案号查询箱信息
/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLBox","GetBoxInfo","","500245")
Query GetBoxInfo(AEpisodeID As %String, AMedRecordNo As %String) As %Query(ROWSPEC = "ID:%String,Sequence:%String,EpisodeID:%String,MREpisodeID:%String,MedRecordNo:%String,BoxID:%String,BoxName:%String,BoxCode:%String,BoxDesc:%String,BoxNumber:%String,BoxBarCode:%String,BoxLocationCode:%String,BoxLocationDesc:%String,BoxTag:%String,CreateUserID:%String,CreateUserName:%String,SealUserID:%String,SealUserName:%String,LastModifyUserID:%String,LastModifyUserName:%String,CreateDateTime:%String,SealDateTime:%String,LastModifyDateTime:%String,Status:%String,StatusDesc:%String,TotalMedRecordCount:%String,TotalEpisodeCount:%String")
{
}

ClassMethod GetBoxInfoExecute(ByRef qHandle As %Binary, AEpisodeID As %String, AMedRecordNo As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
 	s ind=1
	
	s:(AEpisodeID = $c(0)) AEpisodeID = ""
	s:(AMedRecordNo = $c(0)) AMedRecordNo = ""
	
	if (AEpisodeID '= "")
	{
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.INST.BoxI("IdxMREpisode"," "_AEpisodeID,rowID))
			q:(rowID = "")
			s obj = ##class(DHCEPRFS.INST.BoxInstance).%OpenId(rowID)
			d BoxOutPutRow	
		}
	}
	else
	{
		s rowID = ""
		for {
			s rowID = $o(^DHCEPRFS.INST.BoxI("IdxBoxMedRecordNo"," "_AMedRecordNo,rowID))
			q:(rowID = "")
			s obj = ##class(DHCEPRFS.INST.BoxInstance).%OpenId(rowID)
			d BoxOutPutRow	
		}	
	}
	Quit $$$OK
BoxOutPutRow
	s ID = rowID
	s EpisodeID = obj.EpisodeID
	s MedRecordNo = obj.MedRecordNo
	s Sequence = obj.Sequence
	s BoxID = obj.BoxID
	s MREpisodeID = obj.MREpisodeID

	s ObjBox = ##class(DHCEPRFS.META.Box).%OpenId(BoxID)
	
	s BoxName = ObjBox.BoxName
	s BoxCode = ObjBox.BoxCode
	s BoxDesc = ObjBox.BoxDesc
	s BoxNumber = ObjBox.BoxNumber
	s BoxBarCode = ObjBox.BoxBarCode
	s BoxLocationCode = ObjBox.BoxLocationCode
	s BoxLocationDesc = ObjBox.BoxLocationDesc
	s BoxTag = ObjBox.BoxTag
	s CreateUserID = ObjBox.CreateUserID
	s CreateUserName = ""
	if ((CreateUserID '= "") && (CreateUserID '= $c(0)) )
	{
		s CreateUserName = ##class(DHCEPRFS.BL.BLQueryUser).GetUserNameByUserID(CreateUserID)
	}
	s SealUserID = ObjBox.SealUserID
	s SealUserName = ""
	if ((SealUserID '= "") && (SealUserID '= $c(0)) ) 
	{
		s SealUserName = ##class(DHCEPRFS.BL.BLQueryUser).GetUserNameByUserID(SealUserID)
	}
	s LastModifyUserID = ObjBox.LastModifyUserID
	s LastModifyUserName = ""
	if ((LastModifyUserID '= "") && (LastModifyUserID '= $c(0)) )
	{
		s LastModifyUserName = ##class(DHCEPRFS.BL.BLQueryUser).GetUserNameByUserID(LastModifyUserID)
	}
	s CreateDate = ObjBox.CreateDate
	s CreateTime = ObjBox.CreateTime
	s CreateDateTime = ""
	if ((CreateDate '= "") && (CreateDate '= $c(0)))
	{
		s CreateDateTime =  $zd(CreateDate,3)_" "_$zt(CreateTime,1)
	}
	s SealDate = ObjBox.SealDate
	s SealTime = ObjBox.SealTime
	s SealDateTime = ""
	if ((SealDate '= "") && (SealDate '= $c(0)))
	{
		s SealDateTime =  $zd(SealDate,3)_" "_$zt(SealTime,1)
	}
	s LastModifyDate = ObjBox.LastModifyDate
	s LastModifyTime = ObjBox.LastModifyTime
	s LastModifyDateTime = ""
	if ((LastModifyDate '= "") && (LastModifyDate '= $c(0)))
	{
		s LastModifyDateTime =  $zd(LastModifyDate,3)_" "_$zt(LastModifyTime,1)
	}
	s Status = ObjBox.Status
	s StatusDesc = ""
	if (Status = "E")
	{
		s StatusDesc = "空"	
	}
	elseif (Status = "F")
	{
		s StatusDesc = "满"	
	}
	elseif (Status = "N")
	{
		s StatusDesc = "正在装"	
	}
	elseif (Status = "C")
	{
		s StatusDesc = "作废"	
	}
	s TotalMedRecordCount = ObjBox.TotalMedRecordCount
	s TotalEpisodeCount = ObjBox.TotalEpisodeCount
	
 	s data = $lb(ID,Sequence,EpisodeID,MREpisodeID,MedRecordNo,BoxID,BoxName,BoxCode,BoxDesc,BoxNumber,BoxBarCode,BoxLocationCode,BoxLocationDesc,BoxTag,CreateUserID,CreateUserName,SealUserID,SealUserName,LastModifyUserID,LastModifyUserName,CreateDateTime,SealDateTime,LastModifyDateTime,Status,StatusDesc,TotalMedRecordCount,TotalEpisodeCount)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q
}

ClassMethod GetBoxInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBoxInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetBoxInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBoxInfoExecute ]
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

}
