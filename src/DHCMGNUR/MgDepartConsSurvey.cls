/// Hospital:北京协和医院
/// Class Description:科室护理团队建设情况调查表
/// Date:2014-12-01
Class DHCMGNUR.MgDepartConsSurvey Extends %Persistent
{

Relationship perDepCon As DHCMGNUR.MgDepartConsSurveySub [ Cardinality = children, Inverse = subParref ];

//护理部设定开始时间

Property StDate As %Date [ SqlColumnNumber = 2, SqlFieldName = St_Date ];

//护理部设定结束时间

Property EndDate As %Date [ SqlColumnNumber = 3, SqlFieldName = End_Date ];

//填表日期

Property FillDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$p($h,",",1)}, Required, SqlColumnNumber = 4, SqlFieldName = Fill_Date ];

//填表时间

Property FillTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required, SqlColumnNumber = 5, SqlFieldName = Fill_Time ];

//标题

Property TabTitle As %Library.String [ SqlColumnNumber = 6, SqlFieldName = Tab_Title ];

Index FillDate On FillDate;

Index dateFlag On (StDate, EndDate);

Index recordFlag On (StDate, EndDate, TabTitle);

ClassMethod Save(parr As %String) As %String
{
	//2014-12-02^2014-12-13^1^
	s ^TEMP("g20141202105501")=parr
	s id=$P(parr,"^",4)
	i id="" s a=##class(DHCMGNUR.MgDepartConsSurvey).%New()
	e  s a=##class(DHCMGNUR.MgDepartConsSurvey).%OpenId(id)
	s a.StDate=$ZDH($P(parr,"^",1),3)
	s a.EndDate=$ZDH($P(parr,"^",2),3)
	s a.TabTitle=$P(parr,"^",3)
	s ^TMP("g20141202110901")=a.StDate_"|"_a.EndDate_"|"_a.TabTitle_"|"_a.%Id()
	d a.%Save()
	q a.%Id()
}

ClassMethod getVal(id As %String) As %String
{
	;s ^TMP("g20141202114901")=id
	s ret=""
	i id'=""
	{
		s a=##class(DHCMGNUR.MgDepartConsSurvey).%OpenId(id)
		s StDate=$ZD(a.StDate,3)
		s EndDate=$ZD(a.EndDate,3)
		s TabTitle=a.TabTitle
		s ret="StDate|"_StDate_"^EndDate|"_EndDate_"^TabTitle|"_TabTitle
	}
	q ret
}

ClassMethod getNurseDep(nurseId As %String) As %String
{
	;s ^TEMP("g20141202164501")=nurseId
	s ret=""
	s nurseId=$ZConvert(nurseId,"U")
	s id=$O(^DHCMGNUR.MgPersonsI("SSID"," "_nurseId,""))
	i id'=""
	{
		s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
		s nurseDep=a.PersonDepDR
		s ret=nurseDep
	}
	q ret
}

ClassMethod getSurvyFlag(datestr As %String) As %String
{
	;s ^TMP("g20141202184001")=datestr
	s date=$ZDH(datestr,3)
	s ret=""
	s stDate="" f  s stDate=$O(^DHCMGNUR.MgDepartConsSurveyI("dateFlag",stDate)) q:stDate=""  d
	.q:date<stDate
	.s endDate="" f  s endDate=$O(^DHCMGNUR.MgDepartConsSurveyI("dateFlag",stDate,endDate)) q:endDate=""  d
	..q:date>endDate
	..s id=$O(^DHCMGNUR.MgDepartConsSurveyI("dateFlag",stDate,endDate,""))
	..s ret=id
	q ret
}

Storage Default
{
<Data name="MgDepartConsSurveyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StDate</Value>
</Value>
<Value name="3">
<Value>EndDate</Value>
</Value>
<Value name="4">
<Value>NurseID</Value>
</Value>
<Value name="5">
<Value>FillDate</Value>
</Value>
<Value name="6">
<Value>WardID</Value>
</Value>
<Value name="7">
<Value>DataFlag</Value>
</Value>
<Value name="8">
<Value>TabTitle</Value>
</Value>
<Value name="9">
<Value>FillTime</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MgDepartConsSurveyD</DataLocation>
<DefaultData>MgDepartConsSurveyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MgDepartConsSurveyD</IdLocation>
<IndexLocation>^DHCMGNUR.MgDepartConsSurveyI</IndexLocation>
<StreamLocation>^DHCMGNUR.MgDepartConsSurveyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
