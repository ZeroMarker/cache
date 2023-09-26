Import sqluser

/// Descript:   急诊检验结果查看
/// Creator:    QQA 
/// CreateDate: 2017-11-28
Class web.DHCAPPSeePatLis Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Descript: 标本列表
/// w ##class(web.DHCAPPSeePatLis).JsonQryOrdList("1","60","^3161705^2017-12-4^2018-1-3^^0^^^6^0^^^^Y^^")
ClassMethod JsonQryOrdList(page As %String, rows As %String, Params As %String)
{
	
	s Start=page-1*rows+1
	s End=page*rows
	s EpisodeID= -1   //-1 查询全部
	s AdmDr = $p(Params,"^",1)
	s:AdmDr'="" PatientID = $p(^PAADM(AdmDr),"^",1)
	s PatientID=$p(Params,"^",2)
	;s:RegNo'="" PatientID = $o(^PAPERi("PAPMI_PatNo",RegNo,""))
	s FromDate=$p(Params,"^",3)
	s:FromDate'="" FromDate= ##class(web.DHCEMCommonUtil).DateHtmlToLogical(FromDate)
	s:FromDate'="" FromDate = ..%ZD(FromDate)
	s ToDate=$p(Params,"^",4)
	s:ToDate'="" ToDate= ##class(web.DHCEMCommonUtil).DateHtmlToLogical(ToDate)
	s:ToDate'="" ToDate = ..%ZD(ToDate)
	s LocCode=$p(Params,"^",5)
	s AuthFlag=$p(Params,"^",6)
	s AllTS=$p(Params,"^",7)
	s AdmDateFlag=$p(Params,"^",8)
	s UserId=$p(Params,"^",9)
	s fReadFlag=$p(Params,"^",10)
	s fRegNo=$p(Params,"^",11)
	s fLocationDR=$p(Params,"^",12)
	s fWardDR=$p(Params,"^",13)
	s fPrintFlag=$p(Params,"^",14)
	s ARCICatDr = $p(Params,"^",15)
	s AdmType = $p(Params,"^",16)

	s Pid = ##Class(web.DHCAPPExaRepCom).NewPid()
	k ^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",Pid)   
	Set result=##class(%Library.ResultSet).%New("DHCLIS.DHCOrderList:QueryOrderList")
	Set sc=result.Execute(EpisodeID, PatientID, FromDate, ToDate, LocCode, AuthFlag, AllTS, AdmDateFlag, UserId, fReadFlag, fRegNo, fLocationDR, fWardDR, fPrintFlag,"")
	If $$$ISERR(sc) Quit ""

	Set colNum=result.GetColumnCount() //列数

	Set EmPatLevTotal=0,EmPatLevCnt1=0,EmPatLevCnt2=0,EmPatLevCnt3=0,EmPatLevNotCnt=0
	Write ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal() //输出json前缀串

	s Num=0
	While(result.Next())
	{ 
		Set ret=0
		For i=1:1:colNum Do
		.s:ret'=0 ret=ret_"^"_$P(result.%GetData(i),$C(13,10))
		.s:ret=0 ret = $P(result.%GetData(i),$C(13,10))
		s readFlag=$p(ret,"^",20)
		s labNo=$p(ret,"^",6)
		s Num=Num+1
		s ^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",Pid,+readFlag,labNo,Num)=ret   //按照是否阅读排序 1：阅读，其他：未阅读
	 }

	
	Set count = 0,del="""",tmp=""
	s retColName="VisitNumberReportDR^OEOrdItemID^OrdItemName^ReqDateTime^ResultStatus"
	s retColName=retColName_"^LabEpisode^LabTestSetRow^OrdSpecimen^SpecDateTime^RecDateTime"
	s retColName=retColName_"^AuthDateTime^PreReport^WarnComm^TSResultAnomaly^TSMemo^AdmNo"
	s retColName=retColName_"^AdmDate^AdmLoc^AdmType^ReadFlag^PrintFlag^StatusDesc^ReceiveNotes"
	s retColName=retColName_"^MajorConclusion^HasMC^HasMid^HasBic"
	s readFlag=""
	f  s readFlag = $o(^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",Pid,readFlag)) q:readFlag=""  d
	.s labNo=""
	.f  s labNo = $o(^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",Pid,readFlag,labNo)) q:labNo=""  d
	..s Num=""
	..f  s Num = $o(^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",Pid,readFlag,labNo,Num)) q:Num=""  d
	...s rsData  = ^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",Pid,+readFlag,labNo,Num)
	...s OEORIDr = $p(rsData,"^",2)
	...s ARCICatInfo = ##class(web.DHCEMInComUseMethod).GetARCICatByOEORDItmDr(OEORIDr)
	...q:(ARCICatDr'="")&&(+ARCICatInfo'[ARCICatDr)
	...s count=count+1
	...q:count<Start
	...q:count>End
	...w $case(count,Start:"",:",")
	...w ##Class(web.DHCAPPJsonCommon).getJsonData(retColName,rsData)
	
	 
	 w "]"
	 w ","_del_"total"_del_":"_count
	 w "}"
	 Do result.Close()
	 k ^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",Pid) 
	 Quit ""
}

/*/// Descript: 标本列表
/// w ##class(web.DHCAPPSeePatLis).JsonQryOrdListNew(1,60,"","","54^61^03/03/2020^02/04/2020^^0^^^10209^0^^^^Y^^^-1^")
ClassMethod JsonQryOrdListNew(page As %String, rows As %String, sort As %String, order As %String, Params As %String)
{
	
	s ^tempqujina("Sort")=page_","_rows_","_sort_","_order_","_Params
	s Start=page-1*rows+1
	s End=page*rows
	s AdmDr = $p(Params,"^",1)
	s PatientID=$p(Params,"^",2)
	s FromDate=$p(Params,"^",3)
	s:FromDate'="" FromDate= ##class(web.DHCEMCommonUtil).DateHtmlToLogical(FromDate)
	s:FromDate="" FromDate=..%SysDate()-365
	s:FromDate'="" FromDate = ..%ZD(FromDate)
	s ToDate=$p(Params,"^",4)
	s:ToDate'="" ToDate= ##class(web.DHCEMCommonUtil).DateHtmlToLogical(ToDate)
	s:ToDate="" ToDate=..%SysDate()
	s:ToDate'="" ToDate = ..%ZD(ToDate)
	s LocCode=$p(Params,"^",5)
	s AuthFlag=$p(Params,"^",6)
	s AllTS=$p(Params,"^",7)
	s AdmDateFlag=$p(Params,"^",8)
	s UserId=$p(Params,"^",9)
	s fReadFlag=$p(Params,"^",10)
	s fRegNo=$p(Params,"^",11)
	s fLocationDR=$p(Params,"^",12)
	s fWardDR=$p(Params,"^",13)
	s fPrintFlag=$p(Params,"^",14)
	s ARCICatDr = $p(Params,"^",15)
	s AdmType = $p(Params,"^",16)
	s DateOrdVal = $p(Params,"^",17)
	s OEORIID = $p(Params,"^",18)
	s:+DateOrdVal=0 DateOrdVal=-1 

	s Pid = ##Class(web.DHCAPPExaRepCom).NewPid()
	k ^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",Pid)   
	Write ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal() //输出json前缀串

	s AdmStDate="",AdmToDate=""
	s:FromDate'="" AdmStDate = $zdh(FromDate,3)
	s:ToDate'="" AdmToDate = $zdh(ToDate,3)
	s:AdmDr="" AdmStr = ##class(web.DHCAPPSeePatLis).GetAdmStrByPatID(PatientID,AdmType,"","")
	s:AdmDr'="" AdmStr = AdmDr
	s AdmLen = $l(AdmStr,"^"),Num=0
	
	w:AdmStr="" ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(0)
	q:AdmStr="" ""
	
	f bs=1:1:AdmLen d
	.s EpisodeID = $p(AdmStr,"^",bs)
	.d SetPatLisData    //通过临时globle获取数据
	Set count = 0,del="""",tmp=""
	s retColName="PatName^PatSex^PatAge^PortUrl^ARCIMId^VisitNumberReportDR^OEOrdItemID^OrdItemName^ReqDateTime^ResultStatus"
	s retColName=retColName_"^LabEpisode^LabTestSetRow^OrdSpecimen^SpecDateTime^RecDateTime"
	s retColName=retColName_"^AuthDateTime^PreReport^WarnComm^TSResultAnomaly^TSMemo^AdmNo"
	s retColName=retColName_"^AdmDate^AdmLoc^AdmType^ReadFlag^PrintFlag^StatusDesc^ReceiveNotes"
	s retColName=retColName_"^MajorConclusion^HasMC^HasMid^HasBic^RepFlag^ManualState^OrdSpecimenCode^OrderNote"
	s SortNum=""
	if (order="desc") {s orderpg="-1"}else{  s orderpg="1"}
	if (order="") s orderpg="-1"
	for {
		s SortNum=$o(^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",SortNum),orderpg)
		q:SortNum="" 
		s orderByPort=""
		f  s orderByPort = $o(^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",SortNum,Pid,orderByPort),-1) q:orderByPort=""  d
		.s portDate="" 
		.f  s portDate = $o(^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",SortNum, Pid,orderByPort,portDate),DateOrdVal) q:portDate=""  d
		..s portTime=""
		..f  s portTime = $o(^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",SortNum ,Pid,orderByPort,portDate,portTime),DateOrdVal) q:portTime=""  d
		...s labNo=""
		...f  s labNo = $o(^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",SortNum ,Pid,orderByPort,portDate,portTime,labNo)) q:labNo=""  d
		....s Num=""
		....f  s Num = $o(^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",SortNum ,Pid,orderByPort,portDate,portTime,labNo,Num)) q:Num=""  d
		.....s rsData  = ^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",SortNum , Pid,orderByPort,portDate,portTime,labNo,Num)
		.....q:(portDate'=0)&(portDate<AdmStDate)
		.....q:(portDate'=0)&(portDate>AdmToDate)
		.....s VisitNumberReportDR = $p(rsData,"^",1)
		.....s OEORIDrs = $p(rsData,"^",2)
		.....s OEORIDr = $p(OEORIDrs,",",1)
		.....q:'$d(^OEORD(+OEORIDr))
		.....s PortUrl = ##class(web.DHCAPPInterface).GetPacsPortUrlByOrd(OEORIDrs,"",1)
		.....q:(OEORIID'="")&&(OEORIDrs'[OEORIID)
		.....s PaAdm = $p(^OEORD(+OEORIDr),"^",1)
		.....s PatientID  = $p(^PAADM(PaAdm),"^",1)
		.....s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)   /// 病人姓名
		.....	
		.....s PatSex=""
		.....s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)     /// 性别
		.....i SexId'="" s PatSex=$p(^CT("SEX",SexId),"^",2)
		.....s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID)  /// 年龄
		.....s ARCIMId=$p($g(^OEORD(+OEORIDr,"I",$P(OEORIDr,"||",2),1)),"^",2)
		.....s rsData = PatName_"^"_PatSex_"^"_PatAge_"^"_PortUrl_"^"_ARCIMId_"^"_rsData
		.....s SpecDr=$o(^OEORD(+OEORIDrs,"I",$p(OEORIDrs,"||",2),"SPEC",""),-1)
		.....s SpecCode=""
		.....i $l(SpecDr) s SpecCode=$p(^OEORD(+OEORIDrs,"I",$p(OEORIDrs,"||",2),"SPEC",SpecDr),"^",1)
		.....s rsData=rsData_"^"_SpecCode
		.....s depProcNotes = ""  ;备注 OEORI_DepProcNotes
		
		.....s depProcNotesIndex = 0
		.....f  s depProcNotesIndex=$o(^OEORD(+OEORIDrs,"I",$p(OEORIDrs,"||",2),"DEP",depProcNotesIndex)) q:depProcNotesIndex=""  d
		......s depProcNotesData=^OEORD(+OEORIDrs,"I",$p(OEORIDrs,"||",2),"DEP",depProcNotesIndex)
		......q:depProcNotesData=""
		......i depProcNotes="" s depProcNotes=depProcNotesData
		......else  s depProcNotes = depProcNotes_" "_depProcNotesData
		.....s rsData=rsData_"^"_depProcNotes
		.....s ARCICatInfo = ##class(web.DHCEMInComUseMethod).GetARCICatByOEORDItmDr(OEORIDr)
		.....q:(ARCICatDr'="")&&(+ARCICatInfo'[ARCICatDr)
		.....s count=count+1
		.....q:count<Start
		.....q:count>End
		.....w $case(count,Start:"",:",")
		.....w ##Class(web.DHCAPPJsonCommon).getJsonData(retColName,rsData)
	}
	k ^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",Pid)
	w ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(count)
	Do result1.Close()
	Quit ""
SetPatLisData
	Set result1=##class(%Library.ResultSet).%New("web.DHCAPPSeePatLis:QueryOrderList")
	//Set result=##class(%Library.ResultSet).%New("DHCLIS.DHCOrderList:QueryOrderList")
	Set sc1=result1.Execute(EpisodeID, PatientID, FromDate, ToDate, LocCode, AuthFlag, AllTS, AdmDateFlag, UserId, fReadFlag, fRegNo, fLocationDR, fWardDR, fPrintFlag,"")
	If $$$ISERR(sc1) Quit ""
	Set colNum=result1.GetColumnCount() //列数
	s Num=0
	While(result1.Next())
	{ 
		Set ret=0
		For i=1:1:colNum Do
		.s:ret'=0 ret=ret_"^"_$P(result1.%GetData(i),$C(13,10))
		.s:ret=0 ret = $P(result1.%GetData(i),$C(13,10))
		s readFlag=$p(ret,"^",20) //是否阅读
		s hasPort=$p(ret,"^",5)   //是否出报告
		s labNo=$p(ret,"^",6)     //检验号
		s portDateTime =$p(ret,"^",11) //检验出报告时间
		s portDate = $p(portDateTime," ",1) //日期
		s:portDate'="" portDate = $zdh(portDate,3)
		s portTime = $p(portDateTime," ",2) //时间
		s:portTime'="" portTime = ..%ZTH(portTime)
		s orderByPort=""
		s orderByPort = "A"_$case(hasPort,3:"1",:"")_+readFlag
		s SortNum=1
		if (sort'=""){
			if (sort="LabEpisode") s SortNum=+labNo
			if (sort="OrdItemName") s SortNum=$P(ret,"^",3)
			if (sort="AuthDateTime") s SortNum=$P(ret,"^",11)
			if (sort="ReqDateTime") s SortNum=$P(ret,"^",4)
		}else{
			s SortNum=$P(ret,"^",4)	
		}
		if SortNum="" s SortNum=1
		s Num=Num+1
		s ^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",SortNum,Pid,orderByPort,+portDate,+portTime,labNo,Num)=ret   //按照是否阅读排序 1：阅读，其他：未阅读
	 }
	 m ^Tempscl("JsonQryOrdList")=^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList")
	 Q
}*/
/// Descript: 标本列表
/// w ##class(web.DHCAPPSeePatLis).JsonQryOrdListOnly("1","60","^^2018-1-11^2018-1-14^^0^^^10611^0^^^^Y^^^-1^1")
ClassMethod JsonQryOrdListOnly(page As %String, rows As %String, Params As %String)
{
	
	s Start=page-1*rows+1
	s End=page*rows
	s EpisodeID= -1   //-1 查询全部
	s AdmDr = $p(Params,"^",1)
	s:AdmDr'="" PatientID = $p(^PAADM(AdmDr),"^",1)
	s PatientID=""
	s RegNo=$p(Params,"^",2)
	s:RegNo PatientID = ##class(web.DHCEMInComUseMethod).GetPatIDByRegNo(RegNo)
	;s:RegNo'="" PatientID = $o(^PAPERi("PAPMI_PatNo",RegNo,""))
	s FromDate=$p(Params,"^",3)
	s:FromDate'="" FromDate= ##class(web.DHCEMCommonUtil).DateHtmlToLogical(FromDate)
	s:FromDate'="" FromDate =..%ZD(FromDate)
	s ToDate=$p(Params,"^",4)
	s:ToDate'="" ToDate= ##class(web.DHCEMCommonUtil).DateHtmlToLogical(ToDate)
	s:ToDate'="" ToDate =..%ZD(ToDate)
	s LocCode=$p(Params,"^",5)
	s AuthFlag=$p(Params,"^",6)
	s AllTS=$p(Params,"^",7)
	s AdmDateFlag=$p(Params,"^",8)
	s UserId=$p(Params,"^",9)
	s fReadFlag=$p(Params,"^",10)
	s fRegNo=$p(Params,"^",11)
	s fLocationDR=$p(Params,"^",12)
	s fWardDR=$p(Params,"^",13)
	s fPrintFlag=$p(Params,"^",14)
	s ARCICatDr = $p(Params,"^",15)
	s AdmType = $p(Params,"^",16)
	s DateOrdVal = $p(Params,"^",17)
	s AdmLocID =$p(Params,"^",18)
	s:+DateOrdVal=0 DateOrdVal=-1 

	s Pid = ##Class(web.DHCAPPExaRepCom).NewPid()
	k ^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdListOnly")   
	Write ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal() //输出json前缀串

	s AdmStDate="",AdmToDate=""
	s:FromDate'="" AdmStDate = ..%ZDH(FromDate) ; $zdh(FromDate,3)
	s:ToDate'="" AdmToDate = ..%ZDH(ToDate)
	s AdmStr = ##class(web.DHCEMInComUseMethod).GetAdmStrByPatOrLocID(PatientID,AdmLocID,AdmType,AdmStDate,AdmToDate)
	s AdmLen = $l(AdmStr,"^"),Num=0
	
	w:AdmStr="" ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(0)
	q:AdmStr="" ""
	
	f bs=1:1:AdmLen d
	.s EpisodeID = $p(AdmStr,"^",bs)
	.d SetPatLisDataOnly    //通过临时globle获取数据
	
	Set count = 0,del="""",tmp=""
	s retColName="VisitNumberReportDR^OEOrdItemID^OrdItemName^ReqDateTime^ResultStatus"
	s retColName=retColName_"^LabEpisode^LabTestSetRow^OrdSpecimen^SpecDateTime^RecDateTime"
	s retColName=retColName_"^AuthDateTime^PreReport^WarnComm^TSResultAnomaly^TSMemo^AdmNo"
	s retColName=retColName_"^AdmDate^AdmLoc^AdmType^ReadFlag^PrintFlag^StatusDesc^ReceiveNotes"
	s retColName=retColName_"^MajorConclusion^HasMC^HasMid^HasBic^PatName^PatSex^PatAge^PatNo"	//qunianpeng 2018/2/27 输出增加HasBic字段(原因：输出字段个数和数据个数不匹配)

	s reqDate="" 
	f  s reqDate = $o(^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdListOnly",Pid,reqDate),DateOrdVal) q:reqDate=""  d
	.s portFlag=""
	.f  s portFlag = $o(^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdListOnly",Pid,reqDate,portFlag)) q:portFlag=""  d
	..s readFlag=""
	..f  s readFlag = $o(^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdListOnly",Pid,reqDate,portFlag,readFlag)) q:readFlag=""  d
	...s labNo=""
	...f  s labNo = $o(^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdListOnly",Pid,reqDate,portFlag,readFlag,labNo)) q:labNo=""  d
	....s Num=""
	....f  s Num = $o(^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdListOnly",Pid,reqDate,portFlag,readFlag,labNo,Num)) q:Num=""  d
	.....s rsData  = ^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdListOnly",Pid,reqDate,portFlag,+readFlag,labNo,Num)
	.....s OEORIDr = $p(rsData,"^",2)
	.....
	.....s PaAdm = $p($g(^OEORD(+OEORIDr)),"^",1)
	.....q:+PaAdm=0
	.....s PatientID  = $p(^PAADM(PaAdm),"^",1)
	.....s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)   /// 病人姓名
	.....s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)   ///登记号	
	.....s PatSex=""
	.....s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)     /// 性别
	.....i SexId'="" s PatSex=$p(^CT("SEX",SexId),"^",2)
	.....s PatAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID)
	.....s rsData = rsData_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatNo
	.....s ARCICatInfo = ##class(web.DHCEMInComUseMethod).GetARCICatByOEORDItmDr(OEORIDr)
	.....q:(ARCICatDr'="")&&(+ARCICatInfo'[ARCICatDr)
	.....s count=count+1
	.....q:count<Start
	.....q:count>End
	.....w $case(count,Start:"",:",")
	.....w ##Class(web.DHCAPPJsonCommon).getJsonData(retColName,rsData)
	
	w ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(count)
	Do result.Close()
	Quit ""
SetPatLisDataOnly
	Set result=##class(%Library.ResultSet).%New("DHCLIS.DHCOrderList:QueryOrderList")
	Set sc=result.Execute(EpisodeID, PatientID, FromDate, ToDate, LocCode, AuthFlag, AllTS, AdmDateFlag, UserId, fReadFlag, fRegNo, fLocationDR, fWardDR, fPrintFlag,"")
	If $$$ISERR(sc) Quit ""
	Set colNum=result.GetColumnCount() //列数

	s Num=0
	While(result.Next())
	{ 
		Set ret=0
		For i=1:1:colNum Do
		.s:ret'=0 ret=ret_"^"_$P(result.%GetData(i),$C(13,10))
		.s:ret=0 ret = $P(result.%GetData(i),$C(13,10))
	
		s readFlag=$p(ret,"^",20) //是否阅读
		s labNo=$p(ret,"^",6)     //检验号
		s portFlag=""
		s hasPort=$p(ret,"^",5)   //是否审核
		s:hasPort=3 portFlag=1
		s:hasPort'=3 portFlag=2
		s reqDateTime =$p(ret,"^",4) //检验请求时间
		s reqDate = $p(reqDateTime," ",1)
		s:reqDate'="" reqDate =  ..%ZDH(reqDate)
		s Num=Num+1
		s ^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdListOnly",Pid,reqDate,+portFlag,+readFlag,labNo,Num)=ret   //按照是否阅读排序 1：阅读，其他：未阅读
	 }
}

/// Descript: 报告结果
/// w ##class(web.DHCAPPSeePatLis).JsonQryTSInfo("1","6","",0)
ClassMethod JsonQryTSInfo(page As %String, rows As %String, ReportDR As %String, showType As %String)
{
	s ^tempqujian("JsonQryTSInfo")=page_","_rows_","_ReportDR_","_showType
	;s Start=page-1*rows+1
	;s End=page*rows
	w:ReportDR="" ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal() //输出json前缀串
	w:ReportDR="" ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(0)
	q:ReportDR="" "" 
	
	//Set result=##class(%Library.ResultSet).%New("LIS.WS.BLL.DHCRPVisitNumberReportResult:QryTSInfo")
	Set result=##class(%Library.ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:QryTSInfo")
	Set sc=result.Execute(ReportDR)
	If $$$ISERR(sc) Quit ""
	
	Set colNum=result.GetColumnCount() //列数
	Set count = 0
	Set del=""""
	Set tmp=""
	Set EmPatLevTotal=0,EmPatLevCnt1=0,EmPatLevCnt2=0,EmPatLevCnt3=0,EmPatLevNotCnt=0
	Write ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal() //输出json前缀串
	While(result.Next())
	{ 
		Set ret=""
		For i=1:1:colNum Do
		.s resultData=$tr($P(result.%GetData(i),$C(13,10)),$c(34),"")
		.s resultData=##class(web.DHCDocUtil).EvalJSON(resultData)
		.If ret="" Set ret=del_result.GetColumnName(i)_del_":"_del_resultData_del
		.Else   Set ret=ret_","_del_result.GetColumnName(i)_del_":"_del_resultData_del
	
		s retObj = ##class(%DynamicAbstractObject).%FromJSON("{"_ret_"}")
		continue:(showType=1)&(retObj.AbFlag="")
		Set count = count+1
		If count=1 Write "{"_ret_"}"
		Else  Write ",{"_ret_"}"
	 }
	 w "]"
	 w ","_del_"total"_del_":"_count
	 w "}"
	 Do result.Close()
	 Quit ""
}

/// 传病人就诊ID
/// w ##class(web.DHCAPPSeePatLis).GetAdmInfoByAdm("1370")
ClassMethod GetAdmInfoByAdm(EpisodeID As %String)
{

	q:EpisodeID="" ""
	s PatDr = $p(^PAADM(EpisodeID),"^",1)
	s EmRegDate=""
	s EmRegDate=$p(^PAADM(EpisodeID),"^",6)    	/// 登记日期
	s:EmRegDate'="" EmRegDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(EmRegDate) //hxy 
	s EmRegTime=""
	s EmRegTime=$p(^PAADM(EpisodeID),"^",7)    	/// 登记时间
	s:EmRegTime'="" EmRegTime=..%ZT(EmRegTime,2)
	///由于医生修改病人分级是按照就诊走的这里取出医生对病人分级
	s DocCheckInfo = ##class(web.DHCEMECheck).GetDocCheckLev(EpisodeID)
	s EmPatCheckLevId = ##class(web.DHCEMECheck).GetEmPatCheckLevDr(EpisodeID)
	s PatInfo=""
	s PatInfo=##class(web.DHCEMECheck).GetPatInfoByPatId(PatDr)
	s AdmInfoObj=##class(web.DHCEMObsRoomSeat).GetAdmInfo(EpisodeID)
	s WardDr = AdmInfoObj.WardDr 
	s WardDesc = AdmInfoObj.WardDesc
	s QueDepDr = AdmInfoObj.QueDepDr   //就诊科室
	s QueDepDesc = AdmInfoObj.QueDepDesc 
	s QueDocDr = AdmInfoObj.QueDocDr   //就诊医生
	s QueDocDesc = AdmInfoObj.QueDocDesc
	s MRDiagnos=AdmInfoObj.MRDiagnos
	s DateSetting  = ##class(web.DHCEMCommonUtil).DateFormat()
	s PatInfo = $replace(PatInfo,"^","#")
	s rsData =PatInfo_"#"_EmRegDate_"#"_EmRegTime_"#"_EmPatCheckLevId
	s rsData =rsData_"#"_WardDr_"#"_WardDesc_"#"_QueDepDr_"#"_QueDepDesc_"#"_QueDocDr
	s rsData =rsData_"#"_QueDocDesc_"#"_MRDiagnos_"#"_DateSetting
	s str="PatNo#PatName#PatSex#PatAge#birthday#IdentNo"
	s str=str_"#"_"PatNation#PatCountry#PatTelH#Address#BillType"
	s str=str_"#"_"PatCardNo#CardTypeID#EmRegDate#EmRegTime#EmPCLvID"
	s str=str_"#"_"WardDr#WardDesc#QueDepDr#QueDepDesc#QueDocDr"
	s str=str_"#QueDocDesc#MRDiagnos#DateSetting"
	w ##class(web.DHCAPPJsonCommon).getJsonData(str,rsData,"#")
	q ""
}

/// 检验下所有的子类
/// w ##class(web.DHCAPPSeePatLis).JsonListArciCat()
ClassMethod JsonListArciCat(HospitalID As %String = "")
{
	s HospitalID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospitalID)
	Set langid=..%LanguageID()
	s Count=0
	w "["
	s ARCICatDr=""
	f  s ARCICatDr = $o(^ARC("IC",ARCICatDr)) q:ARCICatDr=""  d
	.s RsData=""
	.s ARCICatDesc = $p(^ARC("IC",ARCICatDr),"^",2)
	.s OrderType=$P(^ARC("IC",ARCICatDr),"^",7)
	.q:OrderType'="L"
	.s ARCICatDesc=##class(User.ARCItemCat).GetTranByDesc("ARCICDesc",ARCICatDesc,langid)
	.Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItemCat",ARCICatDr,HospitalID)="N"
	.s RsData = ARCICatDr_"^"_ARCICatDesc
	.w $case(Count,0:"",:",")
	.s Count=Count+1
	.w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",RsData)
	w "]"
	q ""
}

/// 获取阅读记录
/// w ##class(web.DHCAPPSeePatLis).JsonGetReadRecord(1,6,16044)
ClassMethod JsonGetReadRecord(page, rows, ReportDR)
{
	s Start=page-1*rows+1
	s End=page*rows
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	w:ReportDR="" ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(0)
	q:ReportDR="" ""
	s Count=0
	s DataStr = "ReadDate^ReadTime^ReadDoctorName^ReadNotes"
	s ReadDate=""
	f  s ReadDate = $o(^dbo.RPVisitNumberReportReadI("IndexMaster",ReportDR,ReadDate),-1) q:ReadDate=""  d
	.s ReadTime=""
	.f  s ReadTime = $o(^dbo.RPVisitNumberReportReadI("IndexMaster",ReportDR,ReadDate,ReadTime),-1) q:ReadTime=""  d
	..s ReportReadDR = $o(^dbo.RPVisitNumberReportReadI("IndexMaster",ReportDR,ReadDate,ReadTime,""))
	..s ReadDoctorDR = $lg(^dbo.RPVisitNumberReportReadD(ReportReadDR),5)
	..s ReadNotes = $lg(^dbo.RPVisitNumberReportReadD(ReportReadDR),6)
	..s ReadDoctorName=""
	..i $l(ReadDoctorDR) s ReadDoctorName = $lg(^dbo.BTDoctorD(ReadDoctorDR),3)
	..s ReadDateDesc="",ReadTimeDesc=""
	..s:ReadDate'="" ReadDateDesc=$e(ReadDate,1,4)_"-"_$e(ReadDate,5,6)_"-"_$e(ReadDate,7,8)
	..s:ReadTime'="" ReadTimeDesc= ..%ZT(ReadTime,2)
	..s Data = ReadDateDesc_"^"_ReadTimeDesc_"^"_ReadDoctorName_"^"_ReadNotes
	..s Count=Count+1
	..q:Count<Start
	..q:Count>End
	..w $case(Count,Start:"",:",")
	..w ##class(web.DHCAPPJsonCommon).getJsonData(DataStr,Data)
	w ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(Count)
	q ""
}

/// /w ##class(web.DHCAPPSeePatLis).JsonGetPrtRecord(1,6,10)
ClassMethod JsonGetPrtRecord(page, rows, ReportDR)
{
	s Start=page-1*rows+1
	s End=page*rows
	s Count=0
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	w:ReportDR="" ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(0)
	q:ReportDR="" ""
	s DataStr = "PrtDate^PrtTime^PrtDoctorName"
	s PrintDate =""
	f  s PrintDate  = $o(^dbo.RPVisitNumberReportPrintI("IndexMaster",ReportDR,PrintDate),-1) q:PrintDate=""  d
	.s PrintTime="" 
	.f  s PrintTime = $o(^dbo.RPVisitNumberReportPrintI("IndexMaster",ReportDR,PrintDate,PrintTime),-1) q:PrintTime=""  d
	..s ReportPrintDR = $o(^dbo.RPVisitNumberReportPrintI("IndexMaster",ReportDR,PrintDate,PrintTime,""))
	..s PrintedUserName=""
	..S PrintUserDR = $lg(^dbo.RPVisitNumberReportPrintD(ReportPrintDR),5)
	..i $l(PrintUserDR) s PrintedUserName = $lg(^dbo.SYSUserD(PrintUserDR),3)
	..s ModuleID = $lg(^dbo.RPVisitNumberReportPrintD(ReportPrintDR),6)
	..s IPAdress = $lg(^dbo.RPVisitNumberReportPrintD(ReportPrintDR),7)
	..s PrintDateDesc="",PrintTimeDesc=""
	..s:PrintDate'="" PrintDateDesc=$e(PrintDate,1,4)_"-"_$e(PrintDate,5,6)_"-"_$e(PrintDate,7,8)
	..s:PrintTime'="" PrintTimeDesc= ..%ZT(PrintTime,2)
	..s Data = PrintDateDesc_"^"_PrintTimeDesc_"^"_PrintedUserName
	..s Count=Count+1
	..q:Count<Start
	..q:Count>End
	..w $case(Count,Start:"",:",")
	..w ##class(web.DHCAPPJsonCommon).getJsonData(DataStr,Data)
	w ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(Count)			
	q ""
}

/// 获取设置了位置的科室
/// w ##class(web.DHCAPPSeePatLis).GetPositonLocList("","")
ClassMethod GetPositonLocList(AdmType, CTLOCRowID)
{

	s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
	s ADMLOCRowId=0,Count=0
	W "["
	for 
	{
	s ADMLOCRowId=$o(^PAC("ADMLOC",ADMLOCRowId)) q:ADMLOCRowId=""
	s ADMLOCCTLOCDR=""
	s ADMLOCCTLOCDR=$p($g(^PAC("ADMLOC",ADMLOCRowId)),"^",2)
	s HospitalDR=$p($g(^CTLOC(ADMLOCCTLOCDR)),"^",22) 
	s strHospitalID = "{ID:"_HospitalDR_"}"
		if ((AuHospStr[strHospitalID)||(AuHospStr=1)||(AuHospStr="off")) {  
		s ADMLOCAdmType=$p($g(^PAC("ADMLOC",ADMLOCRowId)),"^",1) 
		s ADMLOCCTLOCDR=$p($g(^PAC("ADMLOC",ADMLOCRowId)),"^",2)
		s ADMLOCCTLOCDesc=""
		s:ADMLOCCTLOCDR'="" ADMLOCCTLOCDesc=$p($g(^CTLOC(ADMLOCCTLOCDR)),"^",2) //获取科室描述 
		s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
		s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_AdmTypeLocation",ADMLOCRowId)
		s BDPInternalCode =$p($g(resultStr),"^",1)       
		s BDPInternalDesc = $p($g(resultStr),"^",2)  
		s BDPHospNationalCode=$p($g(resultStr),"^",3)         
		s BDPHospNationalDesc = $p($g(resultStr),"^",4)
			if ((ADMLOCAdmType=AdmType)||(AdmType=""))&((ADMLOCCTLOCDR=CTLOCRowID)||(CTLOCRowID=""))
			{
			    w $case(Count,0:"",Count:",")
			    w ##Class(web.DHCAPPJsonCommon).getJsonData("value^text",ADMLOCCTLOCDR_"^"_ADMLOCCTLOCDesc)
			    s Count=Count+1
			}
		}
	}
	w "]"
    q ""
}

/// w ##class(web.DHCAPPSeePatLis).TestLis(50092282)
ClassMethod TestLis(EpisodeNo)
{
	s OrdId=""  f  s OrdId=$o(^OEORD(0,"Adm",EpisodeNo,OrdId)) q:OrdId=""  d
	.s SubId=""	f  s SubId=$o(^OEORD(OrdId,"I",SubId),-1) q:SubId=""  d
	..s OrdRowId=OrdId_"||"_SubId
	..s OrdStr1=$g(^OEORD(OrdId,"I",SubId,1))
	..s OrdStr3=$g(^OEORD(OrdId,"I",SubId,3))
	..s ItmMastDr=$p(OrdStr1,"^",2)
	..i '$l(ItmMastDr) q
	..i '##Class(web.DHCLabOrder).isLabTS(ItmMastDr) q
	..s OrdName=$p($g(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1)),"^",2)
	..//比较申请日期
	..s ReqDate=$p(OrdStr3,"^",7)
	..;i $l(ReqDate),$l(FromDate),ReqDate-FromDate<0 q
	..;i $l(ReqDate),$l(ToDate),ReqDate-ToDate>0 q
	..//检验号
	..s PlacerNo=$p(OrdStr3,"^",36)
	..s LabEpisode=$p(OrdStr3,"^",20) //优先取预制条码
	..i '$l(LabEpisode) q
	..//报告ID
	..s LabTestSetRow=$p(OrdStr3,"^",35)
	..s LabTestSetRow=$tr(LabTestSetRow,$c(0))
	..s ItmStat=$p(OrdStr1,"^",13)
	..i '$l(ItmStat) q
	..s WorkGroupMachineDR="NULL"
	..i ('$d(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(LabEpisode)))),($d(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(PlacerNo)))) s LabEpisode=PlacerNo
	..s VisitNumberDR=$o(^dbo.RPVisitNumberI("IndexVisitNumber",##Class(LIS.Util.Common).IndexData(LabEpisode),""))
	..i $l(LabTestSetRow) s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberTestSetD(LabTestSetRow)),5)
	..i '$l(WorkGroupMachineDR) s WorkGroupMachineDR="NULL"
	..//此处开始查询该组合套是否属于合报告处理
	..s TestSetDR="",IsGroupReport=0
	..s VisitnumberReportDR = ""
	..i $l(LabTestSetRow) s TestSetDR=$lg($g(^dbo.RPVisitNumberTestSetD(LabTestSetRow)),3) s VisitnumberReportDR=$lg($g(^dbo.RPVisitNumberTestSetD(LabTestSetRow)),11)
	..i $l(TestSetDR),$d(^dbo.BTTestSetOGTTGroupLinksI("IndexSubTestSetOGTTGroup",TestSetDR)) d
	...s TestSetOGTTGroupDR=$o(^dbo.BTTestSetOGTTGroupLinksI("IndexSubTestSetOGTTGroup",TestSetDR,""))
	...//i $d(^TMP($zn,$i,$j,"TestSetOGTTGroup",ReqDate,TestSetOGTTGroupDR)) S ^TMP($zn,$i,$j,"TestSetOGTTGroup",ReqDate,TestSetOGTTGroupDR,VisitNumberDR,WorkGroupMachineDR,TestSetDR)=$lb(LabEpisode) s IsGroupReport=1 q
	...S ^TMP($zn,$i,$j,"TestSetOGTTGroup",ReqDate,TestSetOGTTGroupDR,VisitNumberDR,WorkGroupMachineDR,TestSetDR)=$lb(LabEpisode,ItmMastDr)
	..
	..i '$l(WorkGroupMachineDR) s WorkGroupMachineDR="NULL"
	..i '$l(VisitnumberReportDR) s VisitnumberReportDR="NULL"
	..s ^TMP($zn,$i,$j,"LabNo",LabEpisode,ItmStat,WorkGroupMachineDR,VisitnumberReportDR,OrdRowId)=VisitNumberDR
	
	q ""
}

/// w ##class(web.DHCAPPSeePatLis).GetParams("")
ClassMethod GetParams(Params)
{

	s OEORIId = $p(Params,"^",1)
	s OEORIId = $P($P(OEORIId,"^",1),"@",1)
	s ConnectString = ##class(DHCLIS.DHCOrderList).GetConnectString("1")
	s WebIp = ##class(DHCLIS.DHCOrderList).getDllWebIP()
	s RegNolenght = ##class(web.DHCCLCom).GetPatConfig()
	s DateFormat = ##class(web.DHCEMCommonUtil).DateFormat()
	s OrdStDate = ##class(web.DHCAPPSeePatLis).GetOrdStDate(OEORIId)
	s Rs = ConnectString_"^"_WebIp_"^"_+RegNolenght_"^"_DateFormat_"^"_OrdStDate
	q Rs
}

ClassMethod GetOrdStDate(OEORIId)
{
	q:+OEORIId=0 ""
	s StDate=""
	s OrdInfo = ^OEORD(+OEORIId,"I",$p(OEORIId,"||",2),1)
	s StDate = $p(OrdInfo,"^",9)
	s StDate =  ##class(web.DHCEMCommonUtil).DateLogicalToHtml(StDate)
	q StDate
}

/// Creator:QQA
/// CreatDate:2018-03-08
/// Descript:报告阅读明细
/// Input:Params(医嘱ID,检查号)
/// w ##class(web.DHCEMInComUseMethod).ReadDetailByParams(1,6,"11||4,11||5^^")
ClassMethod ReadDetailByParams(page, rows, Params)
{
	s Start=page-1*rows+1
	s End=page*rows
	s OEORIId = $p($p(Params,"^",1),",",1)
	s StudyNo = $p(Params,"^",2)
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	w:OEORIId="" ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(0)
	q:OEORIId="" ""
	s Count=0
	s DataStr = "ReadDate^ReadTime^ReadDoctorName"
	s RREId=""
	f  s RREId = $o(^DHCAPPRRE(0,"IndexOrdItm",OEORIId,RREId)) q:(RREId="")  d
	.s RRELabNo = $p(^DHCAPPRRE(RREId),"^",2)
	.s RREUserDr = $p(^DHCAPPRRE(RREId),"^",4)
	.q:(StudyNo'="")&&(StudyNo'=RRELabNo)
	.s DDRReadDate = $p(^DHCAPPRRE(RREId),"^",5)
	.s DDRReadTime = $p(^DHCAPPRRE(RREId),"^",6)
	.s:DDRReadDate'="" DDRReadDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(DDRReadDate)
	.s:DDRReadTime'="" DDRReadTime = ..%ZT(DDRReadTime,2)
	.s DDRReadUserDesc=""
	.s DDRReadUserID = $p(^DHCAPPRRE(RREId),"^",4)
	.s:DDRReadUserID'="" DDRReadUserDesc=$p(^SSU("SSUSR",DDRReadUserID),"^",2)
	.s Data = DDRReadDate_"^"_DDRReadTime_"^"_DDRReadUserDesc
	.s Count=Count+1
	.q:Count<Start
	.q:Count>End
	.w $case(Count,Start:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData(DataStr,Data)
	w ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(Count)
	q ""
}

/*Query QueryOrderList(EpisodeID, PatientID, FromDate, ToDate, LocCode, AuthFlag, AllTS, AdmDateFlag, UserId, fReadFlag, fRegNo, fLocationDR, fWardDR, fPrintFlag, Sessions) As %Query(ROWSPEC = "VisitNumberReportDR,OEOrdItemID,OrdItemName,ReqDateTime,ResultStatus,LabEpisode,LabTestSetRow,OrdSpecimen,SpecDateTime,RecDateTime,AuthDateTime,PreReport,WarnComm,TSResultAnomaly,TSMemo,AdmNo,AdmDate,AdmLoc,AdmType,ReadFlag,PrintFlag,StatusDesc,ReceiveNotes,MajorConclusion,HasMC,HasMid,HasBic,RepFlag,ManualState")
{
}

/// Others：  d ##Class(%ResultSet).RunQuery("web.DHCAPPSeePatLis","QueryOrderList","108","89","2019-09-25","2019-10-25","","0","","","10209","0","","","","Y","")     
ClassMethod QueryOrderListExecute(ByRef qHandle As %Binary, EpisodeID, PatientID, FromDate, ToDate, LocCode, AuthFlag, AllTS, AdmDateFlag, UserId, fReadFlag, fRegNo, fLocationDR, fWardDR, fPrintFlag, Sessions) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^tempqujian("QueryOrderList") = $lb(EpisodeID, PatientID, FromDate, ToDate, LocCode, AuthFlag, AllTS, AdmDateFlag, UserId, fReadFlag, fRegNo, fLocationDR, fWardDR, fPrintFlag, Sessions)
	i $l(FromDate) s FromDate=$zdh(FromDate,3)
	i $l(ToDate) S ToDate=$zdh(ToDate,3)
	s UserId=$g(UserId)
	//科室
	s LocCode=$g(LocCode)
	i $l(LocCode) s LocId=$o(^CTLOC(0,"Code",LocCode,""),-1)
	//是否审核
	s AuthFlag=$g(AuthFlag)
	//所有医嘱
	s AllTS=$g(AllTS)
	i '$l(AllTS) s AllTS="N"
	//就诊日期范围  1:三月 2:半年 3:一年 4:所有
	s AdmDateFlag=$g(AdmDateFlag)
	///是否打印
	s fPrintFlag=$g(fPrintFlag)
	i fPrintFlag="N" s AuthFlag=1  ///
	///全部就诊
	i EpisodeID="-1" s EpisodeID=""
		
	k ^TMP($zn,$i,$j)
	k ^TMP($zn,repid,$j)
	i $l(EpisodeID) d GetOrderByEpisode(EpisodeID)

	i '$l(EpisodeID),$l(PatientID) d
	.s type="" f  s type=$o(^PAPERdr(PatientID,"ADM",type)) q:type=""  d
	..s ADMId="" f  s ADMId=$o(^PAPERdr(PatientID,"ADM",type,ADMId),-1) q:ADMId=""  d
	...s AdmLoc=$p(^PAADM(ADMId),"^",4)
	...s AdmDate=$p(^PAADM(ADMId),"^",6)
	...///日期范围
	...i AdmDateFlag="1",(+$H-AdmDate)>90 Q
	...i AdmDateFlag="2",(+$H-AdmDate)>182 Q
	...i AdmDateFlag="3",(+$H-AdmDate)>365 Q
	...i $l(LocCode),LocCode'=AdmLoc q
	...d GetOrderByEpisode(ADMId)
	
	Set qHandle=$lb(0,repid,0)
	k ^TMP($zn,repid,$j)
	k ^TMP($zn,$i,$j)
	Quit $$$OK
	
GetOrderByEpisode(EpisodeNo)
	s OrdId=""  f  {
		s OrdId=$o(^OEORD(0,"Adm",EpisodeNo,OrdId)) 
		q:OrdId=""  
		s SubId=""	f {
			s SubId=$o(^OEORD(OrdId,"I",SubId),-1)
		 	q:SubId=""  
			s OrdRowId=OrdId_"||"_SubId
			s OrdStr1=$g(^OEORD(OrdId,"I",SubId,1))
			s OrdStr3=$g(^OEORD(OrdId,"I",SubId,3))
			s ItmMastDr=$p(OrdStr1,"^",2)
			i '$l(ItmMastDr) continue
			i '##Class(web.DHCLabOrder).isLabTS(ItmMastDr) continue
			s OrdName=$p($g(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1)),"^",2)
			//比较申请日期
			s ReqDate=$p(OrdStr3,"^",7)
			i $l(ReqDate),$l(FromDate),ReqDate-FromDate<0 continue
			i $l(ReqDate),$l(ToDate),ReqDate-ToDate>0 continue
			//检验号
			s PlacerNo=$p(OrdStr3,"^",36)
			s LabEpisode=$p(OrdStr3,"^",20) //优先取预制条码
			i '$l(LabEpisode) continue
			//报告ID
			s LabTestSetRow=$p(OrdStr3,"^",35)
			s LabTestSetRow=$tr(LabTestSetRow,$c(0))
			s stat=$p(^OEORD(OrdId,"I",SubId,1),"^",13)
			s StatusDesc="",StatusCode=""
			i stat'=""{
				s StatusDesc=$P(^OEC("OSTAT",stat),"^",2) 
				s StatusCode=$P(^OEC("OSTAT",stat),"^",1) 
			}
			continue:StatusCode="D"	//停止
			continue:StatusCode="U"	//作废
			continue:StatusCode="C"	//撤销
			//病人所属医院
			s Adm=$p(^OEORD(OrdId),"^",1),locCode="",HospID="",HospitalCode="",AdmLoc=""
			i $l(Adm),$d(^PAADM(Adm)) s locCode=$p(^PAADM(Adm),"^",4)
			i $l(locCode) s HospID=$p(^CTLOC(locCode),"^",22),AdmLoc=$p(^CTLOC(locCode),"^",2)
			i AdmLoc["-" s AdmLoc=$p(AdmLoc,"-",2)
			i $l(HospID) s HospitalCode=$p(^CT("HOSP",HospID),"^",1)
			//就诊日期
			s AdmDate=$p(^PAADM(Adm),"^",6)
			i $l(AdmDate) s AdmDate=..%ZD(AdmDate)
			s AdmType=$p(^PAADM(Adm),"^",2)
			i AdmType="O" s AdmType="门诊"
			i AdmType="I" s AdmType="住院"
			i AdmType="E" s AdmType="急诊"
			i AdmType="H" s AdmType="体检"
			s OrdStr1=$g(^OEORD(OrdId,"I",SubId,1))
			s OrdStr3=$g(^OEORD(OrdId,"I",SubId,3))
			s ItmMastDr=$p(OrdStr1,"^",2)
			s OrdName=$p($g(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1)),"^",2)
			s OrdRowIds=""
			i $l(OrdRowIds) s OrdRowIds=OrdRowIds_","_OrdRowId
			e  s OrdRowIds=OrdRowId
			s OrdNames=""
			i $l(OrdNames) s OrdNames=OrdNames_"+"_OrdName
			e  s OrdNames=OrdName
			//申请日期时间
			s ReqDate=$p(OrdStr3,"^",7)
			s ReqTime=$p(OrdStr1,"^",17)
			s OGTTGroupReqDate=ReqDate
			i $l(ReqDate) s ReqDate=..%ZD(ReqDate)
			i $l(ReqTime) s ReqTime=..%ZT(ReqTime)
			s ReqDateTime=ReqDate_" "_ReqTime
			s LabTestSetRow=$p(OrdStr3,"^",35)
			s LabTestSetRow=$tr(LabTestSetRow,$c(0))
			//标本类型
			s SpecDr=$o(^OEORD(OrdId,"I",SubId,"SPEC",""),-1)
			s (SpecCode,SpecName)=""
			i $l(SpecDr) s SpecCode=$p(^OEORD(OrdId,"I",SubId,"SPEC",SpecDr),"^",1)
			i $l(SpecCode) s SpecName=$p(##Class(DHCLIS.DHCCommon).GetSpecimen(SpecCode,HospitalCode),$c(2),2)
			//采集日期时间Collection
			s (SpecDate,SpecTime)=""
			s retval=##Class(web.DHCNurSpecerNo).GetspecCollDatetime(OrdRowId)
			i $l(retval)  d
			.s SpecDate=$p(retval,"^",2)
			.i $l(SpecDate) s SpecDate=..%ZD(SpecDate)
			.s SpecTime=$p(retval,"^",3)
			.i $l(SpecTime) s SpecTime=..%ZT(SpecTime)
			s SpecDateTime=SpecDate_" "_SpecTime
			s (RecDateTime,ResultStatus,AuthDateTime,ReportFlag,TransComm,TSResultAnomaly,TSMemo,ReceiveNotes,MajorConclusion)=""
			;s OutPutReportDR=##class(web.DHCENS.STBLL.Method.PostReportInfo).QryLISRptIDByLabNo(LabEpisode)
			s OutPutReportDR=##class(web.DHCENS.EnsHISService).DHCHisInterface("QryLISRptIDByLabNo",LabEpisode)
			;continue:OutPutReportDR=""
			Set result=##class(%Library.ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:QryTSInfo")
			Set sc=result.Execute(OutPutReportDR)
			Set colNum=result.GetColumnCount() //列数
			If $$$ISERR(sc) continue
			While(result.Next()){
				Set ret=""
				s ResultStatus="3"
				if ($g(result.Data("ReceiveDate"))'=""){
					s RecDateTime=$g(result.Data("ReceiveDate"))_" "_$g(result.Data("ReceiveTime")) //$ZD($g(result.Data("ReceiveDate")),3)_" "_..%ZT($g(result.Data("ReceiveTime")))
				}
				if ($g(result.Data("AuthDate"))'=""){
					s AuthDateTime=..%ZD($g(result.Data("AuthDate")))_" "_..%ZT($g(result.Data("AuthTime")))
				}
				s ReceiveNotes=$g(result.Data("ResNoes"))
				s MajorConclusion=$g(result.Data("MajorConclusion"))
				if ($g(result.Data("CollectionDate"))'=""){
					s SpecDateTime=..%ZD($g(result.Data("CollectionDate")))_" "_..%ZT($g(result.Data("CollectionTime")))
				}
				s RepStatus=$g(result.Data("RepStatus"))
				;s RepStatus=$case(RepStatus,"1":"审核","2":"取消审核","3":"作废")
				s TSMemo="【"_RepStatus_"】"
				s StatusDesc=RepStatus
			}
			s PrintFlag=""
			s ReadFlag=##class(web.DHCAPPInterface).IsReadByParams(OrdRowId_"^^")
			if ReadFlag="Y" s ReadFlag=1  else  s ReadFlag=0
			s HasMC="",HasMid="",HasBic="",RepFlag="",ManualState=""
			s Data=$lb(OutPutReportDR,OrdRowIds,OrdNames,ReqDateTime,ResultStatus,LabEpisode,LabTestSetRow,SpecName,SpecDateTime,RecDateTime,AuthDateTime,ReportFlag,TransComm,TSResultAnomaly,TSMemo,Adm,AdmDate,AdmLoc,AdmType,ReadFlag,PrintFlag,StatusDesc,ReceiveNotes,MajorConclusion,HasMC,HasMid,HasBic,RepFlag,ManualState)
			d OutputRow7
		}
	}
	q
OutputRow7	
	s iLen=$LISTLENGTH(Data)
	f i=1:1:iLen d
	.i '$ld(Data,i) s $LI(Data,i)=""
	.s $LI(Data,i)=$tr($LI(Data,i),$c(0))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryOrderListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrderListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryOrderListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrderListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}*/
/// Descript: 标本列表
/// w ##class(web.DHCAPPSeePatLis).JsonQryOrdListNew(1,60,"","","1775^749^06/10/2020^05/11/2020^^0^^^12175^0^^^^Y^^^-1^")
ClassMethod JsonQryOrdListNew(page As %String, rows As %String, sort As %String, order As %String, Params As %String)
{
	s ^tempqujina("Sort")=page_","_rows_","_sort_","_order_","_Params
	Set langid=..%LanguageID()
	s Start=page-1*rows+1
	s End=page*rows
	s AdmDr = $p(Params,"^",1)
	s PatientID=$p(Params,"^",2)
	s FromDate=$p(Params,"^",3)
	s:FromDate'="" FromDate= ##class(web.DHCEMCommonUtil).DateHtmlToLogical(FromDate)
	s:FromDate="" FromDate=..%SysDate()-365
	s:FromDate'="" FromDate = ..%ZD(FromDate)
	s ToDate=$p(Params,"^",4)
	s:ToDate'="" ToDate= ##class(web.DHCEMCommonUtil).DateHtmlToLogical(ToDate)
	s:ToDate="" ToDate=..%SysDate()
	s:ToDate'="" ToDate = ..%ZD(ToDate)
	s LocCode=$p(Params,"^",5)
	s AuthFlag=$p(Params,"^",6)
	s AllTS=$p(Params,"^",7)
	s AdmDateFlag=$p(Params,"^",8)
	s UserId=$p(Params,"^",9)
	s fReadFlag=$p(Params,"^",10)
	s fRegNo=$p(Params,"^",11)
	s fLocationDR=$p(Params,"^",12)
	s fWardDR=$p(Params,"^",13)
	s fPrintFlag=$p(Params,"^",14)
	s ARCICatDr = $p(Params,"^",15)
	s AdmType = $p(Params,"^",16)
	s DateOrdVal = $p(Params,"^",17)
	s OEORIID = $p(Params,"^",18)
	s ordResult = $p(Params,"^",19)
	s ArcItemRowid = $p(Params,"^",20)
	s FindLocID = $p(Params,"^",21) ;按照传入科室查询本科检验结果
	s bedNo = $p(Params,"^",22) ;床号
	s:+DateOrdVal=0 DateOrdVal=-1 

	s Pid = ##Class(web.DHCAPPExaRepCom).NewPid()
	k ^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",Pid)   
	Write ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal() //输出json前缀串
	
	s LocAdmStr=""
	if FindLocID'=""{
		s LocAdmStr = ##class(web.DHCAPPSeePatLis).GetLocAdmStr(FindLocID,bedNo)
	}
	s AdmStDate="",AdmToDate=""
	s:FromDate'="" AdmStDate =  ..%ZDH(FromDate)
	s:ToDate'="" AdmToDate =  ..%ZDH(ToDate)
	s:AdmDr="" AdmStr = ##class(web.DHCAPPSeePatLis).GetAdmStrByPatID(PatientID,AdmType,"","")
	s:AdmDr'="" AdmStr = AdmDr
	s:LocAdmStr'="" AdmStr = LocAdmStr
	s AdmLen = $l(AdmStr,"^"),Num=0
	
	w:AdmStr="" ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(0)
	q:AdmStr="" ""
	f bs=1:1:AdmLen d
	.s EpisodeID = $p(AdmStr,"^",bs)
	.d SetPatLisData    //通过临时globle获取数据
	Set count = 0,del="""",tmp=""
	s retColName="PatName^PatSex^PatAge^PortUrl^ARCIMId^VisitNumberReportDR^OEOrdItemID^OrdItemName^ReqDateTime^ResultStatus"
	s retColName=retColName_"^LabEpisode^LabTestSetRow^OrdSpecimen^SpecDateTime^RecDateTime"
	s retColName=retColName_"^AuthDateTime^PreReport^WarnComm^TSResultAnomaly^TSMemo^AdmNo"
	s retColName=retColName_"^AdmDate^AdmLoc^AdmType^ReadFlag^PrintFlag^StatusDesc^ReceiveNotes"
	s retColName=retColName_"^MajorConclusion^HasMC^HasMid^HasBic^RepFlag^ManualState^ReportStatus^ReportUrl^ExecStatus^ExecSequence^ForwardExecStatus^ForwardExecSequence^OrdSpecimenCode^OrderNote^InsureListviewFlag"
	s retColName=retColName_"^AdmBedNO^AdmRowId"
	if (order="desc") {s orderpg="-1"}else{  s orderpg="1"}
	if (order="") s orderpg="-1"
	b //45144
	s SortNum=""
	for {
		s SortNum=$o(^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",Pid,SortNum),orderpg) Q:SortNum=""
		s ReportID=""
		for {
			s ReportID=$o(^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",Pid,SortNum,ReportID)) Q:ReportID=""
			s orderByPort=""
			for {
				s orderByPort=$o(^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",Pid,SortNum,ReportID,orderByPort)) Q:orderByPort=""
				s portDateTime=""
				for {
					s portDateTime=$o(^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",Pid,SortNum,ReportID,orderByPort,portDateTime)) Q:portDateTime=""
					s rsData  = ^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",Pid,SortNum,ReportID,orderByPort,portDateTime) //Num
					s PortDateTime =$p(rsData,"^",11) //检验出报告时间
					s portDate = $p(PortDateTime," ",1) //日期
					s:portDate'="" portDate = ..%ZDH(portDate)
					continue:(+portDate'=0)&(portDate<AdmStDate)
					continue:(+portDate'=0)&(portDate>AdmToDate)
					s VisitNumberReportDR = $p(rsData,"^",1)
					s OEORIDrs = $p(rsData,"^",2)
					s OEORIDr = $p(OEORIDrs,",",1)
					continue:'$d(^OEORD(+OEORIDr))
					
					s ARCICatInfo = ##class(web.DHCEMInComUseMethod).GetARCICatByOEORDItmDr(OEORIDr)
					continue:(ARCICatDr'="")&&(+ARCICatInfo'[ARCICatDr)
					s PortUrl = ##class(web.DHCAPPInterface).GetPacsPortUrlByOrd(OEORIDrs,"",1)
					//continue:(OEORIID'="")&&(OEORIDrs'[OEORIID)
					continue:(OEORIID'="")&&(("@"_OEORIID_"@")'[("@"_OEORIDr_"@"))&&((","_OEORIDrs_",")'[(","_OEORIID_","))
					s PaAdm = $p(^OEORD(+OEORIDr),"^",1)
					s PatientID  = $p(^PAADM(PaAdm),"^",1)
					s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)   /// 病人姓名
						
					s PatSex=""
					s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)     /// 性别
					i (SexId'="") {
						s PatSex=$p(^CT("SEX",SexId),"^",2)
						s PatSex=##class(User.CTSex).GetTranByDesc("CTSEXDesc",PatSex,langid)
					}
					s PatAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,PaAdm)
					s PAAdmBedNO=""
					s PAADMBedDR = ##class(Nur.Interface.OutSide.Patient).GetBedId(PaAdm)
					if (PAADMBedDR '= ""){
						s WARDRowID = $p(PAADMBedDR,"||",1)
						s BEDChildsub = $p(PAADMBedDR,"||",2)
						s BEDRoomDR = $p($g(^PAWARD(WARDRowID,"BED",BEDChildsub)),"^",3)
						// 病房
						s PAAdmRoom = $p($g(^PAROOM(BEDRoomDR)),"^",2)
						s PAAdmBedNO = $p($g(^PAWARD(WARDRowID,"BED",BEDChildsub)),"^",1)
					}
					s ARCIMId=$p($g(^OEORD(+OEORIDr,"I",$P(OEORIDr,"||",2),1)),"^",2)
					s FindARCFlag=""
					s OrdNames=""
					s depProcNotes = ""  ;备注 OEORI_DepProcNotes
					for index=1:1:$l(OEORIDrs,",") {
						s OEORIDr=$p(OEORIDrs,",",index)
						s StatusCode=##class(appcom.OEOrdItem).GetStatusCode(OEORIDr)
						continue:("VE"'[StatusCode)
						s depProcNotesIndex = 0
						for {
							s depProcNotesIndex=$o(^OEORD(+OEORIDr,"I",$p(OEORIDr,"||",2),"DEP",depProcNotesIndex)) q:depProcNotesIndex=""  d
							s depProcNotesData=^OEORD(+OEORIDr,"I",$p(OEORIDr,"||",2),"DEP",depProcNotesIndex)
							continue:depProcNotesData=""
							i depProcNotes="" s depProcNotes=depProcNotesData
							else  s depProcNotes = depProcNotes_" "_depProcNotesData
						}
						s ItmMastDr=$p(^OEORD(+OEORIDr,"I",$p(OEORIDr,"||",2),1),"^",2)
						s:(ArcItemRowid'="")&&(ItmMastDr=ArcItemRowid) FindARCFlag="Y"
						s OrdName=$p($g(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1)),"^",2)
						s OrdName=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",OrdName,langid)
						if (OrdNames="") s OrdNames=OrdName
						else  s OrdNames=OrdNames_"+"_OrdName
					}
					continue:(ArcItemRowid'="")&&(FindARCFlag="")
					s $p(rsData,"^",3)=OrdNames
					s rsData = PatName_"^"_PatSex_"^"_PatAge_"^"_PortUrl_"^"_ARCIMId_"^"_rsData
					s SpecDr=$o(^OEORD(+OEORIDrs,"I",$p(OEORIDrs,"||",2),"SPEC",""),-1)
					s SpecCode=""
					i $l(SpecDr) s SpecCode=$p(^OEORD(+OEORIDrs,"I",$p(OEORIDrs,"||",2),"SPEC",SpecDr),"^",1)
					s InsureListviewFlag=0 //说明书
					s InsureHtml=##class(web.DHCAPPExaReportQuery).GetItemInstr(ARCIMId,"",SpecCode)
					if ((InsureHtml'="")&&(InsureHtml'="[]")) s InsureListviewFlag=1
					s rsData=rsData_"^"_SpecCode_"^"_depProcNotes_"^"_InsureListviewFlag
					s rsData=rsData_"^"_PAAdmBedNO_"^"_PaAdm
					s count=count+1
					continue:count<Start
					continue:count>End
					w $case(count,Start:"",:",")
					w ##Class(web.DHCAPPJsonCommon).getJsonData(retColName,rsData)
				}
			}
		}
	} 
	k ^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",Pid)
	w ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(count)
	Do result1.Close()
	Quit ""
SetPatLisData
	Set result1=##class(%Library.ResultSet).%New("web.DHCAPPSeePatLis:QueryOrderList")
	Set sc1=result1.Execute(EpisodeID, PatientID, FromDate, ToDate, LocCode, AuthFlag, AllTS, AdmDateFlag, UserId, fReadFlag, fRegNo, fLocationDR, fWardDR, fPrintFlag,"",ordResult)
	If $$$ISERR(sc1) Quit ""
	Set colNum=result1.GetColumnCount() //列数
	s Num=0
	While(result1.Next())
	{ 
		Set ret=0
		For i=1:1:colNum Do
		.s:ret'=0 ret=ret_"^"_$P(result1.%GetData(i),$C(13,10))
		.s:ret=0 ret = $P(result1.%GetData(i),$C(13,10))
		s OEORIDr=$p(ret,"^",2)
		s ArcimName=$p(ret,"^",3)
		s SpecName=$p(ret,"^",8)
		s readFlag=$p(ret,"^",20) //是否阅读
		
		s hasPort=$p(ret,"^",5)   //是否出报告
		s labNo=$p(ret,"^",6)     //检验号
		s portDateTime =$p(ret,"^",11) //检验出报告时间
		s portDate = $p(portDateTime," ",1) //日期
		s:portDate'="" portDate = ..%ZDH(portDate)
		s portTime = $p(portDateTime," ",2) //时间
		s:portTime'="" portTime = ..%ZTH(portTime)
		s orderByPort=""
		s orderByPort = "A"_$case(hasPort,3:"1",:"") //_+readFlag
		s SortNum=1
		if (sort'=""){
			if (sort="LabEpisode") s SortNum=+labNo_$e("00000000000000000000",1,15-$l(labNo))_labNo
			if (sort="OrdItemName") s SortNum=$P(ret,"^",3)_$e("00000000000000000000",1,15-$l(labNo))_labNo
			if (sort="AuthDateTime") s SortNum=$P(ret,"^",11)_$e("00000000000000000000",1,15-$l(labNo))_labNo
			if (sort="ReqDateTime") s SortNum=$P(ret,"^",4)_$e("00000000000000000000",1,15-$l(labNo))_labNo
		}else{
			s SortNum=$e("00000000000000000000",1,15-$l(labNo))_labNo //$P(ret,"^",4)	
		}
		s ReportID=$p(ret,"^",1)
		if (portDate="") s portDateTime=0
		else  s portDateTime=portDate_portTime
		if SortNum="" s SortNum=1
		/*s Data=$g(^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",Pid,SortNum,+ReportID,orderByPort,portDateTime))
		if (Data'="") {
			//处理合管未出报告的申请单
			if (+ReportID=0){
				s $p(ret,"^",2)=$p(Data,"^",2)_","_OEORIDr //医嘱ID串
			}
		}*/
		if ReportID="" s ReportID=0
		s ^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",Pid,SortNum,ReportID,orderByPort,portDateTime_OEORIDr)=ret
	 }
	 Q
}

Query QueryOrderList(EpisodeID, PatientID, FromDate, ToDate, LocCode, AuthFlag, AllTS, AdmDateFlag, UserId, fReadFlag, fRegNo, fLocationDR, fWardDR, fPrintFlag, Sessions, ordResult) As %Query(ROWSPEC = "VisitNumberReportDR,OEOrdItemID,OrdItemName,ReqDateTime,ResultStatus,LabEpisode,LabTestSetRow,OrdSpecimen,SpecDateTime,RecDateTime,AuthDateTime,PreReport,WarnComm,TSResultAnomaly,TSMemo,AdmNo,AdmDate,AdmLoc,AdmType,ReadFlag,PrintFlag,StatusDesc,ReceiveNotes,MajorConclusion,HasMC,HasMid,HasBic,RepFlag,ManualState,ReportStatus,ReportUrl,ExecStatus,ExecSequence,ForwardExecStatus,ForwardExecSequence")
{
}

/// Others：  d ##Class(%ResultSet).RunQuery("web.DHCAPPSeePatLis","QueryOrderList","108","89","2019-09-25","2019-10-25","","0","","","10209","0","","","","Y","")     
ClassMethod QueryOrderListExecute(ByRef qHandle As %Binary, EpisodeID, PatientID, FromDate, ToDate, LocCode, AuthFlag, AllTS, AdmDateFlag, UserId, fReadFlag, fRegNo, fLocationDR, fWardDR, fPrintFlag, Sessions, ordResult) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^tempqujian("QueryOrderList") = $lb(EpisodeID, PatientID, FromDate, ToDate, LocCode, AuthFlag, AllTS, AdmDateFlag, UserId, fReadFlag, fRegNo, fLocationDR, fWardDR, fPrintFlag, Sessions,ordResult)
	Set langid=..%LanguageID()
	i $l(FromDate) s FromDate= ..%ZDH(FromDate)
	i $l(ToDate) S ToDate= ..%ZDH(ToDate)
	s UserId=$g(UserId)
	//科室
	s LocCode=$g(LocCode)
	i $l(LocCode) s LocId=$o(^CTLOC(0,"Code",LocCode,""),-1)
	//是否审核
	s AuthFlag=$g(AuthFlag)
	//所有医嘱
	s AllTS=$g(AllTS)
	i '$l(AllTS) s AllTS="N"
	//就诊日期范围  1:三月 2:半年 3:一年 4:所有
	s AdmDateFlag=$g(AdmDateFlag)
	///是否打印
	s fPrintFlag=$g(fPrintFlag)
	i fPrintFlag="N" s AuthFlag=1  ///
	///全部就诊
	i EpisodeID="-1" s EpisodeID=""
	//自助、报告限制手工计费未缴费 1 未缴费不控制 2 未缴费控制
	s SelfCheckFee="1"
	s RowId=$o(^dbo.SYSParameterI("IndexCode"," SELFCHECKFEE"," SYS"," DHCC",""))
	i $l(RowId) s SelfCheckFee=$lg($g(^dbo.SYSParameterD(RowId)),5)
	
	k ^TMP($zn,$i,$j)
	k ^TMP($zn,repid,$j)
	i $l(EpisodeID) d GetOrderByEpisode(EpisodeID)

	i '$l(EpisodeID),$l(PatientID) d
	.s type="" f  s type=$o(^PAPERdr(PatientID,"ADM",type)) q:type=""  d
	..s ADMId="" f  s ADMId=$o(^PAPERdr(PatientID,"ADM",type,ADMId),-1) q:ADMId=""  d
	...s AdmLoc=$p(^PAADM(ADMId),"^",4)
	...s AdmDate=$p(^PAADM(ADMId),"^",6)
	...///日期范围
	...i AdmDateFlag="1",(+$H-AdmDate)>90 Q
	...i AdmDateFlag="2",(+$H-AdmDate)>182 Q
	...i AdmDateFlag="3",(+$H-AdmDate)>365 Q
	...i $l(LocCode),LocCode'=AdmLoc q
	...d GetOrderByEpisode(ADMId)
	
	Set qHandle=$lb(0,repid,0)
	k ^TMP($zn,repid,$j)
	k ^TMP($zn,$i,$j)
	Quit $$$OK
	
GetOrderByEpisode(EpisodeNo)
	Set langid=..%LanguageID()
	s SamLabRowID=""
	s OrdId=""  f  {
		s OrdId=$o(^OEORD(0,"Adm",EpisodeNo,OrdId)) 
		q:OrdId=""  
		s SubId=""	f {
			s SubId=$o(^OEORD(OrdId,"I",SubId),-1)
		 	q:SubId=""  
			s OrdRowId=OrdId_"||"_SubId
			s OrdStr1=$g(^OEORD(OrdId,"I",SubId,1))
			s OrdStr3=$g(^OEORD(OrdId,"I",SubId,3))
			s ItmMastDr=$p(OrdStr1,"^",2)
			i '$l(ItmMastDr) continue
			i '##Class(web.DHCLabOrder).isLabTS(ItmMastDr) continue
			s OrdName=$p($g(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1)),"^",2)
			//比较申请日期
			s ReqDate=$p(OrdStr3,"^",7)
			i $l(ReqDate),$l(FromDate),ReqDate-FromDate<0 continue
			i $l(ReqDate),$l(ToDate),ReqDate-ToDate>0 continue
			//检验号
			s PlacerNo=$p(OrdStr3,"^",36)
			s LabEpisode=$p(OrdStr3,"^",20) //优先取预制条码
			i '$l(LabEpisode) continue
			//报告ID
			s LabTestSetRow=$p(OrdStr3,"^",35)
			s LabTestSetRow=$tr(LabTestSetRow,$c(0))
			s stat=$p(^OEORD(OrdId,"I",SubId,1),"^",13)
			s StatusDesc="",StatusCode=""
			i stat'=""{
				s StatusDesc=$P(^OEC("OSTAT",stat),"^",2) 
				s StatusCode=$P(^OEC("OSTAT",stat),"^",1) 
			}
			continue:StatusCode="D"	//停止
			continue:StatusCode="U"	//作废
			continue:StatusCode="C"	//撤销
			
			//病人所属医院
			s Adm=$p(^OEORD(OrdId),"^",1),locCode="",HospID="",HospitalCode="",AdmLoc=""
			i $l(Adm),$d(^PAADM(Adm)) s locCode=$p(^PAADM(Adm),"^",4)
			i $l(locCode) s HospID=$p(^CTLOC(locCode),"^",22),AdmLoc=$p(^CTLOC(locCode),"^",2)
			i AdmLoc["-" s AdmLoc=$p(AdmLoc,"-",2)
			i $l(HospID) s HospitalCode=$p(^CT("HOSP",HospID),"^",1)
			s AdmLoc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",AdmLoc,langid)
			//就诊日期
			s AdmDate=$p(^PAADM(Adm),"^",6)
			i $l(AdmDate) s AdmDate=..%ZD(AdmDate)
			s PAAdmType=$p(^PAADM(Adm),"^",2)
			i PAAdmType="O" s AdmType="门诊"
			i PAAdmType="I" s AdmType="住院"
			i PAAdmType="E" s AdmType="急诊"
			i PAAdmType="H" s AdmType="体检"
			s AdmType=##class(websys.Translation).Get("dhcapp.seepatlis.csp",AdmType)
			s PatCurStat=##class(web.DHCADMVisitStat).GetStayStatus(Adm)
			s AdmDepDr=$p($g(^PAADM(Adm)),"^",4)
			s AdmDepHospId=$p(^CTLOC(AdmDepDr),"^",22)
			;0:普通收费模式；1：押金收费模式
			s StayPayMode=##class(web.DHCBillInterface).IGetStayPayMode(AdmDepHospId)
			s OrdStr1=$g(^OEORD(OrdId,"I",SubId,1))
			s OrdStr3=$g(^OEORD(OrdId,"I",SubId,3))
			s ItmMastDr=$p(OrdStr1,"^",2)
			
			s OrdRowIds=""
			i $l(OrdRowIds) s OrdRowIds=OrdRowIds_","_OrdRowId
			e  s OrdRowIds=OrdRowId
			
			//申请日期时间
			s ReqDate=$p(OrdStr3,"^",7)
			s ReqTime=$p(OrdStr1,"^",17)
			s OGTTGroupReqDate=ReqDate
			i $l(ReqDate) s ReqDate=..%ZD(ReqDate)
			i $l(ReqTime) s ReqTime=..%ZT(ReqTime)
			s ReqDateTime=ReqDate_" "_ReqTime
			s LabTestSetRow=$p(OrdStr3,"^",35)
			s LabTestSetRow=$tr(LabTestSetRow,$c(0))
			//标本类型
			s SpecDr=$o(^OEORD(OrdId,"I",SubId,"SPEC",""),-1)
			s (SpecCode,SpecName)=""
			i $l(SpecDr) s SpecCode=$p(^OEORD(OrdId,"I",SubId,"SPEC",SpecDr),"^",1)
			i $l(SpecCode) s SpecName=$p(##Class(DHCLIS.DHCCommon).GetSpecimen(SpecCode,HospitalCode),$c(2),2)
			
			s (RecDateTime,ResultStatus,AuthDateTime,ReportFlag,TransComm,TSResultAnomaly,TSMemo,ReceiveNotes,MajorConclusion)=""
			s PrintFlag=""
			s ExecStatusInfo=##Class(web.DHCAPPSeePatLis).GetExecStatusInfo(OrdRowId)
			s ExecStatus=$LG(ExecStatusInfo,2)
			s ExecSequence=$LG(ExecStatusInfo,3)
			s ForwardExecStatus=$LG(ExecStatusInfo,6)
			s ForwardExecSequence=$LG(ExecStatusInfo,7)

			s HasMC="",HasMid="",HasBic="",RepFlag="",ManualState="",ManualOrdItemList=""
			s OutPutReportDR=##class(web.DHCENS.EnsHISService).DHCHisInterface("QryLISRptIDByLabNo",LabEpisode,OrdRowId)
			continue:(ordResult="HasRe")&&(OutPutReportDR="")
			continue:(ordResult="NoRe")&&(OutPutReportDR'="")
			
			//采集日期时间Collection\SpecDateTime
			//ReceiveDate:接收日期,ReceiveTime:接收时间
			//AuthDate:报告审核日期,AuthTime:报告审核时间
			s ExecStatusLogInfo=..GetExecStatusLogInfo($P(OrdRowId,","))
			s SpecDateTime=$LG(ExecStatusLogInfo,1)
			s RecDateTime=$LG(ExecStatusLogInfo,2)
			s AuthDateTime=$LG(ExecStatusLogInfo,3)
			if (OutPutReportDR'="") {
				
				for reportIndex=1:1:$l(OutPutReportDR,",") {
					s oneReportDR=$p(OutPutReportDR,",",reportIndex)
					///获取报告结果信息
					Set result=##class(%Library.ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:QryTSInfoReport")
					Set sc=result.Execute(oneReportDR)
					Set colNum=result.GetColumnCount() //列数
					If $$$ISERR(sc) continue
					While(result.Next()){
						Set ret=""
						s ResultStatus="3"
						
						s ReceiveNotes=$g(result.Data("ResNoes"))
						s MajorConclusion=$g(result.Data("MajorConclusion"))
						
						s RepStatus=$g(result.Data("RepStatus"))
						;s RepStatus=$case(RepStatus,"1":"审核","2":"取消审核","3":"作废")
						s TSMemo="【"_##class(websys.Translation).Get("dhcapp.seepatlis.csp",RepStatus)_"】"
						s StatusDesc=RepStatus
						;ManualState不为空代表微生物有未缴费的手工医嘱
						s ManualOrdItemList=$g(result.Data("ManualOrdItemList"))
						if (ManualOrdItemList'="")&&(SelfCheckFee=1) {
							s ResetManualState=0
							if (PAAdmType'="I") s ResetManualState=1
							;急诊留观押金模式
							if " 1 2 "[(" "_PatCurStat_" ")&&(StayPayMode=1)&&(PAAdmType="E"){ 
								s ResetManualState=0
							}
							if (ResetManualState=1){
								for i=1:1:$length(ManualOrdItemList,","){
									s OneManualOrdItemList=$P(ManualOrdItemList,",",i)
									s OEORIBilled=$p($g(^OEORD(+OneManualOrdItemList,"I",$p(OneManualOrdItemList,"||",2),3)),"^",5)
									if (OEORIBilled'="P") {
										s ManualState=1
									}
								}
							}
						}
						s ReportStatus=$g(result.Data("ReportStatus"))
						s ReportStatus=$case(ReportStatus,"1":"正常报告","2":"异常报告","3":"危急报告","4":"中间报告（预报告）","5":"部分报告","":"无报告")
						;s RecDateTime=..%ZD(result.Data("ReqDate"))_" "_..%ZT(result.Data("ReqTime"))
						s AuthDateTime=..%ZD(result.Data("AuthDate"))_" "_..%ZT(result.Data("AuthTime"))
						
					}
					s LabReport=##class(DHCDoc.DHCApp.BasicConfig).GetConfigNode("LabReport",HospID)
					if (LabReport="orderitem"){
						s OrdRowIds=##class(web.DHCENS.EnsHISService).DHCHisInterface("QryLISOrdIDByRpt",oneReportDR)
						continue:($l(OutPutReportDR,",")>1)&&((","_OrdRowIds_",")'[(","_OrdRowId_","))
						s OrdRowIds=OrdRowId
					}elseif (LabReport="report"){
						s OrdRowIds=##class(web.DHCENS.EnsHISService).DHCHisInterface("QryLISOrdIDByRpt",oneReportDR)
						continue:($l(OutPutReportDR,",")>1)&&((","_OrdRowIds_",")'[(","_OrdRowId_","))
						if ((","_OrdRowIds_",")'[(","_OrdRowId_",")) {
							s OrdRowIds=OrdRowId
							s oneReportDR=""
							s (RecDateTime,ResultStatus,AuthDateTime,ReportFlag,TransComm,TSResultAnomaly,TSMemo,ReceiveNotes,MajorConclusion)=""
						}
					
					}
					/*if ((","_SamLabRowID_",")[(","_OrdId_"||"_SubId_",")) {
						continue
					}else{
						s SamLabRowID=SamLabRowID_","_OrdRowIds
					}*/	
					s OrdNames=""
					for i=1:1:$length(OrdRowIds,","){
						s TMPOrdRowId=$P(OrdRowIds,",",i)
						s TMPItmMastDr=$P(^OEORD(+TMPOrdRowId,"I",$P(TMPOrdRowId,"||",2),1),"^",2)
						s OrdName=$p($g(^ARCIM(+TMPItmMastDr,$p(TMPItmMastDr,"||",2),1)),"^",2)
						s OrdName=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",OrdName,langid)
						i $l(OrdNames) s OrdNames=OrdNames_"+"_OrdName
						e  s OrdNames=OrdName
					}
					continue:OrdNames=""
					s ReportUrl=""
					s ReadFlag=##class(web.DHCAPPInterface).IsReadByParams(OrdRowId_"^"_$P(oneReportDR,"||",1)_"^")
					if ReadFlag="Y" s ReadFlag=1  else  s ReadFlag=0
					continue:((fReadFlag="Y")&&(ReadFlag=1))
					s Data=$lb(oneReportDR,OrdRowIds,OrdNames,ReqDateTime,ResultStatus,LabEpisode,LabTestSetRow,SpecName,SpecDateTime,RecDateTime,AuthDateTime,ReportFlag,TransComm,TSResultAnomaly,TSMemo,Adm,AdmDate,AdmLoc,AdmType,ReadFlag,PrintFlag,StatusDesc,ReceiveNotes,MajorConclusion,HasMC,HasMid,HasBic,RepFlag,ManualState,ReportStatus,ReportUrl,ExecStatus,ExecSequence,ForwardExecStatus,ForwardExecSequence)
					d OutputRow7
				}
			}else{
				s LabReport=##class(DHCDoc.DHCApp.BasicConfig).GetConfigNode("LabReport",HospID)
				if (LabReport="orderitem"){
						s OrdRowIds=OrdId_"||"_SubId
				}elseif (LabReport="report"){
					s suborder="",OrdRowIds=""
					for  {
						s suborder=$O(^OEORD(0,"EpisNo",LabEpisode,OrdId,suborder))
						q:suborder=""
						s stat=$p(^OEORD(OrdId,"I",suborder,1),"^",13)
						s StatusDesc="",StatusCode=""
						i stat'=""{
							s StatusDesc=$P(^OEC("OSTAT",stat),"^",2) 
							s StatusCode=$P(^OEC("OSTAT",stat),"^",1) 
						}
						continue:StatusCode="D"	//停止
						continue:StatusCode="U"	//作废
						continue:StatusCode="C"	//撤销
						if OrdRowIds=""  s OrdRowIds=OrdId_"||"_suborder
						else   s OrdRowIds=OrdRowIds_","_OrdId_"||"_suborder
					
					}
				}
				s ReadFlag=##class(web.DHCAPPInterface).IsReadByParams(OrdRowId_"^^")
				if ReadFlag="Y" s ReadFlag=1  else  s ReadFlag=0
				continue:((fReadFlag="Y")&&(ReadFlag=1))
				if ((","_SamLabRowID_",")[(","_OrdId_"||"_SubId_",")) {
					continue
				}else{
					s SamLabRowID=SamLabRowID_","_OrdRowIds
				}
				s OrdNames=""
				s ReportUrl=""
				s ReportStatus=""
				for i=1:1:$length(OrdRowIds,","){
					s TMPOrdRowId=$P(OrdRowIds,",",i)
					continue:(TMPOrdRowId="")
					s ExecStatusInfo=##Class(web.DHCAPPSeePatLis).GetExecStatusInfo(TMPOrdRowId)
					s Status=$LG(ExecStatusInfo,1)
					if (Status="PRERP") {
						s ReportStatus="预报告"
						s ReportUrl=$LG(ExecStatusInfo,9)
					}
					s TMPItmMastDr=$P(^OEORD(+TMPOrdRowId,"I",$P(TMPOrdRowId,"||",2),1),"^",2)
					s OrdName=$p($g(^ARCIM(+TMPItmMastDr,$p(TMPItmMastDr,"||",2),1)),"^",2)
					s OrdName=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",OrdName,langid)
					i $l(OrdNames) s OrdNames=OrdNames_"+"_OrdName
					e  s OrdNames=OrdName
				}
				
				s Data=$lb(OutPutReportDR,OrdRowIds,OrdNames,ReqDateTime,ResultStatus,LabEpisode,LabTestSetRow,SpecName,SpecDateTime,RecDateTime,AuthDateTime,ReportFlag,TransComm,TSResultAnomaly,TSMemo,Adm,AdmDate,AdmLoc,AdmType,ReadFlag,PrintFlag,StatusDesc,ReceiveNotes,MajorConclusion,HasMC,HasMid,HasBic,RepFlag,ManualState,ReportStatus,ReportUrl,ExecStatus,ExecSequence,ForwardExecStatus,ForwardExecSequence)
				d OutputRow7
			}
		}
	}
	q
OutputRow7	
	s iLen=$LISTLENGTH(Data)
	f i=1:1:iLen d
	.i '$ld(Data,i) s $LI(Data,i)=""
	.s $LI(Data,i)=$tr($LI(Data,i),$c(0))
	s ^Tempscl("ttt",ind)=Data
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryOrderListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOrderListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryOrderListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOrderListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获取时间段内病人就诊ID字符串
/// w ##class(web.DHCEMInComUseMethod).GetAdmStrByPatID(77,"","","")
ClassMethod GetAdmStrByPatID(PatID As %String, Type As %String, StartDate As %String, EndDate As %String)
{

	 q:PatID="" ""
	 i Type="" s Type="O^E^I^H^N"
     s AdmStr="",Num=1

     f i=1:1:$l(Type,"^") d
     .s Temptype=$p(Type,"^",i)
     .s EpisodeID=""
     .f  s EpisodeID=$o(^PAPERdr(PatID,"ADM",Temptype,EpisodeID),-1) q:EpisodeID=""  d  
     ..s Pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
     ..s AdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
     ..q:(StartDate'="")&(AdmDate<StartDate)
     ..q:(EndDate'="")&(AdmDate>EndDate)
     ..s $p(AdmStr,"^",Num)=EpisodeID
     ..s Num=Num+1
     q AdmStr
}

/// tanjishan 2022年2月22日
/// 从平台获取检查检验申请的状态信息
/// zw ##Class(web.DHCAPPSeePatLis).GetExecStatusInfo("258||96")
/// return $LB(当前流程代码,当前流程描述,当前流程级别,所属流程代码,当前正流程代码,当前正流程描述,当前正流程级别,当前流程归属大类)
ClassMethod GetExecStatusInfo(OrdRowId As %String) As %String
{
	if (OrdRowId=""){
		q $LB("","","","","","","","","","","","")
	}
	s OrdStr1=$g(^OEORD(+OrdRowId,"I",$P(OrdRowId,"||",2),1))
	s OrdStr3=$g(^OEORD(+OrdRowId,"I",$P(OrdRowId,"||",2),3))
	s ARCIMRowId=$p(OrdStr1,"^",2)
	s ItemCatRowid=$p(^ARCIM($p(ARCIMRowId,"||",1),$p(ARCIMRowId,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)

	s PlacerNo=$p(OrdStr3,"^",36)
	s LabEpisode=$p(OrdStr3,"^",20) //优先取预制条码
	s StatusParam=##Class(%Stream.GlobalCharacter).%New()
	if (OrderType="L"){
		d StatusParam.Write("[{""OEOrdItemID"":"""_OrdRowId_""",""ExamID"":"""_LabEpisode_"""}]")
	}else{
		q $LB("","","","","","","","","","","","")
	}
	s StatusInfo=##class(web.DHCENS.EnsHISService).DHCHisInterface("QuerySystemStatus",StatusParam).Read()
	k StatusInfoArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(StatusInfo,.StatusInfoArr)
	s SystemCode=$G(StatusInfoArr(1,"SourceSystem"))
	s StatusCode=$G(StatusInfoArr(1,"Status"))
	s ReportUrl=$G(StatusInfoArr(1,"Notes"))
	s StatusDesc=""
	&SQL(select ESC_Desc into :StatusDesc from sqlUser.Ens_StatusCode where ESC_Code=:StatusCode)
	if (SQLCODE) s StatusDesc=""
	&SQL(SELECT ESS_Sequence into :Sequence FROM Ens_SystemLinkStatus WHERE ESS_SystemCode=:SystemCode and ESS_StatusCode=:StatusCode and ESS_EffectiveFlag='Y' )
	if (SQLCODE) s Sequence=0

	s NewStatusCode=StatusCode
	s NewStatusDesc=StatusDesc
	s NewSequence=Sequence
	
	//如果当前流程属于逆向流程，尝试找到对应的正流程归属
	if (Sequence<0){
		s mySequence=$ZABS(Sequence)
		&SQL(SELECT top 1 ESS_StatusCode,ESS_Sequence into :NewStatusCode,:NewSequence FROM Ens_SystemLinkStatus WHERE ESS_SystemCode=:SystemCode and  ESS_EffectiveFlag='Y' and ESS_Sequence<:mySequence  and ESS_Sequence>=0 order by ESS_Sequence)
		&SQL(select ESC_Desc into :NewStatusDesc from sqlUser.Ens_StatusCode where ESC_Code=:NewStatusCode)
	}
	//自定义一个阶段信息大类 申请-登记-报告
	s StatusCat=""
	s (APSequence,SCSequence,PRSequence)=0
	&SQL(SELECT ESS_Sequence into :APSequence FROM Ens_SystemLinkStatus WHERE ESS_SystemCode=:SystemCode and ESS_StatusCode='AP' and ESS_EffectiveFlag='Y' )
	if (SQLCODE) s APSequence=0
	//SC:登记,RECEIVE:接收标本
	&SQL(SELECT ESS_Sequence into :SCSequence FROM Ens_SystemLinkStatus WHERE ESS_SystemCode=:SystemCode and ESS_StatusCode='SC' and ESS_EffectiveFlag='Y' )
	if (SQLCODE){
		&SQL(SELECT ESS_Sequence into :SCSequence FROM Ens_SystemLinkStatus WHERE ESS_SystemCode=:SystemCode and ESS_StatusCode='RECEIVE' and ESS_EffectiveFlag='Y' )
	}
	//PRP:部分报告,PRERP:预报告,IM:已有图像,RP:报告
	&SQL(SELECT ESS_Sequence into :PRSequence FROM Ens_SystemLinkStatus WHERE ESS_SystemCode=:SystemCode and ESS_StatusCode='PRP' and ESS_EffectiveFlag='Y' )
	if (SQLCODE){
		&SQL(SELECT ESS_Sequence into :PRSequence FROM Ens_SystemLinkStatus WHERE ESS_SystemCode=:SystemCode and ESS_StatusCode='PRERP' and ESS_EffectiveFlag='Y' )
		if (SQLCODE){
			&SQL(SELECT ESS_Sequence into :PRSequence FROM Ens_SystemLinkStatus WHERE ESS_SystemCode=:SystemCode and ESS_StatusCode='IM' and ESS_EffectiveFlag='Y' )
			if (SQLCODE){
				&SQL(SELECT ESS_Sequence into :PRSequence FROM Ens_SystemLinkStatus WHERE ESS_SystemCode=:SystemCode and ESS_StatusCode='RP' and ESS_EffectiveFlag='Y' )
			}
		}
	}
	
	if (NewSequence<=APSequence){
		s StatusCat="申请"
	}elseif (NewSequence<PRSequence){
		s StatusCat="登记"
	}else{
		s StatusCat="报告"
	}
	q $LB(StatusCode,StatusDesc,Sequence,SystemCode,NewStatusCode,NewStatusDesc,NewSequence,StatusCat,ReportUrl)
}

/// tanjishan 2022年2月22日
/// 从平台获取检查检验申请的状态信息
/// zw ##Class(web.DHCAPPSeePatLis).GetExecStatusLogInfo("258||96")
/// zw ##Class(web.DHCAPPSeePatLis).GetExecStatusLogInfo("258||136")
/// return $LB(当前流程代码,当前流程描述,当前流程级别,所属流程代码,当前正流程代码,当前正流程描述,当前正流程级别,当前流程归属大类)
ClassMethod GetExecStatusLogInfo(OrdRowId As %String) As %String
{
	s str=$LB("","","","","","","","","","","","")
	if (OrdRowId=""){
		q str
	}
	s OrdStr1=$g(^OEORD(+OrdRowId,"I",$P(OrdRowId,"||",2),1))
	s OrdStr3=$g(^OEORD(+OrdRowId,"I",$P(OrdRowId,"||",2),3))
	
	s ARCIMRowId=$p(OrdStr1,"^",2)
	s ItemCatRowid=$p(^ARCIM($p(ARCIMRowId,"||",1),$p(ARCIMRowId,"||",2),1),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
	s retval=##Class(web.DHCNurSpecerNo).GetspecCollDatetime(OrdRowId)
	s SpecDateTime=..%ZD($p(retval,"^",2))_" "_..%ZT($p(retval,"^",3))
	
	s PlacerNo=$p(OrdStr3,"^",36)
	s LabEpisode=$p(OrdStr3,"^",20) //优先取预制条码
	s StatusParam=##Class(%Stream.GlobalCharacter).%New()
	if (OrderType="L"){
		d StatusParam.Write("[{""OEOrdItemID"":"""_OrdRowId_""",""ExamID"":"""_LabEpisode_"""}]")
	}else{
		q str
	}
	s StatusInfo=##class(web.DHCENS.EnsHISService).DHCHisInterface("QuerySystemStatusLog",StatusParam).Read()
	k StatusInfoArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(StatusInfo,.StatusInfoArr)

	s (ReceiveDate,AuthDate)=""
	s Index=""
	for {
		s Index=$O(StatusInfoArr(Index))
		q:(Index="")
		s Status=StatusInfoArr(Index,"Status")
		//接收、核查||(Status="ACCEPT")
		if (Status="RECEIVE"){
			s ReceiveDate=StatusInfoArr(Index,"UpDateTime")
		}
		//拒收标本、取消核收||(Status="CACCEPT")
		if (Status="REJECT"){
			s ReceiveDate=""
		}
		//部分报告、报告
		if (Status="PRP")||(Status="RP"){
			s AuthDate=StatusInfoArr(Index,"UpDateTime")
		}
		//CPRP:取消部分报告,CRP:取消报告
		if (Status="CPRP")||(Status="CRP"){
			s AuthDate=""
		}
	}
	
	i ReceiveDate["-" s ReceiveDate=..%ZD(..%ZDH($P(ReceiveDate," ",1)))_" "_$P(ReceiveDate," ",2)
	i AuthDate["-" s AuthDate=..%ZD( ..%ZDH($P(AuthDate," ",1)))_" "_$P(AuthDate," ",2)
	q $LB(SpecDateTime,ReceiveDate,AuthDate,"","","","","","","","","","")
}

/// w ##class(web.DHCAPPSeePatLis).GetLocAdmStr("12")
ClassMethod GetLocAdmStr(locID As %String, bedNo As %String = "")
{
	q:locID="" ""	
	s AdmStr=""
	s AdmDate="" 
	s Date=""
	for {
		s Date = $O(^PAADMi("AdmTypeCurrLoc","I",locID,Date))
		q:(Date="")
		s Time=""
		for {
			s Time=$O(^PAADMi("AdmTypeCurrLoc","I",locID,Date,Time))
			q:(Time="")
			s PAADMRowID=""
			for {
				s PAADMRowID=$O(^PAADMi("AdmTypeCurrLoc","I",locID,Date,Time,PAADMRowID))
				q:(PAADMRowID="")
				
				s PAADMBedDR = ##class(Nur.Interface.OutSide.Patient).GetBedId(PAADMRowID)
				if (PAADMBedDR '= ""){
					s WARDRowID = $p(PAADMBedDR,"||",1)
					s BEDChildsub = $p(PAADMBedDR,"||",2)
					s PAAdmBedNO = $p($g(^PAWARD(WARDRowID,"BED",BEDChildsub)),"^",1)
				}
				else{
					s PAAdmBedNO = ""
				}
				continue:(bedNo'="")&&(PAAdmBedNO'[bedNo)
	
				if AdmStr="" s AdmStr=PAADMRowID
				else  s AdmStr=AdmStr_"^"_PAADMRowID
			}
		}
	}
	q AdmStr
}

}
