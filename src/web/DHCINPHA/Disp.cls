Import sqluser

/// creator:yunhaibao
/// createdate:20160504
/// descirpiton:住院药房发药,查询列表
Class web.DHCINPHA.Disp Extends %RegisteredObject [ ProcedureBlock ]
{

/// creator:yunhaibao
/// createdate:20160504
/// descirpiton:获取住院发药病区列表
/// w ##class(web.DHCINPHA.Disp).jsQueryDispWardList(1,30,"2016-11-20!!00:00!!2016-11-22!!23:59!!98!!!!!!")
ClassMethod jsQueryDispWardList(page, rows, params, style)
{
	q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s page=1
	s rows=1000
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s cellSplit="!!"
	s startDate=$p(params,cellSplit,1)
	s startTime=$p(params,cellSplit,2)
	s endDate=$p(params,cellSplit,3)
	s endTime=$p(params,cellSplit,4)
	s startDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startDate)
	s endDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endDate)
	s startTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(startTime)
	s endTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(endTime)
	s phaLoc=$p(params,cellSplit,5)
	s wardLoc=$p(params,cellSplit,6)
	s locGrpId=$p(params,cellSplit,7) 
	s pri=$p(params,cellSplit,8) 
	s result=##class(web.DHCSTPCHCOLLS5).DispensingWards(phaLoc,startDate,endDate,startTime,endTime,pri)	
	s cnt=$p(result,"^",1)
	s pid=$p(result,"^",2)
	q:cnt=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	s $zt="ErrorjsQueryDispWardList"
	s phaDispTypeStr=##class(web.DHCINPHA.InfoCommon).GetPhaDispType(phaLoc)
	q:phaDispTypeStr="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	s colNameStr="TWardRowid^TWard^"_phaDispTypeStr
	s countward=0
	s WardId=""
	f  s WardId=$o(^TMP(pid,"DISPWARDCATS",WardId)) q:WardId=""  d
	. q:(wardLoc'="")&&(wardLoc'=WardId)
	. q:##class(web.DHCSTCNTSIPMONITOR).CheckWard(locGrpId,WardId)=0 //add wyx 2014-12-08 科室组的过滤
	. &sql(select ward_locationdr into :locdr from pac_ward where ward_rowid=:WardId)
	. q:$g(locdr)="" 
	. s TWard=$p(^CTLOC(locdr),"^",2)
	. s countward=countward+1
	. s dispcat=""
	. f  s dispcat=$o(^TMP(pid,"DISPWARDCATS",WardId,dispcat)) q:dispcat=""  d
	. .s ^TMP(pid,"WARDCATS",TWard,dispcat)=""
	s endpage=countward
	s count=0
	s TWard=""
	f  s TWard=$o(^TMP(pid,"WARDCATS",TWard)) q:TWard=""  d
	.s WardId=$o(^PAWARD(0,"WARD_Desc",$$ALPHAUP^SSUTIL4(TWard),"")) 
	.i TWard["-" s WardDesc=$p(TWard,"-",2)
	.e  s WardDesc=TWard
	.s outputdata=WardId_"^"_WardDesc
	.s collength=$l(colNameStr,"^")
	.s coli=0
	.f coli=3:1:collength d
	..s coldisptype=$p(colNameStr,"^",coli)
	..i $d(^TMP(pid,"WARDCATS",TWard,coldisptype)) d
	...s $p(outputdata,"^",coli)="Y"
	.q:outputdata=""
	.s count=count+1 
	.I count=stpage d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countward)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP(pid,"WARDCATS")
	k ^TMP(pid,"DISPWARDCATS")
	k ^TMP(pid,"WAITOTHER")
	q:count=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	q ""
