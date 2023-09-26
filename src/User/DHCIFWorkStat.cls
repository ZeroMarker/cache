Class User.DHCIFWorkStat Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// Work_OeoreId
Property WorkOeoreId As %String(TRUNCATE = 1);

/// Work_Date
Property WorkDate As %Library.Date(FORMAT = 1);

/// Work_Item
Property WorkItem As User.DHCIFWorkItem;

/// Work_User
Property WorkUser As %String(TRUNCATE = 1);

/// Work_Loc
Property WorkLoc As %String(TRUNCATE = 1);

/// Work_FailureNum
Property WorkFailureNum As %String(TRUNCATE = 1);

Index UserDr On (WorkUser, WorkDate);

Index CTLoc On (WorkLoc, WorkDate);

Index Oeore On (WorkOeoreId, WorkItem);

ClassMethod Save(Parr As %String) As %String
{
	s id=$P(Parr,"^",1)
	s OeoreId=$P(Parr,"^",2)
	s Date=$P(Parr,"^",3)
	s Item=$P(Parr,"^",4)
	s UserDr=$P(Parr,"^",5)
	s Loc=$P(Parr,"^",6)
	s FailureNum=$P(Parr,"^",7)
	if id="" s a=##class(User.DHCIFWorkStat).%New()
	else  s a=##class(User.DHCIFWorkStat).%OpenId(id)
	s a.WorkOeoreId=OeoreId
	s a.WorkDate=Date
	s a.WorkItem=##class(User.DHCIFWorkItem).%OpenId(Item)
	s a.WorkUser=UserDr
	s a.WorkLoc=Loc
	s a.WorkFailureNum=FailureNum
	d a.%Save()
	q 0
}

Storage Default
{
<Data name="DHCIFWorkStatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkDate</Value>
</Value>
<Value name="3">
<Value>WorkFailureNum</Value>
</Value>
<Value name="4">
<Value>WorkItem</Value>
</Value>
<Value name="5">
<Value>WorkLoc</Value>
</Value>
<Value name="6">
<Value>WorkOeoreId</Value>
</Value>
<Value name="7">
<Value>WorkUser</Value>
</Value>
</Data>
<DataLocation>^User.DHCIFWorkStatD</DataLocation>
<DefaultData>DHCIFWorkStatDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCIFWorkStatD</IdLocation>
<IndexLocation>^User.DHCIFWorkStatI</IndexLocation>
<StreamLocation>^User.DHCIFWorkStatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
