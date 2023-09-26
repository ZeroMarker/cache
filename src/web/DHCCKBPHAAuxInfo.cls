Class web.DHCCKBPHAAuxInfo Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      yuliping
/// CreatDate：    2021-10-20
/// Description:取关联医嘱主医嘱的Rowid
/// Input:oe_orditmRowid
/// Ouput:关联医嘱主医嘱的Rowid
/// Return:关联医嘱主医嘱的Rowid
/// Others:
ClassMethod GetMainOeori(oeori As %String) As %String
{
	N (oeori)
	Q:oeori="" ""
 	S ord=$p(oeori,"||",1) Q:ord="" ""
 	S chl=$p(oeori,"||",2) Q:chl="" ""
 	Q:'$D(^OEORD(ord,"I",chl,1)) ""
 	S loeori=$P(^OEORD(ord,"I",chl,11),"^",39)
 	Q:loeori'="" loeori
 	Q oeori
}

/// Creator：      yuliping
/// CreatDate：    2021-10-20
/// Description:： 查询医嘱信息
/// Others：       w ##class(web.DHCCKBPHAAuxInfo).listOrder("4")
ClassMethod listOrder(EpisodeIDs = "", type As %String = "")
{
  
	n (EpisodeIDs,type,%request,%session)
	q:+EpisodeIDs=0 ##class(web.DHCCKBPHAAuxInfo).EmptyDataGrid()
	s start=##class(web.DHCCKBPHAAuxInfo).GetStartRow()
	s end=##class(web.DHCCKBPHAAuxInfo).GetEndRow()
	
	
	
	s titlestr="OrdCreateDate^ArcimDesc^DoseQty^Dura^Instr^PHFreq^DoseUnit^OrdStatus^mOeori^Oeori"
	s count=0
	w "{""rows"":["
	s length = $l(EpisodeIDs,",")
	for I=1:1:length
	{
		s episodeId = $p(EpisodeIDs,",",I)

		s ds = ##Class(%Library.ResultSet).%New("web.DHCCKBPHAAuxInfo:GetOrdByAdm")
		d ds.Execute(episodeId,"","","","","","","",type)
		While (ds.Next())
		{
			s count=count+1
			continue:(count<start)||(count>end)
			
			w $case(count,start:"",:",")
			
			s ArcimDesc=ds.Data("ArcimDesc")
			s OrdStatus=ds.Data("OrdStatus")
			s DoseUnit=ds.Data("DoseUnit")
			s $p(rowData,"^",1)=ds.Data("OrdCreateDate")
			s $p(rowData,"^",3)=ds.Data("DoseQty")
			s $p(rowData,"^",4)=ds.Data("Dura")
			s $p(rowData,"^",5)=ds.Data("Instr")
			s $p(rowData,"^",6)=ds.Data("PHFreq")
			
			s $p(rowData,"^",9)=ds.Data("mOeori")
			s $p(rowData,"^",10)=ds.Data("OEItemID")
			s ArcimDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.ARCItmMast","ARCIMDesc","",ArcimDesc)
			s OrdStatus=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.OECOrderStatus","OSTATDesc","",OrdStatus)
			s DoseUnit=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTUOM","CTUOMDesc","",DoseUnit)
			s $p(rowData,"^",2)=ArcimDesc
			s $p(rowData,"^",7)=DoseUnit
			s $p(rowData,"^",8)=OrdStatus
			w ##class(web.DHCAPPJsonCommon).getJsonData(titlestr,rowData)	
		
		}		
	}
    w "],""total"":"_count_"}"
	q ""
}

/// d ##class(web.DHCCKBPHAAuxInfo).GetStartRow()
/// Creator：      yuliping
/// CreatDate：    2021-10-20
/// Description:   返回起始行数
ClassMethod GetStartRow() As %String
{
	s page=+$g(%request.Data("page",1))
	s rows=+$g(%request.Data("rows",1))
	q:page=0 1
	q (page-1)*rows+1
}

