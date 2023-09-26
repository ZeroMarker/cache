/// Description:住院草药房审方发药查询相关
/// Creator:    hulihua
/// CreateDate: 2017-07-05
/// Table:      DHC_OEDispensing-新医嘱打包表
Class web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:获取待发药的处方列表
/// Creator:	hulihua
/// CreateDate:	2017-07-10
/// Table:      DHC_OEDISPENDSING 
/// Input:
/// Output:		床号、登记号、病人姓名、处方号、病区ID、病区描述、提交护士、提交日期、审方结果、付数、处方剂型、是否加急
/// Return：    
/// Others:
/// Debug：		w ##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).jsQueryDispPrescList("1","50","2017-01-01^^2017-07-11^^88^^70^^")
ClassMethod jsQueryDispPrescList(page, rows, params)
{
	n (page, rows, params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	S EnPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1 //开始行
	s StartDate=$p(params,"^",1)
	s StartDate=##class(PHA.FACE.IN.Com).DateHtmlToLogical(StartDate)
	s StartTime=$p(params,"^",2)
	s StartTime=##class(PHA.FACE.IN.Com).TimeHtmlToLogical(StartTime)
	s EndDate=$p(params,"^",3)
	s EndDate=##class(PHA.FACE.IN.Com).DateHtmlToLogical(EndDate)
	s EndTime=$p(params,"^",4)
	s EndTime=##class(PHA.FACE.IN.Com).TimeHtmlToLogical(EndTime)
	s PhaLoc=$p(params,"^",5)
	s WardLoc=$p(params,"^",6)
	s Adm=$p(params,"^",7)
	i Adm'=""  d
	.s ret=..GetDispPrescListByAdm(PhaLoc,StartDate,EndDate,StartTime,EndTime,WardLoc,Adm)
	e  d
	.s ret=..GetDispPrescListByWard(PhaLoc,StartDate,EndDate,StartTime,EndTime,WardLoc)
	s cnt=$p(ret,"^",1)
	s pid=$p(ret,"^",2)
	q:cnt=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(0)
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"jsQueryDispPrescList",pid)
	i Adm'=""  d
	.s prescno=""
	.f  s prescno=$o(^TMP("DHCINPHA",$this,"GetDispPrescListByAdm",pid,"PrescNo",prescno)) q:prescno=""  d
	..M ^TMP("DHCINPHA",$this,"jsQueryDispPrescList",pid,"PrescNo",prescno)=^TMP("DHCINPHA",$this,"GetDispPrescListByAdm",pid,"PrescNo",prescno)
	.d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"GetDispPrescListByAdm",pid)
	e  d
	.s prescno=""
	.f  s prescno=$o(^TMP("DHCINPHA",$this,"GetDispPrescListByWard",pid,"PrescNo",prescno)) q:prescno=""  d
	..M ^TMP("DHCINPHA",$this,"jsQueryDispPrescList",pid,"PrescNo",prescno)=^TMP("DHCINPHA",$this,"GetDispPrescListByWard",pid,"PrescNo",prescno)
	.d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"GetDispPrescListByWard",pid)
	
	s prescno="",h=0
	f  s prescno=$o(^TMP("DHCINPHA",$this,"jsQueryDispPrescList",pid,"PrescNo",prescno)) q:prescno=""  d
	.s str=^TMP("DHCINPHA",$this,"jsQueryDispPrescList",pid,"PrescNo",prescno)
	.s Bed=$p(str,"^",1)
	.s PrescEmergen=$p(str,"^",14)
	.s EmergenFlag=$s(PrescEmergen="Y":0,1:1)
	.s h=h+1
	.s index=EmergenFlag_","_Bed_"^"_prescno
	.s ^TMP("DHCINPHA",$this,"jsQueryDispPrescList",pid,"Index",index)=str
	Q:'$d(^TMP("DHCINPHA",$this,"jsQueryDispPrescList",pid,"Index")) ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(0)
	// 输出Json数据
	S countrecords=h
    Q:countrecords=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(0)
    I EnPage>countrecords S EnPage=countrecords
	s colNameStr="TBedNo^TPatNo^TPatName^TPrescNo^TWardLocId^TWardLoc^TSeekUserName^TSeekDate^TAuditResult^TFactor^TPrescForm^TPrescEmergen"
	s count=0
	s index=""
	f  s index=$o(^TMP("DHCINPHA",$this,"jsQueryDispPrescList",pid,"Index",index)) q:index=""  d
	.S outputdata=^TMP("DHCINPHA",$this,"jsQueryDispPrescList",pid,"Index",index)
	.S count=count+1
	.Q:(count<StPage)||(count>EnPage)
	.I count=StPage D
	..W ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartStringJqGrid(countrecords,rows)
	..W ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(colNameStr,outputdata)
	.E  D
	..W ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(colNameStr,outputdata)
	.I count=EnPage Write ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign()
	D ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"jsQueryDispPrescList",pid) 
	Q ""
}

