Class EPRservice.LISInterface.DALISInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##Class(EPRservice.LISInterface.DALISInfo).TestLoop()
ClassMethod TestLoop()
{
	f i=1:1:10 d
	.if i < 5 q
	.if (i >5),(i<7) q
	.w !,i
}

///  Creator：      Liuzf
///  CreatDate：    20110425
///  Description:： 查询出一定时间范围内指定登记号和就诊号病人的指定检验信息
///  Table：        EP_VisitNumber,EP_VisitTestSet,EP_VisitTestSetData
///  Input：        GUID:唯一标识数字；
///                 Debtor:登记号
///                 AdmID:就诊号
///                 DateList:查询时间范围报告审核日期 2011-1-1 4:00:00^2011-1-12 14:00:00
///                 TCSyn:查询检验项目别名 BWBC 
///  Output：     ^CacheTemp(“DataExtraction”,唯一标识,RegNo,AdmId,”Test”,TestName, RptTime, 项目名称) =值
///               ^CacheTemp(“DataExtraction”,963,”00001234”,”32145”,”Test”,”BWBC”,”2010-7-2 14:08:34”,”Result”)=3.4
///               ^CacheTemp(“DataExtraction”,963,”00001234”,”32145”,”Test”,”BWBC”,”2010-7-2 14:08:34”,”OrdTime”)=2010-7-1 14:07:01
///               ^CacheTemp(“DataExtraction”,963,”00001234”,”32145”,”Test”,”BWBC”,”2010-7-2 14:08:34”,”SampleTime”)=2010-7-1 14:07:01
///               ^CacheTemp(“DataExtraction”,963,”00001234”,”32145”,”Test”,”BWBC”,”2010-7-2 14:08:34”,”RptTime”)=2010-7-1 14:07:01
///  Return：        
///  Others：      
/// w ##Class(web.DHCLabInterfaceEPR).GetLabAdmReuslt(9999,"0000154183",123,"2010-9-12 00:00:00^2011-1-1 23:59:59","WBC")
/// w ##Class(web.DHCLabInterfaceEPR).GetLabAdmReuslt("DataExtraction","08362518","5727865","2011-5-18 00:00:00^2011-5-19 00:00:00","PLT")
ClassMethod GetLabAdmReuslt(GUID As %String, Debtor As %String, AdmID As %String, DateList As %String, TCSyn As %String) As %String
{
	
	i '$l(GUID) Quit 0
    Kill ^TMP($zn,$j)
	Set GUID=$g(GUID),Debtor=$g(Debtor),AdmID=$g(AdmID),DateList=$g(DateList),TCSyn=$g(TCSyn)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set LabData=Config.LabDataNamespace
    iF '$L(LabData) s LabData="LABDATA"
    Do Config.%Close()
   	Set WebNS=$ZUTIL(5)
   	s FromDate=$p($p(DateList,"^",1)," ",1),FromTime=$p($p(DateList,"^",1)," ",2)
   	s ToDate=$p($p(DateList,"^",2)," ",1),ToTime=$p($p(DateList,"^",2)," ",2)
   	i $l(FromDate) s FromDate=$zdh(FromDate,3),FromTime=$zth(FromTime,3)
   	i $l(ToDate) s ToDate=$zdh(ToDate,3),ToTime=$zth(ToTime,3)
    ///
    k TCLIST
    Set tc="" For  Set tc=$Order(^[LabData]TTABi("TC","NNL",TCSyn,tc)) Quit:tc=""  Do
    .s TCLIST(tc)=""
    i '$d(TCLIST) q
    ///
    s TC="" f  s TC=$o(^[LabData]TDHCOldResult(1,Debtor,TC),-1) q:(TC="")  d
    .//s CurTCSyn=$p($g(^[LabData]TTAB("TC",TC)),"\",12)
    .//i '$l(CurTCSyn) Quit
    .//i TCSyn'=CurTCSyn Quit
    .i '$d(TCLIST(TC)) q
    .//f Date=FromDate:1:ToDate d
    .s Date="" f  s Date=$o(^[LabData]TDHCOldResult(1,Debtor,TC,Date),-1) q:(Date="")  d
    ..i (FromDate '= "")&&(Date < FromDate) q
    ..i (ToDate '= "")&&(Date > ToDate) q
    ..s Time="" f  s Time=$o(^[LabData]TDHCOldResult(1,Debtor,TC,Date,Time),-1) q:(Time="")  d
	...i (FromDate'="")&&(Date=FromDate)&&(Time<FromTime) q
	...i (ToDate'="")&&(Date=ToDate)&&(Time>ToTime) q
    ...s labno="" f  s labno=$o(^[LabData]TDHCOldResult(1,Debtor,TC,Date,Time,labno)) q:labno=""  d
    ....s CurAdmID=$$EpisNoToAdm(labno)
    ....i AdmID'=CurAdmID Quit
    ....s ts=""  f  s ts=$o(^[LabData]TDHCOldResult(1,Debtor,TC,Date,Time,labno,ts)) q:ts=""  d
    .....s tscnt="" f  s tscnt=$o(^[LabData]TDHCOldResult(1,Debtor,TC,Date,Time,labno,ts,tscnt)) q:tscnt=""  d
    ......s tTEPITS=$g(^[LabData]TEPI(labno,1,ts,tscnt))
    ......s temres=$p(^[LabData]TEPI(labno,1,ts,tscnt,"DATA",TC),"\",1)
    ......i '$l(temres) q  
    ......s (authdate,authtime,reqdate,reqtime,coldate,coltime)=""
	......s reqdate=$p(^[LabData]TEPI(labno),"\",12)  ;申请时间
	......s reqtime=$p(^[LabData]TEPI(labno),"\",50)
    ......i reqdate'="" s reqdate=$zd(reqdate,3)
    ......i reqtime'="" s reqtime=$zt(reqtime) 
    ......s authdate=$p(tTEPITS,"\",4)  ;报告时间
    ......s authtime=$p(tTEPITS,"\",5)
    ......i authdate'="" s authdate=$zd(authdate,3) ;核实日期
    ......i authtime'="" s authtime=$zt(authtime*60) ;核实时间
    ......s coldate=$p(tTEPITS,"\",44) ;采集时间
    ......s coltime=$p(tTEPITS,"\",45)
    ......i coldate'="" s coldate=$zd(coldate,3)
    ......i coltime'="" s coltime=$zt(coltime) 
    ......s (tsname,temresdesc)=""
    ......i $d(^[LabData]TTAB("TC",TC)) s tsname=$P(^[LabData]TTAB("TC",TC),"\",1)
    ......s temresdesc=temres 
    ......s itmtype=$p(^[LabData]TTAB("TC",TC),"\",3)
    ......;标准备注
    ......i (itmtype["S"),$d(^[LabData]TTAB("TC",TC,2,temres,1)) s temresdesc=$g(^[LabData]TTAB("TC",TC,2,temres,1))
    ......;血型
    ......i itmtype["B",$d(^[LabData]TTAB("BB-BG",temres)) s temresdesc=$p(^[LabData]TTAB("BB-BG",temres),"\",1)
    ......///细菌
    ......i itmtype="V",$d(^[LabData]TTAB("BUG",temres)) s temresdesc=$p(^[LabData]TTAB("BUG",temres),"\",1)
    ......s RptTime=authdate_" "_authtime
    ......s ^CacheTemp("DataExtraction",GUID,Debtor,AdmID,"Test",TCSyn,RptTime,"Result")=temresdesc
    ......s ^CacheTemp("DataExtraction",GUID,Debtor,AdmID,"Test",TCSyn,RptTime,"OrdTime")=reqdate_" "_reqtime
    ......s ^CacheTemp("DataExtraction",GUID,Debtor,AdmID,"Test",TCSyn,RptTime,"SampleTime")=coldate_" "_coltime
    ......s ^CacheTemp("DataExtraction",GUID,Debtor,AdmID,"Test",TCSyn,RptTime,"RptTime")=RptTime
	q 0
	
EpisNoToAdm(LabNo)
  s LabNo=$g(LabNo),CurAdm=""
  i $d(^OEORD(0,"EpisNo",LabNo)) d
  .s OrdItmId=$o(^OEORD(0,"EpisNo",LabNo,""))
  .s CurAdm=$p(^OEORD(OrdItmId),"^",1)
  q CurAdm
}

Query GetLabReuslt(Debtor As %String, AdmID As %String, DateList As %String, TCSyn As %String) As %Query(ROWSPEC = "Result:%String,Spliter:%String,ItemUnit:%String,OrderDateTime:%String,SampleDateTime:%String,ReportDateTime:%String")
{
}

ClassMethod GetLabReusltExecute(ByRef qHandle As %Binary, Debtor As %String, AdmID As %String, DateList As %String, TCSyn As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	
	//d SetData("1","2","3","4")
	//q $$$OK
	
	///////////
	//i '$l(GUID) Quit 0
    //Kill ^TMP($zn,$j)
	Set Debtor=$g(Debtor),AdmID=$g(AdmID),DateList=$g(DateList),TCSyn=$g(TCSyn)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set LabData=Config.LabDataNamespace
    iF '$L(LabData) s LabData="LABDATA"
    Do Config.%Close()
   	Set WebNS=$ZUTIL(5)
   	s FromDate=$p($p(DateList,"^",1)," ",1),FromTime=$p($p(DateList,"^",1)," ",2)
   	s ToDate=$p($p(DateList,"^",2)," ",1),ToTime=$p($p(DateList,"^",2)," ",2)
   	i $l(FromDate) s FromDate=$zdh(FromDate,3),FromTime=$zth(FromTime,3)
   	i $l(ToDate) s ToDate=$zdh(ToDate,3),ToTime=$zth(ToTime,3)
    ///
    k TCLIST
    Set tc="" For  Set tc=$Order(^[LabData]TTABi("TC","NNL",TCSyn,tc)) Quit:tc=""  Do
    .s TCLIST(tc)=""
    i '$d(TCLIST) 
    {
	    //b "s"
	    q $$$OK
    }
    ///
    s TC="" f  s TC=$o(^[LabData]TDHCOldResult(1,Debtor,TC),-1) q:(TC="")  d
    .//s CurTCSyn=$p($g(^[LabData]TTAB("TC",TC)),"\",12)
    .//i '$l(CurTCSyn) Quit
    .//i TCSyn'=CurTCSyn Quit
    .i '$d(TCLIST(TC)) q
    .//f Date=FromDate:1:ToDate d
    .s Date="" f  s Date=$o(^[LabData]TDHCOldResult(1,Debtor,TC,Date),-1) q:(Date="")  d
    ..i (FromDate '= "")&&(Date < FromDate) q
    ..i (ToDate '= "")&&(Date > ToDate) q
    ..s Time="" f  s Time=$o(^[LabData]TDHCOldResult(1,Debtor,TC,Date,Time),-1) q:(Time="")  d
	...i (FromDate'="")&&(Date=FromDate)&&(Time<FromTime) q
	...i (ToDate'="")&&(Date=ToDate)&&(Time>ToTime) q
    ...s labno="" f  s labno=$o(^[LabData]TDHCOldResult(1,Debtor,TC,Date,Time,labno)) q:labno=""  d
    ....s CurAdmID=$$EpisNoToAdm(labno)
    ....i AdmID'=CurAdmID Quit
    ....s ts=""  f  s ts=$o(^[LabData]TDHCOldResult(1,Debtor,TC,Date,Time,labno,ts)) q:ts=""  d
    .....s tscnt="" f  s tscnt=$o(^[LabData]TDHCOldResult(1,Debtor,TC,Date,Time,labno,ts,tscnt)) q:tscnt=""  d
    ......s tTEPITS=$g(^[LabData]TEPI(labno,1,ts,tscnt))
    ......s temres=$p(^[LabData]TEPI(labno,1,ts,tscnt,"DATA",TC),"\",1)
    ......i '$l(temres) q  
    ......s (authdate,authtime,reqdate,reqtime,coldate,coltime)=""
	......s reqdate=$p(^[LabData]TEPI(labno),"\",12)  ;申请时间
	......s reqtime=$p(^[LabData]TEPI(labno),"\",50)
    ......i reqdate'="" s reqdate=$zd(reqdate,3)
    ......i reqtime'="" s reqtime=$zt(reqtime) 
    ......s authdate=$p(tTEPITS,"\",4)  ;报告时间
    ......s authtime=$p(tTEPITS,"\",5)
    ......i authdate'="" s authdate=$zd(authdate,3) ;核实日期
    ......i authtime'="" s authtime=$zt(authtime*60) ;核实时间
    ......s coldate=$p(tTEPITS,"\",44) ;采集时间
    ......s coltime=$p(tTEPITS,"\",45)
    ......i coldate'="" s coldate=$zd(coldate,3)
    ......i coltime'="" s coltime=$zt(coltime) 
    ......s (tsname,temresdesc)=""
    ......i $d(^[LabData]TTAB("TC",TC)) s tsname=$P(^[LabData]TTAB("TC",TC),"\",1)
    ......s temresdesc=temres 
    ......s itmtype=$p(^[LabData]TTAB("TC",TC),"\",3)
    ......;标准备注
    ......i (itmtype["S"),$d(^[LabData]TTAB("TC",TC,2,temres,1)) s temresdesc=$g(^[LabData]TTAB("TC",TC,2,temres,1))
    ......;血型
    ......i itmtype["B",$d(^[LabData]TTAB("BB-BG",temres)) s temresdesc=$p(^[LabData]TTAB("BB-BG",temres),"\",1)
    ......///细菌
    ......i itmtype="V",$d(^[LabData]TTAB("BUG",temres)) s temresdesc=$p(^[LabData]TTAB("BUG",temres),"\",1)
    ......s RptTime=authdate_" "_authtime
    ......///返回值
    ......s labDate = $P(^[LabData]TEPI(labno),"\",10)
    ......s itemUnit = ..GetTCUnitByDate(TC,labDate, LabData)
    ......s spliter = ..GetSpliter(itemUnit)
    ......s resultDesc = temresdesc
    ......s orderDateTime = reqdate_" "_reqtime
    ......s sampleDateTime =coldate_" "_coltime
    ......s reportDateTime = RptTime
	......d SetData(resultDesc, spliter, itemUnit, orderDateTime, sampleDateTime, reportDateTime)
	//b "s"
	Quit $$$OK
	
	
	
EpisNoToAdm(LabNo)
  s LabNo=$g(LabNo),CurAdm=""
  i $d(^OEORD(0,"EpisNo",LabNo)) d
  .s OrdItmId=$o(^OEORD(0,"EpisNo",LabNo,""))
  .s CurAdm=$p(^OEORD(OrdItmId),"^",1)
  q CurAdm

	
SetData(resultDesc, spliter, itemUnit, orderDateTime, sampleDateTime, reportDateTime)
	set ^CacheTemp(repid, ind) = $LB(resultDesc,spliter,itemUnit,orderDateTime,sampleDateTime,reportDateTime)
	set ind =  ind + 1
}

ClassMethod GetLabReusltFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLabReusltExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

ClassMethod GetLabReusltClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLabReusltExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
	Quit $$$OK
}

ClassMethod GetTCUnitByDate(tc, date, LabData) As %String
{
	;table CT_TestCodePrevUnits
  s tc=$g(tc),date=$g(date)
  i '$l(tc) q ""
  i '$l(date) s date=+$h
  s date=date+1
  s last=$o(^[LabData]TTAB("TC",tc,6,""),-1)
  q:($Data(^[LabData]TTAB("TC",tc))'=1)&($Data(^[LabData]TTAB("TC",tc))'=11) ""
  s unit=$p(^[LabData]TTAB("TC",tc),"\",2)
  i date>last s last="" q unit
  i $d(^[LabData]TTAB("TC",tc,6,date)) q $p(^[LabData]TTAB("TC",tc,6,date),"\",1) 
  s last=date s last=$o(^[LabData]TTAB("TC",tc,6,last)) ; q:(last<date)!(last="")
  ;i last="" s last=$o(^TTAB("TC",tc,6,""))
  q $p(^[LabData]TTAB("TC",tc,6,last),"\",1)
}

ClassMethod GetSpliter(itemUnit) As %String
{
	q:(itemUnit = "")||(itemUnit = $C(0)) ""
	s char = $E(itemUnit,1,1)
	q:(char?1N) "*"
	q ""
}

/// d ##Class().Test()
ClassMethod Test()
{
	s p1 = ""
	s p2 = ""
	s p3 = ""
	s p4 = ""
	
	// Create a Result object for the Sample.Person:ByName query
 Set rset = ##class(%ResultSet).%New("EPRservice.LISInterface.DALISInfo:GetLabReuslt")
 Set columns = rset.GetColumnCount()

 // Execute the query
 Set sc = rset.Execute(p1,p2,p3,p4)

 // Now fetch the results
 While (rset.Next()) {
 Write "------------------------",!
 For col = 1:1:columns {
 Write rset.GetColumnName(col),": "
 Write rset.GetData(col),!
 }
 Write "------------------------"
 }
 Do rset.Close()
}

}
