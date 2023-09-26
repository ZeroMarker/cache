Class DWR.BL.LisReport Extends (%RegisteredObject, %XML.Adaptor)
{

/// w ##Class(DWR.BL.LisReport).GetLisReportList(Param)
ClassMethod GetLisReportList(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><admId>24</admId></Request>"
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
	s Config=##Class(websys.Configuration).%OpenId(1)
   	s MEDDATA=Config.DataNamespace
   	//s LABDATA=Config.LabDataNamespace
   	d Config.%Close()
	s oderRowId=$order(^OEORD(0,"Adm",admId,""))
	q:oderRowId="" "202^没有检验医嘱信息!"
	s patientId=$P($get(^PAADM(admId)),"^",1)
	s ordChildSub=""
	f  s ordChildSub=$O(^OEORDi(0,"FLabResult",oderRowId,ordChildSub)) q:ordChildSub=""  d
	.s ordItemId=oderRowId_"||"_ordChildSub
	.s statusId=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",13)
	.s statusCode=$P($G(^OEC("OSTAT",statusId)),"^",1)
	.s ordStatus=$P($G(^OEC("OSTAT",statusId)),"^",2)
	.q:((statusCode'="E")&&(statusCode'="V"))
	.q:(ordStatus="停止")||(ordStatus="未激活")||(ordStatus="未审核")||(ordStatus="撤消")
	.s arcimRowId=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",2)
	.s arcSubCatDr=$P($G(^ARCIM(+arcimRowId,$P(arcimRowId,"||",2),1)),"^",10)
	.q:arcSubCatDr=""
	.s arcCatType=$piece($get(^ARC("IC",arcSubCatDr)),"^",7)
	.q:arcCatType'="L"
	.s ordLabNo=$P($G(^OEORD(oderRowId,"I",ordChildSub,3)),"^",20)
	.q:ordLabNo=""
    .s arcExCode=..GetExCode(arcimRowId)
    .q:arcExCode=""
    .s labRelatId=$P($G(^OEORD(oderRowId,"I",ordChildSub,3)),"^",35)
	.s DWRLisReport(arcimRowId,ordLabNo,ordItemId)=labRelatId
	.s DWRLisReportArc(arcimRowId)=+$G(DWRLisReportArc(arcimRowId))+1
	.s DWRLisReportLab(ordLabNo,arcimRowId)=ordItemId
	.s DWRLisReportLab(ordLabNo)=+$G(DWRLisReportLab(ordLabNo))+1

	s ordIndex=0
	s arcimRowId="" f  s arcimRowId=$O(DWRLisReport(arcimRowId)) q:arcimRowId=""  d
	.s ordLabNo=""  f  s ordLabNo=$O(DWRLisReport(arcimRowId,ordLabNo)) q:ordLabNo=""  d
	..s ordItemId=""  f ordItemId=$O(DWRLisReport(arcimRowId,ordLabNo,ordItemId)) q:ordItemId=""  d
	...s labRelatId=DWRLisReport(arcimRowId,ordLabNo,ordItemId)
	...s oderRowId=$P(ordItemId,"||")
	...s ordChildSub=$P(ordItemId,"||",2)
	...s statusId=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",13)
	...s statusCode=$P($G(^OEC("OSTAT",statusId)),"^",1)
	...s ordStatus=$P($G(^OEC("OSTAT",statusId)),"^",2)
	...s arcimRowId=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",2)
	...s recDeparmentDr=$P($G(^OEORD(oderRowId,"I",ordChildSub,3)),"^",6)
	...i recDeparmentDr'="" s recDeparment=$p($g(^CTLOC(recDeparmentDr)),"^",2)
	...e  s recDeparment=""
	...i $P(recDeparment,"-",2)'="" s recDeparment=$P(recDeparment,"-",2)	
	...s ordItemDesc=$P($G(^ARCIM(+arcimRowId,$P(arcimRowId,"||",2),1)),"^",2)
	...////同一个标本号,并且没有可对比的历史数据时,合并显示
	...i DWRLisReportArc(arcimRowId)<2 d
	....s testArcimRowId=""
	....f  s testArcimRowId=$O(DWRLisReportLab(ordLabNo,testArcimRowId)) q:testArcimRowId=""  d
	.....q:testArcimRowId=arcimRowId
	.....i DWRLisReportArc(testArcimRowId)<2 d
	......s ordItemDesc=ordItemDesc_";"_$C(10)_$P($G(^ARCIM(+testArcimRowId,$P(testArcimRowId,"||",2),1)),"^",2)
	......k DWRLisReport(testArcimRowId)
	...s ordStartDate=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",9)
	...s ordStartDate=$ZD(ordStartDate,3)
	...s ordStartTime=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",9)
	...s ordStartTime=$ZT(ordStartTime)	
    ...s ordLabNo=$P($G(^OEORD(oderRowId,"I",ordChildSub,3)),"^",20)
    ...s arcExCode=..GetExCode(arcimRowId)
    ...s reportDate="",reportTime="",reportUser=""
	...s reportStatus="报告未出"
	...s reportStr=##Class(DWR.BL.LisReport).GetLisReportState(admId,labRelatId)
	...s reportStatus=$p(reportStr,"^",1)
	...s reportDate=$p(reportStr,"^",2)
	...s reportTime=$p(reportStr,"^",3)
	...s reportUser=$p(reportStr,"^",4)
	...s reportException=$p(reportStr,"^",5)
	...s ordLabSpec="",specChildSub=0
	...i $d(^OEORD(oderRowId,"I",ordChildSub,"SPEC",specChildSub))'=0 d
	....s specChildSub=0 f  s specChildSub=$o(^OEORD(oderRowId,"I",ordChildSub,"SPEC",specChildSub)) q:specChildSub=""  d
	.....s labSpecCode=$g(^OEORD(oderRowId,"I",ordChildSub,"SPEC",specChildSub))
	.....s labSpecCode=$p(labSpecCode,"^",1)
	.....//s labSpec=$p(^[LABDATA]TTAB("SPEC",labSpecCode),"\",1)
	.....s labSpec=$p(##Class(DHCLIS.DHCCommon).GetSpecimen(labSpecCode,""),$c(2),2)
	.....i ordLabSpec="" s ordLabSpec=labSpec
	.....e  s ordLabSpec=ordLabSpec_","_labSpec
	...s myobj=##class(DWR.MSG.LisReportList).%New()
	...s ordIndex=ordIndex+1
	...s myobj.ordIndex=ordIndex
	...s myobj.recDept=recDeparment
	...s myobj.ordLabNo=ordLabNo
	...s myobj.arcItemId=arcimRowId
	...s myobj.ordItemDesc=ordItemDesc
	...s myobj.ordStatus=ordStatus
	...s myobj.ordDate=ordStartDate
	...s myobj.ordTime=ordStartTime
	...s myobj.ordLabSpec=ordLabSpec
	...s myobj.reportStatus=reportStatus
	...i reportUser="" s reportUser=$C(0)
	...s myobj.reportUser=reportUser
	...i reportDate="" s reportDate=$C(0)
	...s myobj.reportDate=reportDate
	...i reportTime="" s reportTime=$C(0)
	...s myobj.reportTime=reportTime
	...i reportException'="" s reportException=1
	...e  s reportException=0
	...s myobj.reportException=reportException
	...d myobj.%Close()
	...s Xml=""
	...s ret=myobj.XMLExportToString(.Xml,"LisReportList")
	...i ret=1 s retStr=retStr_Xml
	q retStr
}

/// w ##Class(DWR.BL.LisReport).GetLisReportList(Param)
ClassMethod GetLisReportListOLD(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><admId>11353</admId></Request>"
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
	s Config=##Class(websys.Configuration).%OpenId(1)
   	s MEDDATA=Config.DataNamespace
   	s LABDATA=Config.LabDataNamespace
   	d Config.%Close()
	s oderRowId=$order(^OEORD(0,"Adm",admId,""))
	q:oderRowId="" "202^没有检验医嘱信息!"
	s patientId=$P($get(^PAADM(admId)),"^",1)
	s ordChildSub=""
	f  s ordChildSub=$O(^OEORDi(0,"FLabResult",oderRowId,ordChildSub)) q:ordChildSub=""  d
	.s ordItemId=oderRowId_"||"_ordChildSub
	.s statusId=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",13)
	.s statusCode=$P($G(^OEC("OSTAT",statusId)),"^",1)
	.s ordStatus=$P($G(^OEC("OSTAT",statusId)),"^",2)
	.q:((statusCode'="E")&&(statusCode'="V"))
	.q:(ordStatus="停止")||(ordStatus="未激活")||(ordStatus="未审核")||(ordStatus="撤消")
	.s arcimRowId=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",2)
	.s arcSubCatDr=$P($G(^ARCIM(+arcimRowId,$P(arcimRowId,"||",2),1)),"^",10)
	.q:arcSubCatDr=""
	.s arcCatType=$piece($get(^ARC("IC",arcSubCatDr)),"^",7)
	.q:arcCatType'="L"
	.s ordLabNo=$P($G(^OEORD(oderRowId,"I",ordChildSub,3)),"^",20)
	.q:ordLabNo=""
    .s arcExCode=..GetExCode(arcimRowId)
    .q:arcExCode=""
    .s labRelatId=$P($G(^OEORD(oderRowId,"I",ordChildSub,3)),"^",35)
	.s DWRLisReport(arcimRowId,ordLabNo,ordItemId)=labRelatId
	.s DWRLisReportArc(arcimRowId)=+$G(DWRLisReportArc(arcimRowId))+1
	.s DWRLisReportLab(ordLabNo,arcimRowId)=ordItemId
	.s DWRLisReportLab(ordLabNo)=+$G(DWRLisReportLab(ordLabNo))+1
	/*
	s labRelatId=""
	f  s labRelatId=$O(^OEORDi(0,"LabTS",oderRowId,labRelatId)) q:labRelatId=""  d
	.s ordChildSub=""
	.f  s ordChildSub=$O(^OEORDi(0,"LabTS",oderRowId,labRelatId,ordChildSub)) q:ordChildSub=""  d
	..s ordItemId=oderRowId_"||"_ordChildSub
	..s statusId=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",13)
	..s statusCode=$P($G(^OEC("OSTAT",statusId)),"^",1)
	..s ordStatus=$P($G(^OEC("OSTAT",statusId)),"^",2)
	..q:((statusCode'="E")&&(statusCode'="V"))
	..q:(ordStatus="停止")||(ordStatus="未激活")||(ordStatus="未审核")||(ordStatus="撤消")
	..s arcimRowId=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",2)
	..s arcSubCatDr=$P($G(^ARCIM(+arcimRowId,$P(arcimRowId,"||",2),1)),"^",10)
	..q:arcSubCatDr=""
	..s arcCatType=$piece($get(^ARC("IC",arcSubCatDr)),"^",7)
	..q:arcCatType'="L"
	..s ordLabNo=$P($G(^OEORD(oderRowId,"I",ordChildSub,3)),"^",20)
	..q:ordLabNo=""
    ..s arcExCode=..GetExCode(arcimRowId)
    ..q:arcExCode=""
	..s DWRLisReport(arcimRowId,ordLabNo,ordItemId)=labRelatId
	..s DWRLisReportArc(arcimRowId)=+$G(DWRLisReportArc(arcimRowId))+1
	..s DWRLisReportLab(ordLabNo,arcimRowId)=ordItemId
	..s DWRLisReportLab(ordLabNo)=+$G(DWRLisReportLab(ordLabNo))+1
	*/
	s ordIndex=0
	s arcimRowId="" f  s arcimRowId=$O(DWRLisReport(arcimRowId)) q:arcimRowId=""  d
	.s ordLabNo=""  f  s ordLabNo=$O(DWRLisReport(arcimRowId,ordLabNo)) q:ordLabNo=""  d
	..s ordItemId=""  f ordItemId=$O(DWRLisReport(arcimRowId,ordLabNo,ordItemId)) q:ordItemId=""  d
	...s labRelatId=DWRLisReport(arcimRowId,ordLabNo,ordItemId)
	...s oderRowId=$P(ordItemId,"||")
	...s ordChildSub=$P(ordItemId,"||",2)
	...s statusId=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",13)
	...s statusCode=$P($G(^OEC("OSTAT",statusId)),"^",1)
	...s ordStatus=$P($G(^OEC("OSTAT",statusId)),"^",2)
	...s arcimRowId=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",2)
	...s recDeparmentDr=$P($G(^OEORD(oderRowId,"I",ordChildSub,3)),"^",6)
	...i recDeparmentDr'="" s recDeparment=$p($g(^CTLOC(recDeparmentDr)),"^",2)
	...e  s recDeparment=""
	...i $P(recDeparment,"-",2)'="" s recDeparment=$P(recDeparment,"-",2)	
	...s ordItemDesc=$P($G(^ARCIM(+arcimRowId,$P(arcimRowId,"||",2),1)),"^",2)
	...////同一个标本号,并且没有可对比的历史数据时,合并显示
	...i DWRLisReportArc(arcimRowId)<2 d
	....s testArcimRowId=""
	....f  s testArcimRowId=$O(DWRLisReportLab(ordLabNo,testArcimRowId)) q:testArcimRowId=""  d
	.....q:testArcimRowId=arcimRowId
	.....i DWRLisReportArc(testArcimRowId)<2 d
	......s ordItemDesc=ordItemDesc_";"_$C(10)_$P($G(^ARCIM(+testArcimRowId,$P(testArcimRowId,"||",2),1)),"^",2)
	......k DWRLisReport(testArcimRowId)
	...s ordStartDate=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",9)
	...s ordStartDate=$ZD(ordStartDate,3)
	...s ordStartTime=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",9)
	...s ordStartTime=$ZT(ordStartTime)	
    ...s ordLabNo=$P($G(^OEORD(oderRowId,"I",ordChildSub,3)),"^",20)
    ...s arcExCode=..GetExCode(arcimRowId)
    ...s reportDate="",reportTime="",reportUser=""
    ...i labRelatId'="" d
    ....s labTSCode=$p(labRelatId,"||",2)
    ....s labTSId=$p(labRelatId,"||",3)
	....s reportDate=$P($G(^TEPI(ordLabNo,1,labTSCode,labTSId)),"\",4)
	....i reportDate'="" s reportDate=$ZD(reportDate,3)
	....s reportTime=$P($G(^TEPI(ordLabNo,1,labTSCode,labTSId)),"\",5)
	....i reportTime'="" s reportTime=$ZT(reportTime)
	....s reportUserCode=$P($G(^TEPI(ordLabNo,1,labTSCode,labTSId)),"\",6)
	....s reportUser=""
	....i (reportUserCode'="") s reportUser=$P($G(^SSU("SSUSR",1,reportUserCode)),"^",2)  
	....s labstatus=..IflabnoVer(ordLabNo,arcExCode)
	....s labCpt=$P(labstatus,"^",1)
	....s labDate=$E($P(labstatus,"^",2),6,10)
	....s labTime=$P(labstatus,"^",3)
	...s ordLabSpec="",specChildSub=0
	...i $d(^OEORD(oderRowId,"I",ordChildSub,"SPEC",specChildSub))'=0 d
	....s specChildSub=0 f  s specChildSub=$o(^OEORD(oderRowId,"I",ordChildSub,"SPEC",specChildSub)) q:specChildSub=""  d
	.....s labSpecCode=$g(^OEORD(oderRowId,"I",ordChildSub,"SPEC",specChildSub))
	.....s labSpecCode=$p(labSpecCode,"^",1)
	.....s labSpec=$p(^[LABDATA]TTAB("SPEC",labSpecCode),"\",1)
	.....i ordLabSpec="" s ordLabSpec=labSpec
	.....e  s ordLabSpec=ordLabSpec_","_labSpec
	...s myobj=##class(DWR.MSG.LisReportList).%New()
	...s ordIndex=ordIndex+1
	...s myobj.ordIndex=ordIndex
	...s myobj.recDept=recDeparment
	...s myobj.ordLabNo=ordLabNo
	...s myobj.arcItemId=arcimRowId
	...s myobj.ordItemDesc=ordItemDesc
	...s myobj.ordStatus=ordStatus
	...s myobj.ordDate=ordStartDate
	...s myobj.ordTime=ordStartTime
	...s myobj.ordLabSpec=ordLabSpec
	...s reportStatus="报告未出"
	...i reportDate'="" s reportStatus="报告已出"
	...s reportStatus=##Class(DWR.BL.LisReport).GetLisReportStateOLD(admId,ordLabNo)
	...s myobj.reportStatus=reportStatus
	...i reportUser="" s reportUser=$C(0)
	...s myobj.reportUser=reportUser
	...i reportDate="" s reportDate=$C(0)
	...s myobj.reportDate=reportDate
	...i reportTime="" s reportTime=$C(0)
	...s myobj.reportTime=reportTime
	...s reportException=##Class(DWR.BL.LisReport).GetLisReportExpOLD(admId,ordLabNo)
	...i reportException'="" s reportException=1
	...e  s reportException=0
	...s myobj.reportException=reportException
	...d myobj.%Close()
	...s Xml=""
	...s ret=myobj.XMLExportToString(.Xml,"LisReportList")
	...i ret=1 s retStr=retStr_Xml
	q retStr
}

ClassMethod GetLisReportState(admId As %String = "", VisitNumberTestSetDR As %String = "") As %String
{
	s reportStatus="报告未出"
	s flagUpDown=""
	
	//报告信息
	s VisitNumberDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),2)
	s TestSetDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),3)
	i '$l(VisitNumberDR) q ""
	s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),5)
	i '$l(WorkGroupMachineDR) q ""
	s WorkGroupDR=$lg($g(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR)),4)
	s OrderNo=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,"")) 
	i '$l(OrderNo) q ""
	s ReportDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo,""),-1)
 	i '$l(ReportDR) q ""
 	i $lg($g(^dbo.RPVisitNumberReportD(ReportDR)),22)=3 s reportStatus="报告已出"
    s AuthDate=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),19)
	s AuthTime=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),20)
	s AuthDate=##Class(LIS.Util.Common).FormatDate(AuthDate)
	s AuthTime=##Class(LIS.Util.Common).FormatTime(AuthTime)
	s AuthUserDR=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),21),AuthUser="",AuthUserCode=""
	i $l(AuthUserDR) s AuthUser=$lg($g(^dbo.SYSUserD(AuthUserDR)),3),AuthUserCode=$lg($g(^dbo.SYSUserD(AuthUserDR)),2)
	s expFlag=0	
	s TestCodeDR="" f  s TestCodeDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",ReportDR,TestCodeDR)) q:TestCodeDR=""  d
 	.s ReportResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",ReportDR,TestCodeDR,"")) 
 	.q:'$l(ReportResultDR)
	.s AbFlag=$lg($g(^dbo.RPVisitNumberReportResultD(ReportResultDR)),9)
	.i (AbFlag="H")||(AbFlag="L") s expFlag=1
	.i (AbFlag="PH")||(AbFlag="PL") s expFlag=1
	.i (AbFlag="UH")||(AbFlag="UL") s expFlag=1
	.i (AbFlag="A") s expFlag=1
	q reportStatus_"^"_AuthDate_"^"_AuthTime_"^"_AuthUser_"^"_expFlag
}

