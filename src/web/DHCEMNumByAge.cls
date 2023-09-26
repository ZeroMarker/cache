/// Descript:   病人统计:体温大于38的年龄段个数统计，其中，儿科为小于14，其它为内科，并且只统计社保医保卡，不统计虚拟卡
/// Creator:    huaxiaoying
/// CreateDate: 2018-07-29
Class web.DHCEMNumByAge Extends %RegisteredObject
{

Query admNumQuery(stDate, edDate, HOSPID) As %Query(ROWSPEC = "CurDate:%String,numOne:%String,numTwo:%String,numThree:%String,numFour:%String,numFive:%String,numSix:%String,numSeven:%String") [ SqlProc ]
{
}

ClassMethod admNumQueryExecute(ByRef qHandle As %Binary, stDate, edDate, HOSPID) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCEMNumByAge","admNumQuery","2018-07-04","2018-07-30")
 	
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
	i (stDate="")||(edDate="" ) d
	.Set qHandle=$lb(0,repid,0)
 	i (stDate="")||(edDate="" ) Quit $$$OK
    set ind=1
	
  	//编码开始
  	
  	s stDate=$zdh(stDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(stDate)
  	s edDate=$zdh(edDate,3) ;##class(web.DHCEMCommonUtil).DateHtmlToLogical(edDate)
  	s lastDate=edDate //hxy 2018-07-30
  	s firstDate=stDate //hxy 2018-07-30
  	
	f Date=stDate:1:edDate  d 
	.s numOne=0,numTwo=0,numThree=0,numFour=0,numFive=0,numSix=0,numSeven=0
	.s PCLDr = 0
	.f  s PCLDr = $o(^DHCEMPCL(0,"CreateDate",Date,PCLDr)) q:PCLDr=""  d
	..s PAPMIDr=$p(^DHCEMPCL(PCLDr),"^",1)      /// 病人ID PatientID
	..q:'$d(^PAPER(PAPMIDr))            /// 过滤错误数据
    ..s PCLNurseLevel=$p(^DHCEMPCL(PCLDr),"^",7) //护士分级
    ..q:+PCLNurseLevel=0
    ..s PatLocID=$p(^DHCEMPCL(PCLDr),"^",10) //hxy 2020-06-10 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:CurHospID'=HOSPID //ed
    ..s PCLCreateDate=$p(^DHCEMPCL(PCLDr),"^",4)  ///分诊日期
    ..s PCLCreateTime=$p(^DHCEMPCL(PCLDr),"^",5)  ///分诊时间
    ..;w PCLCreateDate_"*"_PCLCreateTime_"*"_$zth("07:00",3),!
    ..;i Date=lastDate q:PCLCreateTime>$zth("07:00",3) //最后一天为零点到7点 //hxy 2018-07-30 //hxy 2018-08-07
    ..;i Date=firstDate q:PCLCreateTime<$zth("07:00",3) //第一天为7点到24点 //hxy 2018-07-30 //hxy 2018-08-07
    
    ..s CardNoID=$o(^DHCCARDi("CF",0,"PAPMIDR",PAPMIDr,""),-1)
    ..;q:CardNoID="" /// 过滤错误数据
	..;s CardTypeID=$p($g(^DHCCARD("CF",CardNoID)),"^",16) 	 
	..;s CardType=$p(^DHCCARDTYPEDef(CardTypeID),"^", 2) /// 卡类型
	..;q:CardType'="社保身份证"
	..s EmPatChkSignStr=##class(web.DHCEMPatCheckLevQuery).GetEmPatChkSign(PCLDr)      /// 生命体征
    ..s T=$p(EmPatChkSignStr,"@",2)
    ..Q:T=""
    ..i T'="" Q:T<=38
	..s Age=##class(web.DHCEMCommonUtil).GetPapmiAgeByPatCheckLevID(PCLDr)  /// 年龄:根据病人ID
	..i Age'["岁" d
	...s numThree=numThree+1 //0-4岁
	...s numTwo=numTwo+1 //儿科：<14
	..e  d
	...s Age=$p(Age,"岁",1)
	...i Age>14 s numOne=numOne+1 //内科：>14 
	...i Age<=4 s numThree=numThree+1 //0-4岁
	...i Age<=14 s numTwo=numTwo+1 //儿科：<14
	...i (Age>=5)&&(Age<=13) s numFour=numFour+1 //5-13
    ...i (Age>=14)&&(Age<=24) s numFive=numFive+1 //14-24
	...i (Age>=25)&&(Age<=59) s numSix=numSix+1 //25-59
	...i (Age>=60) s numSeven=numSeven+1 //60+
	..;w Age,!
	.s CurDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(Date)

    .d OutputRow1
    
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(CurDate,numOne,numTwo,numThree,numFour,numFive,numSix,numSeven)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod admNumQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = admNumQueryExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod admNumQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = admNumtQueryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

}
