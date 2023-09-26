Class DHCEPRRBAC.BL.BLFavorites Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Debug: w ##class(DHCEPRRBAC.BL.BLFavorites).Add("610","13","9")
ClassMethod Add(AEpisodeID As %String, AFavoritesCategoryID As %String, AUserID As %String)
{
	q:(AEpisodeID = "")||(AFavoritesCategoryID = "") "0"
	s rowID = ""
	s rowID = $o(^DHCEPRRBAC.INST.FavorI("IdxExist"," "_AFavoritesCategoryID," "_AEpisodeID,rowID))
	q:(rowID '= "") "-2"
	
	s obj = ##class(DHCEPRRBAC.INST.Favorites).%New()
	s obj.AddDate = $p($h,",",1)
	s obj.AddTime = $p($h,",",2)
	s obj.CategoryID = AFavoritesCategoryID
	s obj.EpisodeID = AEpisodeID
	s obj.UserID = AUserID
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q "1"
	}
	else
	{
		q "-1"
	}
}

/// Debug: w ##class(DHCEPRRBAC.BL.BLFavorites).Delete("9^10")
ClassMethod Delete(AFavoritesIDS As %String)
{
	s return = "0"
	q:(AFavoritesIDS = "") return
	
	s flag = "true"
	TSTART
	s $zt = "OnDeleteErrorHandler"
	s return = "-1"
	for index=1:1:$l(AFavoritesIDS,"^")
	{
		s favoritesID = $p(AFavoritesIDS,"^",index)
		s sc = ##class(DHCEPRRBAC.INST.Favorites).%DeleteId(favoritesID)
		if ($$$ISERR(sc))
		{
			s flag = "false"
			q
		}
	}
	if (flag = "false")
	{
		TROLLBACK
		q return
	}
	
	TCOMMIT
	s return = "1"
	q return
OnDeleteErrorHandler
	TROLLBACK
	q "-100"
}

/// Debug: w ##class(DHCEPRRBAC.BL.BLFavorites).Move("4","9^10","135^137")
ClassMethod Move(AFavoritesCategoryID As %String, AFavoritesIDS As %String, AEpisodeIDS As %String)
{
	s return = "0"
	q:(AFavoritesCategoryID = "")||(AFavoritesIDS = "")||(AEpisodeIDS = "") return
	
	s flag = "true"
	TSTART
	s $zt = "OnMoveErrorHandler"
	
	s return = "-1"
	for index=1:1:$l(AFavoritesIDS,"^")
	{
		s favoritesID = $p(AFavoritesIDS,"^",index)
		s episodeID = $p(AEpisodeIDS,"^",index)
		//检查被移动的收藏项在分类是否已存在
		s rowID = ""
		s rowID = $o(^DHCEPRRBAC.INST.FavorI("IdxExist"," "_AFavoritesCategoryID," "_episodeID,rowID))
		if (rowID = "")  //不存在则修改分类
		{
			s obj = ##class(DHCEPRRBAC.INST.Favorites).%OpenId(favoritesID)	
			s obj.CategoryID = AFavoritesCategoryID
			s sc = obj.%Save()
			if ($$$ISERR(sc))
			{
				s flag = "false"
				q
			}	
		}
		else  //存在则删除此条
		{
			s sc = ##class(DHCEPRRBAC.INST.Favorites).%DeleteId(favoritesID)
			if ($$$ISERR(sc))
			{
				s flag = "false"
				q
			}
		}
	}
	if (flag = "false")
	{
		TROLLBACK
		q return
	}
	
	TCOMMIT
	s return = "1"
	q return
OnMoveErrorHandler
	TROLLBACK
	q "-100"
}

