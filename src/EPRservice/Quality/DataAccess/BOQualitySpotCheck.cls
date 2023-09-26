Class EPRservice.Quality.DataAccess.BOQualitySpotCheck Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod BatchSetManualCheck(AEpisodeIDs As %String, AOPUserID As %String, AStatus As %String, ASSGroupID As %String, AIsMessage As %String = 0, AFlag As %String = "") As %String
{
	s ret = -1
	q:(AEpisodeIDs = "")||(AOPUserID = "") ret
	
	s lstEpisodeIDs = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AEpisodeIDs,"^","Y")
	q:($listlength(lstEpisodeIDs) = 0) ret
	
	s flag = 1
	TStart
	for i = 1:1:$listlength(lstEpisodeIDs)
	{
		s EpisodeID = $listget(lstEpisodeIDs,i)
		continue:(EpisodeID = "")
		s RowID = $o(^DHCEPRQ.QualitySpotCheckI("IdxEpisodeID"," "_EpisodeID,""))
		if (RowID>0)
		{
			s objSpotCheck = ##Class(EPRinstance.Quality.QualitySpotCheck).%OpenId(RowID)
			s:AStatus="A" IsAdmActive = objSpotCheck.IsAdmActive,objSpotCheck.IsAdmActive = IsAdmActive+1,objSpotCheck.IsMessageActive = AIsMessage
			s:AStatus="D" objSpotCheck.IsActive = "Y"
			s:AStatus="O" objSpotCheck.IsOutActive = "Y"
			S:(AStatus="BS") objSpotCheck.IsBSYActive = AFlag
			S:(AStatus="KS") objSpotCheck.IsSYActive = AFlag

			s:((AStatus="CQC")||(AStatus="IA")||(AStatus="AO"))&&(objSpotCheck.IsCrossActive'[AStatus) objSpotCheck.IsCrossActive=objSpotCheck.IsCrossActive_","_AStatus

			s sc = objSpotCheck.%Save()
			if ('$$$ISOK(sc))
			{
				s flag = -1
				q	
			}
			s objSpotCheckDetail = ##Class(EPRinstance.Quality.QualitySpotCheckDetail).%New()
			s objSpotCheckDetail.CreateUser = AOPUserID
			s objSpotCheckDetail.UserGroupID  = ASSGroupID
			s objSpotCheckDetail.Action = AStatus
			s objSpotCheckDetail.EpisodeID = EpisodeID
			s objSpotCheckDetail.CreateDate = $p($h,",",1)
			s objSpotCheckDetail.CreateTime = $p($h,",",2)
			s objQResult = ##Class(EPRinstance.Quality.QualitySpotCheck).%OpenId(RowID)
			if $IsObject(objQResult)
			{
				s objSpotCheckDetail.TheSpotCheck = objQResult
			}
			s sc = objSpotCheckDetail.%Save()
			if ('$$$ISOK(sc))
			{
				s flag = -1
				q	
			}
		}
		else
		{
			s AdmitDate = $p($g(^PAADM(EpisodeID)),"^",6)
			s objSpotCheck = ##Class(EPRinstance.Quality.QualitySpotCheck).%New()
			s objSpotCheck.EpisodeID = EpisodeID
			s objSpotCheck.AdmitDate = AdmitDate
			S:(AStatus="BS") objSpotCheck.IsBSYActive = AFlag
			S:(AStatus="KS") objSpotCheck.IsSYActive = AFlag

			s objSpotCheck.IsCrossActive=AStatus

			if (AStatus="A")
			{ 
				s objSpotCheck.IsActive = ""
				s objSpotCheck.IsAdmActive = "1"
				s objSpotCheck.IsOutActive = ""
				s objSpotCheck.IsMessageActive = AIsMessage
			}
			if (AStatus="D")
			{ 
				s objSpotCheck.IsActive = "Y"
				s objSpotCheck.IsAdmActive = ""
				s objSpotCheck.IsOutActive = ""
			}
			if (AStatus="O")
			{ 
				s objSpotCheck.IsActive = ""
				s objSpotCheck.IsAdmActive = ""
				s objSpotCheck.IsOutActive = "Y"
			}
			s objSpotCheck.ResumeText = ""
			
			s sc = objSpotCheck.%Save()
			if ('$$$ISOK(sc))
			{
				s flag = -1
				q	
			}
			else
			{
				
				s objSpotCheckDetail = ##Class(EPRinstance.Quality.QualitySpotCheckDetail).%New()
				s objSpotCheckDetail.CreateUser = AOPUserID
				s objSpotCheckDetail.UserGroupID  = ASSGroupID
				s objSpotCheckDetail.Action = AStatus
				s objSpotCheckDetail.EpisodeID = EpisodeID
				s objSpotCheckDetail.CreateDate = $p($h,",",1)
				s objSpotCheckDetail.CreateTime = $p($h,",",2) 
				//s RowId = $o(^DHCEPRQ.QualitySpotCheckI("IdxEpisodeID"," "_EpisodeID,""))
				//s objQResult = ##Class(EPRinstance.Quality.QualitySpotCheck).%OpenId(RowId)
				if $IsObject(objSpotCheck)
				{
					s objSpotCheckDetail.TheSpotCheck = objSpotCheck
				}
				s sc = objSpotCheckDetail.%Save()
				if ('$$$ISOK(sc))
				{
					s flag = -1
					q	
				}
			}
		}
	}
	
	if (flag = 1)
	{
		s ret = 1
		TCommit
	}
	else
	{
		TRollBack	
	}
	q ret
}

/// Creator:	    YHY
/// Create Date:	2017-06-12
/// Desc:	取消手工评价
ClassMethod BatchCancelManualCheck(AEpisodeID As %String, AStatus As %String) As %String
{
	s ret = -1
	q:(AEpisodeID="") ""
	s rowid = ""
	s rowid = $o(^DHCEPRQ.QualitySpotCheckI("IdxEpisodeID"," "_AEpisodeID,rowid))
	q:rowid="" ret
	s objSpotCheck = ##Class(EPRinstance.Quality.QualitySpotCheck).%OpenId(rowid)
	s:AStatus="A" IsAdmActive = objSpotCheck.IsAdmActive,objSpotCheck.IsAdmActive = IsAdmActive-1
	s:AStatus="D" objSpotCheck.IsActive = "N"
	s:AStatus="O" objSpotCheck.IsOutActive = "N"
	s sc = objSpotCheck.%Save()
	if $system.Status.IsError(sc)  //检查更新是否成功
	{           
   		d $system.OBJ.DisplayError(sc) 
   		set ret=-1
	}
	else
	{
		set ret=1
	}
	quit ret
}

/// Creator:	    WZL
/// Create Date:	2021-06-12
/// Desc:	判断是否已经给当前就诊设置过交叉手工检查
ClassMethod GetEpisodeCrossManualFlag(AEpisodeID As %String, AdmType As %String) As %String
{
	s ret = "N"
	q:(AEpisodeID = "") ret
	
	s RowID = $o(^DHCEPRQ.QualitySpotCheckI("IdxEpisodeID"," "_AEpisodeID,""))
	q:RowID="" ret
	s objSpotCheck = ##class(EPRinstance.Quality.QualitySpotCheck).%OpenId(RowID)
	
	s CrossActive=objSpotCheck.IsCrossActive
	
	q:(CrossActive'[AdmType) ret
	
	s length=$l(CrossActive,",")
	
	s count=0
	
	for i=1:1:length
	{
		s isActive=$p(CrossActive,",",i)
		continue:(isActive'=AdmType)
		s count=count+1
	}
	
	s ret = count //做过的次数
	
	q ret
}

/// Creator:	    YHY
/// Create Date:	2017-06-12
/// Desc:	判断是否已经给当前就诊设置过终末手工检查
ClassMethod GetEpisodeDisManualFlag(AEpisodeID As %String) As %String
{
	s ret = "N"
	q:(AEpisodeID = "") ret
	
	s RowID = $o(^DHCEPRQ.QualitySpotCheckI("IdxEpisodeID"," "_AEpisodeID,""))
	q:RowID="" ret
	s objSpotCheck = ##class(EPRinstance.Quality.QualitySpotCheck).%OpenId(RowID)
	s ret = objSpotCheck.IsActive
	q ret
}

/// Creator:	    YHY
/// Create Date:	2017-06-12
/// Desc:	判断是否已经给当前就诊设置过环节手工检查
ClassMethod GetEpisodeAdmManualFlag(AEpisodeID As %String) As %String
{
	s ret = ""
	q:(AEpisodeID = "") ret
	s SpotCheck = "",CreateDate="",CreateTime = ""
	s RowID = $o(^DHCEPRQ.QualitySpotCheckI("IdxEpisodeID"," "_AEpisodeID,""))
	q:RowID="" ret
	s objSpotCheck = ##class(EPRinstance.Quality.QualitySpotCheck).%OpenId(RowID)
	s ret = objSpotCheck.IsAdmActive
	s TheSpotCheck = ""
	for {
		s TheSpotCheck = $o(^DHCEPRQ.QualitySpotCheckDetailI("IdxSpotCheck",RowID,TheSpotCheck))
		q:TheSpotCheck=""
		s SpotCheck = TheSpotCheck
	}
	
	q:SpotCheck="" ret
	s DetailID = RowID_"||"_SpotCheck
	s objSpotCheckDetail = ##class(EPRinstance.Quality.QualitySpotCheckDetail).%OpenId(DetailID)
	s SSGroupID = objSpotCheckDetail.UserGroupID
	s:(objSpotCheckDetail.CreateDate'="") CreateDate = $zd(objSpotCheckDetail.CreateDate,3)
	s:(objSpotCheckDetail.CreateTime'="") CreateTime = $zt(objSpotCheckDetail.CreateTime)
	s CreateDT = CreateDate_" "_CreateTime
	q ret_"^"_SSGroupID_"^"_CreateDT
}

/// Creator:	    YHY
/// Create Date:	2017-06-12
/// Desc:	获取环节质控医师 
ClassMethod GetCreateAdmUserByEpisodeID(AEpisodeID As %String) As %String
{
	s ret = ""
	q:(AEpisodeID = "") ret
	s SpotCheck = ""
	s RowID = $o(^DHCEPRQ.QualitySpotCheckI("IdxEpisodeID"," "_AEpisodeID,""))
	q:RowID="" ret
	s TheSpotCheck = ""
	for {
		s TheSpotCheck = $o(^DHCEPRQ.QualitySpotCheckDetailI("IdxSpotCheck",RowID,TheSpotCheck))
		q:TheSpotCheck=""
		s SpotCheck = TheSpotCheck
	}
	q:SpotCheck="" ret
	s DetailID = RowID_"||"_SpotCheck
	s objSpotCheckDetail = ##class(EPRinstance.Quality.QualitySpotCheckDetail).%OpenId(DetailID)
	s ret = objSpotCheckDetail.CreateUser
	s:(ret'="") ret = $p($g(^SSU("SSUSR",ret)),"^",2)
	q ret
}

/// Creator:	    YHY
/// Create Date:	2017-06-12
/// Desc:	获取终末质控医师
ClassMethod GetCreateUserByEpisodeID(AEpisodeID As %String) As %String
{
	s ret = ""
	q:(AEpisodeID = "") ret
	s SpotCheck = ""
	s RowID = $o(^DHCEPRQ.QualitySpotCheckI("IdxEpisodeID"," "_AEpisodeID,""))
	q:RowID="" ret
	s TheSpotCheck = ""
	for {
		s TheSpotCheck = $o(^DHCEPRQ.QualitySpotCheckDetailI("IdxSpotCheck",RowID,TheSpotCheck))
		q:TheSpotCheck=""
		s SpotCheck = TheSpotCheck
	}
	q:SpotCheck="" ret
	s DetailID = RowID_"||"_SpotCheck
	s objSpotCheckDetail = ##class(EPRinstance.Quality.QualitySpotCheckDetail).%OpenId(DetailID)
	s ret = objSpotCheckDetail.CreateUser
	s:(ret'="") ret = $p($g(^SSU("SSUSR",ret)),"^",2)
	q ret
}

/// Creator:	    YHY
/// Create Date:	2017-06-12
/// Desc:	判断是否已经给当前就诊设置过门诊手工检查
ClassMethod GetEpisodeOutManualFlag(AEpisodeID As %String) As %String
{
	s ret = "N"
	q:(AEpisodeID = "") ret
	
	s RowID = $o(^DHCEPRQ.QualitySpotCheckI("IdxEpisodeID"," "_AEpisodeID,""))
	q:RowID="" ret
	s objSpotCheck = ##class(EPRinstance.Quality.QualitySpotCheck).%OpenId(RowID)
	
	s ret = objSpotCheck.IsOutActive
	q ret
}

/// Creator:	    YHY
/// Create Date:	2017-06-12
/// Desc:	获取门诊质控医师
ClassMethod GetCreateOutUserByEpisodeID(AEpisodeID As %String) As %String
{
	s ret = ""
	q:(AEpisodeID = "") ret
	s SpotCheck = ""
	s RowID = $o(^DHCEPRQ.QualitySpotCheckI("IdxEpisodeID"," "_AEpisodeID,""))
	q:RowID="" ret
	s TheSpotCheck = ""
	for {
		s TheSpotCheck = $o(^DHCEPRQ.QualitySpotCheckDetailI("IdxSpotCheck",RowID,TheSpotCheck))
		q:TheSpotCheck=""
		s SpotCheck = TheSpotCheck
	}
	q:SpotCheck="" ret
	s DetailID = RowID_"||"_SpotCheck
	s objSpotCheckDetail = ##class(EPRinstance.Quality.QualitySpotCheckDetail).%OpenId(DetailID)
	s ret = objSpotCheckDetail.CreateUser
	s:(ret'="") ret = $p($g(^SSU("SSUSR",ret)),"^",2)
	q ret
}

/// Creator:	    YHY
/// Create Date:	2017-06-12
/// Desc:	判断当前患者环节质控缺陷标志
///         0：无缺陷  1：有缺陷未修正  2：有缺陷全部修正
/// Debug: w ##class(EPRservice.Quality.DataAccess.BOQualitySpotCheck).GetEpisodeMessageFlag(EpisodeID)
ClassMethod GetEpisodeMessageFlag(AEpisodeID As %String) As %String
{
	s ret = 0
	q:(AEpisodeID = "") ret
	
	s RowID = $o(^DHCEPRQ.QualitySpotCheckI("IdxEpisodeID"," "_AEpisodeID,""))
	q:RowID="" ret
	s objSpotCheck = ##class(EPRinstance.Quality.QualitySpotCheck).%OpenId(RowID)
	s ret = objSpotCheck.IsMessageActive
	q ret
}

/// Creator:	    YHY
/// Create Date:	2017-06-12
/// Desc:	判断是否已经给当前就诊设置科室首页手工检查
ClassMethod GetEpisodeKSManualFlag(AEpisodeID As %String) As %String
{
	s ret = "N"
	q:(AEpisodeID = "") ret
	
	s RowID = $o(^DHCEPRQ.QualitySpotCheckI("IdxEpisodeID"," "_AEpisodeID,""))
	q:RowID="" ret
	s objSpotCheck = ##class(EPRinstance.Quality.QualitySpotCheck).%OpenId(RowID)
	s ret = objSpotCheck.IsSYActive
	s:ret="" ret="N"
	q ret
}

/// Creator:	    YHY
/// Create Date:	2017-06-12
/// Desc:	判断是否已经给当前就诊设置病案室首页手工检查
ClassMethod GetEpisodeBSManualFlag(AEpisodeID As %String) As %String
{
	s ret = "N"
	q:(AEpisodeID = "") ret
	
	s RowID = $o(^DHCEPRQ.QualitySpotCheckI("IdxEpisodeID"," "_AEpisodeID,""))
	q:RowID="" ret
	s objSpotCheck = ##class(EPRinstance.Quality.QualitySpotCheck).%OpenId(RowID)
	s ret = objSpotCheck.IsBSYActive
	s:ret="" ret="N"
	q ret
}

/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataAccess.BOQualitySpotCheck","GetManualAnalysis","4^5^6^7","01/12/2008","31/12/2008","31563^31564^31565","Y")
Query GetManualAnalysis(ALocIDs As %String, AStartDate As %String, AEndDate As %String, AEntryIDs As %String, AAnalysisFlag As %String) As %Query(ROWSPEC = "EntryIDs,LocID,Department,DocID,Doctor,StartDate,EndDate,Count,Count1,Count2,Count3,Count4,Count5,Count6,Count7,Count8,Count9,Count10,Count11,Count12,Count13,Count14,Count15,Count16,Count17,Count18,Count19,Count20,Count21,Count22,Count23,Count24,Count25,Count26,Count27,Count28,Count29,Count30,Count31,Count32,Count33,Count34,Count35,Count36,Count37,Count38,Count39,Count40,Count41,Count42,Count43,Count44,Count45,Count46,Count47,Count48,Count49,Count50,Summary")
{
}

ClassMethod GetManualAnalysisExecute(ByRef qHandle As %Binary, ALocIDs As %String, AStartDate As %String, AEndDate As %String, AEntryIDs As %String, AAnalysisFlag As %String) As %Status
{
	s uid = $i(^CacheTemp)
	s ind = 2
	s qHandle = $lb(0,uid,"")
	
	/* If you want some debug infomation, just open this closure notes, you should know where the ^CacheTempXZX stored at first
	s ^CacheTempXZX("EPRQuality","GetManualAnalysis","ALocIDs")	 	  = ALocIDs
	s ^CacheTempXZX("EPRQuality","GetManualAnalysis","AStartDate") 	  = AStartDate
	s ^CacheTempXZX("EPRQuality","GetManualAnalysis","AEndDate")   	  = AEndDate
	s ^CacheTempXZX("EPRQuality","GetManualAnalysis","AEntryIDs")	  = AEntryIDs
	s ^CacheTempXZX("EPRQuality","GetManualAnalysis","AAnalysisFlag") = AAnalysisFlag
	*/

	// Just exit with no query condition
	q:(ALocIDs = "")||(AStartDate = "")||(AEndDate = "")||(AEntryIDs = "") $$$OK
	
	// Get loc list without empty elements
	s lstLocID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,",")
	q:($listlength(lstLocID) = 0) $$$OK
	
	// Get entrys list with empty elements
	s lstEntryID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AEntryIDs,"^","N")
	q:($listlength(lstEntryID) = 0) $$$OK
	
	s IsMultiSummary = $s($p(AAnalysisFlag,"^",1)'="":$p(AAnalysisFlag,"^",1),1:"N")
	s IsWithPercent	 = $s($p(AAnalysisFlag,"^",2)'="":$p(AAnalysisFlag,"^",2),1:"N")
	
	s StartDate	= $g(AStartDate)
	s EndDate	= $g(AEndDate)
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(StartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(EndDate)," ",1)

	k ^CacheTemp("EPRQuality","ManualReport",uid)
	
	s Number = 0
	s (Count,Summary) = 0
	s (Count1,Count2,Count3,Count4,Count5,Count6,Count7,Count8,Count9,Count10,Count11,Count12,Count13,Count14,Count15,Count16,Count17,Count18,Count19,Count20) = 0
	s (Count21,Count22,Count23,Count24,Count25,Count26,Count27,Count28,Count29,Count30,Count31,Count32,Count33,Count34,Count35,Count36,Count37,Count38,Count39,Count40) = 0
	s (Count41,Count42,Count43,Count44,Count45,Count46,Count47,Count48,Count49,Count50) = 0
	
	for AdmitDate = StartDate:1:EndDate
	{
		s RowID = ""
		for {
			s RowID = $o(^DHCEPRQ.QualitySpotCheckI("IdxAdmitDate",AdmitDate,RowID))
			q:(RowID = "")
			
			s objSpotCheck = $g(^DHCEPRQ.QualitySpotCheckD(RowID))
			continue:(objSpotCheck = "")
			
			s EpisodeID = $list(objSpotCheck,2)
			continue:(EpisodeID = "")
			
			// BuildManualReportList(EpisodeID,ListLocID,RuleCode,UniqueKey)
			s flag = ..BuildManualReportList(EpisodeID,lstLocID,lstEntryID,uid)
			continue:(flag < 0)
			
			s Number = Number + 1
		}	
	}
	
	if (Number = 0)
	{
		s Data = $lb(AEntryIDs,ALocIDs,"合计","","------",StartDate,EndDate,Count,Count1,Count2,Count3,Count4,Count5,Count6,Count7,Count8,Count9,Count10,Count11,Count12,Count13,Count14,Count15,Count16,Count17,Count18,Count19,Count20,Count21,Count22,Count23,Count24,Count25,Count26,Count27,Count28,Count29,Count30,Count31,Count32,Count33,Count34,Count35,Count36,Count37,Count38,Count39,Count40,Count41,Count42,Count43,Count44,Count45,Count46,Count47,Count48,Count49,Count50,Summary)
		s ^CacheTemp(uid,1) = Data
		
		k ^CacheTemp("EPRQuality","ManualReport",uid)
		
		q $$$OK	
	}

	s DisLocID = ""
	for	{ 
		s DisLocID = $o(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID)) 
		q:(DisLocID = "")
		
		s LocDesc = $p($g(^CTLOC(+DisLocID)),"^",2)
		s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
		
		s (LocCount,LocSummary) = 0
		s (LocCount1,LocCount2,LocCount3,LocCount4,LocCount5,LocCount6,LocCount7,LocCount8,LocCount9,LocCount10,LocCount11,LocCount12,LocCount13,LocCount14,LocCount15,LocCount16,LocCount17,LocCount18,LocCount19,LocCount20) = 0
		s (LocCount21,LocCount22,LocCount23,LocCount24,LocCount25,LocCount26,LocCount27,LocCount28,LocCount29,LocCount30,LocCount31,LocCount32,LocCount33,LocCount34,LocCount35,LocCount36,LocCount37,LocCount38,LocCount39,LocCount40) = 0
		s (LocCount41,LocCount42,LocCount43,LocCount44,LocCount45,LocCount46,LocCount47,LocCount48,LocCount49,LocCount50) = 0
						
		s DocID = ""
		for { 
			s DocID = $o(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID)) 
			q:(DocID = "") 
			
			if (DocID '= "-1")
			{
				s DoctorDesc = $p($g(^CTPCP(+DocID)),"^",2)    			//CT_CareProv
				s SSUserID = $o(^SSU("SSUSR",0,"CTPCP",+DocID,0))  		//SS_User
				s:(SSUserID '= "") DoctorDesc = $p($g(^SSU("SSUSR",+SSUserID)),"^",2)
			}
			else
			{
				s DoctorDesc = "未指定"	
			}
			
			s (DocCount,DocSummary) = 0
			s (DocCount1,DocCount2,DocCount3,DocCount4,DocCount5,DocCount6,DocCount7,DocCount8,DocCount9,DocCount10,DocCount11,DocCount12,DocCount13,DocCount14,DocCount15,DocCount16,DocCount17,DocCount18,DocCount19,DocCount20) = 0
			s (DocCount21,DocCount22,DocCount23,DocCount24,DocCount25,DocCount26,DocCount27,DocCount28,DocCount29,DocCount30,DocCount31,DocCount32,DocCount33,DocCount34,DocCount35,DocCount36,DocCount37,DocCount38,DocCount39,DocCount40) = 0
			s (DocCount41,DocCount42,DocCount43,DocCount44,DocCount45,DocCount46,DocCount47,DocCount48,DocCount49,DocCount50) = 0
		
			s DocCount = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,"Count"))		
			s:($listget(lstEntryID,1) '= "") DocCount1 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,1),"Count"))
			s:($listget(lstEntryID,2) '= "") DocCount2 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,2),"Count"))
			s:($listget(lstEntryID,3) '= "") DocCount3 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,3),"Count"))
			s:($listget(lstEntryID,4) '= "") DocCount4 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,4),"Count"))
			s:($listget(lstEntryID,5) '= "") DocCount5 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,5),"Count"))
			s:($listget(lstEntryID,5) '= "") DocCount6 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,6),"Count"))
			s:($listget(lstEntryID,7) '= "") DocCount7 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,7),"Count"))
			s:($listget(lstEntryID,8) '= "") DocCount8 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,8),"Count"))
			s:($listget(lstEntryID,9) '= "") DocCount9 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,9),"Count"))
			s:($listget(lstEntryID,10) '= "") DocCount10 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,10),"Count"))
			s:($listget(lstEntryID,11) '= "") DocCount11 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,11),"Count"))
			s:($listget(lstEntryID,12) '= "") DocCount12 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,12),"Count"))
			s:($listget(lstEntryID,13) '= "") DocCount13 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,13),"Count"))
			s:($listget(lstEntryID,14) '= "") DocCount14 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,14),"Count"))
			s:($listget(lstEntryID,15) '= "") DocCount15 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,15),"Count"))
			s:($listget(lstEntryID,16) '= "") DocCount16 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,16),"Count"))
			s:($listget(lstEntryID,17) '= "") DocCount17 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,17),"Count"))
			s:($listget(lstEntryID,18) '= "") DocCount18 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,18),"Count"))
			s:($listget(lstEntryID,19) '= "") DocCount18 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,19),"Count"))
			s:($listget(lstEntryID,20) '= "") DocCount20 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,20),"Count"))
			s:($listget(lstEntryID,21) '= "") DocCount21 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,21),"Count"))
			s:($listget(lstEntryID,22) '= "") DocCount22 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,22),"Count"))
			s:($listget(lstEntryID,23) '= "") DocCount23 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,23),"Count"))
			s:($listget(lstEntryID,24) '= "") DocCount24 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,24),"Count"))
			s:($listget(lstEntryID,25) '= "") DocCount25 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,25),"Count"))
			s:($listget(lstEntryID,26) '= "") DocCount26 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,26),"Count"))
			s:($listget(lstEntryID,27) '= "") DocCount27 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,27),"Count"))
			s:($listget(lstEntryID,28) '= "") DocCount28 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,28),"Count"))
			s:($listget(lstEntryID,29) '= "") DocCount29 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,29),"Count"))
			s:($listget(lstEntryID,30) '= "") DocCount30 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,30),"Count"))
			s:($listget(lstEntryID,31) '= "") DocCount31 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,31),"Count"))
			s:($listget(lstEntryID,32) '= "") DocCount32 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,32),"Count"))
			s:($listget(lstEntryID,33) '= "") DocCount33 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,33),"Count"))
			s:($listget(lstEntryID,34) '= "") DocCount34 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,34),"Count"))
			s:($listget(lstEntryID,35) '= "") DocCount35 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,35),"Count"))
			s:($listget(lstEntryID,36) '= "") DocCount36 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,36),"Count"))
			s:($listget(lstEntryID,37) '= "") DocCount37 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,37),"Count"))
			s:($listget(lstEntryID,38) '= "") DocCount38 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,38),"Count"))
			s:($listget(lstEntryID,39) '= "") DocCount39 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,39),"Count"))
			s:($listget(lstEntryID,40) '= "") DocCount40 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,40),"Count"))
			s:($listget(lstEntryID,41) '= "") DocCount41 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,41),"Count"))
			s:($listget(lstEntryID,42) '= "") DocCount42 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,42),"Count"))
			s:($listget(lstEntryID,43) '= "") DocCount43 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,43),"Count"))
			s:($listget(lstEntryID,44) '= "") DocCount44 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,44),"Count"))
			s:($listget(lstEntryID,45) '= "") DocCount45 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,45),"Count"))
			s:($listget(lstEntryID,46) '= "") DocCount46 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,46),"Count"))
			s:($listget(lstEntryID,47) '= "") DocCount47 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,47),"Count"))
			s:($listget(lstEntryID,48) '= "") DocCount48 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,48),"Count"))
			s:($listget(lstEntryID,49) '= "") DocCount49 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,49),"Count"))
			s:($listget(lstEntryID,50) '= "") DocCount50 = +$g(^CacheTemp("EPRQuality","ManualReport",uid,DisLocID,DocID,$listget(lstEntryID,50),"Count"))
			s DocSummary = DocCount1+DocCount2+DocCount3+DocCount4+DocCount5+DocCount6+DocCount7+DocCount8+DocCount9+DocCount10+DocCount11+DocCount12+DocCount13+DocCount14+DocCount15+DocCount16+DocCount17+DocCount18+DocCount19+DocCount20+DocCount21+DocCount22+DocCount23+DocCount24+DocCount25+DocCount26+DocCount27+DocCount28+DocCount29+DocCount30+DocCount31+DocCount32+DocCount33+DocCount34+DocCount35+DocCount36+DocCount37+DocCount38+DocCount39+DocCount40+DocCount41+DocCount42+DocCount43+DocCount44+DocCount45+DocCount46+DocCount47+DocCount48+DocCount49+DocCount50
			
			if (IsWithPercent = "Y")
			{
				// 百分比计算
				s Doc1Percent = $s(DocCount1*100#DocCount=0:DocCount1*100/DocCount,1:$s(DocCount1*100/DocCount>=0.1:$j(DocCount1*100/DocCount,2,1),1:"<0.1"))
				s Doc2Percent = $s(DocCount2*100#DocCount=0:DocCount2*100/DocCount,1:$s(DocCount2*100/DocCount>=0.1:$j(DocCount2*100/DocCount,2,1),1:"<0.1"))
				s Doc3Percent = $s(DocCount3*100#DocCount=0:DocCount3*100/DocCount,1:$s(DocCount3*100/DocCount>=0.1:$j(DocCount3*100/DocCount,2,1),1:"<0.1"))
				s Doc4Percent = $s(DocCount4*100#DocCount=0:DocCount4*100/DocCount,1:$s(DocCount4*100/DocCount>=0.1:$j(DocCount4*100/DocCount,2,1),1:"<0.1"))
				s Doc5Percent = $s(DocCount5*100#DocCount=0:DocCount5*100/DocCount,1:$s(DocCount5*100/DocCount>=0.1:$j(DocCount5*100/DocCount,2,1),1:"<0.1"))
				s Doc6Percent = $s(DocCount6*100#DocCount=0:DocCount6*100/DocCount,1:$s(DocCount6*100/DocCount>=0.1:$j(DocCount6*100/DocCount,2,1),1:"<0.1"))
				s Doc7Percent = $s(DocCount7*100#DocCount=0:DocCount7*100/DocCount,1:$s(DocCount7*100/DocCount>=0.1:$j(DocCount7*100/DocCount,2,1),1:"<0.1"))
				s Doc8Percent = $s(DocCount8*100#DocCount=0:DocCount8*100/DocCount,1:$s(DocCount8*100/DocCount>=0.1:$j(DocCount8*100/DocCount,2,1),1:"<0.1"))
				s Doc9Percent = $s(DocCount9*100#DocCount=0:DocCount9*100/DocCount,1:$s(DocCount9*100/DocCount>=0.1:$j(DocCount9*100/DocCount,2,1),1:"<0.1"))
				s Doc10Percent = $s(DocCount10*100#DocCount=0:DocCount10*100/DocCount,1:$s(DocCount10*100/DocCount>=0.1:$j(DocCount10*100/DocCount,2,1),1:"<0.1"))
				s Doc11Percent = $s(DocCount11*100#DocCount=0:DocCount11*100/DocCount,1:$s(DocCount11*100/DocCount>=0.1:$j(DocCount11*100/DocCount,2,1),1:"<0.1"))
				s Doc12Percent = $s(DocCount12*100#DocCount=0:DocCount12*100/DocCount,1:$s(DocCount12*100/DocCount>=0.1:$j(DocCount12*100/DocCount,2,1),1:"<0.1"))
				s Doc13Percent = $s(DocCount13*100#DocCount=0:DocCount13*100/DocCount,1:$s(DocCount13*100/DocCount>=0.1:$j(DocCount13*100/DocCount,2,1),1:"<0.1"))
				s Doc14Percent = $s(DocCount14*100#DocCount=0:DocCount14*100/DocCount,1:$s(DocCount14*100/DocCount>=0.1:$j(DocCount14*100/DocCount,2,1),1:"<0.1"))
				s Doc15Percent = $s(DocCount15*100#DocCount=0:DocCount15*100/DocCount,1:$s(DocCount15*100/DocCount>=0.1:$j(DocCount15*100/DocCount,2,1),1:"<0.1"))
				s Doc16Percent = $s(DocCount16*100#DocCount=0:DocCount16*100/DocCount,1:$s(DocCount16*100/DocCount>=0.1:$j(DocCount16*100/DocCount,2,1),1:"<0.1"))
				s Doc17Percent = $s(DocCount17*100#DocCount=0:DocCount17*100/DocCount,1:$s(DocCount17*100/DocCount>=0.1:$j(DocCount17*100/DocCount,2,1),1:"<0.1"))
				s Doc18Percent = $s(DocCount18*100#DocCount=0:DocCount18*100/DocCount,1:$s(DocCount18*100/DocCount>=0.1:$j(DocCount18*100/DocCount,2,1),1:"<0.1"))
				s Doc19Percent = $s(DocCount19*100#DocCount=0:DocCount19*100/DocCount,1:$s(DocCount19*100/DocCount>=0.1:$j(DocCount19*100/DocCount,2,1),1:"<0.1"))
				s Doc20Percent = $s(DocCount20*100#DocCount=0:DocCount20*100/DocCount,1:$s(DocCount20*100/DocCount>=0.1:$j(DocCount20*100/DocCount,2,1),1:"<0.1"))
				s Doc21Percent = $s(DocCount21*100#DocCount=0:DocCount21*100/DocCount,1:$s(DocCount21*100/DocCount>=0.1:$j(DocCount21*100/DocCount,2,1),1:"<0.1"))
				s Doc22Percent = $s(DocCount22*100#DocCount=0:DocCount22*100/DocCount,1:$s(DocCount22*100/DocCount>=0.1:$j(DocCount22*100/DocCount,2,1),1:"<0.1"))
				s Doc23Percent = $s(DocCount23*100#DocCount=0:DocCount23*100/DocCount,1:$s(DocCount23*100/DocCount>=0.1:$j(DocCount23*100/DocCount,2,1),1:"<0.1"))
				s Doc24Percent = $s(DocCount24*100#DocCount=0:DocCount24*100/DocCount,1:$s(DocCount24*100/DocCount>=0.1:$j(DocCount24*100/DocCount,2,1),1:"<0.1"))
				s Doc25Percent = $s(DocCount25*100#DocCount=0:DocCount25*100/DocCount,1:$s(DocCount25*100/DocCount>=0.1:$j(DocCount25*100/DocCount,2,1),1:"<0.1"))
				s Doc26Percent = $s(DocCount26*100#DocCount=0:DocCount26*100/DocCount,1:$s(DocCount26*100/DocCount>=0.1:$j(DocCount26*100/DocCount,2,1),1:"<0.1"))
				s Doc27Percent = $s(DocCount27*100#DocCount=0:DocCount27*100/DocCount,1:$s(DocCount27*100/DocCount>=0.1:$j(DocCount27*100/DocCount,2,1),1:"<0.1"))
				s Doc28Percent = $s(DocCount28*100#DocCount=0:DocCount28*100/DocCount,1:$s(DocCount28*100/DocCount>=0.1:$j(DocCount28*100/DocCount,2,1),1:"<0.1"))
				s Doc29Percent = $s(DocCount29*100#DocCount=0:DocCount29*100/DocCount,1:$s(DocCount29*100/DocCount>=0.1:$j(DocCount29*100/DocCount,2,1),1:"<0.1"))
				s Doc30Percent = $s(DocCount30*100#DocCount=0:DocCount30*100/DocCount,1:$s(DocCount30*100/DocCount>=0.1:$j(DocCount30*100/DocCount,2,1),1:"<0.1"))
				s Doc31Percent = $s(DocCount31*100#DocCount=0:DocCount31*100/DocCount,1:$s(DocCount31*100/DocCount>=0.1:$j(DocCount31*100/DocCount,2,1),1:"<0.1"))
				s Doc32Percent = $s(DocCount32*100#DocCount=0:DocCount32*100/DocCount,1:$s(DocCount32*100/DocCount>=0.1:$j(DocCount32*100/DocCount,2,1),1:"<0.1"))
				s Doc33Percent = $s(DocCount33*100#DocCount=0:DocCount33*100/DocCount,1:$s(DocCount33*100/DocCount>=0.1:$j(DocCount33*100/DocCount,2,1),1:"<0.1"))
				s Doc34Percent = $s(DocCount34*100#DocCount=0:DocCount34*100/DocCount,1:$s(DocCount34*100/DocCount>=0.1:$j(DocCount34*100/DocCount,2,1),1:"<0.1"))
				s Doc35Percent = $s(DocCount35*100#DocCount=0:DocCount35*100/DocCount,1:$s(DocCount35*100/DocCount>=0.1:$j(DocCount35*100/DocCount,2,1),1:"<0.1"))
				s Doc36Percent = $s(DocCount36*100#DocCount=0:DocCount36*100/DocCount,1:$s(DocCount36*100/DocCount>=0.1:$j(DocCount36*100/DocCount,2,1),1:"<0.1"))
				s Doc37Percent = $s(DocCount37*100#DocCount=0:DocCount37*100/DocCount,1:$s(DocCount37*100/DocCount>=0.1:$j(DocCount37*100/DocCount,2,1),1:"<0.1"))
				s Doc38Percent = $s(DocCount38*100#DocCount=0:DocCount38*100/DocCount,1:$s(DocCount38*100/DocCount>=0.1:$j(DocCount38*100/DocCount,2,1),1:"<0.1"))
				s Doc39Percent = $s(DocCount39*100#DocCount=0:DocCount39*100/DocCount,1:$s(DocCount39*100/DocCount>=0.1:$j(DocCount39*100/DocCount,2,1),1:"<0.1"))
				s Doc40Percent = $s(DocCount40*100#DocCount=0:DocCount40*100/DocCount,1:$s(DocCount40*100/DocCount>=0.1:$j(DocCount40*100/DocCount,2,1),1:"<0.1"))
				s Doc41Percent = $s(DocCount41*100#DocCount=0:DocCount41*100/DocCount,1:$s(DocCount41*100/DocCount>=0.1:$j(DocCount41*100/DocCount,2,1),1:"<0.1"))
				s Doc42Percent = $s(DocCount42*100#DocCount=0:DocCount42*100/DocCount,1:$s(DocCount42*100/DocCount>=0.1:$j(DocCount42*100/DocCount,2,1),1:"<0.1"))
				s Doc43Percent = $s(DocCount43*100#DocCount=0:DocCount43*100/DocCount,1:$s(DocCount43*100/DocCount>=0.1:$j(DocCount43*100/DocCount,2,1),1:"<0.1"))
				s Doc44Percent = $s(DocCount44*100#DocCount=0:DocCount44*100/DocCount,1:$s(DocCount44*100/DocCount>=0.1:$j(DocCount44*100/DocCount,2,1),1:"<0.1"))
				s Doc45Percent = $s(DocCount45*100#DocCount=0:DocCount45*100/DocCount,1:$s(DocCount45*100/DocCount>=0.1:$j(DocCount45*100/DocCount,2,1),1:"<0.1"))
				s Doc46Percent = $s(DocCount46*100#DocCount=0:DocCount46*100/DocCount,1:$s(DocCount46*100/DocCount>=0.1:$j(DocCount46*100/DocCount,2,1),1:"<0.1"))
				s Doc47Percent = $s(DocCount47*100#DocCount=0:DocCount47*100/DocCount,1:$s(DocCount47*100/DocCount>=0.1:$j(DocCount47*100/DocCount,2,1),1:"<0.1"))
				s Doc48Percent = $s(DocCount48*100#DocCount=0:DocCount48*100/DocCount,1:$s(DocCount48*100/DocCount>=0.1:$j(DocCount48*100/DocCount,2,1),1:"<0.1"))
				s Doc49Percent = $s(DocCount49*100#DocCount=0:DocCount49*100/DocCount,1:$s(DocCount49*100/DocCount>=0.1:$j(DocCount49*100/DocCount,2,1),1:"<0.1"))
				s Doc50Percent = $s(DocCount50*100#DocCount=0:DocCount50*100/DocCount,1:$s(DocCount50*100/DocCount>=0.1:$j(DocCount50*100/DocCount,2,1),1:"<0.1"))
				
				s Doc1Result = DocCount1_" - "_Doc1Percent_"%",Doc2Result = DocCount2_" - "_Doc2Percent_"%",Doc3Result = DocCount3_" - "_Doc3Percent_"%",Doc4Result = DocCount4_" - "_Doc4Percent_"%"
				s Doc5Result = DocCount5_" - "_Doc5Percent_"%",Doc6Result = DocCount6_" - "_Doc6Percent_"%",Doc7Result = DocCount7_" - "_Doc7Percent_"%",Doc8Result = DocCount8_" - "_Doc8Percent_"%"
				s Doc9Result = DocCount9_" - "_Doc9Percent_"%",Doc10Result = DocCount10_" - "_Doc10Percent_"%",Doc11Result = DocCount11_" - "_Doc11Percent_"%",Doc12Result = DocCount12_" - "_Doc12Percent_"%"
				s Doc13Result = DocCount13_" - "_Doc13Percent_"%",Doc14Result = DocCount14_" - "_Doc14Percent_"%",Doc15Result = DocCount15_" - "_Doc15Percent_"%",Doc16Result = DocCount16_" - "_Doc16Percent_"%"
				s Doc17Result = DocCount17_" - "_Doc17Percent_"%",Doc18Result = DocCount18_" - "_Doc18Percent_"%",Doc19Result = DocCount19_" - "_Doc19Percent_"%",Doc20Result = DocCount20_" - "_Doc20Percent_"%"
				s Doc21Result = DocCount21_" - "_Doc21Percent_"%",Doc22Result = DocCount22_" - "_Doc22Percent_"%",Doc23Result = DocCount23_" - "_Doc23Percent_"%",Doc24Result = DocCount24_" - "_Doc24Percent_"%"
				s Doc25Result = DocCount25_" - "_Doc25Percent_"%",Doc26Result = DocCount26_" - "_Doc26Percent_"%",Doc27Result = DocCount27_" - "_Doc27Percent_"%",Doc28Result = DocCount28_" - "_Doc28Percent_"%"
				s Doc29Result = DocCount29_" - "_Doc29Percent_"%",Doc30Result = DocCount30_" - "_Doc30Percent_"%",Doc31Result = DocCount31_" - "_Doc31Percent_"%",Doc32Result = DocCount32_" - "_Doc32Percent_"%"
				s Doc33Result = DocCount33_" - "_Doc33Percent_"%",Doc34Result = DocCount34_" - "_Doc34Percent_"%",Doc35Result = DocCount35_" - "_Doc35Percent_"%",Doc36Result = DocCount36_" - "_Doc36Percent_"%"
				s Doc37Result = DocCount37_" - "_Doc37Percent_"%",Doc38Result = DocCount38_" - "_Doc38Percent_"%",Doc39Result = DocCount39_" - "_Doc39Percent_"%",Doc40Result = DocCount40_" - "_Doc40Percent_"%"
				s Doc41Result = DocCount41_" - "_Doc41Percent_"%",Doc42Result = DocCount42_" - "_Doc42Percent_"%",Doc43Result = DocCount43_" - "_Doc43Percent_"%",Doc44Result = DocCount44_" - "_Doc44Percent_"%"
				s Doc45Result = DocCount45_" - "_Doc45Percent_"%",Doc46Result = DocCount46_" - "_Doc46Percent_"%",Doc47Result = DocCount47_" - "_Doc47Percent_"%",Doc48Result = DocCount48_" - "_Doc48Percent_"%"
				s Doc49Result = DocCount49_" - "_Doc49Percent_"%",Doc50Result = DocCount50_" - "_Doc50Percent_"%"
					
				// 医生总计
				s Data = $lb(AEntryIDs,DisLocID,"------",DocID,DoctorDesc,StartDate,EndDate,DocCount,Doc1Result,Doc2Result,Doc3Result,Doc4Result,Doc5Result,Doc6Result,Doc7Result,Doc8Result,Doc9Result,Doc10Result,Doc11Result,Doc12Result,Doc13Result,Doc14Result,Doc15Result,Doc16Result,Doc17Result,Doc18Result,Doc19Result,Doc20Result,Doc21Result,Doc22Result,Doc23Result,Doc24Result,Doc25Result,Doc26Result,Doc27Result,Doc28Result,Doc29Result,Doc30Result,Doc31Result,Doc32Result,Doc33Result,Doc34Result,Doc35Result,Doc36Result,Doc37Result,Doc38Result,Doc39Result,Doc40Result,Doc41Result,Doc42Result,Doc43Result,Doc44Result,Doc45Result,Doc46Result,Doc47Result,Doc48Result,Doc49Result,Doc50Result,DocSummary)
				s ^CacheTemp(uid,ind) = Data
				s ind = ind + 1				
			}
			else
			{
				// 医生总计
				s Data = $lb(AEntryIDs,DisLocID,"------",DocID,DoctorDesc,StartDate,EndDate,DocCount,DocCount1,DocCount2,DocCount3,DocCount4,DocCount5,DocCount6,DocCount7,DocCount8,DocCount9,DocCount10,DocCount11,DocCount12,DocCount13,DocCount14,DocCount15,DocCount16,DocCount17,DocCount18,DocCount19,DocCount20,DocCount21,DocCount22,DocCount23,DocCount24,DocCount25,DocCount26,DocCount27,DocCount28,DocCount29,DocCount30,DocCount31,DocCount32,DocCount33,DocCount34,DocCount35,DocCount36,DocCount37,DocCount38,DocCount39,DocCount40,DocCount41,DocCount42,DocCount43,DocCount44,DocCount45,DocCount46,DocCount47,DocCount48,DocCount49,DocCount50,DocSummary)
				s ^CacheTemp(uid,ind) = Data
				s ind = ind + 1
			}
			
			s LocCount = LocCount + DocCount
			s LocCount1 = LocCount1 + DocCount1, LocCount2 = LocCount2 + DocCount2, LocCount3 = LocCount3 + DocCount3, LocCount4 = LocCount4 + DocCount4, LocCount5 = LocCount5 + DocCount5
			s LocCount6 = LocCount6 + DocCount6, LocCount7 = LocCount7 + DocCount7, LocCount8 = LocCount8 + DocCount8, LocCount9 = LocCount9 + DocCount9, LocCount10 = LocCount10 + DocCount10
			s LocCount11 = LocCount11 + DocCount11, LocCount12 = LocCount12 + DocCount12, LocCount13 = LocCount13 + DocCount13, LocCount14 = LocCount14 + DocCount14, LocCount15 = LocCount15 + DocCount15
			s LocCount16 = LocCount16 + DocCount16, LocCount17 = LocCount17 + DocCount17, LocCount18 = LocCount18 + DocCount18, LocCount19 = LocCount19 + DocCount19, LocCount20 = LocCount20 + DocCount20
			s LocCount21 = LocCount21 + DocCount21, LocCount22 = LocCount22 + DocCount22, LocCount23 = LocCount23 + DocCount23, LocCount24 = LocCount24 + DocCount24, LocCount25 = LocCount25 + DocCount25
			s LocCount26 = LocCount26 + DocCount26, LocCount27 = LocCount27 + DocCount27, LocCount28 = LocCount28 + DocCount28, LocCount29 = LocCount29 + DocCount29, LocCount30 = LocCount30 + DocCount30
			s LocCount31 = LocCount31 + DocCount31, LocCount32 = LocCount32 + DocCount32, LocCount33 = LocCount33 + DocCount33, LocCount34 = LocCount34 + DocCount34, LocCount34 = LocCount34 + DocCount35
			s LocCount36 = LocCount36 + DocCount36, LocCount37 = LocCount37 + DocCount37, LocCount38 = LocCount38 + DocCount38, LocCount39 = LocCount39 + DocCount39, LocCount40 = LocCount40 + DocCount40
			s LocCount41 = LocCount41 + DocCount41, LocCount42 = LocCount42 + DocCount42, LocCount43 = LocCount43 + DocCount43, LocCount44 = LocCount44 + DocCount44, LocCount45 = LocCount45 + DocCount45
			s LocCount46 = LocCount46 + DocCount46, LocCount47 = LocCount47 + DocCount47, LocCount48 = LocCount48 + DocCount48, LocCount49 = LocCount49 + DocCount49, LocCount50 = LocCount50 + DocCount50
			s LocSummary = LocCount1+LocCount2+LocCount3+LocCount4+LocCount5+LocCount6+LocCount7+LocCount8+LocCount9+LocCount10+LocCount11+LocCount12+LocCount13+LocCount14+LocCount15+LocCount16+LocCount17+LocCount18+LocCount19+LocCount20+LocCount21+LocCount22+LocCount23+LocCount24+LocCount25+LocCount26+LocCount27+LocCount28+LocCount29+LocCount30+LocCount31+LocCount32+LocCount33+LocCount34+LocCount35+LocCount36+LocCount37+LocCount38+LocCount39+LocCount40+LocCount41+LocCount42+LocCount43+LocCount44+LocCount45+LocCount46+LocCount47+LocCount48+LocCount49+LocCount50
		}
		
		if (IsWithPercent = "Y")
		{
			// 百分比计算
			s Loc1Percent = $s(LocCount1*100#LocCount=0:LocCount1*100/LocCount,1:$s(LocCount1*100/LocCount>=0.1:$j(LocCount1*100/LocCount,2,1),1:"<0.1"))
			s Loc2Percent = $s(LocCount2*100#LocCount=0:LocCount2*100/LocCount,1:$s(LocCount2*100/LocCount>=0.1:$j(LocCount2*100/LocCount,2,1),1:"<0.1"))
			s Loc3Percent = $s(LocCount3*100#LocCount=0:LocCount3*100/LocCount,1:$s(LocCount3*100/LocCount>=0.1:$j(LocCount3*100/LocCount,2,1),1:"<0.1"))
			s Loc4Percent = $s(LocCount4*100#LocCount=0:LocCount4*100/LocCount,1:$s(LocCount4*100/LocCount>=0.1:$j(LocCount4*100/LocCount,2,1),1:"<0.1"))
			s Loc5Percent = $s(LocCount5*100#LocCount=0:LocCount5*100/LocCount,1:$s(LocCount5*100/LocCount>=0.1:$j(LocCount5*100/LocCount,2,1),1:"<0.1"))
			s Loc6Percent = $s(LocCount6*100#LocCount=0:LocCount6*100/LocCount,1:$s(LocCount6*100/LocCount>=0.1:$j(LocCount6*100/LocCount,2,1),1:"<0.1"))
			s Loc7Percent = $s(LocCount7*100#LocCount=0:LocCount7*100/LocCount,1:$s(LocCount7*100/LocCount>=0.1:$j(LocCount7*100/LocCount,2,1),1:"<0.1"))
			s Loc8Percent = $s(LocCount8*100#LocCount=0:LocCount8*100/LocCount,1:$s(LocCount8*100/LocCount>=0.1:$j(LocCount8*100/LocCount,2,1),1:"<0.1"))
			s Loc9Percent = $s(LocCount9*100#LocCount=0:LocCount9*100/LocCount,1:$s(LocCount9*100/LocCount>=0.1:$j(LocCount9*100/LocCount,2,1),1:"<0.1"))
			s Loc10Percent = $s(LocCount10*100#LocCount=0:LocCount10*100/LocCount,1:$s(LocCount10*100/LocCount>=0.1:$j(LocCount10*100/LocCount,2,1),1:"<0.1"))
			s Loc11Percent = $s(LocCount11*100#LocCount=0:LocCount11*100/LocCount,1:$s(LocCount11*100/LocCount>=0.1:$j(LocCount11*100/LocCount,2,1),1:"<0.1"))
			s Loc12Percent = $s(LocCount12*100#LocCount=0:LocCount12*100/LocCount,1:$s(LocCount12*100/LocCount>=0.1:$j(LocCount12*100/LocCount,2,1),1:"<0.1"))
			s Loc13Percent = $s(LocCount13*100#LocCount=0:LocCount13*100/LocCount,1:$s(LocCount13*100/LocCount>=0.1:$j(LocCount13*100/LocCount,2,1),1:"<0.1"))
			s Loc14Percent = $s(LocCount14*100#LocCount=0:LocCount14*100/LocCount,1:$s(LocCount14*100/LocCount>=0.1:$j(LocCount14*100/LocCount,2,1),1:"<0.1"))
			s Loc15Percent = $s(LocCount15*100#LocCount=0:LocCount15*100/LocCount,1:$s(LocCount15*100/LocCount>=0.1:$j(LocCount15*100/LocCount,2,1),1:"<0.1"))
			s Loc16Percent = $s(LocCount16*100#LocCount=0:LocCount16*100/LocCount,1:$s(LocCount16*100/LocCount>=0.1:$j(LocCount16*100/LocCount,2,1),1:"<0.1"))
			s Loc17Percent = $s(LocCount17*100#LocCount=0:LocCount17*100/LocCount,1:$s(LocCount17*100/LocCount>=0.1:$j(LocCount17*100/LocCount,2,1),1:"<0.1"))
			s Loc18Percent = $s(LocCount18*100#LocCount=0:LocCount18*100/LocCount,1:$s(LocCount18*100/LocCount>=0.1:$j(LocCount18*100/LocCount,2,1),1:"<0.1"))
			s Loc19Percent = $s(LocCount19*100#LocCount=0:LocCount19*100/LocCount,1:$s(LocCount19*100/LocCount>=0.1:$j(LocCount19*100/LocCount,2,1),1:"<0.1"))
			s Loc20Percent = $s(LocCount20*100#LocCount=0:LocCount20*100/LocCount,1:$s(LocCount20*100/LocCount>=0.1:$j(LocCount20*100/LocCount,2,1),1:"<0.1"))
			s Loc21Percent = $s(LocCount21*100#LocCount=0:LocCount21*100/LocCount,1:$s(LocCount21*100/LocCount>=0.1:$j(LocCount21*100/LocCount,2,1),1:"<0.1"))
			s Loc22Percent = $s(LocCount22*100#LocCount=0:LocCount22*100/LocCount,1:$s(LocCount22*100/LocCount>=0.1:$j(LocCount22*100/LocCount,2,1),1:"<0.1"))
			s Loc23Percent = $s(LocCount23*100#LocCount=0:LocCount23*100/LocCount,1:$s(LocCount23*100/LocCount>=0.1:$j(LocCount23*100/LocCount,2,1),1:"<0.1"))
			s Loc24Percent = $s(LocCount24*100#LocCount=0:LocCount24*100/LocCount,1:$s(LocCount24*100/LocCount>=0.1:$j(LocCount24*100/LocCount,2,1),1:"<0.1"))
			s Loc25Percent = $s(LocCount25*100#LocCount=0:LocCount25*100/LocCount,1:$s(LocCount25*100/LocCount>=0.1:$j(LocCount25*100/LocCount,2,1),1:"<0.1"))
			s Loc26Percent = $s(LocCount26*100#LocCount=0:LocCount26*100/LocCount,1:$s(LocCount26*100/LocCount>=0.1:$j(LocCount26*100/LocCount,2,1),1:"<0.1"))
			s Loc27Percent = $s(LocCount27*100#LocCount=0:LocCount27*100/LocCount,1:$s(LocCount27*100/LocCount>=0.1:$j(LocCount27*100/LocCount,2,1),1:"<0.1"))
			s Loc28Percent = $s(LocCount28*100#LocCount=0:LocCount28*100/LocCount,1:$s(LocCount28*100/LocCount>=0.1:$j(LocCount28*100/LocCount,2,1),1:"<0.1"))
			s Loc29Percent = $s(LocCount29*100#LocCount=0:LocCount29*100/LocCount,1:$s(LocCount29*100/LocCount>=0.1:$j(LocCount29*100/LocCount,2,1),1:"<0.1"))
			s Loc30Percent = $s(LocCount30*100#LocCount=0:LocCount30*100/LocCount,1:$s(LocCount30*100/LocCount>=0.1:$j(LocCount30*100/LocCount,2,1),1:"<0.1"))
			s Loc31Percent = $s(LocCount31*100#LocCount=0:LocCount31*100/LocCount,1:$s(LocCount31*100/LocCount>=0.1:$j(LocCount31*100/LocCount,2,1),1:"<0.1"))
			s Loc32Percent = $s(LocCount32*100#LocCount=0:LocCount32*100/LocCount,1:$s(LocCount32*100/LocCount>=0.1:$j(LocCount32*100/LocCount,2,1),1:"<0.1"))
			s Loc33Percent = $s(LocCount33*100#LocCount=0:LocCount33*100/LocCount,1:$s(LocCount33*100/LocCount>=0.1:$j(LocCount33*100/LocCount,2,1),1:"<0.1"))
			s Loc34Percent = $s(LocCount34*100#LocCount=0:LocCount34*100/LocCount,1:$s(LocCount34*100/LocCount>=0.1:$j(LocCount34*100/LocCount,2,1),1:"<0.1"))
			s Loc35Percent = $s(LocCount35*100#LocCount=0:LocCount35*100/LocCount,1:$s(LocCount35*100/LocCount>=0.1:$j(LocCount35*100/LocCount,2,1),1:"<0.1"))
			s Loc36Percent = $s(LocCount36*100#LocCount=0:LocCount36*100/LocCount,1:$s(LocCount36*100/LocCount>=0.1:$j(LocCount36*100/LocCount,2,1),1:"<0.1"))
			s Loc37Percent = $s(LocCount37*100#LocCount=0:LocCount37*100/LocCount,1:$s(LocCount37*100/LocCount>=0.1:$j(LocCount37*100/LocCount,2,1),1:"<0.1"))
			s Loc38Percent = $s(LocCount38*100#LocCount=0:LocCount38*100/LocCount,1:$s(LocCount38*100/LocCount>=0.1:$j(LocCount38*100/LocCount,2,1),1:"<0.1"))
			s Loc39Percent = $s(LocCount39*100#LocCount=0:LocCount39*100/LocCount,1:$s(LocCount39*100/LocCount>=0.1:$j(LocCount39*100/LocCount,2,1),1:"<0.1"))
			s Loc40Percent = $s(LocCount40*100#LocCount=0:LocCount40*100/LocCount,1:$s(LocCount40*100/LocCount>=0.1:$j(LocCount40*100/LocCount,2,1),1:"<0.1"))
			s Loc41Percent = $s(LocCount41*100#LocCount=0:LocCount41*100/LocCount,1:$s(LocCount41*100/LocCount>=0.1:$j(LocCount41*100/LocCount,2,1),1:"<0.1"))
			s Loc42Percent = $s(LocCount42*100#LocCount=0:LocCount42*100/LocCount,1:$s(LocCount42*100/LocCount>=0.1:$j(LocCount42*100/LocCount,2,1),1:"<0.1"))
			s Loc43Percent = $s(LocCount43*100#LocCount=0:LocCount43*100/LocCount,1:$s(LocCount43*100/LocCount>=0.1:$j(LocCount43*100/LocCount,2,1),1:"<0.1"))
			s Loc44Percent = $s(LocCount44*100#LocCount=0:LocCount44*100/LocCount,1:$s(LocCount44*100/LocCount>=0.1:$j(LocCount44*100/LocCount,2,1),1:"<0.1"))
			s Loc45Percent = $s(LocCount45*100#LocCount=0:LocCount45*100/LocCount,1:$s(LocCount45*100/LocCount>=0.1:$j(LocCount45*100/LocCount,2,1),1:"<0.1"))
			s Loc46Percent = $s(LocCount46*100#LocCount=0:LocCount46*100/LocCount,1:$s(LocCount46*100/LocCount>=0.1:$j(LocCount46*100/LocCount,2,1),1:"<0.1"))
			s Loc47Percent = $s(LocCount47*100#LocCount=0:LocCount47*100/LocCount,1:$s(LocCount47*100/LocCount>=0.1:$j(LocCount47*100/LocCount,2,1),1:"<0.1"))
			s Loc48Percent = $s(LocCount48*100#LocCount=0:LocCount48*100/LocCount,1:$s(LocCount48*100/LocCount>=0.1:$j(LocCount48*100/LocCount,2,1),1:"<0.1"))
			s Loc49Percent = $s(LocCount49*100#LocCount=0:LocCount49*100/LocCount,1:$s(LocCount49*100/LocCount>=0.1:$j(LocCount49*100/LocCount,2,1),1:"<0.1"))
			s Loc50Percent = $s(LocCount50*100#LocCount=0:LocCount50*100/LocCount,1:$s(LocCount50*100/LocCount>=0.1:$j(LocCount50*100/LocCount,2,1),1:"<0.1"))
			
			s Loc1Result = LocCount1_" - "_Loc1Percent_"%",Loc2Result = LocCount2_" - "_Loc2Percent_"%",Loc3Result = LocCount3_" - "_Loc3Percent_"%",Loc4Result = LocCount4_" - "_Loc4Percent_"%"
			s Loc5Result = LocCount5_" - "_Loc5Percent_"%",Loc6Result = LocCount6_" - "_Loc6Percent_"%",Loc7Result = LocCount7_" - "_Loc7Percent_"%",Loc8Result = LocCount8_" - "_Loc8Percent_"%"
			s Loc9Result = LocCount9_" - "_Loc9Percent_"%",Loc10Result = LocCount10_" - "_Loc10Percent_"%",Loc11Result = LocCount11_" - "_Loc11Percent_"%",Loc12Result = LocCount12_" - "_Loc12Percent_"%"
			s Loc13Result = LocCount13_" - "_Loc13Percent_"%",Loc14Result = LocCount14_" - "_Loc14Percent_"%",Loc15Result = LocCount15_" - "_Loc15Percent_"%",Loc16Result = LocCount16_" - "_Loc16Percent_"%"
			s Loc17Result = LocCount17_" - "_Loc17Percent_"%",Loc18Result = LocCount18_" - "_Loc18Percent_"%",Loc19Result = LocCount19_" - "_Loc19Percent_"%",Loc20Result = LocCount20_" - "_Loc20Percent_"%"
			s Loc21Result = LocCount21_" - "_Loc21Percent_"%",Loc22Result = LocCount22_" - "_Loc22Percent_"%",Loc23Result = LocCount23_" - "_Loc23Percent_"%",Loc24Result = LocCount24_" - "_Loc24Percent_"%"
			s Loc25Result = LocCount25_" - "_Loc25Percent_"%",Loc26Result = LocCount26_" - "_Loc26Percent_"%",Loc27Result = LocCount27_" - "_Loc27Percent_"%",Loc28Result = LocCount28_" - "_Loc28Percent_"%"
			s Loc29Result = LocCount29_" - "_Loc29Percent_"%",Loc30Result = LocCount30_" - "_Loc30Percent_"%",Loc31Result = LocCount31_" - "_Loc31Percent_"%",Loc32Result = LocCount32_" - "_Loc32Percent_"%"
			s Loc33Result = LocCount33_" - "_Loc33Percent_"%",Loc34Result = LocCount34_" - "_Loc34Percent_"%",Loc35Result = LocCount35_" - "_Loc35Percent_"%",Loc36Result = LocCount36_" - "_Loc36Percent_"%"
			s Loc37Result = LocCount37_" - "_Loc37Percent_"%",Loc38Result = LocCount38_" - "_Loc38Percent_"%",Loc39Result = LocCount39_" - "_Loc39Percent_"%",Loc40Result = LocCount40_" - "_Loc40Percent_"%"
			s Loc41Result = LocCount41_" - "_Loc41Percent_"%",Loc42Result = LocCount42_" - "_Loc42Percent_"%",Loc43Result = LocCount43_" - "_Loc43Percent_"%",Loc44Result = LocCount44_" - "_Loc44Percent_"%"
			s Loc45Result = LocCount45_" - "_Loc45Percent_"%",Loc46Result = LocCount46_" - "_Loc46Percent_"%",Loc47Result = LocCount47_" - "_Loc47Percent_"%",Loc48Result = LocCount48_" - "_Loc48Percent_"%"
			s Loc49Result = LocCount49_" - "_Loc49Percent_"%",Loc50Result = LocCount50_" - "_Loc50Percent_"%"
			
			// 科室总计
			s Data = $lb(AEntryIDs,DisLocID,LocDesc,"","小计",StartDate,EndDate,LocCount,Loc1Result,Loc2Result,Loc3Result,Loc4Result,Loc5Result,Loc6Result,Loc7Result,Loc8Result,Loc9Result,Loc10Result,Loc11Result,Loc12Result,Loc13Result,Loc14Result,Loc15Result,Loc16Result,Loc17Result,Loc18Result,Loc19Result,Loc20Result,Loc21Result,Loc22Result,Loc23Result,Loc24Result,Loc25Result,Loc26Result,Loc27Result,Loc28Result,Loc29Result,Loc30Result,Loc31Result,Loc32Result,Loc33Result,Loc34Result,Loc35Result,Loc36Result,Loc37Result,Loc38Result,Loc39Result,Loc40Result,Loc41Result,Loc42Result,Loc43Result,Loc44Result,Loc45Result,Loc46Result,Loc47Result,Loc48Result,Loc49Result,Loc50Result,LocSummary)
			s ^CacheTemp(uid,ind) = Data
			s ind = ind + 1
		}
		else
		{
			// 科室总计
			s Data = $lb(AEntryIDs,DisLocID,LocDesc,"","小计",StartDate,EndDate,LocCount,LocCount1,LocCount2,LocCount3,LocCount4,LocCount5,LocCount6,LocCount7,LocCount8,LocCount9,LocCount10,LocCount11,LocCount12,LocCount13,LocCount14,LocCount15,LocCount16,LocCount17,LocCount18,LocCount19,LocCount20,LocCount21,LocCount22,LocCount23,LocCount24,LocCount25,LocCount26,LocCount27,LocCount28,LocCount29,LocCount30,LocCount31,LocCount32,LocCount33,LocCount34,LocCount35,LocCount36,LocCount37,LocCount38,LocCount39,LocCount40,LocCount41,LocCount42,LocCount43,LocCount44,LocCount45,LocCount46,LocCount47,LocCount48,LocCount49,LocCount50,LocSummary)
			s ^CacheTemp(uid,ind) = Data
			s ind = ind + 1
		}
		
		s Count = Count + LocCount
		s Count1 = Count1 + LocCount1, Count2 = Count2 + LocCount2, Count3 = Count3 + LocCount3, Count4 = Count4 + LocCount4, Count5 = Count5 + LocCount5
		s Count6 = Count6 + LocCount6, Count7 = Count7 + LocCount7, Count8 = Count8 + LocCount8, Count9 = Count9 + LocCount9, Count10 = Count10 + LocCount10
		s Count11 = Count11 + LocCount11, Count12 = Count12 + LocCount12, Count13 = Count13 + LocCount13, Count14 = Count14 + LocCount14, Count15 = Count15 + LocCount15
		s Count16 = Count16 + LocCount16, Count17 = Count17 + LocCount17, Count18 = Count18 + LocCount18, Count19 = Count19 + LocCount19, Count20 = Count20 + LocCount20
		s Count21 = Count21 + LocCount21, Count22 = Count22 + LocCount22, Count23 = Count23 + LocCount23, Count24 = Count24 + LocCount24, Count25 = Count25 + LocCount25
		s Count26 = Count26 + LocCount26, Count27 = Count27 + LocCount27, Count28 = Count28 + LocCount28, Count29 = Count29 + LocCount29, Count30 = Count30 + LocCount30
		s Count31 = Count31 + LocCount31, Count32 = Count32 + LocCount32, Count33 = Count33 + LocCount33, Count34 = Count34 + LocCount34, Count35 = Count35 + LocCount35
		s Count36 = Count36 + LocCount36, Count37 = Count37 + LocCount37, Count38 = Count38 + LocCount38, Count39 = Count39 + LocCount39, Count40 = Count40 + LocCount40
		s Count41 = Count41 + LocCount41, Count42 = Count42 + LocCount42, Count43 = Count43 + LocCount43, Count44 = Count44 + LocCount44, Count45 = Count45 + LocCount45
		s Count46 = Count46 + LocCount46, Count47 = Count47 + LocCount47, Count48 = Count48 + LocCount48, Count49 = Count49 + LocCount49, Count50 = Count50 + LocCount50
		s Summary = Count1+Count2+Count3+Count4+Count5+Count6+Count7+Count8+Count9+Count10+Count11+Count12+Count13+Count14+Count15+Count16+Count17+Count18+Count19+Count20+Count21+Count22+Count23+Count24+Count25+Count26+Count27+Count28+Count29+Count30+Count31+Count32+Count33+Count34+Count35+Count36+Count37+Count38+Count39+Count40+Count41+Count42+Count43+Count44+Count45+Count46+Count47+Count48+Count49+Count50
	}
	
	if (IsWithPercent = "Y")
	{
		// 百分比计算
		s Count1Percent = $s(Count1*100#Count=0:Count1*100/Count,1:$s(Count1*100/Count>=0.1:$j(Count1*100/Count,2,1),1:"<0.1"))
		s Count2Percent = $s(Count2*100#Count=0:Count2*100/Count,1:$s(Count2*100/Count>=0.1:$j(Count2*100/Count,2,1),1:"<0.1"))
		s Count3Percent = $s(Count3*100#Count=0:Count3*100/Count,1:$s(Count3*100/Count>=0.1:$j(Count3*100/Count,2,1),1:"<0.1"))
		s Count4Percent = $s(Count4*100#Count=0:Count4*100/Count,1:$s(Count4*100/Count>=0.1:$j(Count4*100/Count,2,1),1:"<0.1"))
		s Count5Percent = $s(Count5*100#Count=0:Count5*100/Count,1:$s(Count5*100/Count>=0.1:$j(Count5*100/Count,2,1),1:"<0.1"))
		s Count6Percent = $s(Count6*100#Count=0:Count6*100/Count,1:$s(Count6*100/Count>=0.1:$j(Count6*100/Count,2,1),1:"<0.1"))
		s Count7Percent = $s(Count7*100#Count=0:Count7*100/Count,1:$s(Count7*100/Count>=0.1:$j(Count7*100/Count,2,1),1:"<0.1"))
		s Count8Percent = $s(Count8*100#Count=0:Count8*100/Count,1:$s(Count8*100/Count>=0.1:$j(Count8*100/Count,2,1),1:"<0.1"))
		s Count9Percent = $s(Count9*100#Count=0:Count9*100/Count,1:$s(Count9*100/Count>=0.1:$j(Count9*100/Count,2,1),1:"<0.1"))
		s Count10Percent = $s(Count10*100#Count=0:Count10*100/Count,1:$s(Count10*100/Count>=0.1:$j(Count10*100/Count,2,1),1:"<0.1"))
		s Count11Percent = $s(Count11*100#Count=0:Count11*100/Count,1:$s(Count11*100/Count>=0.1:$j(Count11*100/Count,2,1),1:"<0.1"))
		s Count12Percent = $s(Count12*100#Count=0:Count12*100/Count,1:$s(Count12*100/Count>=0.1:$j(Count12*100/Count,2,1),1:"<0.1"))
		s Count13Percent = $s(Count13*100#Count=0:Count13*100/Count,1:$s(Count13*100/Count>=0.1:$j(Count13*100/Count,2,1),1:"<0.1"))
		s Count14Percent = $s(Count14*100#Count=0:Count14*100/Count,1:$s(Count14*100/Count>=0.1:$j(Count14*100/Count,2,1),1:"<0.1"))
		s Count15Percent = $s(Count15*100#Count=0:Count15*100/Count,1:$s(Count15*100/Count>=0.1:$j(Count15*100/Count,2,1),1:"<0.1"))
		s Count16Percent = $s(Count16*100#Count=0:Count16*100/Count,1:$s(Count16*100/Count>=0.1:$j(Count16*100/Count,2,1),1:"<0.1"))
		s Count17Percent = $s(Count17*100#Count=0:Count17*100/Count,1:$s(Count17*100/Count>=0.1:$j(Count17*100/Count,2,1),1:"<0.1"))
		s Count18Percent = $s(Count18*100#Count=0:Count18*100/Count,1:$s(Count18*100/Count>=0.1:$j(Count18*100/Count,2,1),1:"<0.1"))
		s Count19Percent = $s(Count19*100#Count=0:Count19*100/Count,1:$s(Count19*100/Count>=0.1:$j(Count19*100/Count,2,1),1:"<0.1"))
		s Count20Percent = $s(Count20*100#Count=0:Count20*100/Count,1:$s(Count20*100/Count>=0.1:$j(Count20*100/Count,2,1),1:"<0.1"))
		s Count21Percent = $s(Count21*100#Count=0:Count21*100/Count,1:$s(Count21*100/Count>=0.1:$j(Count21*100/Count,2,1),1:"<0.1"))
		s Count22Percent = $s(Count22*100#Count=0:Count22*100/Count,1:$s(Count22*100/Count>=0.1:$j(Count22*100/Count,2,1),1:"<0.1"))
		s Count23Percent = $s(Count23*100#Count=0:Count23*100/Count,1:$s(Count23*100/Count>=0.1:$j(Count23*100/Count,2,1),1:"<0.1"))
		s Count24Percent = $s(Count24*100#Count=0:Count24*100/Count,1:$s(Count24*100/Count>=0.1:$j(Count24*100/Count,2,1),1:"<0.1"))
		s Count25Percent = $s(Count25*100#Count=0:Count25*100/Count,1:$s(Count25*100/Count>=0.1:$j(Count25*100/Count,2,1),1:"<0.1"))
		s Count26Percent = $s(Count26*100#Count=0:Count26*100/Count,1:$s(Count26*100/Count>=0.1:$j(Count26*100/Count,2,1),1:"<0.1"))
		s Count27Percent = $s(Count27*100#Count=0:Count27*100/Count,1:$s(Count27*100/Count>=0.1:$j(Count27*100/Count,2,1),1:"<0.1"))
		s Count28Percent = $s(Count28*100#Count=0:Count28*100/Count,1:$s(Count28*100/Count>=0.1:$j(Count28*100/Count,2,1),1:"<0.1"))
		s Count29Percent = $s(Count29*100#Count=0:Count29*100/Count,1:$s(Count29*100/Count>=0.1:$j(Count29*100/Count,2,1),1:"<0.1"))
		s Count30Percent = $s(Count30*100#Count=0:Count30*100/Count,1:$s(Count30*100/Count>=0.1:$j(Count30*100/Count,2,1),1:"<0.1"))
		s Count31Percent = $s(Count31*100#Count=0:Count31*100/Count,1:$s(Count31*100/Count>=0.1:$j(Count31*100/Count,2,1),1:"<0.1"))
		s Count32Percent = $s(Count32*100#Count=0:Count32*100/Count,1:$s(Count32*100/Count>=0.1:$j(Count32*100/Count,2,1),1:"<0.1"))
		s Count33Percent = $s(Count33*100#Count=0:Count33*100/Count,1:$s(Count33*100/Count>=0.1:$j(Count33*100/Count,2,1),1:"<0.1"))
		s Count34Percent = $s(Count34*100#Count=0:Count34*100/Count,1:$s(Count34*100/Count>=0.1:$j(Count34*100/Count,2,1),1:"<0.1"))
		s Count35Percent = $s(Count35*100#Count=0:Count35*100/Count,1:$s(Count35*100/Count>=0.1:$j(Count35*100/Count,2,1),1:"<0.1"))
		s Count36Percent = $s(Count36*100#Count=0:Count36*100/Count,1:$s(Count36*100/Count>=0.1:$j(Count36*100/Count,2,1),1:"<0.1"))
		s Count37Percent = $s(Count37*100#Count=0:Count37*100/Count,1:$s(Count37*100/Count>=0.1:$j(Count37*100/Count,2,1),1:"<0.1"))
		s Count38Percent = $s(Count38*100#Count=0:Count38*100/Count,1:$s(Count38*100/Count>=0.1:$j(Count38*100/Count,2,1),1:"<0.1"))
		s Count39Percent = $s(Count39*100#Count=0:Count39*100/Count,1:$s(Count39*100/Count>=0.1:$j(Count39*100/Count,2,1),1:"<0.1"))
		s Count40Percent = $s(Count40*100#Count=0:Count40*100/Count,1:$s(Count40*100/Count>=0.1:$j(Count40*100/Count,2,1),1:"<0.1"))
		s Count41Percent = $s(Count41*100#Count=0:Count41*100/Count,1:$s(Count41*100/Count>=0.1:$j(Count41*100/Count,2,1),1:"<0.1"))
		s Count42Percent = $s(Count42*100#Count=0:Count42*100/Count,1:$s(Count42*100/Count>=0.1:$j(Count42*100/Count,2,1),1:"<0.1"))
		s Count43Percent = $s(Count43*100#Count=0:Count43*100/Count,1:$s(Count43*100/Count>=0.1:$j(Count43*100/Count,2,1),1:"<0.1"))
		s Count44Percent = $s(Count44*100#Count=0:Count44*100/Count,1:$s(Count44*100/Count>=0.1:$j(Count44*100/Count,2,1),1:"<0.1"))
		s Count45Percent = $s(Count45*100#Count=0:Count45*100/Count,1:$s(Count45*100/Count>=0.1:$j(Count45*100/Count,2,1),1:"<0.1"))
		s Count46Percent = $s(Count46*100#Count=0:Count46*100/Count,1:$s(Count46*100/Count>=0.1:$j(Count46*100/Count,2,1),1:"<0.1"))
		s Count47Percent = $s(Count47*100#Count=0:Count47*100/Count,1:$s(Count47*100/Count>=0.1:$j(Count47*100/Count,2,1),1:"<0.1"))
		s Count48Percent = $s(Count48*100#Count=0:Count48*100/Count,1:$s(Count48*100/Count>=0.1:$j(Count48*100/Count,2,1),1:"<0.1"))
		s Count49Percent = $s(Count49*100#Count=0:Count49*100/Count,1:$s(Count49*100/Count>=0.1:$j(Count49*100/Count,2,1),1:"<0.1"))
		s Count50Percent = $s(Count50*100#Count=0:Count50*100/Count,1:$s(Count50*100/Count>=0.1:$j(Count50*100/Count,2,1),1:"<0.1"))
		
		s Count1Result = Count1_" - "_Count1Percent_"%",Count2Result = Count2_" - "_Count2Percent_"%",Count3Result = Count3_" - "_Count3Percent_"%",Count4Result = Count4_" - "_Count4Percent_"%"
		s Count5Result = Count5_" - "_Count5Percent_"%",Count6Result = Count6_" - "_Count6Percent_"%",Count7Result = Count7_" - "_Count7Percent_"%",Count8Result = Count8_" - "_Count8Percent_"%"
		s Count9Result = Count9_" - "_Count9Percent_"%",Count10Result = Count10_" - "_Count10Percent_"%",Count11Result = Count11_" - "_Count11Percent_"%",Count12Result = Count12_" - "_Count12Percent_"%"
		s Count13Result = Count13_" - "_Count13Percent_"%",Count14Result = Count14_" - "_Count14Percent_"%",Count15Result = Count15_" - "_Count15Percent_"%",Count16Result = Count16_" - "_Count16Percent_"%"
		s Count17Result = Count17_" - "_Count17Percent_"%",Count18Result = Count18_" - "_Count18Percent_"%",Count19Result = Count19_" - "_Count19Percent_"%",Count20Result = Count20_" - "_Count20Percent_"%"
		s Count21Result = Count21_" - "_Count21Percent_"%",Count22Result = Count22_" - "_Count22Percent_"%",Count23Result = Count23_" - "_Count23Percent_"%",Count24Result = Count24_" - "_Count24Percent_"%"
		s Count25Result = Count25_" - "_Count25Percent_"%",Count26Result = Count26_" - "_Count26Percent_"%",Count27Result = Count27_" - "_Count27Percent_"%",Count28Result = Count28_" - "_Count28Percent_"%"
		s Count29Result = Count29_" - "_Count29Percent_"%",Count30Result = Count30_" - "_Count30Percent_"%",Count31Result = Count31_" - "_Count31Percent_"%",Count32Result = Count32_" - "_Count32Percent_"%"
		s Count33Result = Count33_" - "_Count33Percent_"%",Count34Result = Count34_" - "_Count34Percent_"%",Count35Result = Count35_" - "_Count35Percent_"%",Count36Result = Count36_" - "_Count36Percent_"%"
		s Count37Result = Count37_" - "_Count37Percent_"%",Count38Result = Count38_" - "_Count38Percent_"%",Count39Result = Count39_" - "_Count39Percent_"%",Count40Result = Count40_" - "_Count40Percent_"%"
		s Count41Result = Count41_" - "_Count41Percent_"%",Count42Result = Count42_" - "_Count42Percent_"%",Count43Result = Count43_" - "_Count43Percent_"%",Count44Result = Count44_" - "_Count44Percent_"%"
		s Count45Result = Count45_" - "_Count45Percent_"%",Count46Result = Count46_" - "_Count46Percent_"%",Count47Result = Count47_" - "_Count47Percent_"%",Count48Result = Count48_" - "_Count48Percent_"%"
		s Count49Result = Count49_" - "_Count49Percent_"%",Count50Result = Count50_" - "_Count50Percent_"%"
		
		// 最后一栏的统计
		if ($zcvt(IsMultiSummary,"U") = "Y")&&(ind > 25)
		{
			s Data =  $lb(AEntryIDs,ALocIDs,"合计","","------",StartDate,EndDate,Count,Count1Result,Count2Result,Count3Result,Count4Result,Count5Result,Count6Result,Count7Result,Count8Result,Count9Result,Count10Result,Count11Result,Count12Result,Count13Result,Count14Result,Count15Result,Count16Result,Count17Result,Count18Result,Count19Result,Count20Result,Count21Result,Count22Result,Count23Result,Count24Result,Count25Result,Count26Result,Count27Result,Count28Result,Count29Result,Count30Result,Count31Result,Count32Result,Count33Result,Count34Result,Count35Result,Count36Result,Count37Result,Count38Result,Count39Result,Count40Result,Count41Result,Count42Result,Count43Result,Count44Result,Count45Result,Count46Result,Count47Result,Count48Result,Count49Result,Count50Result,Summary)
			s ^CacheTemp(uid,ind) = Data
		}
		
		// 给第一栏也加上合计栏
		s Data =  $lb(AEntryIDs,ALocIDs,"合计","","------",StartDate,EndDate,Count,Count1Result,Count2Result,Count3Result,Count4Result,Count5Result,Count6Result,Count7Result,Count8Result,Count9Result,Count10Result,Count11Result,Count12Result,Count13Result,Count14Result,Count15Result,Count16Result,Count17Result,Count18Result,Count19Result,Count20Result,Count21Result,Count22Result,Count23Result,Count24Result,Count25Result,Count26Result,Count27Result,Count28Result,Count29Result,Count30Result,Count31Result,Count32Result,Count33Result,Count34Result,Count35Result,Count36Result,Count37Result,Count38Result,Count39Result,Count40Result,Count41Result,Count42Result,Count43Result,Count44Result,Count45Result,Count46Result,Count47Result,Count48Result,Count49Result,Count50Result,Summary)
		s ^CacheTemp(uid,1) = Data
	}
	else
	{		
		// 最后一栏的统计
		if ($zcvt(IsMultiSummary,"U") = "Y")&&(ind > 25)
		{
			s Data = $lb(AEntryIDs,ALocIDs,"合计","","------",StartDate,EndDate,Count,Count1,Count2,Count3,Count4,Count5,Count6,Count7,Count8,Count9,Count10,Count11,Count12,Count13,Count14,Count15,Count16,Count17,Count18,Count19,Count20,Count21,Count22,Count23,Count24,Count25,Count26,Count27,Count28,Count29,Count30,Count31,Count32,Count33,Count34,Count35,Count36,Count37,Count38,Count39,Count40,Count41,Count42,Count43,Count44,Count45,Count46,Count47,Count48,Count49,Count50,Summary)
			s ^CacheTemp(uid,ind) = Data
		}
		
		// 给第一栏也加上合计栏
		s Data = $lb(AEntryIDs,ALocIDs,"合计","","------",StartDate,EndDate,Count,Count1,Count2,Count3,Count4,Count5,Count6,Count7,Count8,Count9,Count10,Count11,Count12,Count13,Count14,Count15,Count16,Count17,Count18,Count19,Count20,Count21,Count22,Count23,Count24,Count25,Count26,Count27,Count28,Count29,Count30,Count31,Count32,Count33,Count34,Count35,Count36,Count37,Count38,Count39,Count40,Count41,Count42,Count43,Count44,Count45,Count46,Count47,Count48,Count49,Count50,Summary)
		s ^CacheTemp(uid,1) = Data
	}
	
	k ^CacheTemp("EPRQuality","ManualReport",uid)
	
	q $$$OK
}

ClassMethod BuildManualReportList(AEpisodeID As %String, AListLocID As %List, AListEntryID As %List, AUniqueKey As %String) As %Integer
{
	s ret = -1
	q:(AEpisodeID = "")||(AUniqueKey = "") ret
		
	s objPaAdm = $g(^PAADM(+AEpisodeID))
	q:(objPaAdm = "") ret
	
	s DisLocID = $p(objPaAdm,"^",4)				//出院科室
	q:(DisLocID = "") ret
	q:($listlength(AListLocID) > 0)&&($listfind(AListLocID,DisLocID) = 0) ret
	
	s AdmDoctorID = $p(objPaAdm,"^",9)			//主管医生
	s:(AdmDoctorID = "") AdmDoctorID = "-1"
	
	// 记录医生总病历分数
	s ^CacheTemp("EPRQuality","ManualReport",AUniqueKey,DisLocID,AdmDoctorID,"Count") = (+$g(^CacheTemp("EPRQuality","ManualReport",AUniqueKey,DisLocID,AdmDoctorID,"Count"))) + 1
	
	for i = 1:1:$listlength(AListEntryID)
	{
		//每一列有可能还是一组Entry
		s EntrySet = $listget(AListEntryID,i)
		continue:(EntrySet = "")
		
		s EntryGroup = $p(EntrySet,"#",1)
		s IsPerEntry = $p(EntrySet,"#",2)
		s IsPerEntry = $s(IsPerEntry = "":"N",1:IsPerEntry)	
		
		s lstEntries = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(EntryGroup,"|")
		for j = 1:1:$listlength(lstEntries)
		{
			s EntryID = $listget(lstEntries,j)
			continue:(EntryID = "")

			s ResultID = $o(^DHCEPRQ.QualityResultDetailI("IdxEpisodeEntryID"," "_AEpisodeID," "_EntryID,""))
			if (+ResultID > 0)
			{
				// 记录医生各质控项目份数
				s ^CacheTemp("EPRQuality","ManualReport",AUniqueKey,DisLocID,AdmDoctorID,EntrySet,"Count") = (+$g(^CacheTemp("EPRQuality","ManualReport",AUniqueKey,DisLocID,AdmDoctorID,EntrySet,"Count"))) + 1				
				
				// 一个项目组合只记录一次
				q:(IsPerEntry = "N")
			}
		}
	}
	
	s ret = 1
	q ret
}

ClassMethod GetManualAnalysisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetManualAnalysisExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind),-1)
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetManualAnalysisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetManualAnalysisExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// w ##Class(EPRservice.Quality.BOQualityReport).ExportManualReport(AItemJS,AParameters)
ClassMethod ExportManualReport(AItemJS As %String = "", AParameters As %String) As %Status
{
	s LocIDs = $p(AParameters,"#",1)
	s StartDate = $p(AParameters,"#",2)
	s EndDate = $p(AParameters,"#",3)
	s EntryIDs = $p(AParameters,"#",4)
	s AnalysisFlag = $p(AParameters,"#",5)
	
	//s IsMultiSummary = $p(AnalysisFlag,"^",1)
	s IsWithPercent = $p(AnalysisFlag,"^",2)
	s:(IsWithPercent = "") IsWithPercent = "N"
	s ExportPrintFlag = "N^"_IsWithPercent
	
	s lstEntryID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(EntryIDs,"^","N")
	s ds = ##Class(%Library.ResultSet).%New("EPRservice.Quality.DataAccess.BOQualitySpotCheck:GetManualAnalysis")
	d ds.Execute(LocIDs,StartDate,EndDate,EntryIDs,ExportPrintFlag)
	
	s StartRow = 8
	while(ds.Next())
	{
		s Department = ds.Data("Department")
		s Doctor = ds.Data("Doctor")
		s Count = ds.Data("Count")
		
		s valCells = Department_$c(1)_Doctor_$c(1)_Count
		
		s Count1 = ds.Data("Count1")
		s:($listget(lstEntryID,1) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count1,1:valCells_$c(1)_$tr($p(Count1,"-",1)," ","")_$c(1)_$tr($p(Count1,"-",2)," ",""))
		s Count2 = ds.Data("Count2")
		s:($listget(lstEntryID,2) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count2,1:valCells_$c(1)_$tr($p(Count2,"-",1)," ","")_$c(1)_$tr($p(Count2,"-",2)," ",""))
		s Count3 = ds.Data("Count3")
		s:($listget(lstEntryID,3) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count3,1:valCells_$c(1)_$tr($p(Count3,"-",1)," ","")_$c(1)_$tr($p(Count3,"-",2)," ",""))
		s Count4 = ds.Data("Count4")
		s:($listget(lstEntryID,4) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count4,1:valCells_$c(1)_$tr($p(Count4,"-",1)," ","")_$c(1)_$tr($p(Count4,"-",2)," ",""))
		s Count5 = ds.Data("Count5")
		s:($listget(lstEntryID,5) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count5,1:valCells_$c(1)_$tr($p(Count5,"-",1)," ","")_$c(1)_$tr($p(Count5,"-",2)," ",""))
		s Count6 = ds.Data("Count6")
		s:($listget(lstEntryID,6) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count6,1:valCells_$c(1)_$tr($p(Count6,"-",1)," ","")_$c(1)_$tr($p(Count6,"-",2)," ",""))
		s Count7 = ds.Data("Count7")
		s:($listget(lstEntryID,7) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count7,1:valCells_$c(1)_$tr($p(Count7,"-",1)," ","")_$c(1)_$tr($p(Count7,"-",2)," ",""))
		s Count8 = ds.Data("Count8")
		s:($listget(lstEntryID,8) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count8,1:valCells_$c(1)_$tr($p(Count8,"-",1)," ","")_$c(1)_$tr($p(Count8,"-",2)," ",""))
		s Count9 = ds.Data("Count9")
		s:($listget(lstEntryID,9) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count9,1:valCells_$c(1)_$tr($p(Count9,"-",1)," ","")_$c(1)_$tr($p(Count9,"-",2)," ",""))
		s Count10 = ds.Data("Count10")
		s:($listget(lstEntryID,10) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count10,1:valCells_$c(1)_$tr($p(Count10,"-",1)," ","")_$c(1)_$tr($p(Count10,"-",2)," ",""))
		s Count11 = ds.Data("Count11")
		s:($listget(lstEntryID,11) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count11,1:valCells_$c(1)_$tr($p(Count11,"-",1)," ","")_$c(1)_$tr($p(Count11,"-",2)," ",""))
		s Count12 = ds.Data("Count12")
		s:($listget(lstEntryID,12) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count12,1:valCells_$c(1)_$tr($p(Count12,"-",1)," ","")_$c(1)_$tr($p(Count12,"-",2)," ",""))
		s Count13 = ds.Data("Count13")
		s:($listget(lstEntryID,13) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count13,1:valCells_$c(1)_$tr($p(Count13,"-",1)," ","")_$c(1)_$tr($p(Count13,"-",2)," ",""))
		s Count14 = ds.Data("Count14")
		s:($listget(lstEntryID,14) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count14,1:valCells_$c(1)_$tr($p(Count14,"-",1)," ","")_$c(1)_$tr($p(Count14,"-",2)," ",""))
		s Count15 = ds.Data("Count15")
		s:($listget(lstEntryID,15) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count15,1:valCells_$c(1)_$tr($p(Count15,"-",1)," ","")_$c(1)_$tr($p(Count15,"-",2)," ",""))
		s Count16 = ds.Data("Count16")
		s:($listget(lstEntryID,16) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count16,1:valCells_$c(1)_$tr($p(Count16,"-",1)," ","")_$c(1)_$tr($p(Count16,"-",2)," ",""))
		s Count17 = ds.Data("Count17")
		s:($listget(lstEntryID,17) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count17,1:valCells_$c(1)_$tr($p(Count17,"-",1)," ","")_$c(1)_$tr($p(Count17,"-",2)," ",""))
		s Count18 = ds.Data("Count18")
		s:($listget(lstEntryID,18) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count18,1:valCells_$c(1)_$tr($p(Count18,"-",1)," ","")_$c(1)_$tr($p(Count18,"-",2)," ",""))
		s Count19 = ds.Data("Count19")
		s:($listget(lstEntryID,19) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count19,1:valCells_$c(1)_$tr($p(Count19,"-",1)," ","")_$c(1)_$tr($p(Count19,"-",2)," ",""))
		s Count20 = ds.Data("Count20")
		s:($listget(lstEntryID,20) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count20,1:valCells_$c(1)_$tr($p(Count20,"-",1)," ","")_$c(1)_$tr($p(Count20,"-",2)," ",""))
		s Count21 = ds.Data("Count21")
		s:($listget(lstEntryID,21) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count21,1:valCells_$c(1)_$tr($p(Count21,"-",1)," ","")_$c(1)_$tr($p(Count21,"-",2)," ",""))
		s Count22 = ds.Data("Count22")
		s:($listget(lstEntryID,22) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count22,1:valCells_$c(1)_$tr($p(Count22,"-",1)," ","")_$c(1)_$tr($p(Count22,"-",2)," ",""))
		s Count23 = ds.Data("Count23")
		s:($listget(lstEntryID,23) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count23,1:valCells_$c(1)_$tr($p(Count23,"-",1)," ","")_$c(1)_$tr($p(Count23,"-",2)," ",""))
		s Count24 = ds.Data("Count24")
		s:($listget(lstEntryID,24) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count24,1:valCells_$c(1)_$tr($p(Count24,"-",1)," ","")_$c(1)_$tr($p(Count24,"-",2)," ",""))
		s Count25 = ds.Data("Count25")
		s:($listget(lstEntryID,25) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count25,1:valCells_$c(1)_$tr($p(Count25,"-",1)," ","")_$c(1)_$tr($p(Count25,"-",2)," ",""))
		s Count26 = ds.Data("Count26")
		s:($listget(lstEntryID,26) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count26,1:valCells_$c(1)_$tr($p(Count26,"-",1)," ","")_$c(1)_$tr($p(Count26,"-",2)," ",""))
		s Count27 = ds.Data("Count27")
		s:($listget(lstEntryID,27) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count27,1:valCells_$c(1)_$tr($p(Count27,"-",1)," ","")_$c(1)_$tr($p(Count27,"-",2)," ",""))
		s Count28 = ds.Data("Count28")
		s:($listget(lstEntryID,28) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count28,1:valCells_$c(1)_$tr($p(Count28,"-",1)," ","")_$c(1)_$tr($p(Count28,"-",2)," ",""))
		s Count29 = ds.Data("Count29")
		s:($listget(lstEntryID,29) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count29,1:valCells_$c(1)_$tr($p(Count29,"-",1)," ","")_$c(1)_$tr($p(Count29,"-",2)," ",""))
		s Count30 = ds.Data("Count30")
		s:($listget(lstEntryID,30) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count30,1:valCells_$c(1)_$tr($p(Count30,"-",1)," ","")_$c(1)_$tr($p(Count30,"-",2)," ",""))
		s Count31 = ds.Data("Count31")
		s:($listget(lstEntryID,31) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count31,1:valCells_$c(1)_$tr($p(Count31,"-",1)," ","")_$c(1)_$tr($p(Count31,"-",2)," ",""))
		s Count32 = ds.Data("Count32")
		s:($listget(lstEntryID,32) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count32,1:valCells_$c(1)_$tr($p(Count32,"-",1)," ","")_$c(1)_$tr($p(Count32,"-",2)," ",""))
		s Count33 = ds.Data("Count33")
		s:($listget(lstEntryID,33) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count33,1:valCells_$c(1)_$tr($p(Count33,"-",1)," ","")_$c(1)_$tr($p(Count33,"-",2)," ",""))
		s Count34 = ds.Data("Count34")
		s:($listget(lstEntryID,34) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count34,1:valCells_$c(1)_$tr($p(Count34,"-",1)," ","")_$c(1)_$tr($p(Count34,"-",2)," ",""))
		s Count35 = ds.Data("Count35")
		s:($listget(lstEntryID,35) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count35,1:valCells_$c(1)_$tr($p(Count35,"-",1)," ","")_$c(1)_$tr($p(Count35,"-",2)," ",""))
		s Count36 = ds.Data("Count36")
		s:($listget(lstEntryID,36) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count36,1:valCells_$c(1)_$tr($p(Count36,"-",1)," ","")_$c(1)_$tr($p(Count36,"-",2)," ",""))
		s Count37 = ds.Data("Count37")
		s:($listget(lstEntryID,37) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count37,1:valCells_$c(1)_$tr($p(Count37,"-",1)," ","")_$c(1)_$tr($p(Count37,"-",2)," ",""))
		s Count38 = ds.Data("Count38")
		s:($listget(lstEntryID,38) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count38,1:valCells_$c(1)_$tr($p(Count38,"-",1)," ","")_$c(1)_$tr($p(Count38,"-",2)," ",""))
		s Count39 = ds.Data("Count39")
		s:($listget(lstEntryID,39) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count39,1:valCells_$c(1)_$tr($p(Count39,"-",1)," ","")_$c(1)_$tr($p(Count39,"-",2)," ",""))
		s Count40 = ds.Data("Count40")
		s:($listget(lstEntryID,40) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count40,1:valCells_$c(1)_$tr($p(Count40,"-",1)," ","")_$c(1)_$tr($p(Count40,"-",2)," ",""))
		s Count41 = ds.Data("Count41")
		s:($listget(lstEntryID,41) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count41,1:valCells_$c(1)_$tr($p(Count41,"-",1)," ","")_$c(1)_$tr($p(Count41,"-",2)," ",""))
		s Count42 = ds.Data("Count42")
		s:($listget(lstEntryID,42) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count42,1:valCells_$c(1)_$tr($p(Count42,"-",1)," ","")_$c(1)_$tr($p(Count42,"-",2)," ",""))
		s Count43 = ds.Data("Count43")
		s:($listget(lstEntryID,43) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count43,1:valCells_$c(1)_$tr($p(Count43,"-",1)," ","")_$c(1)_$tr($p(Count43,"-",2)," ",""))
		s Count44 = ds.Data("Count44")
		s:($listget(lstEntryID,44) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count44,1:valCells_$c(1)_$tr($p(Count44,"-",1)," ","")_$c(1)_$tr($p(Count44,"-",2)," ",""))
		s Count45 = ds.Data("Count45")
		s:($listget(lstEntryID,45) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count45,1:valCells_$c(1)_$tr($p(Count45,"-",1)," ","")_$c(1)_$tr($p(Count45,"-",2)," ",""))
		s Count426 = ds.Data("Count46")
		s:($listget(lstEntryID,46) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count46,1:valCells_$c(1)_$tr($p(Count46,"-",1)," ","")_$c(1)_$tr($p(Count46,"-",2)," ",""))
		s Count47 = ds.Data("Count47")
		s:($listget(lstEntryID,47) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count47,1:valCells_$c(1)_$tr($p(Count47,"-",1)," ","")_$c(1)_$tr($p(Count47,"-",2)," ",""))
		s Count48 = ds.Data("Count48")
		s:($listget(lstEntryID,48) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count48,1:valCells_$c(1)_$tr($p(Count48,"-",1)," ","")_$c(1)_$tr($p(Count48,"-",2)," ",""))
		s Count49 = ds.Data("Count49")
		s:($listget(lstEntryID,49) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count49,1:valCells_$c(1)_$tr($p(Count49,"-",1)," ","")_$c(1)_$tr($p(Count49,"-",2)," ",""))
		s Count50 = ds.Data("Count50")
		s:($listget(lstEntryID,50) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count50,1:valCells_$c(1)_$tr($p(Count50,"-",1)," ","")_$c(1)_$tr($p(Count50,"-",2)," ",""))
		
		/*
		s Count51 = ds.Data("Count51")
		s:($listget(lstEntryID,51) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count51,1:valCells_$c(1)_$tr($p(Count51,"-",1)," ","")_$c(1)_$tr($p(Count51,"-",2)," ",""))
		s Count52 = ds.Data("Count52")
		s:($listget(lstEntryID,52) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count52,1:valCells_$c(1)_$tr($p(Count52,"-",1)," ","")_$c(1)_$tr($p(Count52,"-",2)," ",""))
		s Count53 = ds.Data("Count53")
		s:($listget(lstEntryID,53) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count53,1:valCells_$c(1)_$tr($p(Count53,"-",1)," ","")_$c(1)_$tr($p(Count53,"-",2)," ",""))
		s Count54 = ds.Data("Count54")
		s:($listget(lstEntryID,54) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count54,1:valCells_$c(1)_$tr($p(Count54,"-",1)," ","")_$c(1)_$tr($p(Count54,"-",2)," ",""))
		s Count55 = ds.Data("Count55")
		s:($listget(lstEntryID,55) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count55,1:valCells_$c(1)_$tr($p(Count55,"-",1)," ","")_$c(1)_$tr($p(Count55,"-",2)," ",""))
		s Count56 = ds.Data("Count56")
		s:($listget(lstEntryID,56) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count56,1:valCells_$c(1)_$tr($p(Count56,"-",1)," ","")_$c(1)_$tr($p(Count56,"-",2)," ",""))
		s Count57 = ds.Data("Count57")
		s:($listget(lstEntryID,57) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count57,1:valCells_$c(1)_$tr($p(Count57,"-",1)," ","")_$c(1)_$tr($p(Count57,"-",2)," ",""))
		s Count58 = ds.Data("Count58")
		s:($listget(lstEntryID,58) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count58,1:valCells_$c(1)_$tr($p(Count58,"-",1)," ","")_$c(1)_$tr($p(Count58,"-",2)," ",""))
		s Count59 = ds.Data("Count59")
		s:($listget(lstEntryID,59) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count59,1:valCells_$c(1)_$tr($p(Count59,"-",1)," ","")_$c(1)_$tr($p(Count59,"-",2)," ",""))
		s Count60 = ds.Data("Count60")
		s:($listget(lstEntryID,60) '= "") valCells = $s(($zcvt(IsWithPercent,"U") = "N"):valCells_$c(1)_Count60,1:valCells_$c(1)_$tr($p(Count60,"-",1)," ","")_$c(1)_$tr($p(Count60,"-",2)," ",""))
		*/
		
	 	s retval = AItemJS_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s Count = Count + 1
		s StartRow = StartRow + 1
	}
	d ds.Close()
	
	//打印“统计日期：2008-12-01 至 2008-12-21”
	s valCells = "统计日期："_StartDate_" 至 "_EndDate
	s retval = AItemJS_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',5,1);"
	&javascript<#(retval)#>
}

/// d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataAccess.BOQualitySpotCheck","GetManualRPTDetails","5","55","31563^31564^31565","61331","61348")
Query GetManualRPTDetails(ALocIDs As %String, ADocID As %String, AEntryIDs As %String, AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "RegNo,EpisodeID,PatientName,Gender,LocDesc,WardDesc,AdmitDate,DischDate,EntryTitle,EntryScore,MultiErrInfo,VetoInfo")
{
}

ClassMethod GetManualRPTDetailsExecute(ByRef qHandle As %Binary, ALocIDs As %String, ADocID As %String, AEntryIDs As %String, AStartDate As %String, AEndDate As %String) As %Status
{
	s uid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,uid,0)
	
	q:(AEntryIDs = "")||(AStartDate = "")||(AEndDate = "") $$$OK
	
	/* if you want some debug infomation, just open this closure notes
	s ^CacheTempXZX("EPRQuality","GetManualRPTDetails","ALocIDs")		= ALocIDs
	s ^CacheTempXZX("EPRQuality","GetManualRPTDetails","ADocID")		= ADocID
	s ^CacheTempXZX("EPRQuality","GetManualRPTDetails","AEntryIDs")		= AEntryIDs
	s ^CacheTempXZX("EPRQuality","GetManualRPTDetails","AStartDate")	= AStartDate
	s ^CacheTempXZX("EPRQuality","GetManualRPTDetails","AEndDate")		= AEndDate
	*/
	
	// Get loc list without empty elements
	s lstLocID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(ALocIDs,",")
	s ^ALocIDs = ALocIDs
	q:($listlength(lstLocID) = 0) $$$OK
	
	// Get entrys list with empty elements
	s lstEntryID = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(AEntryIDs,"^","N")
	q:($listlength(lstEntryID) = 0) $$$OK
	
	k ^CacheTemp("EPRQuality","ManualRPTDetail",uid)
	
	for AdmitDate = AStartDate:1:AEndDate
	{
		s RowID = ""
		for {
			s RowID = $o(^DHCEPRQ.QualitySpotCheckI("IdxAdmitDate",AdmitDate,RowID))
			q:(RowID = "")
			
			s objSpotCheck = $g(^DHCEPRQ.QualitySpotCheckD(RowID))
			continue:(objSpotCheck = "")
			
			s EpisodeID = $list(objSpotCheck,2)
			continue:(EpisodeID = "")
			
			// BuildManualReportList(EpisodeID,ListLocID,RuleCode,UniqueKey)
			s flag = ..BuildManualRPTDetail(EpisodeID,lstLocID,ADocID,lstEntryID,uid)
			continue:(flag < 0)
		}	
	}

	s DetailKey = ""
	for {
		s DetailKey = $o(^CacheTemp("EPRQuality","ManualRPTDetail",uid,DetailKey))
		q:(DetailKey = "")
		
		s Data = $g(^CacheTemp("EPRQuality","ManualRPTDetail",uid,DetailKey))
		s ^CacheTemp(uid,ind) = Data
		s ind = ind + 1	
	}
	
	k ^CacheTemp("EPRQuality","ManualRPTDetail",uid)
	
	q $$$OK
}

ClassMethod BuildManualRPTDetail(AEpisodeID As %String, AListLocID As %List, ADocID As %String, AListEntryID As %List, AUniqueKey As %String) As %Integer
{
	/* if you want some debug infomation, just open this closure notes
	s ^CacheTempXZX("EPRQuality","BuildManualRPTDetail","AEpisodeID")	= AEpisodeID
	s ^CacheTempXZX("EPRQuality","BuildManualRPTDetail","AListLocID")	= ##Class(EPRservice.Quality.CommonHelper).GetListToString(AListLocID,"^")
	s ^CacheTempXZX("EPRQuality","BuildManualRPTDetail","ADocID")		= ADocID
	s ^CacheTempXZX("EPRQuality","BuildManualRPTDetail","AListEntryID")	= ##Class(EPRservice.Quality.CommonHelper).GetListToString(AListEntryID,"^")
	s ^CacheTempXZX("EPRQuality","BuildManualRPTDetail","AUniqueKey")	= AUniqueKey
	*/
	
	s ret = -1
	q:(AEpisodeID = "")||(AUniqueKey = "") ret
		
	s objPaAdm = $g(^PAADM(+AEpisodeID))
	q:(objPaAdm = "") ret

	q:($p(objPaAdm,"^",2) '= "I") ret			//就诊类别
	q:($p(objPaAdm,"^",75) '= "") ret			//婴儿不建档案
	//q:($p(objPaAdm,"^",20) '= "D") ret		//就诊状态
	
	s DisLocID = $p(objPaAdm,"^",4)				//出院科室
	q:(DisLocID = "") ret
	q:($listlength(AListLocID) > 0)&&($listfind(AListLocID,DisLocID) = 0) ret
	
	s AdmDoctorID = $p(objPaAdm,"^",9)			//主管医生
	s:(AdmDoctorID = "") AdmDoctorID = "-1"
	q:(ADocID '= "")&&(AdmDoctorID '= ADocID) ret
	
	s AdmWardID = $p(objPaAdm,"^",70)			//出院病区
	
	// 患者基本信息
	s Papmi = $p(objPaAdm,"^",1)
	s PatientName = $p($g(^PAPER(+Papmi,"ALL")),"^",1)			
	s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)
	s Gender = $p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
	s AdmitDate = $zd($p(objPaAdm,"^",6),3)
	s DischDate = $p(objPaAdm,"^",17)
	s:(DischDate '= "") DischDate = $zd(DischDate,3)
	s LocDesc = $p($g(^CTLOC(+DisLocID)),"^",2)
	s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
	s WLocID = $p($g(^PAWARD(+AdmWardID)),"^",5)
	s:(WLocID '= "") WardDesc = $p($g(^CTLOC(+WLocID)),"^",2)
	s:(WardDesc [ "-") WardDesc = $p(WardDesc,"-",2)
	s DoctorDesc = $s(AdmDoctorID '= "-1":$p($g(^CTPCP((+AdmDoctorID),1)),"^",2),1:"未指定")
			
	for i = 1:1:$listlength(AListEntryID)
	{
		//每一列有可能还是一组Entry
		s EntrySet = $listget(AListEntryID,i)
		continue:(EntrySet = "")	
		
		s EntryGroup = $p(EntrySet,"#",1)
		s IsPerEntry = $p(EntrySet,"#",2)
		
		s lstEntries = ##Class(EPRservice.Quality.CommonHelper).GetListFromString(EntryGroup,"|")
		for j = 1:1:$listlength(lstEntries)
		{
			s EntryID = $listget(lstEntries,j)
			continue:(EntryID = "")
			
			s objEntry = $g(^DHCEPRM.QualityEntryD(+EntryID))
	  		//continue:(objEntry = "")		// 如果这个条目被删除了，则不参与计分

			s ResultID = $o(^DHCEPRQ.QualityResultDetailI("IdxEpisodeEntryID"," "_AEpisodeID," "_EntryID,""))
			if (+ResultID > 0)
			{
				s DetailID = $o(^DHCEPRQ.QualityResultDetailI("IdxEpisodeEntryID"," "_AEpisodeID," "_EntryID,ResultID,""))
				continue:(DetailID = "")
				
				s RowID = ResultID_"||"_DetailID
				s objDetail = ##Class(EPRinstance.Quality.QualityResultDetail).%OpenId(RowID)
				
				s EntryScore = objDetail.EntryScore
				
				s EntryTitle = ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).GetTitleByEntryID(EntryID)
	  		
		  		s IsMultiErr = $list(objEntry,6)
		  		s MultiErrInfo = $s(IsMultiErr = "Y":"是",1:"否")
		  		s IsVeto = $list(objEntry,7)
		  		s VetoGrade = $list(objEntry,11)
		  		s VetoInfo = $s(IsVeto = "Y":VetoGrade,1:"否")
				
				s DetailKey = DisLocID_"||"_AdmDoctorID_"||"_AEpisodeID_"||"_EntryID
				s ^CacheTemp("EPRQuality","ManualRPTDetail",AUniqueKey,DetailKey) = $lb(RegNo,AEpisodeID,PatientName,Gender,LocDesc,WardDesc,AdmitDate,DischDate,EntryTitle,EntryScore,MultiErrInfo,VetoInfo)
			
				if (objDetail '= "")
				{
					d objDetail.%Close()
					k objDetail
				}
			}
		}
	}
	
	s ret = 1
	q ret
}

ClassMethod GetManualRPTDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetManualRPTDetailsExecute ]
{
	s AtEnd = $list(qHandle,1)
 	s repid = $list(qHandle,2)
 	s ind = $list(qHandle,3)
 	
 	s ind = $o(^CacheTemp(repid,ind))
 	if (ind = "") 
 	{
 		s AtEnd = 1
 		s Row = ""
 		k ^CacheTemp(repid)
 	} 
 	else 
 	{	
 		s Row = ^CacheTemp(repid,ind)
 	}
 	s qHandle = $lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetManualRPTDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetManualRPTDetailsExecute ]
{
	s repid = $list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

}
