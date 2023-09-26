/// 名称:     web.DHCAntCVReportSearch
/// 描述:     危急报告查询
/// 编写者：  huhm
/// 编写日期: 20131008
Class web.DHCAntCVReportSearch Extends %RegisteredObject
{

/// Creator：      huhm
/// CreatDate：    20131009
/// Description:： 查询危急报告
/// Table：        DHC_PanicReport
/// Input：        危急报告日期,科室ID,处理状态(C未完成,F完成),就诊类型(O:门诊,Y:住院,E:急诊),报告类型(1:检验,2病理,3心电,4超声,5内镜,6放射)
/// Output：       
/// Return：        
/// Others：      ##Class(%ResultSet).RunQuery("web.DHCAntCVReportSearch","GetAllPanicReport","2013-09-12","2014-11-13","16","C","I",2)
/// Others：      ##Class(%ResultSet).RunQuery("web.DHCAntCVReportSearch","GetAllPanicReport","2013-09-12","2014-11-13","59","C","I",2)
Query GetAllPanicReport(DateFrom As %String, DateTo As %String, LocId As %String, TransStatus As %String, QryType As %String, ReportType As %String) As %Query(ROWSPEC = "ReportId:%String,DebtorNo:%String,PatName:%String,Species:%String,DOB:%String,Age:%String,Location:%String,Doctor:%String,LabEpis:%String,TestSet:%String,MobPhone:%String,ToPerson:%String,TransMemo:%String,TransDT:%String,TransUser:%String,ReportType:%String,Adm:%String,TransDate,TransDTime,colorflag")
{
}

// 

ClassMethod GetAllPanicReportExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String, LocId As %String, TransStatus As %String, QryType As %String, ReportType As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	If '$Length(DateTo) Set qHandle=$lb(0,repid,0)	 Quit $$$OK
	If '$Length(DateFrom) Set qHandle=$lb(0,repid,0)	 Quit $$$OK
	;s DateFrom=$zdh(DateFrom,3),DateTo=$zdh(DateTo,3)
	s DateFrom=##class(websys.Conversions).DateHtmlToLogical(DateFrom)
	s DateTo=##class(websys.Conversions).DateHtmlToLogical(DateTo)
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LabData=Config.LabDataNamespace
	If '$Length(LabData) Set LabData="labdata"
	k ^TMPPANIC($j)
	s ^TMPPANIC($j,1)=DateFrom_","_DateTo_","_QryType_","_LocId_","_TransStatus_","_ReportType
	i '$l(ReportType) s ReportType=1
	//If '$Length(LabEpis) Set qHandle=$lb(0,repid,0)	 Quit $$$OK
	//^DHCAntCVReport(0,"DATE",62635,125641,1)
	s num=0
	s Date=DateFrom-1 f  s Date=$o(^DHCAntCVReport(0,"DATE",Date)) q:(Date="")!(Date>DateTo)  d
	.s epis="" f  s epis=$o(^DHCAntCVReport(0,"DATE",Date,ReportType,epis)) q:epis=""  d
	..s ord="" f  s ord=$o(^DHCAntCVReport(0,"DATE",Date,ReportType,epis,ord)) q:ord=""  d
	...s adm=$p(^DHCAntCVReport(ReportType,epis,ord),"\",7)
	...s OEOrdItemID=$p(^DHCAntCVReport(ReportType,epis,ord),"\",14)
	...s TSName=..GetOrdItemName(OEOrdItemID)
	...i TSName="",ReportType=1 s TSName=..GetTSName(epis)
	...i '$l(TSName) q 	
	...;i ReportType=1,'$$CheckLoc1(adm,LocId,epis) q                       // 20160226
	...i '$$CheckLoc2(adm,LocId,OEOrdItemID) q	            // 20160226
	...s Status=$p(^DHCAntCVReport(ReportType,epis,ord),"\",9)
	...q:(Status="D")&&(TransStatus'="D")
	...i $l(TransStatus),Status'=TransStatus q
	...//
	...s PapmiDr=$p(^PAADM(adm),"^",1)
	...s AdmType=$p(^PAADM(adm),"^",2)
	...//
	...s num=num+1
	...q:(QryType="OE")&&(AdmType'="O")
	...q:(QryType'="")&&(QryType'="OE")&&(QryType'=AdmType)
	...;i $l(QryType), QryType'=AdmType q
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
	...;i $l(DOB) s DOB=$zd(DOB,3)
	...i $l(DOB) s DOB=##class(websys.Conversions).DateLogicalToHtml(DOB)
	...s Debtor=$p(^PAPER(PapmiDr,"PAT",1),"^",1)
	...//处理取最后一次
	...s TransOrd=+$o(^DHCAntCVReport(ReportType,epis,ord,"TR",""),-1)
	...s (ToPerson,PhoneNo,TransMemo,TransDT,TransDate,TransDTime)=""
	...s colorflag=0,TransUser=""
	...;w !,epis,",",ord
	...;i $l(TransOrd) d
	...i $g(TransOrd)'=0 d
	....s str=$g(^DHCAntCVReport(ReportType,epis,ord,"TR",TransOrd))
	....s TDate=$p(str,"\",1)
	....s TTime=$p(str,"\",2)
	....s TUser=$p(str,"\",3)
	....i $l(TDate),$l(TTime) d
	.....s TransDT=$zd(TDate,3)_" "_$zt(TTime)
	.....s TransDate=##class(websys.Conversions).DateLogicalToHtml(TDate)
	.....s TransDTime=$zt(TTime)
	....s TransUser=""
	....//
	....i $l(TUser) d
	.....s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(TUser,"U"),""))
	.....i $l(UserId) s TransUser=$p(^SSU("SSUSR",UserId),"^",2)
	....s ToPerson=$p(str,"\",5)
	....s PhoneNo=$p(str,"\",6)
	....s TransMemo=$p(str,"\",7)
	....;s ReportId=epis_"||"_ord
	....s colorflag=1
	...s ReportId=epis_"||"_ord
	...d OutputAll
	/*
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
	*/
	Set qHandle=$lb(0,repid,0)
	//m ^TMPPANIC($j,2)=^CacheTemp(repid)
	Quit $$$OK
OutputAll
	set Data=$lb(ReportId,Debtor,PatName,Sex,DOB,Age,DepName,DocName,epis,TSName,PhoneNo,ToPerson,TransMemo,TransDT,TransUser,ReportType,adm,TransDate,TransDTime,colorflag)
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
   s OrdLoc=$p(^OEORD(+$p(OEOrdId,"||",1),"I",+$p(OEOrdId,"||",2),1),"^",3)
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

// 查询历史

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

// 检验危急报告基本信息  

/// w ##class(web.DHCAntCVReportSearch).GetPanicReportInfo(106,1)
ClassMethod GetPanicReportInfo(epis As %String, RepType As %String) As %String
{
	//s ^tlsj("Epis")=epis_"!"_RepType
	s RepType=$g(RepType)
	i RepType="" s RepType=1
	s (Debtor,PatName,Sex,Age,HospNo,TSName,Specimen,Location,Doctor,CollDT,RecDT,Labortory,LabPhone)=""
	s $p(RetVal,"\",14)=""
	i epis="" q RetVal
	s ord=$o(^DHCAntCVReport(RepType,epis,""),-1)
	i '$l(ord) q RetVal
	s str=$g(^DHCAntCVReport(RepType,epis,ord))
	
	s $p(RetVal,"\",11)=$p(str,"\",12)  //RecDT
	s $p(RetVal,"\",12)=$p(str,"\",10)  //labtortory
	s $p(RetVal,"\",13)=$p(str,"\",11)  //labphone
	s OEOrdItemID=$p(str,"\",14)
	//
	s adm=$p(^DHCAntCVReport(RepType,epis,ord),"\",7)
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
	
	//2019-2-1 申请科室取下医嘱科室
	s ordPar=+$p(OEOrdItemID,"||",1),ordSub=+$p(OEOrdItemID,"||",2)
	s ordLoc = $p($g(^OEORD(ordPar,"I",ordSub,7)),"^",2)
	if ordLoc>0 {
		s ordLocDesc = $P($g(^CTLOC(ordLoc)),"^",2)
		if ordLocDesc["-" s ordLocDesc=$p(ordLocDesc,"-",2)
		s:ordLocDesc'="" $p(RetVal,"\",8)=ordLocDesc
	}
	
	
	
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
    .;s OrdId=$o(^OEORD(0,"EpisNo",epis,""))
    .;s OrdSub=""
    .;i $l(OrdId) s OrdSub=$o(^OEORD(0,"EpisNo",epis,OrdId,""))
    .;s SpecSub="1"
    .;s SpecCode=""
    .;i $l(SpecSub) s SpecCode=$p(^OEORD(OrdId,"I",OrdSub,"SPEC",SpecSub),"^",1)
    .;i $l(SpecCode) s $p(RetVal,"\",7)=$p(^TTAB("SPEC",SpecCode),"\",1)
    s OrdId=$p(OEOrdItemID,"||",1),OrdSub=$p(OEOrdItemID,"||",2)
    //20130407 由就诊医生改为开单医生 huhm
    i $l(OrdSub) d
	.s DocCode=$p(^OEORD(OrdId,"I",OrdSub,7),"^",1)
	.i $l(DocCode) s DocName=$p($G(^SSU("SSUSR",DocCode)),"^",2)	
    s $p(RetVal,"\",9)=DocName
    //i AdmType="O" s $p(RetVal,"\",5)=$p(^PAPER(PapmiDr,"PAT",1),"^",22)
    ;s $p(RetVal,"\",5)=$p(^PAPER(PapmiDr,"PAT",1),"^",22)
    ;取病历号用医政组统一接口   20140304
    
    ;S $p(RetVal,"\",5)=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(adm)
    s $p(RetVal,"\",5)=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(adm,AdmType,.ErrMsg)
    
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
	s RetVal=$g(^DHCAntCVReport(RType,$p(ReportId,"||",1),$p(ReportId,"||",2),"Result"))
	q RetVal
}

// 采集时间

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
	s useTrans=0,langId=20
	if $d(%session),%session.Get("LOGON.LANGID")>0 s useTrans=1,langId=%session.Get("LOGON.LANGID")
	if useTrans {
		q ..GetOrdItems(OEOrdId,",",",",langId)	
	}else{
		q ..GetOrdItems(OEOrdId,",",",")	
	}
	
	
	s OrdItemIds=OEOrdId
	s ret=""
	s len=$l(OrdItemIds,",")
	for i=1:1:len{
		s ordItemId=$p(OrdItemIds,",",i)
		s ordPar=$p(ordItemId,"||",1)
		s ordSub=$p(ordItemId,"||",2)
		continue:(ordPar="")||(ordSub="")
		s str1=^OEORD(ordPar,"I",ordSub,1)
		s ItmMastDR = $p(str1,"^",2)
		s ordDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)	;医嘱名称
		if ret="" s ret=ordDesc
		else  s ret=ret_","_ordDesc
	}
	q ret
	
	
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
	s Date=DateFrom-1 f  s Date=$o(^DHCAntCVReport(0,"DATE",Date)) q:(Date="")!(Date>DateTo)  d
	.s ^TMPD(3,Date)=""
	.s RType="" f  s RType=$o(^DHCAntCVReport(0,"DATE",Date,RType)) q:RType=""  d
	..s epis="" f  s epis=$o(^DHCAntCVReport(0,"DATE",Date,RType,epis)) q:epis=""  d
	...s ord="" f  s ord=$o(^DHCAntCVReport(0,"DATE",Date,RType,epis,ord)) q:ord=""  d
	....w !,epis,",",ord
	....i $p($g(^DHCAntCVReport(RType,epis,ord)),"\",9)="F" q
	....//
	....S ^TMPD(2,RType,epis,ord)=""
	....s RepTime=+$p(^DHCAntCVReport(RType,epis,ord),"\",2) 
	....s CurTime=$p($h,",",2)
	....s RepTime1=(((+$h-Date)*86400)-RepTime+CurTime)\3600+1
	....s TimeDiff=RepTime1-TimeValue
	....S ^TMPD(2,RType,epis,ord)=RepTime1_","_RepTime_","_CurTime
	....//b ;100
	....i TimeDiff>0 q  //超时	
	....//
	....s Adm=$p(^DHCAntCVReport(RType,epis,ord),"\",7)
	....s OEOrdItemID=$p(^DHCAntCVReport(RType,epis,ord),"\",14)
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
/// debug    :    ##Class(%ResultSet).RunQuery("web.DHCAntCVReportSearch","GetCVReport","2015-02-01","2015-02-11","","","","")
/// Others：      ##Class(%ResultSet).RunQuery("web.DHCAntCVReportSearch","GetAllPanicReport","2015-09-12","2014-11-13","59","C","I",2)	
Query GetCVReport(DateFrom As %String, DateTo As %String, LocId As %String, TransStatus As %String, QryType As %String, ReportType As %String) As %Query(ROWSPEC = "ReportId:%String,DebtorNo:%String,PatName:%String,Species:%String,DOB:%String,Age:%String,Location:%String,Doctor:%String,LabEpis:%String,TestSet:%String,MobPhone:%String,ToPerson:%String,TransMemo:%String,TransDate:%String,TransDTime:%String,TransUser:%String,ReportType:%String,Adm:%String,colorflag")
{
}

// 

ClassMethod GetCVReportExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String, LocId As %String, TransStatus As %String, QryType As %String, ReportType As %String) As %Status
{
	s ^templsj("2016022602")=TransStatus_"!"_QryType_"!"_ReportType
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	If '$Length(DateTo) Set qHandle=$lb(0,repid,0)	 Quit $$$OK
	If '$Length(DateFrom) Set qHandle=$lb(0,repid,0)	 Quit $$$OK
	//s DateFrom=$zdh(DateFrom,3),DateTo=$zdh(DateTo,3)
	
	if '$l(ReportType)  d
	.;f ReportType=1:1:6 d
	.s ReportType="" f  s ReportType=$o(^User.DHCAntCVOptionsD("CVType",ReportType)) q:ReportType=""  d
	..set objalert=##class(%ResultSet).%New("web.DHCAntCVReportSearch:GetAllPanicReport")
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
	...s TransDate=objalert.Data("TransDate")
	...s TransDTime=objalert.Data("TransDTime")
	...s TransUser=objalert.Data("TransUser")
	...s Adm=objalert.Data("Adm")
	...s colorflag=objalert.Data("colorflag")
	...d OutputCV
	e  d
	.set objalert=##class(%ResultSet).%New("web.DHCAntCVReportSearch:GetAllPanicReport")
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
	..s TransDate=objalert.Data("TransDate")
	..s TransDTime=objalert.Data("TransDTime")
	..s TransUser=objalert.Data("TransUser")
	..s Adm=objalert.Data("Adm")
	..s colorflag=objalert.Data("colorflag")
	..d OutputCV	
	//
	Set qHandle=$lb(0,repid,0)
	//m ^TMPPANIC($j,2)=^CacheTemp(repid)
	Quit $$$OK
OutputCV
	set Data=$lb(ReportId,DebtorNo,PatName,Species,DOB,Age,Location,Doctor,LabEpis,TestSet,MobPhone,ToPerson,TransMemo,TransDate,TransDTime,TransUser,ReportType,Adm,colorflag)
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

// 查询历史

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

/// Creator:		cryze
/// CreatDate:		2019-07-03
/// Description:	危急值查询
/// Table:			DHC_AntCVReport  DHC_AntCVReportTrans
/// Input:			DateFrom开始日期,DateTo结束日期,LocId(科室ID或病区科室ID),TransStatus危急值状态(C,F) QryType就诊类型(OIEH,OE单指门诊zzz) ReportType危急值类型 pAdmLocId科室 pWardLocId病区 pPapmiNo登记号,pHospId医院ID,onlyFlag是否只查一条
/// Debugger:		d ##Class(%ResultSet).RunQuery("web.DHCAntCVReportSearch","GetCVReportNew","","","","","","","","","0000000001")
/// TransStatus ^分隔
///  1-TransStatus C,Rec,F,D
///  3-pRecStatus:接收状态  及时接收1 超时接收2  未接收但未超时3 超时未接收4
///  4-pExecStatus:处理状态  及时处理1 超时处理2  未处理但未超时3 超时未处理4
///  5-pRecConResult 接收时选择的联系结果
///  6-pExecConResult 处理时选择的联系结果 
Query GetCVReportNew(DateFrom As %String = "", DateTo As %String = "", LocId As %String = "", TransStatus As %String = "", QryType As %String = "", ReportType As %String = "", pAdmLocId = "", pWardLocId = "", pPapmiNo = "", pHospId = "", onlyFlag = 0, pAdmDocId = "", pOrdLocId = "", pOrdDocId = "", pArcItemCat = "", pExecTimeUsed = "") As websys.Query(ROWSPEC = "ReportId:%String,DebtorNo:%String,PatName:%String,Species:%String,DOB:%String,Age:%String,Location:%String,Doctor:%String,LabEpis:%String,TestSet:%String,MobPhone:%String,ToPerson:%String,TransMemo:%String,TransDate:%String,TransDTime:%String,TransUser:%String,ReportType:%String,Adm:%String,colorflag,DPRPDate,DPRPTime,CurrBed,MedCareNo,repResult,reportID,PatientID,mradm,HasTransOrd,HasTransEMR,wardLocDesc,TransAdvice,repLoc,repUser,recUser,recDate,recTime,recContact,recTel,recMemo,recAdvice,admHosp,ordLoc,ordDoc,ordAddDT,msgDT,SMSFlag,admCardNo,repTypeDesc,transTimeUsedAlias,mtsRepTime,recTimeUsedAlias,recStatus,recStatusDesc,execStatus,execStatusDesc,oglLoc,admDT,repStatus,repStatusDesc,ordItem") [ SqlProc ]
{
}

ClassMethod GetCVReportNewExecute(ByRef QHandle As %Binary, DateFrom As %String = "", DateTo As %String = "", LocId As %String = "", TransStatus As %String = "", QryType As %String = "", ReportType As %String = "", pAdmLocId = "", pWardLocId = "", pPapmiNo = "", pHospId = "", onlyFlag = 0, pAdmDocId = "", pOrdLocId = "", pOrdDocId = "", pArcItemCat = "", pExecTimeUsed = "") As %Status
{
 	s repid=$I(^CacheTemp) 
 	s ind=1 
 	s QHandle=$lb(0,repid,0)
 	if DateFrom'="" s DateFrom=##class(websys.Conversions).DateHtmlToLogical(DateFrom)
 	if DateTo'="" s DateTo=##class(websys.Conversions).DateHtmlToLogical(DateTo)
 	
 	s useTrans=0,langId=20
 	if $d(%session),%session.Get("LOGON.LANGID")>0 s useTrans=1,langId=%session.Get("LOGON.LANGID")
 	
	s RECTIMELIMIT=+(##class(web.DHCAntCVOptions).GetBaseOpt("RecTimeLimit"))  //及时接收时间限制分钟
	s EXECTIMELIMIT=+(##class(web.DHCAntCVOptions).GetBaseOpt("ExecTimeLimit"))   //及时处理时间限制分钟
	
	s pRecStatus=$p(TransStatus,"^",3),pExecStatus=$p(TransStatus,"^",4) //接收状态 处理状态
	s pRecConResult=$p(TransStatus,"^",5),pExecConResult=$p(TransStatus,"^",6) //接收时选择联系结果  处理时选择联系结果
	s TransStatus=$p(TransStatus,"^",1)  
	
 	s now=$h,nowDate=$p(now,",",1),nowTime=$p(now,",",2)
 	
	if pArcItemCat'="" s pArcItemCat=","_pArcItemCat_","
	
 	for i=1:1:$l(LocId,","){ //就诊科室ID  所在病区科室ID
		if $p(LocId,",",i)>0 s LocIdList($p(LocId,",",i))=1	
	}
	
	s pAdmDocCP=""
	if pAdmDocId'="" s pAdmDocCP=$p($g(^SSU("SSUSR",pAdmDocId)),"^",14) //主管医生人员ID
	s pOrdDocCP=""
	if pOrdDocId'="" s pOrdDocCP=$p($g(^SSU("SSUSR",pOrdDocId)),"^",14) //开医嘱医生人员ID
	
	if TransStatus'="" s TransStatus=","_TransStatus_","
	
	s pRepLoc=$p(ReportType,"^",2)   //报告科室使用ReportType进行传参
	s ReportType =$p(ReportType,"^",1)
	if ReportType'="" s ReportType=","_ReportType_","
	
	s pAdmType=QryType
	if QryType="OE" s pAdmType="O"  //历史遗留 OE查门诊
 	
 	
	if (pPapmiNo'=""){  //登记号不为空走 登记号->就诊->危急值 
		///pPapmiNo 登记号^病人ID^就诊ID
		s pPatientID=$p(pPapmiNo,"^",2)
		s pEpisodeID=$p(pPapmiNo,"^",3)
		s pPapmiNo=$p(pPapmiNo,"^",1)
		
		if pEpisodeID>0 {
			s pPatientID=$p(^PAADM(pEpisodeID),"^",1)
			s pAdmType=$p(^PAADM(pEpisodeID),"^",2)
			
		}
		if pPatientID>0 {
			s PatientID=pPatientID
		}else{
			set PatientID=$o(^PAPERi("PAPMI_PatNo",pPapmiNo,""),-1)
		}
		
		if PatientID="" q $$$OK //登记号查不到
		s admType = ""
 		for {
 			s admType = $O(^PAPERdr(PatientID,"ADM",admType))
 			q:(admType="")
 			q:(onlyFlag=1)&&(ind>1) //仅查标志时 查到一条即退出
 			
 			continue:(pAdmType'="")&&(pAdmType'=admType)
 			//continue:(QryType'="")&&(QryType'="OE")&&(QryType'=admType)
 			//continue:(QryType="OE")&&(admType'="O")  //OE  实际查门诊
 			s adm = ""
 			if pEpisodeID>0 s adm=pEpisodeID+1   //如果有就诊查询条件 直接+1 然后往前循环直接找到就诊
 			for {
	 			s adm = $O(^PAPERdr(PatientID,"ADM",admType,adm),-1)
	 			q:(adm="")
	 			q:(pEpisodeID>0)&&(adm'=pEpisodeID)  //就诊过滤
	 			
	 			q:(onlyFlag=1)&&(ind>1) //仅查标志时 查到一条即退出
	 			s admLoc=$p(^PAADM(adm),"^",4)
	 			continue:(pAdmLocId'="")&&(pAdmLocId'=admLoc) //科室过滤
	 			
	 			continue:(pHospId>0)&&($p($g(^CTLOC(+admLoc)),"^",22)'=pHospId) ;院区过滤 20200513
	 			
				set ward = $p(^PAADM(adm),"^",70),wardLoc=""	
				if ward>0 set wardLoc = $p(^PAWARD(ward),"^",5)
	 			continue:(pWardLocId'="")&&(pWardLocId'=wardLoc)
	 			
	 			continue:($d(LocIdList)>9)&&('$d(LocIdList(+admLoc)))&&('$d(LocIdList(+wardLoc)))
	 			
	 			//根据就诊索引 循环危急值表
 			 	s repType=0
				for{
					s repType=$o(^DHCAntCVReport(0,"ADM",adm,repType)) 
					q:repType=""
					q:(onlyFlag=1)&&(ind>1) //仅查标志时 查到一条即退出
					continue:(ReportType'="")&&(ReportType'[(","_repType_","))
					s repLabno=""
					for{
						s repLabno=$o(^DHCAntCVReport(0,"ADM",adm,repType,repLabno))
						q:repLabno=""
						q:(onlyFlag=1)&&(ind>1) //仅查标志时 查到一条即退出
						s repOrder=""
						for{
							s repOrder=$o(^DHCAntCVReport(0,"ADM",adm,repType,repLabno,repOrder))
							q:repOrder=""
							q:(onlyFlag=1)&&(ind>1) //仅查标志时 查到一条即退出
							s repInfo=^DHCAntCVReport(repType,repLabno,repOrder)
							s repStatus=$p(repInfo,"\",9)
							continue:(repStatus="D")&&(TransStatus'[",D,")
							continue:(TransStatus'="")&&(TransStatus'[(","_repStatus_","))
							s repDate=$p(repInfo,"\",1)
							continue:(DateFrom'="")&&(repDate<DateFrom)
							continue:(DateTo'="")&&(repDate>DateTo)
							d Outputrow
							
						}
					}
				}
 			}
 		}
	}else{ //登记号为空  走日期索引
		if (DateFrom="")||(DateTo="") q $$$OK  //登记号为空 日期必须要有
		set repDate=DateFrom-1
		for {
			s repDate=$o(^DHCAntCVReport(0,"DATE",repDate))
			q:(repDate="")||(repDate>DateTo)
			q:(onlyFlag=1)&&(ind>1) //仅查标志时 查到一条即退出
			//根据就诊索引 循环危急值表
		 	s repType=0
			for{
				s repType=$o(^DHCAntCVReport(0,"DATE",repDate,repType)) 
				q:repType=""
				q:(onlyFlag=1)&&(ind>1) //仅查标志时 查到一条即退出
				continue:(ReportType'="")&&(ReportType'[(","_repType_","))
				s repLabno=""
				for{
					s repLabno=$o(^DHCAntCVReport(0,"DATE",repDate,repType,repLabno))
					q:repLabno=""
					q:(onlyFlag=1)&&(ind>1) //仅查标志时 查到一条即退出
					s repOrder=""
					for{
						s repOrder=$o(^DHCAntCVReport(0,"DATE",repDate,repType,repLabno,repOrder))
						q:repOrder=""
						q:(onlyFlag=1)&&(ind>1) //仅查标志时 查到一条即退出
						s repInfo=^DHCAntCVReport(repType,repLabno,repOrder)
						s repStatus=$p(repInfo,"\",9)
						continue:(repStatus="D")&&(TransStatus'[",D,")
						continue:(TransStatus'="")&&(TransStatus'[(","_repStatus_","))
						
						s adm=$p(repInfo,"\",7)
						continue:(adm="")||('$d(^PAADM(adm)))
						s admType = $p(^PAADM(adm),"^",2)
			 			continue:(QryType'="")&&(QryType'="OE")&&(QryType'=admType)
			 			continue:(QryType="OE")&&(admType'="O")  //OE  实际查门诊
						s admLoc=$p(^PAADM(adm),"^",4)
						//if adm=44 s admLoc=132 //测试
			 			continue:(pAdmLocId'="")&&(pAdmLocId'=admLoc) //科室过滤
			 			
			 			continue:(pHospId>0)&&($p($g(^CTLOC(+admLoc)),"^",22)'=pHospId) ;院区过滤 20200513
			 			
						set ward = $p(^PAADM(adm),"^",70),wardLoc=""	
						if ward>0 set wardLoc = $p(^PAWARD(ward),"^",5)
			 			continue:(pWardLocId'="")&&(pWardLocId'=wardLoc)
			 			
			 			continue:($d(LocIdList)>9)&&('$d(LocIdList(+admLoc)))&&('$d(LocIdList(+wardLoc)))
						d Outputrow
					}
				}
			}
		}
	}
	Set QHandle=$lb(0,repid,0) 
	Quit $$$OK
Outputrow
	// PatientID admType adm repType repLabno repOrder repDate  循环变量 一定不要在这儿赋值
	s repExtdInfo=$g(^DHCAntCVReport(repType,repLabno,repOrder,"EXTD"))
	s ReportId=repLabno_"||"_repOrder  
	s aPatientID=$p(^PAADM(adm),"^",1)
	s DebtorNo=$p(^PAPER(aPatientID,"PAT",1),"^",1) //登记号 2
	s PatName=$p(^PAPER(aPatientID,"ALL"),"^",1)  //病人姓名 3
	s Species=""  //性别 4
	s sexDr=$p(^PAPER(aPatientID,"ALL"),"^",7)
	i sexDr>0 s Species=$p(^CT("SEX",sexDr),"^",2)
	s DOB=$p(^PAPER(aPatientID,"ALL"),"^",6)  //生日 5
	i DOB>0 s DOB=##class(websys.Conversions).DateLogicalToHtml(DOB)
	s Age=##class(web.DHCBillInterface).GetPapmiAge(aPatientID,adm)  //年龄 6
	s Location=""  //科室7
	if admLoc>0 s Location=$p($g(^CTLOC(admLoc)),"^",2)
	s oglLoc=$p(repExtdInfo,"\",2)  //报告时患者所在科室
	if oglLoc>0 s oglLoc=$p($g(^CTLOC(oglLoc)),"^",2)
	
	s admDoc=$p(^PAADM(adm),"^",9),DocName="" //医生8
	if pAdmDocCP>0,admDoc'=pAdmDocCP q //主管医生过滤
	if admDoc>0 s DocName=$p(^CTPCP(admDoc,1),"^",2)
	s Doctor=DocName
	s LabEpis=repLabno //检查检验号9
	s ordItem=$p(repInfo,"\",14)
	s ordPar=+$p(ordItem,"||",1),ordSub=+$p(ordItem,"||",2)
	s arcim=$p($g(^OEORD(ordPar,"I",ordSub,1)),"^",2)
	s ItemCatRowId=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",10)
	q:(pArcItemCat'="")&&(pArcItemCat'[(","_ItemCatRowId_",")) //医嘱子类
	s ordDoc=$p($g(^OEORD(ordPar,"I",ordSub,1)),"^",11)
	if pOrdDocCP>0,ordDoc'=pOrdDocCP q //下医嘱医生过滤
	s:ordDoc>0 ordDoc=$p(^CTPCP(ordDoc,1),"^",2) //下医嘱医生姓名
	
	s ordLoc = $p($g(^OEORD(ordPar,"I",ordSub,7)),"^",2)
	if pOrdLocId>0,ordLoc'=pOrdLocId q //下医嘱科室过滤
	s:ordLoc>0 ordLoc=$p($g(^CTLOC(ordLoc)),"^",2)
	
	s ordAddDate=$p(^OEORD(ordPar,"I",ordSub,3),"^",7)
	s ordAddTime=$p($g(^OEORD(ordPar,"I",ordSub,1)),"^",17)
	s ordAddDT=##class(websys.Conversions).DateLogicalToHtml(ordAddDate)_" "_$zt(ordAddTime)
	
	s TestSet=..GetOrdItems(ordItem) //医嘱名称 项目名称10
	s (MobPhone,ToPerson,TransMemo,TransDate,TransDTime,TransUser,TransAdvice,transTimeUsed,execConResult)="" //MobPhone联系电话11，ToPerson联系人12 ，TransMemo处理结果13，TransDate处理日期14 ，TransDTime处理时间15，TransUser处理人16
	s (recTel,recContact,recMemo,recDate,recTime,recUser,recAdvice,recTimeUsed,recConResult)=""
	s (recDate0,recTime0,recTimeUsed0,transDate0,transTime0,transTimeUsed0)=""
	s repTime=$p(repInfo,"\",2)
	s transOrder=""
	for {
		s transOrder=$o(^DHCAntCVReport(repType,repLabno,repOrder,"TR",transOrder),-1)
		q:transOrder=""
		continue:transOrder'>0
		s transInfo=^DHCAntCVReport(repType,repLabno,repOrder,"TR",transOrder)
		s opType=$p(transInfo,"\",16) if opType="",$p(transInfo,"\",8)="F" s opType="E"	
		s trExecResult=$p(transInfo,"\",10)  //联系结果
		if trExecResult="" s trExecResult=$p(transInfo,"\",8)
		if opType="Rec" {
			s recDate0=$p(transInfo,"\",1)
			s recTime0=$p(transInfo,"\",2)
			s recTimeUsed0=(recDate0-repDate)*86400+recTime0-repTime 
			
			continue:recDate'=""
			
			s recUserCode=$p(transInfo,"\",3)
			s recTimeUsed=recTimeUsed0
			if recDate0>0 s recDate=##class(websys.Conversions).DateLogicalToHtml(recDate0)
			if recTime0'="" s recTime=$zt(recTime0)
			
			s recUserCodeU=$$ALPHAUP^SSUTIL4(recUserCode)
			if recUserCodeU'="" {
				s recUserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",recUserCodeU,""))
				if recUserId>0 s recUser=$p(^SSU("SSUSR",recUserId),"^",2)
			}
			
			s recTel=$p(transInfo,"\",6)
			s recContact=$p(transInfo,"\",5)
			s recMemo=$p(transInfo,"\",7)
			s recAdvice=$p(transInfo,"\",9) //接收备注
			s recConResult=trExecResult //接收时联系结果
		}elseif opType="E"{
			s transDate0=$p(transInfo,"\",1)
			s transTime0=$p(transInfo,"\",2)
			s transTimeUsed0=(transDate0-repDate)*86400+transTime0-repTime 
			
			continue:TransDate'=""
			s transUserCode=$p(transInfo,"\",3)
			s transTimeUsed= transTimeUsed0
			if transDate0>0 s TransDate=##class(websys.Conversions).DateLogicalToHtml(transDate0)
			if transTime0'="" s TransDTime=$zt(transTime0)
			
			s transUserCodeU=$$ALPHAUP^SSUTIL4(transUserCode)
			if transUserCodeU'="" {
				s transUserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",transUserCodeU,""))
				if transUserId>0 s TransUser=$p(^SSU("SSUSR",transUserId),"^",2)
			}
			
			s MobPhone=$p(transInfo,"\",6)
			s ToPerson=$p(transInfo,"\",5)
			s TransMemo=$p(transInfo,"\",7)
			s TransAdvice=$p(transInfo,"\",9) //处理意见或措施
			s execConResult=trExecResult //处理时联系结果
		}
		//q:(TransDate'="")&&(recDate'="") //处理 接收都取到 跳出循环
	}
	q:(pRecConResult'="")&&(pRecConResult'=recConResult)
	q:(pExecConResult'="")&&(pExecConResult'=execConResult)
	
	s transTimeUsedAlias=##class(web.DHCAntCVComm).Seconds2Alias(transTimeUsed0) //改为使用首次操作时间计算
	s recTimeUsedAlias=##class(web.DHCAntCVComm).Seconds2Alias(recTimeUsed0) //改为使用首次操作时间计算
	q:(pExecTimeUsed'="")&&(##class(web.DHCAntCVComm).IsSecondsInMinRange(transTimeUsed0,pExecTimeUsed)=0) //处理用时过滤
	s recStatus="",recStatusDesc="",execStatus="",execStatusDesc=""
	if recTimeUsed0'="" { //已接收
		if RECTIMELIMIT>0,recTimeUsed0>(RECTIMELIMIT*60) { //超时接收
			s recStatus=2,recStatusDesc="超时接收"
		}else{
			s recStatus=1,recStatusDesc="及时接收"	
		}
	}else{
		if RECTIMELIMIT>0,(nowDate-repDate*86400+nowTime-repTime)>(RECTIMELIMIT*60) { //超时未接收
			s recStatus=4,recStatusDesc="超时未接收"
		}else{
			s recStatus=3,recStatusDesc="未超时未接收"	
		}
	}
	q:(pRecStatus'="")&&(pRecStatus'[recStatus)
	
	if transTimeUsed0'="" { //已处理
		if EXECTIMELIMIT>0,transTimeUsed0>(EXECTIMELIMIT*60) { //超时处理
			s execStatus=2,execStatusDesc="超时处理"
		}else{
			s execStatus=1,execStatusDesc="及时处理"	
		}
	}else{
		if EXECTIMELIMIT>0,(nowDate-repDate*86400+nowTime-repTime)>(EXECTIMELIMIT*60) { //超时未处理
			s execStatus=4,execStatusDesc="超时未处理"
		}else{
			s execStatus=3,execStatusDesc="未超时未处理"	
		}
	}
	q:(pExecStatus'="")&&(pExecStatus'[execStatus)

	// repType //危急值类型 17
	s Adm=adm  //就诊ID18
	s colorflag=(repStatus="F") //颜色标志 19
	s DPRPDate=repDate  //报告日期19
	if DPRPDate>0 s DPRPDate=##class(websys.Conversions).DateLogicalToHtml(DPRPDate)
	s DPRPTime=$p(repInfo,"\",2) //报告时间20 
	if DPRPTime'="" s DPRPTime=$zt(DPRPTime)
	s CurrBed="" //床号 21
	if $d(^oddCOM("Nur.Interface.OutSide.Patient","m","getPatientLastBedCode")){
		Set CurrBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(adm)
	}else{
		set CurrBedDR = $p(^PAADM(adm),"^",73),CurrBed=""
		if CurrBedDR'="" Set CurrBed = $p($g(^PAWARD(+CurrBedDR,"BED",$p(CurrBedDR,"||",2))),"^",1)
	}
	s MedCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(adm,admType,.ErrMsg) //病案号 22
	s repResult=$g(^DHCAntCVReport(repType,repLabno,repOrder,"Result")) //报告内容 23
	s reportID=repType_"||"_repLabno_"||"_repOrder //报告完整ID 24
	s mradm=$p(^PAADM(adm),"^",61) //病人ID25, mradm 26
	
	if $d(^oddCOM("web.DHCAntCVReportLink","m","HasTransOrd")){
		s HasTransOrd=##class(web.DHCAntCVReportLink).HasTransOrd(reportID) //27
		s HasTransEMR=##class(web.DHCAntCVReportLink).HasTransEMR(reportID)  //28
	}else{
		s HasTransOrd=0,HasTransEMR=0
	}
	
	s wardLocDesc=""
	s:wardLoc>0 wardLocDesc=$p($g(^CTLOC(wardLoc)),"^",2)

		
	s repLoc=$p(repInfo,"\",21),repLocId=""
	if repLoc'="" {
		if repLoc>0 s repLocId=repLoc,repLoc=$p($g(^CTLOC(repLoc)),"^",2)
		else  s repLoc=$p(repLoc,"^",2)
	}
	if repLoc="" {
		s repLoc=$p($g(^OEORD(+ordItem,"I",+$p(ordItem,"||",2),3)),"^",6),repLocId=repLoc
		s:repLoc>0 repLoc=$p($g(^CTLOC(repLoc)),"^",2)
	}
	
	q:(pRepLoc>0)&&(pRepLoc'=repLocId) //报告科室ID对比
	q:(pRepLoc'="")&&(pRepLoc'>0)&&(pRepLoc'=repLoc) //报告科室名称
	
	
	s repUser=$p(repInfo,"\",3)
	s:repUser>0 repUser=$p($g(^SSU("SSUSR",repUser),"^"_repUser),"^",2)
	
	s admHosp=$p($g(^CTLOC(+admLoc)),"^",22)
	s:admHosp>0 admHosp=$p($g(^CT("HOSP",admHosp)),"^",2)
	
	s msgDate="",msgTime="",msgDT=""
	
	s msgId="" //##class(websys.DHCMessageInterface).FindContentId("1000",adm,ordItem,reportID)
	//s ^cryze("msgfind")=$lb("1000",adm,ordItem,reportID,msgId)
	if msgId>0 {
		s msgDate=$lg(^websys.DHCMessageContentD(msgId),5),msgTime=$lg(^websys.DHCMessageContentD(msgId),6)
		s msgDT=##class(websys.Conversions).DateLogicalToHtml(msgDate)_" "_$zt(msgTime)
	}
	
	s patSMS="",SMSFlag="" //##class(web.DHCAntCVReportLink).GetLastPatSMS(reportID),SMSFlag="否"
	if $p(patSMS,"^",1)=1 s SMSFlag="是"
	else  if $p(patSMS,"^",1)=0 s SMSFlag="失败"
	
	s admCardNo="" //##class(web.DHCPATCardUnite).GetCardNoInfo(aPatientID)
	s admCardNo="" //$p($p(admCardNo,",",1)," ",2)
	
	s repTypeDesc=##class(web.DHCAntCVReportNameQuery).GetPanicName(repType)
	
	s mtsRepTime=..GetMTSRepTime(ordItem,"Html")
	
	s admDate=$P($G(^PAADM(adm)),"^",6),admTime=$P($G(^PAADM(adm)),"^",7)
	s admDT=##class(websys.Conversions).DateLogicalToHtml(admDate)_" "_$zt(admTime)
	
	s repStatusDesc=$case(repStatus,"F":"已处理","C":"未处理","Rec":"已接收","D":"已撤销",:"未处理")
	
	if useTrans=1,langId>0 {
		d TransData	
	}

	set Data=$lb(ReportId,DebtorNo,PatName,Species,DOB,Age,Location,Doctor,LabEpis,TestSet,MobPhone,ToPerson,TransMemo,TransDate,TransDTime,TransUser,repType,Adm,colorflag,DPRPDate,DPRPTime,CurrBed,MedCareNo,repResult,reportID,aPatientID,mradm,HasTransOrd,HasTransEMR,wardLocDesc,TransAdvice,repLoc,repUser,recUser,recDate,recTime,recContact,recTel,recMemo,recAdvice,admHosp,ordLoc,ordDoc,ordAddDT,msgDT,SMSFlag,admCardNo,repTypeDesc,transTimeUsedAlias,mtsRepTime,recTimeUsedAlias,recStatus,recStatusDesc,execStatus,execStatusDesc,oglLoc,admDT,repStatus,repStatusDesc,ordItem)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
TransData
	//对输出数据翻译
	s Location=##class(web.DHCAntCVComm).GetTranByDesc("User.CTLoc","CTLOCDesc",Location,langId)
	s Species=##class(web.DHCAntCVComm).GetTranByDesc("User.CTSex","CTSEXDesc",Species,langId)
	s Doctor=##class(web.DHCAntCVComm).GetTranByDesc("User.CTCareProv","CTPCPDesc",Doctor,langId)
	s TestSet=..GetOrdItems(ordItem,",",",",langId)
	s TransUser=##class(web.DHCAntCVComm).GetTranByDesc("User.SSUser","SSUSRName",TransUser,langId)
	s wardLocDesc=##class(web.DHCAntCVComm).GetTranByDesc("User.CTLoc","CTLOCDesc",wardLocDesc,langId)
	s repLoc=##class(web.DHCAntCVComm).GetTranByDesc("User.CTLoc","CTLOCDesc",repLoc,langId)
	s repUser=##class(web.DHCAntCVComm).GetTranByDesc("User.SSUser","SSUSRName",repUser,langId)
	s recUser=##class(web.DHCAntCVComm).GetTranByDesc("User.SSUser","SSUSRName",recUser,langId)
	s admHosp=##class(web.DHCAntCVComm).GetTranByDesc("User.CTHospital","HOSPDesc",admHosp,langId)
	s ordLoc=##class(web.DHCAntCVComm).GetTranByDesc("User.CTLoc","CTLOCDesc",ordLoc,langId)
	s ordDoc=##class(web.DHCAntCVComm).GetTranByDesc("User.CTCareProv","CTPCPDesc",ordDoc,langId)
	s repTypeDesc=##class(web.DHCAntCVComm).GetCVTypeTrans(repTypeDesc,langId)
	s transTimeUsedAlias=##class(web.DHCAntCVComm).TimeAliasTrans(transTimeUsedAlias,langId)
	s TransMemo=##class(web.DHCAntCVComm).GetConResultTrans(TransMemo,langId)
	s oglLoc=##class(web.DHCAntCVComm).GetTranByDesc("User.CTLoc","CTLOCDesc",oglLoc,langId)
	s recStatusDesc=##class(web.DHCAntCVComm).GetCVStatusTrans(recStatusDesc,langId)
	s execStatusDesc=##class(web.DHCAntCVComm).GetCVStatusTrans(execStatusDesc,langId)
	s repStatusDesc=##class(web.DHCAntCVComm).GetCVStatusTrans(repStatusDesc,langId)
	
	quit
}

/// 根据医嘱ID获取医嘱名称
/// OrdItemIds 可多个
/// idsep OrdItemIds 的分隔符 默认,
/// descsep 返回值的分隔符 默认,
ClassMethod GetOrdItems(OrdItemIds, idsep = ",", descsep = ",", langId = "")
{
	s ret=""
	s len=$l(OrdItemIds,idsep)
	for i=1:1:len{
		s ordItemId=$p(OrdItemIds,idsep,i)
		s ordPar=$p(ordItemId,"||",1)
		s ordSub=$p(ordItemId,"||",2)
		continue:(ordPar="")||(ordSub="")
		s str1=^OEORD(ordPar,"I",ordSub,1)
		s ItmMastDR = $p(str1,"^",2)
		s ordDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)	;医嘱名称
		if langId>0 s ordDesc=##class(web.DHCAntCVComm).GetTranByDesc("User.ARCItmMast","ARCIMDesc",ordDesc,langId)
		if ret="" s ret=ordDesc
		else  s ret=ret_descsep_ordDesc
	}
	q ret
}

ClassMethod GetOrdDocLoc(OrdItemId = "")
{
	s ordPar=+$p(OrdItemId,"||",1)
	s ordSub=+$p(OrdItemId,"||",2)
	q:(ordPar'>0)||(ordSub'>0) "^"
	s ordDoctorName="",ordDoctorUserDr=""
	i $d(^OEORD(ordPar,"I",ordSub,1)){
		s DoctorDr=$p(^OEORD(ordPar,"I",ordSub,1),"^",11)
		if DoctorDr>0 s ordDoctorName=$p(^CTPCP(DoctorDr,1),"^",2),ordDoctorUserDr = $o(^SSU("SSUSR",0,"CTPCP",DoctorDr,""))
	}
	s ordLocDesc=""
	s ordLoc = $p($g(^OEORD(ordPar,"I",ordSub,7)),"^",2)
	s:+ordLoc>0 ordLocDesc = $P($g(^CTLOC(ordLoc)),"^",2)
	if ordLocDesc["-" s ordLocDesc=$p(ordLocDesc,"-",2)
	q ordDoctorName_"^"_ordLocDesc
}

ClassMethod GetAllInfoObj(reportID = "")
{
	s useTrans=0,langId=20
 	if $d(%session),%session.Get("LOGON.LANGID")>0 s useTrans=1,langId=%session.Get("LOGON.LANGID")
 	
	s obj=##class(BSP.SYS.COM.ProxyObject).%New()
	s repType=$p(reportID,"||",1)
	s repLabno=$p(reportID,"||",2)
	s repOrder=$p(reportID,"||",3)
	if (repType="")||(repLabno="")||(repOrder="")||('$d(^DHCAntCVReport(repType,repLabno,repOrder))) {
		d obj.%Set("success",0)
		d obj.%Set("msg","错误的危急值ID")
		q obj.%ToJSON()
	}
	//==================危急值报告信息=============================================
	s (rowid,repInfo,repStatus,repDateDesc,repTime,repUser,repUserName)=""
	s rowid=repType_"||"_repLabno_"||"_repOrder
	s repInfo=$g(^DHCAntCVReport(repType,repLabno,repOrder))
	s repDate=$p(repInfo,"\",1)
	s repStatus=$p(repInfo,"\",9)
	s repDateDesc=##class(websys.Conversions).DateLogicalToHtml(repDate)
	s repTime=$p(repInfo,"\",2)
	s:repTime'="" repTime=$zt(repTime)
	s repUser=$p(repInfo,"\",3)
	if repUser>0 s repUserName=$p($g(^SSU("SSUSR",repUser)),"^",2)
	s repTypeDesc=##class(web.DHCAntCVReportNameQuery).GetPanicName(repType)
	d obj.%Set("rowid",rowid).%Set("repType",repType).%Set("repLabno",$replace(repLabno,"--","||")).%Set("repTypeDesc",repTypeDesc)
	d obj.%Set("repDateDesc",repDateDesc).%Set("repTime",repTime).%Set("repUserName",repUserName).%Set("repStatus",repStatus)
	
	
	//================危急值报告-报告内容==========================
	s repResult=$g(^DHCAntCVReport(repType,repLabno,repOrder,"Result"))
	d obj.%Set("repResult",repResult)
	
	
	//==================危急值报告-医嘱信息=============================================
	s (ordItm,ordDesc)=""
	s ordItm=$p(repInfo,"\",14)
	s ordDesc=..GetOrdItems(ordItm)
	s ordDocLoc=..GetOrdDocLoc(ordItm)
	s ordDocName=$p(ordDocLoc,"^",1)
	s ordLocDesc=$p(ordDocLoc,"^",2)
	s ordSpecName=""
	if repType=1 s ordSpecName=##class(web.DHCAntCVComm).GetSpecName(ordItm)
	d obj.%Set("ordItm",ordItm).%Set("ordDesc",ordDesc).%Set("ordDocName",ordDocName).%Set("ordLocDesc",ordLocDesc).%Set("ordSpecName",ordSpecName)
	

	//==================危急值报告-就诊信息=============================================
	s (EpisodeID,admType,admLoc,admLocDesc,admDoc,admDocName,admDate)=""
	s EpisodeID=$p(repInfo,"\",7)
	s admType=$p(^PAADM(EpisodeID),"^",2)
	s admLoc=$p(^PAADM(EpisodeID),"^",4)
	i admLoc>0 s admLocDesc=$p(^CTLOC(admLoc),"^",2)
	s admDoc=$p(^PAADM(EpisodeID),"^",9)
	i admDoc>0 s admDocName=$p(^CTPCP(admDoc,1),"^",2)
	s admDate=$P($G(^PAADM(EpisodeID)),"^",6)
	i admDate>0 s admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
	set mradm=$P(^PAADM(EpisodeID),"^",61)
	d obj.%Set("EpisodeID",EpisodeID).%Set("admType",admType).%Set("admLocDesc",admLocDesc).%Set("admLoc",admLoc)
	d obj.%Set("admDocName",admDocName).%Set("admDate",admDate).%Set("mradm",mradm)
	
	
	//==================危急值报告-病人信息=============================================
	s (PatientID,patName,sexDr,gender,age,DOB,PAPMINO)=""
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s patName=$p(^PAPER(PatientID,"ALL"),"^",1)
	s sexDr=$p(^PAPER(PatientID,"ALL"),"^",7)
	i sexDr>0 s gender=$p(^CT("SEX",sexDr),"^",2)
	s age=##class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID)
	s DOB=$p(^PAPER(PatientID,"ALL"),"^",6)
	i DOB>0 s DOB=##class(websys.Conversions).DateLogicalToHtml(DOB)
	s PAPMINO=$p(^PAPER(PatientID,"PAT",1),"^",1)
	s patPhone=$p(^PAPER(PatientID,"PER",1),"^",11)  //PAPER_TelH
	d obj.%Set("PatientID",PatientID).%Set("patName",patName).%Set("gender",gender).%Set("DOB",DOB)
	d obj.%Set("age",age).%Set("PAPMINO",PAPMINO).%Set("patPhone",patPhone)
	
	
	//======================危急值报告-病案号===================================
	s patMrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,admType,.ErrMsg)
	d obj.%Set("patMrNo",patMrNo)
	
	//==============================危急值报告-实际报告链接==========================================
	s reportUrl=""
	if repType=1 {
		s reportUrl=..GetLisReportUrl(ordItm)
	}
	d obj.%Set("reportUrl",reportUrl)
	
	
	if useTrans=1,langId>0 { //翻译
		s obj.repTypeDesc=##class(web.DHCAntCVComm).GetCVTypeTrans(repTypeDesc,langId)
		s obj.repUserName=##class(web.DHCAntCVComm).GetTranByDesc("User.SSUser","SSUSRName",repUserName,langId)
		s obj.ordDesc=..GetOrdItems(ordItm,",",",",langId)
		s obj.ordDocName=##class(web.DHCAntCVComm).GetTranByDesc("User.CTCareProv","CTPCPDesc",ordDocName,langId)
		s obj.ordLocDesc=##class(web.DHCAntCVComm).GetTranByDesc("User.CTLoc","CTLOCDesc",ordLocDesc,langId)
		s obj.admLocDesc=##class(web.DHCAntCVComm).GetTranByDesc("User.CTLoc","CTLOCDesc",admLocDesc,langId)
		s obj.admDocName=##class(web.DHCAntCVComm).GetTranByDesc("User.CTCareProv","CTPCPDesc",admDocName,langId)
		s obj.gender=##class(web.DHCAntCVComm).GetTranByDesc("User.CTSex","CTSEXDesc",gender,langId)
	}
	
	
	
	//==================危急值报告-处理记录=============================================
	set trArray=##class(BSP.SYS.COM.ProxyArray).%New()
	s trOrder=0 
	for {
		s trOrder=$o(^DHCAntCVReport(repType,repLabno,repOrder,"TR",trOrder))
		q:trOrder=""
		s (trContact,trPhone,trMemo,trDT,trDate,trTime,trUser,trUserId,trUserName,trStatus)=""
		if trOrder>0{
			s trInfo=$g(^DHCAntCVReport(repType,repLabno,repOrder,"TR",trOrder))
			s trDate=$p(trInfo,"\",1)
			s:trDate>0 trDate=##class(websys.Conversions).DateLogicalToHtml(trDate)
			s trTime=$p(trInfo,"\",2)
			s:trTime'="" trTime=$zt(trTime)
			s trUser=$p(trInfo,"\",3)
			if (trUser'="") s trUserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(trUser,"U"),""))
			if trUserId>0 s trUserName=$p(^SSU("SSUSR",trUserId),"^",2)
			s trContact=$p(trInfo,"\",5)
			s trPhone=$p(trInfo,"\",6)
			s trMemo=$p(trInfo,"\",7)
			s trStatus=$p(trInfo,"\",8)
			s trAdvice=$p(trInfo,"\",9)
			s trExecResult=$p(trInfo,"\",10)
			s trOpType=$p(trInfo,"\",16)
			
			if useTrans=1,langId>0 {
				s trUserName=##class(web.DHCAntCVComm).GetTranByDesc("User.SSUser","SSUSRName",trUserName,langId)	
			}
			
			s trObj=##class(BSP.SYS.COM.ProxyObject).%New()
			d trObj.%Set("trUserName",trUserName).%Set("trDate",trDate).%Set("trTime",trTime)
			d trObj.%Set("trContact",trContact).%Set("trPhone",trPhone).%Set("trMemo",trMemo).%Set("trStatus",trStatus)
			d trObj.%Set("trAdvice",trAdvice).%Set("trExecResult",trExecResult).%Set("trOpType",trOpType)
			d trArray.%Push(trObj)
		}
	}
	d obj.%Set("transArray",trArray)
	
	d obj.%Set("success",1)
	q obj
}

/// w ##class(web.DHCAntCVReportHX).GetAllInfo("1||10000000020||1")
ClassMethod GetAllInfo(reportID = "")
{
	s obj=..GetAllInfoObj(reportID)
	q obj.%ToJSON()
}

ClassMethod GetReportUrl(reportID)
{
}

/// w ##class(web.DHCAntCVReportHX).GetLisReportUrl("293||1")
ClassMethod GetLisReportUrl(OrdItemId)
{
	S ordPar=+$P(OrdItemId,"||",1)
	S ordSub=+$P(OrdItemId,"||",2)
	q:(ordPar'>"")&&(ordSub'>"") ""
	
	S VisitNumberTestSetDR=$P($G(^OEORD(ordPar,"I",ordSub,3)),"^",35)
	Q:'$L(VisitNumberTestSetDR) ""	//标本未接收
	s VisitNumberDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),2)
	Q:'$L(VisitNumberDR) "" //检验科室未接收
	s VsisitNumData=$G(^dbo.RPVisitNumberD(VisitNumberDR))
	
	s WorkGroupMachineDR=$lg($g(^dbo.RPVisitNumberTestSetD(VisitNumberTestSetDR)),5)
	s (OrderNo,ReportDR,reportStatus)=""
	i $l(WorkGroupMachineDR) s OrderNo=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,""))
	i $l(OrderNo) s ReportDR=$o(^dbo.RPVisitNumberReportI("IndexReportID",VisitNumberDR,WorkGroupMachineDR,OrderNo,"")) 	
    i $l(ReportDR) S reportStatus=$LG($g(^dbo.RPVisitNumberReportD(ReportDR)),22)
	I reportStatus="3" {
		S url="jquery.easyui.dhclabreport.csp?PatientBanner=1&VisitNumberReportDR="_ReportDR
		S url=url_"&OrderID="_OrdItemId
		q url
	}
	q ""
}

ClassMethod GetCVProcessObj(reportID) As BSP.SYS.COM.ProxyArray
{
	s useTrans=0,langId=20
 	if $d(%session),%session.Get("LOGON.LANGID")>0 s useTrans=1,langId=%session.Get("LOGON.LANGID")
	s arr=##class(BSP.SYS.COM.ProxyArray).%New()
	
	s repType=$p(reportID,"||",1)
	s repLabno=$p(reportID,"||",2)
	s repOrder=$p(reportID,"||",3)
	q:(repType="")||(repLabno="")||(repOrder="")||('$d(^DHCAntCVReport(repType,repLabno,repOrder))) arr
	
	s repInfo=^DHCAntCVReport(repType,repLabno,repOrder)
	s ordItem=$p(repInfo,"\",14)
	s ordItemDesc=..GetOrdItems(ordItem)
	s ordPar=+$p(ordItem,"||",1),ordSub=+$p(ordItem,"||",2)
	s ordDoctorName=""
	i $d(^OEORD(ordPar,"I",ordSub,1)){
		s DoctorDr=$p(^OEORD(ordPar,"I",ordSub,1),"^",11)
		if DoctorDr>0 s ordDoctorName=$p(^CTPCP(DoctorDr,1),"^",2)
	}
	s ordLocDesc=""
	s ordLoc = $p($g(^OEORD(ordPar,"I",ordSub,7)),"^",2)
	s:+ordLoc>0 ordLocDesc = $P($g(^CTLOC(ordLoc)),"^",2)
	if ordLocDesc["-" s ordLocDesc=$p(ordLocDesc,"-",2)
	s ordDate=$p($g(^OEORD(ordPar,"I",ordSub,3)),"^",7)
	s ordTime=$p(^OEORD(ordPar,"I",ordSub,1),"^",17)
	
	
	if useTrans=1,langId>0 {
		s ordItemDesc=..GetOrdItems(ordItem,",",",",langId)
	}
	s item=##class(BSP.SYS.COM.ProxyObject).%New()
	s item.title="开医嘱",item.state=1,item.date=##class(websys.Conversions).DateLogicalToHtml(ordDate),item.time=$zt(ordTime)
	s item.user=ordDoctorName,item.loc=ordLocDesc,item.note=ordItemDesc,item.note1="",item.code="AP" //定义code用于 闭环
	d arr.%Push(item)
	
	s repDate=$p(repInfo,"\",1),repTime=$p(repInfo,"\",2),repUser=$p(repInfo,"\",3)
	s repUser=$p($g(^SSU("SSUSR",repUser)),"^",2)
	s repLoc=$p(^OEORD(ordPar,"I",ordSub,3),"^",6) //医嘱接受科室
	s:repLoc>0 repLoc = $P($g(^CTLOC(repLoc)),"^",2)
	if repLoc["-" s repLoc=$p(repLoc,"-",2)
	
	s item=##class(BSP.SYS.COM.ProxyObject).%New()
	s item.title="危急值报告",item.state=1,item.date=##class(websys.Conversions).DateLogicalToHtml(repDate),item.time=$zt(repTime)
	s item.user=repUser,item.loc=repLoc,item.note="",item.note1="",item.code="RP"
	d arr.%Push(item)
	
	s trOrder=0,preRepStatus="C"
	for {
		s trOrder=$o(^DHCAntCVReport(repType,repLabno,repOrder,"TR",trOrder))
		q:trOrder=""
		s trInfo=^DHCAntCVReport(repType,repLabno,repOrder,"TR",trOrder)
		s trDate=$p(trInfo,"\",1),trTime=$p(trInfo,"\",2),trUserCode=$p(trInfo,"\",3),trUserId="",trUserName=""
		s:trUserCode'="" trUserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(trUserCode),""))
		s:trUserId>0 trUserName=$p(^SSU("SSUSR",trUserId),"^",2)
		s trExecResult=$p(trInfo,"\",10)
		s trExecResultDesc=$p(trInfo,"\",7)
		s trOpType=$p(trInfo,"\",16)
		s trOpDesc=$case(trOpType,"Rec":"接收","E":"处理","FwD":"转发","D":"撤销","":"处理",:trOpType)
		s code=$case(trOpType,"Rec":"REC","E":"EXEC","FwD":"FWD","D":"DEL","":"EXEC",:trOpType)
		

		
		s state=1 
		if trOpType="D" s state=2
		s note=$p(trInfo,"\",9),note1=""
		if (trOpType="Rec")||(trOpType="E") {
			s note1=trExecResultDesc_"："_$p(trInfo,"\",5)_","_$p(trInfo,"\",6)
			if useTrans,langId>0 {
				s note1=##class(web.DHCAntCVComm).GetConResultTrans(trExecResultDesc,langId)_"："_$p(trInfo,"\",5)_","_$p(trInfo,"\",6)
			}	
		}
		if (trOpType="FwD"){
			s fwLocDr=$p(trInfo,"\",17),fwLocDesc=$p($g(^CTLOC(+fwLocDr)),"^",2),fwLocDesc=$p(fwLocDesc,"-",$l(fwLocDesc,"-"))
			s fwUserDr=$p(trInfo,"\",18),fwUserName=$p($g(^SSU("SSUSR",+fwUserDr)),"^",2)
			s fwUserDr2=$p(trInfo,"\",19),fwUserName2=$p($g(^SSU("SSUSR",+fwUserDr2)),"^",2)
			s note1="转发至："_fwLocDesc_" "_fwUserName_$s(fwUserName2="":"",1:","_fwUserName2)
			
			if useTrans=1,langId>0 {
				s note1=##class(web.DHCAntCVComm).GetPageTrans("criticalvalue.process.csp","转发至：",langId)
				_##class(web.DHCAntCVComm).GetTranByDesc("User.CTLoc","CTLOCDesc",fwLocDesc,langId)_" "
				_##class(web.DHCAntCVComm).GetTranByDesc("User.SSUser","SSUSRName",fwUserName,langId)_$s(fwUserName2="":"",1:",")
				_##class(web.DHCAntCVComm).GetTranByDesc("User.SSUser","SSUSRName",fwUserName2,langId)	
			}
			
		}
		s trLoc=$p(trInfo,"\",11)
		s:trLoc>0 trLoc = $P($g(^CTLOC(trLoc)),"^",2)
		if trLoc["-" s trLoc=$p(trLoc,"-",2)
		
		s item=##class(BSP.SYS.COM.ProxyObject).%New()
		s item.title=trOpDesc,item.state=state,item.date=##class(websys.Conversions).DateLogicalToHtml(trDate),item.time=$zt(trTime)
		s item.user=trUserName,item.loc=trLoc,item.note=note,item.note1=note1,item.code=code
		d arr.%Push(item)
	}
	
	s confirmExecInfo=##class(web.DHCAntCVReportLink).GetFirstTPSConfirmExec(reportID)
	if confirmExecInfo'="" {
		s ceDate=$p(confirmExecInfo,"^",3),ceTime=$p(confirmExecInfo,"^",4),ceUserID=$p(confirmExecInfo,"^",2)
		s ceUser=$p($g(^SSU("SSUSR",+ceUserID)),"^",2),ceLoc=repLoc //确认科室和报告科室一样
		s item=##class(BSP.SYS.COM.ProxyObject).%New()
		s item.title="确认",item.state=1,item.date=##class(websys.Conversions).DateLogicalToHtml(ceDate),item.time=$zt(ceTime)
		s item.user=ceUser,item.loc=ceLoc,item.note="",item.note1="",item.code="TPSCE"  //第三方确认收到临床处理信息
		d arr.%Push(item)	
		
	}
	
	if useTrans=1,langId>0 {
		s len=arr.%Size()
		for i=1:1:len {
			s item=arr.%Get(i)
			if item.user'="" s item.user=##class(web.DHCAntCVComm).GetTranByDesc("User.SSUser","SSUSRName",item.user,langId)	
			if item.loc'="" s item.loc=##class(web.DHCAntCVComm).GetTranByDesc("User.CTLoc","CTLOCDesc",item.loc,langId)
			if item.title'="" s item.title=##class(web.DHCAntCVComm).GetProcessTrans(item.title,langId)
		}	
	}
	
	q arr
}

ClassMethod GetCVProcess(reportID)
{
	s arr=..GetCVProcessObj(reportID)
	
	q arr.%ToJSON()
}

ClassMethod GetMTSRepTime(OEOrdItemID, rettype = "")
{
	s OEOrdItemID=$p(OEOrdItemID,",",1),date="",time=""
	q:OEOrdItemID="" ""
	&sql( select top 1 ES_OperateDate,ES_OperateTime into :date,:time from SQLUser.ENS_StatusLog where ES_OrdItemID=:OEOrdItemID and ES_OperateCode='RP' order by ES_OperateDate desc,ES_OperateTime desc )
	if date>0,time'="" {
		if rettype="Logic" q date_","_time
		if rettype="Html" q ##class(websys.Conversions).DateLogicalToHtml(date)_" "_$zt(time)
		if rettype="3" q $zd(date,3)_" "_$zt(time)
		if rettype="4" q $zd(date,4)_" "_$zt(time)
		q ""
	}else{
		q ""	
	}
}

}
