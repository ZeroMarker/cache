Class User.DHCNurSyPatRec Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property SyLoc As %String(TRUNCATE = 1);

Property SyPatId As %String(TRUNCATE = 1);

Property SyPatEpisode As %String(TRUNCATE = 1);

Property SySeatDr As %String(TRUNCATE = 1);

Property SyUpdateDate As %Library.Date;

Property SyUpdateTime As %Library.Time;

Property SyUpdateUser As %String(TRUNCATE = 1);

Property SyPatStatus As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",Y,N");

Property SyLeavDate As %Library.Date;

Property SyLeavTime As %Library.Time;

Property SyDocDr As User.CTCareProv;

Index pat On (SyUpdateDate, SyPatId, SyPatEpisode, SySeatDr);

Index seat On (SyLoc, SySeatDr, SyPatStatus);

Index patseat On (SyLoc, SyPatEpisode);

Index epiPatSeat On SyPatEpisode;

Index patseatStatus On (SyLoc, SyPatEpisode, SyPatStatus);

Index sypatid On (SyLoc, SyPatId, SyPatStatus);

Index patient On (SyPatId, SyPatStatus);

ClassMethod save(parr As %String) As %String
{
 
	s id=$P(parr,"^",1)
	s loc=$P(parr,"^",2)
	s patno=$P(parr,"^",3)
	s episode=$P(parr,"^",4)
	s Seatid=$P(parr,"^",5)
	s user=$P(parr,"^",6)
	s stat=$P(parr,"^",7)
	//置空其他
	d ##class(web.DHCNurSyComm).ClearPatSeat(episode,loc,user)
	if id="" s a=##class(User.DHCNurSyPatRec).%New()
	e  s a=##class(User.DHCNurSyPatRec).%OpenId(id)
	s a.SyLoc=loc
	s a.SyPatId=patno
	s a.SyPatEpisode=episode
	s a.SySeatDr=Seatid
	s a.SyPatStatus=stat
	if stat="Y"
	{
	  s a.SyUpdateDate=$P($H,",",1)
	  s a.SyUpdateTime=$P($H,",",2)
	  s a.SyUpdateUser=user
	}
	if (stat="N")
	{
	  s a.SyLeavDate=$P($H,",",1)
	  s a.SyLeavTime=$P($H,",",2)
	  s a.SyUpdateUser=user
	}
	d a.%Save()
	//s leavdate=$P(parr,"^")
}

Storage Default
{
<Data name="DHCNurSyPatRecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SyLoc</Value>
</Value>
<Value name="3">
<Value>SyPatEpisode</Value>
</Value>
<Value name="4">
<Value>SyPatId</Value>
</Value>
<Value name="5">
<Value>SySeatDr</Value>
</Value>
<Value name="6">
<Value>SyUpdateDate</Value>
</Value>
<Value name="7">
<Value>SyUpdateTime</Value>
</Value>
<Value name="8">
<Value>SyUpdateUser</Value>
</Value>
<Value name="9">
<Value>SyPatStatus</Value>
</Value>
<Value name="10">
<Value>SyLeavDate</Value>
</Value>
<Value name="11">
<Value>SyLeavTime</Value>
</Value>
<Value name="12">
<Value>SyDocDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCNurSyPatRecD</DataLocation>
<DefaultData>DHCNurSyPatRecDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCNurSyPatRecD</IdLocation>
<IndexLocation>^User.DHCNurSyPatRecI</IndexLocation>
<StreamLocation>^User.DHCNurSyPatRecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
