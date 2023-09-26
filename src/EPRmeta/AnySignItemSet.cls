Class EPRmeta.AnySignItemSet Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property EPRTemplateName As %String(TRUNCATE = 1);

Property PrintDocID As %String(TRUNCATE = 1);

Property AliasName As %String(TRUNCATE = 1);

Property SeqNum As %Integer;

Property GrpName As %String(TRUNCATE = 1);

Property GrpNum As %Integer;

//备用字段

Property SignOption As %String(TRUNCATE = 1);

Index IdxPrtDoc On (PrintDocID, SeqNum) [ Unique ];

Index IdxSeqInGrp On (PrintDocID, GrpNum, SeqNum);

Index IdxGrpName On (PrintDocID, GrpNum, GrpName);

Storage Default
{
<Data name="AnySignItemSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EPRTemplateName</Value>
</Value>
<Value name="3">
<Value>PrintDocID</Value>
</Value>
<Value name="4">
<Value>SignOption</Value>
</Value>
<Value name="5">
<Value>SeqNum</Value>
</Value>
<Value name="6">
<Value>AliasName</Value>
</Value>
<Value name="7">
<Value>GrpName</Value>
</Value>
<Value name="8">
<Value>GrpNum</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.AnySignItemSetD</DataLocation>
<DefaultData>AnySignItemSetDefaultData</DefaultData>
<IdLocation>^DHCEPRM.AnySignItemSetD</IdLocation>
<IndexLocation>^DHCEPRM.AnySignItemSetI</IndexLocation>
<StreamLocation>^DHCEPRM.AnySignItemSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
