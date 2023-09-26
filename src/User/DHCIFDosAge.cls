Class User.DHCIFDosAge Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// DosAge_Adm
Property DosAgeAdm As %String(TRUNCATE = 1);

/// DosAge_OeoreDr
Property DosAgeOeoreDr As %String(TRUNCATE = 1);

/// DosAge_Date 
Property DosAgeDate As %Library.Date(FORMAT = 1);

/// DosAge_Time
Property DosAgeTime As %Library.Time;

/// DosAge_UserId
Property DosAgeUserId As %String(TRUNCATE = 1);

/// DosAge_OeordStatus
Property DosAgeOeordStatus As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",Y,N");

/// DosAge_PatRegNo
Property DosAgePatRegNo As %String(TRUNCATE = 1);

Index Oeore On DosAgeOeoreDr;

Index Date On DosAgeDate;

Index Adm On DosAgeAdm;

Index UserDr On (DosAgeUserId, DosAgeDate);

ClassMethod Save(Parr As %String) As %String
{
	s id=$P(Parr,"^",1)
	s Adm=$P(Parr,"^",2)
	s OeoreDr=$P(Parr,"^",3)
	s Date=$P(Parr,"^",4)
	s Time=$P(Parr,"^",5)
	s UserId=$P(Parr,"^",6)
	s OeordStatus=$P(Parr,"^",7)
	s PatRegNo=$P(Parr,"^",8)
	if id="" s a=##class(User.DHCIFDosAge).%New()
	else  s a=##class(User.DHCIFDosAge).%OpenId(id)
	s a.DosAgeAdm=Adm
	s a.DosAgeOeoreDr=OeoreDr
	s a.DosAgeDate=Date
	s a.DosAgeTime=Time
	s a.DosAgeUserId=UserId
	s a.DosAgeOeordStatus=OeordStatus
	s a.DosAgePatRegNo=PatRegNo
	d a.%Save()
	q 0
}

Storage Default
{
<Data name="DHCIFDosAgeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DosAgeAdm</Value>
</Value>
<Value name="3">
<Value>DosAgeDate</Value>
</Value>
<Value name="4">
<Value>DosAgeOeordStatus</Value>
</Value>
<Value name="5">
<Value>DosAgeOeoreDr</Value>
</Value>
<Value name="6">
<Value>DosAgePatRegNo</Value>
</Value>
<Value name="7">
<Value>DosAgeTime</Value>
</Value>
<Value name="8">
<Value>DosAgeUserId</Value>
</Value>
</Data>
<DataLocation>^User.DHCIFDosAgeD</DataLocation>
<DefaultData>DHCIFDosAgeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCIFDosAgeD</IdLocation>
<IndexLocation>^User.DHCIFDosAgeI</IndexLocation>
<StreamLocation>^User.DHCIFDosAgeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
