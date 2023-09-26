Import SQLUser

Class web.DHCEkg.GetEkgReportState Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 107;

/// 
/// Creator：      yangyali
/// CreatDate：    2017-08-20
/// Modify: 	   
/// ModifyDate：   
/// Description:   新住院医生站查询心电医嘱检查信息
/// Input：        就诊号，开始日期，结束日期
/// Return： 	   医嘱号，报告状态，阴阳性，报告医生，报告医生ID，报告时间，诊断结论
/// d ##class(%ResultSet).RunQuery("web.DHCEkg.GetEkgReportState","GetReportState","1376","2011-1-1","2017-10-30")
Query GetReportState(EpisodeID As %String, StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "OeordId:%String,ReportState:%String,Negative:%String,DoctorName:%String,DoctorId:%String,ReportTime:%String,Diagnose:%String")
{
}

ClassMethod GetReportStateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReportStateExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetReportStateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReportStateExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetReportStateExecute(ByRef qHandle As %Binary, EpisodeID As %String, StartDate As %String, EndDate As %String) As %Status
{
	s repid=$I(^CacheTemp) 
	s qHandle=$lb(0,repid,0)
	s ind=1

	//1.如果SD or ED 为空，那么取today，前段最好控制不为空
	//2.对日期格式需要进行处理
	//3.UserID为空则查全部的，否则查用户
	i StartDate["-" s StartDate=$zdh(StartDate,3)
	i EndDate["-" s EndDate=$zdh(EndDate,3)
	
	i StartDate["/" d
	.s StartDate=$tr(StartDate,"/","-") ;$translate("2015/02/05","/","-")
	.s StartDate=$zdh(StartDate,3)
	
	i EndDate["/" d
	.s EndDate=$tr(EndDate,"/","-")
	.s EndDate=$zdh(EndDate,3)
	
	i (StartDate="") && (EndDate="")  d
	.s sdate=$p($h,",",1)-15,edate=$p($h,",",1)+2
	e  d
	.s sdate=StartDate,edate=EndDate
	
	s CurrentNS = $ZNSPACE
 	s (OeordId,ReportState,Negative,DoctorName,DoctorId,ReportTime,Diagnose)=""
 	
  	s requestId=""
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()	
	f  s requestId=$o(^dbo.tblRequestI("idxAppointNo",EpisodeID,requestId)) q:(requestId="")  d
	.;b ;requestId
	.s (OeordId,ReportState,Negative,DoctorName,DoctorId,ReportTime,Diagnose)=""
	.s requestInfo=^dbo.tblRequestD(requestId)
	.q:(requestInfo="")
	.s OeordId=$li(requestInfo,6)
	.s examId=$o(^dbo.tblExaminationI("idxRequestID",requestId,""))
	.q:(examId="")
	.s examInfo=^dbo.tblExaminationD(examId)
	.q:(examInfo="")
	.s operate=$li(examInfo,13)
	.q:operate=""
	.s operateDate=$zdh($p(operate,$c(32),1),3)
	.s operateTime=$zdt($p(operate,$c(32),2),3)
	.q:((operateDate>edate) || (operateDate<sdate))
	.s status=$li(examInfo,20)
	.s ReportState="0"
	.i ((status="15")!(status="17")) d
	..s ReportState="1"
	..s Negative=$li(examInfo,30)
	..s Diagnose=$li(examInfo,11)
	..i Diagnose'[$c(10) s Diagnose=Diagnose_$c(10) 
	..s D=""
	..f i=1:1:$l(Diagnose,$c(10)) d
	...s tmpD=$p(Diagnose,$c(10),i)
	...i (tmpD'="") d
	....i (D="") s D=tmpD
	....e  s D=D_","_tmpD
	..s Diagnose=D
	..s ReportTime=$li(examInfo,6)
	..s ReportUserID=$li(examInfo,7)
	..q:((ReportUserID="")!(ReportUserID="0"))
	..s userInfo=$g(^dbo.tblUserD(ReportUserID))
	..q:(userInfo="")
	..s DoctorId=$li(userInfo,8)
	..s DoctorName=$li(userInfo,11)
	.d OutEKGRptItem
	
	
  	zn CurrentNS
  	
 	q $$$OK
 
OutEKGRptItem
	new $NAMESPACE
	zn CurrentNS
 	s Data=$lb(OeordId,ReportState,Negative,DoctorName,DoctorId,ReportTime,Diagnose)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
 	q
}

/// 
/// Creator：      yangyali
/// CreatDate：    2017-08-20
/// Modify: 	   
/// ModifyDate：   
/// Description:   新住院医生站查询心电医嘱检查信息
/// Input：        就诊号，开始日期，结束日期
/// Return： 	   医嘱号，报告状态，阴阳性，报告医生，报告医生ID，报告时间，诊断结论
/// d ##class(%ResultSet).RunQuery("web.DHCEkg.GetEkgReportState","GetReportInfoByOrdID","21||350")
Query GetReportInfoByOrdID(OeordId As %String) As %Query(ROWSPEC = "ReportState:%String,Negative:%String,DoctorName:%String,DoctorId:%String,ReportTime:%String,Diagnose:%String,ReportUrl:%String")
{
}

ClassMethod GetReportInfoByOrdIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReportInfoByOrdIDExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetReportInfoByOrdIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReportInfoByOrdIDExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetReportInfoByOrdIDExecute(ByRef qHandle As %Binary, OeordId As %String) As %Status
{
	s repid=$I(^CacheTemp) 
	s qHandle=$lb(0,repid,0)
	s ind=1
	
 	s (ReportState,Negative,DoctorName,DoctorId,ReportTime,Diagnose,ReportUrl)=""
 	
	d GetInfoFromEKG
		
 	s Data=$lb(ReportState,Negative,DoctorName,DoctorId,ReportTime,Diagnose,ReportUrl)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
  	
 	q $$$OK
 	
GetInfoFromEKG
	new $NAMESPACE
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()	
  	s requestId=""
	s requestId=$o(^dbo.tblRequestI("indexBarcode"," "_OeordId,requestId))
	;b ;requestId
	q:(requestId="")
	s requestInfo=^dbo.tblRequestD(requestId)
	q:(requestInfo="")
	s examId=$o(^dbo.tblExaminationI("idxRequestID",requestId,""))
	q:(examId="")
	s examInfo=^dbo.tblExaminationD(examId)
	q:(examInfo="")
	s status=$li(examInfo,20)
	s ReportState="0"
	i ((status="15")!(status="17")) d
	.s ReportState="1"
	.s Negative=$li(examInfo,30)
	.s Diagnose=$li(examInfo,11)
	.i Diagnose'[$c(10) s Diagnose=Diagnose_$c(10) 
	.s D=""
	.f i=1:1:$l(Diagnose,$c(10)) d
	..s tmpD=$p(Diagnose,$c(10),i)
	..i (tmpD'="") d
	...i (D="") s D=tmpD
	...e  s D=D_","_tmpD
	.s Diagnose=D
	.s ReportTime=$li(examInfo,6)
	.s ReportUserID=$li(examInfo,7)
	.q:((ReportUserID="")!(ReportUserID="0"))
	.s userInfo=$g(^dbo.tblUserD(ReportUserID))
	.q:(userInfo="")
	.s DoctorId=$li(userInfo,8)
	.s DoctorName=$li(userInfo,11)
	.s urlCfgId=$o(^dbo.tblConfigureI("idxKey"," WEBURL",""))
	.q:(urlCfgId="")
	.s urlInfo=^dbo.tblConfigureD(urlCfgId)
	.q:(urlInfo="")
	.s url=$li(urlInfo,6)
	.s ReportUrl=url_"?OID="_OeordId
 	q
}

/// Creator：      yangyali
/// CreatDate：    2018-3-22
/// Modify: 	   yangyali
/// ModifyDate：   2020-12-30
/// Description:	通过医嘱号查询心电报告信息
/// Table：        
/// Input：        医嘱ID
/// Output：       是否已完成报告，阴/阳性，报告医生，医生工号，报告时间，诊断结论，报告链接，已读未读
/// w ##class(web.DHCEkg.GetEkgReportState).GetEKGRptInfo("266||134","4634")
ClassMethod GetEKGRptInfo(OeordId As %String, UserId As %String) As %String
{
	new $namespace
	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkg.GetEkgReportState","GetEKGRptInfo",
			$zd($h,3),$zt($p($h,",",2),1),OeordId_"^"_UserId,"params")
	s $ZT="ERRORSEKGINFO"
	s (ReportState,Negative,DoctorName,DoctorId,ReportTime,Diagnose,ReportUrl,ReadStatus)=""
 	
	d GetRptInfoFromEKG
	
	;if UserId'="" set docCode=$p(^SSU("SSUSR",UserId),"^",1)
	;else  set docCode="" 
	
	set studyNo="EKG||"_OeordId
	;set ReadStatus=##class(RISService.TrakRISService).GetRPTCMStatus(OeordId,studyNo,docCode)
	set ReadStatus=##Class(web.DHCEkgService).IfRptRead(OeordId,UserId)
	set ReadStatus=$p(ReadStatus,"^",1)
 	s rtnInfo=ReportState_"^"_Negative_"^"_DoctorName_"^"_DoctorId_"^"_ReportTime_"^"_
 				Diagnose_"^"_ReportUrl_"^"_ReadStatus
  	d ##class(web.DHCEkg.Base).Log("Log","web.DHCEkg.GetEkgReportState","GetEKGRptInfo",
			$zd($h,3),$zt($p($h,",",2),1),rtnInfo,"rtn")
 	q rtnInfo
	 	
GetRptInfoFromEKG
	new $NAMESPACE
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()	
	
	s (examId,tmpExamId)=""
	s (tmpReqID,reqID)=""
	s tmpReqID=$o(^dbo.tblRequestI("indexBarcode"," "_OeordId,tmpReqID))
	while ((tmpReqID'="")&&(examId=""))
	{
		//查询有效检查
		s tmpExamId=""
		s tmpExamId=$o(^dbo.tblExaminationI("idxRequestID",tmpReqID,tmpExamId))
		s flag=0 ;查到有效检查的标志
		while((tmpExamId'="")&&'flag)
		{
			s tmpExamInfo=$g(^dbo.tblExaminationD(tmpExamId))
			s statuscode=$listget(tmpExamInfo,20)
				;b ;w statuscode
			i ((statuscode="15")!(statuscode="17"))
			{
				s examId=tmpExamId
				s flag=1
				s reqID=tmpReqID
			}
			s tmpExamId=$o(^dbo.tblExaminationI("idxRequestID",tmpReqID,tmpExamId))
		}
		q:(examId'="") 
		s tmpReqID=$o(^dbo.tblRequestI("indexBarcode"," "_OeordId,tmpReqID))
	}
		;b ; w examId
	i ((reqID'="")&&(examId'=""))
	{	
		s requestInfo=^dbo.tblRequestD(reqID)
		q:(requestInfo="")
		s examInfo=^dbo.tblExaminationD(examId)
		q:(examInfo="")
		s status=$li(examInfo,20)
		s ReportState="0"
		i ((status="15")!(status="17")) d
		.s ReportState="1"
		.s Negative=$li(examInfo,30)
		.s Diagnose=$li(examInfo,11)
		.i Diagnose'[$c(10) s Diagnose=Diagnose_$c(10) 
		.s D=""
		.f i=1:1:$l(Diagnose,$c(10)) d
		..s tmpD=$p(Diagnose,$c(10),i)
		..i (tmpD'="") d
		...i (D="") s D=tmpD
		...e  s D=D_","_tmpD
		.s Diagnose=D
		.s ReportTime=$li(examInfo,6)
		.s ReportUserID=$li(examInfo,7)
		.q:((ReportUserID="")!(ReportUserID="0"))
		.s userInfo=$g(^dbo.tblUserD(ReportUserID))
		.q:(userInfo="")
		.s DoctorId=$li(userInfo,8)
		.s DoctorName=$li(userInfo,11)
		.s urlCfgId=$o(^dbo.tblConfigureI("idxKey"," WEBURL",""))
		.q:(urlCfgId="")
		.s urlInfo=^dbo.tblConfigureD(urlCfgId)
		.q:(urlInfo="")
		.s url=$li(urlInfo,6)
		.s ReportUrl=url_"?OID="_OeordId
	}
 	q
 
ERRORSEKGINFO
	Set ErrorMsg=$ZE
	new $NAMESPACE
	zn "DHC-APP"
  	d ##class(web.DHCEkg.Base).Log("ERROR","web.DHCEkg.GetEkgReportState","GetEKGRptInfo",
			$zd($h,3),$zt($p($h,",",2),1),ErrorMsg)
	q "-1^异常"
}

/// Creator：      yangyali
/// CreatDate：    2018-12-19
/// Modify: 	   yangyali
/// ModifyDate：   2020-2-10
/// Description:	通过医嘱号查询心电检查号        
/// Input：        医嘱ID
/// Output：       检查号，"EKG||流水号"的格式
/// w ##class(web.DHCEkg.GetEkgReportState).GetEkgStudyId("370||122")
ClassMethod GetEkgStudyId(OeordId As %String) As %String
{
	s StudyId=##class(web.DHCEkgService).GetStudyNo(OeordId)
	q StudyId
	/*
	new $namespace
	s CurrSpace=$ZNSPACE
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()	
	
	s StudyId=""
	s (reqId,examId)=""
	
	s reqId=$o(^dbo.tblRequestI("indexBarcode"," "_OeordId,reqId))
	i (reqId'="") d
	.s examId=$o(^dbo.tblExaminationI("idxRequestID",reqId,examId))
	.q:(examId="")
	.s examInfo=$g(^dbo.tblExaminationD(examId))
	.q:(examInfo="")
	.s statuscode=$listget(examInfo,20,"")
	.q:(statuscode="")!("11^12^13^14^15^16^17^19^20"'[statuscode) ;状态为空或未做检查
	.s StudyId="EKG||"_OeordId ;与平台接口、PACS接口的检查号保持一致
	
	zn CurrSpace
	
	q StudyId
	*/
}

/// Creator：      yangyali
/// CreatDate：    2019-1-10
/// Modify: 	   
/// ModifyDate：   
/// Description:	通过医嘱号查询心电检查结果是否为阳性       
/// Input：        医嘱ID
/// Output：       Y:阳性;N:阴性
/// w ##class(web.DHCEkg.GetEkgReportState).GetEkgPositive("821||WL0007")
ClassMethod GetEkgPositive(OeordId As %String) As %String
{
	
	new $namespace
	s CurrSpace=$ZNSPACE
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()	
	
	s Positive="N" ;默认阴性
	s (reqId,examId)=""
	
	f  s reqId=$o(^dbo.tblRequestI("indexBarcode"," "_OeordId,reqId)) q:(reqId="")  d
	.s examId=""
	.f  s examId=$o(^dbo.tblExaminationI("idxRequestID",reqId,examId)) q:(examId="")  d
	..s examInfo=$g(^dbo.tblExaminationD(examId))
	..q:(examInfo="")
	..s statuscode=$listget(examInfo,20,"")
	..q:(statuscode'="15")&&(statuscode'="17") ;未审核
	..s ekgNegativePositive=$listget(examInfo,30,"")
	..i (ekgNegativePositive="阳性") s Positive="Y"
	
	zn CurrSpace
	
	q Positive
}

/// Creator：      yangyali
/// CreatDate：    2020-8-5
/// Modify: 	   
/// ModifyDate：   
/// Description:	通过医嘱号查询审核人信息
/// Table：        
/// Input：        医嘱ID
/// Output：       审核人工号^姓名
/// w ##class(web.DHCEkg.GetEkgReportState).GetEKGArbiterUser("105||WL0007")
ClassMethod GetEKGArbiterUser(OeordId As %String) As %String
{
	s ArbiterInfo=""
	s (ArbiterNo,ArbiterName)=""
	new $NAMESPACE
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()	
  	s requestId=""
	s requestId=$o(^dbo.tblRequestI("indexBarcode"," "_OeordId,requestId))
	i (requestId'="")
	{
		s requestInfo=^dbo.tblRequestD(requestId)
		q:(requestInfo="")
		s examId=$o(^dbo.tblExaminationI("idxRequestID",requestId,""))
		q:(examId="")
		s examInfo=^dbo.tblExaminationD(examId)
		q:(examInfo="")
		
		s ArbiterUserID=$li(examInfo,7)
		q:((ArbiterUserID="")!(ArbiterUserID="0"))
		s userInfo=$g(^dbo.tblUserD(ArbiterUserID))
		q:(userInfo="")
		s ArbiterNo=$li(userInfo,8)
		s ArbiterName=$li(userInfo,11)
	}
 	s ArbiterInfo=ArbiterNo_"^"_ArbiterName
 	q ArbiterInfo
}

}
