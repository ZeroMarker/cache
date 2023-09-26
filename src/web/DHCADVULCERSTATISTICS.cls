Import sqluser

Class web.DHCADVULCERSTATISTICS Extends %Persistent [ Not ProcedureBlock ]
{

/// creator:dws
/// 2017-09-26
/// Descript:获取不良事件年份
/// d ##class(%ResultSet).RunQuery("web.DHCADVULCERSTATISTICS","getAdvYear")
ClassMethod getAdvYearExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s year=$p(##class(web.DHCADVCOMMON).DateLogicalToHtml($p($h,",")),"-") ;年份
	d OutputYear
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutputYear
	s data=$lb(year)
 	s ^CacheTemp(repid,ind)=data
 	s ind=ind+1
}

Query getAdvYear() As websys.Query(ROWSPEC = "year:%Integer") [ SqlProc ]
{
}

/// creator:dws AssessmentBut
/// 2017-09-21
/// Descript:获取压疮事件发生比率
/// d ##class(%ResultSet).RunQuery("web.DHCADVULCERSTATISTICS","getAdvUlcerRate","2016")
ClassMethod getAdvUlcerRateExecute(ByRef qHandle As %Binary, year As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s month="",leapYearSecMon=""
	s hapNum="",result="",proportion="0.00"
	s DateFormat = ##class(websys.Conversions).DateFormat() //日期格式
	s Date=##class(web.DHCADVCOMMON).DateLogicalToHtml($p($h,",")) //当前日期
	i DateFormat="1"  d //MDY
	.i Date["/" s:year="" year=$p(Date,"/",3) //以"/"截取字符，获取年份
	i DateFormat="3"  d  //YMD
	.i Date["-" s:year="" year=$p(Date,"-",1) //以"-"截取字符，获取年份
    i DateFormat="4"  d  //DMY
	.i Date["/" s:year="" year=$p(Date,"/",3) //以"/"截取字符，获取年份
	s leap=year/4
	s:leap["." leapYearSecMon="28"
	s:leap'["." leapYearSecMon="29"
	f i=1:1:13 d
	.s month=i
	.s:month=1 hapNum=..getEveMonHapNum(year_"-01-01",year_"-01-31"),result=..getEveMonInHosPat(year_"-01-01",year_"-01-31")
	.s:month=2 hapNum=..getEveMonHapNum(year_"-02-01",year_"-02-"_leapYearSecMon),result=..getEveMonInHosPat(year_"-02-01",year_"-02-"_leapYearSecMon)
	.s:month=3 hapNum=..getEveMonHapNum(year_"-03-01",year_"-03-31"),result=..getEveMonInHosPat(year_"-03-01",year_"-03-31")
	.s:month=4 hapNum=..getEveMonHapNum(year_"-04-01",year_"-04-30"),result=..getEveMonInHosPat(year_"-04-01",year_"-04-30")
	.s:month=5 hapNum=..getEveMonHapNum(year_"-05-01",year_"-05-31"),result=..getEveMonInHosPat(year_"-05-01",year_"-05-31")
	.s:month=6 hapNum=..getEveMonHapNum(year_"-06-01",year_"-06-30"),result=..getEveMonInHosPat(year_"-06-01",year_"-06-30")
	.s:month=7 hapNum=..getEveMonHapNum(year_"-07-01",year_"-07-31"),result=..getEveMonInHosPat(year_"-07-01",year_"-07-31")
	.s:month=8 hapNum=..getEveMonHapNum(year_"-08-01",year_"-08-31"),result=..getEveMonInHosPat(year_"-08-01",year_"-08-31")
	.s:month=9 hapNum=..getEveMonHapNum(year_"-09-01",year_"-09-30"),result=..getEveMonInHosPat(year_"-09-01",year_"-09-30")
	.s:month=10 hapNum=..getEveMonHapNum(year_"-10-01",year_"-10-31"),result=..getEveMonInHosPat(year_"-10-01",year_"-10-31")
	.s:month=11 hapNum=..getEveMonHapNum(year_"-11-01",year_"-11-30"),result=..getEveMonInHosPat(year_"-11-01",year_"-11-30")
	.s:month=12 hapNum=..getEveMonHapNum(year_"-12-01",year_"-12-31"),result=..getEveMonInHosPat(year_"-12-01",year_"-12-31")
	.s:month=13 month="合计",hapNum=..getEveMonHapNum(year_"-01-01",year_"-12-31"),result=..getEveMonInHosPat(year_"-01-01",year_"-12-31")
	.i (hapNum'="0")&(result'="0") s proportion=($fn(("0"_(hapNum/result)),"",4))*100
	.i (hapNum="0")&(result'="0") s proportion="0"
	.i (result="0") s proportion="0.00"
	.d OutputAdvUlcerRate
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutputAdvUlcerRate
	s data=$lb(month,hapNum,result,proportion,year)
 	s ^CacheTemp(repid,ind)=data
 	s ind=ind+1
}

Query getAdvUlcerRate(year As %String) As websys.Query(ROWSPEC = "month:%String,hapNum:%Integer,result:%String,proportion:%Double,year:%Date") [ SqlProc ]
{
}

/// creator:dws
/// 2017-09-21
/// Descript:统计每个月在院患者总人数
/// w ##class(web.DHCADVULCERSTATISTICS).getEveMonInHosPat("2017-03-01","2017-03-31")
ClassMethod getEveMonInHosPat(stDate, endDate)
{
	n (stDate,endDate)
	s:stDate'="" stDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(stDate)
	s:endDate'="" endDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(endDate)
	s paAdmRowId="" 
	s num=0
	f date=stDate:1:endDate d
	.f  s paAdmRowId=$o(^PAADM(paAdmRowId)) q:paAdmRowId=""  d
	..s paAdmDate=$p(^PAADM(paAdmRowId),"^",6) ;就诊日期
	..q:paAdmDate'=date
	..s num=num+1
	q num
}

/// creator:dws
/// 2017-09-21
/// Descript:统计每个月发生压疮的人数
/// w ##class(web.DHCADVULCERSTATISTICS).getEveMonHapNum("2017-03-01","2017-03-31")
ClassMethod getEveMonHapNum(stDate, endDate)
{
	n (stDate,endDate)
	s:stDate'="" stDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(stDate)
	s:endDate'="" endDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(endDate)
	
	s formDicRowId="60912"
	s repLoc="",recordId="",createDate="",num=0
	&sql(declare curvendor cursor for select parrRef from DHC_AdvFormRecorditm where value=:formDicRowId)
 	&sql(open curvendor)
 	s n=1
 	f  &sql(fetch curvendor into :repLoc(n))   q:SQLCODE  d 
    .s n=n+1
 	&sql(close curvendor)
 	s len=n-1
 	f date=stDate:1:endDate d
 	.f i=1:1:len d
 	..s recordId= repLoc(i)
 	..s createDate=$lg($g(^User.FormRecordD(recordId)),4)
 	..q:createDate'=date
 	..s num=num+1
	q num
}

/// creator:dws
/// 2017-09-26
/// Descript:获取跌倒事件发生比率
/// d ##class(%ResultSet).RunQuery("web.DHCADVULCERSTATISTICS","getAdvSlip","2017")
ClassMethod getAdvSlipExecute(ByRef qHandle As %Binary, year As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s month="",leapYearSecMon=""
	s SlipNum="",result="",proportion="0.00"
	s DateFormat = ##class(websys.Conversions).DateFormat() //日期格式
	s Date=##class(web.DHCADVCOMMON).DateLogicalToHtml($p($h,",")) //当前日期
	i DateFormat="1"  d //MDY
	.i Date["/" s:year="" year=$p(Date,"/",3) //以"/"截取字符，获取年份
	i DateFormat="3"  d  //YMD
	.i Date["-" s:year="" year=$p(Date,"-",1) //以"-"截取字符，获取年份
    i DateFormat="4"  d  //DMY
	.i Date["/" s:year="" year=$p(Date,"/",3) //以"/"截取字符，获取年份
	s leap=year/4
	s:leap["." leapYearSecMon="28"
	s:leap'["." leapYearSecMon="29"
	f i=1:1:13 d
	.s month=i
	.s:month=1 SlipNum=..getEveMonSlipNum(year_"-01-01",year_"-01-31"),result=..getEveMonBedNum(year_"-01-01",year_"-01-31")
	.s:month=2 SlipNum=..getEveMonSlipNum(year_"-02-01",year_"-02-"_leapYearSecMon),result=..getEveMonBedNum(year_"-02-01",year_"-02-"_leapYearSecMon)
	.s:month=3 SlipNum=..getEveMonSlipNum(year_"-03-01",year_"-03-31"),result=..getEveMonBedNum(year_"-03-01",year_"-03-31")
	.s:month=4 SlipNum=..getEveMonSlipNum(year_"-04-01",year_"-04-30"),result=..getEveMonBedNum(year_"-04-01",year_"-04-30")
	.s:month=5 SlipNum=..getEveMonSlipNum(year_"-05-01",year_"-05-31"),result=..getEveMonBedNum(year_"-05-01",year_"-05-31")
	.s:month=6 SlipNum=..getEveMonSlipNum(year_"-06-01",year_"-06-30"),result=..getEveMonBedNum(year_"-06-01",year_"-06-30")
	.s:month=7 SlipNum=..getEveMonSlipNum(year_"-07-01",year_"-07-31"),result=..getEveMonBedNum(year_"-07-01",year_"-07-31")
	.s:month=8 SlipNum=..getEveMonSlipNum(year_"-08-01",year_"-08-31"),result=..getEveMonBedNum(year_"-08-01",year_"-08-31")
	.s:month=9 SlipNum=..getEveMonSlipNum(year_"-09-01",year_"-09-30"),result=..getEveMonBedNum(year_"-09-01",year_"-09-30")
	.s:month=10 SlipNum=..getEveMonSlipNum(year_"-10-01",year_"-10-31"),result=..getEveMonBedNum(year_"-10-01",year_"-10-31")
	.s:month=11 SlipNum=..getEveMonSlipNum(year_"-11-01",year_"-11-30"),result=..getEveMonBedNum(year_"-11-01",year_"-11-30")
	.s:month=12 SlipNum=..getEveMonSlipNum(year_"-12-01",year_"-12-31"),result=..getEveMonBedNum(year_"-12-01",year_"-12-31")
	.s:month=13 month="合计",SlipNum=..getEveMonSlipNum(year_"-01-01",year_"-12-31"),result=..getEveMonBedNum(year_"-01-01",year_"-12-31")
	.i (SlipNum'="0")&(result'="0") s proportion=($fn(("0"_(SlipNum/result)),"",4))*100
	.i (SlipNum="0")&(result'="0") s proportion="0"
	.i (result="0") s proportion="0.00"
	.d OutputAdvSlip
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutputAdvSlip
	s data=$lb(month,SlipNum,result,proportion,year)
 	s ^CacheTemp(repid,ind)=data
 	s ind=ind+1
}

Query getAdvSlip(year As %String) As websys.Query(ROWSPEC = "month:%String,SlipNum:%Integer,result:%String,proportion:%Double,year:%String") [ SqlProc ]
{
}

/// creator:dws
/// 2017-09-26
/// Descript:统计每个月发生跌倒的人数
/// w ##class(web.DHCADVULCERSTATISTICS).getEveMonSlipNum("2017-03-01","2017-03-31")
ClassMethod getEveMonSlipNum(stDate, endDate)
{
	n (stDate,endDate)
	s:stDate'="" stDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(stDate)
	s:endDate'="" endDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(endDate)
	
	s formDic="跌倒事件"
	s repLoc="",recordId="",createDate="",num=0
	&sql(declare curvendor2 cursor for select parrRef from DHC_AdvFormRecorditm where value=:formDic)
 	&sql(open curvendor2)
 	s n=1
 	f  &sql(fetch curvendor2 into :repLoc(n))   q:SQLCODE  d 
    .s n=n+1
 	&sql(close curvendor2)
 	s len=n-1
 	f date=stDate:1:endDate d
 	.f i=1:1:len d
 	..s recordId= repLoc(i)
 	..s createDate=$lg($g(^User.FormRecordD(recordId)),4)
 	..q:createDate'=date
 	..s num=num+1
	q num
}

/// creator:dws
/// 2017-09-26
/// Descript:统计每个月总床日数
/// w ##class(web.DHCADVULCERSTATISTICS).getEveMonBedNum("2017-03-01","2017-03-31")
ClassMethod getEveMonBedNum(stDate, endDate)
{
	n (stDate,endDate)
	s:stDate'="" stDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(stDate)
	s:endDate'="" endDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(endDate)
	s paAdmRowId="" 
	s num=0
	f date=stDate:1:endDate d
	.f  s paAdmRowId=$o(^PAADMi("PAADM_Type","I",paAdmRowId)) q:paAdmRowId=""  d
	..s paAdmDate=$p($g(^PAADM(paAdmRowId)),"^",6) ;就诊日期
	..s patVisit=$p($g(^PAADM(paAdmRowId)),"^",20) ;就诊状态
	..q:patVisit'="A"
	..q:paAdmDate>date
	..s num=num+1
	q num
}

/// creator:dws
/// 2017-09-28
/// Descript:获取高危压疮事件发生比率
/// d ##class(%ResultSet).RunQuery("web.DHCADVULCERSTATISTICS","getAdvHighSore","")
ClassMethod getAdvHighSoreExecute(ByRef qHandle As %Binary, year As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s month="",leapYearSecMon=""
	s HighSoreNum="",result="",proportion="0.00"
	s DateFormat = ##class(websys.Conversions).DateFormat() //日期格式
	s Date=##class(web.DHCADVCOMMON).DateLogicalToHtml($p($h,",")) //当前日期
	i DateFormat="1"  d //MDY
	.i Date["/" s:year="" year=$p(Date,"/",3) //以"/"截取字符，获取年份
	i DateFormat="3"  d  //YMD
	.i Date["-" s:year="" year=$p(Date,"-",1) //以"-"截取字符，获取年份
    i DateFormat="4"  d  //DMY
	.i Date["/" s:year="" year=$p(Date,"/",3) //以"/"截取字符，获取年份
	s leap=year/4
	s:leap["." leapYearSecMon="28"
	s:leap'["." leapYearSecMon="29"
	f i=1:1:13 d
	.s month=i
	.s:month=1 HighSoreNum=..getEveMonHighSoreNum(year_"-01-01",year_"-01-31"),result=..getEveMonHighPatNum(year_"-01-01",year_"-01-31")
	.s:month=2 HighSoreNum=..getEveMonHighSoreNum(year_"-02-01",year_"-02-"_leapYearSecMon),result=..getEveMonHighPatNum(year_"-02-01",year_"-02-"_leapYearSecMon)
	.s:month=3 HighSoreNum=..getEveMonHighSoreNum(year_"-03-01",year_"-03-31"),result=..getEveMonHighPatNum(year_"-03-01",year_"-03-31")
	.s:month=4 HighSoreNum=..getEveMonHighSoreNum(year_"-04-01",year_"-04-30"),result=..getEveMonHighPatNum(year_"-04-01",year_"-04-30")
	.s:month=5 HighSoreNum=..getEveMonHighSoreNum(year_"-05-01",year_"-05-31"),result=..getEveMonHighPatNum(year_"-05-01",year_"-05-31")
	.s:month=6 HighSoreNum=..getEveMonHighSoreNum(year_"-06-01",year_"-06-30"),result=..getEveMonHighPatNum(year_"-06-01",year_"-06-30")
	.s:month=7 HighSoreNum=..getEveMonHighSoreNum(year_"-07-01",year_"-07-31"),result=..getEveMonHighPatNum(year_"-07-01",year_"-07-31")
	.s:month=8 HighSoreNum=..getEveMonHighSoreNum(year_"-08-01",year_"-08-31"),result=..getEveMonHighPatNum(year_"-08-01",year_"-08-31")
	.s:month=9 HighSoreNum=..getEveMonHighSoreNum(year_"-09-01",year_"-09-30"),result=..getEveMonHighPatNum(year_"-09-01",year_"-09-30")
	.s:month=10 HighSoreNum=..getEveMonHighSoreNum(year_"-10-01",year_"-10-31"),result=..getEveMonHighPatNum(year_"-10-01",year_"-10-31")
	.s:month=11 HighSoreNum=..getEveMonHighSoreNum(year_"-11-01",year_"-11-30"),result=..getEveMonHighPatNum(year_"-11-01",year_"-11-30")
	.s:month=12 HighSoreNum=..getEveMonHighSoreNum(year_"-12-01",year_"-12-31"),result=..getEveMonHighPatNum(year_"-12-01",year_"-12-31")
	.s:month=13 month="合计",HighSoreNum=..getEveMonHighSoreNum(year_"-01-01",year_"-12-31"),result=..getEveMonHighPatNum(year_"-01-01",year_"-12-31")
	.i (HighSoreNum'="0")&(result'="0") s proportion=($fn(("0"_(HighSoreNum/result)),"",4))*100
	.i (HighSoreNum="0")&(result'="0") s proportion="0"
	.i (result="0") s proportion="0.00"
	.d OutputAdvHighSore
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutputAdvHighSore
	s data=$lb(month,HighSoreNum,result,proportion,year)
 	s ^CacheTemp(repid,ind)=data
 	s ind=ind+1
}

Query getAdvHighSore(year As %String) As websys.Query(ROWSPEC = "month:%String,HighSoreNum:%Integer,result:%String,proportion:%Double,year:%Date") [ SqlProc ]
{
}

/// creator:dws
/// 2017-09-28
/// Descript:统计每个月发生高位压疮的人数
/// w ##class(web.DHCADVULCERSTATISTICS).getEveMonHighSoreNum("2017-03-01","2017-03-31")
ClassMethod getEveMonHighSoreNum(stDate, endDate)
{
	n (stDate,endDate)
	s:stDate'="" stDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(stDate)
	s:endDate'="" endDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(endDate)
	
	s formDic="1976" ;压疮高危预报
	s repLoc="",recordId="",createDate="",num=0
	&sql(declare curvendor3 cursor for select parrRef from DHC_AdvFormRecorditm where value=:formDic)
 	&sql(open curvendor3)
 	s n=1
 	f  &sql(fetch curvendor3 into :repLoc(n))   q:SQLCODE  d 
    .s n=n+1
 	&sql(close curvendor3)
 	s len=n-1
 	f date=stDate:1:endDate d
 	.f i=1:1:len d
 	..s recordId= repLoc(i)
 	..s createDate=$lg($g(^User.FormRecordD(recordId)),4)
 	..q:createDate'=date
 	..s num=num+1
	q num
}

/// creator:dws
/// 2017-09-28
/// Descript:统计每个月高危患者人数
/// w ##class(web.DHCADVULCERSTATISTICS).getEveMonHighPatNum("2017-03-01","2017-03-31")
ClassMethod getEveMonHighPatNum(stDate, endDate)
{
	n (stDate,endDate)
	s:stDate'="" stDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(stDate)
	s:endDate'="" endDate=##class(web.DHCADVCOMMON).DateHtmlToLogical(endDate)
	;w stDate_"/"_endDate,!
	s paAdmRowId="" 
	s num=0
	f date=stDate:1:endDate d
	.f  s paAdmRowId=$o(^PAADMi("PAADM_Type","I",paAdmRowId)) q:paAdmRowId=""  d
	..s paAdmDate=$p($g(^PAADM(paAdmRowId)),"^",6) ;就诊日期
	..S paDisCDate=$p(^PAADM(paAdmRowId),"^",17)  //出院日期
	..s patVisit=$p($g(^PAADM(paAdmRowId)),"^",20) ;就诊状态
	..;b //1
	..q:patVisit'="A"
	..q:(paAdmDate>date)
	..q:(paDisCDate'="")&(paDisCDate<date)
	..s num=num+1
	q num
}

Storage Default
{
<Data name="DHCADVULCERSTATISTICSDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCADVULCERSTATISTICSD</DataLocation>
<DefaultData>DHCADVULCERSTATISTICSDefaultData</DefaultData>
<IdLocation>^web.DHCADVULCERSTATISTICSD</IdLocation>
<IndexLocation>^web.DHCADVULCERSTATISTICSI</IndexLocation>
<StreamLocation>^web.DHCADVULCERSTATISTICSS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
