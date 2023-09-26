/// 治疗评定量表表单元素
Class User.DHCDocCureAssScaleForm Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DCASF_RowID, SqlTableName = DHC_DocCureAssScaleForm ]
{

Relationship DCASFParRefDr As User.DHCDocCureAssScale [ Cardinality = parent, Inverse = ChildDHCDocCureAssScaleForm, Required, SqlFieldName = DCASF_ParRef_Dr ];

/// 元素ID  DCAF_key
Property DCASFkey As %String [ SqlColumnNumber = 2, SqlFieldName = DCASF_key ];

/// 元素值  DCAF_Text
Property DCASFText As %String [ SqlColumnNumber = 3, SqlFieldName = DCASF_Text ];

/// 元素类型  DCAF_Type
Property DCASFType As %String [ SqlColumnNumber = 4, SqlFieldName = DCASF_Type ];

Storage Default
{
<Data name="DHCDocCureAssScaleFormDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DCASFkey</Value>
</Value>
<Value name="3">
<Value>DCASFText</Value>
</Value>
<Value name="4">
<Value>DCASFType</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildDHCDocCureAssScaleForm")</DataLocation>
<DefaultData>DHCDocCureAssScaleFormDefaultData</DefaultData>
<IdLocation>^User.DHCDocCureAssScaleC("ChildDHCDocCureAssScaleForm")</IdLocation>
<IndexLocation>^User.DHCDocCureAssScaleFormI</IndexLocation>
<StreamLocation>^User.DHCDocCureAssScaleFormS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
