/// Description:住院草药处方审方查询相关
/// Creator:    hulihua
/// CreateDate: 2018-12-19
/// Table:      OE_OrdItem、DHC_PHAORDMONITOR、DHC_PHAORDMONITORLIST
Class web.DHCINPHA.HMPrescPhaAudit.PrescPhaAuditQuery Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", ProcedureBlock ]
{

/// Description:住院草药处方审方列表查询
/// Creator:	hulihua
/// CreateDate:	2018-12-19
/// Table:      OE_OrdItem
/// Input:		每页显示行数、每页开始行数、params(开始日期^截止日期^药房ID^病区ID^病人就诊ID)
/// Output:
/// Return：	床号、登记号、姓名、处方号、病区科室ID、病区描述、提交护士、提交时间、审方结果、申诉理由、
/// 			拒绝理由、付数、处方剂型、是否加急、就诊ID、病人ID、处方主医嘱ID    
/// Others:
/// Debug:		w ##class(web.DHCINPHA.HMPrescPhaAudit.PrescPhaAuditQuery).jsGetInAuditPrescList("1","50","04/01/2019^06/01/2019^310^^Y")
ClassMethod jsGetInAuditPrescList(page, rows, params) As %String
{
	//s ^hlh($h)=$lb(page, rows, params)
	Q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
 	S EnPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1 //开始行
	s DataDelim=##class(web.DHCINPHA.MTCommon.PublicCallMethod).RowDataDelim()
	s StartDate=$p(params,DataDelim,1)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=$p(params,DataDelim,2)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s PhaLocId=$p(params,DataDelim,3)
	s PutWardLocId=$p(params,DataDelim,4)
	s ChkAudit=$p(params,DataDelim,5)
	s AdmDr=$p(params,DataDelim,6)
	s phaLocation=$o(^DHCPL(0,"Loc",PhaLocId,""))
    s dealOrdFlag=$p($g(^DHCPL(+phaLocation)),"^",37)
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid($this)
	D ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"jsGetInAuditPrescList",pid)
	K CheckPrescNoArr
	S h=0
	//获取未审处方
	I ChkAudit'="Y" D 
	.F Date=StartDate:1:EndDate D
	..I AdmDr="" D
	...S ord=""
	...F  S ord=$o(^OEORDi(0,"LocStDtArr",PhaLocId,0,Date,ord)) Q:ord=""  D
	....S adm=$p(^OEORD(ord),"^",1)
	....S admtype=$p($g(^PAADM(adm)),"^",2)
	....Q:admtype'="I"		//过滤非住院病人
    ....S chl=""  
    ....F  S chl=$o(^OEORDi(0,"LocStDtArr",PhaLocId,0,Date,ord,chl)) Q:chl=""  D
    .....Q:'$D(^OEORD(ord,"I",chl,1))
    .....D CheckUnAuditData
    ....
    ...
    ..E  D
    ...S ord=$o(^OEORD(0,"Adm",AdmDr,""))
	...Q:ord=""
	...S admtype=$p($g(^PAADM(AdmDr)),"^",2)
	...Q:admtype'="I"		//过滤非住院病人
	...S chl=""  
    ...F  S chl=$o(^OEORDi(0,"LocStDtArr",PhaLocId,0,Date,ord,chl)) Q:chl=""  D
    ....Q:'$D(^OEORD(ord,"I",chl,1))
    ....D CheckUnAuditData
    ...
    ..
    .
    //获取已审处方
    E  D
    .I AdmDr="" D
    ..F Date=EndDate:-1:StartDate D
    ...s PhaomId=""
	...f  s PhaomId=$o(^DHCPHORDM(0,"DateLoc",Date,PhaLocId,PhaomId),-1) q:PhaomId=""  d
	....s AppType=$p(^DHCPHORDM(PhaomId),"^",9)
	....q:AppType'="IA"
	....q:$p(^DHCPHORDM(PhaomId),"^",12)'=""
	....D CheckAuditData
	...
	..
	.E  D
	..s PhaomId=""
	..f  s PhaomId=$o(^DHCPHORDM(0,"Adm",AdmDr,PhaomId),-1) q:PhaomId=""  d
	...s AppType=$p(^DHCPHORDM(PhaomId),"^",9)
	...q:AppType'="IA"
	...q:$p(^DHCPHORDM(PhaomId),"^",12)'=""
	...s PhaoLocId=$p(^DHCPHORDM(PhaomId),"^",5)
	...q:PhaoLocId'=PhaLocId
	...s PhaomDate=$p(^DHCPHORDM(PhaomId),"^",3)
	...q:(PhaomDate<StartDate)||(PhaomDate>EndDate)
	...D CheckAuditData
	..
	.
    // 输出Json数据
	S countrecords=h
    Q:countrecords="0" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
    I EnPage>countrecords Set EnPage=countrecords
	S ColNameStr1="TBedNo^TPatNo^TPatName^TPrescNo^TWardLocId"
	S ColNameStr2="TWardLoc^TSeekUserName^TSeekDate^TAuditResult^TDocNote"
	S ColNameStr3="TRefResult^TFactor^TPrescForm^TPrescEmergen^TAdmDr"
	S ColNameStr4="TPapmiDr^TMoeori^TPhaomDate^TPhaomName^TDispState"
	S ColNameStr=ColNameStr1_"^"_ColNameStr2_"^"_ColNameStr3_"^"_ColNameStr4
	S Index="",Count=0
	F  S Index=$O(^TMP("DHCINPHA",$this,"jsGetInAuditPrescList",pid,"PRESCNOLIST",Index))  Q:Index=""  D 
 	.S H=""
 	.F  S H=$O(^TMP("DHCINPHA",$this,"jsGetInAuditPrescList",pid,"PRESCNOLIST",Index,H))  Q:H=""  D
	..S OutPutData=^TMP("DHCINPHA",$this,"jsGetInAuditPrescList",pid,"PRESCNOLIST",Index,H)	
	..S Count=Count+1
	..Q:(Count<StPage)||(Count>EnPage)
    ..I Count=StPage D
	...W ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartStringJqGrid(countrecords,rows)
	...W ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(ColNameStr,OutPutData)
	..E  D
	...W ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(ColNameStr,OutPutData)
	..I Count=EnPage Write ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign()
	.
    D ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"jsGetInAuditPrescList",pid)
    Q ""