/// d ##class(web.DHCCKBPHAAuxInfo).GetEndRow()
/// Creator：      yuliping
/// CreatDate：    2021-10-20
/// Description:   返回结束行数
ClassMethod GetEndRow() As %String
{
	s page=+$g(%request.Data("page",1))
	s rows=+$g(%request.Data("rows",1))
	q:page=0 9999
	q page*rows
}

/// d ##class(web.DHCCKBPHAAuxInfo).EmptyDataGrid()
/// Creator：      yuliping
/// CreatDate：    2021-10-20
/// Description:   返回空的数据
ClassMethod EmptyDataGrid() As %String
{
	w "{""total"":0,""rows"":[]}"
	q ""
}

/// Descript:获取病人医嘱信息
/// Creator：      yuliping
/// CreatDate：    2021-10-20
/// W ##class(web.DHCCKBPHAAuxInfo).GetAdmOrdList("1")
ClassMethod GetAdmOrdList(EpisodeID As %String, orderCode As %String)
{
	N (EpisodeID,orderCode,%request,%session)
	
	q:+EpisodeID=0 ##class(web.DHCCKBPHAAuxInfo).EmptyDataGrid()
	s StPage=##class(web.DHCCKBPHAAuxInfo).GetStartRow()
	s EndPage=##class(web.DHCCKBPHAAuxInfo).GetEndRow()

	S ord=$o(^OEORD(0,"Adm",EpisodeID,""))
	S pid=##class(web.DHCCKBCommonUtil).NewPid()
	
	S Num=0
    S chl=0 
    F  S chl=$o(^OEORD(ord,"I",chl)) Q:(chl="")||(chl=0)  D
	.S orditm=ord_"||"_chl
	.Q:'$d(^OEORD(ord,"I",chl,1))
	.S priDr=+$p(^OEORD(ord,"I",chl,1),"^",8) 
    .Q:priDr=0 
    .S priorty=$p(^OECPR(priDr),"^",1) //医嘱优先级代码              
    .;Q:priorty["OM" //自备药
    .S priorty=$p(^OECPR(priDr),"^",2) //医嘱优先级
    .S StatDr=$p(^OEORD(ord,"I",chl,1),"^",13)
    .S OeFlag=$p(^OEC("OSTAT",StatDr),"^",1) 
	.//Q:(OeFlag'="V")&(OeFlag'="E")
	.S FillerNo=$p(^OEORD(ord,"I",chl,9),"^",12) //滚医嘱来源信息 OEORI_FillerNo
    .Q:(FillerNo'="")&(FillerNo'=orditm_"!!"_orditm)&(OeFlag'="D")  //长嘱非首日和截止日期的记录过滤
	.S ArcItmId=$p(^OEORD(ord,"I",chl,1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
	.S ItemCatDR=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",10)
    .S ordertype=$P(^ARC("IC",ItemCatDR),"^",7)
    .Q:(ordertype'="R")
	.S inci=$o(^INCI(0,"ARCIM_DR",$p(ArcItmId,"||",1),"")) 
	.Q:inci=""  //医嘱名称
	.s CheckCHNFlag=##class(web.DHCSTINTERFACE).GetStruModeFlag(ArcItmId) ;判断某医嘱项的结构模式 Y-一对多，N-一对一 
	.;S incidesc=$p(^INCI(inci,1),"^",2) //药品名称
	.S incidesc=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",2)  ; 取医嘱项名称，因为医嘱项和库存项存在一对多关系
	.S dosage="",dosuomID="",doseuom="",freqdr="",freq="",instrudr="",instru="",durId=""
	.I $D(^OEORD(ord,"I",chl,2))  D
	..S dosage=$p(^OEORD(ord,"I",chl,2),"^",1) //剂量
	..S dosuomID=+$p(^OEORD(ord,"I",chl,2),"^",3)
	..S doseuom=$p($g(^CT("UOM",dosuomID)),"^",2) //剂量单位
	..S freqdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",4) //OEORI_PHFreq_DR
    ..S freq=$p($g(^PHCFR(freqdr)),"^",3) //频率
    ..S instrudr=+$p(^OEORD(ord,"I",chl,2),"^",7)
    ..S instru=$p($g(^PHCIN(instrudr)),"^",2) //用法
    ..s durId=+$p(^OEORD(ord,"I",chl,2),"^",6)
	..S duration=$p($g(^PHCDU(durId)),"^",3) //用药疗程
    
    .S dspid=$o(^DHCOEDISQTY(0,"OEORI",orditm,""))
    .;$p(^DHCOEDISQTY({DSP_RowId}),"^",1)//医嘱表id
    .S qty=$p(^DHCOEDISQTY(dspid),"^",2) //药品数量
    .S qtyuomdr=$p(^DHCOEDISQTY(dspid),"^",6) //药品数量单位指向
    .S qtyuom=$p(^CT("UOM",qtyuomdr),"^",2)
    .S qty=qty_qtyuom
	.;S qty=$p(^OEORD(ord,"I",chl,1),"^",18) //药品数量
    .S phcdf=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",12) Q:phcdf=""
    .S genenicdr=+$p($g(^PHCD(+phcdf,4)),"^",1)
    .S genenic=$p($g(^PHCGE("GE",genenicdr)),"^",2) //通用名
    .q:(orderCode'="")&&(genenic'[orderCode)
    .s formdr="",form=""
    .s:$d(^PHCD(+phcdf,"DF",$p(phcdf,"||",2),1)) formdr=$p(^PHCD(+phcdf,"DF",$p(phcdf,"||",2),1),"^",1)
    .s:formdr'="" form=$p(^PHCF(formdr),"^",2) //剂型
    .S manf=""
    .s manfdr=$p($g(^PHCD(+phcdf,2)),"^",4) //厂家
    .s:manfdr'="" manf=$p($g(^PHMNF(manfdr)),"^",2)
    .S:manf["-" manf=$p(manf,"-",2)
    .S apprdocu=""
    .S itminfo=$o(^DHCITMINFO(0,"INCI",inci,""))
    .I itminfo'="" S apprdocu=$p(^DHCITMINFO(itminfo),"^",10) //批准文号
	.S spec=""
	.S add=$o(^DHCITMINFO(0,"INCI",inci,"")) 
	.I add'=""  D
	..S spec=$p($G(^DHCITMINFO(add)),"^",27) //规格
	.S:CheckCHNFlag=1 spec=""
	.S statusID=""
    .S statusID=$o(^DHCOEDISQTY(0,"OEORI",orditm,statusID))
    .Q:statusID=""   
    .S status=$p(^DHCOEDISQTY(statusID),"^",7) //发药状态
    .Q:((priorty["S")||(priorty["NORM")||(priorty["OUT")||(priorty["临时医嘱"))&&(status'="C")  //如果状态为C为已发药
    .;S spec="["_$p(^INCI(inci,3),"^",9)_"]" 
    .S EndDate=$p(^OEORD(ord,"I",chl,3),"^",34)     //停止日期
    .
	.S:EndDate'="" EndDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(EndDate)
	.I FillerNo'="" D
	..S orditm=$p(FillerNo,"!!",1)
	.S StartDate=$p(^OEORD(ord,"I",$p(orditm,"||",2),1),"^",9)  //开始日期
	.S StartTime=$p(^OEORD(ord,"I",$p(orditm,"||",2),1),"^",10)  //开始时间

	.S:StartDate'="" StartDate=##class(web.DHCADVCOMMON).DateLogicalToHtml(StartDate)
	.s:StartTime'="" StartTime = $zt(StartTime)
	.S moeori=..GetMainOeori(orditm) //主医嘱
    .S index=StartDate_"||"_moeori_"||"_orditm
    .I $d(^TMP("DHCST","web.DHCADVCOMMON","GetPatOrdItmInfo",pid,index)) D
	..S $p(^TMP("DHCST","web.DHCADVCOMMON","GetPatOrdItmInfo",pid,index),"^",21)=EndDate
	..S $p(^TMP("DHCST","web.DHCADVCOMMON","GetPatOrdItmInfo",pid,index),"^",22)=OeFlag
	.E  D
	..S Num=Num+1
	..S ^TMP("DHCST","web.DHCADVCOMMON","GetPatOrdItmInfo",pid,index)=orditm_"^"_phcdf_"^"_incidesc_"^"_dosage_"^"_doseuom_"^"_dosuomID_"^"_freqdr_"^"_freq_"^"_instrudr_"^"_instru_"^"_durId_"^"_duration_"^"_genenicdr_"^"_genenic_"^"_formdr_"^"_form_"^"_manfdr_"^"_manf_"^"_apprdocu_"^"_spec_"^"_StartDate_"^"_EndDate_"^"_OeFlag_"^"_priorty_"^"_qty_"^"_inci_"^"_StartTime

	Q:Num=0 ##class(web.DHCADVJSONCOMMON).GetNoJson() //输出空的json串
	
	S Title="orditm^phcdf^incidesc^dosage^doseuom^dosuomID^freqdr^freq^instrudr^instru^durId^duration^genenicdr^genenic^formdr^form^manfdr^manf^apprdocu^spec^startdate^enddate^OeFlag^priorty^qty^inci^StartTime"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCADVCOMMON","GetPatOrdItmInfo",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCADVCOMMON","GetPatOrdItmInfo",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	
	K ^TMP("DHCST","web.DHCADVCOMMON","GetPatOrdItmInfo",pid)
	
	Q ""
}

/// Descript: 标本列表
/// Creator：      yuliping
/// CreatDate：    2021-10-20
/// w ##class(web.DHCCKBPHAAuxInfo).JsonQryOrdListNew("1","60","510^270^14/02/2018^16/03/2018^^0^^^4634^0^^^^Y")
ClassMethod JsonQryOrdListNew(Params As %String)
{
	
	n (Params,%request)
	s Start=##class(web.DHCCKBPHAAuxInfo).GetStartRow()
	s End=##class(web.DHCCKBPHAAuxInfo).GetEndRow()
	s AdmDr = $p(Params,"^",1)
	s PatientID=$p(Params,"^",2)
	s FromDate=$p(Params,"^",3)
	s:FromDate'="" FromDate= ##class(web.DHCEMCommonUtil).DateHtmlToLogical(FromDate)
	s:FromDate="" FromDate=+$h-10000
	s:FromDate'="" FromDate = $zd(FromDate,3)
	s ToDate=$p(Params,"^",4)
	s:ToDate'="" ToDate= ##class(web.DHCEMCommonUtil).DateHtmlToLogical(ToDate)
	s:ToDate="" ToDate=+$h
	s:ToDate'="" ToDate = $zd(ToDate,3)
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
	s:AdmDr="" AdmStr = ##class(web.DHCEMInComUseMethod).GetAdmStrByPatID(PatientID,AdmType,"","")
	s:AdmDr'="" AdmStr = AdmDr
	s AdmLen = $l(AdmStr,"^"),Num=0
	
	w:AdmStr="" ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(0)
	q:AdmStr="" ""
	
	f bs=1:1:AdmLen d
	.s EpisodeID = $p(AdmStr,"^",bs)
	.d SetPatLisData    //通过临时globle获取数据
	
	Set count = 0,del="""",tmp=""
	s retColName="PatName^PatSex^PatAge^PortUrl^VisitNumberReportDR^OEOrdItemID^OrdItemName^ReqDateTime^ResultStatus"
	s retColName=retColName_"^LabEpisode^LabTestSetRow^OrdSpecimen^SpecDateTime^RecDateTime"
	s retColName=retColName_"^AuthDateTime^PreReport^WarnComm^TSResultAnomaly^TSMemo^AdmNo"
	s retColName=retColName_"^AdmDate^AdmLoc^AdmType^ReadFlag^PrintFlag^StatusDesc^ReceiveNotes"
	s retColName=retColName_"^MajorConclusion^HasMC^HasMid^HasBic"

	s orderByPort=""
	f  s orderByPort = $o(^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",Pid,orderByPort),-1) q:orderByPort=""  d
	.s portDate="" 
	.f  s portDate = $o(^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",Pid,orderByPort,portDate),DateOrdVal) q:portDate=""  d
	..s portTime=""
	..f  s portTime = $o(^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",Pid,orderByPort,portDate,portTime),DateOrdVal) q:portTime=""  d
	...s labNo=""
	...f  s labNo = $o(^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",Pid,orderByPort,portDate,portTime,labNo)) q:labNo=""  d
	....s Num=""
	....f  s Num = $o(^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",Pid,orderByPort,portDate,portTime,labNo,Num)) q:Num=""  d
	.....s rsData  = ^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",Pid,orderByPort,portDate,portTime,labNo,Num)
	.....q:(portDate'=0)&(portDate<AdmStDate)
	.....q:(portDate'=0)&(portDate>AdmToDate)
	.....s VisitNumberReportDR = $p(rsData,"^",1)
	.....s OEORIDrs = $p(rsData,"^",2)
	.....s OEORIDr = $p(OEORIDrs,",",1)
	.....q:'$d(^OEORD(+OEORIDr))
	.....s PortUrl = ##class(web.DHCEMInterface).GetPacsPortUrlByOrd(OEORIDrs,"",1)
	.....q:(OEORIID'="")&&(OEORIDrs'[OEORIID)
	.....s PaAdm = $p(^OEORD(+OEORIDr),"^",1)
	.....s PatientID  = $p(^PAADM(PaAdm),"^",1)
	.....s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)   /// 病人姓名
	.....	
	.....s PatSex=""
	.....s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)     /// 性别
	.....i SexId'="" s PatSex=$p(^CT("SEX",SexId),"^",2)
	.....s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID)  /// 年龄
	.....s rsData = PatName_"^"_PatSex_"^"_PatAge_"^"_PortUrl_"^"_rsData
	.....s ARCICatInfo = ##class(web.DHCEMInComUseMethod).GetARCICatByOEORDItmDr(OEORIDr)
	.....q:(ARCICatDr'="")&&(+ARCICatInfo'[ARCICatDr)
	.....s count=count+1
	.....q:count<Start
	.....q:count>End
	.....w $case(count,Start:"",:",")
	.....w ##Class(web.DHCAPPJsonCommon).getJsonData(retColName,rsData)
	k ^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",Pid)
	w ##class(web.DHCAPPJsonCommon).getJsonEndConTotal(count)
	Do result.Close()
	Quit ""
SetPatLisData
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
		s hasPort=$p(ret,"^",5)   //是否出报告
		s labNo=$p(ret,"^",6)     //检验号
		s portDateTime =$p(ret,"^",11) //检验出报告时间
		s portDate = $p(portDateTime," ",1) //日期
		s:portDate'="" portDate = $zdh(portDate,3)
		s portTime = $p(portDateTime," ",2) //时间
		s:portTime'="" portTime = $zth(portTime)
		s orderByPort=""
		s orderByPort = "A"_$case(hasPort,3:"1",:"")_+readFlag
		s Num=Num+1
		s ^TMP("DHCEM","web.DHCAPPSeePatLis","JsonQryOrdList",Pid,orderByPort,+portDate,+portTime,labNo,Num)=ret   //按照是否阅读排序 1：阅读，其他：未阅读
	 }
}

/// Creator：      yuliping
/// CreatDate：    2021-10-20
/// Descript:检查结果查询与病理合并使用:检查项目内容获取
/// w ##class(web.DHCCKBPHAAuxInfo).GetLisInspectOrdNew(1,6,"86^86^2018-11-06^2018-12-06^4634^^^^")
ClassMethod GetLisInspectOrdNew(Params As %String)
{
	n (Params,%session,%request)
	k ^y
	s ^y = Params
	s Adm = $p(Params,"^",1)   
	s PatDr = $p(Params,"^",2)
	s:+Adm'=0 PatDr = $p(^PAADM(Adm),"^",1)
	s StartDate = $p(Params,"^",3)
	s EndDate = $p(Params,"^",4)
	s UserID = $p(Params,"^",5)
	s AdmType=$p(Params,"^",6)
	s OrdType=$p(Params,"^",7)
	s ReqNo=$p(Params,"^",8)
	s InOEORIId=$p(Params,"^",9)
	s:UserID="" UserID = $g(%session.Data("LOGON.USERID"))
	s StartDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)
	s EndDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	s:StartDate="" StartDate=+$h-1000    //为空的时候查询一年的信息
	s:EndDate="" EndDate=+$h
	s Count=0,Del=""""
	
	s Start=##class(web.DHCCKBPHAAuxInfo).GetStartRow()
	s End=##class(web.DHCCKBPHAAuxInfo).GetEndRow()
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
	...s PartList = ##Class(web.DHCEMInterface).GetExaReqPartNur(OEORIId)
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
	d ##class(web.DHCAPPSeePatPacs).GetLisOrdDetails(.LisOrdList,UserID)
    
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

ClassMethod GetPisOrdDetails(ByRef LisOrdList, UserID As %String) As %String
{
	n (LisOrdList,UserID)
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
		  	s apStatus=##Class(web.DHCEMInterface).GetExaReqItmStatus(oeori,PisNo)
		  	s:apStatus="RP" Report="报告"
			s apStatus =##class(web.DHCAPPSeePatPacs).GetResultStatus(apStatus)
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
		s PortNum = ##class(web.DHCPisApplicationSheet).getRptCount(LocID_"^"_oeori)
		s:+PortNum>1 BlMorePort="更多"
		s ImgFlag=""  									//是否有图像
		s Params = oeori_"^"_PisNo_"^"_UserID
	    s CMStatus=##class(web.DHCEMInterface).IsReadByParams(Params)  ;##class(RISService.TrakRISService).GetRPTCMStatus(OEORIId,StudyNo,myDocCode)
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

/// Desc:       生命体征信息
/// Creaotr：   ylp
/// Createdate: 2014-8-14
/// Input:      AInterFace 调用接口标识(默认HIS) 
/// w ##Class(web.DHCCKBPHAAuxInfo).GetVitalsigns("HIS",4,"WriteDate^temperature^pulse^breath^sysPressure^diaPressure^EpisodeDate^DeptDesc","","",1,10)
ClassMethod GetVitalsigns(AInterFace As %String, AEpisodeID As %String, AItem As %String, AStDate As %String, AEdDate As %String, AIdxStart As %Integer, AIdxLast As %Integer)
{
	n (AInterFace, AEpisodeID, AItem, AStDate, AEdDate, AIdxStart, AIdxLast)
	s json = ""
	q:((AEpisodeID = "")||(AItem = "")) "{""total"":0,""rows"":["_json_"]}"
	s AStDate = $Case(AStDate,"":"",:$zdh(AStDate,3))
	s AEdDate = $Case(AEdDate,"":"",:$zdh(AEdDate,3))
	s episodeDate = $ZD($p($g(^PAADM(AEpisodeID)),"^",6),3)
	
	if (AInterFace = "HIS")
	{
		
		s ret=##class(EMRservice.BL.BLVitalsigns).GetVitalsignsInfo(AEpisodeID,AItem,AStDate,AEdDate)
	}
	//elseif (AInterFace = ...){....}   add by Lina 2016-11-10 调用其它接口
	
	for
	{
		s objItm = ret.GetNext(.date)
		q:(date = "")
		s json = json_"{"
		
			
		s json = json_"""WriteDate"":"""_##Class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","DateTime",date)_""""
		for
		{
			s value = objItm.GetNext(.key)
			q:(key = "")
			s json = json_","
			s json = json_""""_key_""":"""_value_"""" 		
		}		
		s json = json_","
		s json = json_"""EpisodeDate"":"""_##Class(EMRservice.Tools.Tool).GetHISStandardDateTimeFormat("ChangeToFormat","Date",episodeDate)_""""
		s json = json_"}"
		s json =json_","
	}
	
	s json = $e(json,1,$l(json)-1)
	s json = "{""total"":"_ret.Count()_",""rows"":["_json_"]}"
	s json = $ZSTRIP(json,"*C")
	q json
}

/// Return： 	 过敏结果信息
/// Creator：      yuliping
/// CreatDate：    2021-10-20
/// Others:		 w ##class(web.DHCCKBPHAAuxInfo).QueryAllergyInfo(4)
ClassMethod QueryAllergyInfo(EpisodeID, code)
{
	n (EpisodeID,code,%request)
	
	s start=##class(web.DHCCKBPHAAuxInfo).GetStartRow()
	s end=##class(web.DHCCKBPHAAuxInfo).GetEndRow()
	
    S count=0,h=0
    Q:EpisodeID="" "{""rows"":[],""total"":"_count_"}"
    s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s TempColumn="RowID"_$c(1)_"Category"_$c(1)_"Allergen"_$c(1)_"ALGItem"_$c(1)_"NatureOfReaction"_$c(1)_"Severity"_$c(1)_"SeverityColour"_$c(1)_"OnsetDate"_$c(1)_"OnsetDateFreeText"_$c(1)_"CareProvider"_$c(1)_"InActive"_$c(1)_"OnsetDateText"_$c(1)_"RowHexColour"_$c(1)_"LastUpdateDate"_$c(1)_"LastUpdateTime"_$c(1)_"LastUpdateUser"_$c(1)_"LastUpdateHospital"_$c(1)_"Status"_$c(1)_"ExternalID"_$c(1)_"LastUpdateUserRole"_$c(1)_"LastUpdateUserId"_$c(1)_"Comments"_$c(1)_"ALGFreeTextAllergy"_$c(1)_"DrugSpecific"_$c(1)_"tag"_$c(1)_"ALGDSReportFlag"_$c(1)_"HiddenFields"
	w "{""rows"":["
	s objpat=##class(User.PAPatMas).%OpenId(PatientID)
	i $ISOBject(objpat) d
	.s h=objpat.ChildPAAllergy.Count()
	.F i=1:1:h d
	..s (RowID,Category,Allergen,NatureOfReaction,Severity,SeverityColour,OnsetDate,OnsetDateFreeText,CareProvider,InActive,OnsetDateText,RowHexColour,LastUpdateDate,LastUpdateTime,LastUpdateUser,LastUpdateHospital,Status,ExternalID,LastUpdateUserRole,LastUpdateUserId,Comments,ALGFreeTextAllergy,DrugSpecific,tag,ALGDSReportFlag,HiddenFields,ALGItem)=""
	..s objAllergy=objpat.ChildPAAllergy.GetAt(i)
	..s RowID=objAllergy.%Id()
	..;自定义过敏分类
	..if +objAllergy.ALGTypeDRGetObjectId()'="0" d
	...s Allergen=objAllergy.ALGTypeDR.ALGDesc
	...s tag=objAllergy.ALGTypeDR.ALGTypeDR.MRCATTagDescription
	..;通用项过敏源
	..if +objAllergy.ALGPHCGEDRGetObjectId()'="0" d
	...s ALGItem=objAllergy.ALGPHCGEDR.PHCGEName
	...s tag="G"
	...;s tag="Generic Drug"
	..;药学过敏源
	..if +objAllergy.ALGPHCDMDRGetObjectId()'="0" d
	...s ALGItem=objAllergy.ALGPHCDMDR.PHCDName
	...s tag="P"
	...;s tag="Pharmacy Item"
	..if +objAllergy.ALGIngredDRGetObjectId()'="0" d
	...s ALGItem=objAllergy.ALGIngredDR.INGRDesc
	...s tag="I"
	...;s tag="Ingredient"
	..//if objAllergy.ALGIngredDRGetObjectId()'="" d
	...//s ALGItem=objAllergy.ALGIngredDR.INGRDesc
	...//s tag="I"
	...;s tag="Ingredient"
	..;分类
	..s Category=objAllergy.ALGMRCAllTypeDR.MRCATDesc
 	..i (tag="P")!(tag="G")!(tag="I") s tag=##Class(websys.StandardTypeItem).GetDescription("AllergenTag",tag)
	..;拮抗反应
	..if objAllergy.ALGCategoryDRGetObjectId()'="" d
	...s NatureOfReaction=objAllergy.ALGCategoryDR.ALRGCATDesc
	..;医嘱项ID
	..i ALGItem="" d
	...if (objAllergy.ALGExternalID'="")&&(objAllergy.ALGExternalID["||") d
	....s ALGItemID=objAllergy.ALGExternalID
	....s ALGItem=$p($g(^ARCIM(+ALGItemID,$p(ALGItemID,"||",2),1)),"^",2)
	...e  i objAllergy.ALGExternalID'="" d
	....s ALGItem=objAllergy.ALGExternalID
	....s ALGItemID=objAllergy.ALGExternalID
	..;严重
	..if objAllergy.ALGSeverityDRGetObjectId()'="" d
	...s Severity=ALGSeverityDR.ALGSeverityDR.ALRGSEVDesc
	..s OnsetDate=objAllergy.ALGOnsetDate
	..s OnsetDateFreeText=objAllergy.ALGOnsetDateFreeText
	..;发作日期描述
	..s:OnsetDate'="" OnsetDateText=##class(web.DHCEMCommonUtil).DateLogicalToHtml(OnsetDate) //$zd(OnsetDate,3) ;=##Class(websys.Conversions).DateLogicalToHtml(OnsetDate)_OnsetDateFreeText
	..;医护人员 组件里没有使用
	..s CareProvider=objAllergy.ALGCTPCPDR
	..;未激活标志
	..s InActive=objAllergy.ALGInActive
	..;使用不明
	..s RowHexColour=""
	..s SeverityColour=""
	..s HiddenFields=""
	..s LastUpdateDate=objAllergy.ALGLastUpdateDate
	..s:LastUpdateDate'="" LastUpdateDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(LastUpdateDate) //$zd(LastUpdateDate,3)
	..s LastUpdateTime=objAllergy.ALGLastUpdateTime
	..if objAllergy.ALGUpdateUserDRGetObjectId()'="" d
	...s LastUpdateUserId=objAllergy.ALGUpdateUserDR.SSUSRInitials
	...s LastUpdateUser=objAllergy.ALGUpdateUserDR.SSUSRName
	...s LastUpdateUserRole=objAllergy.ALGUpdateUserDR.SSUSRStaffTypeDR.STAFFDesc
	..if objAllergy.ALGLastUpdateHospitalDRGetObjectId()'="" d
	...s LastUpdateHospital=objAllergy.ALGLastUpdateHospitalDR.HOSPDesc
	..;状态
	..s Status=objAllergy.ALGStatus
	..s ExternalID=objAllergy.ALGExternalID
	..;注释
	..s Comments=##Class(websys.Conversions).LongTextLogicalToHtml(objAllergy.ALGComments,$C(13,10))
	..s ALGFreeTextAllergy=objAllergy.ALGFreeTextAllergy
	..s DrugSpecific=objAllergy.ALGDrugSpecific
	..s ALGDSReportFlag=objAllergy.ALGDSReportFlag
	..q:(code'="")&&(Allergen'[code)
	..s TempStr=RowID_$c(1)_Category_$c(1)_Allergen_$c(1)_ALGItem_$c(1)_NatureOfReaction_$c(1)_Severity_$c(1)_SeverityColour_$c(1)_OnsetDate_$c(1)_OnsetDateFreeText
	..s TempStr=TempStr_$c(1)_CareProvider_$c(1)_InActive_$c(1)_OnsetDateText_$c(1)_RowHexColour_$c(1)_LastUpdateDate_$c(1)_LastUpdateTime_$c(1)_LastUpdateUser
	..s TempStr=TempStr_$c(1)_LastUpdateHospital_$c(1)_Status_$c(1)_ExternalID_$c(1)_LastUpdateUserRole_$c(1)_LastUpdateUserId_$c(1)_Comments_$c(1)_ALGFreeTextAllergy
	..s TempStr=TempStr_$c(1)_DrugSpecific_$c(1)_tag_$c(1)_ALGDSReportFlag_$c(1)_HiddenFields
	..
	..;set ^CacheTemp(repid,ind)=data
	..S count=count+1
	..q:count<start
	..q:count>end
   	..W $case(count,start:"",:",") 
	..W ##class(web.DHCAPPJsonCommon).getJsonData(TempColumn,TempStr,$c(1))
	W "],""total"":"_count_"}"

	Q ""
}

}
