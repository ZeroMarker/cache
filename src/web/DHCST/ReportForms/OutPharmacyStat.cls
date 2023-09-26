/// Description:门诊药房相关类报表
/// Creator:    hulihua
/// CreateDate: 2018-07-11
/// Table:
Class web.DHCST.ReportForms.OutPharmacyStat Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", ProcedureBlock ]
{

/// Description: 统计门诊、急诊相关数据：处方日期，诊断名称，性别，年龄，处方金额  
/// Creator: zhangwei
/// CreateDate: 2017-12-25
/// Table:      
/// Input:开始日期，结束日期
/// Output:处方日期-，诊断名称，性别，年龄，处方金额
/// Return：    
/// Others :
Query Serch(StartDate As %String = "", EndDate As %String = "", yflocdr As %String = "") As websys.Query(ROWSPEC = "fydate:%String,money:%String,papsex:%String,perold:%String,yflocdr:%String,LOCDesc:%String,diagnodesc:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.OutPharmacyStat","Serch","2018-11-01","2018-11-16","308")
ClassMethod SerchExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", yflocdr As %String = "") As %Status
{
	s StartDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(StartDate)
	s EndDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(EndDate)
	s yflocdr=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(yflocdr)
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	q:(StartDate="")||(EndDate="") $$$OK
	s startdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s enddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	f fydate=startdate:1:enddate d
	.s LOCDesc=$p(^CTLOC(yflocdr),"^",2)
	.s phl=$o(^DHCPHLOCi("LOC",yflocdr,""))
	.q:phl=""
	.s phdispid=""
    .f  s phdispid=$o(^DHCPHDISPi("FYDATE",fydate,phl,phdispid)) q:phdispid=""  d
	..s fyFlag=$p(^DHCPHDISP(phdispid),"^",4)
	..s prescno=$p(^DHCPHDISP(phdispid,2),"^",1)
	..q:fyFlag'=1
	..s Flag=1
	..;
	..s PrescAtm=0
	..s dispsub=""
	..f  s dispsub=$o(^DHCPHDI(phdispid,"PHDI",dispsub)) q:(dispsub="")  d
	...s phdclb=""
	...f  s phdclb=$o(^DHCPHDI(phdispid,"PHDI",dispsub,"INCLB",phdclb)) q:(phdclb="")  d
	....s qty=$p(^DHCPHDI(phdispid,"PHDI",dispsub,"INCLB",phdclb),"^",1)
	....//s qty=$p(^DHCPHDI(phdispid,"PHDI",dispsub),"^",4)
	....s PrescAtm=PrescAtm+$p(^DHCPHDI(phdispid,"PHDI",dispsub,"INCLB",phdclb),"^",8)
	....//s PrescAtm=PrescAtm+$p(^DHCPHDI(phdispid,"PHDI",dispsub),"^",3)
	..s adm=##class(web.DHCOutPhDisp).getadm(prescno)
	..s papmi=$p(^PAADM(adm),"^",1)
	..s papsexdr=+$p(^PAPER(papmi,"ALL"),"^",7)
	..i papsexdr'="" s papsex=$p(^CT("SEX",papsexdr),"^",2)		//性别
	..s perold=##class(PHA.FACE.IN.Com).GetAge(papmi,adm)						//年龄
	..s diagnodesc=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(adm,",","")
    ..s money=PrescAtm
    ..s queid=$o(^PAQUE1(0,"PrescNo",prescno,""))
    ..s quedate=$zd($p(^PAQUE1(0,"PrescNo",prescno,queid),"^",29))	//处方日期
	..d outputrow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outputrow
	s data=$lb($zd(fydate,3),money,papsex,perold,yflocdr,LOCDesc,diagnodesc)
	set ^CacheTemp(repid,ind)=data
	set ind=ind+1
	q
}

/// Creator yangshijie
/// CreatDate 2017-12-04
/// Description 门诊处方排行 取一段时间的处方金额排行和数量排行
/// 
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.OutPharmacyStat","GetParescStat","2018-11-01","2018-11-22")
Query GetParescStat(stdate As %String = "", eddate As %String = "") As websys.Query(ROWSPEC = "index,doc1,amt,doc2,num") [ SqlProc ]
{
}

ClassMethod GetParescStatExecute(ByRef qHandle As %Binary, stdate As %String = "", eddate As %String = "") As %Status
{
	s stdate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(stdate)
	s eddate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(eddate)
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1 
    q:(stdate="")||(eddate="") $$$OK
    s stdate=$p(stdate," ",1)
    s stdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(stdate)
	s eddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(eddate)
	s pid=..NewPid()
	d ..ClearTmp("GetParescStat",pid)
	s fydate=""
	f fydate=stdate:1:eddate d
	.s phl=""
	.f  s phl=$o(^DHCPHDISPi("FYDATE",fydate,phl)) q:phl=""  d 
	..s phd=""
	..f  s phd=$O(^DHCPHDISPi("FYDATE",fydate,phl,phd)) q:phd=""  d 
	...s prescno=$P(^DHCPHDISP(phd,2),"^",1)
	...s ord=$O(^OEORD(0,"PrescNo",prescno,""))
	...s chl=$O(^OEORD(0,"PrescNo",prescno,ord,""))
	...s orduser=+$p($g(^OEORD(ord,"I",chl,7)),"^",1)
	...s docdesc=$p(^SSU("SSUSR",orduser),"^",2)
	...s orddoctco=+$p($g(^OEORD(ord,"I",chl,1)),"^",11)
	...s:orddoctco'=0 docdesc=$p(^CTPCP(orddoctco,1),"^",2)
	...s sub="",totalAmt=0
 	...f  s sub=$O(^DHCPHDI(phd,"PHDI",sub)) q:sub=""  d
 	....s phdclb=""
	....f  s phdclb=$o(^DHCPHDI(phd,"PHDI",sub,"INCLB",phdclb)) q:(phdclb="")  d
	.....s Amt=$p(^DHCPHDI(phd,"PHDI",sub,"INCLB",phdclb),"^",8)
	.....s totalAmt=totalAmt+Amt
 	.....//s Amt=$P(^DHCPHDI(phd,"PHDI",sub),"^",3) 
 	.....//s totalAmt=totalAmt+Amt
	...i '$D(^TMP("DHCOUTPHA",$this,"GetParescStat",pid,"data1",docdesc)) d
	....s ^TMP("DHCOUTPHA",$this,"GetParescStat",pid,"data1",docdesc)=totalAmt_"^"_1
	...e  d
	....s $P(^TMP("DHCOUTPHA",$this,"GetParescStat",pid,"data1",docdesc),"^",1)=$P(^TMP("DHCOUTPHA",$this,"GetParescStat",pid,"data1",docdesc),"^",1)+totalAmt
	....s $P(^TMP("DHCOUTPHA",$this,"GetParescStat",pid,"data1",docdesc),"^",2)=$P(^TMP("DHCOUTPHA",$this,"GetParescStat",pid,"data1",docdesc),"^",2)+1
	...
	..
	.
	s docdesc="",count=0
	f  s docdesc=$O(^TMP("DHCOUTPHA",$this,"GetParescStat",pid,"data1",docdesc)) q:docdesc=""  d
	.s data=^TMP("DHCOUTPHA",$this,"GetParescStat",pid,"data1",docdesc)
	.s totalamt=$P(data,"^",1)
	.s num=$P(data,"^",2)
	.s count=count+1
	.s ^TMP("DHCOUTPHA",$this,"GetParescStat",pid,"AMT",totalamt,count)=docdesc
	.s ^TMP("DHCOUTPHA",$this,"GetParescStat",pid,"NUM",num,count)=docdesc
	s totalamt="",index=0
	f  s totalamt=$o(^TMP("DHCOUTPHA",$this,"GetParescStat",pid,"AMT",totalamt),-1) q:totalamt=""  d
	.s count=""
	.f  s count=$o(^TMP("DHCOUTPHA",$this,"GetParescStat",pid,"AMT",totalamt,count)) q:count=""  d
	..s index=index+1
	..s docdesc=^TMP("DHCOUTPHA",$this,"GetParescStat",pid,"AMT",totalamt,count)
	..s ^TMP("DHCOUTPHA",$this,"GetParescStat",pid,"INDEX",index)=docdesc_"^"_totalamt_"^^"
	
	s num="",index=0
	f  s num=$o(^TMP("DHCOUTPHA",$this,"GetParescStat",pid,"NUM",num),-1) q:num=""  d
	.s count=""
	.f  s count=$o(^TMP("DHCOUTPHA",$this,"GetParescStat",pid,"NUM",num,count)) q:count=""  d
	..s index=index+1
	..s docdesc=^TMP("DHCOUTPHA",$this,"GetParescStat",pid,"NUM",num,count)
	..s $P(^TMP("DHCOUTPHA",$this,"GetParescStat",pid,"INDEX",index),"^",3)=docdesc
	..s $P(^TMP("DHCOUTPHA",$this,"GetParescStat",pid,"INDEX",index),"^",4)=num
	.
	s index=""
	f  s index=$O(^TMP("DHCOUTPHA",$this,"GetParescStat",pid,"INDEX",index)) q:index=""  d
	.s data=^TMP("DHCOUTPHA",$this,"GetParescStat",pid,"INDEX",index)
	.s doc1=$p(data,"^",1)
	.s amt=$p(data,"^",2)
	.i amt<1 s amt=0_amt
	.s doc2=$p(data,"^",3)
	.s num=$p(data,"^",4)
    .d OutRowItm
    d ..ClearTmp("GetParescStat",pid)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowItm
	set Data=$lb(index,doc1,amt,doc2,num) 
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

/// 窗口工作量统计
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.OutPharmacyStat","QueryDispDataStatByWindow","308","2018-11-16","2018-11-16")
Query QueryDispDataStatByWindow(tDisoLocId As %String = "", tStartDate As %String = "", tEndDate As %String = "") As websys.Query(ROWSPEC = "phwdesc:%String,xySpAmt:%Float,xyRpAmt:%Float,zcySpAmt:%Float,zcyRpAmt:%Float,ymSpAmt:%Float,ymRpAmt:%Float,tolSpAmt:%Float,tolRpAmt:%Float,PrescNum:%Float") [ SqlProc ]
{
}

ClassMethod QueryDispDataStatByWindowExecute(ByRef qHandle As %Binary, tDisoLocId As %String = "", tStartDate As %String = "", tEndDate As %String = "") As %Status
{
	s tDisoLocId=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(tDisoLocId)
	s tStartDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(tStartDate)
	s tEndDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(tEndDate)
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    q:(tDisoLocId="")||(tStartDate="")||(tEndDate="") $$$OK 
    s tStartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(tStartDate)
	s tEndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(tEndDate)
    s HospId=$p(^CTLOC(tDisoLocId),"^^",22)
    s DispLocDesc=""
    i tDisoLocId'="" s DispLocDesc=$p(^CTLOC(tDisoLocId),"^",2)
    i DispLocDesc["-" s DispLocDesc=$p(DispLocDesc,"-",2)
    s HospId=""
    i tDisoLocId'="" s HospId=$p($g(^CTLOC(tDisoLocId)),"^",22)
    s pid=..NewPid()
    d ..ClearTmp("QueryDispDataStatByWindow",pid)
    f date=tStartDate:1:tEndDate d
    .s intr=""
    .f  s intr=$o(^DHCINTR(0,"TypeDate","F",date,intr))  q:intr=""  d
    ..s inclb=$p(^DHCINTR(intr),"^",7)
    ..q:inclb=""
    ..s ctloc=$p(^INCI(+inclb,"IL",$p(inclb,"||",2)),"^",1)
    ..q:(tDisoLocId'="")&(ctloc'=tDisoLocId)
    ..s pointer=$p(^DHCINTR(intr),"^",9)
    ..s phdrowid=+pointer
    ..q:phdrowid=""  
    ..s window=$p($g(^DHCPHDISP(phdrowid,1)),"^",4)
    ..q:+window=0
    ..s prescno=$p($g(^DHCPHDISP(phdrowid,2)),"^",1)
    ..q:prescno=""
    ..s SpAmt=+$p(^DHCINTR(intr),"^",8)
    ..s RpAmt=+$p(^DHCINTR(intr),"^",17)
    ..s SpAmt=SpAmt*(-1)
    ..s RpAmt=RpAmt*(-1)
    ..s Inci=+inclb
    ..s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
    ..s ScgDesc=$p(StkGrpInfo,"^",2)
    ..s statflag=0
    ..i (ScgDesc["西药")||(ScgDesc["中成药")||(ScgDesc["疫苗") s statflag=1
    ..i ('$d(^TMP("DHCOUTPHA",$this,"QueryDispDataStatByWindow",pid,"PRESCNO",prescno)))&&(statflag=1) d
    ...s ^TMP("DHCOUTPHA",$this,"QueryDispDataStatByWindow",pid,"WindowPresc",window)=$g(^TMP("DHCOUTPHA",$this,"QueryDispDataStatByWindow",pid,"WindowPresc",window))+1
    ..i $d(^TMP("DHCOUTPHA",$this,"QueryDispDataStatByWindow",pid,"Window",window,ScgDesc)) d
    ...s $p(^TMP("DHCOUTPHA",$this,"QueryDispDataStatByWindow",pid,"Window",window,ScgDesc),"^",1)=+$p(^TMP("DHCOUTPHA",$this,"QueryDispDataStatByWindow",pid,"Window",window,ScgDesc),"^",1)+SpAmt
    ...s $p(^TMP("DHCOUTPHA",$this,"QueryDispDataStatByWindow",pid,"Window",window,ScgDesc),"^",2)=+$p(^TMP("DHCOUTPHA",$this,"QueryDispDataStatByWindow",pid,"Window",window,ScgDesc),"^",2)+RpAmt
    ..e  d
    ...s ^TMP("DHCOUTPHA",$this,"QueryDispDataStatByWindow",pid,"Window",window,ScgDesc)=SpAmt_"^"_RpAmt
	..s ^TMP("DHCOUTPHA",$this,"QueryDispDataStatByWindow",pid,"PRESCNO",prescno)=""
	
    s phw=""
    f  s phw=$o(^TMP("DHCOUTPHA",$this,"QueryDispDataStatByWindow",pid,"Window",phw)) q:phw=""  d
    .s phwdesc=$p($g(^DHCPHWIN(phw)),"^",1)
    .s xySpAmt=$p($g(^TMP("DHCOUTPHA",$this,"QueryDispDataStatByWindow",pid,"Window",phw,"西药")),"^",1)  //西药售价金额
    .s xyRpAmt=$p($g(^TMP("DHCOUTPHA",$this,"QueryDispDataStatByWindow",pid,"Window",phw,"西药")),"^",2)  //西药进价金额
    .s zcySpAmt=$p($g(^TMP("DHCOUTPHA",$this,"QueryDispDataStatByWindow",pid,"Window",phw,"中成药")),"^",1)  //中成药售价金额
    .s zcyRpAmt=$p($g(^TMP("DHCOUTPHA",$this,"QueryDispDataStatByWindow",pid,"Window",phw,"中成药")),"^",2)  //中成药进价金额
    .s ymSpAmt=$p($g(^TMP("DHCOUTPHA",$this,"QueryDispDataStatByWindow",pid,"Window",phw,"疫苗")),"^",1)  //疫苗药售价金额
    .s ymRpAmt=$p($g(^TMP("DHCOUTPHA",$this,"QueryDispDataStatByWindow",pid,"Window",phw,"疫苗")),"^",2)  //疫苗药进价金额
    .s PrescNum=$g(^TMP("DHCOUTPHA",$this,"QueryDispDataStatByWindow",pid,"WindowPresc",phw))
	.s tolSpAmt=xySpAmt+zcySpAmt+ymSpAmt
	.s tolRpAmt=xyRpAmt+zcyRpAmt+ymRpAmt
	.d OutRowItm
	d ..ClearTmp("QueryDispDataStatByWindow",pid)
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutRowItm
    set Data=$lb(phwdesc,xySpAmt,xyRpAmt,zcySpAmt,zcyRpAmt,ymSpAmt,ymRpAmt,tolSpAmt,tolRpAmt,PrescNum)    
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

/// w ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.OutPharmacyStat","QueryOutPhOweStatData","2019-10-12","2019-10-12","243")
Query QueryOutPhOweStatData(tStartDate As %String = "", tEndDate As %String = "", LocId As %String = "") As websys.Query(ROWSPEC = "inci:%String,incidesc:%String,bUomDr:%String,bUomDesc:%String,sp:%Float,qty:%Float,spamt:%Float") [ SqlProc ]
{
}

ClassMethod QueryOutPhOweStatDataExecute(ByRef qHandle As %Binary, tStartDate = "", tEndDate = "", LocId = "") As %Status
{
	s tStartDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(tStartDate)
	s tEndDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(tEndDate)
	s LocId=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(LocId)
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    q:(tStartDate="")||(tEndDate="")||(LocId="") $$$OK
    s tStartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(tStartDate)
	s tEndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(tEndDate)
    s HospId=$p(^CTLOC(LocId),"^",22)
    s pid=..NewPid()
    d ..ClearTmp("QueryOutPhOweStatData",pid,"INCI")
    f dd=tStartDate:1:tEndDate d
    .s phowid=""
    .f  s phowid=$o(^DHCPHOWi(0,"DATELOC",dd,LocId,phowid)) q:phowid=""  d
    ..s phowstatus=$p(^DHCPHOW(phowid),"^",8)
    ..q:phowstatus'="" 
    ..s retdate=$p(^DHCPHOW(phowid),"^",10)
    ..q:retdate'=""
    ..s phosub=""
    ..f  s phosub=$o(^DHCPHOWEI(phowid,"I",phosub)) q:phosub=""  d
    ...s qty=$p(^DHCPHOWEI(phowid,"I",phosub),"^",2)
    ...s sp=$p(^DHCPHOWEI(phowid,"I",phosub),"^",3)
    ...s sp=##class(web.DHCST.Common.AppCommon).FormatSp(sp,HospId,2)
    ...s spamt=qty*sp
    ...s spamt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(spamt,HospId)
    ...s oeori=$p(^DHCPHOWEI(phowid,"I",phosub),"^",1)
    ...q:oeori=""
    ...s ord=$p(oeori,"||",1),itm=$p(oeori,"||",2)
	...q:ord=""
	...q:'$d(^OEORD(ord))
	...q:'$d(^OEORD(ord,"I",itm))
    ...s oestatusdr=$p(^OEORD(ord,"I",itm,1),"^",13)
    ...q:oestatusdr=""
    ...s OeStatus=$p($g(^OEC("OSTAT",oestatusdr)),"^",1)
    ...q:(OeStatus'="V")&(OeStatus'="E")
    ...s arcim=$p(^OEORD(ord,"I",itm,1),"^",2)
    ...q:arcim=""
    ...s inci=""
    ...s inci=$o(^INCI(0,"ARCIM_DR",$p(arcim,"||",1),inci))
    ...q:inci=""
    ...s incidesc=$p(^INCI(inci,1),"^",2)
    ...s bUomDr=$p(^INCI(inci,1),"^",10)
    ...s bUomDesc=$p(^CT("UOM",bUomDr),"^",2)
    ...i $d(^TMP("DHCOUTPHA",$this,"QueryOutPhOweStatData",pid,"INCI",inci)) d
    ....s $p(^TMP("DHCOUTPHA",$this,"QueryOutPhOweStatData",pid,"INCI",inci),"^",4)=+$p(^TMP("DHCOUTPHA",$this,"QueryOutPhOweStatData",pid,"INCI",inci),"^",4)+sp
    ....s $p(^TMP("DHCOUTPHA",$this,"QueryOutPhOweStatData",pid,"INCI",inci),"^",5)=+$p(^TMP("DHCOUTPHA",$this,"QueryOutPhOweStatData",pid,"INCI",inci),"^",5)+qty
    ....s $p(^TMP("DHCOUTPHA",$this,"QueryOutPhOweStatData",pid,"INCI",inci),"^",6)=+$p(^TMP("DHCOUTPHA",$this,"QueryOutPhOweStatData",pid,"INCI",inci),"^",6)+spamt
    ...e  d
    ....s ^TMP("DHCOUTPHA",$this,"QueryOutPhOweStatData",pid,"INCI",inci)=incidesc_"^"_bUomDr_"^"_bUomDesc_"^"_sp_"^"_qty_"^"_spamt
    ..
    .
    s inci=""
    f  s inci=$o(^TMP("DHCOUTPHA",$this,"QueryOutPhOweStatData",pid,"INCI",inci)) q:inci=""  d
    .s ret=^TMP("DHCOUTPHA",$this,"QueryOutPhOweStatData",pid,"INCI",inci)
    .s incidesc=$p(ret,"^",1)
    .s bUomDr=$p(ret,"^",2)
    .s bUomDesc=$p(ret,"^",3)
    .s sp=$p(ret,"^",4)
    .s qty=$p(ret,"^",5)
    .s spamt=$p(ret,"^",6)
    .d OutRowItm
    d ..ClearTmp("QueryOutPhOweStatData",pid,"INCI")
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowItm
	set Data=$lb(inci,incidesc,bUomDr,bUomDesc,sp,qty,spamt)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

/// d ##class(%ResultSet).RunQuery("web.DHCOutPhOweList","QueryOutPhOweStatDetailData","2017-12-01","2017-12-06",90,14)
Query QueryOutPhOweStatDetailData(tStartDate As %String = "", tEndDate As %String = "", LocId As %String = "", tInci As %String = "") As websys.Query(ROWSPEC = "pano:%String,patsex:%String,patname:%String,patsex:%String,prescno:%String,inci:%String,incidesc:%String,bUomDr:%String,bUomDesc:%String,sp:%Float,qty:%Float,spamt:%Float,owedate:%String,owetime:%String") [ SqlProc ]
{
}

ClassMethod QueryOutPhOweStatDetailDataExecute(ByRef qHandle As %Binary, tStartDate As %String = "", tEndDate As %String = "", LocId As %String = "", tInci As %String = "") As %Status
{
	s tStartDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(tStartDate)
	s tEndDate=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(tEndDate)
	s LocId=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(LocId)
	s tInci=##class(web.DHCST.ReportForms.ReportCommon).FmtInput(tInci)
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    q:(tStartDate="")||(tEndDate="")||(LocId="")||(tInci="") $$$OK
    s tStartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(tStartDate)
	s tEndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(tEndDate)
    s HospId=$p(^CTLOC(LocId),"^",22)
    f dd=tStartDate:1:tEndDate d
    .s phowid=""
    .f  s phowid=$o(^DHCPHOWi(0,"DATELOC",dd,LocId,phowid)) q:phowid=""  d
    ..s phowstatus=$p(^DHCPHOW(phowid),"^",8)
    ..q:phowstatus'="" 
    ..s retdate=$p(^DHCPHOW(phowid),"^",10)
    ..s prescno=$p(^DHCPHOW(phowid),"^",6)
    ..q:retdate'=""
    ..s owedate=$zd(dd,3)
    ..s owetime=$p(^DHCPHOW(phowid),"^",4)
    ..i owetime'="" s owetime=$zt(owetime)
    ..s phosub=""
    ..f  s phosub=$o(^DHCPHOW(phowid,"I",phosub)) q:phosub=""  d
    ...s oeori=$p(^DHCPHOW(phowid,"I",phosub),"^",1)
    ...q:oeori=""
    ...s ord=$p(oeori,"||",1)
    ...s itm=$p(oeori,"||",2)
    ...q:ord=""
	...q:'$d(^OEORD(ord))
	...q:'$d(^OEORD(ord,"I",itm))
    ...s adm=$p(^OEORD(ord),"^",1)
    ...q:adm=""
    ...s papmi=$p(^PAADM(adm),"^",1)
    ...q:papmi=""
    ...s arcim=$p(^OEORD(ord,"I",itm,1),"^",2)
    ...q:arcim=""
    ...s inci=""
    ...s inci=$o(^INCI(0,"ARCIM_DR",$p(arcim,"||",1),inci))
    ...q:inci=""
    ...q:inci'=tInci
    ...s pano=$p(^PAPER(papmi,"PAT",1),"^",2)
    ...s patname=$p(^PAPER(papmi,"ALL"),"^",1)
    ...s sexdr=$p(^PAPER(papmi,"ALL"),"^",7)
    ...s patsex=$p(^CT("SEX",sexdr),"^",2)
    ...s qty=$p(^DHCPHOW(phowid,"I",phosub),"^",2)
    ...s sp=$p(^DHCPHOW(phowid,"I",phosub),"^",3)
    ...s sp=##class(web.DHCST.Common.AppCommon).FormatSp(sp,HospId,2)
    ...s spamt=qty*sp
    ...s spamt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(spamt,HospId)
    ...s oestatusdr=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",13)
    ...q:oestatusdr=""
    ...s OeStatus=$p($g(^OEC("OSTAT",oestatusdr)),"^",1)
    ...q:(OeStatus'="V")&(OeStatus'="E")
    ...s incidesc=$p(^INCI(inci,1),"^",2)
    ...s bUomDr=$p(^INCI(inci,1),"^",10)
    ...s bUomDesc=$p(^CT("UOM",bUomDr),"^",2)
    ...d OutRowDetailItm
    ..
    .
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowDetailItm
	set Data=$lb(pano,patsex,patname,patsex,prescno,inci,incidesc,bUomDr,bUomDesc,sp,qty,spamt,owedate,owetime)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

/// -------yangsj----2019-10-28 ----报表内容集中整理------Start-------//////
/// Descript: 龙川中医单张处方金额排名前30位的门诊医生
/// Creater: hezhigang
/// CreateDate: 2019-07-25
/// Table: DHC_INTRANS
/// Input: 开始日期，结束日期
/// Output: 
/// 
/// Return：
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.OutPharmacyStat","DispOnePrescNoAmt","2019-11-13","2019-11-13")
Query DispOnePrescNoAmt(StartDate As %String = "", EndDate As %String = "", HospId As %String = "") As websys.Query(ROWSPEC = "prescNo:%String,docdesc:%String,docctdesc:%String,ypid:%String,dosage:%String,qty:%String,sp:%Float,SpAmt:%Float,totalAmt:%Float") [ SqlProc ]
{
}

ClassMethod DispOnePrescNoAmtExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", HospId As %String = "") As %Status
{
	//s ^tmphzg("DispOnePrescNoAmt")=$lb(StartDate,EndDate)
	//n (qHandle,StartDate,EndDate)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s pid=..NewPid()
	i (StartDate="")||(EndDate="") q $$$OK
	s ind=1
	s stdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s eddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	f fydate=stdate:1:eddate d
	.s phl=""
	.f  s phl=$o(^DHCPHDISPi("FYDATE",fydate,phl)) q:phl=""  d 
	..s phLocDr=$p(^DHCPHLOC(phl),"^",1)
	..s hospDr=$p(^CTLOC(phLocDr),"^",22)
	..q:(HospId'="")&&(hospDr'="")&&(hospDr'=HospId)
	..s phd=""
	..f  s phd=$O(^DHCPHDISPi("FYDATE",fydate,phl,phd)) q:phd=""  d 
	...s prescno=$P(^DHCPHDISP(phd,2),"^",1) //处方号
	...s sub=""
 	...f  s sub=$O(^DHCPHDI(phd,"PHDI",sub)) q:sub=""  d
 	....s orditm=$p(^DHCPHDI(phd,"PHDI",sub),"^",5)
 	....s ord=+orditm
 	....s chl=$p(orditm,"||",2)
 	....s orduser=+$p($g(^OEORD(ord,"I",chl,7)),"^",1) 
	....s docdesc=$p(^SSU("SSUSR",orduser),"^",2) //医生
	....s orddoctco=+$p($g(^OEORD(ord,"I",chl,7)),"^",2)
	....s:orddoctco'=0 docctdesc=$p(^CTLOC(orddoctco),"^",2) //就诊科室
	....s oeoriDate=$p($g(^OEORD(ord,"I",chl,3)),"^",7)

	....//s dosage=$p(^OEORD(ord,"I",chl,2),"^",1) ;用药剂量
    ....//s dosageuomdr=$p(^OEORD(ord,"I",chl,2),"^",3)
    ....//s dosageuom=""
    ....//s:dosageuomdr'="" dosageuom=$p(^CT("UOM",dosageuomdr),"^",2) ;剂量单位
    ....//s dosage=dosage_dosageuom
    ....s dosage=##class(web.DHCSTCOMMONORDER).OeoriDosage(orditm)
    ....s admId=$p(^OEORD(ord),"^",1)
    ....s papmi=$p(^PAADM(admId),"^",1)
	....s PatName=$p(^PAPER(+papmi,"ALL"),"^",1)
 	....s phdclb=""
	....f  s phdclb=$o(^DHCPHDI(phd,"PHDI",sub,"INCLB",phdclb)) q:(phdclb="")  d
	.....q:'$d(^DHCPHDI(phd,"PHDI",sub,"INCLB",phdclb))
	.....s SpAmt=$p(^DHCPHDI(phd,"PHDI",sub,"INCLB",phdclb),"^",8) //售价
	.....s inclb=$p(^DHCPHDI(phd,"PHDI",sub,"INCLB",phdclb),"^",3) //批号
	.....s sp=$p(^DHCPHDI(phd,"PHDI",sub,"INCLB",phdclb),"^",7) //单价
	.....s dispQty=+$p(^DHCPHDI(phd,"PHDI",sub,"INCLB",phdclb),"^",1) //发药批次数量
	.....s retQty=+$p(^DHCPHDI(phd,"PHDI",sub,"INCLB",phdclb),"^",2)  //退药数量
	.....s qty=dispQty-retQty
	.....q:qty=0
	.....i (retQty'=0) d
	......///通过发药批次表id获取退药表的退药金额 
	......s PHDIC=phd_"||"_sub_"||"_phdclb
	......s phret="",retamt=0
	......f  s phret=$O(^DHCPHRTIi("PHDICDR",PHDIC,phret)) q:phret=""  d
	.......s phreti=""
	.......f  s phreti=$O(^DHCPHRTIi("PHDICDR",PHDIC,phret,phreti)) q:phreti=""  d
	........s retamt=retamt+$P(^DHCPHRTI(phret,"RTI",phreti),"^",1)
	......s SpAmt=SpAmt-retamt
	.....//s ypid=##class(web.DHCST.Common.DrugInfoCommon).Getypid(+inclb) ///将原项目上的品种码改成incidesc
	.....//q:ypid=""
	.....s ypid=$P(^INCI(+inclb,1),"^",2)
	.....s buom=$P(^INCI(+inclb,1),"^",10)
	.....s buomdesc=$P(^CT("UOM",buom),"^",2)
    .....q:ypid=0
	.....;s docpat=orduser_"^"_papmi //同一天，同一个医生，同一个患者，一个药品码是一条数据
	.....s index=ypid
	.....i $d(^TMP("DHCST",$this,"DispOnePrescNoAmt","docpat",pid,oeoriDate,orduser,papmi,index)) d
	......s $p(^TMP("DHCST",$this,"DispOnePrescNoAmt","docpat",pid,oeoriDate,orduser,papmi,index),"^",8)=+$p(^TMP("DHCST",$this,"DispOnePrescNoAmt","docpat",pid,oeoriDate,orduser,papmi,index),"^",8)+SpAmt
	......s $p(^TMP("DHCST",$this,"DispOnePrescNoAmt","docpat",pid,oeoriDate,orduser,papmi,index),"^",6)=+$p(^TMP("DHCST",$this,"DispOnePrescNoAmt","docpat",pid,oeoriDate,orduser,papmi,index),"^",6)+qty
	......///串联处方号
	......//s tmpprescno=$p(^TMP("DHCST",$this,"DispOnePrescNoAmt","docpat",pid,oeoriDate,orduser,papmi,ypid),"^",1)
	......//i (" "_tmpprescno_" ")'[(" "_prescno_"") s $p(^TMP("DHCST",$this,"DispOnePrescNoAmt","docpat",pid,oeoriDate,orduser,papmi,ypid),"^",1)=$p(^TMP("DHCST",$this,"DispOnePrescNoAmt","docpat",pid,oeoriDate,orduser,papmi,ypid),"^",1)_" "_prescno
	.....e  d
	......s ^TMP("DHCST",$this,"DispOnePrescNoAmt","docpat",pid,oeoriDate,orduser,papmi,index)=prescno_"^"_docdesc_"^"_docctdesc_"^"_ypid_"^"_dosage_"^"_qty_"^"_sp_"^"_SpAmt_"^"_buomdesc
	
	.....i '$d(^TMP("DHCST",$this,"DispOnePrescNoAmt","papmi",pid,oeoriDate,orduser,papmi)) d
	......s ^TMP("DHCST",$this,"DispOnePrescNoAmt","papmi",pid,oeoriDate,orduser,papmi)=prescno
	.....e  d
	......//s prescno=^TMP("DHCST",$this,"DispOnePrescNoAmt","papmi",pid,oeoriDate,orduser,papmi)
	......s tmpprescno=^TMP("DHCST",$this,"DispOnePrescNoAmt","papmi",pid,oeoriDate,orduser,papmi)
	......i (" "_tmpprescno_" ")'[(" "_prescno_"") s ^TMP("DHCST",$this,"DispOnePrescNoAmt","papmi",pid,oeoriDate,orduser,papmi)=^TMP("DHCST",$this,"DispOnePrescNoAmt","papmi",pid,oeoriDate,orduser,papmi)_" "_prescno
	
	
	s oeoriDate=""
	f  s oeoriDate=$o(^TMP("DHCST",$this,"DispOnePrescNoAmt","docpat",pid,oeoriDate)) q:oeoriDate=""  d
	.s orduser=""
	.f  s orduser=$o(^TMP("DHCST",$this,"DispOnePrescNoAmt","docpat",pid,oeoriDate,orduser)) q:orduser=""  d
	..s papmi=""
	..f  s papmi=$o(^TMP("DHCST",$this,"DispOnePrescNoAmt","docpat",pid,oeoriDate,orduser,papmi)) q:papmi=""  d
	...s ypid=""
	...f  s ypid=$o(^TMP("DHCST",$this,"DispOnePrescNoAmt","docpat",pid,oeoriDate,orduser,papmi,ypid)) q:ypid=""  d
	....s dataStr=^(ypid)
	....s prescno=^TMP("DHCST",$this,"DispOnePrescNoAmt","papmi",pid,oeoriDate,orduser,papmi) //$p(dataStr,"^",1)
	....s totalAmt=$p(dataStr,"^",8)
	....i $d(^TMP("DHCST",$this,"DispOnePrescNoAmt","Amt",pid,prescno,ypid)) d
	.....s $p(^TMP("DHCST",$this,"DispOnePrescNoAmt","Amt",pid,prescno,ypid),"^",9)=+$p(^TMP("DHCST",$this,"DispOnePrescNoAmt","Amt",pid,prescno,ypid),"^",9)+totalAmt
	....e  d
	.....s ^TMP("DHCST",$this,"DispOnePrescNoAmt","Amt",pid,prescno,ypid)=dataStr_"^"_totalAmt
	
	....i $d(^TMP("DHCST",$this,"DispOnePrescNoAmt","Prescno",pid,prescno)) d
	.....s $p(^TMP("DHCST",$this,"DispOnePrescNoAmt","Prescno",pid,prescno),"^",1)=+$p(^TMP("DHCST",$this,"DispOnePrescNoAmt","Prescno",pid,prescno),"^",1)+totalAmt
	....e  d
	.....s ^TMP("DHCST",$this,"DispOnePrescNoAmt","Prescno",pid,prescno)=totalAmt
	
	
	s prescno=""
	f  s prescno=$o(^TMP("DHCST",$this,"DispOnePrescNoAmt","Prescno",pid,prescno)) q:prescno=""  d
	.s totalAmt=^TMP("DHCST",$this,"DispOnePrescNoAmt","Prescno",pid,prescno)
	.s ^TMP("DHCST",$this,"DispOnePrescNoAmt","PrescnoAmt",pid,totalAmt,prescno)=totalAmt
	
	s totalAmt="",num=1
	f  s totalAmt=$o(^TMP("DHCST",$this,"DispOnePrescNoAmt","PrescnoAmt",pid,totalAmt),-1) q:totalAmt=""  d
	.s prescno=""
	.f  s prescno=$o(^TMP("DHCST",$this,"DispOnePrescNoAmt","PrescnoAmt",pid,totalAmt,prescno)) q:(prescno="")||(num>30)  d 
	..s num=num+1
	..s ypid=""
	..f  s ypid=$o(^TMP("DHCST",$this,"DispOnePrescNoAmt","Amt",pid,prescno,ypid)) q:ypid=""  d
	...s dataStr=^(ypid)
	...s docdesc=$p(dataStr,"^",2),docctdesc=$p(dataStr,"^",3),incidesc=$p(dataStr,"^",4)
	...s dosage=$p(dataStr,"^",5),qty=$p(dataStr,"^",6),sp=$p(dataStr,"^",7),SpAmt=$p(dataStr,"^",8),buom=$p(dataStr,"^",9) 
 	...s allData=$lb(prescno,docdesc,docctdesc,incidesc,dosage,qty_buom,sp,SpAmt,totalAmt)
	...s ^CacheTemp(repid,ind)=allData    
	...s ind=ind+1
	s qHandle=$lb(0,repid,0)
	k ^TMP("DHCST",$this,"DispOnePrescNoAmt","docpat",pid)
	k ^TMP("DHCST",$this,"DispOnePrescNoAmt","Amt",pid)
	k ^TMP("DHCST",$this,"DispOnePrescNoAmt","PrescnoAmt",pid)
	k ^TMP("DHCST",$this,"DispOnePrescNoAmt","Prescno",pid)
	k ^TMP("DHCST",$this,"DispOnePrescNoAmt","papmi",pid)
	q $$$OK
}

/// Descript:	全院使用金额排名前三十位品种及每个品种使用前三的医生(龙川中医)
/// Creater:	hezhigang
/// CreateDate:	2019-08-21
/// Table:      DHC_INTRANS
/// Input:      开始日期，结束日期
/// Output:     ypid  医生
/// 
/// Return：
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.OutPharmacyStat","AllDrugUsingAmtDoc","","")
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.OutPharmacyStat","AllDrugUsingAmtDoc","2019-10-01","2019-11-01")
Query AllDrugUsingAmtDoc(StartDate As %String = "", EndDate As %String = "", HospId As %String = "") As websys.Query(ROWSPEC = "ypid:%String,num:%String,doctor:%String,doclocdesc:%String,Amt:%Float,qty:%String,sp:%Float,drgpzm:%String") [ SqlProc ]
{
}

ClassMethod AllDrugUsingAmtDocExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", HospId As %String = "") As %Status
{
	//s ^YSJTMP("AllDrugUsingAmtDocExecute")=$LB(StartDate,EndDate)
	//n (qHandle,StartDate,EndDate)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s pid=..NewPid()
	i (StartDate="")||(EndDate="") q $$$OK
	s ind=1
	s stdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s eddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s range="P^F^Y^H^HC"
	s cnt=$l(range,"^")
	f i=1:1:cnt d
 	.s flag=$p(range,"^",i)
 	.f date=stdate:1:eddate d
 	..s intrid=""
 	..f  s intrid=$o(^DHCINTR(0,"TypeDate",flag,date,intrid)) q:intrid=""  d
 	...s inci=$p(^DHCINTR(intrid),"^",15)   //INC_Itm id
	...s scdescstr=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)  //类组代码^类组描述^类组类型
 	...s sctype=$p(scdescstr,"^",3)
 	...q:sctype'="G"     //过滤非药品
 	...//s ypid=##class(web.DHCST.Common.DrugInfoCommon).Getypid(inci)
 	...s ypid=$P(^INCI(inci,1),"^",2)  ///将原项目上的品种码改成incidesc
 	...q:ypid=""
 	...s inclb=$p(^DHCINTR(intrid),"^",7)
 	...s dispLocDr=$$LOC^ST01(inclb)
 	...s hospDr=$p(^CTLOC(dispLocDr),"^",22)
 	...q:(HospId'="")&&(hospDr'="")&&(hospDr'=HospId)
	...s Pointer=$p(^DHCINTR(intrid),"^",9)
	...s intrType=$p(^DHCINTR(intrid),"^",1)
	...s amt=$p(^DHCINTR(intrid),"^",8)
	...s amt=-amt
	...s qty=$p(^DHCINTR(intrid),"^",6)
	...s qty=qty*(-1)
	...s sp=$p(^DHCINTR(intrid),"^",14)
	...//s drgpzm=##class(web.DHCST.Common.DrugInfoCommon).GetPZM(inci)  //品种码
	...s drgpzm=inci		///将原项目上的品种码改成inci
	...i intrType="P" d       ;住院发药
    ....q:'$d(^DHCPHAC(+Pointer))
    ....s OrdItm=$p($G(^DHCPHAC(+Pointer,"I",$p(Pointer,"||",2))),"^",7)
    	
 	...i intrType="Y"        ;住院退药
 	....q:'$d(^PHARET(+Pointer))
    ....s OrdItm=$p($G(^PHARET(+Pointer,"I",$p(Pointer,"||",2))),"^",1)
    	
 	...i intrType="F" d       ;门诊发药
    ....q:'$d(^DHCPHDISP(+Pointer))
    ....s PrescNo=$p($G(^DHCPHDISP(+Pointer,2)),"^",1)
    ....q:PrescNo=""
    ....s OrdItm=$p(^DHCPHDI(+Pointer,"PHDI",$p(Pointer,"||",2)),"^",5)
 	
 	...i intrType="H" d       ;门诊退药
    ....q:'$d(^DHCPHRET(+Pointer))
    ....s OrdItm=$p($g(^DHCPHRTI(+Pointer,"RTI",$p(Pointer,"||",2))),"^",2)
    
    ...q:OrdItm=""
    ...s ord=$p(OrdItm,"||",1)
    ...s chl=$p(OrdItm,"||",2)
    ...s doctordr=+$p($g(^OEORD(ord,"I",chl,7)),"^",1)        
	...s doctor=$p(^SSU("SSUSR",doctordr),"^",2)             //医生
	...s doclocdr=+$p($g(^OEORD(ord,"I",chl,7)),"^",2)
	...s:doclocdr'="" doclocdesc=$p(^CTLOC(doclocdr),"^",2) //就诊科室
	
	...i $d(^TMP("DHCST",$this,"AllDrugUsingAmtDoc","ypid",pid,ypid)) d
	....s $p(^TMP("DHCST",$this,"AllDrugUsingAmtDoc","ypid",pid,ypid),"^",4)=+$p(^TMP("DHCST",$this,"AllDrugUsingAmtDoc","ypid",pid,ypid),"^",4)+amt
	....s $p(^TMP("DHCST",$this,"AllDrugUsingAmtDoc","ypid",pid,ypid),"^",5)=+$p(^TMP("DHCST",$this,"AllDrugUsingAmtDoc","ypid",pid,ypid),"^",5)+qty
	...e  d
	....s ^TMP("DHCST",$this,"AllDrugUsingAmtDoc","ypid",pid,ypid)=ypid_"^"_doctor_"^"_doclocdesc_"^"_amt_"^"_qty_"^"_sp_"^"_drgpzm
	
	...i $d(^TMP("DHCST",$this,"AllDrugUsingAmtDoc","doctor",pid,ypid,doctordr)) d
	....s $p(^TMP("DHCST",$this,"AllDrugUsingAmtDoc","doctor",pid,ypid,doctordr),"^",4)=+$p(^TMP("DHCST",$this,"AllDrugUsingAmtDoc","doctor",pid,ypid,doctordr),"^",4)+amt
	...e  d
	....s ^TMP("DHCST",$this,"AllDrugUsingAmtDoc","doctor",pid,ypid,doctordr)=ypid_"^"_doctor_"^"_doclocdesc_"^"_amt
	
	//单个药品金额排名
	s ypid=""
	f  s ypid=$o(^TMP("DHCST",$this,"AllDrugUsingAmtDoc","ypid",pid,ypid))  q:ypid=""  d
	.s amt=$p(^TMP("DHCST",$this,"AllDrugUsingAmtDoc","ypid",pid,ypid),"^",4)
	.s ^TMP("DHCST",$this,"AllDrugUsingAmtDoc","Amtypid",pid,amt,ypid)=^TMP("DHCST",$this,"AllDrugUsingAmtDoc","ypid",pid,ypid)
	
	//医生金额排名
	s ypid=""
	f  s ypid=$o(^TMP("DHCST",$this,"AllDrugUsingAmtDoc","doctor",pid,ypid)) q:ypid=""  d
	.s doctordr=""
	.f  s doctordr=$o(^TMP("DHCST",$this,"AllDrugUsingAmtDoc","doctor",pid,ypid,doctordr)) q:doctordr=""  d
	..s amt=$p(^TMP("DHCST",$this,"AllDrugUsingAmtDoc","doctor",pid,ypid,doctordr),"^",4)
	..s ^TMP("DHCST",$this,"AllDrugUsingAmtDoc","Amtdoc",pid,ypid,amt,doctordr)=^TMP("DHCST",$this,"AllDrugUsingAmtDoc","doctor",pid,ypid,doctordr)
	
	s amt="",n=1
	f  s amt=$o(^TMP("DHCST",$this,"AllDrugUsingAmtDoc","Amtypid",pid,amt),-1) q:amt=""  d
	.s ypid=""
	.f  s ypid=$o(^TMP("DHCST",$this,"AllDrugUsingAmtDoc","Amtypid",pid,amt,ypid)) q:(ypid="")||(n>30)  d
	..s n=n+1
	..s amt1="",m=1
	..f  s amt1=$o(^TMP("DHCST",$this,"AllDrugUsingAmtDoc","Amtdoc",pid,ypid,amt1),-1) q:amt1=""  d
	...s doctordr=""
	...f  s doctordr=$o(^TMP("DHCST",$this,"AllDrugUsingAmtDoc","Amtdoc",pid,ypid,amt1,doctordr)) q:(doctordr="")||(m>3)   d
	....s m=m+1
	....s data=^TMP("DHCST",$this,"AllDrugUsingAmtDoc","Amtdoc",pid,ypid,amt1,doctordr)
	....s data2=^TMP("DHCST",$this,"AllDrugUsingAmtDoc","ypid",pid,ypid)
	....s doctor=$p(data,"^",2)
	....s doclocdesc=$p(data,"^",3)
	....s Amt=$p(data,"^",4)
	....s qty=$p(data2,"^",5)
	....s sp=$p(data2,"^",6)
	....s drgpzm=$p(data2,"^",7)
	....s allData=$lb(ypid,m-1,doctor,doclocdesc,Amt,qty,sp,drgpzm)
	....s ^CacheTemp(repid,ind)=allData    
	....s ind=ind+1
	s qHandle=$lb(0,repid,0)
	k ^TMP("DHCST",$this,"AllDrugUsingAmtDoc","ypiddoc",pid)
	k ^TMP("DHCST",$this,"AllDrugUsingAmtDoc","Amtypid",pid)
	k ^TMP("DHCST",$this,"AllDrugUsingAmtDoc","Amtdoc",pid)
	k ^TMP("DHCST",$this,"AllDrugUsingAmtDoc","doctor",pid)
	k ^TMP("DHCST",$this,"AllDrugUsingAmtDoc","ypid",pid)
	q $$$OK
}

/// Description：门诊处方数量统计
/// Creator:     pushuangcai
/// CreateDate:  2018-11-02
/// Input:       开始日期、截至日期、药房科室ID
/// Output:      DoctorCode:医师编码,Doctor:医师姓名,DocLoc:医生科室,PrescNo:处方号,OrdNum:品种数,SpAMt:售价金额,
/// 			 PhLocDesc:药房,AntiFlag:抗菌药标志,AntiAmt:抗菌药金额,factor:剂数,facAmt:每剂金额,fydate:发药日期
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.OutPharmacyStat","OutPhPrescStat","2019-09-04","2019-10-22","904")
Query OutPhPrescStat(StartDate As %String = "", EndDate As %String = "", PhaLoc As %String = "", HospId As %String = "") As websys.Query(ROWSPEC = "DoctorCode:%String,Doctor:%String,DocLoc:%String,PrescNo:%String,OrdNum:%Numeric,SpAMt:%Float,PhLocDesc:%String,AntiFlag:%String,AntiAmt:%Float,factor:%Integer,facAmt:%Float,fydate:%String") [ SqlProc ]
{
}

ClassMethod OutPhPrescStatExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", PhaLoc As %String = "", HospId As %String = "") As %Status
{
	
	//s ^YSJTMP("OutPhPrescStatExecute")=$LB(StartDate,EndDate,PhaLoc)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    q:(StartDate="")||(EndDate="") $$$OK
    s StDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EnDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s Pid=..NewPid()
	k ^TMP("DHCST",$this,"OutPhPrescStat",Pid)
	f Date=StDate:1:EnDate d
	.s Phl="" 
	.f  s Phl=$o(^DHCPHDISPi("FYDATE",Date,Phl)) q:Phl=""  d 
	..s PhLoc=$p(^DHCPHLOC(Phl),"^",1)
	..q:(PhaLoc'="")&&(PhLoc'=PhaLoc)
	..s hospDr=$p($g(^CTLOC(+PhLoc)),"^",22)
 	..q:(HospId'="")&&(hospDr'="")&&(hospDr'=HospId)
	..s PhdID=""
	..f  s PhdID=$o(^DHCPHDISPi("FYDATE",Date,Phl,PhdID)) q:PhdID=""  d
	...s fyFlag=$p(^DHCPHDISP(PhdID),"^",4)
	...q:fyFlag'=1
	...s PrescNo=$p(^DHCPHDISP(PhdID,2),"^",1)
	...s ^TMP("DHCST",$this,"OutPhPrescStat",Pid,"PrescNo",PrescNo)=PhLoc
	
	// 获取草药处方发药数据(门诊)
	s admTypeStr = "O^E"
	s activeFlag = "Y"
	s dispDictCode = "Dispen"	// 草药发药流程代码
	s dispDictId = +##class(PHA.HERB.Com.Method).GetDictId(dispDictCode)
	for Date = StDate: 1: EnDate {
		s phaLocId = ""
		for {
			s phaLocId = $o(^BS.PHA.HERB.DISPENI("DateLocTypeState", Date, phaLocId))
			q:(phaLocId = "")
			continue:(PhaLoc '= "")&&(phaLocId '= PhaLoc)
			s phLocId = +$o(^DHCPHLOCi("LOC", phaLocId, ""))
			for num = 1: 1: $l(admTypeStr, "^"){
				s admType = $p(admTypeStr, "^", num)
				s phbdId = ""
				for {
					s phbdId = $o(^BS.PHA.HERB.DISPENI("DateLocTypeState", Date, phaLocId, admType, activeFlag, dispDictId, phbdId))
					q:(phbdId = "")
					s phbdData = $g(^BS.PHA.HERB.DISPEND(phbdId))
					continue:(phbdData = "")
					s prescNo = $lg(phbdData, 4)
					s ^TMP("DHCST", $this, "OutPhPrescStat", Pid, "PrescNo", prescNo) = phLocId
				}
			} 
		}
	}


	
	s PrescNo=""
	f  s PrescNo=$o(^TMP("DHCST",$this,"OutPhPrescStat",Pid,"PrescNo",PrescNo)) q:PrescNo=""  d
	.s PhLoc=$p(^TMP("DHCST",$this,"OutPhPrescStat",Pid,"PrescNo",PrescNo),"^",1)
	.s PhLocDesc=$p($g(^CTLOC(PhLoc)),"^",2)
	.s Ord=$o(^OEORD(0,"PrescNo",PrescNo,""),-1)
	.q:Ord=""
	.s Itm=$o(^OEORD(0,"PrescNo",PrescNo,Ord,""),-1)
	.q:Itm=""
	.q:'$d(^OEORD(Ord))
	.q:'$d(^OEORD(Ord,"I",Itm))
	.s queId = +##class(PHA.HERB.Com.Method).PrescCYQueId(PrescNo)
	.s adm=$p(^OEORD(Ord),"^",1)	 
	.s papmi=$p(^PAADM(adm),"^",1)	  
	.s patno=$p(^PAPER(papmi,"PAT",1),"^",2)
	.s pname=$p(^PAPER(papmi,"ALL"),"^",1)
	.s DoctorCode="",Doctor="",DocLoc=""
	.s DocLocdr=$p(^OEORD(Ord,"I",Itm,1),"^",3)
	.s DocLoc=$p(^CTLOC(DocLocdr),"^",2)
	.s DoctorDr=$p($g(^OEORD(Ord,"I",Itm,1)),"^",11) ;医师
    .i DoctorDr'="" s Doctor=$p($g(^CTPCP(DoctorDr,1)),"^",2)
    .s OeoriDate=$p($g(^OEORD(Ord,"I",Itm,3)),"^",7)
    .//s:DoctorDr'="" MedUmDesc=$p(..GetResMedUnitCareProv(DoctorDr,OeoriDate),"^",2)
    .//s:$g(MedUmDesc)'="" DocLoc=MedUmDesc
    .i DoctorDr'="" s UserDr=$p(^CTPCP(DoctorDr,3),"^",24)
    .i DoctorDr'="" s UserDr=$o(^SSU("SSUSR",0,"CTPCP",DoctorDr,""))
    .i UserDr'="" s DoctorCode=$p(^SSU("SSUSR",UserDr),"^",1)
	.i (queId = 0) d
    ..s OrdNumAndAmt=..GetPrescNum(PrescNo)		// 医嘱数^处方金额^是否抗菌药处方
	..s PhdID=+$o(^DHCPHDISPi("PRESCNO",PrescNo,""))
	..s phl=$p($g(^DHCPHDISP(PhdID,1)),"^",1)
	..s fyDate=$p($g(^DHCPHDISP(PhdID)),"^",3)
	..s fyDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(fyDate)
	..s fyTime=$p($g(^DHCPHDISP(PhdID)),"^",5)
	..s fyTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(fyTime)
	.e  d 
	..s OrdNumAndAmt = ..GetHerbPrescNum(PrescNo)
	..s herbFYInfo = ##class(PHA.HERB.Com.Data).GetPrescFYInfo(PrescNo)
	..s phl = PhLoc
	..s fyDate = $p(herbFYInfo, "^", 3)
	..s fyTime = $p(herbFYInfo, "^", 4)
	..
	.s OrdNum=$p(OrdNumAndAmt,"^",1)
	.q:OrdNum<1
	.s SpAMt=$p(OrdNumAndAmt,"^",2)
	.s AntiFlag=$p(OrdNumAndAmt,"^",3)
	.s AntiAmt=$p(OrdNumAndAmt,"^",4)
	.s factor=+##class(web.DHCOutPhCommon).GetQueFactor(PrescNo,phl)
	.s:factor=0 factor=1 
	.s facAmt=(SpAMt/factor)
	.s fydate=fyDate_" "_fyTime
	.s Data=$lb(DoctorCode,Doctor,DocLoc,PrescNo,OrdNum,SpAMt,PhLocDesc,AntiFlag,AntiAmt,factor,facAmt,fydate) 
	.S ^CacheTemp(repid,ind)=Data
	.S ind=ind+1
	k ^TMP("DHCST",$this,"OutPhPrescStat",Pid)
	Set QHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Description：门诊处方数量统计按照人次 
/// Creator:     hulihua
/// CreateDate:  2019-06-25
/// Table:
/// Input:       开始日期、截至日期、就诊类型
/// Output:		 就诊科室、人次、处方归类、处方数、草药付数
/// Return:
/// Others:		 患者一次就诊有3张西药处方、2张草药处方，则西药跟草药各统计1次      
/// Debug:		 d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.OutPharmacyStat","PresCountByAdm","2019-10-01","2019-11-21","")
Query PresCountByAdm(StartDate As %String = "", EndDate As %String = "", AdmType As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "DocLoc:%String,admnum:%Integer,StkCat:%String,NumQty:%Integer,Factor:%Integer") [ SqlProc ]
{
}

ClassMethod PresCountByAdmExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", AdmType As %String = "", HOSPID As %String = "") As %Status
{
	//s ^YSJTMP("PresCountByAdmExecute")=$LB(StartDate,EndDate,AdmType)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    q:(StartDate="")||(EndDate="") $$$OK
    s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s Pid=..NewPid()
	d ..ClearTmp("OutPhPrescStatByAdm",Pid)
	s typeStr="F^FH"
	s typel=$l(typeStr,"^")
	f idate=StartDate:1:EndDate d
	.f itype=1:1:typel d
	..s type=$p(typeStr,"^",itype)
	..s intrRowId="" 
	..f  s intrRowId=$o(^DHCINTR(0, "TypeDate", type, idate, intrRowId))  q:intrRowId=""  d
	...s dhcIntrData=^DHCINTR(intrRowId)
	...s inclb=$p(^DHCINTR(intrRowId),"^",7)
	...q:inclb=""
	...s tmploc=$P(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
	...q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤
	...s inci = $p(dhcIntrData,"^",15) //获取库存项id
	...s pointer = $p(dhcIntrData,"^",9)
	...s oeori=##class(web.DHCST.ReportForms.ReportCommon).GetOeoriByTans(pointer,type)
	...q:oeori=""
	...s Ord=+oeori,Itm=$P(oeori,"||",2)
	...q:Ord=""
	...q:'$d(^OEORD(Ord))
	...q:'$d(^OEORD(Ord,"I",Itm))
	...s paadm=$p(^OEORD(Ord),"^",1)
	...s admtype=$p(^PAADM(paadm),"^",2)   //就诊类型
	...q:(AdmType'="")&&(admtype'=AdmType) 
	...s PrescNo=##class(web.DHCST.ReportForms.ReportCommon).GetPrescNo(pointer,type)
	...q:PrescNo=""
	...s Inci=+inclb
	...s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	...s StkGrpDesc=$p(StkGrpInfo,"^",2)
	...s Factor=$s(StkGrpDesc["草药":+$p(##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(PrescNo),"^",2),1:0)  ///此处用 "草药"来判断草药参数固定，不妥也没法 yangsj 2019-11-18
	...s DocLocdr=$p(^OEORD(Ord,"I",Itm,1),"^",3)
	...s DocLoc=$p(^CTLOC(DocLocdr),"^",2)
	...s DoctorDr=$p($g(^OEORD(Ord,"I",Itm,1)),"^",11) ;医师
    ...s OeoriDate=$p($g(^OEORD(Ord,"I",Itm,3)),"^",7)
    ...//s:DoctorDr'="" MedUmDesc=$p(..GetResMedUnitCareProv(DoctorDr,OeoriDate),"^",2)
    ...//s:$g(MedUmDesc)'="" DocLoc=MedUmDesc
	...s index=DocLoc_","_paadm_","_StkGrpDesc
	...s ^||TMP("DHCOUTPHA",$this,"OutPhPrescStatByAdm",Pid,"PrescNo",index)=+$G(^||TMP("DHCOUTPHA",$this,"OutPhPrescStatByAdm",Pid,"PrescNo",index))+Factor
	..
	.
	s index="",paadmstr="",admnum=0
	f  s index=$o(^||TMP("DHCOUTPHA",$this,"OutPhPrescStatByAdm",Pid,"PrescNo",index)) q:index=""  d
	.s Factor=$p(^||TMP("DHCOUTPHA",$this,"OutPhPrescStatByAdm",Pid,"PrescNo",index),"^",1)
	.s DocLoc=$p(index,",",1)
	.s paadm=$p(index,",",2)
	.s StkCatDesc=$p(index,",",3)
	
	.i paadmstr'=paadm  s admnum=1
	.s paadmstr=paadm
	.s numqty=1
	.s patindex=DocLoc_","_StkCatDesc
	.i '$d(^||TMP("DHCOUTPHA",$this,"OutPhPrescStatByAdm",Pid,"paadm",patindex)) d
	..s ^||TMP("DHCOUTPHA",$this,"OutPhPrescStatByAdm",Pid,"paadm",patindex)=DocLoc_"^"_admnum_"^"_StkCatDesc_"^"_numqty_"^"_Factor
	.e  d
	..s $p(^||TMP("DHCOUTPHA",$this,"OutPhPrescStatByAdm",Pid,"paadm",patindex),"^",2)=$p(^||TMP("DHCOUTPHA",$this,"OutPhPrescStatByAdm",Pid,"paadm",patindex),"^",2)+admnum
	..s $p(^||TMP("DHCOUTPHA",$this,"OutPhPrescStatByAdm",Pid,"paadm",patindex),"^",4)=$p(^||TMP("DHCOUTPHA",$this,"OutPhPrescStatByAdm",Pid,"paadm",patindex),"^",4)+numqty
	..s $p(^||TMP("DHCOUTPHA",$this,"OutPhPrescStatByAdm",Pid,"paadm",patindex),"^",5)=$p(^||TMP("DHCOUTPHA",$this,"OutPhPrescStatByAdm",Pid,"paadm",patindex),"^",5)+Factor
	.
	s index=""
	f  s index=$o(^||TMP("DHCOUTPHA",$this,"OutPhPrescStatByAdm",Pid,"paadm",index))  q:index=""  d
	.s data=^||TMP("DHCOUTPHA",$this,"OutPhPrescStatByAdm",Pid,"paadm",index)
	.d OutPutData
	d ..ClearTmp("OutPhPrescStatByAdm",Pid)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutData
	set Data=$LISTFROMSTRING(data,"^") 
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

/// //================报表整理====yangsj====2019-10-20======End==================/////////
/// //================报表整理====yangsj====2019-10-31======Start==================/////////
/// Descript: 全院处方金额前三十名分类排序(惠爱门诊)
/// Creator： xuchuwei
/// CreateDate: 2019-02-21
/// Table: DHC_INTRANS
/// Input: StartDate 开始日期, EndDate 截止日期, rank前多少名
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.OutPharmacyStat","QueryAllPrescOut","2020-04-01","2020-04-28","20","")
Query QueryAllPrescOut(StartDate As %String = "", EndDate As %String = "", rank As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "prescno:%String,docloc:%String,doctor:%String,prescnoamt:%Float") [ SqlProc ]
{
}

ClassMethod QueryAllPrescOutExecute(ByRef QHandle As %Binary, StartDate As %String = "", EndDate As %String = "", rank As %String = "", HOSPID As %String = "") As %Status
{
 Set repid=$I(^CacheTemp)
 s ind=1
 Set QHandle=$lb(0,repid,0)
 i StartDate="" q $$$OK
 i EndDate="" q $$$OK
 i rank="" q $$$OK
 s pid=..NewPid()
 k ^TMP("DHCST",$this,"QueryAllPrescOut",pid)
 s nn=0 //只查找前m个
 s m=rank
 s sd=$zdh(StartDate,3)
 s ed=$zdh(EndDate,3) 
 f date=sd:1:ed d
 .s phl=""
 .f  s phl=$o(^DHCPHDISPi("FYDATE",date,phl)) q:phl=""  d
 ..s phctloc=$P(^DHCPHLOC(phl),"^",1)
 ..s tmphos=$P(^CTLOC(phctloc),"^",22)
 ..q:(HOSPID'="")&&(tmphos'="")&&(HOSPID'=tmphos)
 ..s phd=""
 ..f  s phd=$o(^DHCPHDISPi("FYDATE",date,phl,phd)) q:phd=""  d
 ...s prescno=$p(^DHCPHDISP(phd,2),"^",1)
 ...s fyflag=$p(^DHCPHDISP(phd),"^",4)
 ...q:fyflag'="1"
 ...s phdi=$o(^DHCPHDI(phd,"PHDI",""))
 ...s oeori=$p(^DHCPHDI(phd,"PHDI",phdi),"^",5) 
 ...s Ord=$p(oeori,"||",1)
 ...s Chl=$p(oeori,"||",2)
 ...q:Ord=""
 ...q:'$d(^OEORD(Ord))
 ...q:'$d(^OEORD(Ord,"I",Chl))
 ...s docloc=""
 ...i $d(^OEORD(Ord,"I",Chl,1)) d
 ....s ordept=$p(^OEORD(Ord,"I",Chl,1),"^",3)
 ....s docloc=$p(^CTLOC(ordept),"^",2) 
 ...i $f(docloc,"-") s docloc=$P(docloc,"-",2)
 ...s doctor=$p(##class(web.DHCOutPhCommon).GetOrdDoctor(oeori),"^",2)
 ...s prescnoamt=..GetPrescAmt(phd)
 ...i prescnoamt'>0 s prescnoamt=0
 ...;s prescnoamt=$fn(prescnoamt,"",2)
 ...i '$d(^TMP("DHCST",$this,"QueryAllPrescOut",pid,"PrescNo",prescno))  d
 ....s ^TMP("DHCST",$this,"QueryAllPrescOut",pid,"PrescNo",prescno)=prescno_"^"_docloc_"^"_doctor_"^"_prescnoamt
 ...e  d
 ....s $p(^TMP("DHCST",$this,"QueryAllPrescOut",pid,"PrescNo",prescno),"^",4)=prescnoamt+$p(^TMP("DHCST",$this,"QueryAllPrescOut",pid,"PrescNo",prescno),"^",4)
 
 s prescNo=""
 f  s prescNo=$o(^TMP("DHCST",$this,"QueryAllPrescOut",pid,"PrescNo",prescNo)) q:prescNo=""  d
 .s tmpData=^TMP("DHCST",$this,"QueryAllPrescOut",pid,"PrescNo",prescNo)
 .s amtTotal=+$p(tmpData,"^",4)
 .q:amtTotal=0
 .s ^TMP("DHCST",$this,"QueryAllPrescOut",pid,"AmtTotal",amtTotal,prescno)=tmpData
 b
 s amt="",n=0
 f  s amt=$o(^TMP("DHCST",$this,"QueryAllPrescOut",pid,"AmtTotal",amt),-1) q:(amt="")||(n>=m)  d 
 .s prescIndex=""
 .f  s prescIndex=$o(^TMP("DHCST",$this,"QueryAllPrescOut",pid,"AmtTotal",amt,prescIndex)) q:(prescIndex="")||(n>=m)  d
 ..s n=n+1
 ..s data=^TMP("DHCST",$this,"QueryAllPrescOut",pid,"AmtTotal",amt,prescIndex)
 ..s prescno=$p(data,"^",1)
 ..s docloc=$p(data,"^",2)
 ..s doctor=$p(data,"^",3)
 ..s prescnoamt=$p(data,"^",4)
 ..s prescnoamt=$fn(prescnoamt,"",2)
 ..set Data=$lb(prescno,docloc,doctor,prescnoamt)
 ..Set ^CacheTemp(repid,ind)=Data	
 ..Set ind=ind+1
 k ^TMP("DHCST",$this,"QueryAllPrescOut",pid)
 
 Set QHandle=$lb(0,repid,0)
 Quit $$$OK
}

/// Descript: 全院处方金额前三十名处方明细(惠爱门诊)
/// Creator： xuchuwei
/// CreateDate: 2019-02-21
/// Table: DHC_INTRANS
/// Input: StartDate 开始日期, EndDate 截止日期, rank前多少名
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.OutPharmacyStat","QueryPrescDetail","O200424000027")
Query QueryPrescDetail(prescno As %String) As websys.Query(ROWSPEC = "incidesc:%String,qtyuom:%String,doseqtyuom:%String,unitdesc:%String,amt:%Float,price:%Float") [ SqlProc ]
{
}

ClassMethod QueryPrescDetailExecute(ByRef QHandle As %Binary, prescno As %String) As %Status
{

 Set repid=$I(^CacheTemp)
 s ind=1
 i prescno="" Quit $$$OK
 f ix=1:1:$l(prescno,",") d
 .s presc=$p(prescno,",",ix)
 .s phd="" 
 .f  s phd=$o(^DHCPHDISPi("PRESCNO",presc,phd)) q:phd=""  d
 .. 
 ..s phdi=""
 ..f  s phdi=$o(^DHCPHDI(phd,"PHDI",phdi)) q:phdi=""  d
 ...s oeori=$p(^DHCPHDI(phd,"PHDI",phdi),"^",5)
 ...s ord=$p(oeori,"||",1)
 ...s itm=$p(oeori,"||",2)
 ...s doseqty=##class(web.DHCSTCOMMONORDER).OeoriDosage(oeori)
 ...s bsub=""  
 ...f  s bsub=$o(^DHCPHDI(phd,"PHDI",phdi,"INCLB",bsub)) q:bsub=""  d
 ....s dataStr=^DHCPHDI(phd,"PHDI",phdi,"INCLB",bsub)
 ....s price= $p(dataStr,"^",7)
 ....s amt=$p(dataStr,"^",8)
 ....s dispQty=$p(dataStr,"^",1)
 ....s retQty=$p(dataStr,"^",2)
 ....s qty=dispQty-retQty
 ....s amt=qty*price
 ....s inclb=$p(dataStr,"^",3)
 ....s inci=+inclb
 ....s incidesc=$p(^INCI(inci,1),"^",2)
 ....s buom=$p(^INCI(inci,1),"^",10)
 ....s buomdesc=$p($g(^CT("UOM",buom)),"^",2)
 ....s uom=buomdesc
 ....i '$d(ArrPrescDetail("inci",inci)) d
 .....s ArrPrescDetail("inci",inci)=incidesc_"^"_qty_"^"_uom_"^"_doseqty_"^"_""_"^"_amt_"^"_price
 ....e  d
 .....s $p(ArrPrescDetail("inci",inci),"^",2)=qty+$p(ArrPrescDetail("inci",inci),"^",2)
 .....s $p(ArrPrescDetail("inci",inci),"^",6)=amt+$p(ArrPrescDetail("inci",inci),"^",6)

 s inciIndex=""
 f  s inciIndex=$o(ArrPrescDetail("inci",inciIndex)) q:inciIndex=""  d
 .s indexData=ArrPrescDetail("inci",inciIndex)
 .s incidesc=$p(ArrPrescDetail("inci",inciIndex),"^",1)
 .s qty=$p(ArrPrescDetail("inci",inciIndex),"^",2)
 .s uom=$p(ArrPrescDetail("inci",inciIndex),"^",3)
 .s doseqty=$p(ArrPrescDetail("inci",inciIndex),"^",4)
 .s unitdesc=$p(ArrPrescDetail("inci",inciIndex),"^",5)
 .s amt=$p(ArrPrescDetail("inci",inciIndex),"^",6)
 .s price=$p(ArrPrescDetail("inci",inciIndex),"^",7)
 .set Data=$lb(incidesc,qty_uom,doseqty,"",amt,price)
 .Set ^CacheTemp(repid,ind)=Data	
 .Set ind=ind+1 
 Set QHandle=$lb(0,repid,0)
 Quit $$$OK
}

/// Descript:	取处方总金额（除去退药）
/// Creater:	xuchuwei
/// CreateDate:	20190221
/// Input:		phd
/// Others: w ##class(web.DHCST.ReportForms.OutPharmacyStat).GetPrescAmt()
ClassMethod GetPrescAmt(phd)
{
 	q:phd="" "0"
 	q:'$d(^DHCPHDISP(phd)) "0"
 	s amt=0
 	s phdi=""
 	f  s phdi=$o(^DHCPHDI(phd,"PHDI",phdi)) q:phdi=""  d
 	.s phdb=""
 	.f  s phdb=$o(^DHCPHDI(phd,"PHDI",phdi,"INCLB",phdb)) q:phdb=""  d
 	..s data=^DHCPHDI(phd,"PHDI",phdi,"INCLB",phdb)
 	..s qty=$P(data,"^",1)
 	..s retqty=$P(data,"^",2)
 	..s price=$P(data,"^",7)
 	..s amt=amt+((qty-retqty)*price)
 	
 	
 	q amt
}

Query QueryGRetPhHZ(ctloc As %String = "", CDateSt As %String = "", CDateEnd As %String = "", CDepCode As %String, reason As %String = "") As websys.Query(ROWSPEC = "TPhDesc:%String,TPhUom:%String,TRetQty:%Float,TRetMoney:%Float,docLocDesc,doctorName,reasondesc,ctlocdesc") [ SqlProc ]
{
}

/// 新增一个type 参数用来区分统计方式 yangsj 2019-09-10
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.OutPharmacyStat","QueryGRetPhHZ","106","2022-01-01","2022-01-10","","")
ClassMethod QueryGRetPhHZExecute(ByRef QHandle As %Binary, ctloc As %Library.String = "", CDateSt As %Library.String = "", CDateEnd As %Library.String = "", CDepCode As %Library.String = "", reason As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	k QueryGRetPhHZData
	s CDateSt=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateSt)
	s CDateEnd=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(CDateEnd)
	s stdate="",enddate="" 	  
	s stdate=CDateSt
	s enddate=CDateEnd
	i CDateSt="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
	i CDateEnd="" S QHandle=$lb(0,repid,0)	Quit $$$OK  
	s phl=""
	i ctloc=""  S QHandle=$lb(0,repid,0)	Quit $$$OK
	s phl=$o(^DHCPHLOCi("LOC",ctloc,""))
	s ctlocdesc=$P(^CTLOC(ctloc),"^",2)
	i phl=""   S QHandle=$lb(0,repid,0)	Quit $$$OK
	
	s typeStr="H^HC"
	s typeLen=$l(typeStr,"^")
	f typeI=1:1:typeLen  d
	.s type=$p(typeStr,"^",typeI)
	.f date=stdate:1:enddate d
    ..s intrId=""
    ..f  s intrId=$o(^DHCINTR(0,"LOCTYPEDATE",ctloc,type,date,intrId)) q:intrId=""  d
    ...s pointer=$p(^DHCINTR(intrId),"^",9)
    ...q:pointer=""
    ...s retRowId=+pointer
    ...s retSub=$p(pointer,"||",2)
	...s tmpreason=$P(^DHCPHRET(retRowId),"^",13)
	...q:(reason'="")&&(reason'=tmpreason)
	...s reasondesc=$P(^DHCINVOPREFR(tmpreason),"^",2)
	...s prt="",retmoney=0,retuser="",username=""
	...s retSubData=^DHCPHRTI(retRowId,"RTI",retSub)
	...s rmoney=0,retqty=0,retunit="",retoeori=""
	...s rmoney=+$p(^DHCINTR(intrId),"^",8)
	...s retmoney=retmoney+rmoney
	...s retqty=$p(^DHCINTR(intrId),"^",6)
	...s retqty=$p(retqty,$c(1),1)
	...s retunit=$p(^DHCINTR(intrId),"^",10)
	...s retunit=$p(retunit,$c(1),1)
	...s retoeori=$p(retSubData,"^",2)
	...s retinclb=$p(^DHCINTR(intrId),"^",7)
	...s inci=+retinclb
	...s ord=$p(retoeori,"||",1)
	...s itm=$p(retoeori,"||",2)
	...s adm="",ghloc="",ldoctor=""
	...s adm=+$p(^OEORD(ord),"^",1)
	...s ghloc=+$p(^PAADM(adm),"^",4)
	...s ldoctor=+$p(^OEORD(ord,"I",itm,1),"^",11)
	...q:(ghloc'=CDepCode)&(CDepCode'="")
	...s doctorName=$P($g(^CTPCP(ldoctor,1)),"^",2)
	...s docLocDesc=$p(##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).OeoriDocLoc(retoeori),"^",2)
	...s index=retRowId_"^"_retSub   //科室 医生  药品  原因 数量  金额  
	...i '$d(QueryGRetPhHZData(phl,index))  d
	....s $p(QueryGRetPhHZData(phl,index),"^",1)=rmoney
	....s $p(QueryGRetPhHZData(phl,index),"^",2)=retqty
	....s $p(QueryGRetPhHZData(phl,index),"^",3)=retunit
	....s $p(QueryGRetPhHZData(phl,index),"^",4)=inci
	....s $p(QueryGRetPhHZData(phl,index),"^",5)=docLocDesc
	....s $p(QueryGRetPhHZData(phl,index),"^",6)=doctorName
	....s $p(QueryGRetPhHZData(phl,index),"^",7)=reasondesc
	...e  d
	....s $p(QueryGRetPhHZData(phl,index),"^",1)=$p(QueryGRetPhHZData(phl,index),"^",1)+rmoney
	....s $p(QueryGRetPhHZData(phl,index),"^",2)=$p(QueryGRetPhHZData(phl,index),"^",2)+retqty
	
	s index = "",total=0
	f  s index=$o(QueryGRetPhHZData(phl,index)) q:index=""  d
	.s money = 0, qty = 0, unit = "",uomdesc=""
	.s money=$p(QueryGRetPhHZData(phl,index),"^",1)
	.s qty=$p(QueryGRetPhHZData(phl,index),"^",2)
	.q:(qty=0)&&(money=0)
	.s unit=$p(QueryGRetPhHZData(phl,index),"^",3)
	.s inci=$p(QueryGRetPhHZData(phl,index),"^",4)
	.s docLocDesc=$p(QueryGRetPhHZData(phl,index),"^",5)
	.s doctorName=$p(QueryGRetPhHZData(phl,index),"^",6)
	.s reasondesc=$p(QueryGRetPhHZData(phl,index),"^",7)
	.s phdesc=$p(^INCI(inci,1),"^",2)
	.s fmtQtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToOutUomQty(inci,qty)
	.s qty=$p(fmtQtyUomStr,"^",1)
	.s uomId=$p(fmtQtyUomStr,"^",2)
	.s uomDesc=$p($g(^CT("UOM",+uomId)),"^",2)
	.s total=total+money
	.s money=$fn(money,"",2)
	.s iii=0
	.s Data=$lb(phdesc,uomDesc,+qty,+money,docLocDesc,doctorName,reasondesc,ctlocdesc)   
	.S ^CacheTemp(repid,ind)=Data	
	.S ind=ind+1
	S QHandle=$lb(0,repid,0)
	k QueryGRetPhHZData
	Quit $$$OK
}

Query GetCtLocDs(combotext As %String = "", style As %String = "", loctype As %String = "", custtype As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "ctloc,locdesc") [ SqlProc ]
{
}

/// creator:    yangsj
/// createdate: 2019-11-08
/// description:获取科室集合
/// input:		custtype(DocLoc:医生科室)
/// w ##class(web.DHCSTPharmacyCommon).GetCtLocDs("","select2","W","")
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.OutPharmacyStat","GetCtLocDs","","","","")
ClassMethod GetCtLocDsExecute(ByRef QHandle As %Binary, combotext As %String = "", style As %String = "", loctype As %String = "", custtype As %String = "", HOSPID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1

	s h=0
	s ctloc=0
	f  s ctloc=$o(^CTLOC(ctloc)) q:ctloc=""  d
	.s locdesc=$p(^CTLOC(ctloc),"^",2)
	.s tmphos=$p(^CTLOC(ctloc),"^",22)
	.q:(HOSPID'="")&&(HOSPID'=tmphos)
	.s dateTo = $p(^CTLOC(ctloc), "^", 25)
	.q:(dateTo '= "")&&(dateTo <= (+$h))
	.s locConName=$p(^CTLOC(ctloc),"^",43)
	.s quitFlag=""
	.s locType=$p(^CTLOC(ctloc),"^",13)
	.i custtype'="" d
	..i custtype="DocLoc" d
	...i $p(^CTLOC(ctloc),"^",5)="Y" s quitFlag="1" q
	...i locType="D" s quitFlag="1" q
	.e  d
	..s exitflag=##class(web.DHCST.Common.UtilCommon).FindInList(loctype,locType,"$$")
	..s:exitflag=0 quitFlag="1" 
	.q:(loctype'="")&&(quitFlag'="")
	.s matchFlag=""
	.i combotext="" s matchFlag=1
	.i (combotext'="")&&($zcvt(locdesc,"U")[$zcvt(combotext,"U")) s matchFlag=1
	.i (combotext'="")&&($zcvt(locConName,"U")[$zcvt(combotext,"U")) s matchFlag=1
	.q:matchFlag=""
	.i (style["select2")&&(locdesc["-") s locdesc=$p(locdesc,"-",2)
	.q:locdesc=""
	.s Data=$LB(ctloc,locdesc)
	.S ^CacheTemp(repid,ind)=Data	
	.S ind=ind+1
	.S QHandle=$lb(0,repid,0)
	
	Quit $$$OK
}

Query Getinvreson(HOSPID As %String = "") As websys.Query(ROWSPEC = "nvreson,invresondesc") [ SqlProc ]
{
}

/// creator:    yangsj
/// createdate: 2019-11-08
/// description:获取科室集合
/// input:		custtype(DocLoc:医生科室)
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.OutPharmacyStat","Getinvreson")
ClassMethod GetinvresonExecute(ByRef QHandle As %Binary, HOSPID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1


	s invreson=""
	f  s invreson=$O(^DHCINVOPREFR(invreson)) q:invreson=""  d
	.s invresondesc=$P(^DHCINVOPREFR(invreson),"^",2)
	.s HOSPID=##class(PHA.FACE.IN.Com).GetDefHospIdByTableName("Bill_OP_RefInvReason",HOSPID)
	.s hospDr=$p(^DHCINVOPREFR(invreson),"^",3)
	.q:(HOSPID'="")&&(hospDr'="")&&(HOSPID'=hospDr)
	.s Data=$LB(invreson,invresondesc)
	.S ^CacheTemp(repid,ind)=Data	
	.S ind=ind+1
	.S QHandle=$lb(0,repid,0)
	
	Quit $$$OK
}

/// //================报表整理====yangsj====2019-10-31======End==================/////////
/// ////////////////////// ////////////////////// ////////////////////// ///////////////////
/// ///////////////////上面为Query方法,下面为过程函数,请按此规则////////////////////////////
/// ////////////////////// ////////////////////// ////////////////////// ///////////////////
/// Description:新建临时global的计数器
/// Creator:	hulihua
/// CreateDate:	2016-06-05
/// Table:      
/// Input:      
/// Output:		
/// Return：
/// w ##class(web.DHCST.ReportForms.ReportCommon).NewPid()
ClassMethod NewPid() As %String
{
  	Q $I(^DHCOUTPHAPID("DHCOUTPHA",$this))
}

/// Description:Kill临时global的公共方法
/// Creator:	hulihua
/// CreateDate:	2016-06-05
/// Table:      
/// Input:      
/// Output:		
/// Return：
/// w ##class(web.DHCST.ReportForms.ReportCommon).ClearTmp()
ClassMethod ClearTmp(MethodName As %String, pid As %String, PAR As %String = "") As %String
{
	I PAR'="" D
	.K ^TMP("DHCOUTPHA",$this,MethodName,pid,PAR)
	.K ^TEMP("DHCOUTPHA",$this,MethodName,pid,PAR)
	E  D
	.K ^TMP("DHCOUTPHA",$this,MethodName,pid)
	.K ^TEMP("DHCOUTPHA",$this,MethodName,pid)
	Q ""
}

/// 判断库存分类
/// 
/// w ##class(web.DHCST.ReportForms.OutPharmacyStat).GetStkGrp()
ClassMethod GetStkGrp(PhdID)
{
	q:PhdID="" ""
	s TmpStrStkGrp=""
	s Phdi=""
	f  s Phdi=$o(^DHCPHDI(PhdID,"PHDI",Phdi)) q:Phdi=""  d
	.s Oeori=$p(^DHCPHDI(PhdID,"PHDI",Phdi),"^",5)
	.s PhdiClb=$o(^DHCPHDI(PhdID,"PHDI",Phdi,"INCLB",""),-1)
	.q:PhdiClb=""
	.s Inclb=$p(^DHCPHDI(PhdID,"PHDI",Phdi,"INCLB",PhdiClb),"^",3)
	.s Inci=+Inclb
	.s StkGrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	.s StkGrpDesc=$p(StkGrpInfo,"^",2)
	.i TmpStrStkGrp="" s TmpStrStkGrp=StkGrpDesc
	.e  i ("+"_TmpStrStkGrp_"+")'[("+"_StkGrpDesc_"+") s TmpStrStkGrp=TmpStrStkGrp_"+"_StkGrpDesc
	
	q StkGrpDesc
}

/// Description：获取医生所属的医疗单元
/// Creator:     pushuangcai
/// CreateDate:  2018-11-02
/// Input:       医生id, 日期
/// Output:      所属医疗单元代码^描述
/// w ##class(web.DHCST.ReportForms.OutPharmacyStat).GetResMedUnitCareProv("4702",+$h)
ClassMethod GetResMedUnitCareProv(doc, date)
{
	q:doc="" ""
  	s retVal=""
 	s medUnit=0 f  s medUnit=$o(^CTLOC(0,"CTPCP",doc,medUnit)) q:medUnit=""  d
 	.s muChildsub=0
	.f  s muChildsub=$o(^CTLOC(0,"CTPCP",doc,medUnit,"MU",muChildsub)) q:muChildsub=""  d
	..s mucpChildsub=0
	..f  s mucpChildsub=$o(^CTLOC(0,"CTPCP",doc,medUnit,"MU",muChildsub,"CP",mucpChildsub)) q:(mucpChildsub="")!(retVal'="")  d
  	...s mUcpDateF=$p(^CTLOC(medUnit,"MU",muChildsub,"CP",mucpChildsub),"^",5)
  	...s mUcpDateT=$p(^CTLOC(medUnit,"MU",muChildsub,"CP",mucpChildsub),"^",6)
  	...s mUcpDoctDr=$p(^CTLOC(medUnit,"MU",muChildsub,"CP",mucpChildsub),"^",1)
  	...s opFlag=$p(^CTLOC(medUnit,"MU",muChildsub,"CP",mucpChildsub),"^",3)
  	...s ipFlag=$p(^CTLOC(medUnit,"MU",muChildsub,"CP",mucpChildsub),"^",4)
  	...q:date<mUcpDateF
  	...q:(mUcpDateT'="")&(date>mUcpDateT)
  	...s medUnitCode=$p(^CTLOC(medUnit,"MU",muChildsub),"^",1)
  	...s medUnitDesc=$p(^CTLOC(medUnit,"MU",muChildsub),"^",2)
  	...s retVal=medUnitCode_"^"_medUnitDesc
  	q retVal
}

/// Description：计算处方药品品种数、处方金额、是否抗菌药处方、抗菌药金额
/// Creator:     pushuangcai
/// CreateDate:  2018-11-02
/// Input:       处方号
/// Output:      药品品种数^处方金额^是否抗菌药处方^抗菌药金额
/// w ##class(web.DHCST.ReportForms.OutPharmacyStat).GetPrescNum("")
ClassMethod GetPrescNum(PrescNo)
{
	q:PrescNo="" 0
	s PhdID=$o(^DHCPHDISPi("PRESCNO",PrescNo,""))
    q:PhdID="" 0
    s Type="F"
    s OrdNum=0,SpAmt=0,RetAmt=0,Amt=0
    s antiflag="N",antiAmt=0,antiret="N"
	s Phdi=""
	f  s Phdi=$o(^DHCPHDI(PhdID,"PHDI",Phdi)) q:Phdi=""  d
	.s Oeori=$p(^DHCPHDI(PhdID,"PHDI",Phdi),"^",5)
	.q:Oeori=""
	.s OeStatDr=+$p($g(^OEORD(+$p(Oeori,"||",1),"I",+$p(Oeori,"||",2),1)),"^",13)
	.s OeStat=$p($g(^OEC("OSTAT",OeStatDr)),"^",1)
	.q:(OeStat'="E")&&((OeStat'="V"))
	.s arcim=$p($g(^OEORD(+$p(Oeori,"||",1),"I",+$p(Oeori,"||",2),1)),"^",2)
	.s phcdf=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(arcim)
	.s antiflag=##class(web.DHCST.Common.DrugInfoCommon).GetAntiFlagByPhcdf(phcdf)
	.i antiflag="Y" s antiret="Y"
	.s OrdNum=OrdNum+1
	.s phdclb=""
	.f  s phdclb=$o(^DHCPHDI(PhdID,"PHDI",Phdi,"INCLB",phdclb)) q:phdclb=""  d
	..s pointer=PhdID_"||"_Phdi_"||"_phdclb
	..s Intr=+$o(^DHCINTR(0,"TypePointer",Type,pointer,""),-1)
	..s TmpSpAmt=-$p($g(^DHCINTR(Intr)),"^",8)
	..s SpAmt=TmpSpAmt+SpAmt
	..i antiflag="Y" s antiAmt=antiAmt+TmpSpAmt	
	s Amt=SpAmt	
	q OrdNum_"^"_Amt_"^"_antiret_"^"_antiAmt
}

/// Description：计算草药处方药品品种数、处方金额、是否抗菌药处方、抗菌药金额
/// Creator:     MaYuqiang
/// CreateDate:  2023-03-02
/// Input:       处方号
/// Output:      药品品种数^处方金额^是否抗菌药处方^抗菌药金额
/// w ##class(web.DHCST.ReportForms.OutPharmacyStat).GetHerbPrescNum("O230224000168")
ClassMethod GetHerbPrescNum(prescNo) As %String
{
	q:(prescNo = "") 0
	s phbdId = +##class(PHA.HERB.Com.Method).GetPhbdByPresc(prescNo)
    q:(phbdId = 0) 0
    s intrType = "FH"
    s ordNum = 0, spAmt = 0, retAmt = 0, amt = 0
    s antiflag = "N", antiAmt = 0, antiret = "N"
	s phbdItm = ""
	for {
		s phbdItm = $o(^BS.PHA.HERB.DISPEND(phbdId, "I", phbdItm))
		q:(phbdItm = "")
		s phbdItmData = $g(^BS.PHA.HERB.DISPEND(phbdId, "I", phbdItm))
		continue:(phbdItmData = "")
		s oeori = $lg(phbdItmData, 3)
		continue:(oeori = "")
		s oeStatId = +$p($g(^OEORD(+$p(oeori,"||",1), "I", +$p(oeori,"||",2), 1)), "^", 13)
		s oeStatCode = $p($g(^OEC("OSTAT", oeStatId)), "^", 1)
		q:(oeStatCode '= "E")&&((oeStatCode '= "V"))
		s arcim = $p($g(^OEORD(+$p(oeori,"||",1), "I", +$p(oeori,"||",2),1)), "^", 2)
		s phcdf = ##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(arcim)
		s antiflag = ##class(web.DHCST.Common.DrugInfoCommon).GetAntiFlagByPhcdf(phcdf)
		if (antiflag = "Y"){
			s antiret = "Y"
		}
		s ordNum = ordNum + 1
		s phbdic = ""
		for {
			s phbdic = $o(^BS.PHA.HERB.DISPEND(phbdId, "I", phbdItm, "B", phbdic))
			q:(phbdic = "")
			s phbdicId = phbdId _"||"_ phbdItm _"||"_ phbdic
			s intrId = +$o(^DHCINTR(0, "TypePointer", intrType, phbdicId, ""), -1)
			s tmpSpAmt = -$p($g(^DHCINTR(intrId)), "^", 8)
			s spAmt = tmpSpAmt + spAmt
			if (antiflag = "Y"){
				s antiAmt = antiAmt + tmpSpAmt
			} 	
		}
	}
	s amt = spAmt	
	
	q ordNum _"^"_ amt _"^"_ antiret _"^"_ antiAmt
}

}