/// Debug: do ##class(%ResultSet).RunQuery("DHCEPRRBAC.BL.BLFavorites","GetList","159","12")
Query GetList(AUserID As %String, AFavoritesCategoryID As %String) As %Query(ROWSPEC = "FavoritesID:%String,EpisodeID:%String,PatientID:%String,MedRecordNo:%String,RegNo:%String,PAStatusType:%String,PAAdmType:%String,PAPMIName:%String,PAPMIDOB:%String,PAPMIAge:%String,PAPMISex:%String,PAAdmDate:%String,PAAdmTime:%String,PAAdmWard:%String,PAAdmLoc:%String,PADischgeDate:%String,PADischgeTime:%String,PAAdmDoc:%String,PayMode:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, AUserID As %String, AFavoritesCategoryID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	Set langid=20  //登录语言
	If ($d(%session)){
		Set langid=+$g(%session.Data("LOGON.LANGID"))
	}
	Set EnableTranslation=0  //翻译功能启用标识
	If (##class(%Dictionary.CompiledMethod).%ExistsId("User.Abstract||GetTranByDesc"))
	{
		Set EnableTranslation=1
	}
	
	q:(AUserID = "")||(AFavoritesCategoryID = "") $$$OK
	
	s date = ""
	for {
		s date = $o(^DHCEPRRBAC.INST.FavorI("IdxUserID"," "_AUserID," "_AFavoritesCategoryID,date))
		q:(date = "")
		
		s time = ""
		for {
			s time = $o(^DHCEPRRBAC.INST.FavorI("IdxUserID"," "_AUserID," "_AFavoritesCategoryID,date,time))
			q:(time = "")
			
			s rowID = ""
			for {
				s rowID = $o(^DHCEPRRBAC.INST.FavorI("IdxUserID"," "_AUserID," "_AFavoritesCategoryID,date,time,rowID))
				q:(rowID = "")
				
				s obj = ##class(DHCEPRRBAC.INST.Favorites).%OpenId(rowID)
				s EpisodeID = obj.EpisodeID
				
				s MREpisodeID = ""
				s MREpisodeID = $o(^DHCEPRFS.INST.MREpisodeI("IdxSysCodeAndEpisodeID"," DHC"," "_EpisodeID,MREpisodeID))
				
				s objMREpisode = ##class(DHCEPRFS.INST.MREpisode).%OpenId(MREpisodeID)
				s objMRPatient = ##class(DHCEPRFS.INST.MRPatient).%OpenId(objMREpisode.MRPatientID)
				
				s PatientID = objMRPatient.PatientID
				s MedRecordNo = objMREpisode.MedRecordNo
				s RegNo = objMRPatient.RegNo
				
				//就诊类型
				s PAAdmType = objMREpisode.AdmType
				
				//病人姓名
				s PAPMIName = objMRPatient.Name
				
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
				
				s PAAdmDate = objMREpisode.AdmDate  //入院日期
				s PAAdmTime = objMREpisode.AdmTime  //入院时间
				s:(PAAdmDate '= "") PAAdmDate = ##class(DHCEPRRBAC.Util.Utilization).FormatDisplayDate(PAAdmDate)
				s:(PAAdmTime '= "") PAAdmTime = $zt(PAAdmTime)
				
				//病区
				s PAAdmWard = objMREpisode.AdmWard
				
				//当前科室
				s PAAdmLoc = objMREpisode.AdmLoc
				if (PAAdmLoc = $c(0)) s PAAdmLoc=""
				
				//出院日期时间
				s PADischgeDate = objMREpisode.DisDate  //出院日期
				s PADischgeTime = objMREpisode.DisTime  //出院时间
				s:(PADischgeDate '= "") PADischgeDate = ##class(DHCEPRRBAC.Util.Utilization).FormatDisplayDate(PADischgeDate)
				s:(PADischgeTime '= "") PADischgeTime = $zt(PADischgeTime)
				
				//在院状态
				s PAStatusType = "出院"
				
				//医生 
				s PAAdmDoc = objMREpisode.MainDoctor
				
				//付费方式
				s PayMode = objMREpisode.PayMode
				
				if (EnableTranslation = 1)
				{
					s:(PAPMISex'="") PAPMISex = ##class(User.CTSex).GetTranByDesc("CTSEXDesc",PAPMISex,langid)
					s:(PAAdmLoc'="") PAAdmLoc = ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",PAAdmLoc,langid)
					s:(PAAdmWard'="") PAAdmWard = ##class(User.PACWard).GetTranByDesc("WARDDesc",PAAdmWard,langid)
					s:(PAAdmDoc'="") PAAdmDoc = ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",PAAdmDoc,langid)
				}
				
	 			s data = $lb(rowID,EpisodeID,PatientID,MedRecordNo,RegNo,PAStatusType,PAAdmType,PAPMIName,PAPMIDOB,PAPMIAge,PAPMISex,PAAdmDate,PAAdmTime,PAAdmWard,PAAdmLoc,PADischgeDate,PADischgeTime,PAAdmDoc,PayMode)
				s ^CacheTemp(repid,ind)=data
				s ind=ind+1
			}
		}
	}
   Quit $$$OK
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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
