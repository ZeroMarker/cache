Class User.DHCNurSkinTestList Extends %Persistent
{

Property TestAdmDr As %String(TRUNCATE = 1);

Property TestStartDate As %Library.Date(FORMAT = 1);

Property TestStartTime As %Library.Time;

Property TestDate As %Library.Date(FORMAT = 1);

Property TestTime As %Library.Time;

Property TestCallFlag As %String(TRUNCATE = 1);

Property RecDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$p($h,",",1)}, Required ];

Property RecTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required ];

Property RecUser As %String(TRUNCATE = 1);

Property TestOeoriDr As %String(TRUNCATE = 1);

Property ObserveTime As %String(TRUNCATE = 1);

Property TestLocDr As %String(TRUNCATE = 1);

Property TestMethod As %String(TRUNCATE = 1);

Property TestResult As %String(TRUNCATE = 1);

Property TestResultDesc As %String(TRUNCATE = 1);

Index StartDateTime On (TestStartDate, TestStartTime);

Index AdmDateTime On (TestAdmDr, TestStartDate, TestStartTime);

Index OeoriDr On TestOeoriDr;

/// typ现有count:开始计时按钮,test:置皮试结果按钮,call:呼叫按钮
ClassMethod Save(id, parr As %String, typ = "") As %String
{
  	s l=$L(parr,"^")
	for i=1:1:l
	{
		s itm=$P(parr,"^",i)
		if itm="" continue
		s name=$P(itm,"|")
		s val=$P(itm,"|",2)
		s tmp(name)=val
	}
	if $D(tmp("TestOeoriDr")) {
		s tmp("TestOeoriDr")=$TR($G(tmp("TestOeoriDr")),"!!","||")
	}
	if $G(id)'="" {
		//呼叫
		s IfOverTime=..IfOverTime(id)
		if IfOverTime'="" q IfOverTime 
		s a=##class(User.DHCNurSkinTestList).%OpenId(id)
	}
	else {
		//开始皮试计时,置皮试结果
		if ($G(tmp("TestAdmDr"))'="") {
			s id=..GetIdByAdm($G(tmp("TestAdmDr")),$G(tmp("TestOeoriDr")))
			if (id'=""){
				if typ="count" q "已在皮试病人列表中或已做皮试!"
				s IfOverTime=..IfOverTime(id)
				//if IfOverTime'="" q IfOverTime 
				if IfOverTime'="",typ'="test" q IfOverTime
				s a=##class(User.DHCNurSkinTestList).%OpenId(id)
			}
			else {
				s a=##class(User.DHCNurSkinTestList).%New()
			}
		}
		else {
			q "请先选择一个病人!"
		}
	}
	if $D(tmp("TestAdmDr")) s a.TestAdmDr=tmp("TestAdmDr")
	if $D(tmp("TestStartDate")) s a.TestStartDate=..TransDate($G(tmp("TestStartDate")))
	if $D(tmp("TestStartTime")) s a.TestStartTime=..TransTime($G(tmp("TestStartTime")))
	if $D(tmp("TestDate")) s a.TestDate=..TransDate($G(tmp("TestDate")))
	if $D(tmp("TestTime")) s a.TestTime=..TransTime($G(tmp("TestTime")))
	if $D(tmp("TestCallFlag")) s a.TestCallFlag=tmp("TestCallFlag")
	if $D(tmp("RecUser")) s a.RecUser=tmp("RecUser")
	if $D(tmp("TestOeoriDr")) s a.TestOeoriDr=tmp("TestOeoriDr")
	if $D(tmp("ObserveTime")) s a.ObserveTime=tmp("ObserveTime")
	if $D(tmp("TestLocDr")) s a.TestLocDr=tmp("TestLocDr")
	if $D(tmp("TestMethod")) s a.TestMethod=tmp("TestMethod")
	if $D(tmp("TestResult")) s a.TestResult=tmp("TestResult")
	if $D(tmp("TestResultDesc")) s a.TestResultDesc=tmp("TestResultDesc")	
	d a.%Save()
	//q a.%Id()
	q 0
}

