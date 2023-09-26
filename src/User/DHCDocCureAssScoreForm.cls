Class User.DHCDocCureAssScoreForm Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = DCASF_RowID, SqlTableName = DHC_DocCureAssScoreForm ]
{

Relationship DCASFParRefDr As User.DHCDocCureAssScore [ Cardinality = parent, Inverse = ChildDHCDocCureAssScoreForm, Required, SqlFieldName = DCASF_ParRef_Dr ];

/// 元素ID  EC_key
Property DCASFkey As %String [ SqlColumnNumber = 2, SqlFieldName = DCASF_key ];

/// 元素值  EC_Val
Property DCASFVal As %String [ SqlColumnNumber = 3, SqlFieldName = DCASF_Val ];

/// 元素类型  EC_Type
Property DCASFType As %String [ SqlColumnNumber = 4, SqlFieldName = DCASF_Type ];

Storage Default
{
<Data name="DHCDocCureAssScoreFormDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DCASFkey</Value>
</Value>
<Value name="3">
<Value>DCASFVal</Value>
</Value>
<Value name="4">
<Value>DCASFType</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildDHCDocCureAssScoreForm")</DataLocation>
<DefaultData>DHCDocCureAssScoreFormDefaultData</DefaultData>
<IdLocation>^User.DHCDocCureAssScoreC("ChildDHCDocCureAssScoreForm")</IdLocation>
<IndexLocation>^User.DHCDocCureAssScoreFormI</IndexLocation>
<StreamLocation>^User.DHCDocCureAssScoreFormS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
