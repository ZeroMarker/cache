Class DHCEPRFS.INST.SubmitRemarks Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property RemarksCode As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

Property RemarksDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

Property Remarks As %String(MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 4 ];

Property Available As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

Property CreateDate As %Date [ SqlColumnNumber = 6 ];

Property CreateTime As %Time [ SqlColumnNumber = 7 ];

Property CreateUserID As %String(TRUNCATE = 1) [ SqlColumnNumber = 8 ];

Index IdxRemarksCode On RemarksCode [ Unique ];

Index IdxMain On (Available, CreateUserID, CreateDate, CreateTime);

Storage Default
{
<Data name="SubmitRemarksDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryCode</Value>
</Value>
<Value name="3">
<Value>CategoryDesc</Value>
</Value>
<Value name="4">
<Value>Remarks</Value>
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
<Value>CreateUserID</Value>
</Value>
<Value name="9">
<Value>RemarksCode</Value>
</Value>
<Value name="10">
<Value>RemarksDesc</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.SubmitRemarksD</DataLocation>
<DefaultData>SubmitRemarksDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.INST.SubmitRemarksD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.SubmitRemarksI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.SubmitRemarksS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