/// 转换数字格式日期
ClassMethod TransDate(Date) As %String
{
	if (Date'="") {
		i Date["/" q $zdh(Date,4)
		i Date["-" q $zdh(Date,3)
		q Date
	}
	else {
		q +$h
	}
}

/// 转换数字格式时间
ClassMethod TransTime(Time) As %String
{
	if (Time'="") {
		i $l(Time,":")=2 q $zth(Time,2)
		i $l(Time,":")=3 q $zth(Time)
		q Time
	}
	else {
		q $p($h,",",2)
	}
}

/// 日期+时间值
ClassMethod GetAbsTime(dt As %String) As %String
{
	s dat=$P(dt,",",1),tim=$P(dt,",",2)
	q ((dat*86400)+tim)
}

/// 判断病人当天 是否在列表中(有无皮试)
/// 有,且未做皮试,返回记录ID
/// 无,或已做皮试,返回0
ClassMethod GetIdByAdm(Adm, OeoriDr) As %String
{
	q:Adm="" ""
	s flag=0,ret=""
	//按医嘱ID查询是否已在皮试病人列表中
	i OeoriDr'="" d 
	.s curId="" f  s curId=$O(^User.DHCNurSkinTestListI("OeoriDr"," "_OeoriDr,curId)) q:(curId="")!(flag=1)  d
	..s flag=1
	..s ret=curId
	i flag'=0 q ret
	
	s curDate="" f  s curDate=$O(^User.DHCNurSkinTestListI("AdmDateTime"," "_Adm,curDate)) q:(curDate="")!(flag=1)  d
	.q:($TR(curDate," ","")'=+$h)
	.s curTime="" f  s curTime=$O(^User.DHCNurSkinTestListI("AdmDateTime"," "_Adm,curDate,curTime)) q:(curTime="")!(flag=1)  d
	..s curId="" f  s curId=$O(^User.DHCNurSkinTestListI("AdmDateTime"," "_Adm,curDate,curTime,curId)) q:(curId="")!(flag=1)  d
	...s TestDate=$ListGet(^User.DHCNurSkinTestListD(curId),4)
	...i TestDate="",OeoriDr="" d
	....s flag=1
	....s ret=curId
	...e  d
	....s TestOeoriDr=$ListGet(^User.DHCNurSkinTestListD(curId),11)
	....i OeoriDr'="",OeoriDr=TestOeoriDr d
	.....s flag=1
	.....s ret=curId
  	q ret
}

/// 判断从置皮试结果到当前是否超过20分钟
/// "":超过,其它:未超过
ClassMethod IfOverTime(id) As %String
{
	q:id="" "" 
	s a=##class(User.DHCNurSkinTestList).%OpenId(id)
	s TestStartDate=a.TestStartDate
	s TestStartTime=a.TestStartTime
	i TestStartDate="" q "请先将病人加入到皮试病人列表中,进行计时!"
	s curDateTime=..GetAbsTime($h)
	s StartDateTime=..GetAbsTime(TestStartDate_","_TestStartTime)
	;i curDateTime-StartDateTime<(20*60) q "未超过二十分钟!"
	q ""
}

/// 撤销删除计时记录
ClassMethod Delete(id) As %String
{
	q:id="" 0
	d ##class(User.DHCNurSkinTestList).%DeleteId(id)
	q 0
}

/// 判断病人当天 是否在列表中(有无皮试)
/// 有,且未做皮试,返回记录ID
/// 无,或已做皮试,返回0
/// ##class(User.DHCNurSkinTestList).IfPatPSEnd(304)
ClassMethod IfPatPSEnd(Adm) As %String
{
	q:Adm="" ""
	s TestStartTime=""
	s flag=""
	s curDate="" f  s curDate=$O(^User.DHCNurSkinTestListI("AdmDateTime"," "_Adm,curDate)) q:(curDate="")!(flag=1)  d
	.q:($TR(curDate," ","")'=+$h)
	.s curTime="" f  s curTime=$O(^User.DHCNurSkinTestListI("AdmDateTime"," "_Adm,curDate,curTime)) q:(curTime="")!(flag=1)  d
	..s curId="" f  s curId=$O(^User.DHCNurSkinTestListI("AdmDateTime"," "_Adm,curDate,curTime,curId)) q:(curId="")!(flag=1)  d
	...s TestDate=$ListGet(^User.DHCNurSkinTestListD(curId),4)
	...q:(TestDate'="") //已做过皮试
	...s TestStartDate=$ListGet(^User.DHCNurSkinTestListD(curId),5)
	...s TestStartTime=$ListGet(^User.DHCNurSkinTestListD(curId),6)
	...s ObserveTime=$ListGet(^User.DHCNurSkinTestListD(curId),12)
	...i ObserveTime'="" d
	....i ObserveTime["分钟" s ObserveTime=+ObserveTime*60
	....i ObserveTime["小时" s ObserveTime=+ObserveTime*3600
	q:TestStartTime="" 0
	s curtime=$p($h,",",2)
	q:(curtime-TestStartTime)<ObserveTime 1
  	q 0
}

Storage Default
{
<Data name="DHCNurSkinTestListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestAdmDr</Value>
</Value>
<Value name="3">
<Value>TestCallFlag</Value>
</Value>
<Value name="4">
<Value>TestDate</Value>
</Value>
<Value name="5">
<Value>TestStartDate</Value>
</Value>
<Value name="6">
<Value>TestStartTime</Value>
</Value>
<Value name="7">
<Value>TestTime</Value>
</Value>
<Value name="8">
<Value>RecDate</Value>
</Value>
<Value name="9">
<Value>RecTime</Value>
</Value>
<Value name="10">
<Value>RecUser</Value>
</Value>
<Value name="11">
<Value>TestOeoriDr</Value>
</Value>
<Value name="12">
<Value>ObserveTime</Value>
</Value>
<Value name="13">
<Value>TestLocDr</Value>
</Value>
<Value name="14">
<Value>TestMethod</Value>
</Value>
<Value name="15">
<Value>TestResult</Value>
</Value>
<Value name="16">
<Value>TestResultDesc</Value>
</Value>
</Data>
<DataLocation>^User.DHCNurSkinTestListD</DataLocation>
<DefaultData>DHCNurSkinTestListDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCNurSkinTestListD</IdLocation>
<IndexLocation>^User.DHCNurSkinTestListI</IndexLocation>
<StreamLocation>^User.DHCNurSkinTestListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
