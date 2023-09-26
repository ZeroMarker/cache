Class User.DHCMGTurnPlan Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property plStdate As %Library.Date(FORMAT = 1);

Property plEndate As %Library.Date(FORMAT = 1);

Property mDate As %Library.Date(FORMAT = 1);

Property mtime As %Library.Time;

Property mUser As User.DHCMGPersons;

Property plmem As %String(TRUNCATE = 1);

Property plStatus As %Library.String(DISPLAYLIST = ",New,Achieve", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",N,A");

Index Date On plStdate;

//轮转计划表

ClassMethod save(par) As %String
{
 //s a=##class(User.DHCMGTurnPlan).save()
 //s par="^2009-12-1^2009-12-31^3552^dfsdfdsf"
	s id=$P(par,"^")
	s stdate=$P(par,"^",2)
	s eddate=$P(par,"^",3)
	s user=$P(par,"^",4)
	s mem=$P(par,"^",5)
	if id="" s a=##class(User.DHCMGTurnPlan).%New()
	else  s a=##class(User.DHCMGTurnPlan).%OpenId(id)
	s a.plStdate=$ZDH(stdate,3)
	s a.plEndate=$ZDH(eddate,3)
	s a.mDate=$P($H,",",1)
	s a.mtime=$P($H,",",2)
	s a.mUser=##class(User.DHCMGPersons).%OpenId(user)
	s a.plmem=mem
	d a.%Save()
	q 0
}

Storage Default
{
<Data name="DHCMGTurnPlanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>mDate</Value>
</Value>
<Value name="3">
<Value>mUser</Value>
</Value>
<Value name="4">
<Value>mtime</Value>
</Value>
<Value name="5">
<Value>plEndate</Value>
</Value>
<Value name="6">
<Value>plStdate</Value>
</Value>
<Value name="7">
<Value>plmem</Value>
</Value>
<Value name="8">
<Value>plStatus</Value>
</Value>
</Data>
<DataLocation>^User.DHCMGTurnPlanD</DataLocation>
<DefaultData>DHCMGTurnPlanDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCMGTurnPlanD</IdLocation>
<IndexLocation>^User.DHCMGTurnPlanI</IndexLocation>
<StreamLocation>^User.DHCMGTurnPlanS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
