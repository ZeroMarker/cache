Class User.DHCMGFtpRecord Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property FtpUser As %String(TRUNCATE = 1);

Property FtpDate As %Library.Date(FORMAT = 1) [ InitialExpression = {+$p($h,",",1)}, Required ];

Property FtpTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required ];

Property FtpMem As %Library.String(MAXLEN = 100, TRUNCATE = 0);

ClassMethod Save(parr As %String) As %String
{
	s user=$P(parr,"^",1)
	s mem=$P(parr,"^",2)
	s a=##class(User.DHCMGFtpRecord).%New()
	s a.FtpUser=user
	s a.FtpMem=mem
	d a.%Save()
	q 0
}

Storage Default
{
<Data name="DHCMGFtpRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FtpDate</Value>
</Value>
<Value name="3">
<Value>FtpTime</Value>
</Value>
<Value name="4">
<Value>FtpUser</Value>
</Value>
<Value name="5">
<Value>FtpMem</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGFtpRecordD</DataLocation>
<DefaultData>DHCMGFtpRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGFtpRecordD</IdLocation>
<IndexLocation>^User.DHCMGFtpRecordI</IndexLocation>
<StreamLocation>^User.DHCMGFtpRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
