Class EPRservice.Quality.DataAccess.BOQualityAiResult Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/qualityservice";

Parameter SERVICENAME = "QualityAiResult";

/// Creator:	    qy
/// Create Date:	2021
/// Desc:			内涵质控缺陷数据保存
/// Input:			AInput	EpisodeID^EntryDR^AiResultTitle^SignUserDR^ErrorText
/// Output:         -1 失败  >0 AiResultID
/// Debug:w ##Class(EPRservice.Quality.DataAccess.BOQualityAiResult).SaveAiResult()
ClassMethod SaveAiResult(AInput As %String)
{
	q:(AInput="") "-1"
	
	s AiResultID = $o(^DHCEPRQ.AiResultI("IdxEpisodeAiResultTitle"," "_$p(AInput,"^",1)," "_$zcvt($p(AInput,"^",3),"U"),""))
	q:(AiResultID '= "") AiResultID
	
	s objAiResult = ##Class(EPRinstance.Quality.AiResult).%New()
	s objAiResult.EpisodeID = $p(AInput,"^",1)
	s objAiResult.EntryDR=$p(AInput,"^",2)
	s objAiResult.AiResultTitle=$p(AInput,"^",3)
	s objAiResult.SignUserDR=$p(AInput,"^",4)
	s objAiResult.ExamineDate=$zd($p($h,",",1),3)
	s objAiResult.ExamineTime=$zt($p($h,",",2),1)
	s objAiResult.ErrorText =$p(AInput,"^",5)
	s sc = objAiResult.%Save()
	if $SYSTEM.Status.IsError(sc) 
	{                               
   		d $SYSTEM.OBJ.DisplayError(sc) 
   		s AiResultID = -1
	}
	else
	{
		s AiResultID = objAiResult.%Id()
	}
	d objAiResult.%Close()	
	q AiResultID
}

/// Creator:	    qy
/// Create Date:	2021
/// Desc:			内涵质控缺陷标记
/// Input:			AInput	EpisodeID^AiResultTitle^Tag^Remarks
/// Output:         -1 失败  >0 AiResultID
/// Debug:w ##class(EPRservice.Quality.DataAccess.BOQualityAiResult).SaveAiTag("59^首次病程病历特点-起病病程未描述^Recovered^已修复")
ClassMethod SaveAiTag(AInput As %String)
{
	q:(AInput="") "-1"
	
	s EpisodeID=$p(AInput,"^",1)
	s AiResultTitle=$p(AInput,"^",2)
	s AiResultID = $o(^DHCEPRQ.AiResultI("IdxEpisodeAiResultTitle"," "_EpisodeID," "_$zcvt(AiResultTitle,"U"),""))

	q:(AiResultID = "") "-1"
	//修改的更新
	s editFlag=0
	s objAiResult = ##Class(EPRinstance.Quality.AiResult).%OpenId(AiResultID)
	s:(objAiResult.Tag'=$p(AInput,"^",3)) objAiResult.Tag = $p(AInput,"^",3),editFlag=1
	s:(objAiResult.Remarks'=$p(AInput,"^",4)) objAiResult.Remarks=$p(AInput,"^",4),editFlag=1
	q:(editFlag=0) "noEdit"
	s:(editFlag=1) objAiResult.RemarksDate=$zd($p($h,",",1),3),objAiResult.RemarksTime=$zt($p($h,",",2),1)
	
	s sc = objAiResult.%Save()
	if $SYSTEM.Status.IsError(sc) 
	{                               
   		d $SYSTEM.OBJ.DisplayError(sc) 
   		s AiResultID = -1
	}
	else
	{
		s AiResultID = objAiResult.%Id()
	}
	d objAiResult.%Close()	
	q AiResultID
}

/// Creator:	    qy
/// Create Date:	2021
/// Desc:			某患者某阶段质控中是否保存某条目
/// Input:			AEpisodeID	就诊号
/// 				AEntryID	EntryID
/// 				AResumeText	内涵条目备注
/// 				Action		质控阶段
/// Output:         0 没有保存此条目  1 保存了此条目
/// Debug: w ##Class(EPRservice.Quality.DataAccess.BOQualityAiResult).IsAiItemInDetail()
ClassMethod IsAiItemInDetail(AEpisodeID As %String, AEntryID As %String, AResumeText As %String, Action As %String)
{
	s ret=0

	s ResultId=$o(^DHCEPRQ.QualityResultI("IdxEpisodeRuleID"," "_AEpisodeID," 1",""),-1)
	q:(ResultId="") ret
	s action=$lg(^DHCEPRQ.QualityResultD(ResultId),15)
	q:(action'=Action) ret
	s DetailId=""
	for{
		s DetailId=$o(^DHCEPRQ.QualityResultD(ResultId,"Details",DetailId))
		q:(DetailId="")
		s Entryid=$lg(^DHCEPRQ.QualityResultD(ResultId,"Details",DetailId),2)
		continue:(Entryid'=AEntryID) 
		s ResumeText=$lg(^DHCEPRQ.QualityResultD(ResultId,"Details",DetailId),9)
		s:(ResumeText=AResumeText) ret=1
		
		q:(ret=1)
	}
	
	q ret
}

/// Creator:	    qy
/// Create Date:	2021
/// Desc:			条目是否错误反馈
/// Input:			AEpisodeID	就诊号
/// 				EntryID		EntryID
/// 				AiResultTitle	内涵条目完整提示文本
/// Output:         0 没有错误反馈  1 进行了错误反馈
/// Debug: w ##Class(EPRservice.Quality.DataAccess.BOQualityAiResult).IsAiItemInAiResult()
ClassMethod IsAiItemInAiResult(AEpisodeID As %String, EntryID As %String, AiResultTitle As %String)
{
	s ret=0
	s AIid=""
	for{
		s AIid=$o(^DHCEPRQ.AiResultI("IdxEpisodeEntryID"," "_AEpisodeID," "_EntryID,AIid))
		q:(AIid="")
		s AiResultObj=##class(EPRinstance.Quality.AiResult).%OpenId(AIid)
		s ResultTitle=AiResultObj.AiResultTitle
		s:(AiResultTitle=ResultTitle) ret=1
		q:(ret=1)
	}
	
	q ret
}

/// Creator:	    qy
/// Create Date:	2021
/// Desc:			内涵质控保存及错误反馈统计
/// Input:			AStartDate	质控开始时间
/// 				AEndDate	质控结束时间
/// 				ADay		数据统计时间段间隔
/// Output:         保存数量、错误反馈数量、合计、错误反馈占总数比值
/// Debug: d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataAccess.BOQualityAiResult","GetCorrectRateData","2021-06-01","2021-08-30")
Query GetCorrectRateData(AStartDate As %String, AEndDate As %String, ADay As %String = "7") As %Query(ROWSPEC = "startDate,endDate,ErrCount,CorrectCount,Count,CorrectRate") [ SqlProc ]
{
}

ClassMethod GetCorrectRateDataExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ADay As %String = "7") As %Status
{
 
    s repid = $i(^CacheTemp)
	s ind = 2
	s qHandle = $lb(0,repid,"")

	s IntervalDay=ADay-1
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AStartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AEndDate)," ",1)
	s ARule=$o(^DHCEPRM.QualityRuleI("IdxCode","A",""))
	s NRule=$o(^DHCEPRM.QualityRuleI("IdxCode","N",""))
	s endDate=EndDate
	s startDate=EndDate-IntervalDay
	for {
		q:(startDate<StartDate)
		s ErrCount=0,CorrectCount=0,Count=0,CorrectRate=0
		s start=$zd(startDate,3),end=$zd(endDate,3)
		&sql(
			SELECT count(*) INTO :ErrCount FROM EPRinstance_Quality.AiResult WHERE ExamineDate >= :start AND ExamineDate<=:end
		)
		&sql(
			SELECT count(*) into :CorrectCount FROM EPRinstance_quality.qualityresultdetail a, EPRmeta_Quality.qualityENTRY b,EPRinstance_quality.qualityresult c 
			WHERE a.EntryDR=b.ID  AND a.TheResult=c.ID 
		 	AND a.TriggerDate<=:end AND a.TriggerDate>= :start AND c.RuleDR=:ARule AND b.RuleDR=:NRule
		)

		s Count=ErrCount+CorrectCount
		s:(Count'=0) CorrectRate=CorrectCount/Count
		s:(start'="") start = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",start)
		s:(end'="") end = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",end)
		s Data = $lb(start,end,ErrCount,CorrectCount,Count,CorrectRate)
	 	s ^CacheTemp(repid,ind) = Data
	 	s ind = ind + 1
	 	s endDate=startDate-1
		s startDate=endDate-IntervalDay
	}
	
	Quit $$$OK
}

ClassMethod GetCorrectRateDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCorrectRateDataExecute ]
{
	s repid = $list(qHandle,2)
  k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCorrectRateDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCorrectRateDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
  Set repid=$LIST(qHandle,2)
  Set ind=$LIST(qHandle,3)
  Set ind=$o(^CacheTemp(repid,ind))
  If ind="" { // if there are no more rows, finish fetching
  Set AtEnd=1
  Set Row=""
  }
  Else      { // fetch row
  Set Row=^CacheTemp(repid,ind)
  }
  s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:	    qy
/// Create Date:	2021
/// Desc:			内涵质控保存及手工保存统计
/// Input:			AStartDate	质控开始时间
/// 				AEndDate	质控结束时间
/// 				ADay		数据统计时间段间隔
/// Output:         内涵保存数量、手工保存数量、合计、内涵保存占总数比值
/// Debug:d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataAccess.BOQualityAiResult","GetCorrectRateData","2021-06-01","2021-08-30")
Query GetAcceptRateData(AStartDate As %String, AEndDate As %String, ADay As %String = "7") As %Query(ROWSPEC = "startDate,endDate,AiCount,ManualCount,Count,EpiCount,AcceptRate") [ SqlProc ]
{
}

ClassMethod GetAcceptRateDataExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, ADay As %String = "7") As %Status
{
 
    s repid = $i(^CacheTemp)
	s ind = 2
	s qHandle = $lb(0,repid,"")

	s IntervalDay=ADay-1
	s StartDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AStartDate)," ",1)
	s EndDate	= $p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AEndDate)," ",1)
	s ARule=$o(^DHCEPRM.QualityRuleI("IdxCode","A",""))
	s NRule=$o(^DHCEPRM.QualityRuleI("IdxCode","N",""))
	s endDate=EndDate
	s startDate=EndDate-IntervalDay
	for {
		q:(startDate<StartDate)
		s AiCount=0,ManualCount=0,Count=0,EpiCount=0,AcceptRate=0
		s start=$zd(startDate,3),end=$zd(endDate,3)
		&sql(
			SELECT count(*) into :AiCount FROM EPRinstance_quality.qualityresultdetail a, EPRmeta_Quality.qualityENTRY b,EPRinstance_quality.qualityresult c 
			WHERE a.EntryDR=b.ID  AND a.TheResult=c.ID 
		 	AND a.TriggerDate<=:end AND a.TriggerDate>= :start AND c.RuleDR=:ARule AND b.RuleDR=:NRule
		)
		&sql(
			SELECT count(*) into :ManualCount FROM EPRinstance_quality.qualityresultdetail a, EPRmeta_Quality.qualityENTRY b,EPRinstance_quality.qualityresult c 
			WHERE a.EntryDR=b.ID  AND a.TheResult=c.ID 
		 	AND a.TriggerDate<=:end AND a.TriggerDate>= :start AND c.RuleDR=:ARule AND b.RuleDR=:ARule
		)
		&sql(
			SELECT count (DISTINCT a.EpisodeID) into :EpiCount FROM EPRinstance_quality.qualityresultdetail a, EPRmeta_Quality.qualityENTRY b,EPRinstance_quality.qualityresult c 
			WHERE a.EntryDR=b.ID  AND a.TheResult=c.ID 
		 	AND a.TriggerDate<=:end AND a.TriggerDate>= :start AND c.RuleDR=:ARule
		)
		//s AiCount=$r(100),SelfCount=$r(100)
		s Count=AiCount+ManualCount
		s:(Count'=0) AcceptRate=AiCount/Count
		s:(start'="") start = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",start)
		s:(end'="") end = ##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",end)
		s Data = $lb(start,end,AiCount,ManualCount,Count,EpiCount,AcceptRate)
	 	s ^CacheTemp(repid,ind) = Data
	 	s ind = ind + 1
	 	s endDate=startDate-1
		s startDate=endDate-IntervalDay
	}
	
	Quit $$$OK
}

ClassMethod GetAcceptRateDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAcceptRateDataExecute ]
{
	s repid = $list(qHandle,2)
  k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAcceptRateDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAcceptRateDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
  Set repid=$LIST(qHandle,2)
  Set ind=$LIST(qHandle,3)
  Set ind=$o(^CacheTemp(repid,ind))
  If ind="" { // if there are no more rows, finish fetching
  Set AtEnd=1
  Set Row=""
  }
  Else      { // fetch row
  Set Row=^CacheTemp(repid,ind)
  }
  s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:	    qy
/// Create Date:	2021
/// Desc:			内涵反馈明细
/// Input:			AStartDate	质控开始时间
/// 				AEndDate	质控结束时间
/// Output:         明细
/// Debug:d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataAccess.BOQualityAiResult","GetAiErrDatail","2021-06-01","2021-08-30")
Query GetAiErrDetail(AStartDate As %String, AEndDate As %String) As %Query(ROWSPEC = "EpisodeID,Name,RegNo,LocDesc,DoctorDesc,EntryTitle,ErrorText,SignUserDesc,ExamineDate,Tag,TagDesc,Remarks") [ SqlProc ]
{
}

ClassMethod GetAiErrDetailExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String) As %Status
{
 
    s repid = $i(^CacheTemp)
	s ind = 2
	s qHandle = $lb(0,repid,"")
	
	s AiErrTag=##Class(EPRservice.Quality.DataAccess.BOQualityParams).GetValuebyCode("AiErrTag")
	s TagObj={}.%FromJSON(AiErrTag)
	s start=$p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AStartDate)," ",1)
	s end=$p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AEndDate)," ",1)
	s Date=""
	for {
		s Date=$o(^DHCEPRQ.AiResultI("IdxExamineDate",Date))
		q:(Date="")||($zdh($tr(Date," ",""),3)>$tr(end," ",""))  
		continue:($zdh($tr(Date," ",""),3)<$tr(start," ",""))
		s AiResultid=""
		for {
			s AiResultid=$o(^DHCEPRQ.AiResultI("IdxExamineDate",Date,AiResultid))
			q:(AiResultid="")
			s AiResultobj=##class(EPRinstance.Quality.AiResult).%OpenId(AiResultid)
			s EpisodeID=AiResultobj.EpisodeID
			s ErrorText=AiResultobj.ErrorText
			s ExamineDate=AiResultobj.ExamineDate
			s ExamineDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ExamineDate)
			s SignUserDR=AiResultobj.SignUserDR
			s SignUserDesc = $s($g(SignUserDR)'="-1":$p($g(^SSU("SSUSR",+SignUserDR)),"^",2),1:"无")
			s AiResultTitle=AiResultobj.AiResultTitle
			s Tag=AiResultobj.Tag
			s TagDesc=""
			s:(Tag'="") TagDesc=TagObj.%Get(Tag)
			
			s Remarks=AiResultobj.Remarks
			//基本信息
			s objPaAdm = $g(^PAADM(+EpisodeID))
			continue:(objPaAdm = "") 
			s Papmi = $p(objPaAdm,"^",1)
			s DisLocID = $p(objPaAdm,"^",4)				
			continue:(DisLocID = "") 
			s AdmDoctorID = $p(objPaAdm,"^",9)				
			s:(AdmDoctorID = "") AdmDoctorID = "-1"
			s DoctorDesc = $s(AdmDoctorID '= -1:$p($g(^CTPCP((+AdmDoctorID),1)),"^",2),1:"未指定")
			s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1)
			s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)	
			s Gender = $p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
			s AdmitDate = $zd($p(objPaAdm,"^",6),3)
			s AdmitTime = $zt($p(objPaAdm,"^",7),1)
			s DischDate = $p(objPaAdm,"^",17)
			s DischTime = $p(objPaAdm,"^",18)
			s:(DischDate '= "") DischDate = $zd(DischDate,3)
			s:(DischTime '= "") DischTime = $zt(DischTime,1)
			s LocDesc = $p($g(^CTLOC(+DisLocID)),"^",2)
			s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
			s Data = $lb(EpisodeID,Name,RegNo,LocDesc,DoctorDesc,AiResultTitle,ErrorText,SignUserDesc,ExamineDate,Tag,TagDesc,Remarks)
		 	s ^CacheTemp(repid,ind) = Data
		 	s ind = ind + 1
		}	
	}
	
	Quit $$$OK
}

ClassMethod GetAiErrDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAiErrDetailExecute ]
{
	s repid = $list(qHandle,2)
  k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAiErrDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAiErrDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
  Set repid=$LIST(qHandle,2)
  Set ind=$LIST(qHandle,3)
  Set ind=$o(^CacheTemp(repid,ind),-1)
  If ind="" { // if there are no more rows, finish fetching
  Set AtEnd=1
  Set Row=""
  }
  Else      { // fetch row
  Set Row=^CacheTemp(repid,ind)
  }
  s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:	    qy
/// Create Date:	2021
/// Desc:			内涵质控保存明细
/// Input:			AStartDate	质控开始时间
/// 				AEndDate	质控结束时间
/// 				AType		类型（N 内涵保存 A 手工保存）
/// Output:         明细
/// Debug:d ##Class(%ResultSet).RunQuery("EPRservice.Quality.DataAccess.BOQualityAiResult","GetAiCorrectDetail","2021-06-01","2021-08-30","N")
Query GetAiCorrectDetail(AStartDate As %String, AEndDate As %String, AType As %String = "N") As %Query(ROWSPEC = "EpisodeID,Name,RegNo,LocDesc,DoctorDesc,EntryTitle,ResumeText,SignUserDesc,ExamineDate") [ SqlProc ]
{
}

ClassMethod GetAiCorrectDetailExecute(ByRef qHandle As %Binary, AStartDate As %String, AEndDate As %String, AType As %String = "N") As %Status
{
 
    s repid = $i(^CacheTemp)
	s ind = 2
	s qHandle = $lb(0,repid,"")
	
	s start=$p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AStartDate)," ",1)
	s end=$p(##Class(EPRservice.Quality.CommonHelper).ChangeTimeToSys(AEndDate)," ",1)
	s RuleID=$o(^DHCEPRM.QualityRuleI("IdxCode",AType,""))
	s Date=""
	for {
		s Date=$o(^DHCEPRQ.QualityResultI("IdxExamineDate",Date))
		q:(Date="")||($zdh($tr(Date," ",""),3)>$tr(end," ","")) 
		continue:($zdh($tr(Date," ",""),3)<$tr(start," ",""))
		s Resultid=""
		for {
			s Resultid=$o(^DHCEPRQ.QualityResultI("IdxExamineDate",Date,Resultid))
			q:(Resultid="")
			s Resultobj=##class(EPRinstance.Quality.QualityResult).%OpenId(Resultid)
			continue:(Resultobj.RuleDR'=1)
			s ExamineDate=Resultobj.ExamineDate
			s ExamineDate=##class(EMRservice.Util.DateTimeFormat).GetHISStandardDateTimeFormat("ChangeToFormat","Date",ExamineDate)
			s SignUserDR=Resultobj.SignUserDR
			s SignUserDesc = $s($g(SignUserDR)'="-1":$p($g(^SSU("SSUSR",+SignUserDR)),"^",2),1:"无")
			s EpisodeID=Resultobj.EpisodeID
			//基本信息
			s objPaAdm = $g(^PAADM(+EpisodeID))
			continue:(objPaAdm = "") 
			s Papmi = $p(objPaAdm,"^",1)
			s DisLocID = $p(objPaAdm,"^",4)				
			continue:(DisLocID = "") 
			s AdmDoctorID = $p(objPaAdm,"^",9)				
			s:(AdmDoctorID = "") AdmDoctorID = "-1"
			s DoctorDesc = $s(AdmDoctorID '= -1:$p($g(^CTPCP((+AdmDoctorID),1)),"^",2),1:"未指定")
			s Name = $p($g(^PAPER(+Papmi,"ALL")),"^",1)
			s RegNo = $p($g(^PAPER(+Papmi,"PAT",1)),"^",1)	
			s Gender = $p($g(^CT("SEX",$p($g(^PAPER(+Papmi,"ALL")),"^",7))),"^",2)
			s AdmitDate = $zd($p(objPaAdm,"^",6),3)
			s AdmitTime = $zt($p(objPaAdm,"^",7),1)
			s DischDate = $p(objPaAdm,"^",17)
			s DischTime = $p(objPaAdm,"^",18)
			s:(DischDate '= "") DischDate = $zd(DischDate,3)
			s:(DischTime '= "") DischTime = $zt(DischTime,1)
			s LocDesc = $p($g(^CTLOC(+DisLocID)),"^",2)
			s:(LocDesc [ "-") LocDesc = $p(LocDesc,"-",2)
			
			s key = ""
			do {
				s objDetail = Resultobj.Details.GetNext(.key)
			  	if (objDetail '= "")
			  	{ 
			  		s EntryID = objDetail.EntryDR
			  		s EntryTitle = ##Class(EPRservice.Quality.DataAccess.BOQualityEntry).GetTitleByEntryID(EntryID)
			  		s ResumeText = objDetail.ResumeText	
			  		s entryObj=##class(EPRmeta.Quality.QualityEntry).%OpenId(EntryID)
			  		continue:(entryObj.RuleDR'=RuleID)
			  		
					s Data = $lb(EpisodeID,Name,RegNo,LocDesc,DoctorDesc,EntryTitle,ResumeText,SignUserDesc,ExamineDate)
				 	s ^CacheTemp(repid,ind) = Data
				 	s ind = ind + 1
			  	}
			} while(key '= "")
	
		}	
	}
	
	Quit $$$OK
}

ClassMethod GetAiCorrectDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAiCorrectDetailExecute ]
{
	s repid = $list(qHandle,2)
  k ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAiCorrectDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAiCorrectDetailExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
  Set repid=$LIST(qHandle,2)
  Set ind=$LIST(qHandle,3)
  Set ind=$o(^CacheTemp(repid,ind),-1)
  If ind="" { // if there are no more rows, finish fetching
  Set AtEnd=1
  Set Row=""
  }
  Else      { // fetch row
  Set Row=^CacheTemp(repid,ind)
  }
  s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
