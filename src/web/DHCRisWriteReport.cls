Import SQLUser

Class web.DHCRisWriteReport Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 函数功能:获得病人基本信息和检查信息
/// 函数名称:QueryStudyReportInfo
/// 函数入参:Info=检查号^医嘱ID
/// 作者:sunyi
/// 日期:2011-09-22
/// w ##class(web.DHCRisWriteReport).QueryStudyReportInfo("U20120606-001^75880||72") 
ClassMethod QueryStudyReportInfo(Info As %String) As %String
{
	 s (StudyNo,OrdItemID,OeordRowid,Paadmdr,PatientInfo,RegNo,Name,Age,Sex)=""
	 s (wardname,bedname,returnInfos,StudyInfo,ExamDesc,ResultDesc,ExamMethod,ReportDoc,RptDate,RptTime)=""
	 s (VerifyDoc,VerifyDate,VerifyTime)=""
	 
	 s StudyNo=$p(Info,"^",1)
	 s OrdItemID=$p(Info,"^",2)
	 
	 i (OrdItemID'="")
	 {
		s OeordRowid=$p(OrdItemID,"||",1)
		i OeordRowid'="" s Paadmdr=$p(^OEORD(OeordRowid),"^",1)
		i Paadmdr'="" s PatientInfo=##class(web.DHCRisCommFunctionEx).GetPaadmInfo(Paadmdr)
	  	i (PatientInfo'="")
	  	{
		  	s RegNo=$p(PatientInfo,"^",1)
		  	s Name=$p(PatientInfo,"^",2)
		  	s Age=$p(PatientInfo,"^",4)
		  	s Sex=$p(PatientInfo,"^",5)
		  	s wardname=$p(PatientInfo,"^",10)
		  	s bedname=$p(PatientInfo,"^",11)	
		}
		
	 }
	 
	 i (StudyNo'="")
	 {
		s StudyInfo=..QueryInfobyStudyNo(StudyNo)
		i (StudyInfo'="")
		 {
			s ExamDesc=$p($g(StudyInfo),"^",2)
			s ResultDesc=$p($g(StudyInfo),"^",3)
			s ExamMethod=$p($g(StudyInfo),"^",7)
			s ReportDoc=$p($g(StudyInfo),"^",5)
			s RptDate=$p($g(StudyInfo),"^",9)
			s RptTime=$p($g(StudyInfo),"^",10)
			s VerifyDoc=$p($g(StudyInfo),"^",11)
			s VerifyDate=$p($g(StudyInfo),"^",12)
			s VerifyTime=$p($g(StudyInfo),"^",13)
		 } 
		 s returnInfos=RegNo_"^"_Name_"^"_Age_"^"_Sex_"^"_wardname_"^"_bedname_"^"_ExamDesc_"^"_ResultDesc_"^"_ExamMethod_"^"_ReportDoc_"^"_RptDate_"^"_RptTime_"^"_StudyNo_"^"_VerifyDoc_"^"_VerifyDate_"^"_VerifyTime	 
	 }
	 
	 q returnInfos
}

ClassMethod QueryInfobyStudyNo(StudyNo As %String) As %String
{
	s (resInfo,rowid,VerifyDoc,ReportDoc,RptTime,VerifyTime)=""
	s rowid=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,""),-1)
	i (rowid'="")
	{
		s ExamDesc=$p(^DHCRBStudy("Report",rowid),"^",5)
		s ResultDesc=$p(^DHCRBStudy("Report",rowid),"^",6)
		s Result=$p(^DHCRBStudy("Report",rowid),"^",7)
		s ReportDocDR=$p(^DHCRBStudy("Report",rowid),"^",8)
		i ReportDocDR'="" s ReportDoc=$p($g(^SSU("SSUSR",ReportDocDR)),"^",2)
		s RptDate=$p($g(^DHCRBStudy("Report",rowid)),"^",9)
        i RptDate'="" s RptDate=$zd(RptDate,3)
        s RptTime=$p($g(^DHCRBStudy("Report",rowid)),"^",10)
        i RptTime'="" s RptTime=$zt(RptTime,3)
		s VerifyDocDR=$p(^DHCRBStudy("Report",rowid),"^",11)
		i VerifyDocDR'="" s VerifyDoc=$p($g(^SSU("SSUSR",VerifyDocDR)),"^",2)
		s VerifyDate=$p($g(^DHCRBStudy("Report",rowid)),"^",12)
	    i VerifyDate'="" s VerifyDate=$zd(VerifyDate,3) 
	    s VerifyTime=$p($g(^DHCRBStudy("Report",rowid)),"^",13)
	    i VerifyTime'="" s VerifyTime=$zt(VerifyTime,3)
		s ExamMethod=$p(^DHCRBStudy("Report",rowid),"^",24)
		s Typist = $p(^DHCRBStudy("Report",rowid),"^",26) //录入者 20080610
		s strExam="",strResult="",strRptMemo=""
		i $g(^DHCRBStudy("Report",rowid,"ExamDescEx"))'= "" d
		.s ExamDesc=^DHCRBStudy("Report",rowid,"ExamDescEx")
		.s ExamDesc=..ChangeRportInfo(ExamDesc)
	    i $g(^DHCRBStudy("Report",rowid,"ResultDescEx"))'= "" d
		.s strResult=^DHCRBStudy("Report",rowid,"ResultDescEx")
		.s strResult=..ChangeRportInfo(strResult)
		i $g(^DHCRBStudy("Report",rowid,"MemoEx"))'= "" d
		.s strRptMemo=^DHCRBStudy("Report",rowid,"MemoEx")
		i strResult'="" s ResultDesc=strResult
		s resInfo = rowid_"^"_ExamDesc_"^"_ResultDesc_"^"_Result_"^"_ReportDoc_"^"_strRptMemo_"^"_ExamMethod_"^"_Typist_"^"_RptDate_"^"_RptTime_"^"_VerifyDoc_"^"_VerifyDate_"^"_VerifyTime
	}
	q resInfo
}

/// 函数功能:设置病人检查报告信息
/// 函数名称:SetReportData
/// 函数入参:Info=检查号^医嘱ID
/// 作者:sunyi
/// 日期:2011-09-22
/// d ##class(web.DHCRisWriteReport).SetReportData("","E")
ClassMethod SetReportData(Info As %String(MAXLEN=65535), Oper As %String) As %String
{
	 //s Info="U20110922-001^1^1^3^双肺野透亮度正常?血管纹理清晰?肺内未见异常密度区?心脏及大血管影在正常范围?心脏各弓形态正常?心胸比值50%?膈肌光滑?肋膈角锐利^正常心脏sunyi^Y^457^36677||3042"
	 s StudyNo=$p(Info,"^",1)
	 s ReportID=$p(Info,"^",2)
	 s Version=$p(Info,"^",3)
	 s StatusDR=$p(Info,"^",4)
	 s ExamDesc=$p(Info,"^",5)
	 s ResultDesc=$p(Info,"^",6)
	 s Result=$p(Info,"^",7)
	 s ReportDocDR=$p(Info,"^",8)
	 s ReportDate=+$h
	 s ReportTime=$p($h,",",2)
	 s OeordItmDR=$p(Info,"^",9)
	 s VerifyDocDR=$p(Info,"^",10)
     s VerifyDate=+$h
     s VerifyTime=$p($h,",",2)
 
	 
	 
	 s regrowid="" 
	 s rptrowid=""
	 if $g(StudyNo)'="" d
	 .s regrowid=$o(^DHCPACRegInfoi("StudyNo",StudyNo,0))
	 q:regrowid="" 100 //如果登记表为空 不让写入报告 按病理号 
	 
	 s Status = $P($g(^DHCRBCStatus("ReportStatus",StatusDR)),"^",1)
 
	 s bWrite=0
	 &sql(select count(*) into:bWrite from DHCRB_Report where ((DRPT_ReportID=:ReportID) and (DRPT_StudyNo=:StudyNo)))
	 i ((Oper="I")&(bWrite'=0))  s Oper="E"
	 
	 // 插入
	 i Oper="I" d
	 .&sql(insert into DHCRB_Report(DRPT_StudyNo,DRPT_ReportID,DRPT_Version,DRPT_Status_DR,DRPT_Result,DRPT_ReportDoc_DR,DRPT_ReportDate,DRPT_ReportTime,DRPT_OeordItm_DR)
	       values (:StudyNo,:ReportID,:Version,:StatusDR,:Result,:ReportDocDR,:ReportDate,:ReportTime,:OeordItmDR))
	 .s rptrowid=$p(%ROWID,$c(1))
	 .i rptrowid'="" d
	 ..s ^DHCRBStudy("Report",rptrowid,"ExamDescEx")=ExamDesc
	 ..s ^DHCRBStudy("Report",rptrowid,"ResultDescEx")=ResultDesc
	 ..;s ^DHCRBStudy("Report",rptrowid,"MemoEx")=RptMemo
	 ..d ##class(web.DHCRisCommFunctionEx).UpdateOrdStatus(ReportDocDR,StudyNo,"E")
	 
	 // 修改已经保存的报告，但不审核
 
	 i Oper="E" d
	 .&sql(update  DHCRB_Report (DRPT_Version,DRPT_Status_DR,DRPT_Result,DRPT_ReportDoc_DR,DRPT_ReportDate,DRPT_ReportTime,DRPT_OeordItm_DR)
	       values (:Version,:StatusDR,:Result,:ReportDocDR,:ReportDate,:ReportTime,:OeordItmDR) where ((DRPT_ReportID=:ReportID) and (DRPT_StudyNo=:StudyNo)))
	 .s rptrowid=$p($g(%ROWID),$c(1))
	 .i rptrowid'="" d
	 ..s ^DHCRBStudy("Report",rptrowid,"ExamDescEx")=ExamDesc
	 ..s ^DHCRBStudy("Report",rptrowid,"ResultDescEx")=ResultDesc
	 ..;s ^DHCRBStudy("Report",rptrowid,"MemoEx")=RptMemo
	 ..d ##class(web.DHCRisCommFunctionEx).UpdateOrdStatus(ReportDocDR,StudyNo,"E")
	 
	 // 审核报告
	 i Oper="V" d
	 .&sql(update  DHCRB_Report (DRPT_Version,DRPT_Status_DR,DRPT_Result,DRPT_VerifyDoc_DR,DRPT_VerifyDate,DRPT_VerifyTime,DRPT_OeordItm_DR)
	       values (:Version,:StatusDR,:Result,:VerifyDocDR,:VerifyDate,:VerifyTime,:OeordItmDR) where ((DRPT_ReportID=:ReportID) and (DRPT_StudyNo=:StudyNo)))
	 .s rptrowid=$p(%ROWID,$c(1))
	 .i rptrowid'="" d
	 ..s ^DHCRBStudy("Report",rptrowid,"ExamDescEx")=ExamDesc
	 ..s ^DHCRBStudy("Report",rptrowid,"ResultDescEx")=ResultDesc
	 ..;s ^DHCRBStudy("Report",rptrowid,"MemoEx")=RptMemo
	 ..d ##class(web.DHCRisCommFunctionEx).UpdateOrdStatus(VerifyDocDR,StudyNo,"V")
	 
	 q SQLCODE
}

/// w ##class(web.DHCRisWriteReport).GetStudyNo("55918||1711")
ClassMethod GetStudyNo(OrdItemID As %String) As %String
{
	q:(OrdItemID="") ""
	s StudyNo=""
	
	s Rowid=$o(^DHCPACRegInfoi("OEORI",OrdItemID,0))
	i Rowid'="" d
	.s StudyNo=$p($g(^DHCPACRegInfo(Rowid)),"^",2)
	q StudyNo
}

/// 对\n(_$c(13,10)_)和\r(_$c_)分别进行了16进制的转义，变为\X000a\和\X000b\
ClassMethod ChangeRportInfo(Param) As %String
{
     
     s Info=""
     s Info=Param
     s Info=..Replace(Info,"_$c_","X000b")
     s Info=..Replace(Info,"_$c(13,10)_","X000a")
     q Info
}

/// w ##class(web.DHCRisWriteReport).Replace("abcdefghijklmn&KeyEnter;opqrstuvwxyz","&KeyEnter;","\n")
ClassMethod Replace(Strings, Str, Rep) As %String [ Language = basic ]
{
	   
	   return Replace(Strings,Str,Rep)
}

/// w ##class(web.DHCRisWriteReport).GetRptStatusbyCode("R")
ClassMethod GetRptStatusbyCode(Code As %String) As %String
{
	s StatusDR=""
	
	if (Code'="") 
	{
		s StatusDR=$o(^DHCRBCStatusi("RCode",Code,""))
	}

	q StatusDR
}

}
