/// 
/// 
/// 操作项目考试实体类
Class DHCMGNUR.MgNurOperationExam Extends %Persistent
{

Property ScoreDep As %String(TRUNCATE = 1);

Property ScoreNur As %String(TRUNCATE = 1);

Property ScoreDate As %Library.Date(FORMAT = 1);

Property ScoreResult As %String(TRUNCATE = 1);

Property ScoreItem As %String(TRUNCATE = 1);

Property ScoreMonth As %String(TRUNCATE = 1);

Property ScoreMissReason As %String(TRUNCATE = 1);

Property ScoreYear As %Integer;

Property Flag As %String(TRUNCATE = 1);

Index DateDep On (ScoreDate, ScoreDep);

Index Date On ScoreDate;

Index type On (ScoreItem, ScoreDate);

Index Typ On (ScoreNur, ScoreItem, ScoreDate);

Index NurId On (ScoreNur, ScoreDate);

Index isFlag On (ScoreNur, ScoreItem, ScoreYear, ScoreMonth);

Index flag On (ScoreDep, ScoreNur, ScoreDate);

ClassMethod Save(parr As %String) As %String
{
	;s ^TEMP("g20150826001")=parr
	//rw@^depVal@27^nurseVal@0001^operatorVal@67||10^scoreVal@^examDate@2015-08-01^monthVal@Aug^reasExam@66||3
	s tmp="" k tmp
	d ##class(web.DHCMgNurQuarterExamComm).setArray(parr,.tmp)
	s rw=tmp("rw")
	i rw="" s obj=##class(DHCMGNUR.MgNurOperationExam).%New()
	e  s obj=##class(DHCMGNUR.MgNurOperationExam).%OpenId(rw)
	i $G(tmp("depVal"))'="" s obj.ScoreDep=tmp("depVal")
	e  s obj.ScoreDep=""
	i $G(tmp("monthVal"))'="" s obj.ScoreMonth=tmp("monthVal")
	e  s obj.ScoreMonth=""
	i $G(tmp("examDate"))'="" s obj.ScoreDate=$ZDH(tmp("examDate"),3)
	e  s obj.ScoreDate=""
	i $G(tmp("nurseVal"))'="" s obj.ScoreNur=$ZConvert(tmp("nurseVal"),"U")
	e  s obj.ScoreNur=""
	i $G(tmp("operatorVal"))'="" s obj.ScoreItem=tmp("operatorVal")
	e  s obj.ScoreItem=""
	i $G(tmp("reasExam"))'="" s obj.ScoreMissReason=tmp("reasExam")
	e  s obj.ScoreMissReason=""
	i $G(tmp("scoreVal"))'="" s obj.ScoreResult=tmp("scoreVal")
	e  s obj.ScoreResult=""
	i $g(tmp("scoreYear"))'="" s obj.ScoreYear=tmp("scoreYear")
	e  s obj.ScoreYear=""
	i $g(tmp("Flag"))'="" s obj.Flag=tmp("Flag")
	e  s obj.Flag=""
	d obj.%Save()
	q 0
}

ClassMethod getVal(id As %String) As %String
{
	s dateFlag=##class(websys.Conversions).DateFormat()
	s ret=""
	i id'="" 
	{
		s obj=##class(DHCMGNUR.MgNurOperationExam).%OpenId(id)
		;i $G(^CTLOC(obj.ScoreDep))'="" s ScoreDep=$P(^CTLOC(obj.ScoreDep),"^",2)
		;e  s ScoreDep=""
		s ScoreDep=obj.ScoreDep
		;i obj.ScoreNur'="" d
		;.s nurno=$ZConvert(obj.ScoreNur,"U")
		;.s nurid=$O(^DHCMGNUR.MgPersonsI("SSID"," "_nurno,""))
		;.i nurid'="" d
		;..s nurobj=##class(DHCMGNUR.MgPersons).%OpenId(nurid)
		;...s ScoreNur=nurobj.PersonID
		;e  s ScoreNur=""
		s ScoreNur=obj.ScoreNur
		i obj.ScoreDate'="" d
		.i ((dateFlag=3)!(dateFlag=4)) s ScoreDate=##class(web.DHCMgNurPerHRComm).getDateFormat(obj.ScoreDate)
		.e  s ScoreDate=""
		e  s ScoreDate=""
		;s ScoreMonth=##class(web.DHCMgNurOperationExamComm).getMonth(obj.ScoreMonth)
		s ScoreMonth=obj.ScoreMonth
		s ScoreResult=obj.ScoreResult
		;i obj.ScoreItem'="" d
		;.s itmObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScoreItem)
		;.s ScoreItem=itmObj.Code
		;e  s ScoreItem=""
		s ScoreItem=obj.ScoreItem
		;i obj.ScoreMissReason'="" d
		;.s reaObj=##class(DHCMGNUR.CommDictionarySub).%OpenId(obj.ScoreMissReason)
		;.s ScoreReason=reaObj.Code
		;e  s ScoreReason=""
		s ScoreReason=obj.ScoreMissReason
		s ScoreYear=obj.ScoreYear
		b ;01
		s ret="ScoreDep@"_ScoreDep_"^ScoreNur@"_ScoreNur_"^ScoreDate@"_ScoreDate_"^ScoreMonth@"_ScoreMonth_"^ScoreResult@"_ScoreResult_"^ScoreItem@"_ScoreItem_"^ScoreReason@"_ScoreReason_"^ScoreYear@"_ScoreYear
	}
	q ret
}

ClassMethod saveflag(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCMGNUR.MgNurOperationExam).%OpenId(id)
	s obj.Flag="N"
	d obj.%Save()
	q id
}

ClassMethod delete(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCMGNUR.MgNurOperationExam).%DeleteId(id)
	q 1
}

ClassMethod isExist(nurse, operator, month, year) As %String
{
	s ret=""
	s nurse=$ZConvert(nurse,"U")
	s operator=$ZConvert(operator,"U")
	s month=$ZConvert(month,"U")
	s id=$O(^DHCMGNUR.MgNurOperationExamI("isFlag"," "_nurse," "_operator,year," "_month,""))
	s ret=id
	q ret
}

Storage Default
{
<Data name="MgNurOperationExamDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ScoreDep</Value>
</Value>
<Value name="3">
<Value>ScoreNur</Value>
</Value>
<Value name="4">
<Value>ScoreDate</Value>
</Value>
<Value name="5">
<Value>ScoreResult</Value>
</Value>
<Value name="6">
<Value>ScoreItem</Value>
</Value>
<Value name="7">
<Value>Scoremoth</Value>
</Value>
<Value name="8">
<Value>ScoreMissReason</Value>
</Value>
<Value name="9">
<Value>ScoreMonth</Value>
</Value>
<Value name="10">
<Value>ScoreYear</Value>
</Value>
<Value name="11">
<Value>Flag</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgNurOperationExamD</DataLocation>
<DefaultData>MgNurOperationExamDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgNurOperationExamD</IdLocation>
<IndexLocation>^DHCMGNUR.MgNurOperationExamI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgNurOperationExamS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
