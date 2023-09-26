/// 检查报告
Class DWR.ORD.BL.RISReport Extends %RegisteredObject
{

/// 查询检查报告
ClassMethod RISReportQry(RtStream As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $ZT="RISReportQryET"
	set pResponse=##Class(DWR.ORD.MSG.RISReportQryRp).%New()

	set reader = ##class(%XML.Reader).%New()
	set sc=reader.OpenStream(RtStream)
	If $$$ISERR(sc) 
	{
		do Output("100","HIS接收到的入参数据格式有误"_sc)
	    Quit RpStream
	}
	Do reader.Correlate("Request","DWR.ORD.MSG.RISReportQryRt")
	if (reader.Next(.pRequest,.sc))
	{   
	}
	if ('$IsObject(pRequest))
	{
		do Output("100","HIS接收到的入参数据格式有误")
	    Quit RpStream
	}
	
	
	set pResponse=..RISReportQryExe(pRequest)
	do Output(pResponse.ResultCode,pResponse.ResultContent)
	
	quit RpStream
	
Output(ResultCode,ResultContent)
	set RpStream=""
	set pResponse.ResultCode=ResultCode
	set pResponse.ResultContent=ResultContent
	set RtStream=##class(%GlobalCharacterStream).%New()
	do pResponse.XMLExportToStream(.RpStream,"Response")
	quit
RISReportQryET
	set pResponse=##Class(DWR.ORD.MSG.RISReportQryRp).%New()
	do Output("-100","HIS端错误："_$ZERROR)
	quit RpStream
}

ClassMethod RISReportQryExe(Rt As DWR.ORD.MSG.RISReportQryRt) As DWR.ORD.MSG.RISReportQryRp
{
	set $ZT="RISReportQryExeET"
	set ResultCode="100"
	set ResultContent="没有查询到检查报告记录"
	set Rp=##Class(DWR.ORD.MSG.RISReportQryRp).%New()
	set EpisodeID=Rt.EpisodeID
	set GroupBy=Rt.GroupBy
	if (EpisodeID="")
	{
		do OutputResult("101","就诊ID不能为空")
	    Quit Rp
	}
	if ('$data(^PAADM(EpisodeID)))
	{
		do OutputResult("106","就诊ID不存在")
    	quit Rp
	}
	
	set OEORDRowID=$order(^OEORD(0,"Adm",EpisodeID,""))
	if (OEORDRowID="")
	{
		do OutputResult("100","没有查询到检查报告记录")
    	quit Rp
	}
	set PatientID=$piece($get(^PAADM(EpisodeID)),"^",1)
	set myJob=$job
	kill ^TMP("DWRRISREPORT",myJob)
	set ChildSub="0"
	while ($order(^OEORD(OEORDRowID,"I",ChildSub))'="")
	{
		set ChildSub=$order(^OEORD(OEORDRowID,"I",ChildSub))
		set OrdItemID=OEORDRowID_"||"_ChildSub
		
		set StatusID=$piece($get(^OEORD(OEORDRowID,"I",ChildSub,1)),"^",13)
		set StatusCode=$piece($get(^OEC("OSTAT",StatusID)),"^",1)
			
		if ((StatusCode'="E")&&(StatusCode'="V")) continue
			
		set RisRegID=$order(^DHCPACRegInfoi("OEORI",OrdItemID,""))
		if (RisRegID="") continue
		
		set StudyID=$piece($get(^DHCPACRegInfo(RisRegID)),"^",2)
		if (StudyID="") continue
			    
		set ResultCode="0",ResultContent="查询成功"
				
		set ArcimRowID=$piece($get(^OEORD(OEORDRowID,"I",ChildSub,1)),"^",2)
		set OrdItemDesc=$piece($get(^ARCIM(+ArcimRowID,$piece(ArcimRowID,"||",2),1)),"^",2)
		set OrdStartDate=$piece($get(^OEORD(OEORDRowID,"I",ChildSub,1)),"^",9)
		
		if (GroupBy="Date")
		{
				set Group1=$ZDate(OrdStartDate,3)
		}
		else
		{
			set Group1=OrdItemDesc
		}
			
		set ^TMP("DWRRISREPORT",myJob,Group1,OrdItemID)=StudyID		
					
	}
	
	set Group1=""
	while($order(^TMP("DWRRISREPORT",myJob,Group1))'="")
	{
		set Group1=$order(^TMP("DWRRISREPORT",myJob,Group1))
		set GroupObj=##Class(DWR.ORD.MSG.RISReportGroup).%New()
		set GroupObj.GroupName=Group1
		set myOrdItemID=""
		while($order(^TMP("DWRRISREPORT",myJob,Group1,myOrdItemID))'="")
		{
			set myOrdItemID=$order(^TMP("DWRRISREPORT",myJob,Group1,myOrdItemID))
			set myStudyID=^TMP("DWRRISREPORT",myJob,Group1,myOrdItemID)
			do OutputRISReport
		}
		do Rp.RISReportGroupList.Insert(GroupObj)
		do GroupObj.%Close()
		
	}
	
	kill ^TMP("DWRLISREPORT",myJob)	
	
	
	do OutputResult(ResultCode,ResultContent)
	quit Rp
	
OutputRISReport
	set RowObj=##Class(DWR.ORD.MSG.RISReport).%New()
	set myrtn=..GetOneRISReport(myOrdItemID,myStudyID,.RowObj)
	if (+myrtn="0")
	{
		set sc=GroupObj.RISReportList.Insert(RowObj)	
					
	}
		do RowObj.%Close()
	quit

OutputResult(ResultCode,ResultContent)
	set Rp.ResultCode=ResultCode
	set Rp.ResultContent=ResultContent
	quit
RISReportQryExeET
	set Rp=##Class(DWR.ORD.MSG.RISReportQryRp).%New()
	do OutputResult("-100","HIS端错误："_$ZERROR)
	quit Rp
}

/// 取一个检查结果报告
ClassMethod GetOneRISReport(OEORIRowID As %String, myStudyID As %String, myRISReportObj As DWR.ORD.MSG.RISReport) As %String
{
	set $ZTrap="GetOneRISReportET"
    
	set rtn="0",ResultContent="查询成功"
	set myRbRowID=$order(^DHCRBStudyi("Report","StudyNo",myStudyID,"0"))
	set myRBObj=##Class(User.DHCRBReport).%OpenId(myRbRowID)
	set PAADMRowID=$piece($get(^OEORD(+OEORIRowID)),"^",1)
	set PatientID=$piece($get(^PAADM(PAADMRowID)),"^",1)
	set PatInfoStr=##Class(DWR.PAT.BL.Patient).GetPatientByRowId(PatientID)
	set RegNo=$piece(PatInfoStr,"^",2)
	set Name=$piece(PatInfoStr,"^",3)
	set Sex=$piece(PatInfoStr,"^",4)
	set Age=$piece(PatInfoStr,"^",5)
	set PaAdmObj=##Class(User.PAAdm).%OpenId(PAADMRowID)
	set AdmDept=PaAdmObj.PAADMDepCodeDR.CTLOCDesc
	if AdmDept["-" set AdmDept=$piece(AdmDept,"-",2)
	set Ward=PaAdmObj.PAADMCurrentWardDR.WARDDesc
	if Ward["-" set Ward=$piece(Ward,"-",2)
	set Bed=PaAdmObj.PAADMCurrentBedDR.BEDCode
	
	set Diagnosis=##Class(DWR.DIA.BL.Diagnosis).GetOneAdmDiagnos(PaAdmObj.PAADMMainMRADMDR.%Id())
	
	set RecLocDr=$piece($get(^OEORD(+OEORIRowID,"I",$piece(OEORIRowID,"||",2),3)),"^",6)
	set ExamLoc=$piece($get(^CTLOC(RecLocDr)),"^",2)
	if ExamLoc["-" set ExamLoc=$piece(ExamLoc,"-",2)
	set ArcimRowID=$piece($get(^OEORD(+OEORIRowID,"I",$piece(OEORIRowID,"||",2),1)),"^",2)
	set ItemCode=$piece($get(^ARCIM(+ArcimRowID,$piece(ArcimRowID,"||",2),1)),"^",1)
	set ItemDesc=$piece($get(^ARCIM(+ArcimRowID,$piece(ArcimRowID,"||",2),1)),"^",2)
	set ReportDoc="",VerifyDoc=""
	if (myRBObj.DRPTReportDocDR'="") set ReportDoc=$piece($get(^CTPCP(myRBObj.DRPTReportDocDR,1)),"^",2)
	if (myRBObj.DRPTVerifyDocDR'="") set VerifyDoc=$piece($get(^CTPCP(myRBObj.DRPTVerifyDocDR,1)),"^",2)
	
	set (ExamDescEx,ResultDescEx,SeeDesc,Memo)=""
	set ExamDescEx=$get(^DHCRBStudy("Report",myRbRowID,"ExamDescEx"))
	set ResultDescEx=$get(^DHCRBStudy("Report",myRbRowID,"ResultDescEx"))
	set ExamDescEx=$translate(ExamDescEx,"_$c_",$char(10))
	set ResultDescEx=$translate(ResultDescEx,"_$c_",$char(10))
	/*
	set myCount=myRBObj.DRPTExamDescEx.Count()
	for i=1:1:myCount
	{
		set myExamstr=myRBObj.DRPTExamDescEx.GetAt(i)
		set ExamDescEx=ExamDescEx_myExamstr
		
	}
	set myCount=myRBObj.DRPTResultDescEx.Count()
	for i=1:1:myCount
	{
		set myResultstr=myRBObj.DRPTResultDescEx.GetAt(i)
		set ResultDescEx=ResultDescEx_myResultstr
		
	}
	set myCount=myRBObj.DRPTSeeDesc.Count()
	for i=1:1:myCount
	{
		set mySeeDescstr=myRBObj.DRPTSeeDesc.GetAt(i)
		set SeeDesc=SeeDesc_mySeeDescstr
		
	}
	set myCount=myRBObj.DRPTMemo.Count()
	for i=1:1:myCount
	{
		set myMemostr=myRBObj.DRPTMemo.GetAt(i)
		set Memo=Memo_myMemostr
		
	}
	*/
	set RISReportURL=##Class(web.DHCRisBrowseExamResult).GetReportBrowseURL(OEORIRowID)
	set RISImageURL=##Class(web.DHCRisBrowseExamResult).GetImageBrowseURL(OEORIRowID)
	
	set myRISReportObj.ReportTitle1=..GetLocalHospital()
	set myRISReportObj.ReportTitle2="检查报告单"
	set myRISReportObj.Name=Name
	set myRISReportObj.Sex=Sex
	set myRISReportObj.Age=Age
	set myRISReportObj.RegNo=RegNo
	set myRISReportObj.AdmDept=AdmDept
	set myRISReportObj.Ward=Ward
	set myRISReportObj.Bed=Bed
	set myRISReportObj.StudyID=myStudyID
	set myRISReportObj.Diagnosis=Diagnosis
	set myRISReportObj.Resource=""
	set myRISReportObj.ExamLoc=ExamLoc
	set myRISReportObj.ItemName=ItemDesc
	set myRISReportObj.ExamDescEx=ExamDescEx
	set myRISReportObj.ResultDescEx=ResultDescEx
	set myRISReportObj.SeeDesc=SeeDesc
	set myRISReportObj.Memo=Memo
	set myRISReportObj.ReportDate=myRBObj.DRPTReportDate
	set myRISReportObj.ReportUser=ReportDoc
	set myRISReportObj.VerifyDate=myRBObj.DRPTVerifyDate
	set myRISReportObj.VerifyUser=VerifyDoc
	set myRISReportObj.RISReportURL=RISReportURL
	set myRISReportObj.RISImageURL=RISImageURL
	
	do myRBObj.%Close()
	do PaAdmObj.%Close()
	quit rtn_"^"_ResultContent
	
GetOneRISReportET
    quit "-1"_"^"_$ZERROR
}

/// 取本地的医院名称
ClassMethod GetLocalHospital() As %String
{
	set Hospital=""
	set myHospitalID=$order(^CT("HOSP","0"))
	if myHospitalID="" quit Hospital
	set Hospital=$piece($get(^CT("HOSP",myHospitalID)),"^",2)
	quit Hospital
}

}
