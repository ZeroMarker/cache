Import SQLUser

/// Descript:审方查询类
/// CreateDate:2021-11-06
/// Creator:sufan
Class web.DHCPRESCQuery Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Descript:获取检验历史列表
/// CreateDate:2021-11-06
/// Creator:sufan
/// Input:就诊Id
/// w ##class(web.DHCPRESCQuery).GetLisHisList("1","10","^^^^^0^^^^0^^^^Y^^^^")
ClassMethod GetLisHisList(page As %String, rows As %String, params As %String)
{
	s Start=page-1*rows+1
	s End=page*rows
	s adm = $p(params,"^",1)
	q:+adm=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0)
	s patientId = $p(params,"^",2)
	s fromDate=$p(params,"^",3)
	s:fromDate="" fromDate = $zd(+$h-30,3)
	s toDate = $p(params,"^",4)
	s:toDate="" toDate = $zd(+$h,3)
	s locCode=$p(params,"^",5)
	s authFlag = $p(params,"^",6)
	s allts = $p(params,"^",7)
	s admDateFlag = $p(params,"^",8)
	s userId = $p(params,"^",9)
	s readFlag = ""
	s regNo = ""
	s locationId = ""
	s wardId = ""
	s printFlag = ""
	s catId = ""
	s admType = ""
	s dateOrdVal = ""
	s oeorId = ""
	s:+dateOrdVal=0 dateOrdVal=-1 

	s pid = ##class(web.DHCPRESCCommonUtil).NewPid()
	k ^TMP("DHCPRESC","web.DHCPRESCQuery","GetLisHisList",pid)   
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal() //输出json前缀串

	
	
	w:adm="" ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(0)
	q:adm="" ""
	

	d SetPatLisData    //通过临时globle获取数据
	
	Set count = 0,del="""",tmp=""
	s retColName="PatName^PatSex^PatAge^PortUrl^VisitNumberReportDR^OEOrdItemID^OrdItemName^ReqDateTime^ResultStatus"
	s retColName=retColName_"^LabEpisode^LabTestSetRow^OrdSpecimen^SpecDateTime^RecDateTime"
	s retColName=retColName_"^AuthDateTime^PreReport^WarnComm^TSResultAnomaly^TSMemo^AdmNo"
	s retColName=retColName_"^AdmDate^AdmLoc^AdmType^ReadFlag^PrintFlag^StatusDesc^ReceiveNotes"
	s retColName=retColName_"^MajorConclusion^HasMC^HasMid^HasBic"

	s orderByPort=""
	f  s orderByPort = $o(^TMP("DHCPRESC","web.DHCPRESCQuery","GetLisHisList",pid,orderByPort),-1) q:orderByPort=""  d
	.s portDate="" 
	.f  s portDate = $o(^TMP("DHCPRESC","web.DHCPRESCQuery","GetLisHisList",pid,orderByPort,portDate),dateOrdVal) q:portDate=""  d
	..s portTime=""
	..f  s portTime = $o(^TMP("DHCPRESC","web.DHCPRESCQuery","GetLisHisList",pid,orderByPort,portDate,portTime),dateOrdVal) q:portTime=""  d
	...s labNo=""
	...f  s labNo = $o(^TMP("DHCPRESC","web.DHCPRESCQuery","GetLisHisList",pid,orderByPort,portDate,portTime,labNo)) q:labNo=""  d
	....s Num=""
	....f  s Num = $o(^TMP("DHCPRESC","web.DHCPRESCQuery","GetLisHisList",pid,orderByPort,portDate,portTime,labNo,Num)) q:Num=""  d
	.....s rsData  = ^TMP("DHCPRESC","web.DHCPRESCQuery","GetLisHisList",pid,orderByPort,portDate,portTime,labNo,Num)
	.....s visitNumberReportId = $p(rsData,"^",1)
	.....s ordList = $p(rsData,"^",2)
	.....s oeorId = $p(ordList,",",1)
	.....q:'$d(^OEORD(+oeorId))
	.....s portUrl = ##class(web.DHCAPPInterface).GetPacsPortUrlByOrd(oeorId,"",1)
	.....s paAdm = $p(^OEORD(+oeorId),"^",1)
	.....s patId  = $p(^PAADM(paAdm),"^",1)
	.....s patName = $p(^PAPER(patId,"ALL"),"^",1)   /// 病人姓名	
	.....s patSex = ""
	.....s sexId = $p(^PAPER(patId,"ALL"),"^",7)     /// 性别
	.....i sexId'="" s patSex=$p(^CT("SEX",sexId),"^",2)
	.....s patAge = ##class(web.DHCBillInterface).GetPapmiAge(patId)  /// 年龄
	.....s rsData = patName_"^"_patSex_"^"_patAge_"^"_portUrl_"^"_rsData
	.....s count=count+1
	.....q:count<Start
	.....q:count>End
	.....w $case(count,Start:"",:",")
	.....w ##Class(web.DHCAPPJsonCommon).getJsonData(retColName,rsData)
	k ^TMP("DHCPRESC","web.DHCPRESCQuery","GetLisHisList",pid)
	w ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(count)
	Do result.Close()
	Quit ""
SetPatLisData
	Set result = ##class(%Library.ResultSet).%New("DHCLIS.DHCOrderList:QueryOrderList")
	Set sc = result.Execute(adm, patientId, fromDate, toDate, locCode, authFlag, allts, admDateFlag, userId, readFlag, regNo, locationId, wardId, printFlag,"")
	If $$$ISERR(sc) Quit ""

	Set colNum=result.GetColumnCount() //列数

	s num = 0
	While(result.Next())
	{ 
		Set ret=0
		For i=1:1:colNum Do
		.s:ret'=0 ret=ret_"^"_$P(result.%GetData(i),$C(13,10))
		.s:ret=0 ret = $P(result.%GetData(i),$C(13,10))
		s readFlag = $p(ret,"^",20) 				//是否阅读
		s hasPort = $p(ret,"^",5)   				//是否出报告
		s labNo = $p(ret,"^",6)     				//检验号
		s portDateTime = $p(ret,"^",11) 			//检验出报告时间
		s portDate = $p(portDateTime," ",1) 		//日期
		s:portDate'="" portDate = $zdh(portDate,3)
		s portTime = $p(portDateTime," ",2) 		//时间
		s:portTime'="" portTime = $zth(portTime)
		s orderByPort=""
		s orderByPort = "A"_$case(hasPort,3:"1",:"")_+readFlag
		s num = num+1
		b  //s1
		s ^TMP("DHCPRESC","web.DHCPRESCQuery","GetLisHisList",pid,orderByPort,+portDate,+portTime,labNo,num) = ret   //按照是否阅读排序 1：阅读，其他：未阅读
	 }
}

/// Descript: 检验报告结果
/// w ##class(web.DHCPRESCQuery).GetLisDetList("1","6","",0)
ClassMethod GetLisDetList(page As %String, rows As %String, reportId As %String, showType As %String = "")
{
	w:reportId="" ##class(web.DHCEMJsonCommon).getJsonStartNoTotal() //输出json前缀串
	w:reportId="" ##class(web.DHCEMJsonCommon).getJsonEndConTotal(0)
	q:reportId="" "" 
	
	Set result=##class(%Library.ResultSet).%New("LIS.WS.BLL.DHCRPVisitNumberReportResult:QryTSInfo")
	Set sc=result.Execute(reportId)
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
		.If ret="" Set ret=del_result.GetColumnName(i)_del_":"_del_$tr($P(result.%GetData(i),$C(13,10)),$c(34),"")_del
		.Else   Set ret=ret_","_del_result.GetColumnName(i)_del_":"_del_$tr($P(result.%GetData(i),$C(13,10)),$c(34),"")_del
	
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

/// Descript:取检查数据
/// Creator:QQA
/// CreatTime:2018-02-24
/// Descript:检查结果查询与病理合并使用:检查项目内容获取
/// w ##class(web.DHCPRESCQuery).GetInspectOrd("1","10","85^62^^^20667^^^^")
ClassMethod GetInspectOrd(page As %String, rows As %String, Params As %String)
{
		s ^temptest("222") = $lb(page,rows,Params)
	s Adm = $p(Params,"^",1)
	q:+Adm=0 ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0)
	s PatDr = $p(Params,"^",2)
	s:+Adm'=0 PatDr = $p(^PAADM(Adm),"^",1)
	s StartDate = $p(Params,"^",3)
	s EndDate = $p(Params,"^",4)
	s UserID = $p(Params,"^",5)
	s AdmType=$p(Params,"^",6)
	s OrdType=$p(Params,"^",7)
	s ReqNo=$p(Params,"^",8)
	s InOEORIId=$p(Params,"^",9)
	s StartDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)
	s EndDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	s:StartDate="" StartDate=+$h-365    //为空的时候查询一年的信息
	s:EndDate="" EndDate=+$h
	s Count=0,Del=""""
	s Start=page-1*rows+1
	s End=page*rows
	//s Pid = ##Class(web.DHCAPPExaRepCom).NewPid()
	k LisOrdList
	
    f Date=StartDate:1:EndDate  d
    .s ARRowID=""
    .f  s ARRowID = $o(^DHCAPREP(0,"CreateDate",Date,ARRowID)) q:ARRowID=""  d
    ..s ARChildSub=""
    ..f  s ARChildSub= $o(^DHCAPREP(ARRowID,"AR",ARChildSub)) q:ARChildSub=""  d
    ...s OEORIId = $p(^DHCAPREP(ARRowID,"AR",ARChildSub),"^",3)
    ...q:OEORIId=""
    ...q:(InOEORIId'="")&&(InOEORIId'=OEORIId)
    ...s OrdAdm = $p(^OEORD(+OEORIId),"^",1)
    ...s OrdPatDr = $p(^PAADM(OrdAdm),"^",1)
    ...q:OrdPatDr'=PatDr			/// 用病人id过滤 qunianpeng 2018/3/14 
    ...q:(+Adm'=0)&&(OrdAdm'=Adm)
    ...s OEOrd = +OEORIId
    ...s OEOrdItm = $p(OEORIId,"||",2)
	...s ARCICatInfo = ##class(web.DHCEMInComUseMethod).GetARCICatByOEORDItmDr(OEORIId)  //医嘱子类信息
	...s ARCICatDr = $p(ARCICatInfo,"^",1)
	...q:+ARCICatDr=0
	...s No = $p(^DHCAPREP(ARRowID),"^",1)
	...q:(ReqNo'="")&&(No'=ReqNo)
	...s AccID = $o(^DHCAPARCCA(0,"O",ARCICatDr,""))
	...q:(OrdType'="")&&(AccID'=OrdType)
	...s OECCatDesc = ##class(web.DHCEMInComUseMethod).GetOECCatByOEORDItmDr(OEORIId)
	...q:OECCatDesc'["检查"
	...s ItmStatDesc = ""   //医嘱描述
	...s ItmStatDr = $p(^OEORD(OEOrd,"I",OEOrdItm,1),"^",13)
	...s ItmStatDesc = $p(^OEC("OSTAT",ItmStatDr),"^",2)
	...q:(ItmStatDesc["撤销")!(ItmStatDesc["作废")!(ItmStatDesc["停止") //这些状态的医嘱不显示
	...s ArciID=$p($g(^OEORD(OEOrd,"I",OEOrdItm,1)),"^",2)
	...q:(ArciID="")
	...s ServerMaterial=$p($g(^ARCIM($p(ArciID,"||",1),$p(ArciID,"||",2),7)),"^",6)
	...q:(ServerMaterial'="S")    ;没有service标识,不是检查医嘱退出
	...s PartList = ##Class(web.DHCAPPInterface).GetExaReqPartNur(OEORIId)
	...i '$d(^DHCAPREP(ARRowID,"AR",ARChildSub,"PA")) d
	....s StudyNo = ##class(web.DHCAPPSeePatPacs).GetStudyNoByORORIAndPart(OEORIId,"")
	....s:StudyNo="" StudyNo=0
	....s LisOrdList("PacsGroup",StudyNo,OEORIId,0)=""
	...s RepPartID=""
	...f  s RepPartID= $o(^DHCAPREP(ARRowID,"AR",ARChildSub,"PA",RepPartID)) q:RepPartID=""  d
	....s ReqPartStatus = $p(^DHCAPREP(ARRowID,"AR",ARChildSub,"PA",RepPartID),"^",2)
	....q:ReqPartStatus="D"                      //D为停止状态
	....s PartID = $p(^DHCAPREP(ARRowID,"AR",ARChildSub,"PA",RepPartID),"^",1)
	....s StudyNo = ##class(web.DHCAPPSeePatPacs).GetStudyNoByORORIAndPart(OEORIId,PartID)
	....s hasBooked=##class(web.DHCRisResApptSchudleSystem).HasBooked(OEORIId,PartID) ;##class(web.DHCRisResApptSchudleSystem).getBookDetailRowid(OEORIId_"^"_PartID)    //预约的和申请的分开
	....s:(hasBooked="Y")&&(StudyNo="") StudyNo=-1
	....s:StudyNo="" StudyNo=0
	....s:PartID="" PartID=0
	....s LisOrdList("PacsGroup",StudyNo,OEORIId,PartID)=""
	
	b ;data
	d ..GetLisOrdDetails(.LisOrdList,UserID)
    
    /*上半部分是获取检查数据*/
  	///获取病理相关数据
    s StDate=StartDate   													/// 开始日期
    s EndDate=EndDate  														/// 结束日期
    s EpiType=AdmType      													/// 就诊类型
	for Date=StDate:1:EndDate d
    .s PisID=""
    .f  s PisID=$o(^DHCAPPPM(0,"CreateDate",Date,PisID)) Q:PisID=""  D
    ..s EpisodeID=$p(^DHCAPPPM(PisID),"^",1)  										/// 就诊ID
    ..s ApStatus=$p(^DHCAPPPM(PisID),"^",9)  										/// 申请单状态
    ..q:ApStatus="D"
    ..q:'$d(^PAADM(EpisodeID))
    ..s PatType=$p($g(^PAADM(EpisodeID)),"^",2)										/// 就诊类型
    ..q:(EpiType'="")&&(PatType'=EpiType)
    ..q:(+Adm'=0)&&(+Adm'=EpisodeID)                                                /// 过滤Adm
    ..s PatientID=$p(^PAADM(EpisodeID),"^",1)										/// 病人ID
    ..q:(PatDr'="")&&(PatDr'=PatientID)
    ..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  		 							/// 登记号       									/// 申请单号
	..q:(ReqNo'="")&&(ReqNo'=No)
	..
  	..s oeori=""
  	..s CH=""
  	..f  s CH=$o(^DHCAPPPM(PisID,"A",CH))  Q:(CH="")||(oeori'="")  D
  	...s oeori=$p(^DHCAPPPM(PisID,"A",CH),"^",3)
  	...q:oeori=""
	..q:(InOEORIId'="")&&(InOEORIId'=oeori)
	..s ARCICatInfo = ##class(web.DHCEMInComUseMethod).GetARCICatByOEORDItmDr(oeori)  //医嘱子类信息
	..s ARCICatDr = $p(ARCICatInfo,"^",1)
	..q:+ARCICatDr=0
	..s AccID = $o(^DHCAPARCCA(0,"O",ARCICatDr,""))
	..q:(OrdType'="")&&(AccID'=OrdType) 
	..s LisOrdList("PisGroup",PisID)=""
	
	d ..GetPisOrdDetails(.LisOrdList,UserID)
	
    
    b ;2
    s Num=0
    Write ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal() //输出json前缀串
    s RsStr="BLOrJC^RowNum^ReqNo^RegNo^AdmLoc^PatientID^StudyNo^strOrderName^strOrderDate^ItemStatus^OEORIId^IsIll^recLocName^recLocDr^IshasImg^MediumName^Image^Shut^Report^Memo^ImageUrl^Grade^IsModify^IsReaded^ImgUrl^PortUrl^BlMorePort^IsCVR"
	s OrderByPort=""
	f  s OrderByPort = $o(LisOrdList("Data",OrderByPort),-1) q:OrderByPort=""  d
	.s OrderByDesc=""
	.f  s OrderByDesc = $o(LisOrdList("Data",OrderByPort,OrderByDesc),-1) q:OrderByDesc=""  d
	..s Flag=""
	..f  s Flag = $o(LisOrdList("Data",OrderByPort,OrderByDesc,Flag)) q:Flag=""  d
	...s StudyNo=""
	...f  s StudyNo =$o(LisOrdList("Data",OrderByPort,OrderByDesc,Flag,StudyNo)) q:StudyNo=""  d
	....s OEORIId=0
	....f  s OEORIId = $o(LisOrdList("Data",OrderByPort,OrderByDesc,Flag,StudyNo,OEORIId)) q:OEORIId=""  d
	.....s Count=Count+1
	.....q:Count<Start
	.....q:Count>End
	.....w $case(Count,Start:"",:",")
	.....s RsData= Flag_"^"_Num_"^"_LisOrdList("Data",OrderByPort,OrderByDesc,Flag,StudyNo,OEORIId)
	.....s Num=Num+1
	.....w ##class(web.DHCAPPJsonCommon).getJsonData(RsStr,RsData)
	w "]"
	w ","_Del_"total"_Del_":"_Count
	w "}"

	k LisOrdList
	q ""
}

/// /w ##class(web.DHCAPPSeePatPacs).GetStudyNoByORORIAndPart("4||4","")
ClassMethod GetStudyNoByORORIAndPart(OEORIId, PartID)
{
	s StudyNo=""
	s RegInfoDr=""
	f  s RegInfoDr=$o(^DHCPACRegInfoi("OEORI",OEORIId,RegInfoDr)) q:RegInfoDr=""  d
	.s:PartID="" StudyNo = $p(^DHCPACRegInfo(RegInfoDr),"^",2) 
	.q:StudyNo'=""
	.s ChildSub=""
	.f  s ChildSub =  $o(^DHCPACRegInfoBD("BODYPARTS",0,RegInfoDr,ChildSub)) q:(ChildSub="")||(StudyNo'="")  d
	..s PartDr=$p(^DHCPACRegInfoBD("BODYPARTS",0,RegInfoDr,ChildSub),"^",1)
	..q:PartID'=PartDr
	..s StudyNo = $p(^DHCPACRegInfo(RegInfoDr),"^",2)
	s:StudyNo="" StudyNo = ##class(web.DHCEkg.GetEkgReportState).GetEkgStudyId(OEORIId)   //心电的检查号获取
	q StudyNo
}

ClassMethod GetPortStatusCodeByStudyNo(StudyNo)
{
	s examStatus=""
	q:StudyNo="" ""
	q:StudyNo=0 ""
	s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,""),"-1")
	i RptRowId'=""  d
	.s StatusDR=$p(^DHCRBStudy("Report",RptRowId),"^",4)
	.s StatusCode=""
	.i StatusDR'="" s StatusCode=$p(^DHCRBCStatus("ReportStatus",StatusDR),"^",1)
	.s:StatusCode="S" examStatus="CM"
	q examStatus
}

/// Creator: zhouxin
/// CreatDate: 2016.06.30
/// Description: 根据菜单类型,日期时间段,登记号取病人就诊串
/// Table：
/// Input：
/// Return：admStr 就诊号串 ^分割
ClassMethod getAdmStrByRegNo(RegNo As %String, Type As %String, StartDate As %String, EndDate As %String)
{
	 i Type="" s Type="OE"
	 s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(RegNo),""))
     q:papmiId="" ""
     s admStr="",num=1
     
     s typeStr="O^E"
     f i=1:1:$l(typeStr,"^") d
     .s temptype=$p(typeStr,"^",i)
     .q:(temptype="O")&&(Type'["O")
     .q:(temptype="E")&&(Type="EM")
     .q:(temptype="E")&&(Type'["E")

     .s EpisodeID=""
     .f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM",temptype,EpisodeID),-1) q:EpisodeID=""  d  
     ..s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)

     ..q:(pavisit'="A")
     ..s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
     ..q:(StartDate'="")&(admDate<StartDate)
     ..q:(EndDate'="")&(admDate>EndDate)
     ..s $p(admStr,"^",num)=EpisodeID
     ..s num=num+1
     q admStr
}

/// Descript:这个检查和病理融合使用方法
/// w ##class(web.DHCAPPSeePatPacs).QueryExamOrderListNew("6795||4","0")
ClassMethod QueryExamOrderListNew(OEORIId As %String, StudyNoLab As %String) As %Status
{
	q:OEORIId="" ""
	
	s Count=0,Del=""""
	s:StudyNoLab=0 StudyNoLab=""
	s Ord=+OEORIId
	s Itm=$p(OEORIId,"||","2")
	s EpisodeID=$p(^OEORD(Ord),"^",1)
	s PatMasRowid=$p(^PAADM(EpisodeID),"^",1)
	s RegNo=$p(^PAPER(PatMasRowid,"PAT",1),"^",1) 
	s arcimid=$p($g(^OEORD(Ord,"I",Itm,1)),"^",2)
	q:(arcimid="")
	s ServerMaterial=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),7)),"^",6)
	q:(ServerMaterial'="S")    ;没有service标识,不是检查医嘱退出
	s itmCatRowid=$p($g(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1)),"^",10)	
	s itmArcCatID=$o(^DHCAPARCCA(0,"O",itmCatRowid,""))
	if (itmArcCatID'="")
	{
		s examTypeRowid=$p(^DHCAPARCCA(itmArcCatID),"^",1)  	/// 检查分类代码
		s examTypeDescGet=$p(^DHCAPARCCA(itmArcCatID),"^",2)  	/// 检查分类描述
	}
	q:(($g(ExamType)'="")&&($g(examTypeDescGet)'=ExamType))
	s recLocDr=$p($g(^OEORD(Ord,"I",Itm,3)),"^",6)
	i recLocDr'="" s recLocName=$p(^CTLOC(recLocDr),"^",2)
	s:recLocDr'="" pacsSetInfo = ..GetPacsOpenPortInfo(recLocDr)
	s ClinicRowid=$o(^DHCRBCi("LocClinicSet",recLocDr,0))
	s OrderDate=$p(^OEORD(Ord,"I",Itm,1),"^",9)
	s strOrderDate=##class(websys.Conversions).DateLogicalToHtml(OrderDate)
	s OrderTime=$p(^OEORD(Ord,"I",Itm,1),"^",10) 
	s strOrderTime=$zt(OrderTime)
	s strOrderDateDesc = strOrderDate_" "_strOrderTime
	s bodydrList=""
	s:StudyNoLab="" bodydrList=##Class(web.DHCRisWorkBenchDoEx).GetstrOrderName(OEORIId)
	s:StudyNoLab'="" bodydrList=##Class(web.DHCAPPSeePatPacs).GetstrOrderName(StudyNoLab)
	for iBody=1:1:$L(bodydrList,"^") 
	{
		s (StudyNo,ImageUrl,IshasImg,IsIll,Memo)=""
		s (Image,Report,Grade)=""
		s (isModify,isReaded,IsReaded)=""
		s bodypart=$p($g(bodydrList),"^",iBody)
		s bodypartRowid=$p($g(bodypart),":",1) 
		s bodypartDesc=$p($g(bodypart),":",2)
		s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
		if bodypartDesc'=""  s strOrderName=strOrderName_" ("_bodypartDesc_")"
		s orderStatusInfo=##class(web.DHCRisWorkBenchDoEx).getOrderBodyStatus(OEORIId,bodypartRowid)
		s ItemStatusCode=$p($g(orderStatusInfo),"^",1)
		if ((ItemStatusCode="U")||(ItemStatusCode="D")||(ItemStatusCode="C"))
		{
			;非执行和核实状态退出,进入下次循环
			continue
		}
		s examStatus="A"   ;默认状态为申请
		s RegRowid=##class(web.DHCRisResApptSchudleSystem).getRegRowid(OEORIId_"^"_bodypartRowid )
		if (RegRowid'="")
		{
			s examStatus="SC"  ;登记
			
			s StudyNo=$p(^DHCPACRegInfo(RegRowid),"^",2)
			continue:StudyNoLab'=StudyNo
			s ImageUrl=$p(^DHCPACRegInfo(RegRowid),"^",22)      ;存放外部传输过来的URL
			i (StudyNo'="") 
			{
				s Imgrowid=$o(^DHCRBStudyi("StudyNo-Images",StudyNo,0))   ;
				s IshasImg="" ;..GetImageStatus(StudyNo)
				i Imgrowid'="" s IshasImg="Y"
				if (IshasImg="Y")
				{
					s examStatus="IM"   ;有图像
				}
				s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,""),"-1")
				if (RptRowId'="")
				{
					s examStatus="RP"  ;已写报告
					s StatusDR=$p(^DHCRBStudy("Report",RptRowId),"^",4)
					s StatusCode=""
					i StatusDR'="" s StatusCode=$p(^DHCRBCStatus("ReportStatus",StatusDR),"^",1)
					s IsIll = $p(^DHCRBStudy("Report",RptRowId),"^",7)
					s Memo=$g(^DHCRBStudy("Report",RptRowId,"MemoEx"))
					if (StatusCode="S")      ;((StatusCode="V")||(StatusCode="S"))  ;发布后 检查完成
					{
						s examStatus="CM"
					}
				}

			}
			
		}else
		{
			s BookedRowid=##class(web.DHCRisResApptSchudleSystem).getBookDetailRowid(OEORIId_"^"_bodypartRowid)
			if (BookedRowid'="")
			{
				s examStatus="BK"   ;预约
			}
		}
		if ( ClinicRowid'="")  ;配置了临床查看报告路径才能显示链接
		{
			;默认检查完成后才能查看报告和图像
			i (examStatus="CM")
			{
				s Image="图像"
				;s Shut="关闭"
				s Report="报告"
				s Grade="评级"
			}
			i ($g(StudyNo)'="")
			{
				s PortalRowId=$o(^DHCRBCLINICCHECKRPTINFOi(OEORIId,StudyNo,0))
				if (PortalRowId'="")
				{
					s CurUserID=..GetSession("LOGON.USERID")    ;%session.Get("LOGON.USERCODE")
					s Params = OEORIId_"^"_StudyNo_"^"_CurUserID
					s CMStatus=##class(web.DHCAPPSeePatPacs).IsReadByParams(Params)  ;##class(RISService.TrakRISService).GetRPTCMStatus(OEORIId,StudyNo,myDocCode)
					s isReaded=$p(CMStatus,"^",1)
					s isModify=$p(CMStatus,"^",2)
					if (isModify="Y") 
					{
						s IsModify="已修改"
					}
					else  
					{
						s IsModify=""
					}
					if (isReaded="Y")
					{
						s IsReaded="已阅读"
					}
					else
					{
						i Report="报告" s IsReaded="未阅读"
						e  s IsReaded=""
					}
				}
			}
		}
		s ItemStatus=..GetResultStatus(examStatus,RegNo_"^"_StudyNo)
		s ImgUrl = ..GetImgUrl(pacsSetInfo)
		s PortUrl = $p(pacsSetInfo,"^",1)
		s AdmDr = $p(^OEORD(+OEORIId),"^",1)
		s DepLocDesc=""
    	s DepLoc=$p(^PAADM(AdmDr),"^",4)       									    //就诊科室
		s DepLocDesc = $p(^CTLOC(DepLoc),"^",2)
		s PatID = $P(^PAADM(AdmDr),"^",1) 
		s RsData=RegNo_"^"_DepLocDesc_"^"_PatID_"^"_StudyNo_"^"_strOrderName_"^"_strOrderDateDesc_"^"_ItemStatus_"^"_OEORIId_"^"_IsIll_"^"_recLocName_"^"_recLocDr_"^"_IshasImg_"^"_$g(MediumName)_"^"_Image_"^"_$g(Shut)_"^"_Report_"^"_Memo_"^"_ImageUrl_"^"_Grade_"^"_$g(IsModify)_"^"_IsReaded_"^"_ImgUrl_"^"_PortUrl
	}  
	
	s PacsOrdName = ##class(web.DHCAPPSeePatPacs).GetPacsOrdName(OEORIId,StudyNoLab)
	s $p(RsData,"^",5) = PacsOrdName
	q RsData
}

/// Params:登记号^检查号
/// w ##class(web.DHCAPPSeePatPacs).GetPortUrl("11^222")
ClassMethod GetPortUrl(PacsSetInfo, Params)
{
	s PortUrl=""
	s RegNo = $p(Params,"^",1)
	s StudyNo = $p(Params,"^",2)
	s OeoriID = $p(Params,"^",3)
	s RepID = $p(Params,"^",4)
	s PortUrl = $p(PacsSetInfo,"^",1)
	s NeedRegNo = $p(PacsSetInfo,"^",2)
	s RegNoPar = $p(PacsSetInfo,"^",3)
	s NeedPacsNo = $p(PacsSetInfo,"^",4)
	s PacsNoPar = $p(PacsSetInfo,"^",5)
	s NeedOrdID = $p(PacsSetInfo,"^",17)
	s OrdIdPar = $p(PacsSetInfo,"^",18)
	s NeedOther = $p(PacsSetInfo,"^",13)
	s OtherPar = $p(PacsSetInfo,"^",14)
	s NeedRepID = $p(PacsSetInfo,"^",22)
	s RepIdPar = $p(PacsSetInfo,"^",23)

	q:PortUrl="" ""
	s:NeedRegNo="Y" PortUrl=PortUrl_$case($find(PortUrl,"?"),0:"?",:"&")_RegNoPar_"="_RegNo
	s:NeedPacsNo="Y" PortUrl=PortUrl_$case($find(PortUrl,"?"),0:"?",:"&")_PacsNoPar_"="_StudyNo
	s:NeedOrdID="Y" PortUrl=PortUrl_$case($find(PortUrl,"?"),0:"?",:"&")_OrdIdPar_"="_OeoriID
	s:NeedRepID="Y" PortUrl=PortUrl_$case($find(PortUrl,"?"),0:"?",:"&")_RepIdPar_"="_RepID
	s:NeedOther="Y" PortUrl=PortUrl_$case($find(PortUrl,"?"),0:"?",:"&")_OtherPar
	
	q PortUrl
}

/// Params:登记号^检查号
ClassMethod GetImgUrl(PacsSetInfo, Params)
{
	s ImgUrl=""
	s RegNo = $p(Params,"^",1)
	s StudyNo = $p(Params,"^",2)
	s OeoriID = $p(Params,"^",3)
	s RepID = $p(Params,"^",4)
	s ImgUrl = $p(PacsSetInfo,"^",7)
	s NeedRegNo = $p(PacsSetInfo,"^",8)
	s RegNoPar = $p(PacsSetInfo,"^",9)
	s NeedPacsNo = $p(PacsSetInfo,"^",10)
	s PacsNoPar = $p(PacsSetInfo,"^",11)
	s NeedOther = $p(PacsSetInfo,"^",15)
	s OtherPar = $p(PacsSetInfo,"^",16)
	s NeedOrdID = $p(PacsSetInfo,"^",19)
	s OrdIdPar = $p(PacsSetInfo,"^",20)
	s NeedRepID = $p(PacsSetInfo,"^",24)
	s RepIdPar = $p(PacsSetInfo,"^",25)
	q:ImgUrl="" ""
	s:NeedRegNo="Y" ImgUrl=ImgUrl_$case($find(ImgUrl,"?"),0:"?",:"&")_RegNoPar_"="_RegNo
	s:NeedPacsNo="Y" ImgUrl=ImgUrl_$case($find(ImgUrl,"?"),0:"?",:"&")_PacsNoPar_"="_StudyNo
	s:NeedOrdID="Y" ImgUrl=ImgUrl_$case($find(ImgUrl,"?"),0:"?",:"&")_OrdIdPar_"="_OeoriID
	s:NeedRepID="Y" ImgUrl=ImgUrl_$case($find(ImgUrl,"?"),0:"?",:"&")_RepIdPar_"="_RepID
	s:NeedOther="Y" ImgUrl=ImgUrl_$case($find(ImgUrl,"?"),0:"?",:"&")_OtherPar
	q ImgUrl
}

ClassMethod GetPacsOrdName(OEORIId, StudyNoLab)
{
	s OrdName =""
	s:StudyNoLab="" OrdName = ##class(web.DHCAPPSeePatPacs).GetPacsOrdNameByOEORI(OEORIId)
	s:StudyNoLab'="" OrdName = ##class(web.DHCAPPSeePatPacs).GetPacsOrdNameByStudyNo(StudyNoLab)
	q OrdName
}

/// w ##class(web.DHCAPPSeePatPacs).GetPacsOrdNameByOEORI("740||4")
ClassMethod GetPacsOrdNameByOEORI(OEORIId)
{
	q:OEORIId="" ""
	s OrdName=""
	s PartList = ##Class(web.DHCRisWorkBenchDoEx).GetstrOrderName(OEORIId)
	s ArciName = ##class(web.DHCEMInComUseMethod).getArcimDesc(+OEORIId,$p(OEORIId,"||",2))
	s PartDesc =""
	f i=1:1:$l(PartList,"^") d
	.s PartItm = $p(PartList,"^",i)
	.s PartItmDesc = $p(PartItm,":",2)
	.s:PartDesc'="" PartDesc=PartDesc_"+"_PartItmDesc
	.s:PartDesc="" PartDesc=PartItmDesc
	s OrdName= ArciName_$case(PartDesc,"":"",:"("_PartDesc_")")
	q OrdName
}

ClassMethod GetstrOrderName(StudyNoLab)
{
	s PartList=""
	s RARRowid = ""
	f  s RARRowid = $o(^DHCPACRegInfoi("StudyNo",StudyNoLab,RARRowid)) q:RARRowid=""  d
	.s RRBChildSub=""
	.f  s RRBChildSub = $o(^DHCPACRegInfoBD("BODYPARTS",0,RARRowid,RRBChildSub)) q:RRBChildSub=""  d
	..s PartItmDr = $p(^DHCPACRegInfoBD("BODYPARTS",0,RARRowid,RRBChildSub),"^",1)
	..s PartItmDesc = $p(^DHCPACRegInfoBD("BODYPARTS",0,RARRowid,RRBChildSub),"^",3)
	..s PartItm = PartItmDr_":"_PartItmDesc
	..s:PartList'="" PartList=PartList_"^"_PartItm
	..s:PartList="" PartList=PartItm
	q PartList
}

ClassMethod GetPacsOrdNameByStudyNo(StudyNoLab)
{
	s OrdName=""
	s RARRowid = ""
	f  s RARRowid = $o(^DHCPACRegInfoi("StudyNo",StudyNoLab,RARRowid)) q:RARRowid=""  d
	.s OEORIId = $p(^DHCPACRegInfo(RARRowid),"^",11)
	.s ArciName = ##class(web.DHCEMInComUseMethod).getArcimDesc(+OEORIId,$p(OEORIId,"||",2))
	.s PartDesc=""
	.s RRBChildSub=""
	.f  s RRBChildSub = $o(^DHCPACRegInfoBD("BODYPARTS",0,RARRowid,RRBChildSub)) q:RRBChildSub=""  d
	..s PartItmDesc = $p(^DHCPACRegInfoBD("BODYPARTS",0,RARRowid,RRBChildSub),"^",3)
	..s:PartDesc'="" PartDesc =PartDesc_"+"_PartItmDesc
	..s:PartDesc="" PartDesc =PartItmDesc
	.s:OrdName'="" OrdName =OrdName_","_ArciName_$case(PartDesc,"":"",:"("_PartDesc_")")
	.s:OrdName="" OrdName = ArciName_$case(PartDesc,"":"",:"("_PartDesc_")")
	q OrdName
}

ClassMethod GetResultStatus(statusCode As %String) As %String
{
	q:(statusCode="") ""
	s StatusDesc=""
	&sql(SELECT ESC_Desc INTO :StatusDesc FROM Ens_Statuscode WHERE ESC_Code=:statusCode)
	q StatusDesc
}

ClassMethod GetSession(Name As %Library.String) As %String
{
    s val=""
    q:(Name="") val
    Set $ZT="ERROR"	
	if $Get(%session.Data(Name))=""
	{
		s val=""
	}
	else
	{
		s val=%session.Get(Name)
	}  
	q val
ERROR	
	Set ErrorMsg=$ZE 
 	Quit ""
}

ClassMethod GetImageStatus(StudyNo As %String) As %String
{
	s HasImge="N",ImageCount=0
	s CurrSpace=$ZNSPACE
	zn "PACS"
	s strStudyNo=" "_StudyNo
	s id=$o(^User.STUDYINFOI("STUDYINFOPK",strStudyNo,0))
	i id'="" s ImageCount=$LISTGET(^User.STUDYINFOD(id),35)
	i ImageCount>0 d
	.s HasImge="Y"
	zn CurrSpace
	Q HasImge
}

/// w ##class(web.DHCAPPSeePatPacs).GetPacsOpenPortInfo("1")
ClassMethod GetPacsOpenPortInfo(LocDr As %String)
{
	s Rowid="",hasSet=""
	f  s Rowid=$o(^DHCRBC("ClinicSet",Rowid)) q:(Rowid="")  d
	.s LocDR=$P(^DHCRBC("ClinicSet",Rowid),"^",1)
	.q:(LocDr'="")&(LocDr'=LocDR)
	.s LocDr=LocDR
	.s hasSet=1
	.s:LocDR'="" LocDR=$p($g(^CTLOC(LocDR)),"^",2)
	.s ReportFullFile=$P(^DHCRBC("ClinicSet",Rowid),"^",2)
	.s RegYesNo=$P(^DHCRBC("ClinicSet",Rowid),"^",3)
	.s RRegParam=$P(^DHCRBC("ClinicSet",Rowid),"^",4)
	.s RStudyNOYesNo=$P(^DHCRBC("ClinicSet",Rowid),"^",5)
	.s RStudyParam=$P(^DHCRBC("ClinicSet",Rowid),"^",6)
	.s ReportDelim=$P(^DHCRBC("ClinicSet",Rowid),"^",7)
	.s ImageFullFile=$P(^DHCRBC("ClinicSet",Rowid),"^",8)
	.s IRegYesNo=$P(^DHCRBC("ClinicSet",Rowid),"^",9)
	.s IRegParam=$P(^DHCRBC("ClinicSet",Rowid),"^",10)
	.s IStudyNOYesNo=$P(^DHCRBC("ClinicSet",Rowid),"^",11)
	.s IStudyNOParam=$P(^DHCRBC("ClinicSet",Rowid),"^",12)
	.s ImageDelim=$P(^DHCRBC("ClinicSet",Rowid),"^",13)
	.s ROtherYesNo=$P(^DHCRBC("ClinicSet",Rowid),"^",14)
	.s ROtherParam=$P(^DHCRBC("ClinicSet",Rowid),"^",15)
	.s IOtherYesNo=$P(^DHCRBC("ClinicSet",Rowid),"^",16)
	.s IOtherParam=$P(^DHCRBC("ClinicSet",Rowid),"^",17)
	.s ROeitemYesNo=$P(^DHCRBC("ClinicSet",Rowid),"^",18)
	.s ROeitemParam=$P(^DHCRBC("ClinicSet",Rowid),"^",19)
	.s IOeitemYesNo=$P($g(^DHCRBC("ClinicSet",Rowid)),"^",20)
	.s IOeitemParam=$P($g(^DHCRBC("ClinicSet",Rowid)),"^",21)
	.s IsOpenList=$P($g(^DHCRBC("ClinicSet",Rowid)),"^",22)
	.s RRepIdYesNo=$P($g(^DHCRBC("ClinicSet",Rowid)),"^",23)
	.s RRepIdParam=$P($g(^DHCRBC("ClinicSet",Rowid)),"^",24)
	.s IRepIdYesNo=$P($g(^DHCRBC("ClinicSet",Rowid)),"^",25)
	.s IRepIdParam=$P($g(^DHCRBC("ClinicSet",Rowid)),"^",26)
	q:hasSet'=1 ""
	s rsData = ReportFullFile_"^"_RegYesNo_"^"_RRegParam_"^"_RStudyNOYesNo_"^"_RStudyParam
	s rsData = rsData_"^"_ReportDelim_"^"_ImageFullFile_"^"_IRegYesNo_"^"_IRegParam_"^"_IStudyNOYesNo
	s rsData = rsData_"^"_IStudyNOParam_"^"_ImageDelim_"^"_ROtherYesNo_"^"_ROtherParam_"^"_IOtherYesNo
	s rsData = rsData_"^"_IOtherParam_"^"_ROeitemYesNo_"^"_ROeitemParam_"^"_IOeitemYesNo_"^"_IOeitemParam
	s rsData = rsData_"^"_IsOpenList_"^"_RRepIdYesNo_"^"_RRepIdParam_"^"_IRepIdYesNo_"^"_IRepIdParam
	
	q rsData
}

ClassMethod GetParam(Params)
{
	 s LocDr = $p(Params,"^",1)
	 s PatientID = $p(Params,"^",2)
	 s OEORIId = $p(Params,"^",3)
	 s PatInfo=""
	 s DateSet = ##class(web.DHCEMCommonUtil).DateFormat()
	 s:PatientID PatInfo=##class(web.DHCEMECheck).GetPatInfoByPatId(PatientID)
	 s RegNolenghtInfo = ##class(web.DHCCLCom).GetPatConfig()
	 s OrdStDate = ##class(web.DHCAPPSeePatPacs).GetOrdStDate(OEORIId)
	 q DateSet_"#"_$p(PatInfo,"^",1)_"#"_$p(RegNolenghtInfo,"^",1)_"#"_OrdStDate
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
/// CreatDate:2018-03-01
/// Descript:获取医嘱类型:走检查申请检查分类维护
/// w ##class(web.DHCAPPSeePatPacs).GetOrdType("2")
ClassMethod GetOrdType(Params)
{
	 w "["
	 s Count=0
	 s HospID = $p(Params,"^",1)
	 s ArccaID=0
	 f  s ArccaID = $o(^DHCAPARCCA(ArccaID)) q:ArccaID=""  d
	 .s ArccaHospDr = $p(^DHCAPARCCA(ArccaID),"^",4)
	 .q:$d(^DHCAPARCCA(ArccaID,"I"))'=10
	 .q:(HospID'="")&(HospID'=ArccaHospDr)
	 .s ArccDesc = $p(^DHCAPARCCA(ArccaID),"^",2)
	 .q:ArccDesc["检验"
	 .s Data = ArccaID_"^"_ArccDesc
	 .s Count=Count+1
	 .w $case(Count,1:"",:",")
	 .w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",Data)
	 w "]"
	 q ""
}

/// Creator:QQA
/// CreatDate:2018-03-08
/// Descript:报告查看和图像查看
/// Input:Model(I图像R报告)
/// w ##class(web.DHCAPPSeePatPacs).ClinicRecordSet("R","329^286^0000000100^US20180301003^4636^47||12")
ClassMethod ClinicRecordSet(Model, Params)
{
	s RecLocDR=$p($g(Params),"^",1)    //接受科室
	s LoginLocDR=$p($g(Params),"^",2)  //登录科室
	s RegNo=$p($g(Params),"^",3)       //登记号
	s StudyNo=$p($g(Params),"^",4)     //检查号
	s Date=+$h						   //阅读日期
	s Time=$p($h,",",2)				   //阅读时间
	s UserDR=$p($g(Params),"^",5)      //阅读人
	s OrditemDR=$p($g(Params),"^",6)   //医嘱ID
	
	;医嘱id^检查病理号/检验号^当前登录科室^阅读人
	s DataList = OrditemDR_"^"_StudyNo_"^"_LoginLocDR_"^"_UserDR
	s Ret= ##class(web.DHCAPPInterface).ClinicRecordSet(Model,DataList)
	q Ret
}

/// Creator:QQA
/// CreatDate:2018-03-08
/// Descript:报告是否阅读
/// Input:Params(医嘱ID,检查号,用户ID)
/// w ##class(web.DHCAPPSeePatPacs).IsReadByParams("47||12^US20180301003^4636")
ClassMethod IsReadByParams(Params)
{
	s Ret= ##class(web.DHCAPPInterface).IsReadByParams(Params)
	q Ret
}

/// Creator:QQA
/// CreatDate:2018-03-08
/// Descript:报告阅读明细
/// Input:Params(医嘱ID,检查号)
/// w ##class(web.DHCAPPSeePatPacs).ReadDetailByParams(1,6,"47||12^US20180301003")
ClassMethod ReadDetailByParams1(page, rows, Params)
{
	s Start=page-1*rows+1
	s End=page*rows
	s OEORIId = $p(Params,"^",1)
	s StudyNo = $p(Params,"^",2)
	w ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()
	w:StudyNo="" ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(0)
	q:StudyNo="" ""
	s Count=0
	s DataStr = "ReadDate^ReadTime^ReadDoctorName"
	s DDRRowID=""
	f  s DDRRowID = $o(^DHCRBDOCRECORDi("StudyNo",StudyNo,DDRRowID)) q:(DDRRowID="")  d
	.s DDROEOriID = $p($g(^DHCRBDOCRECORD("DOCTOR-RECORD",DDRRowID)),"^",13)
	.q:(OEORIId'="")&&(OEORIId'=DDROEOriID)
	.s DDRReadUserDesc=""
	.s DDRReadUserID = $p($g(^DHCRBDOCRECORD("DOCTOR-RECORD",DDRRowID)),"^",7)
	.s:DDRReadUserID'="" DDRReadUserDesc=$p(^SSU("SSUSR",DDRReadUserID),"^",2)
	.s DDRReadDate = $p($g(^DHCRBDOCRECORD("DOCTOR-RECORD",DDRRowID)),"^",5)
	.s DDRReadTime = $p($g(^DHCRBDOCRECORD("DOCTOR-RECORD",DDRRowID)),"^",6)
	.s:DDRReadDate'="" DDRReadDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(DDRReadDate)
	.s:DDRReadTime'="" DDRReadTime = $zt(DDRReadTime,2)
	.s Data = DDRReadDate_"^"_DDRReadTime_"^"_DDRReadUserDesc
	.s Count=Count+1
	.q:Count<Start
	.q:Count>End
	.w $case(Count,Start:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData(DataStr,Data)
	w ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(Count)
	q ""
}

/// Creator:QQA
/// CreatDate:2018-03-08
/// Descript:报告阅读明细
/// Input:Params(医嘱ID,检查号)
/// w ##class(web.DHCAPPSeePatPacs).ReadDetailByParams(1,6,"21||17^^")
ClassMethod ReadDetailByParams(page, rows, Params)
{
	d ##class(web.DHCEMInComUseMethod).ReadDetailByParams(page, rows, Params)
	q ""
}

/// Creator:QQA
/// CreatDate:2018-03-09
/// Descript:获取病人就诊记录
/// Input:病人ID
/// Return:Json 数组
/// w ##class(web.DHCAPPSeePatPacs).GetAdmLoc("1")
ClassMethod GetAdmLoc(PatientID)
{
	q:PatientID="" []
	s Count=0
	w "["
	w ##class(web.DHCAPPJsonCommon).getJsonData("value^text","0^所有就诊")  //所有就诊
	s Count=Count+1
	w $case(Count,1:"",:",")
	
	s AdmType=""
	f  s AdmType  = $o(^PAPERdr(PatientID,"ADM",AdmType)) q:AdmType=""  d
	.s AdmID = ""
	.f  s AdmID = $o(^PAPERdr(PatientID,"ADM",AdmType,AdmID))  q:AdmID=""  d
	..q:'$d(^PAADM(AdmID))
	..s AdmTypeDesc = $case(AdmType,"O":"门诊","E":"急诊","I":"住院",:"")
	..s AdmDate = $p(^PAADM(AdmID),"^",6)
	..s AdmDateDesc = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(AdmDate)
	..s AdmTime = $p(^PAADM(AdmID),"^",7)
	..s DepLoc=$p(^PAADM(AdmID),"^",4)          //就诊科室
	..s DepLocDesc = $p(^CTLOC(DepLoc),"^",2)
	..s AdmInfoDesc=DepLocDesc_"("_AdmDateDesc_")"_AdmTypeDesc
	..s Data = AdmID_"^"_AdmInfoDesc
	..s Count=Count+1
	..w $case(Count,1:"",:",")
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",Data)
	w "]"
	q ""
}

/// Creator:	sufan(不用)
/// CreatDate:  2018-03-09
/// Descript:   取病理报告链接
/// Input:      医嘱ID
/// Return:		报告链接
/// w ##class(web.DHCAPPSeePatPacs).GetPisLinkUrl("70||259")
ClassMethod GetPisLinkUrl(Oeori As %String) As %String
{
	s $zt="LinkErrMsg"
	s recLoc=$p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),3),"^",6) /// 接收科室
	s PatientID=$p(^PAADM(EpisodeID),"^",1)          /// 病人ID
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)      /// 登记号
	s Link=##Class(web.DHCPisApplicationSheet).getrptUrl(recLoc_"^"_Oeori)
	Q Link
LinkErrMsg
	zn "DHC-APP"
    Q ""
}

ClassMethod GetReqNo(OEORIId)
{
	s GetReqNo=""
	s ARRowID = $o(^DHCAPREP(0,"OrdItem",OEORIId,""),-1)
	s:ARRowID'="" GetReqNo=$p(^DHCAPREP(ARRowID),"^",1)
	q GetReqNo
}

/// 获取检查明细数据
ClassMethod GetLisOrdDetails(ByRef LisOrdList, UserID As %String) As %String
{
	s StudyNo="" 
	f  s StudyNo = $o(LisOrdList("PacsGroup",StudyNo)) q:StudyNo=""  d
	.s OEORIId = ""
	.f  s OEORIId = $o(LisOrdList("PacsGroup",StudyNo,OEORIId)) q:OEORIId=""  d
	..s Ord = +OEORIId
	..s Itm = $p(OEORIId,"||",2)
	..s ARCIMId=$p($g(^OEORD(Ord,"I",Itm,1)),"^",2)
	..s ARCIName = 	$p(^ARCIM($p(ARCIMId,"||",1),$p(ARCIMId,"||",2),1),"^",2)   ///获取医嘱名称
	..s RecLocName=""
	..s RecLocDr=$p($g(^OEORD(Ord,"I",Itm,3)),"^",6)
	..i RecLocDr'="" s RecLocName=$p(^CTLOC(RecLocDr),"^",2)
	..s:RecLocDr'="" PacsSetInfo = ..GetPacsOpenPortInfo(RecLocDr)
	..s ClinicRowid=$o(^DHCRBCi("LocClinicSet",RecLocDr,0))
	..s PartID = "",PartDesc=""
	..;s ExamStatus="A"    ;默认状态为申请               ///PartDesc 是获取统一个检查号下多个部位描述
	..s ExamID = $case(StudyNo,-1:"",0:"",:StudyNo)
	..s IsCVR = ##Class(web.DHCAntService).IsCVReport(ExamID,OEORIId)
	..s IsCVR = $case(+IsCVR,1:"是",:"否")
	..s Position=""
	..f  s PartID = $o(LisOrdList("PacsGroup",StudyNo,OEORIId,PartID)) q:PartID=""  d
	...s PartItmDesc = $p($g(^DHCAPPART(PartID)),"^",2) 
	...s:PartDesc'="" PartDesc=PartDesc_"+"_PartItmDesc
	...s:PartDesc="" PartDesc=PartItmDesc
	...s:Position'="" Position=Position_"@@"_PartItmDesc
	...s:Position="" Position=PartItmDesc
	..s ExamStatus=##Class(web.DHCAPPInterface).GetExaReqItmStatus(OEORIId,ExamID,Position)
	..s StrOrderName = ARCIName_$case(PartDesc,"":"",:"("_PartDesc_")")
	..s OrderDate=$p(^OEORD(+OEORIId,"I",$p(OEORIId,"||",2),1),"^",9)
	..s OrderTime=$p(^OEORD(+OEORIId,"I",$p(OEORIId,"||",2),1),"^",10)
	..s OrderByDesc = +OrderDate_+OrderTime
	..s OrdAdm = $p(^OEORD(+OEORIId),"^",1)								   //就诊ID	
    ..s PatDr = $p(^PAADM(OrdAdm),"^",1)							   //病人ID
	..s RegNo=$p(^PAPER(PatDr,"PAT",1),"^",1)                              //病人登记号
	..s DepLoc=$p(^PAADM(OrdAdm),"^",4)       						       //就诊科室
	..s DepLocDesc = $p(^CTLOC(DepLoc),"^",2)	
	..s PatID = PatDr
	..s OrderDate="",OrderTime=""													   //病人ID
	..s OrderDate=$p(^OEORD(Ord,"I",Itm,1),"^",9)
	..s strOrderDate=##class(websys.Conversions).DateLogicalToHtml(OrderDate)
	..s OrderTime=$p(^OEORD(Ord,"I",Itm,1),"^",10) 
	..s strOrderTime=$zt(OrderTime,2)
	..s strOrderDateDesc = strOrderDate_" "_strOrderTime                  //日期+时间
	..s IshasImg="",Image="",Report="",Memo="",ImageUrl="",Grade="",IsReaded="",ImgUrl=""
	..s PortUrl="",BlMorePort="",IsIll=""
	..i (StudyNo'=0)&&(StudyNo'=-1) d
	...;s ExamStatus="SC"   ;登记
	...s RegRowid = $o(^DHCPACRegInfoi("StudyNo",StudyNo,""))
	...s:RegRowid'="" ImageUrl=$p(^DHCPACRegInfo(RegRowid),"^",22)      ;存放外部传输过来的URL RegRowid 待发布
	...s Imgrowid=$o(^DHCRBStudyi("StudyNo-Images",StudyNo,0))   ;
	...s IshasImg="" ;..GetImageStatus(StudyNo)
	...i Imgrowid'="" s IshasImg="Y"
	...;s:IshasImg="Y" ExamStatus="IM"   ;有图像
	...s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,""),"-1")
	...i RptRowId'="" d
	....;s ExamStatus="RP"  ;已写报告
	....s StatusDR=$p(^DHCRBStudy("Report",RptRowId),"^",4)
	....s StatusCode=""
	....i StatusDR'="" s StatusCode=$p(^DHCRBCStatus("ReportStatus",StatusDR),"^",1)
	....s IsIll = $p(^DHCRBStudy("Report",RptRowId),"^",7)
	....s Memo=$g(^DHCRBStudy("Report",RptRowId,"MemoEx"))
	....;s:StatusCode="S" ExamStatus="CM"
	..;if ClinicRowid'="" d   ;配置了临床查看报告路径才能显示链接
	..s:IsIll="" IsIll = ##class(web.DHCEkg.GetEkgReportState).GetEkgPositive(OEORIId)   //心电报告是否阳性 
	..i ExamStatus="RP" d   ;默认检查完成后才能查看报告和图像
	...s:IshasImg="Y" Image="图像"
	...s Report="报告"
	...s Grade="评级"
	..s Params = OEORIId_"^"_$case(StudyNo,0:"",:StudyNo)_"^"_UserID
	..s IsReadedFlag=##class(web.DHCAPPInterface).IsReadByParams(Params)
	..b:OEORIId="292||219"
	..s IsModify=""                 		//是否修改                      
	..s:(ExamStatus="RP")&&(IsReadedFlag'="Y") IsReaded="未阅读"
	..s:(ExamStatus'="RP") IsReaded=""
	..s:IsReadedFlag="Y" IsReaded="已阅读"
	..b:OEORIId="292||219" ;1
	..s ItemStatus=..GetResultStatus(ExamStatus)
	..s No=##class(web.DHCAPPSeePatPacs).GetReqNo(OEORIId)
	..s UrlParams = RegNo_"^"_StudyNo_"^"_OEORIId
	..s ImgUrl = ##class(web.DHCAPPSeePatPacs).GetImgUrl(PacsSetInfo,UrlParams) ;$p(PacsSetInfo,"^",7)     //
	..s PortUrl = ##class(web.DHCAPPSeePatPacs).GetPortUrl(PacsSetInfo,UrlParams) ;$p(PacsSetInfo,"^",1)
	..s PacsData=RegNo_"^"_DepLocDesc_"^"_PatID_"^"_$case(StudyNo,0:"",-1:"",:StudyNo)_"^"_StrOrderName_"^"_strOrderDateDesc_"^"_ItemStatus_"^"_OEORIId_"^"_$g(IsIll)_"^"_RecLocName_"^"_RecLocDr_"^"_IshasImg_"^"_$g(MediumName)_"^"_Image_"^"_$g(Shut)_"^"_Report_"^"_Memo_"^"_ImageUrl_"^"_Grade_"^"_$g(IsModify)_"^"_IsReaded_"^"_ImgUrl_"^"_PortUrl
	..s OrderByPort=""""_$case(IsReaded,"未阅读":"1",:"0")_$case(Report,"报告":"1",:"0")_""""
	..s LisOrdList("Data",OrderByPort,OrderByDesc,0,StudyNo,OEORIId)=No_"^"_PacsData_"^"_BlMorePort_"^"_IsCVR
	q
}

ClassMethod GetPisOrdDetails(ByRef LisOrdList, UserID As %String) As %String
{
	s PisID=""
	for {
		s PisID=$O(LisOrdList("PisGroup",PisID))
		q:(PisID="")
		s EpisodeID=$p(^DHCAPPPM(PisID),"^",1)
		s PatType=$p($g(^PAADM(EpisodeID)),"^",2)				/// 就诊类型
    	s DepLoc=$p(^PAADM(EpisodeID),"^",4)       				//就诊科室
		s DepLocDesc = $p(^CTLOC(DepLoc),"^",2)
		s PatientID=$p(^PAADM(EpisodeID),"^",1)					/// 病人ID
	    s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  		 	/// 登记号
		s No=$p(^DHCAPPPM(PisID),"^",4)           				/// 申请单号
		;s PisNo=$p(^DHCAPPPM(PisID),"^",13)						//病理号
		s CreatDate=$p(^DHCAPPPM(PisID),"^",6)	    			/// 申请日期
		s CreatTime=$p(^DHCAPPPM(PisID),"^",7)	   				/// 申请时间
		s OrderByDesc =+CreatDate_+CreatTime
		s:CreatDate'="" CreatDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(CreatDate) 
		s:CreatTime'="" CreatTime=$zt(CreatTime,2)
		s CreatDateTime = CreatDate_" "_CreatTime				//申请日期+时间
		s apStatus=$p(^DHCAPPPM(PisID),"^",9) 					/// 申请状态 

		s ID=+$p(^DHCAPPPM(PisID),"^",21)       				/// 结果状态ID
		s PisType=$p(^DHCAPPPM(PisID),"^",20)  	   									/// 申请类型
		s PisReqDesc=$s(PisType="CYT":"细胞",PisType="HPV":"HPV",PisType="TCT":"TCT",PisType="LIV":"活体",PisType="APY":"尸检",PisType="CON":"外院",PisType="MOL":"分子",1:"未知")
		s arcListData=""
	  	s oeori=""
	  	s Report="" 																	///报告
	  	s CH="",recLoc="",LocID="",RepUrl="",PisNo=""    								//平台对接你传什么，就给我什么
	  	for{
		  	s CH=$o(^DHCAPPPM(PisID,"A",CH))
		  	Q:(CH="")||(oeori'="")
		  	s oeori=$p(^DHCAPPPM(PisID,"A",CH),"^",3)
		  	continue:oeori=""
		  	s PisNo=##class(web.DHCAPPSeePatPacs).GetTmInfoByOrderRowId(oeori)
		  	;s:PisNo'="" PisNo = $p(PisNo,"^",2)
		  	s apStatus=##Class(web.DHCAPPInterface).GetExaReqItmStatus(oeori,PisNo)
		  	s:apStatus="RP" Report="报告"
			s apStatus = ..GetResultStatus(apStatus)
			s LocID=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),3),"^",6) 						/// 接收科室 sufan 2018-03-08
			i LocID'="" s RecLoc=$p(^CTLOC(LocID),"^",2)
			s arcimid=$p(^DHCAPPPM(PisID,"A",CH),"^",1)   								/// 医嘱项ID
			s itmmastid=$p(arcimid,"||",1)
			s itmmastver=$p(arcimid,"||",2)
			s ItemLabel=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  						///医嘱项名称
			i arcListData="" s arcListData=oeori_"&&"_ItemLabel_"&&"_""_"&&"_""
			E  s arcListData=arcListData_"#"_oeori_"&&"_ItemLabel_"&&"_""_"&&"_""
			s PacsSetInfo = ##class(web.DHCAPPSeePatPacs).GetPacsOpenPortInfo(LocID)
			s UrlParams = PatNo_"^"_PisNo_"^"_oeori
			s PortUrl=##class(web.DHCAPPSeePatPacs).GetPortUrl(PacsSetInfo,UrlParams)				//报告路径
			s ImgUrl =##class(web.DHCAPPSeePatPacs).GetImgUrl(PacsSetInfo,UrlParams)
			;b ;err
	  	}
		s BlMorePort=""
		s PortNum = "" ;##class(web.DHCPisApplicationSheet).getRptCount(LocID_"^"_oeori)
		s:+PortNum>1 BlMorePort="更多"
		s ImgFlag=""  									//是否有图像
		s Params = oeori_"^"_PisNo_"^"_UserID
	    s CMStatus=##class(web.DHCAPPInterface).IsReadByParams(Params)  ;##class(RISService.TrakRISService).GetRPTCMStatus(OEORIId,StudyNo,myDocCode)
		s IsReaded=""
		s isReaded=$p(CMStatus,"^",1)
		s:isReaded="Y" IsReaded="已阅读" 					  //已经阅读
		s:(Report'="")&&(isReaded'="Y") IsReaded="未阅读"   //已出报告并且未阅读
		
		s:Report="" IsReaded=""
		s Grade=""																	///评级													    ///阅读:待添加
		s MediumName="",Shut="",Image="",Memo="",IsModify="",IsIll="",ImageUrl=""		///TC
		s OrderByPort=""
	    s OrderByPort= """"_$case(IsReaded,"未阅读":"1",:"0")_$case(Report,"报告":"1",:"0")_""""
	    s IsCVR=""														
		;登记号^病历号^
		s ListData=PatNo_"^"_DepLocDesc_"^"_PatientID_"^"_PisNo_"^"_ItemLabel_"^"_CreatDateTime_"^"_apStatus
		s ListData=ListData_"^"_oeori_"^"_IsIll_"^"_RecLoc_"^"_LocID
		s ListData=ListData_"^"_ImgFlag_"^"_MediumName_"^"_Image_"^"_Shut
		s ListData=ListData_"^"_Report_"^"_Memo_"^"_ImageUrl_"^"_Grade_"^"_IsModify
		s ListData=ListData_"^"_IsReaded_"^"_ImgUrl_"^"_PortUrl_"^"_BlMorePort_"^"_IsCVR
		s index=No_"^"_PisID
		s LisOrdList("Data",OrderByPort,OrderByDesc,1,+PisNo,oeori)=No_"^"_ListData
	 	
	}
	
	q
}

ClassMethod GetTmInfoByOrderRowId(OrdItm)
{
	s CurrSpace=$ZNSPACE
  	zn "PIS"
  	s PisNo = ##class(Src.DPIS3OutInterface).GetPisrowidByOrderRowId(OrdItm)
  	zn CurrSpace
  	q PisNo
}

/// Shy
/// 2023-01-04
/// 医嘱查询
/// d ##class(web.DHCPRESCQuery).GetAdmOeordInfo(509)
ClassMethod GetAdmOeordInfo(Adm)
{
	q:+Adm=0 ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)	
	
	s count=0	
	s listTitle="ID^Code^Desc"
	w "{""rows"":["
	s oeordID=0	  
	f  s oeordID=$o(^OEORD(0,"Adm",Adm,oeordID)) q:oeordID=""  d
	.s subID=0  
	.f  s subID=$o(^OEORD(oeordID,"I",subID))  q:subID=""  d
	..s arcMID=$p(^OEORD(oeordID,"I",subID,1),"^",2)
	..s arcID=$p(arcMID,"||",1)
	..s arcsubID=$p(arcMID,"||",2)
	..s oeOrdCode=$p(^ARCIM(arcID,arcsubID,1),"^",1)
	..s oeOrdDesc=$p(^ARCIM(arcID,arcsubID,1),"^",2)
	..s listData=arcMID_"^"_oeOrdCode_"^"_oeOrdDesc
	..s count=count+1
	..i count=1 D
	...w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	
	w "],""total"":"_count_"}"
	q ""
}

}