CheckUnAuditData
	//检查未审处方
    s oeori=ord_"||"_chl
	s prescNo=$p(^OEORD(ord,"I",chl,1),"^",14) 			;处方号
	q:prescNo=""
	Q:$d(CheckPrescNoArr("PrescNo",prescNo))
	s queid=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).PrescCYQueId(prescNo)
 	q:queid=""						;非草药处方
 	s preOrdStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPreOrdInfo(prescNo)
 	s seekType=$p(preOrdStr,"^",5)
 	q:(dealOrdFlag="Y")&&(seekType'="A")				;护士未提交或者拒绝的过滤
	s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	q:dspId=""
	s admDr=$p(^DHCOEDISQTY(dspId),"^",26)
	q:admDr=""
	S wardLocId=$p(^DHCOEDISQTY(dspId),"^",22)
	q:wardLocId=""
	q:(PutWardLocId'="")&&(PutWardLocId'=wardLocId) 
	s priorDr=+$p(^OEORD(ord,"I",chl,1),"^",8) 
    q:priorDr=0 
    s priority=$p(^OECPR(priorDr),"^",1) 				;医嘱优先级代码              
    q:priority["OM" 									;自备药以及嘱托
    q:##class(web.DHCSTCNTSIPMONITOR).CheckOEOREStatByOeori(oeori)'=1
 	s AuditStatus=##class(web.DHCSTCNTSCOMMON).CheckPrescNoStatus(prescNo,"IA")
 	q:(AuditStatus'="0")&&(AuditStatus'="2")			;申诉或未审的
 	s arcimId=$p(^OEORD(ord,"I",chl,1),"^",2)                                    ;医嘱 ARC_ItmMast ARCIM_RowId
 	s arcCatId=$p(^ARCIM($p(arcimId,"||",1),$p(arcimId,"||",2),1),"^",10)        ;医嘱子类RowId
 	s amtFlag=##class(web.DHCSTPCHCOLLS2).IfCollectDrugAllowed(admDr,arcCatId_"^"_priority_"^"_oeori)
 	q:amtFlag=0
 	D GetOutPutData
    Q ""
    
CheckAuditData
	//检查已申处方
	s PhaomCh=$o(^DHCPHORDM(PhaomId,"I",""))
	S prescNo=$p(^DHCPHORDM(PhaomId,"I",PhaomCh),"^",4)
	Q:prescNo=""
	Q:$d(CheckPrescNoArr("PrescNo",prescNo))
	s queid=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).PrescCYQueId(prescNo)
 	q:queid=""							;非草药处方
	S admDr=$p(^DHCPHORDM(PhaomId,"I",PhaomCh),"^",5)
	Q:admDr=""
	S oeori=$p(^DHCPHORDM(PhaomId,"I",PhaomCh),"^",2)
	s dspId=$o(^DHCOEDISQTY(0,"OEORI",oeori,""))
	q:dspId=""
	S wardLocId=$p(^DHCOEDISQTY(dspId),"^",22)
	q:wardLocId=""
	q:(PutWardLocId'="")&&(PutWardLocId'=wardLocId) 
	s phaomDate=$p(^DHCPHORDM(PhaomId),"^",3)
	s phaomDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(phaomDate)
	s phaomTime=$p(^DHCPHORDM(PhaomId),"^",4)
	s phaomTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(phaomTime)
	s:phaomDate'="" phaomDate=phaomDate_" "_phaomTime
	s phaomUserId=$p(^DHCPHORDM(PhaomId),"^",1)
	s phaomName=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(phaomUserId),"^",2) 
	s preOrdStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPreOrdInfo(prescNo)
	D GetOutPutData
    Q ""
    
