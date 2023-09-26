Class DHCWL.util.DateUtil Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description： 根据指定日期类型的日期范围获得日期对应的指标日期id（Months id），有的日期范围可以根据日期类型自动计算。
/// 可以根据日期类型计算日期范围的有：今天，昨天，上周，上月，去年，本周，本月，本年。（都是基于服务器当前日期来计算的）
/// Input: name:开始日期和结束日期的字符串，日期字符串为各种常用格式，格式不受限制，只要年月日之间有分隔符就行。开始日期和结束日期之间用dele参数指定为分隔符
///       dele：开始日期和结束日期间的分隔符。mode：日期的类型，常用的有年，季，月，日，（上月，上周，昨天）等
/// w ##class(DHCWL.util.DateUtil).GetMonthIdByName("2012-05:2012-06")
ClassMethod GetMonthIdByName(name = "2013-03-22:2013-03-22", dele = ":", mode = "freeDateChoce") As %Text
{
	n (name,dele,mode)
	s sd=$p(name,dele,1),ed=$p(name,dele,2)
	q:(sd="")&&(ed="") ""
	s canIgnore=0
	i (($g(mode)'="")&&((mode="torday")||(mode="yesterday")||(mode="lastWeek")||(mode="lastMonth")||(mode="lastYear")||(mode="currentMonth")||(mode="currentYear")||(mode="currentWeek"))||(mode="byMonth")||(mode="byQua")||(mode="byYear")) s canIgnore=1
	i ($g(sd) ["Y"){
		s mode="byYear"
		s:$g(ed)="" ed=sd
		s canIgnore=1
	}
	q:(canIgnore=0)&&(name="") ""
	i ($g(sd) ["Q"){
		s mode="byQua"
		s:$g(ed)="" ed=sd
		s canIgnore=1
	}
	if (($l(sd,"-")=2)&&($l(ed,"-")=2)){
		s sd=..UniteDateStr(sd),ed=..UniteDateStr(ed)
		s canIgnore=1
	}
	i canIgnore=0 {
		i $g(ed)="" s ed=sd
		s sd=..UniteDateStr(sd),ed=..UniteDateStr(ed)
		i $l(sd,"-")=2 {
			s sd=sd_"-01"
		}
		i $l(ed,"-")=2 {
			s ed=ed_"-01"
		}
		s tempSd=$zdh(sd,3),tempEd=$zdh(ed,3)
		i (tempSd>tempEd)&&(canIgnore=0) q ""
	}
	i $g(mode)=""  d  ;若没有给出日期类型，则从月份中自动推算
	.i $f(sd,"Y")>0 s mode="byYear"
	.e  i $f(sd,"Q")>0 s mode="byQua"
	.e  s mode="freeDateChoice"
	s currentDate=$zd($h,3),flag=0
	i mode="torday"  d
	.s sd=$zd($h,3),ed=sd
	else  if mode="yesterday" d
	.s sd=$zd($h-1,3),ed=sd
	.;s sd=$zd($zdh(sd,3),8),ed=$zd($zdh(ed,3),8)
	else  if mode="lastWeek"  d
	.s day=..GetWeekday(currentDate)
	.s ed=$zd($h-day,3),sd=$zd($h-day-6,3)
	else  if mode="lastMonth"  d
	.s day=$p(currentDate,"-",3,3)
	.s ed=$zd($h-day,3)
	.;s sd=$p(ed,"-",1,2)_"-01"
	.s sd=$zd($zdh(ed,3)-..GetMonthDays(ed)+1,3)
	.;b ;001
	.;s sd=$p(ed,"-",1)_$p(ed,"-",2),ed=sd  ;sd=$zd($zdh(sd,3),8),ed=$zd($zdh(ed,3),8)
	else  if mode="lastYear"  d
	.;s year=+$p(currentDate,"-",1)-1
	.s firstMonth=$p(currentDate,"-",1)_"-01-01"
	.s tempDate=$zdh(firstMonth,3)-1
	.s ed=$zd(tempDate,3)
	.s sd=$p(ed,"-",1,1)_"-01-01"
	.;s sd=year_"-Y",ed=sd  ;sd=year_"0101",ed=year_"1231"
	.;b ;001
	else  if mode="freeDateChoice" d
	.;s sd=$zd($zdh(sd,3),8),ed=$zd($zdh(ed,3),8)
	else  if mode="currentWeek" d
	.s weekDay=..GetWeekday(currentDate)
	.s sd=$zd($h-weekDay+1,3),ed=$zd($zdh(sd,3)+6,3)
	else  if mode="currentMonth" d
	.s sd=$p(currentDate,"-",1,2)_"-01"
	.s ed=$p(currentDate,"-",1,2)_"-"_..GetMonthDays(sd)
	.;s sd=$zd($zdh(sd,3),8),ed=$zd($zdh(ed,3),8)
	else  if mode="currentYear" d
	.;s sd=$p(currentDate,"-",1)_"-Y",ed=sd
	.s sd=$p(currentDate,"-",1)_"-01-01",ed=$p(currentDate,"-",1)_"-12-31"
	.s flag=1
	else  if mode="byMonth" d    ;按月
	.s sd=$p(sd,"-",1)_"-"_$p(sd,"-",2) ;_"-01"
	.s ed=$p(ed,"-",1)_"-"_$p(ed,"-",2) ;_"-"_..GetMonthDays(sd)
	.;s sd=$p(sd,"-",1)_$p(sd,"-",2) ;_"-01"
	.;s ed=$p(ed,"-",1)_$p(ed,"-",2) ;_"-"_..GetMonthDays(sd)
	else  if mode="byYear" d   ;按年，不包括结束的那一年
	.s sd=+$p(sd,"-",1)_"-Y"
	.s:+sd'=+ed ed=(+$p(ed,"-",1)-1)_"-Y"
	.s:+ed<+sd ed=sd
	.s ed=+ed_"-Y"
	.s flag=1
	else  if mode="byQua"  d
	.i $f(sd,"Q")>0 s sd=+sd_"-Q"_$e(sd,$l(sd)),ed=+ed_"-Q"_$e(ed,$l(ed))
	.e  d 
	..s sd=$p(sd,"-",1)_"-Q"_..IntegerDiv((+$p(sd,"-",2)),3),ed=$p(ed,"-",1)_"-Q"_..IntegerDiv((+$p(ed,"-",2)),3)
	else  if mode="byQua1" d
	.s sd=+$p(sd,"-",1)_"-Q1",ed=sd
	else  if mode="byQua2" d
	.s sd=ed=+$p(sd,"-",1)_"-Q2"
	else  if mode="byQua3" d
	.s sd=+$p(sd,"-",1)_"-Q3",ed=sd
	else  if mode="byQua4" d
	.s sd=+$p(sd,"-",1)_"-Q4",ed=sd
	//以上过程将用户日期格式装换成MonthName格式
	s sd=..UniteDateStr(sd),ed=..UniteDateStr(ed)
	s str="",date=sd,monId=""
	f  q:date=ed  d
	.s monId=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode(date,"DHCWL.MKPI.Months")   ;$o(^DHCWL.MKPI.MonthsI("Name"," "_date,""))
	.s:monId'="" str=str_monId_","
	.s date=..Create(date)
	;b ;002
	s monId=$o(^DHCWL.MKPI.MonthsI("Name"," "_date,""))
	i monId="" q $e(str,1,$l(str)-1) 
	e  q str_monId
}

/// 将给定Months id尽可能转换为粒度更大的区间id
/// w ##class(DHCWL.util.DateUtil).ConvertMaxSection("12,13,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,99,367,368,369,370")
ClassMethod ConvertMaxSection(monIdStr As %Text) As %Text
{
	n (monIdStr)
	k secPC,sec,tempMonArr
	d ##class(DHCWL.MKPIService.ConfigService).GetSectionMaxToMin(.sec)
	
	f i=$l(monIdStr,","):-1:1 d
	.s tempMonArr($p(monIdStr,",",i))=""
	s tempMonId="",tempMonIdStr="" f  s tempMonId=$o(tempMonArr(tempMonId)) q:tempMonId=""  d
	.i tempMonIdStr'="" s tempMonIdStr=tempMonIdStr_","_tempMonId
	.e  s tempMonIdStr=tempMonId
	s monIdStr=tempMonIdStr
	s secLevel="" f  s secLevel=$o(sec(secLevel),-1) q:secLevel=""  d
	.s secId=$o(sec(secLevel,""))
	.s secCode=sec(secLevel,secId,"C")
	.s secParent=sec(secLevel,secId,"P")
	.s tempLevel="",hasParent="" f  s tempLevel=$o(sec(tempLevel),-1) q:(tempLevel="")||(hasParent'="")  d
	..s tempSecId=$o(sec(tempLevel,""))
	..i tempSecId=secParent s hasParent=sec(tempLevel,tempSecId,"C")
	.s secPC(secCode)=hasParent
	s monLen=$l(monIdStr,",")
	s result="",j=0
	f i=1:1:monLen d
	.s monId=$p(monIdStr,",",i)
	.q:'$d(^DHCWL.MKPI.MonthsD(monId))
	.s monName=$lg(^DHCWL.MKPI.MonthsD(monId),5)
	.s monSecId=$lg(^DHCWL.MKPI.MonthsD(monId),11)
	.s monSecCode=$lg(^DHCWL.MKPI.SectionD(monSecId),2)
	.s monSecP=$g(secPC(monSecCode))
	.s monSecPId=""
	.s:monSecP'="" monSecPId=$o(^DHCWL.MKPI.SectionI("SecCode",$zcvt(monSecP,"U"),""))
	.i monSecPId="" d
	..i result="" s result=monId
	..e  s result=result_","_monId
	..q
	.i (monSecCode="D") d
	..s guessParMonName=$p(monName,"-",1,2)
	..s guessParMonId=$o(^DHCWL.MKPI.MonthsI("SectionFlagName",monSecPId,guessParMonName,""))
	..s monScope=$lg(^DHCWL.MKPI.MonthsD(guessParMonId),12)
	..i monIdStr [ monScope d
	...i result="" s result=guessParMonId
	...e  s result=result_","_guessParMonId
	...s sconeNums=$l(monScope,",")
	...s i=i+sconeNums-1
	..e  d
	...i result="" s result=monId
	...e  s result=result_","_monId
	.else  if (monSecCode="M") d
	..s tempM=$p(monName,"-",2,2)
	..s tempQ=..IntegerDiv(+tempM,3)
	..s sameFlag=1
	..s j=i f  q:((j>monLen)||(j>(i+2))||(sameFlag=0))  d
	...s tempMonId=$p(monIdStr,",",j)
	...s monName2=$lg(^DHCWL.MKPI.MonthsD(tempMonId),5)
	...s tempM2=$p(monName2,"-",2,2)
	...s tempQ2=..IntegerDiv(+tempM2,3)
	...i tempQ2'=tempQ s sameFlag=0
	...e  s sameFlag=sameFlag+1
	...s j=j+1
	..i sameFlag=4 d
	...s guessParMonName=$p(monName,"-",1,1)_"-Q"_tempQ
	...s guessParMonId=$o(^DHCWL.MKPI.MonthsI("SectionFlagName",monSecPId,guessParMonName,""))
	...i result="" s result=guessParMonId
	...e  s result=result_","_guessParMonId
	...s i=i+3-1
	..e  d
	...i result="" s result=monId
	...e  s result=result_","_monId
	.else  if (monSecCode="Q") d
	..s tempY=$p(monName,"-",1,1)
	..s sameFlag=1
	..s j=i f  q:((j>monLen)||(j>(i+3))||(sameFlag=0))  d
	...s tempMonId=$p(monIdStr,",",j) 
	...s monName2=$lg(^DHCWL.MKPI.MonthsD(tempMonId),5)
	...s tempY2=$p(monName2,"-",1,1)
	...i tempY'=tempY s sameFlag=0
	...e  s sameFlag=sameFlag+1
	...s j=j+1
	..i sameFlag=5 d
	...s guessParMonName=tempY_"-Y"
	...s guessParMonId=$o(^DHCWL.MKPI.MonthsI("SectionFlagName",monSecPId,guessParMonName,""))
	...i result="" s result=guessParMonId
	...e  s result=result_","_guessParMonId
	...s i=i+4-1
	..e  d
	...i result="" s result=monId
	...e  s result=result_","_monId
	
	q result
}

/// 根据指标是否有数据将给定Months id尽可能转换为粒度更大的区间id
/// w ##class(DHCWL.util.DateUtil).ConvertMaxSectionByKpi("306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335",16)
ClassMethod ConvertMaxSectionByKpi(monIdStr As %Text, kpiId) As %Text
{
	n (monIdStr,kpiId)
	k secPC,sec,tempMonArr
	d ##class(DHCWL.MKPIService.ConfigService).GetSectionMaxToMin(.sec)
	
	f i=$l(monIdStr,","):-1:1 d
	.s tempMonArr($p(monIdStr,",",i))=""
	s tempMonId="",tempMonIdStr="" f  s tempMonId=$o(tempMonArr(tempMonId)) q:tempMonId=""  d
	.i tempMonIdStr'="" s tempMonIdStr=tempMonIdStr_","_tempMonId
	.e  s tempMonIdStr=tempMonId
	s monIdStr=tempMonIdStr
	s secLevel="" f  s secLevel=$o(sec(secLevel),-1) q:secLevel=""  d
	.s secId=$o(sec(secLevel,""))
	.s secCode=sec(secLevel,secId,"C")
	.s secParent=sec(secLevel,secId,"P")
	.s tempLevel="",hasParent="" f  s tempLevel=$o(sec(tempLevel),-1) q:(tempLevel="")||(hasParent'="")  d
	..s tempSecId=$o(sec(tempLevel,""))
	..i tempSecId=secParent s hasParent=sec(tempLevel,tempSecId,"C")
	.s secPC(secCode)=hasParent
	s monLen=$l(monIdStr,",")
	s result="",j=0
	f i=1:1:monLen d
	.s monId=$p(monIdStr,",",i)
	.q:'$d(^DHCWL.MKPI.MonthsD(monId))
	.s monName=$lg(^DHCWL.MKPI.MonthsD(monId),5)
	.s monSecId=$lg(^DHCWL.MKPI.MonthsD(monId),11)
	.s monSecCode=$lg(^DHCWL.MKPI.SectionD(monSecId),2)
	.s monSecP=$g(secPC(monSecCode))
	.s monSecPId=""
	.s:monSecP'="" monSecPId=$o(^DHCWL.MKPI.SectionI("SecCode",$zcvt(monSecP,"U"),""))
	.i monSecPId="" d
	..i result="" s result=monId
	..e  s result=result_","_monId
	..q
	.i (monSecCode="D") d
	..s guessParMonName=$p(monName,"-",1,2)
	..s guessParMonId=$o(^DHCWL.MKPI.MonthsI("SectionFlagName",monSecPId,guessParMonName,""))
	..s monScope=$lg(^DHCWL.MKPI.MonthsD(guessParMonId),12)
	..i ((monIdStr [ monScope)&&($$Check(guessParMonId,kpiId))=1) d
	...;b ;00001
	...;also we need check kpi has kpiData?
	...i result="" s result=guessParMonId
	...e  s result=result_","_guessParMonId
	...s sconeNums=$l(monScope,",")
	...s i=i+sconeNums-1
	..e  d
	...i result="" s result=monId
	...e  s result=result_","_monId
	.else  if (monSecCode="M") d
	..s tempM=$p(monName,"-",2,2)
	..s tempQ=..IntegerDiv(+tempM,3)
	..s sameFlag=1
	..s j=i f  q:((j>monLen)||(j>(i+2))||(sameFlag=0))  d
	...s tempMonId=$p(monIdStr,",",j)
	...s monName2=$lg(^DHCWL.MKPI.MonthsD(tempMonId),5)
	...s tempM2=$p(monName2,"-",2,2)
	...s tempQ2=..IntegerDiv(+tempM2,3)
	...i tempQ2'=tempQ s sameFlag=0
	...e  s sameFlag=sameFlag+1
	...s j=j+1
	..i (sameFlag=4) d
	...s guessParMonName=$p(monName,"-",1,1)_"-Q"_tempQ
	...s guessParMonId=$o(^DHCWL.MKPI.MonthsI("SectionFlagName",monSecPId,guessParMonName,""))
	...i $$Check(guessParMonId,kpiId)=1 d
	....i result="" s result=guessParMonId
	....e  s result=result_","_guessParMonId
	....s i=i+3-1
	...e  d
	....i result="" s result=monId
	....e  s result=result_","_monId
	..e  d
	...i result="" s result=monId
	...e  s result=result_","_monId
	.else  if (monSecCode="Q") d
	..s tempY=$p(monName,"-",1,1)
	..s sameFlag=1
	..s j=i f  q:((j>monLen)||(j>(i+3))||(sameFlag=0))  d
	...s tempMonId=$p(monIdStr,",",j) 
	...s monName2=$lg(^DHCWL.MKPI.MonthsD(tempMonId),5)
	...s tempY2=$p(monName2,"-",1,1)
	...i tempY'=tempY s sameFlag=0
	...e  s sameFlag=sameFlag+1
	...s j=j+1
	..i sameFlag=5 d
	...s guessParMonName=tempY_"-Y"
	...s guessParMonId=$o(^DHCWL.MKPI.MonthsI("SectionFlagName",monSecPId,guessParMonName,""))
	...i $$Check(guessParMonId,kpiId)=1 d
	....i result="" s result=guessParMonId
	....e  s result=result_","_guessParMonId
	....s i=i+4-1
	...e  d
	....i result="" s result=monId
	....e  s result=result_","_monId
	..e  d
	...i result="" s result=monId
	...e  s result=result_","_monId
	q result
Check(checkMonId,checkKpi)
	q:$d(^DHCWL.MKPI.MKPIDataI("MONKPI",checkMonId,checkKpi))=0 0
	s dataId=$o(^DHCWL.MKPI.MKPIDataI("MONKPI",checkMonId,checkKpi,""))
	q:(+dataId=0)||($d(^DHCWL.MKPI.DeptKPIDataI("DKPIKPIDrIndex",dataId))=0) 0
	q $o(^DHCWL.MKPI.DeptKPIDataI("DKPIKPIDrIndex",dataId,""))'=0
}

/// 整除操作，结果为向上取整
/// w ##class(DHCWL.util.DateUtil).IntegerDiv(1,2)
ClassMethod IntegerDiv(a As %Integer, b As %Integer) As %Integer
{
	n (a,b)
	i a#b'=0 q a\b+1
	e  q a\b
}

/// w ##class(DHCWL.util.DateUtil).GetScopeByMonthName("2008-01-01:2012-12-1",,"lastMonth")
ClassMethod GetScopeByMonthName(name, dele = ":", mode = "freeDateChoce") As %String
{
	n (name,dele,mode)
	q:name="" ""
	s sd=$p(name,dele,1),ed=$p(name,dele,2)
	s canIgnore=0
	i (($g(mode)'="")&&((mode="torday")||(mode="yesterday")||(mode="lastWeek")||(mode="lastMonth")||(mode="lastYear")||(mode="currentMonth")||(mode="currentYear"))) s canIgnore=1
	i canIgnore=0 {
		i $g(ed)="" s ed=sd
		s sd=..UniteDateStr(sd),ed=..UniteDateStr(ed)
		s tempSd=$zdh(sd,3),tempEd=$zdh(ed,3)
		i (tempSd>tempEd)&&(canIgnore=0) q ""
	}
	s currentDate=$zd($h,3),flag=0
	i $g(mode)=""  d  ;若没有给出日期类型，则从月份中自动推算
	.i $f(sd,"Y")>0 s mode="byYear"
	.e  i $f(sd,"Q")>0 s mode="byQua"
	.e  s mode="freeDateChoice"
	s currentDate=$zd($h,3),flag=0
	i mode="torday"  d
	.s sd=$zd($h,3),ed=sd
	else  if mode="yesterday" d
	.s sd=$zd($h-1,3),ed=sd
	else  if mode="lastWeek"  d
	.s day=..GetWeekday(currentDate)
	.s ed=$zd($h-day,3),sd=$zd($h-day-6,3)
	else  if mode="lastMonth"  d
	.s day=$p(currentDate,"-",3,3)
	.s ed=$zd($h-day,3)
	.s sd=$p(ed,"-",1,2)_"-01"
	else  if mode="lastYear"  d
	.s year=+$p(currentDate,"-",1)-1
	.s sd=year_"-01-01",ed=year_"-12-31"
	else  if mode="freeDateChoice" d
	.;s sd=$zd($zdh(sd,3),3),ed=$zd($zdh(ed,3),8)
	else  if mode="currentMonth" d
	.s sd=$p(currentDate,"-",1,2)_"-01"
	.s ed=$p(currentDate,"-",1,2)_"-"_..GetMonthDays(sd)
	.;s sd=$zd($zdh(sd,3),8),ed=$zd($zdh(ed,3),8)
	else  if mode="currentYear" d
	.s sd=$p(currentDate,"-",1)_"-01-01",ed=$p(currentDate,"-",1)_"-12-31"
	.s flag=1
	else  if mode="byMonth" d
	.s sd=$p(sd,"-",1)_"-"_$p(sd,"-",2)_"-01"
	.s ed=$p(ed,"-",1)_"-"_$p(ed,"-",2)_"-"_..GetMonthDays(ed) ;$p(ed,"-",1)_$p(ed,"-",2)_"-"_..GetMonthDays(ed)
	else  if mode="byYear" d
	.s sd=$p(sd,"-",1)_"-01-01"
	.s ed=(+$p(ed,"-",1)-1)_"-12-31"
	.s flag=1
	else  if mode="byQua1" d
	.s sd=$p(sd,"-",1)_"-01-01",ed=$p(sd,"-",1)_"-03-31"
	else  if mode="byQua2" d
	.s sd=$p(sd,"-",1)_"-04-01",ed=$p(sd,"-",1)_"-06-30"
	else  if mode="byQua3" d
	.s sd=$p(sd,"-",1)_"-07-01",ed=$p(sd,"-",1)_"-09-30"
	else  if mode="byQua4" d
	.s sd=$p(sd,"-",1)_"-10-01",ed=$p(sd,"-",1)_"-12-31"
	q sd_":"_ed
}

/// 日期自增一，一根据日期类型来决定是年还是月，日，季等。
/// w ##class(DHCWL.util.DateUtil).Create("2012Q1")
ClassMethod Create(date) As %String
{
	n (date)
	i $f(date,"Y")>0  d
	.s date=((+date)+1)_"-Y"
	e  i $f(date,"Q")>0  d
	.i +$e(date,$l(date))=4  d
	..s date=((+date)+1)_"-Q1"
	.e  s date=+date_"-Q"_(+$e(date,$l(date))+1)
	e  i $l(date,"-")=2 d
	.s date=$p($zd($zdh(date_"-"_..GetMonthDays(date),3)+1,3),"-",1,2)
	e  s date=$zd($zdh(date,3)+1,3)
	q date
}

/// w ##class(DHCWL.util.DateUtil).Minus("2012Q1")
ClassMethod Minus(date) As %String
{
	n (date)
	i date [ "Y" {
		q (+date-1)_"-Y"
	}elseif date [ "Q" {
		s year=+$p(date,"Q",1)
		s qua=+$p(date,"Q",2)
		i qua=1 {
			s year=year-1,qua=4
		}else{
			s qua=qua-1
		}
		q year_"-Q"_qua
	}elseif $l(date,"-")=2 {
		s date=date_"-01"
		s date=$zdh(date,3)
		s date=date-2
		s date=$zd(date,3)
		q $p(date,"-",1,2)
	}elseif $l(date,"-")=3{
		s date=$zdh(date,3)
		s date=date-1
		q $zd(date,3)
	}
	q ""
}

/// 去给定日期的上月的起始日期
/// w ##class(DHCWL.util.DateUtil).GetPreMonth("2012.1.1")
ClassMethod GetPreMonth(currentDate) As %String
{
	n (currentDate)
	q:currentDate="" ""
	s currentDate=..UniteDateStr(currentDate)
	s day=$p(currentDate,"-",3,3)
	s ed=$zd($zdh(currentDate,3)-day,3)
	s sd=$p(ed,"-",1,2)_"-01"
	q sd_":"_ed
}

/// 将多种不同日期统一成yyyy-mm-dd格式
/// w ##class(DHCWL.util.DateUtil).UniteDateStr("2012-Y")
ClassMethod UniteDateStr(dateStr) As %String
{
	n (dateStr)
	q:dateStr="" ""
	s flag=1,dele="-"
	s len=$l(dateStr),result=""
	f i=1:1:len d
	.s pe=$e(dateStr,i)
	.i ($ascii(pe)>47)&&($ascii(pe)<58) s result=result_pe  ;保留数字字符
	.e  i (($ascii(pe)>64)&&($ascii(pe)<91))||(($ascii(pe)>96)&&($ascii(pe)<123)) s result=result_pe,flag=0  ;保留字母
	.e  s result=result_dele,flag=0  ;替换其他字符
	i (flag)&&($l(result,dele)=3) s result=$zd($zdh(result,8),3)   ;可以转换的就统一转换
	q ..Unite(result,dele)
}

/// 统一格式补零处理（不足量位的）。如2012-7-1改为2012-07-01
ClassMethod Unite(date, dele) As %String
{
	n (date,dele)
	i $l(date,dele)>1 d
	.s temp=""
	.f i=1:1:$l(date,dele) d
	..s temp2=$p(date,dele,i)
	..i (+temp2<10)&&(+temp2>0) s temp2="0"_+temp2
	..i temp="" s temp=temp2
	..e  s temp=temp_dele_temp2
	.s date=temp
	e  q date
	q date
}

/// w ##class(DHCWL.util.DateUtil).GetDateScopeFromMonth("2012-12-1","2012-12-22")
ClassMethod GetDateScopeFromMonth(sDate, eDate) As %String
{
	q:sDate="" ""
	i $g(eDate)="" s eDate=sDate
	s sDate=..Unite(sDate,"-"),eDate=..Unite(eDate,"-")
	s monsId=$o(^DHCWL.MKPI.MonthsI("Code",sDate,"")),moneId=$o(^DHCWL.MKPI.MonthsI("Code",eDate,""))
	q:($g(monsId)="")||($g(moneId)="") sDate_":"_eDate
	s sectionId=$list(^DHCWL.MKPI.MonthsD(monsId),11)
	s secCode=$list(^DHCWL.MKPI.SectionD(sectionId),2),result=""
	i secCode="D" s result= $list(^DHCWL.MKPI.MonthsD(monsId),5)_":"_$list(^DHCWL.MKPI.MonthsD(moneId),5)
	else  if secCode="M" s result= $list(^DHCWL.MKPI.MonthsD(monsId),5)_"-01"_":"_$list(^DHCWL.MKPI.MonthsD(moneId),5)_"-"_..GetMonthDays($list(^DHCWL.MKPI.MonthsD(moneId),5))
	else  if secCode="Q" d 
	.s from=$p($list(^DHCWL.MKPI.MonthsD(monsId),12),",",1)
	.s to=$p($list(^DHCWL.MKPI.MonthsD(moneId),12),",",3)
	.s from=$list(^DHCWL.MKPI.MonthsD(from),5)_"-01"
	.s to=$list(^DHCWL.MKPI.MonthsD(to),5)_"-"_..GetMonthDays($list(^DHCWL.MKPI.MonthsD(to),5))
	.s result= from_":"_to
	else  if secCode="Y" s result=+($list(^DHCWL.MKPI.MonthsD(monsId),5))_"-01-01:"_+($list(^DHCWL.MKPI.MonthsD(moneId),5))_"-12-31"
	q result
}

/// 计算所给日期为周几？
/// w ##class(DHCWL.util.DateUtil).GetWeekday("2012-11-23")
ClassMethod GetWeekday(date) As %Integer
{
	n (date)
	s date=..UniteDateStr(date)
	s base=$zdh("2008-01-06",3),date=$zdh(date,3)   ;以2008-01-06，周日作为参考点，可以自由选定
	s days=date-base
	i days<0 s days=-days s res= 7-(days#7)
	e  s res= days#7
	i res=0 q 7
	q res
}

/// 计算所给月份下的天数
/// w ##class(DHCWL.util.DateUtil).GetMonthDays("2012-2")
ClassMethod GetMonthDays(date) As %Integer
{
	n (date)
	s year=$p(date,"-",1),month=$p(date,"-",2)
	s days(1)=31,days(2,1)=28,days(2,2)=29,days(3)=31,days(4)=30,days(5)=31,days(6)=30,days(7)=31,days(8)=31,days(9)=30,days(10)=31,days(11)=30,days(12)=31
	if (+month=2) {
		if ((year#4=0)&&(year#100'=0))||(year#400=0) {
			q days(+month,2)
		}else{
			q days(+month,1)
		}
	}
	q days(+month)
}

/// 根据日期转换类型将给定month id转换为目标类型month id
/// w ##class(DHCWL.util.DateUtil).GeDirContrastMonId(365,"PP")
/// type: PP,SL,CM,CY
ClassMethod GeDirContrastMonId(monthId, type) As %Text
{
	n (monthId,type)
	q:(monthId="")||('$d(^DHCWL.MKPI.MonthsD(monthId))) ""
	q:type="" monthId
	q:'$d(^DHCWL.MKPI.MonthContractI("MonthDrTypeI",monthId)) ""
	s typeId=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("MONCON||"_type)
	q:+typeId=0 ""
	s conMonId=""
	//直接计算对比日期
	q ##class(DHCWL.util.DateUtil).GetMonIdByContractType(monthId,type)  ;GetMonIdByContractType
	//从数据库中取对比日期
	s conMonId=$o(^DHCWL.MKPI.MonthContractI("MonthDrTypeI",monthId,typeId,""))
	q:conMonId'="" $lg(^DHCWL.MKPI.MonthContractD(conMonId),4)
	q ""
}

/// w ##class(DHCWL.util.DateUtil).GetMonIdByContractType(377,"PP")
ClassMethod GetMonIdByContractType(monthId, type) As %String
{
	n (monthId,type)
	q:(monthId="")||('$d(^DHCWL.MKPI.MonthsD(monthId))) ""
	q:type="" monthId
	s monSec=$lg(^DHCWL.MKPI.MonthsD(monthId),11,"")
	s date=$lg(^DHCWL.MKPI.MonthsD(monthId),5,"")
	s monSecCode=##class(DHCWL.MKPIIO.XMLIOConfige).GetCodeById(monSec,"DHCWL.MKPI.Section")
	s conMontId=monthId,conDate=date
	;b ;001
	i type="PP" {	//previous period of the date
		s conDate=..Minus(date)
	}elseif type="SL"{	//same period last year
		if (monSecCode="D"){
			s date=$zdh(date,3)
			s date=$zd(date,3)
			i $p(date,"-",2,3)="02-29" q ""
		}
		s year=+date
		s year=year-1
		s conDate=year_"-"_$p(date,"-",2,$l(date,"-"))
	}elseif type="CM" {		//sum this month
		if (monSecCode="D"){
			s start=$p(date,"-",1,2)_"-01"
			s start=$zdh(start,3),end=$zdh(date,3)
			s currentMonth=""
			f tempDateh=start:1:end {
				s tempDate=$zd(tempDateh,3)
				s tempMonId=$o(^DHCWL.MKPI.MonthsI("SectionFlagName",monSec,tempDate,""))
				i currentMonth="" s currentMonth=tempMonId
				e  s currentMonth=currentMonth_","_tempMonId
			}
			q currentMonth
		}elseif (monSecCode="M"){
			s start=$p(date,"-",1,2)_"-01"
			s year=$p(date,"-",1)
			s end=date_"-"_..GetMonthDays(date)
			s start=1,end=+$p(date,"-",2)
			s currentMonth=""
			f tempDateh=start:1:end {
				s tempDate=year_"-"_tempDateh
				s tempMonId=$o(^DHCWL.MKPI.MonthsI("SectionFlagName",monSec,tempDate,""))
				i currentMonth="" s currentMonth=tempMonId
				e  s currentMonth=currentMonth_","_tempMonId
			}
			q currentMonth
		}elseif (monSecCode="Q"){
			q ""
		}elseif (monSecCode="Y"){
			q ""
		}
	}elseif type="CY" {		//sum this year
		if (monSecCode="D"){
			s year=$p(date,"-",1)
			s month=+$p(date,"-",2)
			s conMonSec=##class(DHCWL.MKPIIO.XMLIOConfige).GetIdByCode("M","DHCWL.MKPI.Section")
			s currentMonth=""
			f tempM=1:1:month {
				s tempDateh=year_"-"_tempM_"-01"
				s tempDate=$zdh(tempDateh,3)
				s tempDate=$zd(tempDate,3)
				s tempDate=$p(tempDate,"-",1,2)
				s tempMonId=$o(^DHCWL.MKPI.MonthsI("SectionFlagName",conMonSec,tempDate,""))
				i currentMonth="" s currentMonth=tempMonId
				e  s currentMonth=currentMonth_","_tempMonId
			}
			q currentMonth
		}elseif (monSecCode="M"){
			s year=$p(date,"-",1)
			s month=+$p(date,"-",2)
			s currentMonth=""
			f tempM=1:1:month {
				s tempDateh=year_"-"_tempM_"-01"
				s tempDate=$zd(tempDateh,3)
				s tempDate=$p(tempDate,"-",1,2)
				s tempMonId=$o(^DHCWL.MKPI.MonthsI("SectionFlagName",monSec,tempDate,""))
				i currentMonth="" s currentMonth=tempMonId
				e  s currentMonth=currentMonth_","_tempMonId
			}
			q currentMonth
		}elseif (monSecCode="Q"){
			q ""
		}elseif (monSecCode="Y"){
			q monthId
		}
	}
	s conMontId=$o(^DHCWL.MKPI.MonthsI("SectionFlagName",monSec,conDate,""))
	q conMontId
}

ClassMethod SetMonthContract(monthId, rebildFlag = 0)
{
	n (monthId,rebildFlag)
	q:(monthId="")||('$d(^DHCWL.MKPI.MonthsD(monthId)))
	i (rebildFlag=0)&&($d(^DHCWL.MKPI.MonthContractI("MonthDrTypeI",monthId))) q
	&sql(delete from DHCWL_MKPI.DHCWLKPIMonthsContract where MonCon_MonthDr=:monthId)
	d ##class(DHCWL.MKPI.MonthContract).CreateNeed()
	s conMon=..GetMonIdByContractType(monthId,"PP")
	s type=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("MONCON||PP")
	&sql(insert into DHCWL_MKPI.DHCWLKPIMonthsContract(MonCon_MonthDr,MonCon_Type,MonCon_MonIdList)
		values(:monthId,:type,:conMon)
	)
	s conMon=..GetMonIdByContractType(monthId,"SL")
	s type=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("MONCON||SL")
	&sql(insert into DHCWL_MKPI.DHCWLKPIMonthsContract(MonCon_MonthDr,MonCon_Type,MonCon_MonIdList)
		values(:monthId,:type,:conMon)
	)
	s conMon=..GetMonIdByContractType(monthId,"CM")
	s type=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("MONCON||CM")
	&sql(insert into DHCWL_MKPI.DHCWLKPIMonthsContract(MonCon_MonthDr,MonCon_Type,MonCon_MonIdList)
		values(:monthId,:type,:conMon)
	)
	s conMon=..GetMonIdByContractType(monthId,"CY")
	s type=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("MONCON||CY")
	&sql(insert into DHCWL_MKPI.DHCWLKPIMonthsContract(MonCon_MonthDr,MonCon_Type,MonCon_MonIdList)
		values(:monthId,:type,:conMon)
	)
}

/// d ##class(DHCWL.util.DateUtil).SetMonthContractScope(365,1)
ClassMethod SetMonthContractScope(idScope, rebildFlag = 0)
{
	n (idScope,rebildFlag)
	q:idScope=""
	s sd=+$p(idScope,"-",1),ed=+$p(idScope,"-",2)
	f i=sd:1:ed {
		d ..SetMonthContract(i,rebildFlag)
	}
}

/// d ##class(DHCWL.util.DateUtil).SetMonthContractYear("2012",1)
ClassMethod SetMonthContractYear(year, rebildFlag = 0)
{
	n (year,rebildFlag)
	q:year=""
	s year=+year
	s monId="" f  s monId=$o(^DHCWL.MKPI.MonthsD(monId)) q:monId=""  d
	.s name=$lg(^DHCWL.MKPI.MonthsD(monId),5,"")
	.q:+name'=year
	.d ..SetMonthContract(monId,rebildFlag)
}

/// Creator    : wk
/// CreatData  : 2020-04-10
/// Desc       : 
/// Input      : 开始日期、结束日期
/// Output     : 判断状态
/// Other      : do ##class(DHCWL.util.DateUtil).DateIslegitimate()
ClassMethod DateIslegitimate(startDate, endDate)
{
	n (startDate,endDate)
	if ((startDate="")||(endDate="")){
		q "日期不能为空"
	}
	s startDate=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(startDate)
 	s endDate=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(endDate)
 	if (startDate>endDate){
 		q "结束日期需要大于开始日期"
 	}
 	q "ok"
}

}
