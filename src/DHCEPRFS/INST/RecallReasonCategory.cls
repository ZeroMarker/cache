Class DHCEPRFS.INST.RecallReasonCategory Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property UserID As %String(TRUNCATE = 1);

Property CategoryCode As %String(TRUNCATE = 1);

Property CategoryDesc As %String(TRUNCATE = 1);

Property Reason As %String(TRUNCATE = 1);

Property Available As %String(TRUNCATE = 1);

Property CreateDate As %Date;

Property CreateTime As %Time;

Index IdxCategoryCode On CategoryCode [ Unique ];

Index IdxMain On (Available, UserID, CreateDate, CreateTime);

Storage Default
{
<Data name="RecallReasonCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>CategoryCode</Value>
</Value>
<Value name="4">
<Value>CategoryDesc</Value>
</Value>
<Value name="5">
<Value>Reason</Value>
</Value>
<Value name="6">
<Value>Available</Value>
</Value>
<Value name="7">
<Value>CreateDate</Value>
</Value>
<Value name="8">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.RecallReasonCatD</DataLocation>
<DefaultData>RecallReasonCategoryDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.RecallReasonCatD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.RecallReasonCatI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.RecallReasonCatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
