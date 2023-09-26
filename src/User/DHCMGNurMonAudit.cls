Class User.DHCMGNurMonAudit Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//月报审核记录

Property AuditUser As User.DHCMGPersons;

Property AuditDate As %Library.Date(FORMAT = 1);

Property AuditSmUser As User.DHCMGPersons;

Property AuditTime As %Library.Time;

Property AuditSmDate As %Library.Date(FORMAT = 1);

Property AuditSmTime As %Library.Time;

Property AuditStDate As %Library.Date(FORMAT = 1);

Property AuditEdDate As %Library.Date(FORMAT = 1);

Property AuditDep As %Library.String(TRUNCATE = 1);

Property AuditStat As %Library.String(DISPLAYLIST = ",Submit,Audit,Refund", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",S,A,R");

Property AuditMem As %Library.String(TRUNCATE = 1);

Index DepDate On (AuditDep, AuditSmDate);

ClassMethod AuditArrange(parr As %String) As %String
{
	//月报审核
	//w ##class(User.DHCMGNurMonAudit).AuditArrange("1^1^1")
	s id=$P(parr,"^",1)
	s user=$P(parr,"^",2)
	s dep=$P(parr,"^",3)
	s a=##class(User.DHCMGNurMonAudit).%OpenId(id)
	s a.AuditUser=##class(User.DHCMGPersons).%OpenId(user)
	s a.AuditDate=+$H
	s a.AuditTime=$P($H,",",2)
	s a.AuditStat="A" //审核状态
	d a.%Save()
	q 0
}

ClassMethod SubmitArrange(parr As %String) As %String
{
	//月报提交
	//w ##class(User.DHCMGNurMonAudit).AuditArrange("^1^2010-07-01^2010-07-31^1")
	s id=$P(parr,"^",1)
	s user=$P(parr,"^",2)
	s stdate=$P(parr,"^",3)
	s edate=$P(parr,"^",4)
	s dep=$P(parr,"^",5)
	s stdate=$ZDH(stdate,3)
	s edate=$ZDH(edate,3)
	if id="" s a=##class(User.DHCMGNurMonAudit).%New()
	e  s a=##class(User.DHCMGNurMonAudit).%OpenId(id)
	s a.AuditSmUser=##class(User.DHCMGPersons).%OpenId(user)
	s a.AuditStDate=stdate
	s a.AuditEdDate=edate
	s a.AuditSmDate=+$H
	s a.AuditSmTime=$P($H,",",2)
	s a.AuditDep=dep //##class(User.CTLoc).%OpenId(dep)
	s a.AuditStat="S" //提交状态
	d a.%Save()
	q a.%Id()
}

ClassMethod RetArrange(parr As %String) As %String
{
 	//退回月报记录
	//w ##class(User.DHCMGNurMonAudit).AuditArrange("^1^2010-07-01^2010-07-31^1")
	s id=$P(parr,"^",1)
	s user=$P(parr,"^",2)
	s mem=$P(parr,"^",3)
	if id="" s a=##class(User.DHCMGNurMonAudit).%New()
	e  s a=##class(User.DHCMGNurMonAudit).%OpenId(id)
	s a.AuditStat="R" //提交状态
	s a.AuditMem=mem
	d a.%Save()
	q 0
}

Storage Default
{
<Data name="DHCMGNurMonAuditDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AuditDate</Value>
</Value>
<Value name="3">
<Value>AuditDep</Value>
</Value>
<Value name="4">
<Value>AuditEdDate</Value>
</Value>
<Value name="5">
<Value>AuditMem</Value>
</Value>
<Value name="6">
<Value>AuditSmDate</Value>
</Value>
<Value name="7">
<Value>AuditSmTime</Value>
</Value>
<Value name="8">
<Value>AuditSmUser</Value>
</Value>
<Value name="9">
<Value>AuditStDate</Value>
</Value>
<Value name="10">
<Value>AuditStat</Value>
</Value>
<Value name="11">
<Value>AuditTime</Value>
</Value>
<Value name="12">
<Value>AuditUser</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGNurMonAuditD</DataLocation>
<DefaultData>DHCMGNurMonAuditDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGNurMonAuditD</IdLocation>
<IndexLocation>^User.DHCMGNurMonAuditI</IndexLocation>
<StreamLocation>^User.DHCMGNurMonAuditS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
