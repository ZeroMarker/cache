/// 字典表
Class CT.AN.Dictionary Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Dictionary ]
{

/// 字典代码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 字典名称
Property Description As %String [ SqlColumnNumber = 3 ];

/// 激活状态
Property Active As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 4 ];

/// 代码唯一性约束
Index ICode On Code [ Unique ];

Storage Default
{
<Data name="DictionaryDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^CT.AN.DictionaryD</DataLocation>
<DefaultData>DictionaryDefaultData</DefaultData>
<IdLocation>^CT.AN.DictionaryD</IdLocation>
<IndexLocation>^CT.AN.DictionaryI</IndexLocation>
<StreamLocation>^CT.AN.DictionaryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
