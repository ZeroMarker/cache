/// 名称:     web.DHCLabPanicReportSearch
/// 描述:     危急报告查询
/// 编写者：  huhm
/// 编写日期: 20131008
Class web.DHCLabPanicReportSearch Extends %RegisteredObject
{

//

/// Creator：      huhm
/// CreatDate：    20131009
/// Description:： 查询危急报告
/// Table：        DHC_PanicReport
/// Input：        危急报告日期,科室ID,处理状态(C未完成,F完成),就诊类型(O:门诊,Y:住院,E:急诊),报告类型(1:检验,2病理,3心电,4超声,5内镜,6放射)
/// Output：       
/// Return：        
/// Others：      ##Class(%ResultSet).RunQuery("web.DHCLabPanicReportSearch","GetAllPanicReport","2013-09-12","2014-11-13","16","C","I",2)
/// Others：      ##Class(%ResultSet).RunQuery("web.DHCLabPanicReportSearch","GetAllPanicReport","2013-09-12","2014-11-13","59","C","I",2)
Query GetAllPanicReport(DateFrom As %String, DateTo As %String, LocId As %String, TransStatus As %String, QryType As %String, ReportType As %String) As %Query(ROWSPEC = "ReportId:%String,DebtorNo:%String,PatName:%String,Species:%String,DOB:%String,Age:%String,Location:%String,Doctor:%String,LabEpis:%String,TestSet:%String,MobPhone:%String,ToPerson:%String,TransMemo:%String,TransDT:%String,TransUser:%String,ReportType:%String,Adm:%String")
{
}

//

ClassMethod GetAllPanicReportExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String, LocId As %String, TransStatus As %String, QryType As %String, ReportType As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	If '$Length(DateTo) Set qHandle=$lb(0,repid,0)	 Quit $$$OK
	If '$Length(DateFrom) Set qHandle=$lb(0,repid,0)	 Quit $$$OK
	s DateFrom=$zdh(DateFrom,3),DateTo=$zdh(DateTo,3)
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LabData=Config.LabDataNamespace
	If '$Length(LabData) Set LabData="labdata"
	k ^TMPPANIC($j)
	s ^TMPPANIC($j,1)=DateFrom_","_DateTo_","_QryType_","_LocId_","_TransStatus_","_ReportType
	i '$l(ReportType) s ReportType=1
	//If '$Length(LabEpis) Set qHandle=$lb(0,repid,0)	 Quit $$$OK
	//^DHCPanicReport(0,"DATE",62635,125641,1)
	s num=0
	s Date=DateFrom-1 f  s Date=$o(^DHCPanicReport(0,"DATE",Date)) q:(Date="")!(Date>DateTo)  d
	.s epis="" f  s epis=$o(^DHCPanicReport(0,"DATE",Date,ReportType,epis)) q:epis=""  d
	..s ord="" f  s ord=$o(^DHCPanicReport(0,"DATE",Date,ReportType,epis,ord)) q:ord=""  d
	...s adm=$p(^DHCPanicReport(ReportType,epis,ord),"\",7)
	...s OEOrdItemID=$p(^DHCPanicReport(ReportType,epis,ord),"\",14)
	...s TSName=..GetOrdItemName(OEOrdItemID)
	...i TSName="",ReportType=1 s TSName=..GetTSName(epis)
	...i '$l(TSName) q 	
	...i ReportType=1,'$$CheckLoc1(adm,LocId,epis) q
	...i ReportType'=1,'$$CheckLoc2(adm,LocId,OEOrdItemID) q	
	...s Status=$p(^DHCPanicReport(ReportType,epis,ord),"\",9)
	...i $l(TransStatus),Status'=TransStatus q
	...//
	...s PapmiDr=$p(^PAADM(adm),"^",1)
	...s AdmType=$p(^PAADM(adm),"^",2)
	...//
	...s num=num+1
	...i $l(QryType), QryType'=AdmType q
	...//
	...s DepCode=$p(^PAADM(adm),"^",4)
	...s DepName=""
	...i $l(DepCode) s DepName=$p(^CTLOC(DepCode),"^",2)
	...s DocCode=$p(^PAADM(adm),"^",9)
	...s DocName=""
	...i $l(DocCode) s DocName=$p(^CTPCP(DocCode,1),"^",2)
	...s PatName=$p(^PAPER(PapmiDr,"ALL"),"^",1)
	...s SexDr=$p(^PAPER(PapmiDr,"ALL"),"^",7)
	...s Sex=""
	...i $l(SexDr) s Sex=$p(^CT("SEX",SexDr),"^",2)
	...s DOB=$p(^PAPER(PapmiDr,"ALL"),"^",6)
	...s Age=""
	...;i $l(DOB) s Age=+(##class(web.DHCCLCom).CalAge(DOB,+$h)) //年龄
	...s Age=##class(web.DHCBillInterface).GetPapmiAge(PapmiDr,adm)   //年龄
	...i $l(DOB) s DOB=$zd(DOB,3)
	...s Debtor=$p(^PAPER(PapmiDr,"PAT",1),"^",1)
	...//处理取最后一次
	...s TransOrd=+$o(^DHCPanicReport(ReportType,epis,ord,"TR",""),-1)
	...s (ToPerson,PhoneNo,TransMemo,TransDT)=""
	...;w !,epis,",",ord
	...i $l(TransOrd) d
	....s str=$g(^DHCPanicReport(ReportType,epis,ord,"TR",TransOrd))
	....s TDate=$p(str,"\",1)
	....s TTime=$p(str,"\",2)
	....s TUser=$p(str,"\",3)
	....i $l(TDate),$l(TTime) s TransDT=$zd(TDate,3)_" "_$zt(TTime)
	....s TransUser=""
	....//
	....i $l(TUser) d
	.....s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(TUser,"U"),""))
	.....i $l(UserId) s TransUser=$p(^SSU("SSUSR",UserId),"^",2)
	....s ToPerson=$p(str,"\",5)
	....s PhoneNo=$p(str,"\",6)
	....s TransMemo=$p(str,"\",7)
	....s ReportId=epis_"||"_ord
	...d OutputAll
	//
	f type="PNC" d
	.s dt=DateFrom-1 f  s dt=$o(^[LabData]DHCTSTransi("PNC",dt)) q:(dt>DateTo)!(dt="")  d
	..s tt="" f  s tt=$o(^[LabData]DHCTSTransi("PNC",dt,tt)) q:tt=""  d
	...s ts="" f  s ts=$o(^[LabData]DHCTSTransi("PNC",dt,tt,ts)) q:ts=""  d
	....s labno="" f  s labno=$o(^[LabData]DHCTSTransi("PNC",dt,tt,ts,labno)) q:labno=""  d
	.....s cnt="" f  s cnt=$o(^[LabData]DHCTSTransi("PNC",dt,tt,ts,labno,cnt)) q:cnt=""  d
	......s LastDT=$$GetLastDT(labno,ts,cnt),DTStr=dt_"^"_tt
	......i $l(LastDT),DTStr'=LastDT q
	......s Read=..IsRead(labno,ts,cnt)
	......i TransStatus="F",Read'=1 q
	......i TransStatus'="F",Read=1 q
	......S adm=..GetAdmIDByLabno(labno) //wwh,2015-1-6
	......i $l(LocId),'$$CheckLoc1(adm,LocId,labno) q
	......//b ;101
	......s PatName=$p(^TEPI(labno),"\",1)
	......s TSName=$p(^TTAB("TS",ts),"\",1)
	......s Debtor=$p(^TEPI(labno),"\",18)
	......s SexDr=$p(^TEPI(labno),"\",3)
	......s DOB=$p(^TEPI(labno),"\",4)
	......i $l(DOB) s DOB=$zd(DOB,3)
	......s Age=""
	......s DepDr=$p(^TEPI(labno),"\",36),DepName=""
	......i DepDr'="",$d(^TTAB("USLOC",DepDr)) s DepName=$p($g(^TTAB("USLOC",DepDr)),"\",1)
	......s DocDr=$p(^TEPI(labno),"\",13),DocName=""
	......i DocDr'="",$d(^TTAB("DR",DocDr)) s DocName=$p(^TTAB("DR",DocDr),"\",1)
	......s epis=labno
	......s (PhoneNo,ToPerson,TransMemo,TransDT,TransUser)=""
	......//
	......s RType=1
	......s ReportId=labno_"||"_ts_"||"_cnt
	......s Ver=0
	......d OutputAll	
	//
	Set qHandle=$lb(0,repid,0)
	//m ^TMPPANIC($j,2)=^CacheTemp(repid)
	Quit $$$OK
OutputAll
	set Data=$lb(ReportId,Debtor,PatName,Sex,DOB,Age,DepName,DocName,epis,TSName,PhoneNo,ToPerson,TransMemo,TransDT,TransUser,ReportType,adm)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
CheckLoc1(adm,LocId,epis)
   //s adm=$p(^OEORD(OrdId),"^",1)
   s AdmType=$p(^PAADM(adm),"^",2)
   s OrdId=$o(^OEORD(0,"EpisNo",epis,""))
   i '$l(OrdId) q 0
   s OrdSub=$o(^OEORD(0,"EpisNo",epis,OrdId,""))
   i '$l(OrdSub) q 0 
   //
   s OrdLoc=$p(^OEORD(OrdId,"I",OrdSub,1),"^",3)
   i AdmType="I" d
   .s CurrentWard=$p(^PAADM(adm),"^",70)
   .i $l(CurrentWard) s OrdLoc=$p(^PAWARD(CurrentWard),"^",1)
   i '$l(OrdLoc) q 0
   s Locid=$o(^CTLOC(0,"Code",$zcvt(OrdLoc,"U"),""))
   s AmdLoc=$p(^PAADM(adm),"^",4)
   i (((LocId'="")&&(LocId'=Locid))&&((LocId'="")&&(LocId'=AmdLoc))) q 0   //医生，护士都可看见危急值报告
   q 1
CheckLoc2(adm,LocId,OEOrdId)
   //s adm=$p(^OEORD(OrdId),"^",1)
   s AdmType=$p(^PAADM(adm),"^",2)
   s OrdLoc=$p(^OEORD($p(OEOrdId,"||",1),"I",$p(OEOrdId,"||",2),1),"^",3)
   i AdmType="I" d
   .s CurrentWard=$p(^PAADM(adm),"^",70)
   .i $l(CurrentWard) s OrdLoc=$p(^PAWARD(CurrentWard),"^",1)
   i '$l(OrdLoc) q 0
   s Locid=$o(^CTLOC(0,"Code",$zcvt(OrdLoc,"U"),""))
   s AmdLoc=$p(^PAADM(adm),"^",4)
   i (((LocId'="")&&(LocId'=Locid))&&((LocId'="")&&(LocId'=AmdLoc))) q 0   //医生，护士都可看见危急值报告
   q 1 
GetLastDT(labno,ts,cnt)
    s ret=""
    s date=$o(^DHCTSTrans(labno,ts,cnt,""),-1)
    i '$l(date) q ret
    s time=$o(^DHCTSTrans(labno,ts,cnt,date,""),-1)
    i '$l(time) q ret
   q date_"^"_time
}

ClassMethod GetAllPanicReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllPanicReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

//查询历史

ClassMethod GetAllPanicReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllPanicReportExecute ]
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

//检验危急报告基本信息  

ClassMethod GetPanicReportInfo(epis As %String, RepType As %String) As %String
{
	s RepType=$g(RepType)
	i RepType="" s RepType=1
	s (Debtor,PatName,Sex,Age,HospNo,TSName,Specimen,Location,Doctor,CollDT,RecDT,Labortory,LabPhone)=""
	s $p(RetVal,"\",14)=""
	s ord=$o(^DHCPanicReport(RepType,epis,""),-1)
	i '$l(ord) q RetVal
	s str=$g(^DHCPanicReport(RepType,epis,ord))
	
	s $p(RetVal,"\",11)=$p(str,"\",12)  //RecDT
	s $p(RetVal,"\",12)=$p(str,"\",10)  //labtortory
	s $p(RetVal,"\",13)=$p(str,"\",11)  //labphone
	s OEOrdItemID=$p(str,"\",14)
	//
	s adm=$p(^DHCPanicReport(RepType,epis,ord),"\",7)
	i '$l(adm) q RetVal
	s PapmiDr=$p(^PAADM(adm),"^",1)
	s AdmType=$p(^PAADM(adm),"^",2)
	s DepCode=$p(^PAADM(adm),"^",4)
	//
	s TSName=..GetOrdItemName(OEOrdItemID)
	i TSName="",RepType=1 d
	.s TSName=..GetTSName(epis)
	s $p(RetVal,"\",6)=TSName
	s DepName=""
	i $l(DepCode) s DepName=$p(^CTLOC(DepCode),"^",2)
	i DepName["-" s DepName=$p(DepName,"-",2)
	s $p(RetVal,"\",8)=DepName
	s DocName=""
	s PatName=$p(^PAPER(PapmiDr,"ALL"),"^",1)
	s $p(RetVal,"\",2)=PatName
	s SexDr=$p(^PAPER(PapmiDr,"ALL"),"^",7)
	s Sex=""
	i $l(SexDr) s Sex=$p(^CT("SEX",SexDr),"^",2)
	s $p(RetVal,"\",3)=Sex
	s DOB=$p(^PAPER(PapmiDr,"ALL"),"^",6)
	s Age=""
	;i $l(DOB) s Age=+(##class(web.DHCCLCom).CalAge(DOB,+$h)) //年龄
	s Age=##class(web.DHCBillInterface).GetPapmiAge(PapmiDr,adm)   //年龄
	i $l(DOB) s DOB=$zd(DOB,3)
	s $p(RetVal,"\",4)=Age
	s Debtor=$p(^PAPER(PapmiDr,"PAT",1),"^",1)	
	//s MobPhone=$p(^PAPER(PapmiDr,"PER",4),"^",21)  //PAPER_MobPhone
	s MobPhone=$p(^PAPER(PapmiDr,"PER",1),"^",11)  //PAPER_TelH
	s $p(RetVal,"\",14)=MobPhone
	s $p(RetVal,"\",1)=Debtor
	i RepType=1 d
	.s $p(RetVal,"\",10)=..GetCollDT(epis)
	.//标本类型
    .s OrdId=$o(^OEORD(0,"EpisNo",epis,""))
    .s OrdSub=""
    .i $l(OrdId) s OrdSub=$o(^OEORD(0,"EpisNo",epis,OrdId,""))
    .s SpecSub="1"
    .s SpecCode=""
    .i $l(SpecSub) s SpecCode=$p(^OEORD(OrdId,"I",OrdSub,"SPEC",SpecSub),"^",1)
    .i $l(SpecCode) s $p(RetVal,"\",7)=$p(^TTAB("SPEC",SpecCode),"\",1)
    e  d
    .s OrdId=$p(OEOrdItemID,"||",1),OrdSub=$p(OEOrdItemID,"||",2)
    //20130407 由就诊医生改为开单医生 huhm
    i $l(OrdSub) d
	.s DocCode=$p(^OEORD(OrdId,"I",OrdSub,7),"^",1)
	.i $l(DocCode) s DocName=$p($G(^SSU("SSUSR",DocCode)),"^",2)	
    s $p(RetVal,"\",9)=DocName
    //i AdmType="O" s $p(RetVal,"\",5)=$p(^PAPER(PapmiDr,"PAT",1),"^",22)
    ;s $p(RetVal,"\",5)=$p(^PAPER(PapmiDr,"PAT",1),"^",22)
    ;取病历号用医政组统一接口   20140304
    S $p(RetVal,"\",5)=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(adm)
    q RetVal
}

/// Creator：      huhm
/// CreatDate：    20131009
/// Description:： 根据危急报告ID取危急报告诊断结果
/// Table：        DHC_PanicReport
/// Input：        危急报告类型,危急报告ID
/// Output：       危急报告诊断结果
/// Return：        
/// Others：   
ClassMethod GetPanicReportResult(RType As %String, ReportId As %String) As %String
{
	s RetVal=$g(^DHCPanicReport(RType,$p(ReportId,"||",1),$p(ReportId,"||",2),"Result"))
	q RetVal
}

//采集时间

ClassMethod GetCollDT(epis As %String)
{
	//
	//
	s (CollDate,CollTime)=""
	s flag=0
	s Ord="" f  s Ord=$o(^OEORD(0,"EpisNo",epis,Ord)) q:(Ord="")!(flag)  d
	.s OrdSub="" f  s OrdSub=$o(^OEORD(0,"EpisNo",epis,Ord,OrdSub)) q:(OrdSub="")!(flag)  d
	..s ExecId=Ord_"||"_OrdSub_"||1"
	..s id=$o(^DHCOrdExec(0,"OEOREDR",ExecId,""))
	..i '$l(id) q
	..s CollDate=$p(^DHCOrdExec(id),"^",13)
	..s CollTime=$p(^DHCOrdExec(id),"^",14)
	..i $l(CollDate),$l(CollTime) s flag=1
	i $l(CollDate) s CollDate=$zd(CollDate,3)
	i $l(CollTime) s CollTime=$zt(CollTime)
	q CollDate_" "_CollTime
}

ClassMethod GetTSName(epis As %String) As %String
{
	//n (epis)
   s epis=$g(epis)
   s RetValue=""
   s OrdId="" f  s OrdId=$o(^OEORD(0,"EpisNo",epis,OrdId)) q:OrdId=""  d
   .s OrdSub="" f  s OrdSub=$o(^OEORD(0,"EpisNo",epis,OrdId,OrdSub)) q:OrdSub=""  d
   ..s OrdStr=$g(^OEORD(OrdId,"I",OrdSub,1))
   ..s ItmMastDr=$p(OrdStr,"^",2)
   ..i '$l(ItmMastDr) q
   ..i '$d(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1)) q
   ..s TSName=$p(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1),"^",2)
   ..s RetValue=RetValue_TSName_"+"
   s RetValue=$p(RetValue,"+",1,$l(RetValue,"+")-1)
   q RetValue
}

/// Creator：      huhm
/// CreatDate：    20131008
/// Description:： 根据医嘱ID取医嘱名称
/// Table：        OE_OrdItem
/// Input：        医嘱ID
/// Output：       医嘱名称
/// Return：        
/// Others：       
ClassMethod GetOrdItemName(OEOrdId As %String) As %String
{
	//n (epis)
   s epis=$g(epis)
   s RetValue=""
   s OrdId=$p(OEOrdId,"||",1)
   i OrdId="" q ""
   s OrdSub=$p(OEOrdId,"||",2)
   i OrdSub="" q ""
   s OrdStr=$g(^OEORD(OrdId,"I",OrdSub,1))
   s ItmMastDr=$p(OrdStr,"^",2)
   i '$l(ItmMastDr) q ""
   i '$d(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1)) q ""
   s RetValue=$p(^ARCIM(+ItmMastDr,$p(ItmMastDr,"||",2),1),"^",2)
   q RetValue
}

/// Creator：      huhm
/// CreatDate：    20120910
/// Description:： 查询指定最近时间段内未读危急值报告
/// Table：        DHC_PanicReport
/// Input：        查询最近时间值,客户端IP地址
/// Output：       登记号,姓名,检验号,危急报告ID,危急报告类型,危急报告处理版本
/// Return：        
/// Others：        其它说明
///                增加其他系统危急报告和支持新旧处理危急报告 20131009 huhm
Query QryPanicReport(TimeValue As %String, IPAddress As %String) As %Query(ROWSPEC = "DebtorNo:%String,PatName:%String,LabEpis:%String,TestSet:%String,LabTSRow:%String,ReportType:%String,Version:%String")
{
}

ClassMethod QryPanicReportExecute(ByRef qHandle As %Binary, TimeValue As %String, IPAddress As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	//s ^TMPPARA=DateFrom_","_DateTo_","_IPAddress
	//s ^TMPIP=IPAddress
	s TimeValue=$g(TimeValue)
	i '$l(TimeValue) s TimeValue=24
	//If '$Length(DateFrom) Set qHandle=$lb(0,repid,0)	 Quit $$$OK
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LabData=Config.LabDataNamespace
	If '$Length(LabData) Set LabData="labdata"	
	k ^TMP($zn,$j)
	s IPId=$O(^DHCLabCTIP(0,"IP",IPAddress,""))
	i '$l(IPId) set qHandle=$lb(0,repid,0)	 Quit $$$OK
	s DateTo=+$h
	s DateFrom=(DateTo-(TimeValue\24))
	//
	s ^TMPD(1)=DateFrom_","_DateTo
	s Date=DateFrom-1 f  s Date=$o(^DHCPanicReport(0,"DATE",Date)) q:(Date="")!(Date>DateTo)  d
	.s ^TMPD(3,Date)=""
	.s RType="" f  s RType=$o(^DHCPanicReport(0,"DATE",Date,RType)) q:RType=""  d
	..s epis="" f  s epis=$o(^DHCPanicReport(0,"DATE",Date,RType,epis)) q:epis=""  d
	...s ord="" f  s ord=$o(^DHCPanicReport(0,"DATE",Date,RType,epis,ord)) q:ord=""  d
	....w !,epis,",",ord
	....i $p($g(^DHCPanicReport(RType,epis,ord)),"\",9)="F" q
	....//
	....S ^TMPD(2,RType,epis,ord)=""
	....s RepTime=+$p(^DHCPanicReport(RType,epis,ord),"\",2) 
	....s CurTime=$p($h,",",2)
	....s RepTime1=(((+$h-Date)*86400)-RepTime+CurTime)\3600+1
	....s TimeDiff=RepTime1-TimeValue
	....S ^TMPD(2,RType,epis,ord)=RepTime1_","_RepTime_","_CurTime
	....//b ;100
	....i TimeDiff>0 q  //超时	
	....//
	....s Adm=$p(^DHCPanicReport(RType,epis,ord),"\",7)
	....s OEOrdItemID=$p(^DHCPanicReport(RType,epis,ord),"\",14)
	....i RType=1,'$$CheckIP1(Adm,IPId,epis) q
	....i RType'=1,'$$CheckIP2(Adm,IPId,OEOrdItemID) q
	....//
	....s PapmiDr=$p(^PAADM(Adm),"^",1)
	....s PatName=$p(^PAPER(PapmiDr,"ALL"),"^",1)
	....s Debtor=$p(^PAPER(PapmiDr,"PAT",1),"^",1)	
	....s TSName=..GetOrdItemName(OEOrdItemID)
	....i TSName="",RType=1 d
	.....s TSName=..GetTSName(epis)
	....b
	....i TSName="" q
	....//
	....s labno=epis
	....s ReportId=epis_"||"_ord
	....s Ver=1
	....//w !,ReportId
	....d OutputAll1
	//
	f type="PNC" d
	.s dt=DateFrom-1 f  s dt=$o(^[LabData]DHCTSTransi("PNC",dt)) q:(dt>DateTo)!(dt="")  d
	..s tt="" f  s tt=$o(^[LabData]DHCTSTransi("PNC",dt,tt)) q:tt=""  d
	...s ts="" f  s ts=$o(^[LabData]DHCTSTransi("PNC",dt,tt,ts)) q:ts=""  d
	....s labno="" f  s labno=$o(^[LabData]DHCTSTransi("PNC",dt,tt,ts,labno)) q:labno=""  d
	.....s cnt="" f  s cnt=$o(^[LabData]DHCTSTransi("PNC",dt,tt,ts,labno,cnt)) q:cnt=""  d
	......s LastDT=$$GetLastDT(labno,ts,cnt),DTStr=dt_"^"_tt
	......i $l(LastDT),DTStr'=LastDT q
	......i ..IsRead(labno,ts,cnt) q
	......i '$$CheckIP(labno,IPId) q
	......//b ;101
	......s PatName=$p(^TEPI(labno),"\",1)
	......s TSName=$p(^TTAB("TS",ts),"\",1)
	......s Debtor=$p(^TEPI(labno),"\",18)
	......//
	......s RType=1
	......s ReportId=labno_"||"_ts_"||"_cnt
	......s Ver=0
	......d OutputAll1
	//
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	

GetLastDT(labno,ts,cnt)
    s ret=""
    s date=$o(^DHCTSTrans(labno,ts,cnt,""),-1)
    i '$l(date) q ret
    s time=$o(^DHCTSTrans(labno,ts,cnt,date,""),-1)
    i '$l(time) q ret
   q date_"^"_time

CheckIP(labno,IPId)
   s OrdId=$o(^OEORD(0,"EpisNo",labno,""))
   i '$l(OrdId) q 0
   //s OrdSub=$o(^OEORDi(0,"LabTS",labno_"||"_ts_"||"_cnt,OrdSub))
   s adm=$p(^OEORD(OrdId),"^",1)
   s AdmType=$p(^PAADM(adm),"^",2)
   i $p(^DHCLabCTIP(IPId),"\",5)'=AdmType q 0
   s CurrentWard=$p(^PAADM(adm),"^",70)
   s WardCode=""
   i $l(CurrentWard) s WardCode=$p(^PAWARD(CurrentWard),"^",1)
   i '$l(WardCode) q 0
   s Locid=$o(^CTLOC(0,"Code",$zcvt(WardCode,"U"),""))
   i '$l(Locid) q ""
   s ^TMPALERT(Locid)=""
   i '$d(^DHCLabCTIP(IPId,"LOC",Locid)) q 0
   q 1
CheckIP1(adm,IPId,Epis)
   //s adm=$p(^OEORD(OrdId),"^",1)
   s AdmType=$p(^PAADM(adm),"^",2)
   i $p(^DHCLabCTIP(IPId),"\",5)'=AdmType q 0
   s OrdId=$o(^OEORD(0,"EpisNo",epis,""))
   i '$l(OrdId) q 0
   s OrdSub=$o(^OEORD(0,"EpisNo",epis,OrdId,""))
   i '$l(OrdSub) q 0 
   //
   s OrdLoc=$p(^OEORD(OrdId,"I",OrdSub,1),"^",3)
   i AdmType="I" d
   .s CurrentWard=$p(^PAADM(adm),"^",70)
   .i $l(CurrentWard) s OrdLoc=$p(^PAWARD(CurrentWard),"^",1)
   i '$l(OrdLoc) q ""
   s Locid=$o(^CTLOC(0,"Code",$zcvt(OrdLoc,"U"),""))
   i '$l(Locid) q ""
   s ^TMPALERT(Locid)=""
   i '$d(^DHCLabCTIP(IPId,"LOC",Locid)) q 0
   q 1
CheckIP2(adm,IPId,OEOrdId)
   //s adm=$p(^OEORD(OrdId),"^",1)
   s AdmType=$p(^PAADM(adm),"^",2)
   i $p(^DHCLabCTIP(IPId),"\",5)'=AdmType q 0
   s OrdLoc=$p(^OEORD($p(OEOrdId,"||",1),"I",$p(OEOrdId,"||",2),1),"^",3)
   i AdmType="I" d
   .s CurrentWard=$p(^PAADM(adm),"^",70)
   .i $l(CurrentWard) s OrdLoc=$p(^PAWARD(CurrentWard),"^",1)
   i '$l(OrdLoc) q 0
   s Locid=$o(^CTLOC(0,"Code",$zcvt(OrdLoc,"U"),""))
   i '$l(Locid) q 0
   s ^TMPALERT(Locid)=""
   i '$d(^DHCLabCTIP(IPId,"LOC",Locid)) q 0
   q 1   
OutputAll1
	set Data=$lb(Debtor,PatName,labno,TSName,ReportId,RType,Ver)  //RType
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QryPanicReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPanicReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPanicReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPanicReportExecute ]
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

ClassMethod IsRead(labno As %String, ts As %String, cnt As %String) As %String
{
   //youyi
   s ord=$o(^DHCLabReportReadLog(labno,ts,cnt,""))
   i $l(ord) q 1
   //^DHCLabReportReadLog(11527513,"C079",1,1)=62711\41140\al\10.193.18.102
   q 0
}

/// Creator：		wwh
/// CreateDate：	2013-06-21
/// Description：	根据检验号获取就诊号
/// Table：			无
/// Input：			labno:检验号
/// Output：		无
/// Return：		ret:就诊号
/// Others：		无
/// 	 
ClassMethod GetAdmIDByLabno(labno As %String) As %String
{
	S labno=$G(labno)
	Q:'$L(labno) ""
    S orderItemID=$O(^OEORD(0,"EpisNo",labno,""))
    Q:'$L(orderItemID) ""
    Q $P($G(^OEORD(orderItemID)),"^",1)
}

/// Creator：		shp
/// CreateDate：	2015-02-11
/// Description：	门急诊危急值报告查询
/// debug    :    ##Class(%ResultSet).RunQuery("web.DHCLabPanicReportSearch","GetCVReport","2015-02-01","2015-02-11","","","","")
/// Others：      ##Class(%ResultSet).RunQuery("web.DHCLabPanicReportSearch","GetAllPanicReport","2015-09-12","2014-11-13","59","C","I",2)	
Query GetCVReport(DateFrom As %String, DateTo As %String, LocId As %String, TransStatus As %String, QryType As %String, ReportType As %String) As %Query(ROWSPEC = "ReportId:%String,DebtorNo:%String,PatName:%String,Species:%String,DOB:%String,Age:%String,Location:%String,Doctor:%String,LabEpis:%String,TestSet:%String,MobPhone:%String,ToPerson:%String,TransMemo:%String,TransDT:%String,TransUser:%String,ReportType:%String,Adm:%String")
{
}

//

ClassMethod GetCVReportExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String, LocId As %String, TransStatus As %String, QryType As %String, ReportType As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	If '$Length(DateTo) Set qHandle=$lb(0,repid,0)	 Quit $$$OK
	If '$Length(DateFrom) Set qHandle=$lb(0,repid,0)	 Quit $$$OK
	//s DateFrom=$zdh(DateFrom,3),DateTo=$zdh(DateTo,3)
	
	if '$l(ReportType)  d
	.f ReportType=1:1:6 d
	..set objalert=##class(%ResultSet).%New("web.DHCLabPanicReportSearch:GetAllPanicReport")
	..d objalert.Execute(DateFrom,DateTo,LocId,TransStatus,QryType,ReportType)
	..For  Quit:'objalert.Next()  Do
	...s ReportId=objalert.Data("ReportId")
	...s DebtorNo=objalert.Data("DebtorNo")
	...s PatName=objalert.Data("PatName")
	...s Species=objalert.Data("Species")
	...s DOB=objalert.Data("DOB")
	...s Age=objalert.Data("Age")
	...s Location=objalert.Data("Location")
	...s Doctor=objalert.Data("Doctor")
	...s LabEpis=objalert.Data("LabEpis")
	...s TestSet=objalert.Data("TestSet")
	...s MobPhone=objalert.Data("MobPhone")
	...s ToPerson=objalert.Data("ToPerson")
	...s TransMemo=objalert.Data("TransMemo")
	...s TransDT=objalert.Data("TransDT")
	...s TransUser=objalert.Data("TransUser")
	...s Adm=objalert.Data("Adm")
	...d OutputCV
	e  d
	.set objalert=##class(%ResultSet).%New("web.DHCLabPanicReportSearch:GetAllPanicReport")
	.d objalert.Execute(DateFrom,DateTo,LocId,TransStatus,QryType,ReportType)
	.For  Quit:'objalert.Next()  Do
	..s ReportId=objalert.Data("ReportId")
	..s DebtorNo=objalert.Data("DebtorNo")
	..s PatName=objalert.Data("PatName")
	..s Species=objalert.Data("Species")
	..s DOB=objalert.Data("DOB")
	..s Age=objalert.Data("Age")
	..s Location=objalert.Data("Location")
	..s Doctor=objalert.Data("Doctor")
	..s LabEpis=objalert.Data("LabEpis")
	..s TestSet=objalert.Data("TestSet")
	..s MobPhone=objalert.Data("MobPhone")
	..s ToPerson=objalert.Data("ToPerson")
	..s TransMemo=objalert.Data("TransMemo")
	..s TransDT=objalert.Data("TransDT")
	..s TransUser=objalert.Data("TransUser")
	..s Adm=objalert.Data("Adm")
	..d OutputCV	
	//
	Set qHandle=$lb(0,repid,0)
	//m ^TMPPANIC($j,2)=^CacheTemp(repid)
	Quit $$$OK
OutputCV
	set Data=$lb(ReportId,DebtorNo,PatName,Species,DOB,Age,Location,Doctor,LabEpis,TestSet,MobPhone,ToPerson,TransMemo,TransDT,TransUser,ReportType,Adm)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCVReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCVReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

//查询历史

ClassMethod GetCVReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCVReportExecute ]
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

}
