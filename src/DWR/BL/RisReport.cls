Class DWR.BL.RisReport Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##Class(DWR.BL.RisReport).GetRisReportList()
ClassMethod GetRisReportList(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><admId>99948</admId></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","DWR.MSG.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	}
	q:($G(admId)="") "201^就诊号不能为空!"
	s oderRowId=$order(^OEORD(0,"Adm",admId,""))
	q:oderRowId="" ""
	s orderSubRowId=""
	f  s orderSubRowId=$O(^OEORD(oderRowId,"I",orderSubRowId)) q:orderSubRowId=""  d
    .s ordItemId=oderRowId_"||"_orderSubRowId
    .s priorDr=$P($G(^OEORD(oderRowId,"I",orderSubRowId,1)),"^",8)
    .q:priorDr=""
	.s ordDate=$P($G(^OEORD(oderRowId,"I",orderSubRowId,1)),"^",9)
	.s ordTime=$P($G(^OEORD(oderRowId,"I",orderSubRowId,1)),"^",10)
	.i ordTime="" s ordTime=$P($H,",",2)
    .s priorDes=$P($G(^OECPR(priorDr)),"^",2)
	.s priorCode=$P($G(^OECPR(priorDr)),"^",1)
	.s ordStatDr=$P($G(^OEORD(oderRowId,"I",orderSubRowId,1)),"^",13) 
	.s ordStatus=""
	.i ordStatDr'="" s ordStatus=$P(^OEC("OSTAT",ordStatDr),"^",2)
	.q:(ordStatus="停止")||(ordStatus="未激活")||(ordStatus="未审核")||(ordStatus="撤消")
	.s doctorDr=$P($G(^OEORD(oderRowId,"I",orderSubRowId,1)),"^",11)
 	.s arcimId=$p(^OEORD(oderRowId,"I",orderSubRowId,1),"^",2)
 	.s serverMaterial=$p($g(^ARCIM($p(arcimId,"||",1),$p(arcimId,"||",2),7)),"^",6)
	.q:serverMaterial'="S"
	.s ordItemDesc=$P($G(^ARCIM($p(arcimId,"||",1),$p(arcimId,"||",2),1)),"^",2)  
	.s CpTypDR=""
    .i doctorDr'="" s CpTypDR=$P(^CTPCP(doctorDr,1),"^",4)
	.q:CpTypDR=""
	.q:'$D(^CT("CPT",CpTypDR))
	.i $G(CpTypDR)'="" s CpTyp=$P(^CT("CPT",CpTypDR),"^",4)
	.q:CpTyp'="DOCTOR"
	.s ordStartDate=$P($G(^OEORD(oderRowId,"I",orderSubRowId,1)),"^",9)
	.s ordStartDate=$ZD(ordStartDate,3)
	.s ordStartTime=$P($G(^OEORD(oderRowId,"I",orderSubRowId,1)),"^",9)
	.s ordStartTime=$ZT(ordStartTime)
	.s execDate=$P($G(^OEORD(oderRowId,"I",orderSubRowId,6)),"^",2)         // OEORI_DateExecuted
	.//s execTime=$P($G(^OEORD(oderRowId,"I",orderSubRowId,11)),"^",5)      // OEORI_UpdateTime
	.s execTime=$P($G(^OEORD(oderRowId,"I",orderSubRowId,6)),"^",3)         // OEORI_TimeExecuted
    .i +execDate>0 s execDate=$zd(execDate,3)
    .i +execTime>0 s execTime=$zt(execTime)
	.//s execCtcpDR=$P(^OEORD(oderRowId,"I",orderSubRowId,8),"^",12)        // OEORI_UserUpdate
	.s execCtcpDR=$P($G(^OEORD(oderRowId,"I",orderSubRowId,6)),"^",4)       // OEORI_UserExecuted
	.i execCtcpDR'="" s execCtcpDesc=$P($G(^SSU("SSUSR",execCtcpDR)),"^",2)
	.e  s execCtcpDesc=""
	.s risRegId=$O(^DHCPACRegInfoi("OEORI",ordItemId,""))
	.q:risRegId=""
	.s studyId=$P($G(^DHCPACRegInfo(risRegId)),"^",2)
	.q:studyId=""
	.s recDeparmentDr=$P($G(^OEORD(oderRowId,"I",orderSubRowId,3)),"^",6)
	.i recDeparmentDr'="" s recDeparment=$p($g(^CTLOC(recDeparmentDr)),"^",2)
	.e  s recDeparment=""
	.s reportRowId=$O(^DHCRBStudyi("Report","StudyNo",studyId,"0"))
	.i reportRowId'="" d
	..s reportObj=##Class(User.DHCRBReport).%OpenId(reportRowId)
	..s reportStatus=reportObj.DRPTStatusDR.DRSDesc
	..i reportObj.DRPTReportDocDR'="" s reportUser=$P($G(^CTPCP(reportObj.DRPTReportDocDR,1)),"^",2)
	..i reportObj.DRPTReportDate'="" d
	...s reportDate=reportObj.DRPTReportDate
	...i +reportDate>0 s reportDate=$ZDT(reportDate,3)
	..i reportObj.DRPTReportTime'="" d
	...s reportTime=reportObj.DRPTReportTime
	...i +reportTime>0 s reportTime=$ZT(reportTime)
	..d reportObj.%Close()
	.s myobj=##class(DWR.MSG.RisReportList).%New()
	.s myobj.ordItemId=ordItemId
	.s myobj.ordItemDesc=ordItemDesc
	.s myobj.ordStatus=ordStatus
	.s myobj.ordDate=ordStartDate
	.s myobj.ordTime=ordStartTime
	.s myobj.risRegId=risRegId
	.s myobj.studyId=studyId
	.i $G(reportStatus)="" s reportStatus=""
	.s myobj.reportStatus=reportStatus
	.i $G(reportUser)="" s reportUser=""
	.s myobj.reportUser=reportUser
	.i $G(reportDate)="" s reportDate=""
	.s myobj.reportDate=reportDate
	.i $G(reportTime)="" s reportTime=""
	.s myobj.reportTime=reportTime
	.d myobj.%Close()
	.s Xml=""
	.s ret=myobj.XMLExportToString(.Xml,"RisReportList")
	.i ret=1 s retStr=retStr_Xml
	q retStr
}

