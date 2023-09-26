Class User.DHCMGNURCPReport Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property CpStDate As %Library.Date(FORMAT = 1);

Property CpEnDate As %Library.Date(FORMAT = 1);

Property CpItm As User.DHCNURMGQualItm;

Property CpDate As %Library.Date(FORMAT = 1);

Property CpTime As %Library.Time(FORMAT = 1);

Property CpDep As %String(TRUNCATE = 1);

Property CpTitle As %String(TRUNCATE = 1);

Property CpUser As %String(TRUNCATE = 1);

Property CpMem As %String(TRUNCATE = 1);

Property CpStatus As %Library.String(DISPLAYLIST = ",New,Achieve", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",N,A");

Index Date On (CpStDate, CpItm);

Index Status On (CpItm, CpStatus);

ClassMethod GetCpID(CpCode As %String) As %String
{
  //s a=##class(User.DHCMGNURCPReport).GetCpID()
     s CpCode=$ZConvert(CpCode,"U")
     s CpCode=" "_CpCode
     s id="" s id=$O(^User.DHCNURMGQualItmI("Code",CpCode,id)) 
     b
     q:id=""
     s rw=""  s rw=$O(^User.DHCMGNURCPReportI("Status",id," N",rw))
     if rw="" q ""
     b
     if rw'="" s flag=..ifdate(rw)
     b //
     if flag="1" q rw
     e  q ""
}

ClassMethod GetCpRp(CpId As %String) As %String
{
  //s a=##class(User.DHCMGNURCPReport).GetCpID()
     s rw=""  s rw=$O(^User.DHCMGNURCPReportI("Status",CpId," N",rw))
     q rw
}

ClassMethod ifdate(CPRepId) As %String
{
 //s a=##class(User.DHCMGNURCPReport).ifdate()
    s flag="0"
   	s date=$P($H,",")
    s a=^User.DHCMGNURCPReportD(CPRepId)
    s stat=$listGet(a,9)
    s stdate=$listGet(a,6), enddate=$listGet(a,4)
    if stat="A" s flag="3" //完成
    if (((date'<stdate)&(date'>enddate))&(stat="N")) s flag="1"
    if (date<stdate) s flag="2" //还没开始
    if (date>enddate) s flag="3" //已结束
    q flag
}

ClassMethod GetCpRpStatus(id) As %String
{
 //取状态
	s flag="0"
	s b=^User.DHCMGNURQualReportD(id)
	s CPRepId=$ListGet(b,12)
	if CPRepId="" q flag
	s flag=..ifdate(CPRepId)
    q flag
}

Storage Default
{
<Data name="DHCMGNURCPReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CpDate</Value>
</Value>
<Value name="3">
<Value>CpDep</Value>
</Value>
<Value name="4">
<Value>CpEnDate</Value>
</Value>
<Value name="5">
<Value>CpItm</Value>
</Value>
<Value name="6">
<Value>CpStDate</Value>
</Value>
<Value name="7">
<Value>CpTime</Value>
</Value>
<Value name="8">
<Value>CpMem</Value>
</Value>
<Value name="9">
<Value>CpStatus</Value>
</Value>
<Value name="10">
<Value>CpUser</Value>
</Value>
<Value name="11">
<Value>CpTitle</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGNURCPReportD</DataLocation>
<DefaultData>DHCMGNURCPReportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNURCPReportD</IdLocation>
<IndexLocation>^User.DHCMGNURCPReportI</IndexLocation>
<StreamLocation>^User.DHCMGNURCPReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
