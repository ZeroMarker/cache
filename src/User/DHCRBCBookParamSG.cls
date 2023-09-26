Class User.DHCRBCBookParamSG Extends (%Persistent, %XML.Adaptor) [ ProcedureBlock, SqlTableName = DHCRBC_BookParamSG ]
{

Relationship BPParref As User.DHCRBCBookParam [ Cardinality = parent, Inverse = BPChild ];

Property ServiceGroupID As %String [ Required ];

Property ServiceGroupCode As %String;

Storage Default
{
<Data name="DHCRBCBookParamSGDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ServiceGroupID</Value>
</Value>
<Value name="3">
<Value>ServiceGroupCode</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("BPChild")</DataLocation>
<DefaultData>DHCRBCBookParamSGDefaultData</DefaultData>
<IdLocation>{%%PARENT}("BPChild")</IdLocation>
<IndexLocation>{%%PARENT}("BPChild")</IndexLocation>
<StreamLocation>^User.DHCRBCBookParamSGS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
