Class DHCEPRFS.INST.ReviewReasonCategory Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property UserID As %String(TRUNCATE = 1);

Property CategoryCode As %String(TRUNCATE = 1);

Property CategoryDesc As %String(TRUNCATE = 1);

Property Reason As %String(TRUNCATE = 1);

Property Available As %String(TRUNCATE = 1);

Property CreateDate As %Date;

Property CreateTime As %Time;

Index IdxMain On (Available, UserID, CreateDate, CreateTime);

Index IdxCategoryCode On CategoryCode [ Unique ];

Storage Default
{
<Data name="ReviewReasonCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UserID</Value>
</Value>
<Value name="3">
<Value>Category</Value>
</Value>
<Value name="4">
<Value>Reason</Value>
</Value>
<Value name="5">
<Value>Available</Value>
</Value>
<Value name="6">
<Value>CreateDate</Value>
</Value>
<Value name="7">
<Value>CreateTime</Value>
</Value>
<Value name="8">
<Value>CategoryDesc</Value>
</Value>
<Value name="9">
<Value>CategoryCode</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.ReviewReasonCD</DataLocation>
<DefaultData>ReviewReasonCategoryDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.ReviewReasonCD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.ReviewReasonCI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.ReviewReasonCS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
