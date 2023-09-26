Class DHCEPRFS.INST.MRLog Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property MREpisodeID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

Property MRStatus As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

Property CreateDate As %Date [ SqlColumnNumber = 4 ];

Property CreateTime As %Time [ SqlColumnNumber = 5 ];

Property CreateUserID As %String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

Property ModifyDate As %Date [ SqlColumnNumber = 7 ];

Property ModifyTime As %Time [ SqlColumnNumber = 8 ];

Property ModifyUserID As %String(TRUNCATE = 1) [ SqlColumnNumber = 9 ];

Property GenPages As %Integer [ SqlColumnNumber = 10 ];

Property ScanPages As %Integer [ SqlColumnNumber = 11 ];

Property MRMedRecordID As %String(TRUNCATE = 1) [ SqlColumnNumber = 12 ];

Property PageStatus As %String(TRUNCATE = 1) [ SqlColumnNumber = 13 ];

Property PageModifyDate As %Date [ SqlColumnNumber = 14 ];

Property PageModifyTime As %Time [ SqlColumnNumber = 15 ];

Property PageModifyUserID As %String(TRUNCATE = 1) [ SqlColumnNumber = 16 ];

Relationship TheMRLogDetail As DHCEPRFS.INST.MRLogDetail [ Cardinality = children, Inverse = TheMRLog ];

Index IdxUnique On (MREpisodeID, MRMedRecordID) [ Unique ];

Index IdxMain On MREpisodeID;

Index IdxMRMedRecord On MRMedRecordID;

Index IdxMRStatus On MRStatus;

Index IdxModifyDateTime On (ModifyDate, ModifyTime);

Index IdxCreateDateTime On (CreateDate, CreateTime);

Index IdxPageStatus On PageStatus;

Index IdxPageModifyDateTime On (PageModifyDate, PageModifyTime);

Storage Default
{
<Data name="MRLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MREpisodeID</Value>
</Value>
<Value name="3">
<Value>MRStatus</Value>
</Value>
<Value name="4">
<Value>CreateDate</Value>
</Value>
<Value name="5">
<Value>CreateTime</Value>
</Value>
<Value name="6">
<Value>CreateUserID</Value>
</Value>
<Value name="7">
<Value>ModifyDate</Value>
</Value>
<Value name="8">
<Value>ModifyTime</Value>
</Value>
<Value name="9">
<Value>ModifyUserID</Value>
</Value>
<Value name="10">
<Value>GenPages</Value>
</Value>
<Value name="11">
<Value>ScanPages</Value>
</Value>
<Value name="12">
<Value>MRMedRecordID</Value>
</Value>
<Value name="13">
<Value>PageStatus</Value>
</Value>
<Value name="14">
<Value>PageModifyDate</Value>
</Value>
<Value name="15">
<Value>PageModifyTime</Value>
</Value>
<Value name="16">
<Value>PageModifyUserID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.MRLogD</DataLocation>
<DefaultData>MRLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.MRLogD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.MRLogI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.MRLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