/// 取一个检查结果报告
/// w ##Class(DWR.BL.RisReport).GetRisReport()
ClassMethod GetRisReport(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><admId>99948</admId><studyId>300587981</studyId></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","DWR.MSG.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	   s studyId=request.studyId
	   s studyId=$TR(studyId,$C(0))
	}
	q:($G(admId)="") "201^就诊号不能为空!"
	q:($G(studyId)="") "202^检查Id不存在!"
	s risRegId=$O(^DHCPACRegInfoi("StudyNo",studyId,0))
	q:risRegId="" "203^检查报告不存在!"
	//s reportRowId=$O(^DHCRBStudyi("Report","StudyNo",studyId,"0"))
	s reportRowId=$O(^DHCRBStudyi("ReportRegDR",risRegId,"0"))
	q:reportRowId="" "203^检查报告不存在!"
	s reportObj=##Class(User.DHCRBReport).%OpenId(reportRowId)
	s ordItemId=reportObj.DRPTOeordItmDR
	q:ordItemId="" "203^检查报告不存在!"
	s studyNo=reportObj.DRPTStudyNo
	s patientId=$P($G(^PAADM(admId)),"^",1)
	s patInfoStr=##Class(MHC.BI.Common).PatInfo("^"_admId)
	s regNo=$P(patInfoStr,"^",1)
	s patName=$P(patInfoStr,"^",5)
	s sex=$P(patInfoStr,"^",4)
	s age=$P(patInfoStr,"^",8)
	s wardDesc=$P(patInfoStr,"^",9)
	s bedCode=$P(patInfoStr,"^",7)
	s admDept=$P(patInfoStr,"^",2)
	s diagnosis=$P(patInfoStr,"^",14)
	s diagnosis=..GetOneAdmDiagnos(admId)
	
	s recLocDr=$P($G(^OEORD(+ordItemId,"I",$P(ordItemId,"||",2),3)),"^",6)
	i recLocDr'="" s examDept=$P($G(^CTLOC(recLocDr)),"^",2)
	e  s examDept=""
	i examDept["-" s examDept=$P(examDept,"-",2)
	s arcimRowId=$P($G(^OEORD(+ordItemId,"I",$P(ordItemId,"||",2),1)),"^",2)
	s itemCode=$P($G(^ARCIM(+arcimRowId,$P(arcimRowId,"||",2),1)),"^",1)
	s itemDesc=$P($G(^ARCIM(+arcimRowId,$P(arcimRowId,"||",2),1)),"^",2)
	s reportDoc="",verifyDoc="",reportDate="",reportTime="",verifyDate="",verifyTime=""
	i reportObj.DRPTReportDocDR'="" s reportDoc=$P($G(^CTPCP(reportObj.DRPTReportDocDR,1)),"^",2)
	i reportObj.DRPTVerifyDocDR'="" s verifyDoc=$P($G(^CTPCP(reportObj.DRPTVerifyDocDR,1)),"^",2)
	i reportObj.DRPTReportDate'="" s reportDate=reportObj.DRPTReportDate
	i reportObj.DRPTReportTime'="" s reportTime=reportObj.DRPTReportTime
	i reportObj.DRPTVerifyDate'="" s verifyDate=reportObj.DRPTReportDate
	i reportObj.DRPTVerifyTime'="" s verifyTime=reportObj.DRPTReportTime
	s examDescEx=$G(^DHCRBStudy("Report",reportRowId,"ExamDescEx"))
	s resultDescEx=$G(^DHCRBStudy("Report",reportRowId,"ResultDescEx"))
	s examDescEx=$TR(examDescEx,"_$c_",$char(10))
	s resultDescEx=$TR(resultDescEx,"_$c_",$char(10))
	s memoEx=$G(^DHCRBStudy("Report",reportRowId,"MemoEx"))
	s seeDescEx=$G(^DHCRBStudy("Report",reportRowId,"SeeDescEx"))	
	s reportURL=##Class(web.DHCRisBrowseExamResult).GetReportBrowseURL(ordItemId)
	s imageURL=##Class(web.DHCRisBrowseExamResult).GetImageBrowseURL(ordItemId)
	i $G(^DHCDWRSET("Image","Browse"))="DICOM" d
	.s imageURL=studyId
	.s imageURL=$P(imageURL,$TR(ordItemId,"||"))
	.s imageURL="DICOM:"_imageURL
	i $G(^DHCDWRSET("Image","Browse"))="INFINITT" d
	.s imageURL=studyId
	.s imageURL=$P(imageURL,$TR(ordItemId,"||"))
	.s imageURL="INFINITT:"_imageURL
	i $G(^DHCDWRSET("Image","Browse"))="AGFA" d
	.s imageURL=studyId
	.s imageURL=$P(imageURL,$TR(ordItemId,"||"))
	.s imageURL="AGFA:patientID="_patientId_"&accessionNumber="_imageURL
	d reportObj.%Close()
	s myObj=##class(DWR.MSG.RisReport).%New()
	s myObj.reportMainTitle=..GetLocalHospital()
	s myObj.reportSubTitle="检查报告单"
	s myObj.patName=patName
	s myObj.sex=sex
	s myObj.age=age
	s myObj.regNo=regNo
	s myObj.admDept=admDept
	s myObj.wardDesc=wardDesc
	s myObj.bedCode=bedCode
	s myObj.studyId=studyId
	s myObj.diagnosis=diagnosis
	s myObj.examDept=examDept
	s myObj.itemCode=itemCode
	s myObj.itemDesc=itemDesc
	s myObj.examDescEx=examDescEx
	s myObj.resultDescEx=resultDescEx
	s myObj.memoEx=memoEx         //检查备注
	s myObj.seeDescEx=seeDescEx   //检查所见
	i +reportDate>0 d
	.s reportDate=$ZDT(reportDate,3)
	.i +reportTime>0 s reportDate=reportDate_" "_$ZT(reportTime)
	s myObj.reportDate=reportDate
	s myObj.reportDoc=reportDoc
	i +verifyDate>0 d
	.s verifyDate=$ZDT(verifyDate,3)
	.i +verifyTime>0 s verifyDate=verifyDate_" "_$ZT(verifyTime)
	s myObj.verifyDate=verifyDate
	s myObj.verifyDoc=verifyDoc
	s myObj.reportURL=reportURL
	s myObj.imageURL=imageURL
	s ret=myObj.XMLExportToString(.Xml,"RisReport")
	i ret=1 s retStr=Xml
	d myObj.%Close()
	q retStr
}