/// Description:根据就诊ID获取处方列表
/// Creator:	hulihua
/// CreateDate:	2017-07-10
/// Table:      DHC_OEDISPENDSING 
/// Input:		就诊ID、药房ID、开始日期、开始时间、截至日期、截至时间
/// Output:		
/// Return：	条数、计数器    
/// Others:
/// w ##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).GetDispPrescListByAdm("2017-01-01^^2017-07-10^^87^^")
ClassMethod GetDispPrescListByAdm(PhaLoc, StratDate, EndDate, StartTime, EndTime, WardLoc, Adm)
{
	n (PhaLoc, StratDate, EndDate, StartTime, EndTime, WardLoc, Adm)
	s cnt=0
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid($this)
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"GetDispPrescListByAdm",pid)
	s PhaLocation=$o(^DHCPL(0,"Loc",PhaLoc,""))
	s NurseSeekFlag=$p($g(^DHCPL(+PhaLocation)),"^",37)
	s HospId=$p($g(^CTLOC(PhaLoc)),"^",22)
	k CheckAllowFlagArr
	f Date=StratDate:1:EndDate  d
	.s DspId=0
	.f  s DspId=$o(^DHCOEDISQTY(0,"ADM",PhaLoc,Date,"TC",Adm,DspId)) q:DspId=""  d
	..s Cat=$p(^DHCOEDISQTY(DspId),"^",27)
 	..q:Cat=0 //过虑配液医嘱
	..s TimeDosing=$p(^DHCOEDISQTY(DspId),"^",20)  ;分发时间
 	..q:(Date=StratDate)&(TimeDosing'="")&(StartTime'="")&(TimeDosing<StartTime)
 	..q:(Date=EndDate)&(TimeDosing'="")&(EndTime'="")&(TimeDosing>EndTime)
	..s OrdItmRowid=$p(^DHCOEDISQTY(DspId),"^",1)     ;OE_OrdItem表指针
	..s OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3)     ;OE_OrdExec表指针
	..s WardLocId=$p(^DHCOEDISQTY(DspId),"^",22)
 	..q:WardLocId=""
 	..q:(WardLoc'="")&&(WardLoc'=WardLocId)
 	..s WardId=$o(^PAWARD(0,"WARD_LocationDR",WardLocId,""))
	..s AdmWard=$p(^PAADM(Adm),"^",70)  		;病人当前病房
 	..s AdmType=$p($g(^PAADM(Adm)),"^",2)
 	..q:AdmType'="I"  							;过滤非住院病人  
 	..s Ord=+OrdExeRowid
 	..s Chl=$p(OrdExeRowid,"||",2)
 	..s OreChl=$p(OrdExeRowid,"||",3)
 	..q:Ord=""
 	..q:Chl=""
 	..q:'$d(^OEORD(Ord))
 	..q:'$d(^OEORD(Ord,"I",Chl))
 	..s prescNo=$p(^OEORD(Ord,"I",Chl,1),"^",14)
 	..q:prescNo=""
	..q:$d(CheckAllowFlagArr(prescNo))
 	..s queid=##class(PHA.COM.Order).PrescCYQueId(prescNo)
 	..q:queid=""
 	..s preOrdStr=##class(PHA.COM.Order).GetPreOrdInfo(prescNo)
 	..s seekType=$p(preOrdStr,"^",5)
 	..q:(NurseSeekFlag="Y")&&(seekType'="A")					;过滤-护士未提交或者拒绝
 	..s seekUserName=$p(preOrdStr,"^",3)
 	..s seekDate=$p(preOrdStr,"^",4)
 	..s prescStr=##class(PHA.COM.Order).GetPaQueInfo(prescNo)
 	..s Factor=$p(prescStr,"^",2)  
 	..s PrescForm=$p(prescStr,"^",8)
 	..s PrescEmergen=$p(prescStr,"^",18)
 	..i PrescEmergen="Y" d
 	...s PrescEmergen="是"
 	..e  d
 	...s PrescEmergen="否"
 	..q:$d(^TMP("DHCINPHA",$this,"GetDispPrescListByAdm",pid,"PrescNo",prescNo))
	..q:##class(web.DHCSTCOMMONSRV).IfAuditByPriority(DspId)=0	;过滤-护士审核												
 	..s RefuseFlag=##class(web.DHCSTPCHCOLLS2).HaveBeenRefused(DspId,prescNo)
 	..s:RefuseFlag'="" CheckAllowFlagArr(prescNo)=""
 	..q:RefuseFlag'=""   										;过滤-拒绝发药
 	..s AuditStatus=##class(web.DHCSTKUTIL).GetOrdAuditResult(DspId)
 	..s:AuditStatus'="Y" CheckAllowFlagArr(prescNo)=""
 	..q:AuditStatus'="Y"										;过滤-药师审核
 	..s AuditResult=##class(web.DHCSTCNTSCOMMON).GetCurPhoResultByPresc(prescNo,"IA")
 	..s DoctorLoc=$p(^OEORD(Ord,"I",Chl,7),"^",2) 
 	..q:##class(web.DHCSTPCHCOLLS).DoctorLocRefuse(PhaLoc,DoctorLoc)=1
 	..s ArcimId=$p(^OEORD(Ord,"I",Chl,1),"^",2)                                    ;医嘱 ARC_ItmMast ARCIM_RowId
 	..s ArcCatId=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10)        ;医嘱子类RowId
 	..s PriorDr=$p(^OEORD(Ord,"I",Chl,1),"^",8) 
 	..q:PriorDr=""
 	..s Priority=$p(^OECPR(PriorDr),"^",1) 
 	..q:Priority["OM"
 	..s AmtFlag=##class(web.DHCSTPCHCOLLS2).IfCollectDrugAllowed(Adm,ArcCatId_"^"_Priority)
 	..q:(AmtFlag=0)
 	..s CheckPartyAgr=##class(web.DHCDocOrderEntryCM).IsPrecompoundedARCIM(ArcimId)	;判断是否是协定方
 	..s Inci=$o(^INCI(0,"ARCIM_DR",$p(ArcimId,"||",1),"")) 
 	..q:(Inci="")&&(CheckPartyAgr'="1")
 	..q:'$d(^OEORD(Ord,"I",Chl,"X",OreChl,"BILL"))
 	..q:##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)=0  ;判断该配药记录是否需要配药：执行记录医嘱状态，护士执行状态
	..s patInfo=##class(PHA.COM.Order).GetPatInfo(Adm)
	..s patno=$p(patInfo,"^",1) 
	..s patname=$p(patInfo,"^",3) 
 	..s Bed=$P(patInfo,"^",13)        						   ;病人床号
 	..s WardLocDesc=$P(^CTLOC(WardLocId),"^",2)
 	..s Data1=Bed_"^"_patno_"^"_patname_"^"_prescNo_"^"_WardLocId_"^"_WardLocDesc_"^"_seekUserName_"^"_seekDate_"^"_AuditResult
 	..s Data2=$g(Factor)_"^"_$g(PrescForm)_"^"_$g(PrescEmergen)
 	..s Data=Data1_"^"_Data2
	..s ^TMP("DHCINPHA",$this,"GetDispPrescListByAdm",pid,"PrescNo",prescNo)=Data
	..s cnt=cnt+1
	.
	k CheckAllowFlagArr
	s ret=cnt_"^"_pid
	q ret
}

/// Description:依据病区ID串获取处方列表信息
/// Creator:	hulihua
/// CreateDate:	2017-07-10
/// Table:      DHC_OEDISPENDSING 
/// Input:		病区ID串、药房ID、开始日期、开始时间、截至日期、截至时间
/// Output:		
/// Return：	条数、计数器    
/// Others:
/// w ##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).GetDispPrescListByWard("2017-01-01^^2017-07-10^^87^^")
ClassMethod GetDispPrescListByWard(PhaLoc, StratDate, EndDate, StartTime, EndTime, WardLoc)
{
	n (PhaLoc, StratDate, EndDate, StartTime, EndTime, WardLoc)
	s cnt=0
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid($this)
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"GetDispPrescListByWard",pid)
	s PhaLocation=$o(^DHCPL(0,"Loc",PhaLoc,""))
	s NurseSeekFlag=$p($g(^DHCPL(+PhaLocation)),"^",37)
	s HospId=$p($g(^CTLOC(PhaLoc)),"^",22)
	s CatStr=##class(web.DHCINPHA.InfoCommon).GetPhaDispType(PhaLoc)
	k CheckAllowFlagArr
	f Date=StratDate:1:EndDate  d
	.s WardLocId=""
 	.f  s WardLocId=$o(^DHCOEDISQTY(0,"REC",PhaLoc,Date,"TC",WardLocId))  q:WardLocId=""  d
 	..q:(WardLoc'="")&&(WardLoc'=WardLocId)
	..s CatLen=$l(CatStr,"^")
	..f j=1:1:CatLen d
	...s DspCat=$p(CatStr,"^",j)
	...s DspId=0
	...f  s DspId=$o(^DHCOEDISQTY(0,"REC",PhaLoc,Date,"TC",WardLocId,DspCat,DspId)) q:DspId=""  d
	....s TimeDosing=$p(^DHCOEDISQTY(DspId),"^",20)  ;分发时间
 	....q:(Date=StratDate)&(TimeDosing'="")&(StartTime'="")&(TimeDosing<StartTime)
 	....q:(Date=EndDate)&(TimeDosing'="")&(EndTime'="")&(TimeDosing>EndTime)
	....s OrdItmRowid=$p(^DHCOEDISQTY(DspId),"^",1)     ;OE_OrdItem表指针
	....s OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3)     ;OE_OrdExec表指针 
	....s Adm=$p(^DHCOEDISQTY(DspId),"^",26)
	....q:Adm=""
	....s AdmWard=$p(^PAADM(Adm),"^",70)  		;病人当前病房
	....s AdmType=$p($g(^PAADM(Adm)),"^",2)
	....q:AdmType'="I"  							;过滤非住院病人     
	....s Ord=+OrdExeRowid
	....s Chl=$p(OrdExeRowid,"||",2)
	....s OreChl=$p(OrdExeRowid,"||",3)
	....q:Ord=""
	....q:Chl=""
	....q:'$d(^OEORD(Ord))
	....q:'$d(^OEORD(Ord,"I",Chl))
	....s prescNo=$p(^OEORD(Ord,"I",Chl,1),"^",14)
	....q:prescNo=""
	....q:$d(CheckAllowFlagArr(prescNo))
 	....s queid=##class(PHA.COM.Order).PrescCYQueId(prescNo)
 	....q:queid=""
 	....s preOrdStr=##class(PHA.COM.Order).GetPreOrdInfo(prescNo)
 	....s seekType=$p(preOrdStr,"^",5)
 	....q:(NurseSeekFlag="Y")&&(seekType'="A")						;过滤-护士未提交或者拒绝
 	....s seekUserName=$p(preOrdStr,"^",3)
 	....s seekDate=$p(preOrdStr,"^",4)
 	....s prescStr=##class(PHA.COM.Order).GetPaQueInfo(prescNo)
 	....s Factor=$p(prescStr,"^",2)  
 	....s PrescForm=$p(prescStr,"^",8)
 	....s PrescEmergen=$p(prescStr,"^",18)
 	....i PrescEmergen="Y" d
 	.....s PrescEmergen="是"
 	....e  d
 	.....s PrescEmergen="否"
 	....q:$d(^TMP("DHCINPHA",$this,"GetDispPrescListByWard",pid,"PrescNo",prescNo))
 	....q:##class(web.DHCSTCOMMONSRV).IfAuditByPriority(DspId)=0	;过滤-护士审核
 	....s RefuseFlag=##class(web.DHCSTPCHCOLLS2).HaveBeenRefused(DspId,prescNo)
 	....s:RefuseFlag'="" CheckAllowFlagArr(prescNo)=""
 	....q:RefuseFlag'=""   											;过滤-拒绝发药
 	....s AuditStatus=##class(web.DHCSTKUTIL).GetOrdAuditResult(DspId)
 	....s:AuditStatus'="Y" CheckAllowFlagArr(prescNo)=""
 	....q:AuditStatus'="Y"											;过滤-药师审核
 	....s AuditResult=##class(web.DHCSTCNTSCOMMON).GetCurPhoResultByPresc(prescNo,"IA")
 	....s DoctorLoc=$p(^OEORD(Ord,"I",Chl,7),"^",2) 
 	....q:##class(web.DHCSTPCHCOLLS).DoctorLocRefuse(PhaLoc,DoctorLoc)=1
 	....s ArcimId=$p(^OEORD(Ord,"I",Chl,1),"^",2)                                    ;医嘱 ARC_ItmMast ARCIM_RowId
 	....s ArcCatId=$p(^ARCIM($p(ArcimId,"||",1),$p(ArcimId,"||",2),1),"^",10)        ;医嘱子类RowId
 	....s PriorDr=$p(^OEORD(Ord,"I",Chl,1),"^",8) 
 	....q:PriorDr=""
 	....s Priority=$p(^OECPR(PriorDr),"^",1) 
	....q:Priority["OM" ;自备以及嘱托
 	....s AmtFlag=##class(web.DHCSTPCHCOLLS2).IfCollectDrugAllowed(Adm,ArcCatId_"^"_Priority)
 	....q:AmtFlag=0
 	....s CheckPartyAgr=##class(web.DHCDocOrderEntryCM).IsPrecompoundedARCIM(ArcimId)	;判断是否是协定方
 	....s Inci=$o(^INCI(0,"ARCIM_DR",$p(ArcimId,"||",1),"")) 
 	....q:(Inci="")&&(CheckPartyAgr'="1")
 	....q:'$d(^OEORD(Ord,"I",Chl,"X",OreChl,"BILL"))
 	....q:##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)=0  ;判断该配药记录是否需要配药：执行记录医嘱状态，护士执行状态
	....s patInfo=##class(PHA.COM.Order).GetPatInfo(Adm)
	....s patno=$p(patInfo,"^",1) 
	....s patname=$p(patInfo,"^",3) 
 	....s Bed=$P(patInfo,"^",13)        						   ;病人床号
 	....s WardLocDesc=$P(^CTLOC(WardLocId),"^",2)
 	....s Data1=Bed_"^"_patno_"^"_patname_"^"_prescNo_"^"_WardLoc_"^"_WardLocDesc_"^"_seekUserName_"^"_seekDate_"^"_AuditResult
 	....s Data2=$g(Factor)_"^"_$g(PrescForm)_"^"_$g(PrescEmergen)
 	....s Data=Data1_"^"_Data2
	....s ^TMP("DHCINPHA",$this,"GetDispPrescListByWard",pid,"PrescNo",prescNo)=Data
	....s cnt=cnt+1
	...
	..
	.
	k CheckAllowFlagArr
	s ret=cnt_"^"_pid
	q ret
}

/// Description:通过登记号获取某病人的就诊列表
/// Creator:	hulihua
/// CreateDate:	2017-07-14
/// Table:      PA_PatMas、PA_Adm
/// Input:
/// Output:
/// Return：    床号、登记号、病人姓名、处方号
/// Others:
/// w ##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).jsQueryDispAdmList("1","50","0000000118")
ClassMethod jsQueryDispAdmList(page, rows, params, logonLocId = "")
{
	n (page, rows, params, logonLocId)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson() 
	s page=1
	s rows=1000
	s patNo=$p(params,"^",1)
	s papmi=$o(^PAPERi("PAPMI_PatNo",patNo,""))
	i papmi="" d
	.s papmi=##Class(web.DHCWMRService).IGetPatientIDByMrNo(patNo,"")
	q:papmi="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson() 
	s logonHospId=$p($g(^CTLOC(+logonLocId)),"^",22)
	s colNameStr="TAdm^TCurrWard^TAdmDate^TAdmTime^TAdmLoc^TCurrentBed^TDoctor^TPameNo^TPatNo^TPapmi"
	s count=0
	s adm="" 
	f  s adm=$o(^PAPERdr(papmi,"ADM","I",adm),-1) q:adm=""  d
	.s adm=+adm
	.q:$p(^PAADM(adm),"^",2)'="I"     
	.s depcodedr=$p(^PAADM(adm),"^",4) i depcodedr'="" s depDesc=$p(^CTLOC(depcodedr),"^",2)
	.s deptHospId=$p($g(^CTLOC(+depcodedr)),"^",22)
	.q:(logonHospId'="")&&(logonHospId'=deptHospId)
	.s admdate=$p(^PAADM(adm),"^",6) 
	.i +admdate>0 s admdate=##class(PHA.FACE.IN.Com).DateLogicalToHtml(admdate) 
	.s admtime=$p(^PAADM(adm),"^",7) 
	.i +admtime>0 s admtime=##class(PHA.FACE.IN.Com).TimeLogicalToHtml(admtime,"IP")
	.s curWard=$p(^PAADM(adm),"^",70) i curWard'="" s curWardDesc=$p(^PAWARD(+curWard),"^",2)
	.s wardLocId=$p($g(^PAWARD(+curWard)),"^",5)
	.s wardHospId=$p($g(^CTLOC(+wardLocId)),"^",22)
	.q:(logonHospId'="")&&(logonHospId'=wardHospId)
	.s doctor=$p(^PAADM(adm),"^",9)
	.i +doctor'="0"  s doctor=$p($g(^CTPCP(doctor,1)),"^",2 )
	.i curWardDesc["-" s curWardDesc=$p(curWardDesc,"-",2)
	.i depDesc["-" s depDesc=$p(depDesc,"-",2)
	.s patInfo=##class(PHA.COM.Order).GetPatInfo(adm)
	.s patNo=$p(patInfo,"^",1)
	.s pameNo=$p(patInfo,"^",12)
	.s bedNo=$p(patInfo,"^",13)
	.s outputdata=$g(adm)_"^"_$g(curWardDesc)_"^"_$g(admdate)_"^"_$g(admtime)_"^"_$g(depDesc)_"^"_$g(bedNo)_"^"_$g(doctor)_"^"_$g(pameNo)_"^"_$g(patNo)_"^"_$g(papmi) 
	.s count=count+1
	.I count=1 d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetJsonStartString(999)
	..W ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(colNameStr,outputdata)
	.e  d
	..W ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(colNameStr,outputdata)
	.
	q:count=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(0) 
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign()
	q ""
}

/// Description:获取时间段内已发处方列表
/// Creator:	hulihua
/// CreateDate:	2018-12-24
/// Table:      DHC_PHACollected、DHC_PHACollectItm、DHC_PhaCollectItmLB
/// Input:
/// Output:
/// Return：    病区、床号、登记号、病人姓名、处方号
/// Others:
/// Debug:		w ##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).jsQueryAlrDispPrescList("1","50","2021-02-07^00:00:00^2021-02-07^23:59:59^212^")
ClassMethod jsQueryAlrDispPrescList(page, rows, params)
{
	n (page, rows, params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson() 
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s StartDate=$p(params,"^",1)
	s StartDate=##class(PHA.FACE.IN.Com).DateHtmlToLogical(StartDate)
	s StartTime=$p(params,"^",2)
	s StartTime=##class(PHA.FACE.IN.Com).TimeHtmlToLogical(StartTime)
	s EndDate=$p(params,"^",3)
	s EndDate=##class(PHA.FACE.IN.Com).DateHtmlToLogical(EndDate)
	s EndTime=$p(params,"^",4)
	s EndTime=##class(PHA.FACE.IN.Com).TimeHtmlToLogical(EndTime)
	s PhaLoc=$p(params,"^",5)
	s WardLocId=$p(params,"^",6)
	s InutAdm=$p(params,"^",7)
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid($this)
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"jsQueryAlrDispPrescList",pid)
	k CheckAlrDispPrescArr
	s cnt=0
	f Date=StartDate:1:EndDate  d
	.s phacId=""
	.f  s phacId=$o(^DHCPHAC(0,"PHA",PhaLoc,"DATE",Date,phacId)) q:phacId=""  d
	..q:'$d(^DHCPHAC(phacId))
	..s prescNo=$p($g(^DHCPHAC(phacId,1)),"^",1)
	..q:prescNo=""
	..q:$d(CheckAlrDispPrescArr("PrescNo",prescNo))
	..s CollTime=$p(^DHCPHAC(phacId),"^",3)
	..q:(StartDate=Date)&&(StartTime'="")&&(CollTime<StartTime)
	..q:(EndDate=Date)&&(EndTime'="")&&(CollTime>EndTime)
 	..s queid=##class(PHA.COM.Order).PrescCYQueId(prescNo)
 	..q:queid=""							;非草药处方
 	..s preOrdStr=##class(PHA.COM.Order).GetPreOrdInfo(prescNo)
 	..s admDr=$p(preOrdStr,"^",2)
 	..q:(InutAdm'="")&&(InutAdm'=admDr)
 	..s seekUserName=$p(preOrdStr,"^",3)
 	..s seekDate=$p(preOrdStr,"^",4)
	..s prescStr=##class(PHA.COM.Order).GetPaQueInfo(prescNo)
 	..s facTor=$p(prescStr,"^",2)
 	..s prescCount=##class(PHA.COM.Order).GetPrescNoCount(prescNo)
 	..s patInfo=##class(PHA.COM.Order).GetPatInfo(admDr,phacId)
	..s patNo=$p(patInfo,"^",1)
	..s patName=$p(patInfo,"^",3)
	..s bedNo=$p(patInfo,"^",13)
	..s phaomInfo=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPhaomInfo(prescNo,"N")
	..s monitorDateTime=$p(phaomInfo,"^",1)
	..s monitorName=$p(phaomInfo,"^",3)
	..s wardId=$p(^PAADM(admDr),"^",70)
	..s wardLocDr=$p(^PAWARD(wardId),"^",5)
	..q:(WardLocId'="")&&(WardLocId'=wardLocDr)
	..s wardLocDesc=$p(##class(PHA.COM.Method).GetLocInfoById(wardLocDr),"^",2)
	..s prescForm=$p(prescStr,"^",8)
	..s printFlag=$p(^DHCPHAC(phacId),"^",16)
	..s dataSource=$p(^DHCPHAC(phacId),"^",35)
	..i prescForm'["颗粒剂"  d
	...s optorType=$s(dataSource=1:"人工",printFlag>0:"调剂单",1:"手机")
	..e  d
	...s optorType="人工"
	..s collectUserId=$p(^DHCPHAC(phacId),"^",13)
	..s collectUser=$p(##class(PHA.COM.Method).GetUserInfoById(collectUserId),"^",2)
	..s collectDate=$p(^DHCPHAC(phacId),"^",2)
	..s collectDate=##class(PHA.FACE.IN.Com).DateLogicalToHtml(collectDate)
	..s collectTime=$p(^DHCPHAC(phacId),"^",3)
	..s collectTime=##class(PHA.FACE.IN.Com).TimeLogicalToHtml(collectTime)
	..s:collectDate'="" collectDate=collectDate_" "_collectTime
	..s operatorId=$p(^DHCPHAC(phacId),"^",5)
	..s operatorUser=$p(##class(PHA.COM.Method).GetUserInfoById(operatorId),"^",2)
	..s operatorDate=$p(^DHCPHAC(phacId),"^",18)
	..s operatorDate=##class(PHA.FACE.IN.Com).DateLogicalToHtml(operatorDate)
	..s operatorTime=$p(^DHCPHAC(phacId),"^",19)
	..s operatorTime=##class(PHA.FACE.IN.Com).TimeLogicalToHtml(operatorTime)
	..s:operatorDate'="" operatorDate=operatorDate_" "_operatorTime
	..s agreeRetInfo=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPhacAgreeRetInfo(prescNo)
	..s agreeRetFlag=$p(agreeRetInfo,"^",1)
	..s agreeRetFlag = $s(agreeRetFlag="Y":"是",1:"")
	..s agreeRetUser=$p(agreeRetInfo,"^",3)
	..s agreeRetDate=$p(agreeRetInfo,"^",4)
	..s agreeRetRemark=$p(agreeRetInfo,"^",5)
	..s CheckAlrDispPrescArr("PrescNo",prescNo)=""
	..;
	..s Data1=bedNo_"^"_patNo_"^"_patName_"^"_prescNo_"^"_wardLocDr
	..s Data2=wardLocDesc_"^"_monitorName_"^"_monitorDateTime_"^"_seekUserName_"^"_seekDate
	..s Data3=facTor_"^"_prescCount_"^"_optorType_"^"_prescForm_"^"_phacId
	..s Data4=operatorUser_"^"_operatorDate_"^"_collectUser_"^"_collectDate_"^"_agreeRetFlag
	..s Data5=agreeRetUser_"^"_agreeRetDate_"^"_agreeRetRemark
	..s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4_"^"_Data5
	..s cnt=cnt+1
	..s index=bedNo_","_prescNo
	..s ^TMP("DHCINPHA",$this,"jsQueryAlrDispPrescList",pid,"PrescNo",index)=Data
	.
	i cnt=0 d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"jsQueryAlrDispPrescList",pid)
	q:cnt=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(0)
	s colNameStr1="TBedNo^TPatNo^TPatName^TPrescNo^TWardLocId"
	s colNameStr2="TWardLoc^TmonitorName^TmonitorDateTime^TSeekUserName^TSeekDate"
	s colNameStr3="TFactor^TPrescCount^TOptorType^TPrescForm^TPhac"
	s colNameStr4="TOperatorUser^TOperatorDate^TCollectUser^TCollectDate^TAgreeRetFlag"
	s colNameStr5="TAgreeRetUser^TAgreeRetDate^TAgreeRetRemark"
	s colNameStr=colNameStr1_"^"_colNameStr2_"^"_colNameStr3_"^"_colNameStr4_"^"_colNameStr5
	s count=0
	s index=""
	f  s index=$o(^TMP("DHCINPHA",$this,"jsQueryAlrDispPrescList",pid,"PrescNo",index)) q:index=""  d
	.s outputdata=^TMP("DHCINPHA",$this,"jsQueryAlrDispPrescList",pid,"PrescNo",index)
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
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp($this,"jsQueryAlrDispPrescList",pid)
	k CheckAlrDispPrescArr
	q ""
}

/// w ##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).GetPrescDetail("I181105000010")
ClassMethod GetPrescDetail(prescno)
{
	n (prescno)
	q:prescno="" ""
	s ord=$o(^OEORD(0,"PrescNo",prescno,""))
	q:ord="" ""
	s itm=$o(^OEORD(0,"PrescNo",prescno,ord,"")) 
	q:itm="" ""
	s adm=$p(^OEORD(ord),"^",1)
	s admType=$p(^PAADM(adm),"^",2)
	s papmi=$p(^PAADM(adm),"^",1)
	s perno=$p(^PAPER(papmi,"PAT",1),"^",2)
	s pname=$p(^PAPER(papmi,"ALL"),"^",1)
	s ptel=$p(^PAPER(papmi,"PER",1),"^",11)
	s paddress=$g(^PAPER(papmi,"PER","ADD",1))
	s getage=##class(PHA.FACE.IN.Com).GetAge(papmi,adm) 
    s sexdr=$p(^PAPER(papmi,"ALL"),"^",7)
    s sex=$p(^CT("SEX",sexdr),"^",2)
    s patNation=$s(($D(^PAPER(papmi,"PER",2)))&&($p(^PAPER(papmi,"PER",2),"^",1)'=""):$p(^CT("NAT",$p(^PAPER(papmi,"PER",2),"^",1)),"^",2),1:"") //民族
    s cardNo=""
    s cfRowId=$o(^DHCCARDi("CF",0,"PAPMIDR",papmi,""),-1)
	s pameno=##class(PHA.FACE.IN.Com).GetMrNoByEpisodeID(adm,admType) //病案号    
    s:cfRowId'="" cardNo=$p($g(^DHCCARD("CF",cfRowId)),"^",2)
    s credno=$p(^PAPER(papmi,"ALL"),"^",9)
    s admord=$o(^OEORD(0,"PrescNo",prescno,""))
    s adm=$p(^OEORD(admord),"^",1)
    s admdate=""
    s admdate=$p(^PAADM(adm),"^",6)
    i admdate'="" s admdate=$zd(admdate,3)
    ;先取处方的关联诊断，如果取空了再取该患者的中医诊断！
    s diagnodesc=##class(PHA.FACE.IN.Com).GetMRDiagnosDesc(prescno,",","GC")
    s:diagnodesc="" diagnodesc=##class(PHA.COM.Order).MrDiagnose(adm,",","GC")
    s patW=##class(PHA.COM.Order).PatWeight(adm)
    s deplocdr=$p(^PAADM(adm),"^",4)
    s deplocdesc=$p(^CTLOC(deplocdr),"^",2)
    i deplocdesc["-" s deplocdesc=$p(deplocdesc,"-",2)
    s orddate=+$p($g(^OEORD(ord,"I",itm,3)),"^",7)
    s:orddate'="" orddate=$zd(orddate,3)
    s reclocdr=$p(^OEORD(ord,"I",itm,3),"^",6)
    s recloc=$p(^CTLOC(reclocdr),"^",2) 
    s HospID=$p(^CTLOC(reclocdr),"^",22) 
    i $F(recloc,"-") s recloc=$p(recloc,"-",2)
    s orddeptdr=$p(^OEORD(ord,"I",itm,7),"^",2)
    s doctloc=$p(^CTLOC(orddeptdr),"^",2)
    s:doctloc["-" doctloc=$p(doctloc,"-",2)
    s orddoctdr=$p($g(^OEORD(ord,"I",itm,1)),"^",11) 
    s doctor=""
    i orddoctdr'="" s doctor=$p($g(^CTPCP(orddoctdr,1)),"^",2)
    //草药
    s prescStr=##class(PHA.COM.Order).GetPaQueInfo(prescno)
    s queinst=$p(prescStr,"^",1)
    s quefac=$p(prescStr,"^",2) 
    s queqty=$p(prescStr,"^",3)
    s quedate=$p(prescStr,"^",4)
    s quexdate=$p(prescStr,"^",5)
    s quenote=$p(prescStr,"^",6)  
    s quecook=$p(prescStr,"^",7)
    s queform=$p(prescStr,"^",8)
    s queFreq=$p(prescStr,"^",9)
    s PrescConfig=$p(prescStr,"^",10)
    s PrescOrderQtyDesc=$p(prescStr,"^",11)
    s DrugInfo=$p(prescStr,"^",12)
    s DurationDesc=$p(prescStr,"^",14)
    s sumamt=0
    s presctype=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetCYPrescTitle(prescno)
    s paytype=##class(web.DHCOutPhCommon).GetPrescFeeType(prescno)
    s auditname=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPhaomInfo(prescno),"^",3)
    s (pyname,fyname,pydate,pytime,fydate,pytime,checkname)=""
    S Phac=$o(^DHCPHACi("PRESCNO",prescno,""),-1)
    i Phac'="" s PrescCount=##class(PHA.COM.Order).GetPrescNoCount(prescno)	//处方味数
    e  s PrescCount=##class(PHA.COM.Order).GetPrescNoUnCount(prescno)
    ;
    s patstring1=perno_"^"_pname_"^"_getage_"^"_sex_"^"_diagnodesc
    s patstring2=patW_"^"_cardNo_"^"_admdate_"^"_deplocdesc_"^"_pyname
    s patstring3=fyname_"^"_pydate_"^"_pytime_"^"_fydate_"^"_pytime
    s patstring4=recloc_"^"_doctloc_"^"_doctor_"^"_orddate_"^"_ptel
    s patstring5=paddress_"^"_queinst_"^"_quefac_"^"_queqty_"^"_quedate
    s patstring6=quexdate_"^"_quenote_"^"_quecook_"^"_sumamt_"^"_prescno
    s patstring7=presctype_"^"_patNation_"^"_paytype_"^"_pameno_"^"_auditname
    s patstring8=checkname_"^"_PrescConfig_"^"_queFreq_"^"_PrescOrderQtyDesc_"^"_DrugInfo
    s patstring9=DurationDesc_"^"_PrescCount
    s patstring=patstring1_"^"_patstring2_"^"_patstring3_"^"_patstring4_"^"_patstring5_"^"_patstring6_"^"_patstring7_"^"_patstring8_"^"_patstring9
    ;以下为处方明细
    s ComFlag=##class(web.DHCINPHA.MTCommon.PublicCallMethod).CheckCMXDPTCom(prescno)
    s ord="",medstring=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:ord=""  d
	.s itm=""
	.f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm))  q:itm=""  d
	..s oeori=ord_"||"_itm
	..s OEPrescNo=$p(^OEORD(ord,"I",itm,1),"^",14)
	..q:prescno'=OEPrescNo
	..s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,""),-1)
	..q:dsp="" 
    ..s totalprice=..GetTotalSpAmt(oeori)
    ..s sumamt=sumamt+totalprice
    ..s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)
    ..s CheckPartyAgr=##class(web.DHCDocOrderEntryCM).IsPrecompoundedARCIM(arcimid)	;判断是否是协定方 
    ..s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"")) 
    ..q:(inci="")&&(CheckPartyAgr'="1")
    ..s fontflag=""
    ..i ComFlag="1"  d
    ...;协定处方和普通草药组合
    ...s OrdUserID=$p($g(^OEORD(ord,"I",itm,7)),"^",1)
	...s OrdUserName=$p($g(^SSU("SSUSR",OrdUserID)),"^",2)
	...s DepId=0 
	...f  s DepId=$O(^ARCIM(+arcimid,$p(arcimid,"||",2),"DEPEND",DepId)) q:DepId=""  d
	....s depdatefrom=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),"DEPEND",DepId),"^",1)
	....q:(depdatefrom'="")&&(depdatefrom>+$h)
	....s depdateto=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),"DEPEND",DepId),"^",2)
	....q:(depdateto'="")&&(depdateto<+$h)
	....s deparcimdr=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),"DEPEND",DepId),"^",3)
	....q:deparcimdr=""
	....s arcimdesc=$p(^ARCIM(+deparcimdr,$p(deparcimdr,"||",2),1),"^",2)
	....s DoseQtyCM=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),"DEPEND",DepId),"^",7)
	....s DoseUOM=$p(^ARCIM(+arcimid,$p(arcimid,"||",2),"DEPEND",DepId),"^",8)
	....s CTUOMDesc=$s(DoseUOM'="":$p(^CT("UOM",DoseUOM),"^",2),1:"") //剂量单位
	....;限量 极量判断
	....s XLQty=0,JLQty=0,PhSpecInstr=""
	....s DHCItmMastRowID=$o(^DHCItmMast("0","ARCIM",deparcimdr,0))
	....i DHCItmMastRowID'="" d
	.....s XLQty=+$p($g(^DHCItmMast(DHCItmMastRowID)),"^",3)
	.....s JLQty=+$p($g(^DHCItmMast(DHCItmMastRowID)),"^",10)
	....s:((XLQty'=0)&&(DoseQtyCM>XLQty))||((JLQty'=0)&&(DoseQtyCM>JLQty)) PhSpecInstr=OrdUserName
	....;十八反判断
	....s LimitFlag=##class(PHA.COM.Order).CheckCMPrescLimitInfo(oeori)
	....s:PhSpecInstr="" PhSpecInstr=$s(LimitFlag="Y":OrdUserName,1:"")
	....;毒麻判断
	....s Phcdf=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(arcimid)  
 	....s PoisonDesc=$p(##class(web.DHCST.Common.DrugInfoCommon).GetPhcPoisonByPhcd(Phcdf),"^",2)
 	....s:(PoisonDesc["毒")||(PoisonDesc["麻") fontflag=1
 	....s:PhSpecInstr="" PhSpecInstr=$s((PoisonDesc["毒")||(PoisonDesc["麻"):OrdUserName,1:"")
	....;
	....s tmpsting1=arcimdesc_"^"_DoseQtyCM_"^"_CTUOMDesc_"^"_totalprice_"^"
	....s tmpsting2=PhSpecInstr_"^"_fontflag
    ....s tmpsting=tmpsting1_"^"_tmpsting2
    ....i medstring="" d
    .....s medstring=tmpsting
    ....e  d
    .....s medstring=medstring_"@"_tmpsting
    ....
    ...
    ..e  d
    ...s arcimdesc=$p($g(^ARCIM(+arcimid,1,1)),"^",2)
    ...s ordremark=$p($g(^OEORD(ord,"I",itm,2)),"^",8)
    ...s OrdUserID=$p($g(^OEORD(ord,"I",itm,7)),"^",1)
	...s OrdUserName=$p($g(^SSU("SSUSR",OrdUserID)),"^",2)
	...s DoseUOM=$p($g(^OEORD(ord,"I",itm,2)),"^",3)
	...s CTUOMDesc=$s(DoseUOM'="":$p(^CT("UOM",DoseUOM),"^",2),1:"") //剂量单位
	...s DoseQty=$p($g(^OEORD(ord,"I",itm,1)),"^",12) 				 //数量
	...s DoseQtyCM=DoseQty/quefac
	...;限量 极量判断
	...s XLQty=0,JLQty=0,PhSpecInstr=""
	...s DHCItmMastRowID=$o(^DHCItmMast("0","ARCIM",arcimid,0))
	...i DHCItmMastRowID'="" d
	....s XLQty=+$p($g(^DHCItmMast(DHCItmMastRowID)),"^",3)
	....s JLQty=+$p($g(^DHCItmMast(DHCItmMastRowID)),"^",10)
	...s:((XLQty'=0)&&(DoseQtyCM>=XLQty))||((JLQty'=0)&&(DoseQtyCM>=JLQty)) PhSpecInstr=OrdUserName
	...;十八反判断
	...s LimitFlag=##class(PHA.COM.Order).CheckCMPrescLimitInfo(oeori)
	...s:PhSpecInstr="" PhSpecInstr=$s(LimitFlag="Y":OrdUserName,1:"")
	...;毒麻判断
	...s Phcdf=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(arcimid)  
 	...s PoisonDesc=$p(##class(web.DHCST.Common.DrugInfoCommon).GetPhcPoisonByPhcd(Phcdf),"^",2)
	...s:(PoisonDesc["毒")||(PoisonDesc["麻") fontflag=1
 	...s:PhSpecInstr="" PhSpecInstr=$s((PoisonDesc["毒")||(PoisonDesc["麻"):OrdUserName,1:"")
	...;
    ...s tmpsting1=arcimdesc_"^"_DoseQtyCM_"^"_CTUOMDesc_"^"_totalprice_"^"_ordremark
    ...s tmpsting2=PhSpecInstr_"^"_fontflag
    ...s tmpsting=tmpsting1_"^"_tmpsting2
    ...i medstring="" d
    ....s medstring=tmpsting
    ...e  d
    ....s medstring=medstring_"@"_tmpsting
    ...
    ..
    .
    s:$p(sumamt,".",1)="" sumamt=0_sumamt
    s $p(patstring,"^",29)=sumamt   //处方总金额
    q patstring_"!!"_medstring
}

/// Description:获取某医嘱在打包表记录的金额
/// Creator: 	hulihua
/// CreateDate: 2017-10-25
/// Table:      DHC_OEDispensing--新医嘱打包表、DHC_OEDispBatch 打包子表
/// Input:		oeori-医嘱ID
/// Output:
/// Return：    某医嘱在打包表的金额
/// Others:
/// w ##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).GetTotalSpAmt("1||73")
ClassMethod GetTotalSpAmt(oeori As %String) As %String
{
	n (oeori)
	s delflag=0,totalspamt=0
	s dsp=""
	f  s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,dsp),-1)  q:(dsp="")||(delflag'=0)  d
	.s dspsub=0
	.f  s dspsub=$o(^DHCOEDISQTY(dsp,"I",dspsub))  q:dspsub=""  d
	..s dspbatchid=dsp_"||"_dspsub
	..s qty=$p(^DHCOEDISQTY(dsp,"I",dspsub),"^",2)
	..s sp=+$p(^DHCOEDISQTY(dsp,"I",dspsub),"^",4)
	..s:sp=0 sp=##Class(web.DHCSTINTERFACE).GetBatchSp(dspbatchid)
	..s spamt=sp*qty
	..s totalspamt=totalspamt+spamt
	.s delflag=1
	q totalspamt
}

/// w ##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).GetOrdStrByPrescno("I181226000067")
ClassMethod GetOrdStrByPrescno(prescno As %String) As %String
{
	n (prescno)
	q:prescno="" ""
	s OrditmStr="",oeoreStr="",oeori=""
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:ord=""  d
	.s itm=""
	.f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm))  q:itm=""  d
	..S dspId=$o(^DHCOEDISQTY(0,"OEORI",ord_"||"_itm,""))
	..Q:dspId=""
	..s dspStatus=$p(^DHCOEDISQTY(dspId),"^",7)
	..i dspStatus="C" s disped="Y"
	..e  s disped=""
	..s OEPrescNo=$p(^OEORD(ord,"I",itm,1),"^",14)
	..q:prescno'=OEPrescNo
	..s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1)
	..// 过滤-医嘱已停止    
	..q:(oeflag'="V")&&(oeflag'="E")		                                      
	..s priority=$p(^OEORD(ord,"I",itm,1),"^",8) 
	..s priorcode=$p(^OECPR(priority),"^",1)   
	..q:priorcode["OM"
	..s oeore=$p(^DHCOEDISQTY(dspId),"^",3)
	..// 过滤-执行记录停止
	..q:##class(web.DHCSTCOMMONSRV).GetOrdState(oeore)=0 
	..s dspQty=$p(^DHCOEDISQTY(dspId),"^",5)
	..s oeoreQtyData=oeore_$c(2)_dspQty
	..s oeori=ord_"||"_itm
	..s OrditmStr=$s(OrditmStr="":oeori,1:OrditmStr_"^"_oeori)
	..s oeoreStr=$s(oeoreStr="":oeoreQtyData,1:oeoreStr_"^"_oeoreQtyData)
	.
	q:oeori="" ""
	q:disped="Y" "-1&&该处方已发药！"
	s mainorditm=##class(PHA.COM.Order).GetMainOeori(oeori)
	q OrditmStr_"&&"_mainorditm_"&&"_oeoreStr
}

/// Description:判读处方是否需要审核
/// Creator: 	hulihua
/// CreateDate: 2017-11-02
/// Table:      DHC_OEDISPENSING,DHC_PhaLocation
/// Input:
/// Output:
/// Return：    Y-是，N-否
/// Others:
/// w ##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).CheckIfAudit("I17110100015")
ClassMethod CheckIfAudit(prescno As %String) As %String
{
	n (prescno)
	s ord=$o(^OEORD(0,"PrescNo",prescno,""),-1)  
	q:ord="" "N"
	s itm=$o(^OEORD(0,"PrescNo",prescno,ord,""),-1)
	q:itm="" "N" 
	s oeori=ord_"||"_itm 
	s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,""),-1)
	q:dsp="" "N"
	s AuditFlag=##class(web.DHCSTKUTIL).GetOrdAuditFlag(dsp)
	q AuditFlag
}

/// Description:通过处方号获取发药主表的ID
/// Creator: 	hulihua
/// CreateDate: 2017-12-11
/// Table:      DHC_PHACollected--住院发药主表
/// Input:		prescno-处方号
/// Output:
/// Return：    发药主表ID
/// Others:
/// w ##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).GetPhacByPres("I17110100015")
ClassMethod GetPhacByPres(prescno As %String) As %String
{
	n (prescno)
	s phac=$o(^DHCPHACi("PRESCNO",prescno,""),-1)
	q:phac'="" phac
	s phac=$o(^DHCPHAC(0,"Prescno",prescno,""),-1)
	q:phac="" ""
	q phac
}

/// Description:根据处方号获取处方的拒绝原因串
/// Creator: 	hulihua
/// CreateDate: 2018-12-19
/// Table:      DHC_PHAORDMONITOR--医嘱审核主表、DHC_PHAORDMONITORLIST--审核子表
/// Input:		PhaomId-医嘱审核主表ID
/// Output:
/// Return：    该处方的拒绝原因串
/// Others:
/// w ##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).GetRefReasonByPresc("I17110100015")
ClassMethod GetRefReasonByPresc(prescno, type = "") As %String
{
   q:prescno="" ""
   s exit=0
   s phaomid=""
   f  s phaomid=$o(^DHCPHORDM(0,"PrescNo",prescno,phaomid),-1) q:(phaomid="")||(exit=1)  d
   .s apptype=$p(^DHCPHORDM(phaomid),"^",9)
   .q:(type'="")&&(apptype'=type)
   .s AuditRefReason=..GetAuditRefReason(phaomid)
   .s:AuditRefReason'="" exit=1
   q $G(AuditRefReason)
}

/// Description:通过医嘱审核ID获取该处方的拒绝原因串
/// Creator: 	hulihua
/// CreateDate: 2017-12-11
/// Table:      DHC_PHAORDMONITOR--医嘱审核主表、DHC_PHAORDMONITORLIST--审核子表
/// Input:		PhaomId-医嘱审核主表ID
/// Output:
/// Return：    该处方的拒绝原因串
/// Others:
/// w ##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).GetAuditRefReason("I17110100015")
ClassMethod GetAuditRefReason(PhaomId As %String) As %String
{
	n (PhaomId)
	q:PhaomId="" ""
	s PhacCh="",ResultStr=""
	f  s PhacCh=$o(^DHCPHORDM(PhaomId,"I",PhacCh)) q:PhacCh=""  d
	.q:'$D(^DHCPHORDM(PhaomId,"I",PhacCh))
	.s AuditReasonDr=$p(^DHCPHORDM(PhaomId,"I",PhacCh),"^",3)
	.q:AuditReasonDr=""
	.s AuditReason=$p($g(^DHCPCREASON(AuditReasonDr)),"^",2)
	.s oeori=$p(^DHCPHORDM(PhaomId,"I",PhacCh),"^",2)
	.s arcimid=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",2)
	.s arcimdesc=$p($g(^ARCIM(+arcimid,1,1)),"^",2)
	.s AuditReasonStr=arcimdesc_":"_AuditReason
	.s ResultStr=$s(ResultStr="":AuditReasonStr,1:ResultStr_","_AuditReasonStr)
	q ResultStr
}

/// Description:通过处方号处理置可退药标志相关的表字段
/// Creator: 	hulihua
/// CreateDate: 2017-12-25
/// Table:      DHC_PHACollected--发药主表
/// Input:		SqlStr-处方号^处理人
/// Output:
/// Return：    0-成功，非0-失败
/// Others:
/// w ##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).SaveAgreeRet("I17122501368^2754^")
ClassMethod SaveAgreeRet(SqlStr As %String) As %String
{
	n (SqlStr)
	s phacId=$p(SqlStr,"^",1)
	q:phacId="" "-1^该处方还未发药或未选中处方!"
	s prescNo=$p($g(^DHCPHAC(phacId,1)),"^",1)
	q:prescNo="" "-2^该处方不是草药处方，请核实!"
	s AgreeUserId=$p(SqlStr,"^",2)
	q:AgreeUserId="" "-3^置可退人为空，请刷新界面后重试!"
	s AgrRetFlag=$p($g(^DHCPHAC(phacId,1)),"^",2)
	q:AgrRetFlag="Y" "-4^该处方已经置为可退，无需再次操作!"
	s AgrRetRemark=$p(SqlStr,"^",3)
	s:AgrRetRemark'="" AgrRetRemark=##class(web.DHCST.Common.JsonObj).GetData(AgrRetRemark)
    s Ret=##class(web.DHCINPHA.HMTrialDrugDisp.SqlDbTrialDrugDisp).SaveAgreeRetData(phacId,AgreeUserId,AgrRetRemark)
	q Ret
}

/// Description:查询拒绝发药列表
/// Creator:	pushaungcai
/// CreateDate:	2017-12-22
/// Table:      DHC_STDRUGREFUSE
/// Input:		开始日期、开始时间、截至日期、截至时间、科室（药房）、病区
/// Output:		TPrescNo(处方号)^TOeori(医嘱明细id)^TDodis(打包表指针)^TAdm^TPatNo^TPatName^TCurBedcode(床号)^TWardDesc^TCurWard
/// Return：	   
/// Others:
/// w ##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).RefuseDrugQuery("20/12/2016^00:00^26/12/2017^23:59^96")	
ClassMethod RefuseDrugQuery(Params As %String)
{
	n (Params)
	q:Params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson() 
	s StartDate=$p(Params,"^",1)
	s EndDate=$p(Params,"^",3)
	s StartTime=$p(Params,"^",2)
	s EndTime=$p(Params,"^",4)
	s Loc=$p(Params,"^",5)
	q:StartDate="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson() 
	q:EndDate="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson() 
	s argWard=$p(Params,"^",6)
	s StartDate=##class(PHA.FACE.IN.Com).DateHtmlToLogical(StartDate)
	s EndDate=##class(PHA.FACE.IN.Com).DateHtmlToLogical(EndDate)
	s StartTime=##class(PHA.FACE.IN.Com).TimeHtmlToLogical(StartTime)
	s EndTime=##class(PHA.FACE.IN.Com).TimeHtmlToLogical(EndTime)
	s Count=0
	s ColNameStr="TReason^TDate^TRefuseName^TPrescNo^TOeori^TDodis^TAdm^TPatNo^TPatName^TCurBedcode^TWardDesc^TCurWard"
	s PrescNo=0
	f  s PrescNo=$o(^STDFi("PRESCNO",PrescNo)) q:PrescNo=""  d
	.s Stdfi=""
	.s Stdfi=$o(^STDFi("PRESCNO",PrescNo,Stdfi),-1)
	.q:Stdfi=""
	.q:'$d(^STDF(Stdfi))
	.s StdfInfo=(^STDF(Stdfi))     //add by qhj 20171229 增加拒绝发药的日期、拒绝人、拒绝原因
	.s StdfDate=$p(StdfInfo,"^",4)
	.s StdfDate=##class(PHA.FACE.IN.Com).DateLogicalToHtml(StdfDate)
	.s StdfTime=$p(StdfInfo,"^",5)
	.s StdfTime=##class(PHA.FACE.IN.Com).TimeLogicalToHtml(StdfTime,"IP")
	.s:StdfDate'="" StdfDate=StdfDate_" "_StdfTime
	.s StdfUserDr=$p(StdfInfo,"^",6)
	.s StdfUser=$p(##class(PHA.COM.Method).GetUserInfoById(StdfUserDr),"^",2)
	.s StdfReasonDr=$p(StdfInfo,"^",7)
	.s ReasonDesc=$p(^DHCRFREASON(StdfReasonDr),"^",2)
	.s Stloc=$p(^STDF(Stdfi),"^",2)
	.q:(Loc'="")&&(Stloc'=Loc)
	.s Date=$p(^STDF(Stdfi),"^",4)
	.q:Date<StartDate
	.q:Date>EndDate
	.s PrescNo=$p(^STDF(Stdfi),"^",3)
	.q:PrescNo=""
	.s Oeori=$p(^STDF(Stdfi),"^",1) 
	.s Dodis=$p(^STDF(Stdfi),"^",8)
	.s STime=$p(^STDF(Stdfi),"^",5)
	.q:(StartDate=Date)&&(StartTime'="")&&(STime<StartTime)
	.q:(EndDate=Date)&&(EndTime'="")&&(STime>EndTime)
	.s Adm=$p(^DHCOEDISQTY(Dodis),"^",26)
	.s CurWard=$p(^PAADM(Adm),"^",70) i CurWard'="" s WardDesc=$p(^PAWARD(+CurWard),"^",2)
	.s Wardlocatin=$p(^PAWARD(+CurWard),"^",5)
	.q:(argWard'="")&&(Wardlocatin'=argWard)
	.s PatInfo=##class(PHA.COM.Order).GetPatInfo(Adm)
	.s PatNo=$p(PatInfo,"^",1)
	.s PatName=$p(PatInfo,"^",3)
	.s CurBedcode=$p(PatInfo,"^",13)
	.s OutputData=ReasonDesc_"^"_StdfDate_"^"_StdfUser_"^"_PrescNo_"^"_Oeori_"^"_Dodis_"^"_Adm_"^"_PatNo_"^"_PatName_"^"_CurBedcode_"^"_$g(WardDesc)_"^"_CurWard 
	.s Count=Count+1
	.I Count=1 d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetJsonStartString(999)
	..W ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(ColNameStr,OutputData)
	.e  d
	..W ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(ColNameStr,OutputData)
	q:Count=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(0) 
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign()
	q ""
}

/// Description:获取库存不足或者批次不可用的药品用于前台提示
/// Creator:	hulihua
/// CreateDate:	2018-04-18
/// Table:      
/// Input:		
/// Output:		
/// Return：	   
/// Others:
/// Debug:		w ##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).GetNoQtyItmDesc()	
ClassMethod GetNoQtyItmDesc() As %String
{
	Q $G(^TMP("DHCINPHA","web.DHCSTPCHCOLLS","DispensingByBatch"))
}

}
