Class User.DHCMGSysLog Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//登录日志

Property username As %String(TRUNCATE = 1);

Property hosname As %String(TRUNCATE = 1);

Property hosip As %String(TRUNCATE = 1);

Property hosmac As %String(TRUNCATE = 1);

Property logDate As %Library.Date(FORMAT = 1);

Property logTime As %Library.Time;

ClassMethod save(parr As %String) As %String
{
   //s a=##class(User.DHCMGSysLog).save()
   // s parr="李艳华^legend-564cfec9^10.193.18.151^00:1E:EC:10:74:8C"

	s user=$P(parr,"^",1)
	s hosname=$P(parr,"^",2)
	s ip=$P(parr,"^",3)
	s mac=$P(parr,"^",4)
	s a=##class(User.DHCMGSysLog).%New()
	s a.username=user
	s a.hosname=hosname
	s a.hosip=ip
	s a.hosmac=mac
	s a.logDate=+$H
	s a.logTime=$P($H,",",2)
	d a.%Save()
	q 0
}

Storage Default
{
<Data name="DHCMGSysLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>hosip</Value>
</Value>
<Value name="3">
<Value>hosmac</Value>
</Value>
<Value name="4">
<Value>hosname</Value>
</Value>
<Value name="5">
<Value>logDate</Value>
</Value>
<Value name="6">
<Value>logTime</Value>
</Value>
<Value name="7">
<Value>username</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGSysLogD</DataLocation>
<DefaultData>DHCMGSysLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGSysLogD</IdLocation>
<IndexLocation>^User.DHCMGSysLogI</IndexLocation>
<StreamLocation>^User.DHCMGSysLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
