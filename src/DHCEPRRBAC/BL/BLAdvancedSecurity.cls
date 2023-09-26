Class DHCEPRRBAC.BL.BLAdvancedSecurity Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod CheckASByGroupID(AFSAuthorizationGroupID As %String)
{
	s ret = "N"
	s detailNum = ""
	for {
		s detailNum = $o(^DHCEPRRBAC.INST.FSAuthI("IdxMain",AFSAuthorizationGroupID,detailNum))
		q:(detailNum = "")
		s subID = ""
		for {
			s subID = $o(^DHCEPRRBAC.INST.FSAuthI("IdxMain",AFSAuthorizationGroupID,detailNum,subID))
			q:(subID = "")
			
			s rowID = AFSAuthorizationGroupID_"||"_subID
			s obj = ##class(DHCEPRRBAC.INST.FSAuthorization).%OpenId(rowID)
			s episodeID = obj.EpisodeID
			s checkRet = ..CheckAS("DHC",episodeID)
			if (checkRet = "1")
			{
				s ret = "Y"
				q	
			}
		}
		q:(ret = "Y")
	}
		
	q ret
}

ClassMethod CheckAS(ASysCode As %String, AEpisodeID As %String)
{
	s ret = "0"
	s rowID = ""
	s rowID = $o(^DHCEPRRBAC.META.ASecurityI("IdxUnique"," "_ASysCode, " "_AEpisodeID,rowID))
	if (rowID '= "")
	{
		s ret = "1"
	}
	q ret
}

// debug: d ##class(DHCEPRRBAC.BL.BLAdvancedSecurity).RemoveAS("7502292","")

/* 增加了Type类型，所以取消这两个方法 2021.5.16
ClassMethod RemoveAS(ASysCode As %String, AEpisodeID As %String, AUserID As %String)
{

	s rowID = ""
	s rowID = $o(^DHCEPRRBAC.META.ASecurityI("IdxUnique"," "_ASysCode," "_AEpisodeID,rowID))
	if (rowID = "")
	{
		q "-2"		
	}
	
	//取得对象-->MREpisodeID
	s objASecurity=##class(DHCEPRRBAC.META.AdvancedSecurity).%OpenId(rowID)
	s MREpisodeID=objASecurity.MREpisodeID
	
	TSTART
	s $zt = "OnAddASErrorHandler"
	
	d ##class(DHCEPRRBAC.META.AdvancedSecurity).%DeleteId(rowID)
	
	s objI = ##class(DHCEPRRBAC.INST.AdvancedSecurityLog).%New()
	s objI.SysCode=ASysCode
	s objI.EpisodeID = AEpisodeID
	s objI.MREpisodeID=MREpisodeID
	s objI.UserID = AUserID
	s objI.ActionDate = $p($h,",",1)
	s objI.ActionTime = $p($h,",",2)
	s objI.Active = "N"
	s objI.Type = objASecurity.Type
	s sc = objI.%Save()
	if ('$$$ISOK(sc))
	{
		TROLLBACK
		q "-1"	
	}
	
	TCOMMIT
	q "1"
OnAddASErrorHandler
	TROLLBACK
	q "-1"
}

ClassMethod AddAS(ASysCode As %String, AEpisodeID As %String, AUserID As %String)
{
	s rowID = ""
	s rowID = $o(^DHCEPRRBAC.META.ASecurityI("IdxUnique"," "_ASysCode," "_AEpisodeID,rowID))
	//已存在
	q:(rowID '= "") "-2"
	//取得MREpisodeID
	s MREpisodeID=##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,ASysCode)
	
	TSTART
	
	s $zt = "OnAddASErrorHandler"
	s obj = ##class(DHCEPRRBAC.META.AdvancedSecurity).%New()
	s obj.SysCode=ASysCode
	s obj.EpisodeID = AEpisodeID
	s obj.MREpisodeID=MREpisodeID
	s obj.UserID = AUserID
	s obj.ActionDate = $p($h,",",1)
	s obj.ActionTime = $p($h,",",2)
	s sc = obj.%Save()
	if ('$$$ISOK(sc))
	{
		TROLLBACK
		q "-1"	
	}
	
	s objI = ##class(DHCEPRRBAC.INST.AdvancedSecurityLog).%New()
	s objI.SysCode=ASysCode
	s objI.EpisodeID = AEpisodeID
	s objI.UserID = AUserID
	s objI.MREpisodeID=MREpisodeID
	s objI.ActionDate = $p($h,",",1)
	s objI.ActionTime = $p($h,",",2)
	s objI.Active = "Y"
	s sc = objI.%Save()
	if ('$$$ISOK(sc))
	{
		TROLLBACK
		q "-1"	
	}
	
	TCOMMIT
	q "1"
OnAddASErrorHandler
	TROLLBACK
	q "-1"
}
*/
/// do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.BLAdvancedSecurity","GetASecurityList")
Query GetASecurityList() As %Query(ROWSPEC = "UserID:%String,UserName:%String,ActDate:%String,ActTime:%String,ASType:%String,ASTypeName:%String,PAStatusType:%String,PAAdmType:%String,PAPMIName:%String,PAPMINO:%String,PAPMIDOB:%String,PAPMIAge:%String,PAPMISex:%String,PAAdmDate:%String,PAAdmTime:%String,PAAdmWard:%String,PAAdmLoc:%String,PADischgeDate:%String,PADischgeTime:%String,PAAdmDoc:%String,PayMode:%String,EpisodeID:%String,PatientID:%String")
{
}

ClassMethod GetASecurityListExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s date = ""
	for {
		s date = $o(^DHCEPRRBAC.META.ASecurityI("IdxActionDateTime",date),-1)
		q:(date = "")
		s time = ""
		for {
			s time = $o(^DHCEPRRBAC.META.ASecurityI("IdxActionDateTime",date,time),-1)
			q:(time = "")
			s rowID = ""
			for {
				s rowID = $o(^DHCEPRRBAC.META.ASecurityI("IdxActionDateTime",date,time,rowID))
				q:(rowID = "")
				s obj = ##class(DHCEPRRBAC.META.AdvancedSecurity).%OpenId(rowID)
				s PAAdm = obj.EpisodeID
				s UserID = obj.UserID
				
				if ($p(UserID,"^",1) = "TEMP")
				{
					s objUser = ##class(DHCEPRFS.META.QueryUser).%OpenId($p(UserID,"^",2))
					s UserName = objUser.UserName
				}
				else
				{
					s UserName = $p($g(^SSU("SSUSR",UserID)),"^",2)
				}
				
				s ActionDate = obj.ActionDate
				s:(ActionDate'="") ActionDate = ##class(DHCEPRRBAC.Util.Utilization).FormatDisplayDate(ActionDate)
				s ActionTime = obj.ActionTime
				s:(ActionTime'="") ActionTime = $zt(ActionTime,1)
				s ASType = obj.Type
				
				s ASTypeName=""
				s ASTypeRowID =$o(^DHCEPRFS.META.ASTypeI("IdxCode"," "_ASType,""))
				
				if (ASTypeRowID '= "")
				{
					s objASType=##class(DHCEPRFS.META.ASType).%OpenId(ASTypeRowID)
					s ASTypeName = objASType.Name
				}
				
				d OutPutRow
			}
		}
	}
	Quit $$$OK

OutPutRow
	s MREpisodeID=""
	s MREpisodeID=$o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_PAAdm,MREpisodeID))
	
	s objMREpisode=##class(DHCEPRFS.INST.MREpisode).%OpenId(MREpisodeID)
	s objMRPatient=##class(DHCEPRFS.INST.MRPatient).%OpenId(objMREpisode.MRPatientID)
	
	s PatientID = objMRPatient.PatientID
	s PAAdmType = objMREpisode.AdmType
	
	//病人姓名
	s PAPMIName = objMRPatient.Name
	//登记号
	s PAPMINO = objMRPatient.RegNo
	
	//出生日期,年龄
	s PAPMIDOB = "" ,PAPMIAge = ""
	s DobDate = objMRPatient.Birthday
	If DobDate '= ""
	{
		s PAPMIDOB = ##class(DHCEPRRBAC.Util.Utilization).FormatDisplayDate(DobDate)
		s PAPMIAge = $fn((+$H-DobDate)/365,"",0)
	}
	//性别
	s PAPMISex = objMRPatient.Gender
	
	s PAAdmDate = "", PAAdmTime = ""
	s AdmDate = objMREpisode.AdmDate
	s:(AdmDate'="") PAAdmDate = ##class(DHCEPRRBAC.Util.Utilization).FormatDisplayDate(AdmDate)  //入院日期
	s AdmTime = objMREpisode.AdmTime
	s:(AdmTime'="") PAAdmTime = $zt(objMREpisode.AdmTime,1)  //入院时间
	
	//病区
	s PAAdmWard = objMREpisode.AdmWard
	
	//当前科室
	s PAAdmLoc = objMREpisode.AdmLoc
	if (PAAdmLoc = $c(0)) s PAAdmLoc=""
	
	//出院日期时间
	s PADischgeDate = "", PADischgeTime = ""
	s DisDate = objMREpisode.DisDate
	s:(DisDate'="") PADischgeDate = ##class(DHCEPRRBAC.Util.Utilization).FormatDisplayDate(DisDate)
	s DisTime = objMREpisode.DisTime
	s:(DisTime'="") PADischgeTime = $zt(objMREpisode.DisTime,1)
	
	//在院状态
	s PAStatusType = "出院"
	
	//医生
	s PAAdmDoc = objMREpisode.MainDoctor
	
	//付费方式
	s PayMode = objMREpisode.PayMode
	
	s data = $lb(UserID,UserName,ActionDate,ActionTime,ASType,ASTypeName,PAStatusType,PAAdmType,PAPMIName,PAPMINO,PAPMIDOB,PAPMIAge,PAPMISex,PAAdmDate,PAAdmTime,PAAdmWard,PAAdmLoc,PADischgeDate,PADischgeTime,PAAdmDoc,PayMode,PAAdm,PatientID)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1 
	q
}

ClassMethod GetASecurityListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetASecurityListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetASecurityListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetASecurityListExecute ]
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

// debug: d ##class(DHCEPRRBAC.BL.BLAdvancedSecurity).AddSpcl("DHC","59","731","SEALUP")

ClassMethod AddSpcl(ASysCode As %String, AEpisodeID As %String, AUserID As %String, AType As %String)
{
	s rowID = ""
	//判断同样类型的特殊病历只能加入一次
	s rowID = $o(^DHCEPRRBAC.META.ASecurityI("IdxSealType"," "_ASysCode," "_AEpisodeID," "_AType ,rowID))
	//已存在
	q:(rowID '= "") "-2"
	//取得MREpisodeID
	s MREpisodeID=##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,ASysCode)
	
	TSTART
	
	s $zt = "OnAddASErrorHandler"
	s obj = ##class(DHCEPRRBAC.META.AdvancedSecurity).%New()
	s obj.SysCode=ASysCode
	s obj.EpisodeID = AEpisodeID
	s obj.MREpisodeID=MREpisodeID
	s obj.UserID = AUserID
	s obj.Type = AType
	s obj.ActionDate = $p($h,",",1)
	s obj.ActionTime = $p($h,",",2)
	s sc = obj.%Save()
	if ('$$$ISOK(sc))
	{
		TROLLBACK
		q "-1"	
	}
	
	s objI = ##class(DHCEPRRBAC.INST.AdvancedSecurityLog).%New()
	s objI.SysCode=ASysCode
	s objI.EpisodeID = AEpisodeID
	s objI.UserID = AUserID
	s objI.MREpisodeID=MREpisodeID
	s objI.ActionDate = $p($h,",",1)
	s objI.ActionTime = $p($h,",",2)
	s objI.Active = "Y"
	s objI.Type = AType
	s sc = objI.%Save()
	if ('$$$ISOK(sc))
	{
		TROLLBACK
		q "-1"	
	}
	
	TCOMMIT
	q "1"
OnAddASErrorHandler
	TROLLBACK
	q "-1"
}

// debug: d ##class(DHCEPRRBAC.BL.BLAdvancedSecurity).RemoveAS("7502292","")

ClassMethod RemoveSpcl(ASysCode As %String, AEpisodeID As %String, AUserID As %String, AType As %String)
{

	s rowID = ""
	s rowID = $o(^DHCEPRRBAC.META.ASecurityI("IdxSealType"," "_ASysCode," "_AEpisodeID," "_AType ,rowID))
	if (rowID = "")
	{
		q "-2"		
	}
	
	//取得对象-->MREpisodeID
	s objASecurity=##class(DHCEPRRBAC.META.AdvancedSecurity).%OpenId(rowID)
	s MREpisodeID=objASecurity.MREpisodeID
	
	TSTART
	s $zt = "OnAddASErrorHandler"
	
	d ##class(DHCEPRRBAC.META.AdvancedSecurity).%DeleteId(rowID)
	
	s objI = ##class(DHCEPRRBAC.INST.AdvancedSecurityLog).%New()
	s objI.SysCode=ASysCode
	s objI.EpisodeID = AEpisodeID
	s objI.MREpisodeID=MREpisodeID
	s objI.UserID = AUserID
	s objI.ActionDate = $p($h,",",1)
	s objI.ActionTime = $p($h,",",2)
	s objI.Active = "N"
	s objI.Type = objASecurity.Type
	s sc = objI.%Save()
	if ('$$$ISOK(sc))
	{
		TROLLBACK
		q "-1"	
	}
	
	TCOMMIT
	q "1"
OnAddASErrorHandler
	TROLLBACK
	q "-1"
}

/// Desc: 查询所有的特殊病历类型
/// Creator: yangpeng
/// Debug：	do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.BLAdvancedSecurity","GetAllASType")
Query GetAllASType() As %SQLQuery(CONTAINID = 1, ROWSPEC = "Code:%String,Name: %String,Description: %String")
{
	SELECT Code,Name,Description FROM DHCEPRFS_META.ASType WHERE Code <>'SEAL'
}

}
