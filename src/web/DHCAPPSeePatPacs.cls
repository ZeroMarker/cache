Import sqluser

/// Descript:   急诊检查结果查看
/// Creator:    QQA 
/// CreateDate: 2017-11-28
Class web.DHCAPPSeePatPacs Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:QQA
/// CreatTime:2018-02-24
/// Descript:检查结果查询与病理合并使用:检查项目内容获取
/// w ##class(web.DHCAPPSeePatPacs).GetLisInspectOrdNew(1,10,"38^38^2022-10-31^2022-10-31^17314^^4^^")
ClassMethod GetLisInspectOrdNew(page As %String, rows As %String, Params As %String)
{
	n (page,rows,Params,%session)
	s ^Tempqujian("GetLisInspectOrdNew")=page_","_rows_","_Params
	s Adm = $p(Params,"^",1)   
	s PatDr = $p(Params,"^",2)
	s:+Adm'=0 PatDr = $p(^PAADM(Adm),"^",1)
	s StartDate = $p(Params,"^",3)
	s EndDate = $p(Params,"^",4)
	s UserID = $p(Params,"^",5)
	s AdmType=$p(Params,"^",6)
	s OrdType=$p(Params,"^",7)
	s ReqNo=$p(Params,"^",8)
	s PisFlag=0 //在医嘱ID/申请单号不为空时,有可能传入的是病理的申请
	;传入申请单号不为空，根据单号获取相应的就诊，降低查询时间
	if (ReqNo'="") {
		s ARRowID=$o(^DHCAPREP(0,"ARNo",ReqNo,""))
		if (ARRowID="") {
			s ARRowID=$o(^DHCAPPPM(0,"PisNo",ReqNo,"")),PisFlag=1
		}
		if (ARRowID'="") {
			s Adm=$p(^DHCAPREP(ARRowID),"^",6)
		}
	}
	;传入医嘱ID不为空，根据医嘱ID获取相应的就诊，降低查询时间
	s InOEORIId=$p(Params,"^",9)
	if (InOEORIId'="") {
		s Adm = $p(^OEORD(+InOEORIId),"^",1)
		s ARRowID=$o(^DHCAPREP(0,"OrdItem",InOEORIId,""))
		if (ARRowID="") {
			s ARRowID=$o(^DHCAPPPM(0,"OrdItem",InOEORIId,"")),PisFlag=1
		}
	}
	s:+Adm'=0 PatDr = $p(^PAADM(Adm),"^",1)
	s:UserID="" UserID = $g(%session.Data("LOGON.USERID"))
	s StartDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)
	s EndDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	s:StartDate="" StartDate=..%SysDate()-365    //为空的时候查询一年的信息
	s:EndDate="" EndDate=..%SysDate()
	s Count=0,Del=""""
	s Start=page-1*rows+1
	s End=page*rows
	//s Pid = ##Class(web.DHCAPPExaRepCom).NewPid()
	k LisOrdList
	if ($g(ARRowID)'="")&&(PisFlag=0) { //传入申请单号/医嘱ID查询时可精确到申请ID
		s ARCreateDate=$p(^DHCAPREP(ARRowID),"^",2)
		s ARChildSub=""
		for {
			s ARChildSub= $o(^DHCAPREP(ARRowID,"AR",ARChildSub)) Q:ARChildSub="" 
			d GetLisOrdData(ARRowID,ARChildSub)
		}
	}elseif (Adm'="") {
		s ARRowID=0
		for {
			s ARRowID=$o(^DHCAPREP(0,"ADM",Adm,ARRowID)) Q:ARRowID=""
			s ARCreateDate=$p(^DHCAPREP(ARRowID),"^",2)
			continue:(ARCreateDate>EndDate)||(ARCreateDate<StartDate)
			s ARChildSub=""
			for {
				s ARChildSub= $o(^DHCAPREP(ARRowID,"AR",ARChildSub)) Q:ARChildSub="" 
				d GetLisOrdData(ARRowID,ARChildSub)
			}
		}
	}else{
	    /*f Date=StartDate:1:EndDate{
		    s ARRowID=""
		    for {
			    s ARRowID = $o(^DHCAPREP(0,"CreateDate",Date,ARRowID)) q:ARRowID=""
			    s ARChildSub=""
			    for {
				    s ARChildSub= $o(^DHCAPREP(ARRowID,"AR",ARChildSub)) q:ARChildSub=""
			    	d GetLisOrdData(ARRowID,ARChildSub)
			    }
		    }
	    }*/
		s PAAdmType="" f  s PAAdmType=$O(^PAPERdr(PatDr,"ADM",PAAdmType)) Q:PAAdmType=""  d
		.s OrdAdm=0 f  s OrdAdm=$O(^PAPERdr(PatDr,"ADM",PAAdmType,OrdAdm)) Q:OrdAdm=""  d
		..s ARRowID=0 f  s ARRowID=$O(^DHCAPREP(0,"ADM",OrdAdm,ARRowID)) Q:ARRowID=""  d
		...s CreateDate=$P(^DHCAPREP(ARRowID),"^",2)
		...Q:((StartDate'="")&&(CreateDate<StartDate))||((EndDate'="")&&(CreateDate>EndDate))
		...s ARChildSub=""
		...for  s ARChildSub= $o(^DHCAPREP(ARRowID,"AR",ARChildSub)) Q:ARChildSub=""  d
		....d GetLisOrdData(ARRowID,ARChildSub)
	}
	b ;data
	d ..GetLisOrdDetails(.LisOrdList,UserID)
    
    /*上半部分是获取检查数据*/
  	///获取病理相关数据
    s StDate=StartDate   													/// 开始日期
    s EndDate=EndDate  														/// 结束日期
    s EpiType=AdmType      													/// 就诊类型
    if ($g(ARRowID)'="")&&(PisFlag=1) { //传入申请单号/医嘱ID查询时可精确到申请ID
    	s PisID=ARRowID
    	s CH=""
    	for {
	    	s CH=$o(^DHCAPPPM(ARRowID,"A",CH)) Q:CH=""
	    	s oeori=$p(^DHCAPPPM(PisID,"A",CH),"^",3)
	    	continue:oeori=""
	    	continue:(InOEORIId'="")&&(InOEORIId'=oeori)
	    	s ARCICatInfo = ##class(web.DHCEMInComUseMethod).GetARCICatByOEORDItmDr(oeori)  //医嘱子类信息
	    	s ARCICatDr = $p(ARCICatInfo,"^",1)
			continue:+ARCICatDr=0
	    	s AccID = $o(^DHCAPARCCA(0,"O",ARCICatDr,""))
			continue:(OrdType'="")&&(AccID'=OrdType)
			s LisOrdList("PisGroup",PisID)="" 
	    }
    }elseif(Adm'=""){
	    s PisID=""
	    for {
		    s PisID=$o(^DHCAPPPM(0,"Adm",Adm,PisID)) Q:PisID=""
		    s APCreateDate=$p(^DHCAPPPM(PisID),"^",6)
		    continue:(APCreateDate>EndDate)||(APCreateDate<StartDate)
		    d GetPisOrdData(PisID)
	    }
	}else {
		/*for Date=StDate:1:EndDate {
			s PisID=""
		    for {
			    s PisID=$o(^DHCAPPPM(0,"CreateDate",Date,PisID)) Q:PisID=""
		    	d GetPisOrdData(PisID)
		    }
		}*/
	    s PAAdmType="" f  s PAAdmType=$O(^PAPERdr(PatDr,"ADM",PAAdmType)) Q:PAAdmType=""  d
		.s OrdAdm=0 f  s OrdAdm=$O(^PAPERdr(PatDr,"ADM",PAAdmType,OrdAdm)) Q:OrdAdm=""  d
		..s PisID=0 f  s PisID=$O(^DHCAPPPM(0,"Adm",OrdAdm,PisID)) Q:PisID=""  d
		...s CreateDate=$P(^DHCAPPPM(PisID),"^",6)
		...Q:((StartDate'="")&&(CreateDate<StartDate))||((EndDate'="")&&(CreateDate>EndDate))
		...d GetPisOrdData(PisID)
	}
	d ..GetPisOrdDetails(.LisOrdList,UserID)
	
    s Num=0
    Write ##class(web.DHCAPPJsonCommon).getJsonStartNoTotal() //输出json前缀串
    s RsStr="BLOrJC^RowNum^ReqNo^RegNo^AdmLoc^PatientID^StudyNo^strOrderName^strOrderDate^ItemStatus^OEORIId^IsIll^recLocName^recLocDr^IshasImg^MediumName^Image^Shut^Report^Memo^ImageUrl^Grade^IsModify^IsReaded^ImgUrl^PortUrl^BlMorePort^IsCVR^Bookingtime^ARCIMId^PartID^EpisodeID^mradm"
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
GetLisOrdData(ARRowID,ARChildSub)
	s OEORIId = $p(^DHCAPREP(ARRowID,"AR",ARChildSub),"^",3)
    q:OEORIId=""
    q:(InOEORIId'="")&&(("@"_InOEORIId_"@")'[("@"_OEORIId_"@"))
    s OrdAdm = $p(^OEORD(+OEORIId),"^",1)
    s OrdPatDr = $p(^PAADM(OrdAdm),"^",1)
    q:OrdPatDr'=PatDr			/// 用病人id过滤 qunianpeng 2018/3/14 
    q:(+Adm'=0)&&(OrdAdm'=Adm)
    s OEOrd = +OEORIId
    s OEOrdItm = $p(OEORIId,"||",2)
    s ArciID=$p($g(^OEORD(OEOrd,"I",OEOrdItm,1)),"^",2)
	q:(ArciID="")
	s ARCICatInfo = ##class(web.DHCEMInComUseMethod).GetARCICatByOEORDItmDr(OEORIId)  //医嘱子类信息
	s ARCICatDr = $p(ARCICatInfo,"^",1)
	q:+ARCICatDr=0
	s No = $p(^DHCAPREP(ARRowID),"^",1)
	q:(ReqNo'="")&&(No'=ReqNo)
	s AccID = $o(^DHCAPARCCA(0,"O",ARCICatDr,""))
	q:(OrdType'="")&&(AccID'=OrdType)
	s OECCatDesc = ##class(web.DHCEMInComUseMethod).GetOECCatByOEORDItmDr(OEORIId)
	q:OECCatDesc'["检查"
	s ItmStatDesc = ""   //医嘱描述
	s ItmStatDr = $p(^OEORD(OEOrd,"I",OEOrdItm,1),"^",13)
	s ItmStatDesc = $p(^OEC("OSTAT",ItmStatDr),"^",2)
	s ItmStatCode=$p(^OEC("OSTAT",ItmStatDr),"^",1)
	;q:(ItmStatDesc["撤销")!(ItmStatDesc["作废")!(ItmStatDesc["停止") //这些状态的医嘱不显示
	q:(ItmStatCode="C")!(ItmStatCode="U")!(ItmStatCode="D")
	s ServerMaterial=$p($g(^ARCIM($p(ArciID,"||",1),$p(ArciID,"||",2),7)),"^",6)
	q:(ServerMaterial'="S")    ;没有service标识,不是检查医嘱退出
	s PartList = ##Class(web.DHCAPPInterface).GetExaReqPartNur(OEORIId)
	i '$d(^DHCAPREP(ARRowID,"AR",ARChildSub,"PA")) {
		s StudyNo = ##class(web.DHCAPPSeePatPacs).GetStudyNoByORORIAndPart(OEORIId,"")
		s:StudyNo="" StudyNo=0
		s LisOrdList("PacsGroup",StudyNo,OEORIId,0)=""
	}
	k OrdPartBookArr
	d ..GetBookDateObj(OEORIId,"","",.OrdPartBookArr)
	s RepPartID=""
	for {s RepPartID= $o(^DHCAPREP(ARRowID,"AR",ARChildSub,"PA",RepPartID)) q:RepPartID=""
		s ReqPartStatus = $p(^DHCAPREP(ARRowID,"AR",ARChildSub,"PA",RepPartID),"^",2)
		continue:ReqPartStatus="D"                      //D为停止状态
		s PartID = $p(^DHCAPREP(ARRowID,"AR",ARChildSub,"PA",RepPartID),"^",1)
		s StudyNo = ##class(web.DHCAPPSeePatPacs).GetStudyNoByORORIAndPart(OEORIId,PartID)
		//s hasBooked=##class(web.DHCRisResApptSchudleSystem).HasBooked(OEORIId,PartID) ;##class(web.DHCRisResApptSchudleSystem).getBookDetailRowid(OEORIId_"^"_PartID)    //预约的和申请的分开
		s PartDesc=$p($g(^DHCAPPART(PartID)),"^",2) 
		if StudyNo="" {
			//s StudyNo = ##class(web.DHCAPPSeePatPacs).GetStudyNoByORORIAndPart(OEORIId,"")
		}
		s Booktime=$P($G(OrdPartBookArr(OEORIId,PartDesc)),"^",1)
		s BookKey=$P($G(OrdPartBookArr(OEORIId,PartDesc)),"^",2)
		//s:(booktime="Y")&&(StudyNo="") StudyNo=-1
		if (Booktime'="")&&(StudyNo=""){
			//按部位拆分预约但还未登记时，需要按部位展示检查
			s StudyNo="-1"_"@@"_BookKey
		}
		s:StudyNo="" StudyNo=0
		s:PartID="" PartID=0
		s LisOrdList("PacsGroup",StudyNo,OEORIId,ARRowID_"||"_ARChildSub_"||"_RepPartID)=PartID
	}
	Q
GetPisOrdData(PisID)
	s EpisodeID=$p(^DHCAPPPM(PisID),"^",1)  										/// 就诊ID
    s ApStatus=$p(^DHCAPPPM(PisID),"^",9)  										/// 申请单状态
    q:ApStatus="D"
    q:'$d(^PAADM(EpisodeID))
    s PatType=$p($g(^PAADM(EpisodeID)),"^",2)										/// 就诊类型
    q:(EpiType'="")&&(PatType'=EpiType)
    q:(+Adm'=0)&&(+Adm'=EpisodeID)                                                /// 过滤Adm
    s PatientID=$p(^PAADM(EpisodeID),"^",1)										/// 病人ID
    q:(PatDr'="")&&(PatDr'=PatientID)
    s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  		 							/// 登记号       									/// 申请单号
	q:(ReqNo'="")&&(ReqNo'=No)
  	s oeori=""
  	s CH=""
  	for {s CH=$o(^DHCAPPPM(PisID,"A",CH))  Q:(CH="")||(oeori'="")
	  	s oeori=$p(^DHCAPPPM(PisID,"A",CH),"^",3)
	  	continue:+oeori="0"
  	}
  	Q:oeori=""
  	s ArciID=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),1)),"^",2)
	q:(ArciID="")
	//q:(InOEORIId'="")&&(InOEORIId'=oeori)
	q:(InOEORIId'="")&&(("@"_InOEORIId_"@")'[("@"_oeori_"@"))
	s ARCICatInfo = ##class(web.DHCEMInComUseMethod).GetARCICatByOEORDItmDr(oeori)  //医嘱子类信息
	s ARCICatDr = $p(ARCICatInfo,"^",1)
	q:+ARCICatDr=0
	s AccID = $o(^DHCAPARCCA(0,"O",ARCICatDr,""))
	i AccID="" s AccID=$o(^DHCAPARCCA(0,"Arc",ArciID,""))
	q:(OrdType'="")&&(AccID'=OrdType) 
	s LisOrdList("PisGroup",PisID)=""
	Q
}

/// /w ##class(web.DHCAPPSeePatPacs).GetStudyNoByORORIAndPart("4||4","")
ClassMethod GetStudyNoByORORIAndPart(OEORIId, PartID)
{
	n (OEORIId,PartID)
	;V8.3开始,检验检查(含东华及第三方的)都会存储数据到医院信息平台的数据结构中
	s PartDesc=""
	if PartID'="" s PartDesc=$p($g(^DHCAPPART(PartID)),"^",2) 
	s DataList=[]
	s DymObj={}
	s DymObj.OEOrdItemID =OEORIId
	s DymObj.ExamID =""
	s DymObj.Position= PartDesc
	d DataList.%Push(DymObj)
	s Steam = ##class(%Stream.GlobalCharacter).%New()
	d Steam.Write(DataList.%ToJSON())
	s RetSteam = ##class(web.DHCENS.EnsHISService).DHCHisInterface("QuerySystemStatus",Steam)
	s RetString = RetSteam.Read()
	q:$find(RetString,"ResultCode") ""
	s RetArr =[]
	s RetArr = RetArr.%FromJSON(RetString)
	s RetObj = RetArr.%Get(0)
	s ExamID = RetObj.ExamID
	
	if (RetObj.Status="AP") s ExamID = ""
	q ExamID
	/*
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
	*/
	;s:StudyNo="" StudyNo = ##class(web.DHCEkg.GetEkgReportState).GetEkgStudyId(OEORIId)   //心电的检查号获取
	;q StudyNo
}

ClassMethod GetPortStatusCodeByStudyNo(StudyNo)
{
	n (StudyNo)
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
	 n (RegNo, Type ,StartDate,EndDate, DayNum)
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
	n (OEORIId,StudyNoLab,%session)
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
	s strOrderDate=..%ZD(OrderDate)
	s OrderTime=$p(^OEORD(Ord,"I",Itm,1),"^",10) 
	s strOrderTime=..%ZT(OrderTime)
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
				s IshasImg=..GetImageStatus(StudyNo)
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
	n (PacsSetInfo,Params)
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
	s RStartDate = $p(PacsSetInfo,"^",26)
	s REndDate = $p(PacsSetInfo,"^",27)
	q:((RStartDate'="")&&(RStartDate<+$H)) ""
	q:((REndDate'="")&&(REndDate>+$H)) ""
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
	n (PacsSetInfo,Params)
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
	s IStartDate = $p(PacsSetInfo,"^",28)
	s IEndDate = $p(PacsSetInfo,"^",29)
	q:((IStartDate'="")&&(IStartDate<+$H)) ""
	q:((IEndDate'="")&&(IEndDate>+$H)) ""
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
	n (OEORIId,StudyNoLab)
	s OrdName =""
	s:StudyNoLab="" OrdName = ##class(web.DHCAPPSeePatPacs).GetPacsOrdNameByOEORI(OEORIId)
	s:StudyNoLab'="" OrdName = ##class(web.DHCAPPSeePatPacs).GetPacsOrdNameByStudyNo(StudyNoLab)
	q OrdName
}

/// w ##class(web.DHCAPPSeePatPacs).GetPacsOrdNameByOEORI("740||4")
ClassMethod GetPacsOrdNameByOEORI(OEORIId)
{
	n (OEORIId)
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
	n (StudyNoLab)
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
	n (StudyNoLab)
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
	zn "DHC-PACS"
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
	n (LocDr)
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
	.s RStartDate=$P($g(^DHCRBC("ClinicSet",Rowid)),"^",27)
	.s REndDate=$P($g(^DHCRBC("ClinicSet",Rowid)),"^",28)
	.s IStartDate=$P($g(^DHCRBC("ClinicSet",Rowid)),"^",29)
	.s IEndDate=$P($g(^DHCRBC("ClinicSet",Rowid)),"^",30)
	q:hasSet'=1 ""
	s rsData = ReportFullFile_"^"_RegYesNo_"^"_RRegParam_"^"_RStudyNOYesNo_"^"_RStudyParam
	s rsData = rsData_"^"_ReportDelim_"^"_ImageFullFile_"^"_IRegYesNo_"^"_IRegParam_"^"_IStudyNOYesNo
	s rsData = rsData_"^"_IStudyNOParam_"^"_ImageDelim_"^"_ROtherYesNo_"^"_ROtherParam_"^"_IOtherYesNo
	s rsData = rsData_"^"_IOtherParam_"^"_ROeitemYesNo_"^"_ROeitemParam_"^"_IOeitemYesNo_"^"_IOeitemParam
	s rsData = rsData_"^"_IsOpenList_"^"_RRepIdYesNo_"^"_RRepIdParam_"^"_IRepIdYesNo_"^"_IRepIdParam
	s rsData = rsData_"^"_RStartDate_"^"_REndDate_"^"_IStartDate_"^"_IEndDate
	
	q rsData
}

ClassMethod GetParam(Params)
{
 n (Params)
 s LocDr = $p(Params,"^",1)
 s PatientID = $p(Params,"^",2)
 s OEORIId = $p(Params,"^",3)
 s OEORIId = $P($P(OEORIId,"^",1),"@",1)
 s PatInfo=""
 s DateSet = ##class(web.DHCEMCommonUtil).DateFormat()
 s:PatientID PatInfo=##class(web.DHCEMECheck).GetPatInfoByPatId(PatientID)
 s RegNolenghtInfo = ##class(web.DHCCLCom).GetPatConfig()
 s OrdStDate = ##class(web.DHCAPPSeePatPacs).GetOrdStDate(OEORIId)
 q DateSet_"#"_$p(PatInfo,"^",1)_"#"_$p(RegNolenghtInfo,"^",1)_"#"_OrdStDate
}

ClassMethod GetOrdStDate(OEORIId)
{
	n (OEORIId)
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
 n (Params,%session)
 s Stream=##class(%Stream.GlobalCharacter).%New()
 d Stream.Write("[")
 Set langid=..%LanguageID()
 s Count=0
 
 s HospID = $p(Params,"^",1)
 s ArccaID=0
 f  s ArccaID = $o(^DHCAPARCCA(ArccaID)) q:ArccaID=""  d
 .s ArccaHospDr = $p(^DHCAPARCCA(ArccaID),"^",4)
 .//q:$d(^DHCAPARCCA(ArccaID,"I"))'=10
 .q:(HospID'="")&(HospID'=ArccaHospDr)
 .s ArccDesc = $p(^DHCAPARCCA(ArccaID),"^",2)
 .q:ArccDesc["检验"
 .Set ArccDesc= ##class(User.DHCAppArcCat).GetTranByDesc("ACCatDesc",ArccDesc,langid)
 .s Data = ArccaID_"^"_ArccDesc
 .s Count=Count+1
 .d Stream.Write($case(Count,1:"",:","))
 .d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text",Data))
 d Stream.Write("]")
 q Stream.Read()
}

/// Creator:QQA
/// CreatDate:2018-03-08
/// Descript:报告查看和图像查看
/// Input:Model(I图像R报告)
/// w ##class(web.DHCAPPSeePatPacs).ClinicRecordSet("R","329^286^0000000100^US20180301003^4636^47||12")
ClassMethod ClinicRecordSet(Model, Params)
{
	n (Model,Params)
	s RecLocDR=$p($g(Params),"^",1)    //接受科室
	s LoginLocDR=$p($g(Params),"^",2)  //登录科室
	s RegNo=$p($g(Params),"^",3)       //登记号
	s StudyNo=$p($g(Params),"^",4)     //检查号
	s Date=..%SysDate()					//阅读日期
	s Time=..%SysTime()				   //阅读时间
	s UserDR=$p($g(Params),"^",5)      //阅读人
	s OrditemDR=$p($g(Params),"^",6)   //医嘱ID
	s PartID=$p($g(Params),"^",7)  //部位
	s PartStr=""
	if (PartID'=""){
		for i=1:1:$L(PartID,"+") {
			s PartIDDr=$P(PartID,"+",i)
			if PartStr="" s PartStr=$p($g(^DHCAPPART(PartIDDr)),"^",2) 
			else  s PartStr=PartStr_"+"_$p($g(^DHCAPPART(PartIDDr)),"^",2) 
			}
		}
	;医嘱id^检查病理号/检验号^当前登录科室^阅读人
	s DataList = OrditemDR_"^"_StudyNo_"^"_LoginLocDR_"^"_UserDR_"^^"_PartStr
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
	n (Params)
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
	n (page,rows,Params)
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
	.s:DDRReadTime'="" DDRReadTime = ..%ZT(DDRReadTime,2)
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
/// w ##class(web.DHCAPPSeePatPacs).ReadDetailByParams(1,6,"18||60^U20190216005")
ClassMethod ReadDetailByParams(page, rows, Params)
{
	n (page,rows,Params)
	d ##class(web.DHCAPPInterface).ReadDetailByParams(page, rows, Params)
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
	n (PatientID)
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
	n (Oeori)
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
	n (OEORIId)
	s GetReqNo=""
	s ARRowID = $o(^DHCAPREP(0,"OrdItem",OEORIId,""),-1)
	s:ARRowID'="" GetReqNo=$p(^DHCAPREP(ARRowID),"^",1)
	q GetReqNo
}

/// 获取检查明细数据
ClassMethod GetLisOrdDetails(ByRef LisOrdList, UserID As %String) As %String
{
	n (LisOrdList,UserID,%session)
	Set langid=..%LanguageID()
	s StudyNo="" 
	f  {
		s StudyNo = $o(LisOrdList("PacsGroup",StudyNo))
		q:StudyNo=""
		s OEORIId = ""
		f  {
			s OEORIId = $o(LisOrdList("PacsGroup",StudyNo,OEORIId))
			q:OEORIId=""
			s Ord = +OEORIId
			s Itm = $p(OEORIId,"||",2)
			s ARCIMId=$p($g(^OEORD(Ord,"I",Itm,1)),"^",2)
			s ARCIName = 	$p(^ARCIM($p(ARCIMId,"||",1),$p(ARCIMId,"||",2),1),"^",2)   ///获取医嘱名称
			s ARCIName=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ARCIName,langid)
			s RecLocName=""
			s RecLocDr=$p($g(^OEORD(Ord,"I",Itm,3)),"^",6)
			i RecLocDr'="" s RecLocName=$p(^CTLOC(RecLocDr),"^",2)
			s RecLocName=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",RecLocName,langid)
			s:RecLocDr'="" PacsSetInfo = ..GetPacsOpenPortInfo(RecLocDr)
			s ClinicRowid=$o(^DHCRBCi("LocClinicSet",RecLocDr,0))
			
			;s ExamStatus="A"    ;默认状态为申请               ///PartDesc 是获取统一个检查号下多个部位描述
			//s ExamID = $case(StudyNo,-1:"",0:"",:StudyNo)
			s ExamID=""
			if (StudyNo'=0)&&($P(StudyNo,"@@")'=-1)&&($P(StudyNo,"^")'=-1){
				s ExamID=StudyNo
			}
			s IsCVR = ##Class(web.DHCAntService).IsCVReport(ExamID,OEORIId)
			s IsCVR = $case(+IsCVR,1:##class(websys.Translation).Get("dhcapp.inspectrs.csp","是"),0:##class(websys.Translation).Get("dhcapp.inspectrs.csp","否"),:##class(websys.Translation).Get("dhcapp.inspectrs.csp","否"))
			s Position="" //ARRowID_"||"_ARChildSub_"||"_RepPartID
			s InitPartID="",DispDesc=""
			s RepPartID = "",PartDesc="",PartID=""
			f  {
				s RepPartID = $o(LisOrdList("PacsGroup",StudyNo,OEORIId,RepPartID))
				q:RepPartID=""
				s PartID=$g(LisOrdList("PacsGroup",StudyNo,OEORIId,RepPartID))
				continue:PartID=""
				s:InitPartID'="" InitPartID=InitPartID_"+"_PartID
				s:InitPartID="" InitPartID=PartID
				s PartItmDesc = $p($g(^DHCAPPART(PartID)),"^",2) 
				s PartItmDesc=##class(User.DHCAppPart).GetTranByDesc("APDesc",PartItmDesc,langid)
				s:PartDesc'="" PartDesc=PartDesc_"+"_PartItmDesc
				s:PartDesc="" PartDesc=PartItmDesc
				s PosiDesc=##Class(web.DHCAPPExaReportQuery).GetRepPosi(RepPartID) /// 体位
				if (PosiDesc'="") s PartDesc=PartDesc_"("_PosiDesc_")"
				s:Position'="" Position=Position_"@@"_PartItmDesc
				s:Position="" Position=PartItmDesc
				s DispDesc=##Class(web.DHCAPPExaReportQuery).GetRepDisp(+RepPartID_"||"_$P(RepPartID,"||",2)) ///后处理
			}
			
			s ExamStatus=##Class(web.DHCAPPInterface).GetExaReqItmStatus(OEORIId,ExamID,Position)
			
			s StrOrderName = ARCIName ;//_$case(PartDesc,"":"",:"("_PartDesc_")")
			i DispDesc'="" s StrOrderName=StrOrderName_" + "_DispDesc
			i PartDesc'="" s StrOrderName=StrOrderName_"【"_PartDesc_"】"
			;s StrOrderName = ##Class(web.DHCAPPInterface).GetExaReqItemDesc(OEORIId)
			s OrderDate=$p(^OEORD(+OEORIId,"I",$p(OEORIId,"||",2),1),"^",9)
			s OrderTime=$p(^OEORD(+OEORIId,"I",$p(OEORIId,"||",2),1),"^",10)
			s OrderByDesc = +OrderDate_+OrderTime
			s OrdAdm = $p(^OEORD(+OEORIId),"^",1)								   //就诊ID	
    		        s PatDr = $p(^PAADM(OrdAdm),"^",1)							   //病人ID
			s MRAdmID = $p(^PAADM(OrdAdm),"^",61)							   //
			s RegNo=$p(^PAPER(PatDr,"PAT",1),"^",1)                              //病人登记号
			s DepLoc=$p(^PAADM(OrdAdm),"^",4)       						       //就诊科室
			s DepLocDesc = $p(^CTLOC(DepLoc),"^",2)	
			s DepLocDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",DepLocDesc,langid)
			s PatID = PatDr
			s OrderDate="",OrderTime=""													   //病人ID
			s OrderDate=$p(^OEORD(Ord,"I",Itm,1),"^",9)
			s strOrderDate=..%ZD(OrderDate)
			s OrderTime=$p(^OEORD(Ord,"I",Itm,1),"^",10) 
			s strOrderTime=..%ZT(OrderTime,2)
			s strOrderDateDesc = strOrderDate_" "_strOrderTime                  //日期+时间
			s IshasImg="",Image="",Report="",Memo="",ImageUrl="",Grade="",IsReaded="",ImgUrl=""
			s PortUrl="",BlMorePort="",IsIll=""
			i (ExamID'="") d
			.;s ExamStatus="SC"   ;登记
			.s RegRowid = $o(^DHCPACRegInfoi("StudyNo",ExamID,""))
			.s:RegRowid'="" ImageUrl=$p(^DHCPACRegInfo(RegRowid),"^",22)      ;存放外部传输过来的URL RegRowid 待发布
			.s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",ExamID,""),"-1")
			.i RptRowId'="" d
			..;s ExamStatus="RP"  ;已写报告
			..s StatusDR=$p(^DHCRBStudy("Report",RptRowId),"^",4)
			..s StatusCode=""
			..i StatusDR'="" s StatusCode=$p(^DHCRBCStatus("ReportStatus",StatusDR),"^",1)
			..s IsIll = $p(^DHCRBStudy("Report",RptRowId),"^",7)
			..s Memo=$g(^DHCRBStudy("Report",RptRowId,"MemoEx"))
			..;s:StatusCode="S" ExamStatus="CM"
			;if ClinicRowid'="" d   ;配置了临床查看报告路径才能显示链接
			s:IsIll="" IsIll = ##class(web.DHCEkg.GetEkgReportState).GetEkgPositive(OEORIId)   //心电报告是否阳性 
			if ("^IM^RP^CM^DIAG^CRP^PRP^")[("^"_ExamStatus_"^") s Image="图像",IshasImg="Y"
			i ((ExamStatus="RP")||(ExamStatus="RD")) d   ;默认检查完成后才能查看报告和图像
			.s Report="报告"
			.s Grade="评级"
			s Params = OEORIId_"^"_$case(StudyNo,0:"",:StudyNo)_"^"_UserID
			s IsReadedFlag=##class(web.DHCAPPInterface).IsReadByParams(Params)
			s IsModify=""                 		//是否修改                      
			s:(ExamStatus="RP")&&(IsReadedFlag'="Y") IsReaded="未阅读"
			s:(ExamStatus'="RP") IsReaded=""
			s:IsReadedFlag="Y" IsReaded="已阅读"
			s ItemStatus=..GetResultStatus(ExamStatus)
			s No=##class(web.DHCAPPSeePatPacs).GetReqNo(OEORIId)
			s Bookingtime=""
			;找其中一个部位的预约时间即可
			s Bookingtime=..GetBookDateObj(OEORIId,"",$P(InitPartID,"+",1))
			s UrlParams = RegNo_"^"_StudyNo_"^"_OEORIId
			s ImgUrl = ##class(web.DHCAPPSeePatPacs).GetImgUrl(PacsSetInfo,UrlParams) ;$p(PacsSetInfo,"^",7)     //
			s PortUrl = ##class(web.DHCAPPSeePatPacs).GetPortUrl(PacsSetInfo,UrlParams) ;$p(PacsSetInfo,"^",1)
			s OrderByPort=""""_$case(IsReaded,"未阅读":"1",:"0")_$case(Report,"报告":"1",:"0")_""""
			s IsReaded=##class(websys.Translation).Get("dhcapp.inspectrs.csp",IsReaded)
			s Report=##class(websys.Translation).Get("dhcapp.inspectrs.csp",Report)
			s ItemStatus=##class(websys.Translation).Get("dhcapp.inspectrs.csp",ItemStatus)
			s Image=##class(websys.Translation).Get("dhcapp.inspectrs.csp",Image)
			s Grade=##class(websys.Translation).Get("dhcapp.inspectrs.csp",Grade)
			s PacsData=RegNo_"^"_DepLocDesc_"^"_PatID_"^"_ExamID_"^"_StrOrderName_"^"_strOrderDateDesc_"^"_ItemStatus_"^"_OEORIId_"^"_$g(IsIll)_"^"_RecLocName_"^"_RecLocDr_"^"_IshasImg_"^"_$g(MediumName)_"^"_Image_"^"_$g(Shut)_"^"_Report_"^"_Memo_"^"_ImageUrl_"^"_Grade_"^"_$g(IsModify)_"^"_IsReaded_"^"_ImgUrl_"^"_PortUrl
			s LisOrdList("Data",OrderByPort,OrderByDesc,0,StudyNo,OEORIId)=No_"^"_PacsData_"^"_BlMorePort_"^"_IsCVR_"^"_Bookingtime_"^"_ARCIMId_"^"_InitPartID_"^"_OrdAdm_"^"_MRAdmID
		}
	}
	q
}

ClassMethod GetPisOrdDetails(ByRef LisOrdList, UserID As %String) As %String
{
	n (LisOrdList,UserID,%session)
	Set langid=..%LanguageID()
	s PisID=""
	for {
		s PisID=$O(LisOrdList("PisGroup",PisID))
		q:(PisID="")
		s EpisodeID=$p(^DHCAPPPM(PisID),"^",1)
		s PatType=$p($g(^PAADM(EpisodeID)),"^",2)				/// 就诊类型
    	        s DepLoc=$p(^PAADM(EpisodeID),"^",4)       				//就诊科室
		s DepLocDesc = $p(^CTLOC(DepLoc),"^",2)
		s DepLocDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",DepLocDesc,langid)
		s PatientID=$p(^PAADM(EpisodeID),"^",1)					/// 病人ID
		s MRAdmID=$p($g(^PAADM(EpisodeID)),"^",61)				//
	        s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  		 	/// 登记号
		s No=$p(^DHCAPPPM(PisID),"^",4)           				/// 申请单号
		;s PisNo=$p(^DHCAPPPM(PisID),"^",13)						//病理号
		s CreatDate=$p(^DHCAPPPM(PisID),"^",6)	    			/// 申请日期
		s CreatTime=$p(^DHCAPPPM(PisID),"^",7)	   				/// 申请时间
		s OrderByDesc =+CreatDate_+CreatTime
		s:CreatDate'="" CreatDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(CreatDate) 
		s:CreatTime'="" CreatTime=..%ZT(CreatTime,2)
		s CreatDateTime = CreatDate_" "_CreatTime				//申请日期+时间
		s apStatus=$p(^DHCAPPPM(PisID),"^",9) 					/// 申请状态 

		s ID=+$p(^DHCAPPPM(PisID),"^",21)       				/// 结果状态ID
		s PisType=$p(^DHCAPPPM(PisID),"^",20)  	   									/// 申请类型
		s PisReqDesc=$s(PisType="CYT":"细胞",PisType="HPV":"HPV",PisType="TCT":"TCT",PisType="LIV":"活体",PisType="APY":"尸检",PisType="CON":"外院",PisType="MOL":"分子",1:"未知")
		s PisReqDesc=##class(websys.Translation).Get("dhcapp.inspectrs.csp",PisReqDesc)
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
		  	s OnePisNo=$p(PisNo,"^",2)
		  	s PisNo = ##class(web.DHCAPPSeePatPacs).GetStudyNoByORORIAndPart(oeori,"") ;$p(PisNo,"^",1)
		  	;s:PisNo'="" PisNo = $p(PisNo,"^",2)
		  	s apStatus=##Class(web.DHCAPPInterface).GetExaReqItmStatus(oeori,OnePisNo)
		  	s:((apStatus="RP")||(apStatus="RD")||(apStatus="PRERP")||(apStatus="SRP")) Report="报告"
			s apStatus = ..GetResultStatus(apStatus)
			s LocID=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),3),"^",6) 						/// 接收科室 sufan 2018-03-08
			i LocID'="" s RecLoc=$p(^CTLOC(LocID),"^",2)
			s RecLoc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",RecLoc,langid)
			s arcimid=$p(^DHCAPPPM(PisID,"A",CH),"^",1)   								/// 医嘱项ID
			s itmmastid=$p(arcimid,"||",1)
			s itmmastver=$p(arcimid,"||",2)
			s ItemLabel=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  	
			s ItemLabel=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ItemLabel,langid)					///医嘱项名称
			i arcListData="" s arcListData=oeori_"&&"_ItemLabel_"&&"_""_"&&"_""
			E  s arcListData=arcListData_"#"_oeori_"&&"_ItemLabel_"&&"_""_"&&"_""
			s PacsSetInfo = ##class(web.DHCAPPSeePatPacs).GetPacsOpenPortInfo(LocID)
			s UrlParams = PatNo_"^"_PisNo_"^"_oeori
			s PortUrl=##class(web.DHCAPPSeePatPacs).GetPortUrl(PacsSetInfo,UrlParams)				//报告路径
			s ImgUrl =##class(web.DHCAPPSeePatPacs).GetImgUrl(PacsSetInfo,UrlParams)
			;b ;err
	  	}
		s BlMorePort=""
		//s PortNum = ##class(web.DHCPisApplicationSheet).getRptCount(LocID_"^"_oeori)
		//s:+PortNum>1 BlMorePort="更多"
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
	    s IsCVR = ##Class(web.DHCAntService).IsCVReport(PisNo,oeori)
		s IsCVR = $case(+IsCVR,1:##class(websys.Translation).Get("dhcapp.inspectrs.csp","是"),0:##class(websys.Translation).Get("dhcapp.inspectrs.csp","否"),:##class(websys.Translation).Get("dhcapp.inspectrs.csp","否"))
	
	    s apStatus=##class(websys.Translation).Get("dhcapp.inspectrs.csp",apStatus)
	    s IsReaded=##class(websys.Translation).Get("dhcapp.inspectrs.csp",IsReaded)
	    s Report=##class(websys.Translation).Get("dhcapp.inspectrs.csp",Report)
	    s BlMorePort=##class(websys.Translation).Get("dhcapp.inspectrs.csp",BlMorePort)													
		;登记号^病历号^
		s ListData=PatNo_"^"_DepLocDesc_"^"_PatientID_"^"_PisNo_"^"_ItemLabel_"^"_CreatDateTime_"^"_apStatus
		s ListData=ListData_"^"_oeori_"^"_IsIll_"^"_RecLoc_"^"_LocID
		s ListData=ListData_"^"_ImgFlag_"^"_MediumName_"^"_Image_"^"_Shut
		s ListData=ListData_"^"_Report_"^"_Memo_"^"_ImageUrl_"^"_Grade_"^"_IsModify
		s ListData=ListData_"^"_IsReaded_"^"_ImgUrl_"^"_PortUrl_"^"_BlMorePort_"^"_IsCVR_"^"_""_"^"_$g(arcimid)_"^^"_EpisodeID_"^"_MRAdmID
		s index=No_"^"_PisID
		s LisOrdList("Data",OrderByPort,OrderByDesc,1,+PisNo,oeori)=No_"^"_ListData
	 	
	}
	
	q
}

ClassMethod GetTmInfoByOrderRowId(OrdItm)
{
	n (OrdItm)
	s CurrSpace=$ZNSPACE
  	zn "DHC-PIS"
  	s PisNo = "" ;##class(Src.DPIS3OutInterface).GetPathidByOrderRowId(OrdItm)
  	zn CurrSpace
  	q PisNo
}

/// 获取预约日期，多部位情况下，可以使用OrdPartBookArr一次性获取所有部位的预约日期信息
ClassMethod GetBookDateObj(OEOrdItemID, ExamID, PartID = "", ByRef OrdPartBookArr = "") As %String
{
	n (OEOrdItemID,ExamID,PartID,OrdPartBookArr)
	s PartDesc=""
	if PartID'="" s PartDesc=$p($g(^DHCAPPART(PartID)),"^",2) 
	s DataList=[]
	s DymObj={}
	s DymObj.OEOrdItemID =OEOrdItemID
	s DymObj.ExamID =ExamID
	d DataList.%Push(DymObj)
	s Steam = ##class(%Stream.GlobalCharacter).%New()
	d Steam.Write(DataList.%ToJSON())
	s RetSteam = ##class(web.DHCENS.EnsHISService).DHCHisInterface("QuerySystemStatusLog",Steam)
	s RetString = RetSteam.Read()
	;q:$find(RetString,"ResultCode") ""
	//s json=##class(DHCDoc.Util.FromJSON).%FromJSON(RetString)
	s Arr=##Class(DHCDoc.Util.ArrayData).%New()
	s json=Arr.%FromJSON(RetString)
	k OrdPartBookArr
	s key="",booktime=""
	For {
		Set value=json.GetNext(.key)
		Quit:key=""
		
		Set data=json.GetAt(key)
		if '$IsObject(data){continue}
		s Status=data.Data("Status")
		s PositionStr=data.Data("Position")
		if (PartDesc'="")&&(("@@"_PositionStr_"@@")'[("@@"_PartDesc_"@@")){
			continue
		}

		if (Status="BK"){
			s booktime=data.Data("Notes")
		}elseif (",CBK,OCA,")[(","_Status_","){
			//取消预约或撤销检查
			s booktime=""
		}
		
		for i=1:1:$Length(PositionStr,"@@"){
			s Position=$P(PositionStr,"@@",i)
			continue:(Position="")
			if (Status="BK"){
				;Key值可以用来标识是否按照部位拆分预约；即使是拆分预约，booktime也有可能是一样的
				s OrdPartBookArr(OEOrdItemID,Position)=booktime_"^"_key
				s booktime=data.Data("Notes")
			}elseif (",CBK,OCA,")[(","_Status_","){
				//取消预约或撤销检查
				k OrdPartBookArr(OEOrdItemID,Position)
			}
			
		}
	}
	//返回的是最后一次预约时间，多部位情况下，以OrdPartBookArr为准
	q booktime
}

}