/// /获取Pacs DICOM 图像浏览参数
/// w ##Class(DWR.BL.RisReport).GetPacsView()
ClassMethod GetPacsView(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><admId>99948</admId><studyId>300587981</studyId><padIP>192.168.0.1</padIP></Request>"
    s Param=$TR(Param,$C(10))
    s reader=##class(%XML.Reader).%New()
    s sc=reader.OpenString(Param)
    // s sc=reader.OpenStream(objStream)
    d reader.Correlate("Request","DWR.MSG.Request")
    //Do reader.Rewind()
	While reader.Next(.request,.sc)
	{
	   s admId=request.admId
	   s admId=$TR(admId,$C(0))
	   s studyId=request.studyId
	   s studyId=$TR(studyId,$C(0))
	   s padIP=request.padIP
	   s padIP=$TR(padIP,$C(0))
	}
	q:($G(admId)="") "201^就诊号不能为空!"
	q:($G(studyId)="") "202^检查Id不存在!"
	s reportRowId=$O(^DHCRBStudyi("Report","StudyNo",studyId,"0"))
	//q:reportRowId="" "203^检查报告不存在!"
	i $G(^DHCDWRSET("Image","Browse"))="DICOM" d
	.s imageURL=studyId
	.//s imageURL=$P(imageURL,$TR(ordItemId,"||"))

	s myObj=##class(DWR.MSG.PacsView).%New()
	s myObj.localAETitle="IPAD"
	i $G(^DHCDWRSET("DICOM","localAETitle"))'="" s myObj.localAETitle=^DHCDWRSET("DICOM","localAETitle")
	i padIP'="" d
	.s myObj.localAETitle=myObj.localAETitle_$P(padIP,".",3)_"D"_$P(padIP,".",4)
	s myObj.localPort=105
	i $G(^DHCDWRSET("DICOM","localPort"))'="" s myObj.localPort=^DHCDWRSET("DICOM","localPort")
	s myObj.localSyntax="Explicit Little Endian"
	i $G(^DHCDWRSET("DICOM","localSyntax"))'="" s myObj.localSyntax=^DHCDWRSET("DICOM","localSyntax")
	s myObj.serverDesc="GEPACS"
	i $G(^DHCDWRSET("DICOM","serverDesc"))'="" s myObj.serverDesc=^DHCDWRSET("DICOM","serverDesc")
	s myObj.serverAETitle="GEPACS"
	i $G(^DHCDWRSET("DICOM","serverAETitle")) s myObj.serverAETitle=^DHCDWRSET("DICOM","serverAETitle")
	s myObj.serverAddress="172.23.6.114"
	i $G(^DHCDWRSET("DICOM","serverAddress"))'="" s myObj.serverAddress=^DHCDWRSET("DICOM","serverAddress")
	s myObj.serverPort=4100
	i $G(^DHCDWRSET("DICOM","serverPort"))'="" s myObj.serverPort=^DHCDWRSET("DICOM","serverPort")
	s myObj.serverRetrieve="C-MOVE"
	i $G(^DHCDWRSET("DICOM","serverRetrieve"))'="" s myObj.serverRetrieve=^DHCDWRSET("DICOM","serverRetrieve")
	s myObj.serverTLS="N"
	i $G(^DHCDWRSET("DICOM","serverTLS"))'="" s myObj.serverTLS=^DHCDWRSET("DICOM","serverTLS")
	s myObj.serverSyntax="Implicit Little Endian"
	i $G(^DHCDWRSET("DICOM","serverSyntax"))'="" s myObj.serverSyntax=^DHCDWRSET("DICOM","serverSyntax")
	s myObj.patId=""
	s myObj.accNum=studyId
	s ret=myObj.XMLExportToString(.Xml)
	i ret=1 s retStr=Xml
	d myObj.%Close()
	q retStr
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

/// 取一次就诊的诊断信息	
/// /w ##Class(DWR.BL.RisReport).GetOneAdmDiagnos(99948)
ClassMethod GetOneAdmDiagnos(admId As %String = "") As %String
{
	q:admId="" ""
	s mrAdmId=$P($G(^PAADM(admId)),"^",61)
	q:mrAdmId="" ""
	s disRetStr=""
	s childSub=""
	f  s childSub=$O(^MR(mrAdmId,"DIA",childSub)) q:childSub=""  d
	.q:+childSub=0
	.s diaICDId=$P($G(^MR(mrAdmId,"DIA",childSub)),"^",1)
	.i diaICDId'="" s diaDesc=$P($G(^MRC("ID",diaICDId)),"^",2)
	.e  s diaDesc=""
	.s diaNote=""
	.s mrDiaNoteId=""
	.f  s mrDiaNoteId=$O(^MR(mrAdmId,"DIA",childSub,"DES",mrDiaNoteId)) q:mrDiaNoteId=""  d
	..q:mrDiaNoteId=0
	..s mrDiaNote=$G(^MR(mrAdmId,"DIA",childSub,"DES",mrDiaNoteId))
	..s mrDiaNote=$TR(mrDiaNote," ")
	..q:mrDiaNote=""
	..i diaNote="" s diaNote=mrDiaNote
	..e  s diaNote=diaNote_","_mrDiaNote
	.i disRetStr="" d
	..i diaNote'="" s disRetStr=diaDesc_":"_diaNote
	..e  s disRetStr=diaDesc
	.e  d
	..i diaNote'="" s disRetStr=disRetStr_","_diaDesc_":"_diaNote
	..e  s disRetStr=disRetStr_","_diaDesc
	q disRetStr
}

}