/// w ##Class(DWR.BL.LisReport).GetLisReportExp()
ClassMethod GetLisReportExpOLD(admId As %String = "", ordLabNo As %String = "") As %String
{
	s expFlag=""
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	s labTSCode=$O(^[LABDATA]TEPI(ordLabNo,1,""))
	q:labTSCode="" expFlag
	s labTSId=$O(^[LABDATA]TEPI(ordLabNo,1,labTSCode,""))
	q:labTSId="" expFlag
	i ($D(^[LABDATA]TEPI(ordLabNo,1,labTSCode,labTSId))) d
	.s reportId=""
	.f  s reportId=$O(^[LABDATA]TEPI(ordLabNo,reportId)) q:reportId=""  d
	..s labTSCode=""
	..f  s labTSCode=$O(^[LABDATA]TEPI(ordLabNo,reportId,labTSCode)) q:labTSCode=""  d
	...s labTSId=""
	...f  s labTSId=$O(^[LABDATA]TEPI(ordLabNo,reportId,labTSCode,labTSId)) q:labTSId=""  d
	....s itemCode=""
	....s serialNo=0
	....f  s itemCode=$O(^[LABDATA]TEPI(ordLabNo,reportId,labTSCode,labTSId,"DATA",itemCode)) q:itemCode=""  d
	.....s resultStr=$G(^[LABDATA]TEPI(ordLabNo,reportId,labTSCode,labTSId,"DATA",itemCode))
	.....q:resultStr=""
	.....s itemDesc=$P(^[LABDATA]TTAB("TC",itemCode),"\",1)
	.....s result=""
	.....s resultValue=$P($G(^[LABDATA]TEPI(ordLabNo,reportId,labTSCode,labTSId,"DATA",itemCode)),"\",1)
	.....s reportDate=$P(^[LABDATA]TEPI(ordLabNo,reportId,labTSCode,labTSId),"\",4)
	.....zn LABDATA
	.....s myItemStr=$$TestItmRes^CHDhcLabReport(ordLabNo,itemCode,resultValue,reportDate)
	.....zn CurrentNS
	.....s flagUpDown=$P(myItemStr,$Char(2),6)
	.....//s flagUpDown=$P(myItemStr,$Char(2),11)   H L N  
	.....i (flagUpDown'="") s expFlag=1
	.....i (flagUpDown="H")||(flagUpDown="L")||(flagUpDown="↑")||(flagUpDown="↓")   s expFlag=1
	.....i expFlag="" d
	......s flagUpDown=$P($G(^[LABDATA]TEPI(ordLabNo,reportId,labTSCode,labTSId,"DATA",itemCode)),"\",2)
	......i (flagUpDown="H")||(flagUpDown="L")||(flagUpDown="↑")||(flagUpDown="↓")   s expFlag=1
	q expFlag
}

/// w ##Class(DWR.BL.LisReport).GetLisReportState()
ClassMethod GetLisReportStateOLD(admId As %String = "", ordLabNo As %String = "") As %String
{
	s reportStatus="报告未出"
	s flagUpDown=""
	s Config=##Class(websys.Configuration).%OpenId(1)
    s LABDATA=Config.LabDataNamespace
    d Config.%Close()
	s labTSCode=$O(^[LABDATA]TEPI(ordLabNo,1,""))
	q:labTSCode="" reportStatus
	s labTSId=$O(^[LABDATA]TEPI(ordLabNo,1,labTSCode,""))
	q:labTSId="" reportStatus
	i ($D(^[LABDATA]TEPI(ordLabNo,1,labTSCode,labTSId))) d
	.s reportId=""
	.f  s reportId=$O(^[LABDATA]TEPI(ordLabNo,reportId)) q:reportId=""  d
	..s labTSCode=""
	..f  s labTSCode=$O(^[LABDATA]TEPI(ordLabNo,reportId,labTSCode)) q:labTSCode=""  d
	...s labTSId=""
	...f  s labTSId=$O(^[LABDATA]TEPI(ordLabNo,reportId,labTSCode,labTSId)) q:labTSId=""  d
	....
	....s itemCode=""
	....s serialNo=0
	....f  s itemCode=$O(^[LABDATA]TEPI(ordLabNo,reportId,labTSCode,labTSId,"DATA",itemCode)) q:itemCode=""  d
	.....s resultStr=$G(^[LABDATA]TEPI(ordLabNo,reportId,labTSCode,labTSId,"DATA",itemCode))
	.....q:resultStr=""
	.....s itemDesc=$P(^[LABDATA]TTAB("TC",itemCode),"\",1)
	.....s result=""
	.....s resultValue=$P($G(^[LABDATA]TEPI(ordLabNo,reportId,labTSCode,labTSId,"DATA",itemCode)),"\",1)
	.....i resultValue'="" s reportStatus="报告已出"
	.....i flagUpDown="" s flagUpDown=$P($G(^[LABDATA]TEPI(ordLabNo,reportId,labTSCode,labTSId,"DATA",itemCode)),"\",2)
	//i flagUpDown'="" s reportStatus=reportStatus_"(异常)"
	q reportStatus
}

ClassMethod IflabnoVer(labno As %String = "", testc As %String = "") As %String
{
   q:testc="" ""
   s Config=##Class(websys.Configuration).%OpenId(1)
   s MEDDATA=Config.DataNamespace
   s LABDATA=Config.LabDataNamespace
   d Config.%Close()
   s status=$P($g(^[LABDATA]TEPI(labno,1,testc,1)),"\",31)
   if status'="A"  q ""
   s ^TMP(labno,testc)=""
   s author=$p(^[LABDATA]TEPI(labno,1,testc,1),"\",3)
   i (author'="") {
	   if ($D(^[LABDATA]SSU("SSUSR",1,author))){
	  	 s author=$p(^[LABDATA]SSU("SSUSR",1,author),"^",2) 
		}
		else{
			s author=""
		}
	}
	else 
	{
		s author=""
	}
	s Adate=$zd($p($G(^[LABDATA]TEPI(labno,1,testc,1)),"\",1),3)
	s Atime=$zt($p($G(^[LABDATA]TEPI(labno,1,testc,1)),"\",2)*60)
	s ret=author_"^"_Adate_"^"_Atime
	i $P(ret,"^",2)="" s ret=""
	q ret
}

ClassMethod GetExCode(ArcimRowid As %String) As %String
{
	s arcsub=$p(ArcimRowid,"||",2)
	q:arcsub="" ""
	s ExCode=""
	s chl="" f  s chl=$o(^ARCIM(+ArcimRowid,arcsub,"EXT",chl)) q:chl=""  d
	.s tod=$p(^ARCIM(+ArcimRowid,arcsub,"EXT",chl),"^",2)
	.s fromd=$p(^ARCIM(+ArcimRowid,arcsub,"EXT",chl),"^",1)
	.q:(fromd'="")&(fromd>+$h)
	.q:(tod'="")&(tod<+$h)
	.s ExCode=$p(^ARCIM(+ArcimRowid,arcsub,"EXT",chl),"^",4)
	q ExCode
}

/// w ##Class(DWR.BL.LisReport).GetLisReport()
ClassMethod GetLisReport(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><admId>24</admId><ordLabNo>1604220036</ordLabNo></Request>"
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
	   s labNo=request.ordLabNo
	   s labNo=$TR(labNo,$C(0))
	}
	q:($G(admId)="") "201^就诊号不能为空!"
	q:($G(labNo)="") "202^标本号不能为空!"
	
	s VisitNumberDR=$o(^dbo.RPVisitNumberI("IndexVisitNumber",$c(32)_labNo,""))
	i '$l(VisitNumberDR) q "203^报告不存在!"

	s WorkGroupMachineDR="" f  s WorkGroupMachineDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR)) q:WorkGroupMachineDR=""  d
	.s OrderNo=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,"")) 
	.i '$l(OrderNo) q
	.s ReportDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo,""),-1)
	.s TestCodeDR="" f  s TestCodeDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",ReportDR,TestCodeDR)) q:TestCodeDR=""  d
 	..s ReportResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",ReportDR,TestCodeDR,"")) 
 	..q:'$l(ReportResultDR)
	..s ReportResult=$g(^dbo.RPVisitNumberReportResultD(ReportResultDR))
    ..s TestCodeData=$g(^dbo.BTTestCodeD(TestCodeDR))
	..s ItemCode = $lg(TestCodeData,2)
	..s ItemDesc=$lg(TestCodeData,3)
	..s Synonym = $lg(TestCodeData,7) //缩写
	..s ItemUnit = $lg(TestCodeData,8) //单位
	..s resultValue=$lg(ReportResult,4)
	..s ItemResult=$lg(ReportResult,5)
	..s AbnorFlag=$lg(ReportResult,9)
	..s ItemRangs = $lg(ReportResult,12) //参考范围
	..s ItemDate=$lg(ReportResult,16)
	..s ItemTime=$lg(ReportResult,17)
	..s Sequence=$lg(ReportResult,18)
	..i (AbnorFlag="H") s AbnorFlag="↑"
	..i (AbnorFlag="L") s AbnorFlag="↓"
	..s myobj=##class(DWR.MSG.LisReportItem).%New()
	..s myobj.itemCode=ItemCode
	..s myobj.itemDesc=ItemDesc
	..s myobj.abbreviation=Synonym
	..s myobj.unit=ItemUnit
	..s myobj.serialNo=Sequence
	..s myobj.result=ItemResult
	..s myobj.resultValue=resultValue
	..s myobj.flagUpDown=AbnorFlag
	..s myobj.naturalRange=ItemRangs
	..d myobj.%Close()
	..s Xml=""
	..s ret=myobj.XMLExportToString(.Xml,"LisReportItem")
	..i ret=1 s retStr=retStr_Xml
	q retStr
}

/// w ##Class(DWR.BL.LisReport).GetLisReport()
ClassMethod GetLisReportOLD(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><admId>11353</admId><labNo>600000000756</labNo></Request>"
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
	   s labNo=request.ordLabNo
	   s labNo=$TR(labNo,$C(0))
	}
	q:($G(admId)="") "201^就诊号不能为空!"
	q:($G(labNo)="") "202^标本号不能为空!"
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	s labTSCode=$O(^[LABDATA]TEPI(labNo,1,""))
	q:labTSCode="" "203^报告不存在!"
	s labTSId=$O(^[LABDATA]TEPI(labNo,1,labTSCode,""))
	q:labTSId="" "203^报告不存在!"
	i ($D(^[LABDATA]TEPI(labNo,1,labTSCode,labTSId))) d
	.s serialNo=0
	.s reportId=""
	.f  s reportId=$O(^[LABDATA]TEPI(labNo,reportId)) q:reportId=""  d
	..s labTSCode=""
	..f  s labTSCode=$O(^[LABDATA]TEPI(labNo,reportId,labTSCode)) q:labTSCode=""  d
	...s labTSId=""
	...f  s labTSId=$O(^[LABDATA]TEPI(labNo,reportId,labTSCode,labTSId)) q:labTSId=""  d
	....s itemCode=""
	....f  s itemCode=$O(^[LABDATA]TEPI(labNo,reportId,labTSCode,labTSId,"DATA",itemCode)) q:itemCode=""  d
	.....s resultStr=$G(^[LABDATA]TEPI(labNo,reportId,labTSCode,labTSId,"DATA",itemCode))
	.....q:resultStr=""
	.....s itemDesc=$P(^[LABDATA]TTAB("TC",itemCode),"\",1)
	.....s result=""
	.....s resultValue=$P($G(^[LABDATA]TEPI(labNo,reportId,labTSCode,labTSId,"DATA",itemCode)),"\",1)
	.....s serialNo=serialNo+1
	.....s receiveDate=$P(^[LABDATA]TEPI(labNo,reportId,labTSCode,labTSId),"\",21)
	.....//i receiveDate'="" s receiveDate=$ZD(receiveDate,3)
	.....s reportDate=$P(^[LABDATA]TEPI(labNo,reportId,labTSCode,labTSId),"\",4)
	.....//i reportDate'="" s reportDate=$ZD(reportDate,3)
	.....s reportUserCode=$P(^[LABDATA]TEPI(labNo,reportId,labTSCode,labTSId),"\",6)
	.....s reportUser=""
	.....i (reportUserCode'="") set reportUser=$P($G(^SSU("SSUSR",1,reportUserCode)),"^",2)
	.....zn LABDATA
	.....s myItemStr=$$TestItmRes^CHDhcLabReport(labNo,itemCode,resultValue,reportDate)
	.....zn CurrentNS
	.....s abbreviation=$P(myItemStr,$Char(2),3)
	.....s unit=$P(myItemStr,$Char(2),5)
	.....//i (unit["~") s unit=$TR(unit,"~","-")
	.....s naturalRange=$P(myItemStr,$Char(2),7)
	.....i naturalRange="" s naturalRange=$G(^[LABDATA]TEPI(labNo,reportId,labTSCode,labTSId,"DATA",itemCode,"Ranges"))
	.....i naturalRange="" s naturalRange=$C(0)
	.....//i (naturalRange["~") s naturalRange=$TR(naturalRange,"~","-")
	.....s flagUpDown=$P(myItemStr,$Char(2),6)
	.....i (flagUpDown="H") s flagUpDown="↑"
	.....i (flagUpDown="L") s flagUpDown="↓"
	.....i flagUpDown="" s flagUpDown=$P($G(^[LABDATA]TEPI(labNo,reportId,labTSCode,labTSId,"DATA",itemCode)),"\",2)
	.....i (flagUpDown="N") s flagUpDown=""
	.....//i (flagUpDown="*") s flagUpDown=""
	.....i flagUpDown="" s flagUpDown=$C(0)
	.....s myobj=##class(DWR.MSG.LisReportItem).%New()
	.....s myobj.itemCode=itemCode
	.....s myobj.itemDesc=itemDesc
	.....s myobj.abbreviation=abbreviation
	.....s myobj.unit=unit
	.....s myobj.serialNo=serialNo
	.....s myobj.result=result
	.....s myobj.resultValue=resultValue
	.....s myobj.flagUpDown=flagUpDown
	.....s myobj.naturalRange=naturalRange
	.....d myobj.%Close()
	.....s Xml=""
	.....s ret=myobj.XMLExportToString(.Xml,"LisReportItem")
	.....i ret=1 s retStr=retStr_Xml
	q retStr
}

/// w ##Class(DWR.BL.LisReport).GetLisItemChart()
ClassMethod GetLisItemChart(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><admId>24</admId><ordLabNo>1604220036</ordLabNo><itemCode>L0002</itemCode></Request>"
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
	   s labNo=request.ordLabNo
	   s labNo=$TR(labNo,$C(0))
	   s itemCode=request.itemCode
	   s itemCode=$TR(itemCode,$C(0))
	}
	q:($G(admId)="") "201^就诊号不能为空!"
	q:($G(labNo)="") "202^标本号不能为空!"
	q:($G(itemCode)="") "202^检验项目代码不能为空!"
	s Config=##Class(websys.Configuration).%OpenId(1)
    s MEDDATA=Config.DataNamespace
    s LABDATA=Config.LabDataNamespace
    s CurrentNS=$ZNSPACE
    d Config.%Close()
	s itemDesc=$P($G(^TTAB("TC",itemCode)),"\",1)
	s patientId=$piece($get(^PAADM(admId)),"^",1)
	s regNo=##Class(web.PAPatMas).GetRegistration(patientId)
	//s regNo="0000002308"
  	s TestCodeDR="" f  s TestCodeDR=$o(^dbo.RPVisitNumberReportResultI("IndexPatientItem",$c(32)_regNo,TestCodeDR)) q:TestCodeDR=""  d
    .s TestCodeData=$g(^dbo.BTTestCodeD(TestCodeDR))
	.s ItemCode1 = $lg(TestCodeData,2)
	.i itemCode'=ItemCode1 q
	.s ItemDesc=$lg(TestCodeData,3)
	.s AuthDate=$o(^dbo.RPVisitNumberReportResultI("IndexPatientItem",$c(32)_regNo,TestCodeDR,""),-1)
	.i '$l(AuthDate) q 
	.s AuthTime=$o(^dbo.RPVisitNumberReportResultI("IndexPatientItem",$c(32)_regNo,TestCodeDR,AuthDate,""),-1)
	.i '$l(AuthTime) q 
	.s ResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexPatientItem",$c(32)_regNo,TestCodeDR,AuthDate,AuthTime,""))
	.i '$l(ResultDR) q 
	.s ReportResult=$g(^dbo.RPVisitNumberReportResultD(ResultDR))
	.s VisitNumberReportDR=$lg(ReportResult,2)
	.i $lg($g(^dbo.RPVisitNumberReportD(VisitNumberReportDR)),22)'=3 q
	.s ReportResult=$g(^dbo.RPVisitNumberReportResultD(ResultDR))
	.s Synonym = $lg(TestCodeData,7) //缩写
	.s ItemUnit = $lg(TestCodeData,8) //单位
	.s resultValue=$lg(ReportResult,4)
	.s ItemResult=$lg(ReportResult,5)
	.s AbnorFlag=$lg(ReportResult,9)
	.s ItemRangs = $lg(ReportResult,12) //参考范围
	.s reportDate=##Class(LIS.Util.Common).FormatDate(AuthDate)
	.s reportTime=##Class(LIS.Util.Common).FormatTime(AuthTime)
  	.s Sequence=$lg(ReportResult,18)
	.s myobj=##class(DWR.MSG.LisReportItem).%New()
	.s myobj.reportDate=reportDate
	.s myobj.reportTime=reportTime
	.s myobj.itemCode=ItemCode1
	.s myobj.itemDesc=ItemDesc
	.s myobj.abbreviation=Synonym
	.s myobj.unit=ItemUnit
	.s myobj.serialNo=Sequence
	.s myobj.result=ItemResult
	.s myobj.resultValue=resultValue
	.s myobj.flagUpDown=AbnorFlag
	.s myobj.naturalRange=ItemRangs
	.d myobj.%Close()
	.s Xml=""
	.s ret=myobj.XMLExportToString(.Xml,"LisReportItem")
	.i ret=1 s retStr=retStr_Xml	
	q retStr
}

/// w ##Class(DWR.BL.LisReport).CompareLisReport(Param)
ClassMethod CompareLisReport(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><admId>24</admId><arcItemId>4097||1</arcItemId></Request>"
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
	   s arcItemId=request.arcItemId
	   s arcItemId=$TR(arcItemId,$C(0))
	}
	q:($G(admId)="") "201^就诊号不能为空!"
	q:($G(arcItemId)="") "202^医嘱项不能为空!"
	
	s oderRowId=$order(^OEORD(0,"Adm",admId,""))
	q:oderRowId=""
	s patientId=$P($get(^PAADM(admId)),"^",1)
	s ordChildSub=0 f  s ordChildSub=$O(^OEORD(oderRowId,"I",ordChildSub)) q:ordChildSub=""  d
	.s ordItemId=oderRowId_"||"_ordChildSub
	.s statusId=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",13)
	.s statusCode=$P($G(^OEC("OSTAT",statusId)),"^",1)
	.s ordStatus=$P($G(^OEC("OSTAT",statusId)),"^",2)
	.q:((statusCode'="E")&&(statusCode'="V"))
	.q:(ordStatus="停止")||(ordStatus="未激活")||(ordStatus="未审核")||(ordStatus="撤消")
	.s arcimRowId=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",2)
	.q:arcItemId'=arcimRowId
	.s labNo=$P($G(^OEORD(oderRowId,"I",ordChildSub,3)),"^",20)
	.q:labNo=""    
	.s VisitNumberTestSetDR=$P($G(^OEORD(oderRowId,"I",ordChildSub,3)),"^",35)
	.q:VisitNumberTestSetDR=""    
	.s VisitNumberDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),2)
	.s TestSetDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),3)
	.i '$l(VisitNumberDR) q 
	.s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),5)
	.i '$l(WorkGroupMachineDR) q 
	.s WorkGroupDR=$lg($g(^dbo.BTWorkGroupMachineD(WorkGroupMachineDR)),4)
	.s OrderNo=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,"")) 
	.i '$l(OrderNo) q 
	.s ReportDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo,""),-1)
 	.i '$l(ReportDR) q 
    .s reportDate=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),19)
	.s TestCodeDR="" f  s TestCodeDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",ReportDR,TestCodeDR)) q:TestCodeDR=""  d
 	..s ReportResultDR=$o(^dbo.RPVisitNumberReportResultI("IndexReportItem",ReportDR,TestCodeDR,"")) 
 	..q:'$l(ReportResultDR)
	..s flagUpDown=$lg($g(^dbo.RPVisitNumberReportResultD(ReportResultDR)),9)
	..s resultValue=$lg($g(^dbo.RPVisitNumberReportResultD(ReportResultDR)),5)
	..s naturalRange=$lg($g(^dbo.RPVisitNumberReportResultD(ReportResultDR)),12)
	..i (flagUpDown="H") s flagUpDown="↑"
	..i (flagUpDown="L") s flagUpDown="↓"
	..i (flagUpDown="N") s flagUpDown=""
	..i (flagUpDown="*") s flagUpDown=""
	..s DWRLisComp(TestCodeDR,reportDate,labNo)=resultValue_flagUpDown
	..s DWRLisCompRange(TestCodeDR)=naturalRange
	s serialNo=0
	s TestCodeDR=""	f  s TestCodeDR=$O(DWRLisComp(TestCodeDR)) q:TestCodeDR=""  d
	.s itemCode = $lg($g(^dbo.BTTestCodeD(TestCodeDR)),2)
	.s itemDesc = $lg($g(^dbo.BTTestCodeD(TestCodeDR)),3)
	.s myobj=##class(DWR.MSG.LisReportItem).%New()
	.s serialNo=serialNo+1
	.s myobj.serialNo=serialNo
	.s myobj.itemCode=itemCode
	.s myobj.itemDesc=itemDesc
	.s reportDate="" f  s reportDate=$O(DWRLisComp(TestCodeDR,reportDate)) q:reportDate=""  d
	..s labNo="" f  s labNo=$O(DWRLisComp(TestCodeDR,reportDate,labNo)) q:labNo=""  d
	...s resultValue=$G(DWRLisComp(TestCodeDR,reportDate,labNo))
	...i resultValue="" s resultValue=$C(0)
	...s resultObj=##Class(DWR.MSG.LisReportResult).%New()
	...s resultObj.reportDate=##Class(LIS.Util.Common).FormatDate(reportDate)
	...s resultObj.resultValue=resultValue
	...d myobj.resultList.Insert(resultObj)
	...d resultObj.%Close()
	.s naturalRange=$G(DWRLisCompRange(TestCodeDR))
	.s resultObj=##Class(DWR.MSG.LisReportResult).%New()
	.s resultObj.reportDate="参考范围"
	.s resultObj.resultValue=naturalRange
	.d myobj.resultList.Insert(resultObj)
	.d resultObj.%Close()
	.d myobj.%Close()
	.s Xml=""
	.s ret=myobj.XMLExportToString(.Xml) //,"LisReportItem")
	.i ret=1 s retStr=retStr_Xml
	q retStr
}

ClassMethod CompareLisReportOLD(Param As %String = "") As %String
{
	s retStr=""
	i Param="" s Param="<Request><admId>11353</admId><arcItemId>4097||1</arcItemId></Request>"
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
	   s arcItemId=request.arcItemId
	   s arcItemId=$TR(arcItemId,$C(0))
	}
	q:($G(admId)="") "201^就诊号不能为空!"
	q:($G(arcItemId)="") "202^医嘱项不能为空!"
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	s oderRowId=$order(^OEORD(0,"Adm",admId,""))
	q:oderRowId=""
	s patientId=$P($get(^PAADM(admId)),"^",1)
	s labRelatId=""
	f  s labRelatId=$O(^OEORDi(0,"LabTS",oderRowId,labRelatId)) q:labRelatId=""  d
	.s ordChildSub=""
	.f  s ordChildSub=$O(^OEORDi(0,"LabTS",oderRowId,labRelatId,ordChildSub)) q:ordChildSub=""  d
	..s ordItemId=oderRowId_"||"_ordChildSub
	..s statusId=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",13)
	..s statusCode=$P($G(^OEC("OSTAT",statusId)),"^",1)
	..s ordStatus=$P($G(^OEC("OSTAT",statusId)),"^",2)
	..q:((statusCode'="E")&&(statusCode'="V"))
	..q:(ordStatus="停止")||(ordStatus="未激活")||(ordStatus="未审核")||(ordStatus="撤消")
	..s arcimRowId=$P($G(^OEORD(oderRowId,"I",ordChildSub,1)),"^",2)
	..q:arcItemId'=arcimRowId
	..s labNo=$P($G(^OEORD(oderRowId,"I",ordChildSub,3)),"^",20)
	..q:labNo=""    
	..s labTSCode=$P(labRelatId,"||",2)
	..q:labTSCode=""
	..s labTSId=$P(labRelatId,"||",3)
	..q:labTSId=""
	..q:'$D(^[LABDATA]TEPI(labNo,1,labTSCode,labTSId))
	..s itemCode=""
	..s serialNo=0
	..f  s itemCode=$O(^[LABDATA]TEPI(labNo,1,labTSCode,labTSId,"DATA",itemCode)) q:itemCode=""  d
	...s resultStr=$G(^[LABDATA]TEPI(labNo,1,labTSCode,labTSId,"DATA",itemCode))
	...q:resultStr=""
	...s itemDesc=$P(^[LABDATA]TTAB("TC",itemCode),"\",1)
	...s result=""
	...s resultValue=$P($G(^[LABDATA]TEPI(labNo,1,labTSCode,labTSId,"DATA",itemCode)),"\",1)
	...s serialNo=serialNo+1
	...s receiveDate=$P(^[LABDATA]TEPI(labNo,1,labTSCode,labTSId),"\",21)
	...//i receiveDate'="" s receiveDate=$ZD(receiveDate,3)
	...s reportDate=$P(^[LABDATA]TEPI(labNo,1,labTSCode,labTSId),"\",4)
	...//i reportDate'="" s reportDate=$ZD(reportDate,3)
	...s reportUserCode=$P(^[LABDATA]TEPI(labNo,1,labTSCode,labTSId),"\",6)
	...s reportUser=""
	...i (reportUserCode'="") set reportUser=$P($G(^SSU("SSUSR",1,reportUserCode)),"^",2)
	...zn LABDATA
	...s myItemStr=$$TestItmRes^CHDhcLabReport(labNo,itemCode,resultValue,reportDate)
	...zn CurrentNS
	...s abbreviation=$P(myItemStr,$Char(2),3)
	...s unit=$P(myItemStr,$Char(2),5)
	...//i (unit["~") s unit=$TR(unit,"~","-")
	...s naturalRange=$P(myItemStr,$Char(2),7)
	...i naturalRange="" s naturalRange=$G(^[LABDATA]TEPI(labNo,1,labTSCode,labTSId,"DATA",itemCode,"Ranges"))
	...i naturalRange="" s naturalRange=$C(0)
	...//i (naturalRange["~") s naturalRange=$TR(naturalRange,"~","-")
	...s flagUpDown=$P(myItemStr,$Char(2),6)
	...i (flagUpDown="H") s flagUpDown="↑"
	...i (flagUpDown="L") s flagUpDown="↓"
	...i (flagUpDown="N") s flagUpDown=""
	...i (flagUpDown="*") s flagUpDown=""
	...i flagUpDown="" s flagUpDown=$P($G(^[LABDATA]TEPI(labNo,1,labTSCode,labTSId,"DATA",itemCode)),"\",2)
	...//i flagUpDown="" s flagUpDown=$C(0)
	...q:reportDate=""
	...s DWRLisComp(itemCode,reportDate,labNo)=resultValue_flagUpDown
	...s DWRLisCompRange(itemCode)=naturalRange
	s serialNo=0
	s itemCode=""
	f  s itemCode=$O(DWRLisComp(itemCode)) q:itemCode=""  d
	.s myobj=##class(DWR.MSG.LisReportItem).%New()
	.s serialNo=serialNo+1
	.s myobj.serialNo=serialNo
	.s myobj.itemCode=itemCode
	.s itemDesc=$P(^[LABDATA]TTAB("TC",itemCode),"\",1)
	.s myobj.itemDesc=itemDesc
	.s reportDate=""
	.f  s reportDate=$O(DWRLisComp(itemCode,reportDate)) q:reportDate=""  d
	..s labNo=""
	..f  s labNo=$O(DWRLisComp(itemCode,reportDate,labNo)) q:labNo=""  d
	...s resultValue=$G(DWRLisComp(itemCode,reportDate,labNo))
	...i resultValue="" s resultValue=$C(0)
	...s resultObj=##Class(DWR.MSG.LisReportResult).%New()
	...s resultObj.reportDate=$ZD(reportDate,3)
	...s resultObj.resultValue=resultValue
	...d myobj.resultList.Insert(resultObj)
	...d resultObj.%Close()
	.s naturalRange=$G(DWRLisCompRange(itemCode))
	.s resultObj=##Class(DWR.MSG.LisReportResult).%New()
	.s resultObj.reportDate="参考范围"
	.s resultObj.resultValue=naturalRange
	.d myobj.resultList.Insert(resultObj)
	.d resultObj.%Close()
	.d myobj.%Close()
	.s Xml=""
	.s ret=myobj.XMLExportToString(.Xml) //,"LisReportItem")
	.i ret=1 s retStr=retStr_Xml
	q retStr
}

}