GetOutPutData
	//输出数据列
	s phacId = +$o(^DHCPHACi("PRESCNO",prescNo,0))
	/* MaYuqiang 20211018 允许查询已发药处方 */
	//q:phacId'=0		// 过滤已发药数据
 	s AuditResult=##class(web.DHCSTCNTSCOMMON).GetCurPhoResultByPresc(prescNo,"IA")
 	s lastPhaomId=""
 	s tmpPhaOrdId=""
	f  s tmpPhaOrdId=$o(^DHCPHORDM(0,"PrescNo",prescNo,tmpPhaOrdId),-1) q:(tmpPhaOrdId="")||(lastPhaomId'="")  d
    .s cancelUser=$p(^DHCPHORDM(tmpPhaOrdId),"^",12)
    .q:(cancelUser'="")
	.s lastPhaomId=tmpPhaOrdId
 	s RefResult=$s(lastPhaomId'="":##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).GetAuditRefReason(lastPhaomId),1:"")
 	s DocNote=$s(lastPhaomId'="":$p($g(^DHCPHORDM(lastPhaomId)),"^",7),1:"")
 	s seekUserName=$p(preOrdStr,"^",3)
 	s seekDate=$p(preOrdStr,"^",4)
 	s patInfo=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetPatInfo(admDr)
 	s patNo=$p(patInfo,"^",1) 
 	S patName=$P(patInfo,"^",3)
	S bedNo=$P(patInfo,"^",13)
	s prescStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(prescNo)
	s facTor=$p(prescStr,"^",2) 
 	s prescForm=$p(prescStr,"^",8)
 	s prescEmergen=$p(prescStr,"^",18) 
 	S papmiDr=$p(^PAADM(admDr),"^",1)
 	S mOeori=##class(web.DHCSTCNTSCOMMON).GetMainOeori(oeori)
 	S wardLocDesc=$P(^CTLOC(wardLocId),"^",2)
 	i phacId'=0 d
 	.s dispState = "已发药"
 	e  d
 	.s dispState = "未发药"
 	S CheckPrescNoArr("PrescNo",prescNo)=""
 	s Data1=bedNo_"^"_patNo_"^"_patName_"^"_prescNo_"^"_wardLocId
 	S Data2=wardLocDesc_"^"_seekUserName_"^"_seekDate_"^"_AuditResult_"^"_DocNote
 	s Data3=RefResult_"^"_$g(facTor)_"^"_$g(prescForm)_"^"_$g(prescEmergen)_"^"_admDr
 	S Data4=papmiDr_"^"_mOeori_"^"_$g(phaomDate)_"^"_$g(phaomName)_"^"_$g(dispState)
 	s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4
 	S h=h+1
 	S Index=wardLocId
	S ^TMP("DHCINPHA",$this,"jsGetInAuditPrescList",pid,"PRESCNOLIST",Index,h)=Data
    Q ""
}

/// Description:获取已审方病区的处方列表
/// Creator:	hulihua
/// CreateDate:	2017-12-11
/// Table:      DHC_PHAORDMONITOR--医嘱审核主表、DHC_PHAORDMONITORLIST--审核子表
/// Input:
/// Output:
/// Return：    病区、床号、登记号、病人姓名、处方号
/// Others:
/// w ##class(web.DHCINPHA.HMPrescPhaAudit.PrescPhaAuditQuery).jsQueryAuditPrescList("1","50","2017-12-07^^2017-12-11^^96^^^^")
ClassMethod jsQueryAuditPrescList(page, rows, params)
{
	//s ^hlh($h)=$lb(page, rows, params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson() 
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s StartDate=$p(params,"^",1)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s StartTime=$p(params,"^",2)
	s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	s EndDate=$p(params,"^",3)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s EndTime=$p(params,"^",4)
	s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
	s PhaLoc=$p(params,"^",5)
	s AuditRefFlag=$p(params,"^",6)
	s WardLocId=$p(params,"^",7)
	s Adm=$p(params,"^",8)
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid($this)
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"jsQueryAuditPrescList",pid)
	s cnt=0
	f Date=StartDate:1:EndDate  d
	.s PhaomId=""
	.f  s PhaomId=$o(^DHCPHORDM(0,"DateLoc",Date,PhaLoc,PhaomId)) q:PhaomId=""  d
	..s AppType=$p(^DHCPHORDM(PhaomId),"^",9)
	..q:AppType'="IA"
	..s Result=$p(^DHCPHORDM(PhaomId),"^",2)
	..q:(AuditRefFlag="Y")&&(Result'="N")
	..S AuitTime=$p(^DHCPHORDM(PhaomId),"^",4)
	..i Date=StartDate q:(AuitTime<StartTime)&&(StartTime'="")
    ..i Date=EndDate q:(AuitTime>EndTime)&&(EndTime'="")
	..s AgreeRetFlag=$p(^DHCPHORDM(PhaomId),"^",20)  //add by psc 2018/01/09 增加可退信息
	..s AgreeUserdr=$p(^DHCPHORDM(PhaomId),"^",16)
	..s AgreeUser=$s(AgreeUserdr'="":$p(^SSU("SSUSR",AgreeUserdr),"^",2),1:"")
	..s AgreeDate=""
	..i AgreeRetFlag="Y" d
	...s AgreeDate=$p(^DHCPHORDM(PhaomId),"^",17)
	...s AgreeDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AgreeDate)
	...s AgreeTime=$p(^DHCPHORDM(PhaomId),"^",18)
	...s AgreeTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(AgreeTime)
	...s:AgreeDate'="" AgreeDate=AgreeDate_" "_AgreeTime
	..s AgreeRemark=$p(^DHCPHORDM(PhaomId),"^",19)
	..s PhaomCh=$o(^DHCPHORDM(PhaomId,"I",""))
	..s PrescNo=$p(^DHCPHORDM(PhaomId,"I",PhaomCh),"^",4)
	..q:PrescNo=""
	..s PatAdm=$p(^DHCPHORDM(PhaomId,"I",PhaomCh),"^",5)
	..s preOrdStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPreOrdInfo(prescNo)
	..s SeekUserName=$p(preOrdStr,"^",3)
 	..s SeekDate=$p(preOrdStr,"^",4)
	..s PrescStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(PrescNo)
 	..s Factor=$p(PrescStr,"^",2)
 	..s PatInfo=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetPatInfo(PatAdm)
	..s PatNo=$p(PatInfo,"^",1)
	..s PatName=$p(PatInfo,"^",3)
	..s BedNo=$p(PatInfo,"^",13)
	..s PrintFlag="",Phac="",DataSource=""
	..s WardId=$p(^PAADM(PatAdm),"^",70)
	..s PrescCount=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPrescNoUnCount(PrescNo)
	..s WardLocDr=$p(^PAWARD(WardId),"^",5)
	..q:(WardLocId'="")&&(WardLocId'=WardLocDr)
	..s PhaomInfo=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPhaomInfo(PrescNo,"N")
	..s monitorName=$p(PhaomInfo,"^",3)
 	..s monitorDateTime=$p(PhaomInfo,"^",1)
	..s AuitResult=$s(Result="Y":"通过",Result="N":"拒绝",Result="A":"申诉",1:"撤销")
	..s AgreeFlag=$p(^DHCPHORDM(PhaomId),"^",8)
	..s:(Result="N")&&(AgreeFlag="Y") AuitResult="医生接受"
	..s WardLocDesc=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetLocInfoById(WardLocDr),"^",2)
	..s ResultStr=##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).GetAuditRefReason(PhaomId)
	..s PrescForm=$p(PrescStr,"^",8)
	..i PrescForm'["颗粒剂"  d
	...s OptorType=$s(DataSource=1:"人工",PrintFlag>0:"调剂单",1:"手机")
	..e  d
	...s OptorType="人工"
	..;
	..s Data1=BedNo_"^"_PatNo_"^"_PatName_"^"_PrescNo_"^"_WardLocDr
	..s Data2=WardLocDesc_"^"_AuitResult_"^"_ResultStr_"^"_monitorName_"^"_monitorDateTime
	..s Data3=SeekUserName_"^"_SeekDate_"^"_AgreeRetFlag_"^"_AgreeUser_"^"_$g(AgreeDate)
	..s Data4=AgreeRemark_"^"_Factor_"^"_PrescCount_"^"_OptorType_"^"_Phac
	..s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4
	..s cnt=cnt+1
	..s Index=BedNo_","_PrescNo
	..s ^TMP("DHCINPHA",$this,"jsQueryAuditPrescList",pid,"PrescNo",Index)=Data
	.
	i cnt=0 d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"jsQueryAuditPrescList",pid)
	q:cnt=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(0)
	s colNameStr1="TBedNo^TPatNo^TPatName^TPrescNo^TWardLocId"
	s colNameStr2="TWardLoc^TAuitResult^TResultStr^TmonitorName^TmonitorDateTime"
	s colNameStr3="TSeekUserName^TSeekDate^TAgreeRetFlag^TAgreeUser^TAgreeDate"
	s colNameStr4="TAgreeRemark^TFactor^TPrescCount^TOptorType^TPhac"
	s colNameStr=colNameStr1_"^"_colNameStr2_"^"_colNameStr3_"^"_colNameStr4
	s count=0
	s Index=""
	f  s Index=$o(^TMP("DHCINPHA",$this,"jsQueryAuditPrescList",pid,"PrescNo",Index)) q:Index=""  d
	.s outputdata=^TMP("DHCINPHA",$this,"jsQueryAuditPrescList",pid,"PrescNo",Index)
	.s count=count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	.. w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonRowSign()
	.. W ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(colNameStr,outputdata)
	.e  d
	.. W ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(colNameStr,outputdata)
	i count>0 d
	.w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndStringJqGrid(count,rows)
	e  d
	.w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"jsQueryAuditPrescList",pid)
	q ""
}

/// Description:通过就诊ID获取某登记号病人的所有已审处方
/// Creator:	hulihua
/// CreateDate:	2017-12-21
/// Table:      DHC_PHAORDMONITOR--医嘱审核主表、DHC_PHAORDMONITORLIST--审核子表
/// Input:
/// Output:
/// Return：    床号、登记号、病人姓名、处方号
/// Others:
/// w ##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).GetAllPrescNoByAdmList("1","500","28/02/2018^00:00^28/03/2018^23:59^96^N^30598")
ClassMethod jsQueryAuditPrescByAdm(page, rows, params)
{
	//s ^hlh($h)=$lb(page, rows, params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson() 
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s StartDate=$p(params,"^",1)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s StartTime=$p(params,"^",2)
	s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	s EndDate=$p(params,"^",3)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s EndTime=$p(params,"^",4)
	s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
	s PhaLoc=$p(params,"^",5)
	s AuditRefFlag=$p(params,"^",6)
	s AdmDr=$p(params,"^",7)
	q:AdmDr="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson() 
	s colNameStr1="TBedNo^TPatNo^TPatName^TPrescNo^TMonitorName"
	s colNameStr2="TMonitorDateTime^TAuitResult^TSeekUserName^TSeekDate^TReasonStr"
	s colNameStr3="TAgreeRetFlag^TAgreeDate^TAgreeUser^TAgreeRemark^TFactor"
	s colNameStr4="TPrescCount^TOptorType^TPhac"
	s colNameStr=colNameStr1_"^"_colNameStr2_"^"_colNameStr3_"^"_colNameStr4
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid($this)
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"GetAllPrescNoByAdmList",pid)
	s count=0
	s PhaomId=""
	f  s PhaomId=$o(^DHCPHORDM(0,"Adm",AdmDr,PhaomId),-1) q:PhaomId=""  d
	.s AppType=$p(^DHCPHORDM(PhaomId),"^",9)
	.q:AppType'="IA"
	.s PhaoLocId=$p(^DHCPHORDM(PhaomId),"^",5)
	.q:PhaoLocId'=PhaLoc
	.s PhaomDate=$p(^DHCPHORDM(PhaomId),"^",3)
	.q:(PhaomDate<StartDate)||(PhaomDate>EndDate)
	.s AgreeRetFlag=$p(^DHCPHORDM(PhaomId),"^",20)  //add by psc 2018/01/09 增加可退信息
	.s AgreeUserdr=$p(^DHCPHORDM(PhaomId),"^",16)
	.s AgreeUser=$s(AgreeUserdr'="":$p(^SSU("SSUSR",AgreeUserdr),"^",2),1:"")
	.s AgreeDate=""
	.i AgreeRetFlag="Y" d
	..s AgreeDate=$p(^DHCPHORDM(PhaomId),"^",17)
	..s AgreeDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AgreeDate)
	..s AgreeTime=$p(^DHCPHORDM(PhaomId),"^",18)
	..s AgreeTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(AgreeTime)
	..s:AgreeDate'="" AgreeDate=AgreeDate_" "_AgreeTime
	.s AgreeRemark=$p(^DHCPHORDM(PhaomId),"^",19)
	.s PhaomCh=$o(^DHCPHORDM(PhaomId,"I",""))
	.s PrescNo=$p(^DHCPHORDM(PhaomId,"I",PhaomCh),"^",4)
	.q:PrescNo=""
	.q:$d(^TMP("DHCINPHA",$this,"GetAllPrescNoByAdmList",pid,"PrescNo",PrescNo))
	.s ^TMP("DHCINPHA",$this,"GetAllPrescNoByAdmList",pid,"PrescNo",PrescNo)=""
	.s preOrdStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPreOrdInfo(prescNo)
	.s SeekUserName=$p(preOrdStr,"^",3)
 	.s SeekDate=$p(preOrdStr,"^",4)
	.s PrescStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(PrescNo)
 	.s Factor=$p(PrescStr,"^",2)
 	.s ReasonStr=##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).GetAuditRefReason(PhaomId)
	.s PatInfo=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetPatInfo(AdmDr)
	.s PatNo=$p(PatInfo,"^",1)
	.s PatName=$p(PatInfo,"^",3)
	.s Bed=$p(PatInfo,"^",13)
	.s PhaomInfo=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPhaomInfo(PrescNo,"N")
	.s monitorName=$p(PhaomInfo,"^",3)
 	.s monitorDateTime=$p(PhaomInfo,"^",1)
	.s Result=$p(^DHCPHORDM(PhaomId),"^",2)
	.q:(AuditRefFlag="Y")&&(Result'="N")
	.s AuitResult=$s(Result="Y":"通过",Result="N":"拒绝",Result="A":"申诉",1:"撤销")
	.s AgreeFlag=$p(^DHCPHORDM(PhaomId),"^",8)
	.s:(Result="N")&&(AgreeFlag="Y") AuitResult="医生接受"
	.s PrescCount=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPrescNoCount(PrescNo)
	.s:PrescCount=0 PrescCount=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPrescNoUnCount(PrescNo)
	.s Phac=$o(^DHCPHAC(0,"Prescno",PrescNo,""),-1)
	.s DataSource=$s(Phac'="":$p($G(^DHCPHAC(Phac)),"^",35),1:"")
	.s PrintFlag=$s(Phac'="":+$p(^DHCPHAC(Phac),"^",16),1:"")
	.s PrescForm=$p(PrescStr,"^",8)
	.i PrescForm'["颗粒剂"  d
	..s OptorType=$s(DataSource=1:"人工",PrintFlag>0:"调剂单",1:"手机")
	.e  d
	..s OptorType="人工"
	.s outputdata1=$g(Bed)_"^"_$g(PatNo)_"^"_$g(PatName)_"^"_$g(PrescNo)_"^"_$g(monitorName)
	.s outputdata2=$g(monitorDateTime)_"^"_$g(AuitResult)_"^"_$g(SeekUserName)_"^"_$g(SeekDate)_"^"_$g(ReasonStr)
	.s outputdata3=$g(AgreeRetFlag)_"^"_$g(AgreeDate)_"^"_$g(AgreeUser)_"^"_$g(AgreeRemark)_"^"_$g(Factor)
	.s outputdata4=$g(PrescCount)_"^"_$g(OptorType)_"^"_$g(Phac)
	.s outputdata=outputdata1_"^"_outputdata2_"^"_outputdata3_"^"_outputdata4
	.s count=count+1
	.I count=1 d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetJsonStartString(999)
	..W ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(colNameStr,outputdata)
	.e  d
	..W ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(colNameStr,outputdata)
	.
	q:count=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(0) 
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign()
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"GetAllPrescNoByAdmList",pid)
	q ""
}

}