ErrorjsQueryDispWardList
	k ^TMP("DHCST","web.DHCOUTPHA.Disp","jsQueryDispWardList",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

/// creator:yunhaibao
/// createdate:20160504
/// descirpiton:获取就诊列表
/// params:		登记号^查询类型(DISP:发药)
/// w ##class(web.DHCINPHA.Disp).jsQueryDispAdmList(1,50,"0000002084^DISP")
ClassMethod jsQueryDispAdmList(page, rows, params)
{
	//s ^yunhaibao("jsQueryDispWardList")=page_","_rows_","_params
	q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s page=1
	s rows=1000
	s patNo=$p(params,"^",1)
	q:patNo="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s queryType=$p(params,"^",2)
	s hosp=$p(params,"^",3)
	s papmi=$o(^PAPERi("PAPMI_PatNo",patNo,""))
	q:papmi="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNameStr="Adm^CurrWard^AdmDate^AdmTime^AdmLoc^CurrentBed"
	s count=0
	s adm="" f  s adm=$o(^PAPERdr(papmi,"ADM","I",adm),-1) q:adm=""  d
	. i adm'="" d
	. . s adm=+adm
	. . q:$p(^PAADM(adm),"^",2)'="I"      ; if not inpatient then quit - 20060601
	. . s ord=$o(^OEORD(0,"Adm",adm,""))
	. . q:ord=""
	. . s admstatus=##class(web.DHCSTCOMMONSRV).GetCurrentAdmStatus(adm)
	. . s exitflag=$s(queryType="DISP":1,1:"")
	. . i admstatus="1" s exitflag=""
	. . i (queryType="DISP")&&(admstatus'=1) d ; 发药显示的就诊需要判断计费点是否显示
	. . . s exitflag="1"
	. . . s orditm=""
	. . . f  s orditm=$o(^OEORD(ord,"I",orditm),-1) q:(orditm="")||(exitflag="")  d 
	. . . . q:+orditm=0
	. . . . s oeori=ord_"||"_orditm
	. . . . s pri=$p(^OEORD(ord,"I",orditm,1),"^",8) 
 	. . . . q:pri="" 
 	. . . . s pricode=$p($g(^OECPR(pri)),"^",1)
 	. . . . q:pricode["OM" 							
	. . . . s arcimid=$P(^OEORD(ord,"I",orditm,1),"^",2)
 	. . . . q:arcimid="" 
 	. . . . s arcimm=$p(arcimid,"||",1)
 	. . . . q:arcimm="" 
 	. . . . s arcimsub=$p(arcimid,"||",2)
 	. . . . q:arcimsub="" 
 	. . . . s arcitemcat=$p($g(^ARCIM(arcimm,arcimsub,1)),"^",10)
 	. . . . q:arcitemcat="" 
 	. . . . s arcitmtype=$p($g(^ARC("IC",arcitemcat)),"^",7)
 	. . . . q:arcitmtype'="R" ; 过滤非药品医嘱
 	. . . . s amtflag=##class(web.DHCSTPCHCOLLS2).IfCollectDrugAllowed(adm,arcitemcat_"^"_pricode)
 	. . . . q:amtflag'=1
	. . . . s dsp=""
	. . . . f  s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,dsp),-1) q:(dsp="")||(exitflag="")  d
	. . . . . q:+dsp=0
	. . . . . s dspstatus=$p(^DHCOEDISQTY(dsp),"^",7)
	. . . . . q:dspstatus'="TC"
	. . . . . s oeore=$p(^DHCOEDISQTY(dsp),"^",3)
	. . . . . q:##class(web.DHCSTCOMMONSRV).GetOrdState(oeore)=0 ; 
	. . . . . q:##class(web.DHCSTPCHCOLLS2).HaveBeenRefused(dsp)=1
 	. . . . . s exitflag=""
    . . q:exitflag'=""
	. . s depcodedr=$p(^PAADM(adm),"^",4) i depcodedr'="" s depDesc=$p(^CTLOC(depcodedr),"^",2)
	. . q:(hosp'="")&&(hosp'=$p($g(^CTLOC(+depcodedr)),"^",22))
	. . s admdate=$p(^PAADM(adm),"^",6) i admdate>0 s admdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(admdate,"IP") 
	. . s admtime=$p(^PAADM(adm),"^",7) i admtime>0 s admtime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(admtime,"IP")
	. . s curWard=$p(^PAADM(adm),"^",70) i curWard'="" s curWardDesc=$p(^PAWARD(+curWard),"^",2)
	. . s curBedcode=$p(##class(web.DHCSTCOMMONORDER).GetAdmBedCode(adm),"^",2)
	. . s doctor=$p(^PAADM(adm),"^",9) i +doctor'=0  s doctor=$p(^CTPCP(doctor,1),"^",2 )
	. . i curWardDesc["-" s curWardDesc=$p(curWardDesc,"-",2)
	. . i depDesc["-" s depDesc=$p(depDesc,"-",2)
	. . s outputdata=$g(adm)_"^"_$g(curWardDesc)_"^"_$g(admdate)_"^"_$g(admtime)_"^"_$g(depDesc)_"^"_$g(curBedcode)
	. . s count=count+1
	. . I count=1 d
	. . . w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(999)
	. . . W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	. . e  d
	. . . W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	q:count=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	q ""
}

/// creator:yunhaibao
/// createdate:20160506
/// descirpiton:获取住院药房发药明细列表easyui在用
/// w ##class(web.DHCINPHA.Disp).jsQueryDispList(1,300,"98!!14!!2016-04-24!!2016-05-10!!578!!!!0!!0||NOEmOrd||!!0!!PTFY##655247!!!!!!!!!!!!")
ClassMethod jsQueryDispList(page, rows, params, style = "")
{
	n (%session)
	q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s cellSplit="!!"
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s displocrowid=$p(params,cellSplit,1)
	s wardrowid=$p(params,cellSplit,2)
	s StartDate=$p(params,"!!",3)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=$p(params,cellSplit,4)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s Userid=$p(params,cellSplit,5)
	s ByWardFlag=$p(params,cellSplit,6)
	s LongOrdFlag=$p(params,cellSplit,7)
	s ShortOrdFlag=$p(params,cellSplit,8)
	s OutWithDrugFlag=$p(params,cellSplit,9)
	s DispCat=$p(params,cellSplit,10)
	s Adm=$p(params,cellSplit,11)
	s DoctorLocRowid=$p(params,cellSplit,12)
	s NotAudit=$p(params,cellSplit,13)
	s StartTime=$p(params,cellSplit,14)
	s EndTime=$p(params,cellSplit,15)
	s incirowid=$p(params,cellSplit,16)
	
	s pid=..NewPid() 	
    s $zt="ErrorjsQueryDispList"
    s result=##class(%Library.ResultSet).%New("web.DHCSTPCHCOLLS:CollectDrug")
	s sc=result.Execute(displocrowid,wardrowid,StartDate,EndDate,Userid,ByWardFlag,LongOrdFlag,ShortOrdFlag,OutWithDrugFlag,DispCat,Adm,DoctorLocRowid,NotAudit,StartTime,EndTime,incirowid)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.s colName=result.GetColumnName(i)
	.i colName="Tstr" s Tstrnum=i
	.i colNameStr="" s colNameStr=colName
	.e  s colNameStr=colNameStr_"#"_colName
	s addColNameStr="Tcooktype#Tseqno#TarcEndDate#TarcEndDateFlag#Tbill#TDispIdStr#TColType#TSelect"
	s colNameStr=colNameStr_"#"_addColNameStr
	s countrecords=0
	While(result.Next())
	{ 
		s retdata="",adddata=""
		f i=1:1:colNum d
		.s ret=result.%GetData(i)
		.i i=Tstrnum s adddata=ret
		.i retdata="" d
		..s retdata=ret
		.e  d
		..s retdata=retdata_"#"_ret
		s adddata=$tr(adddata,"^","#")
		s retdata=retdata_"#"_$p(adddata,"#",1,7)_"#"_"Y"
		s countrecords=countrecords+1  //可做索引用
		s ^TMP("DHCST","web.DHCINPHA.Disp","jsQueryDispList",pid,countrecords)=retdata
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCINPHA.Disp","jsQueryDispList",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCINPHA.Disp","jsQueryDispList",pid,outputi)
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..i style="jqGrid" w ##class(web.DHCSTJQUERYCOMMON).getJsonStartStringJqGrid(countrecords,rows)
	..e  w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata,"#")
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata,"#")
	.i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCINPHA.Disp","jsQueryDispList",pid)
	q ""
ErrorjsQueryDispList
	k ^TMP("DHCST","web.DHCINPHA.Disp","jsQueryDispList",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

/// creator:yunhaibao
/// createdate:20160506
/// descirpiton:获取住院药房发药明细列表,easyui在用
/// w ##class(web.DHCINPHA.Disp).jsQueryDispTotalList(1,300,"657911")
ClassMethod jsQueryDispTotalList(page, rows, params)
{
	//s ^yunhaibao("jsQueryDispTotalList")=params_"^"_page_"^"_rows
	q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s disppid=+params
	s pid=..NewPid() 	
    s $zt="ErrorjsQueryDispTotalList"
    s result=##class(%Library.ResultSet).%New("web.DHCSTPCHCOLLS:DispItmTotal")
	s sc=result.Execute(disppid)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.s colName=result.GetColumnName(i)
	.i colNameStr="" s colNameStr=colName
	.e  s colNameStr=colNameStr_"#"_colName
	s countrecords=0
	While(result.Next())
	{ 
		s retdata=""
		f i=1:1:colNum d
		.s ret=result.%GetData(i)
		.i retdata="" d
		..s retdata=ret
		.e  d
		..s retdata=retdata_"#"_ret
		s countrecords=countrecords+1  //可做索引用
		s ^TMP("DHCST","web.DHCINPHA.Disp","jsQueryDispTotalList",pid,countrecords)=retdata
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCINPHA.Disp","jsQueryDispTotalList",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCINPHA.Disp","jsQueryDispTotalList",pid,outputi)
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata,"#")
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata,"#")
	.i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCINPHA.Disp","jsQueryDispTotalList",pid)
	q ""
ErrorjsQueryDispTotalList
	k ^TMP("DHCST","web.DHCINPHA.Disp","jsQueryDispTotalList",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

/// creator:yunhaibao
/// createdate:20160908
/// description:住院发药汇总明细统一入口,json版本
/// others:新建查询,但详细查询调用原来的方法,因控制较多,不再直接引用原query
/// w ##CLASS(web.DHCINPHA.Disp).jsQueryInDisp(1,999,"98!!19!!2016-09-05!!2016-09-09!!578!!!!0!!0||NOEmOrd||!!0!!OUT^PTFY##659960!!!!!!!!00:00!!23:59!!","total","661486","")
ClassMethod jsQueryInDisp(page, rows, params, querytype, ProcessId = "", style = "")
{
	n (%session)
	//s ^hlh($h)=$lb(page, rows, params, querytype, ProcessId,style)	
	q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	s jsQueryInDispPid="INPHA"_..NewPid()
	s cellSplit="!!"
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s displocrowid=$p(params,cellSplit,1)
	s wardrowid=$p(params,cellSplit,2)
	s StartDate=$p(params,"!!",3)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=$p(params,cellSplit,4)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s Userid=$p(params,cellSplit,5)
	s ByWardFlag=$p(params,cellSplit,6)
	s LongOrdFlag=$p(params,cellSplit,7)
	s ShortOrdFlag=$p(params,cellSplit,8)
	s OutWithDrugFlag=$p(params,cellSplit,9)
	s DispCat=$p(params,cellSplit,10)
	s Adm=$p(params,cellSplit,11)
	s DoctorLocRowid=$p(params,cellSplit,12)
	s NotAudit=$p(params,cellSplit,13)
	s StartTime=$p(params,cellSplit,14)
	s EndTime=$p(params,cellSplit,15)
	s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
	s EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
	s incirowid=$p(params,cellSplit,16)
	q:(displocrowid="")||(StartDate="")||(EndDate="") ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)  
	s loclog=%session.Data("LOGON.CTLOCID")
   	i NotAudit="on" s NotAudit=1 
   	e  s NotAudit=0
	;如果出院代药,类别应默认为发药科室的全部类别  LQ
	i OutWithDrugFlag="1"   s DispCat=##class(web.DHCSTPHALOC).GetPhaLocDisType(displocrowid)
	s dhcplrowid=$o(^DHCPL(0,"Loc",displocrowid,""))
	s displayemyflag=""
	i dhcplrowid'="" s displayemyflag=$p(^DHCPL(dhcplrowid),"^",24)
	i ProcessId'="" d
	.i querytype="total" d OutPutTotal
	.i querytype="detail" d OutPutDetail
	q:ProcessId'="" ""
	i Adm="" d  // 按病区发药
	. s PID=##class(web.DHCSTPCHCOLLS).PCHCOLLS(displocrowid,wardrowid,StartDate,EndDate,Userid,LongOrdFlag,ShortOrdFlag,OutWithDrugFlag,DispCat,NotAudit,StartTime,EndTime,incirowid,loclog)
	e  d  //按病人发药
	. s PID=##class(web.DHCSTPCHCOLLS).PCHCOLLADM(displocrowid,Adm,StartDate,EndDate,Userid,LongOrdFlag,ShortOrdFlag,OutWithDrugFlag,DispCat,NotAudit,StartTime,EndTime,incirowid,loclog)
	q:PID="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s ProcessId=PID
	i querytype="total" d OutPutTotal
	i querytype="detail" d OutPutDetail
	//k ^TMP("dhcpha",PID,"DISPD")
	//k ^TMP("DHCST","web.DHCSTPCHCOLLS","PHABILL",PID)
	//k ^TMP("dhcpha",PID,"OEORI")
	q ""
OutPutTotal
	s totalTitle1="TDesc$$TUom$$TDrugForm$$TQty$$TQtyBed$$TSp$$TBarcode$$TManufacture$$TIncstk$$TAmt"
	s totalTitle2="TGeneric$$TPID$$TCollStat"
	s totalTitle=totalTitle1_"$$"_totalTitle2
	s amtTotal=0
	s num=0
	s TmpCat=""
 	f  s TmpCat=$o(^TMP("dhcpha",ProcessId,"DispCat",TmpCat)) q:TmpCat=""  d
 	.s SubStr=""
 	.f  s SubStr=$o(^TMP("dhcpha",ProcessId,"DispCat",TmpCat,SubStr)) q:SubStr=""  d
 	..s AdmDr=$p(SubStr,"^",1)
 	..s OrdItmRowid=$p(SubStr,"^",3)
 	..s DataStr=^TMP("dhcpha",ProcessId,"DispCat",TmpCat,SubStr)
 	..s DspIdStr=$p(DataStr,"^",6)
	..s tmpdspid="",dspquit="",tmpdspidi=0
 	..f tmpdspidi=1:1:$l(DspIdStr,",") d
 	...s tmpdspid=$p(DspIdStr,",",tmpdspidi)
 	...q:'$d(^TMP("dhcpha",ProcessId,"D","Filter",tmpdspid)) ;过滤没有选择的医嘱
 	...s dspquit=1
 	..q:dspquit'=""
 	..s BedNo=$p(DataStr,"^",3)
 	..s:BedNo="" BedNo="*"
 	..s RecLocId=$p(DataStr,"^",9)
 	..s SubInci="" 
 	..f  s SubInci=$o(^TMP("dhcpha",ProcessId,"DispCat",TmpCat,SubStr,SubInci)) q:SubInci=""  d        
	...q:SubInci=""
	...s SubInciData=^TMP("dhcpha",PID,"DispCat",TmpCat,SubStr,SubInci)
	...s InciDesc=$p(SubInciData,"^",1)
	...s Sp=$p(SubInciData,"^",2)
	...s SpAmt=$p(SubInciData,"^",3)
	...s DspQty=$p(SubInciData,"^",4)
	...s Uom=$p(SubInciData,"^",5)
	...s IL=$o(^INCI("IL_LOC",RecLocId,SubInci,"")) 
 	...i IL'=""  d
 	....s Incil=SubInci_"||"_IL
 	....s InciQty=##class(web.DHCSTSTKQTY).GetPhaQty(Incil,DspQty)  ;1,够发，0：不可发 
 	...e  d
 	....s Incil=""
 	....s InciQty=0
 	...i $d(^TMP("DHCST","web.DHCSTPCHCOLLS","PHABILL",ProcessId,AdmDr)) s CollStat="存在欠费"
 	...e  i InciQty=0 s CollStat="库存不足"
 	...e  s CollStat=""
    ...s tmpindex=InciDesc_"||"_SubInci
    ...;计算某个床某药品的发药数量
    ...i $d(^TMP("DHCST","web.DHCINPHA.Disp","jsQueryInDisp",jsQueryInDispPid,"TOTALQTYBED",tmpindex,BedNo)) d
	....s ^TMP("DHCST","web.DHCINPHA.Disp","jsQueryInDisp",jsQueryInDispPid,"TOTALQTYBED",tmpindex,BedNo)=+^TMP("DHCST","web.DHCINPHA.Disp","jsQueryInDisp",jsQueryInDispPid,"TOTALQTYBED",tmpindex,BedNo)+DspQty
	...e   d
	....s ^TMP("DHCST","web.DHCINPHA.Disp","jsQueryInDisp",jsQueryInDispPid,"TOTALQTYBED",tmpindex,BedNo)=DspQty
	...;按药品汇总
	...i $d(^TMP("DHCST","web.DHCINPHA.Disp","jsQueryInDisp",jsQueryInDispPid,"TOTAL",tmpindex)) d
	....s $p(^TMP("DHCST","web.DHCINPHA.Disp","jsQueryInDisp",jsQueryInDispPid,"TOTAL",tmpindex),"^",2)=+$p(^TMP("DHCST","web.DHCINPHA.Disp","jsQueryInDisp",jsQueryInDispPid,"TOTAL",tmpindex),"^",2)+DspQty
	....s $p(^TMP("DHCST","web.DHCINPHA.Disp","jsQueryInDisp",jsQueryInDispPid,"TOTAL",tmpindex),"^",11)=+$p(^TMP("DHCST","web.DHCINPHA.Disp","jsQueryInDisp",jsQueryInDispPid,"TOTAL",tmpindex),"^",11)+SpAmt
	....s tmpCollStat=$p(^TMP("DHCST","web.DHCINPHA.Disp","jsQueryInDisp",jsQueryInDispPid,"TOTAL",tmpindex),"^",12)
	....i CollStat'="" d
	.....i tmpCollStat'["欠费" d
	......s $p(^TMP("DHCST","web.DHCINPHA.Disp","jsQueryInDisp",jsQueryInDispPid,"TOTAL",tmpindex),"^",12)=CollStat
	...e  d
	....s Generic=##class(web.DHCSTCOMMONSRV).getGeneric(SubInci)
	....i $f(Generic,"-") s Generic=$p(Generic,"-",2)
	....s Form=##class(web.DHCSTCOMMONSRV).GetForm(SubInci)
	....s Manf=##class(web.DHCSTITMDESC).GetManfNameByInci(SubInci)
	....s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",SubInci)
	....s StkBin=##class(web.DHCSTCOMMONSRV).getIncStk(Incil) ;货位
	....s qtybed=""
	....s ^TMP("DHCST","web.DHCINPHA.Disp","jsQueryInDisp",jsQueryInDispPid,"TOTAL",tmpindex)=InciDesc_"^"_DspQty_"^"_Uom_"^"_Sp_"^"_qtybed_"^"_Form_"^"_Spec_"^"_Manf_"^"_StkBin_"^"_Generic_"^"_SpAmt_"^"_CollStat
	...
	..
	.
	s countrecords=0
	s tmpindex=""
	f  s tmpindex=$o(^TMP("DHCST","web.DHCINPHA.Disp","jsQueryInDisp",jsQueryInDispPid,"TOTAL",tmpindex)) q:tmpindex=""  d
	.s bedno="" f  s bedno=$o(^TMP("DHCST","web.DHCINPHA.Disp","jsQueryInDisp",jsQueryInDispPid,"TOTALQTYBED",tmpindex,bedno)) q:bedno=""  d
	..s qty=^TMP("DHCST","web.DHCINPHA.Disp","jsQueryInDisp",jsQueryInDispPid,"TOTALQTYBED",tmpindex,bedno)
	..s qtybedno=qty_"/"_bedno
	..i $p(^TMP("DHCST","web.DHCINPHA.Disp","jsQueryInDisp",jsQueryInDispPid,"TOTAL",tmpindex),"^",5)=""  d
	...s $p(^TMP("DHCST","web.DHCINPHA.Disp","jsQueryInDisp",jsQueryInDispPid,"TOTAL",tmpindex),"^",5)=qtybedno
	..e  d
	...s $p(^TMP("DHCST","web.DHCINPHA.Disp","jsQueryInDisp",jsQueryInDispPid,"TOTAL",tmpindex),"^",5)=$p(^TMP("DHCST","web.DHCINPHA.Disp","jsQueryInDisp",jsQueryInDispPid,"TOTAL",tmpindex),"^",5)_" "_qtybedno 
	..s countrecords=countrecords+1
	s count=0
	s tmpindex=""
	f  s tmpindex=$o(^TMP("DHCST","web.DHCINPHA.Disp","jsQueryInDisp",jsQueryInDispPid,"TOTAL",tmpindex)) q:tmpindex=""  d
 	.s result=^TMP("DHCST","web.DHCINPHA.Disp","jsQueryInDisp",jsQueryInDispPid,"TOTAL",tmpindex)
	.s TDesc=$p(result,"^",1)
	.s TQty=$p(result,"^",2)
	.s TUom=$p(result,"^",3)
	.S TSp=$p(result,"^",4)
	.s TSp=##class(web.DHCSTKUTIL).Getprice4(TSp)
	.s TQtyBed=$p(result,"^",5)
	.s TDrugForm=$p(result,"^",6)
	.s TBarcode=$p(result,"^",7)
	.s TManufacture=$p(result,"^",8)
	.s TIncstk=$p(result,"^",9)
	.s TAmt=$p(result,"^",11)
	.s TAmt=##class(web.DHCSTKUTIL).Getprice2(TAmt)
	.s amtTotal=amtTotal+TAmt
	.s TGeneric=$p(result,"^",10)
	.s TCollStat=$p(result,"^",12)
	.s ArcDateStr=##class(web.DHCSTPCHCOLLS).GetArcEndFlag(OrdItmRowid)
    .s ArcFlag=$p(ArcDateStr,"^",1)
	.i ArcFlag<0 s TCollStat="医嘱项</br>截止"
	.s outputdata1=TDesc_"$$"_TUom_"$$"_TDrugForm_"$$"_TQty_"$$"_TQtyBed_"$$"_TSp_"$$"_TBarcode_"$$"_TManufacture_"$$"_TIncstk_"$$"_TAmt
	.s outputdata2=TGeneric_"$$"_ProcessId_"$$"_TCollStat
	.s outputdata=outputdata1_"$$"_outputdata2
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonStartStringJqGrid(countrecords,rows)
	..//e  w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(totalTitle,outputdata,"$$")
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(totalTitle,outputdata,"$$")
	i count>0 w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCINPHA.Disp","jsQueryInDisp",jsQueryInDispPid,"TOTALQTYBED")
	k ^TMP("DHCST","web.DHCINPHA.Disp","jsQueryInDisp",jsQueryInDispPid,"TOTAL")
	i +count=0 w ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	q ""
	
OutPutDetail
	s detailTitle1="TPID$$TInsuType$$TAdmLoc$$TBedNo$$TPaName$$TRegNo$$TDesc$$TQty$$TUom$$TSalePrice"
	s detailTitle2="TOrdStatus$$TPhaCat$$TDoseQty$$TFreq$$TInstruction$$TDuration$$TPrescNo$$TBatchNo$$Toedis$$TAudited"
	s detailTitle3="TGeneric$$TForm$$TBarcode$$TManufacture$$TIncStk$$TAmt$$TUserAdd$$TTimeAdd$$TDiagnose$$TAge"
	s detailTitle4="Taction$$Tsex$$Tstr$$TEncryptLevel$$TPatLevel$$TMainOrd$$TTimeDosing$$TUrgent"
	s detailTitle5="Tcooktype$$Tseqno$$TDispIdStr$$TSelect$$TCollStat"
	s detailTitle=detailTitle1_"$$"_detailTitle2_"$$"_detailTitle3_"$$"_detailTitle4_"$$"_detailTitle5
	s TSelect="Y" //发药明细默认勾选
	s countrecords=0,count=0
 	s TmpCat=""
 	f  s TmpCat=$o(^TMP("dhcpha",ProcessId,"DispCat",TmpCat)) q:TmpCat=""  d
 	.s SubStr=""
 	.f  s SubStr=$o(^TMP("dhcpha",ProcessId,"DispCat",TmpCat,SubStr)) q:SubStr=""  d
 	..s AdmDr=$p(SubStr,"^",1)
 	..s DateDosing=$p(SubStr,"^",2)
 	..s OrdItmRowid=$p(SubStr,"^",3)
 	..s papmidr=$p(^PAADM(AdmDr),"^",1)
 	..S EncryptLevelInfo=""
	..s EncryptLevel=""
	..s PatLevel=""
	..s HospID=""
    ..s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag(HospID)
    ..i EncryptFlag=1 d
 	...s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmidr,"")
 	...s EncryptLevel=$p(EncryptLevelInfo,"^",1)
 	...s PatLevel=$p(EncryptLevelInfo,"^",2)
 	..s DataStr=^TMP("dhcpha",ProcessId,"DispCat",TmpCat,SubStr)
 	..s Prescno=$p(DataStr,"^",1)
 	..s BedId=$p(DataStr,"^",2)
	..s BedNo=$p(DataStr,"^",3)
 	..s OeFlag=$p(DataStr,"^",4)
 	..s:OeFlag="V" OeFlag="核实"
 	..s AdmLoc=$p(DataStr,"^",5)
 	..s AdmLocDesc=$p(^CTLOC(AdmLoc),"^",2) 
 	..s DspIdStr=$p(DataStr,"^",6)
 	..s TimeDosing=$p(DataStr,"^",8)
 	..s RecLocId=$p(DataStr,"^",9)
 	..s DateTime=$p(DataStr,"^",10)
 	..s DateTime=$p(DateTime,",",1)
 	..s OrdInfo=$g(^TMP("dhcpha",ProcessId,"OEORI",OrdItmRowid))
 	..s SeqNo=$p(OrdInfo,"^",1)
	..s ArcimId=$p(OrdInfo,"^",2)                              ;ARCIM_RowId 
	..s PhcdfDr=$p(OrdInfo,"^",3)
	..s IssuType=$p(OrdInfo,"^",4) ;医保类别  
	..s PapmiId=$p(OrdInfo,"^",5) 
	..s PatName=$p(OrdInfo,"^",6) 
	..s PatNo=$p(OrdInfo,"^",7)
	..s ArcimDesc=$p(OrdInfo,"^",8)
	..s UomId=$p(OrdInfo,"^",9)
	..s Uom=$p(OrdInfo,"^",10)
	..s Priorty=$p(OrdInfo,"^",11)   		;医嘱优先级
	..s DoseQty=$p(OrdInfo,"^",12)       						;用药剂量
	..s Freq=$p(OrdInfo,"^",13)     			;用药频率 
	..s Instru=$p(OrdInfo,"^",14)        	;用法
	..s Duration=$p(OrdInfo,"^",15)        	;用药疗程
	..s Batno=$p(OrdInfo,"^",16)       ;发药前不知道
	..s Audited=$p(OrdInfo,"^",17)		;护士审核标志按配药记录走的，按医嘱没法显示
	..s Generic=$p(OrdInfo,"^",18)
	..s Form=$p(OrdInfo,"^",19)
	..s Spec=$p(OrdInfo,"^",20)
	..s Manf=$p(OrdInfo,"^",21)
	..s StkBin=$p(OrdInfo,"^",22) 					;货位
	..s UserAdd=$p(OrdInfo,"^",23)       ;医生
	..s Diagnose=$p(OrdInfo,"^",24)
	..s Age=$p(OrdInfo,"^",25)					;PA_PatMas PAPMI_RowId 
	..s SkinTest=$p(OrdInfo,"^",26) 		;备注(皮试结果)
	..s SexDr=$p(OrdInfo,"^",27)
	..s Sex=$p(OrdInfo,"^",28)
	..s collstat=""
	..s MainOrd=##class(web.DHCSTPCHCOLLS).GetMainOrdRowid(OrdItmRowid) 
    ..s ArcDateStr=##class(web.DHCSTPCHCOLLS).GetArcEndFlag(OrdItmRowid)
    ..s ArcFlag=$p(ArcDateStr,"^",1)
    ..i ArcFlag=-1 d
    ...s ^TMP("dhcpha",ProcessId,"arcEndDate",MainOrd)=""   ;医嘱项到期，,保存数据时用
    ...s collstat="医嘱项</br>截止"
    ..s ArcEndDateFlag=0
    ..s:ArcFlag=-1 ArcEndDateFlag=1							;医嘱项到期
    ..s ArcEndDate=$p(ArcDateStr,"^",2) 
    ..i displayemyflag="Y" s Urgent=$p($g(^OEORD(+OrdItmRowid,"I",$p(OrdItmRowid,"||",2),11)),"^",55) //加急
	..e  s Urgent=""
	..s CookType=##class(web.DHCSTPCHCOLLS).GetCookType(Prescno)     ;草药煎药方式
    ..i ArcEndDate'="" s ArcEndDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ArcEndDate,"IP")
    ..s Bill=""
	..i $d(^TMP("DHCST","web.DHCSTPCHCOLLS","PHABILL",ProcessId,AdmDr)) s Bill="欠费"
	..i Bill="欠费" s collstat="病人欠费"
	..s Str=CookType_"^"_SeqNo_"^"_ArcEndDate_"^"_ArcEndDateFlag_"^"_Bill_"^"_DspIdStr
	..s InciId="" 
 	..f  s InciId=$o(^TMP("dhcpha",ProcessId,"DispCat",TmpCat,SubStr,InciId)) q:InciId=""  d        
	...q:InciId=""
	...s SubInciData=^TMP("dhcpha",ProcessId,"DispCat",TmpCat,SubStr,InciId)
	...s InciDesc=$p(SubInciData,"^",1)
	...s Sp=$p(SubInciData,"^",2)
	...s SpAmt=$p(SubInciData,"^",3)
	...s DspQty=$p(SubInciData,"^",4)
	...s Uom=$p(SubInciData,"^",5)             
	...s IL=$o(^INCI("IL_LOC",RecLocId,InciId,"")) 
 	...i IL'=""  d
 	....s Incil=InciId_"||"_IL
 	....s InciQty=##class(web.DHCSTSTKQTY).GetPhaQty(Incil,DspQty)  ;1,够发，0：不可发 
 	...e  d
 	....s Incil=""
 	....s InciQty=0
    ...
    ...i InciQty=0  s ^TMP("dhcpha",ProcessId,"NoStockOrd",SubStr)="" ;构造库存不足的医嘱项,保存数据时用
    ...s:(collstat="")&&(InciQty=0) collstat="库存不足"
	...s tmpdspid="",TSelect="Y",tmpdspidi=0
 	...f tmpdspidi=1:1:$l(DspIdStr,",") d
 	....s tmpdspid=$p(DspIdStr,",",tmpdspidi)
 	....i $d(^TMP("dhcpha",ProcessId,"D","Filter",tmpdspid)) d ;过滤没有选择的医嘱
 	.....s TSelect="N"
	...s outputdata1=ProcessId_"$$"_IssuType_"$$"_AdmLocDesc_"$$"_BedNo_"$$"_PatName_"$$"_PatNo_"$$"_ArcimDesc_"$$"_DspQty_"$$"_Uom_"$$"_Sp
	...s outputdata2=OeFlag_"$$"_Priorty_"$$"_DoseQty_"$$"_Freq_"$$"_Instru_"$$"_Duration_"$$"_Prescno_"$$"_Batno_"$$"_OrdItmRowid_"$$"_Audited
	...s outputdata3=Generic_"$$"_Form_"$$"_Spec_"$$"_Manf_"$$"_StkBin_"$$"_SpAmt_"$$"_UserAdd_"$$"_DateTime_"$$"_Diagnose_"$$"_Age
	...s outputdata4=SkinTest_"$$"_Sex_"$$"_Str_"$$"_EncryptLevel_"$$"_PatLevel_"$$"_MainOrd_"$$"_TimeDosing_"$$"_Urgent
	...s outputdata5=CookType_"$$"_SeqNo_"$$"_DspIdStr_"$$"_TSelect_"$$"_collstat
	...s outputdata=outputdata1_"$$"_outputdata2_"$$"_outputdata3_"$$"_outputdata4_"$$"_outputdata5
	...s countrecords=countrecords+1
	...s count=count+1
	...q:count<stpage
    ...q:count>endpage
	...I count=stpage d
	....w ##class(web.DHCSTJQUERYCOMMON).getJsonRowSign()
	....W ##class(web.DHCSTJQUERYCOMMON).getJsonData(detailTitle,outputdata,"$$")
	...e  d
	....W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(detailTitle,outputdata,"$$")
	...
	..
	.
	i count>0 d
	.w ##class(web.DHCSTJQUERYCOMMON).getJsonEndStringJqGrid(count,rows)
	e  w ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	q ""
}

// 

ClassMethod KillTmp(pid)
{
	k ^TMP("dhcpha",pid,"DispCat")
	k ^TMP("dhcpha",pid,"arcEndDate")
	k ^TMP("dhcpha",pid,"NoStockOrd")
	k ^TMP("dhcpha",pid,"DISPD")
	k ^TMP("DHCST","web.DHCSTPCHCOLLS","PHABILL",pid)
	k ^TMP("dhcpha",pid,"OEORI")
	k ^TMP("dhcpha",pid,"DispOrdItem")
	k ^TMP("dhcpha",pid,"DISPM")
	k ^TMP("dhcpha",pid,"D","Filter")
	q ""
}

ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($this,"IP")
}

}
