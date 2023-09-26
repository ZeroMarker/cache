Class User.DHCMGPostAdjust Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property AdjPersonDR As %String(TRUNCATE = 1);

Property AdjDate As %Library.Date(FORMAT = 1);

Property AdjOldPostDR As %String(TRUNCATE = 1);

Property AdjNewPostDR As %String(TRUNCATE = 1);

Property AdjRecDate As %Library.Date(FORMAT = 1);

Property AdjRecTime As %Library.Time [ InitialExpression = {+$p($h,",",2)}, Required ];

Property AdjRecUser As %String(TRUNCATE = 1);

Property AdjMem As %String(TRUNCATE = 1);

Index Person On AdjPersonDR;

Index PerDate On (AdjPersonDR, AdjDate);

Index AdjDate On AdjDate;

ClassMethod SaveAdjust(parr As %String) As %String
{
	//s parr="^186^5^2009-02-24^4^eee^561^1079"
	s id=$P(parr,"^",1)
	s pers=$P(parr,"^",2)
	s date=$P(parr,"^",4)
	s oldpst=$P(parr,"^",3)
	s newpst=$P(parr,"^",5)
	s mem=$P(parr,"^",6)
	s user=$P(parr,"^",7)
	
	if id="" s adj=##class(User.DHCMGPostAdjust).%New()
	e  s adj=##class(User.DHCMGPostAdjust).%OpenId(id)
	s adj.AdjPersonDR=pers
	s adj.AdjDate=$ZDH(date,3)
	s adj.AdjOldPostDR=oldpst
	s adj.AdjNewPostDR=newpst
	s adj.AdjRecDate=+$H
	s adj.AdjRecTime=$P($H,",",2)
	s adj.AdjRecUser=user
	d adj.%Save()
	q 0
}

Storage Default
{
<Data name="DHCMGPostAdjustDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AdjDate</Value>
</Value>
<Value name="3">
<Value>AdjMem</Value>
</Value>
<Value name="4">
<Value>AdjNewPostDR</Value>
</Value>
<Value name="5">
<Value>AdjOldPostDR</Value>
</Value>
<Value name="6">
<Value>AdjPersonDR</Value>
</Value>
<Value name="7">
<Value>AdjRecDate</Value>
</Value>
<Value name="8">
<Value>AdjRecTime</Value>
</Value>
<Value name="9">
<Value>AdjRecUser</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGPostAdjustD</DataLocation>
<DefaultData>DHCMGPostAdjustDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGPostAdjustD</IdLocation>
<IndexLocation>^User.DHCMGPostAdjustI</IndexLocation>
<StreamLocation>^User.DHCMGPostAdjustS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
