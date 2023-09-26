Class User.EnsSystemType Extends (%Persistent, %XML.Adaptor) [ SqlTableName = Ens_SystemType ]
{

/// 系统分类代码
Property ESTCode As %String(COLLATION = "EXACT", MAXLEN = 32767) [ Required, SqlFieldName = EST_Code ];

/// 系统分类描述
Property ESTDesc As %String(COLLATION = "EXACT", MAXLEN = 32767) [ Required, SqlFieldName = EST_Desc ];

/// 有效标志（Y:启用；N:停用）
Property ESTEffectiveFlag As %String(COLLATION = "EXACT") [ SqlFieldName = EST_EffectiveFlag ];

Index IndexESTCode On ESTCode [ PrimaryKey, Type = index, Unique ];

Index IndexEffectiveESTCode On (ESTEffectiveFlag, ESTCode);

Storage Default
{
<Data name="EnsSystemTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ESTCode</Value>
</Value>
<Value name="3">
<Value>ESTDesc</Value>
</Value>
<Value name="4">
<Value>ESTEffectiveFlag</Value>
</Value>
</Data>
<DataLocation>^Code.ENS.EnsSystemTypeD</DataLocation>
<DefaultData>EnsSystemTypeDefaultData</DefaultData>
<IdLocation>^Code.ENS.EnsSystemTypeD</IdLocation>
<IndexLocation>^Code.ENS.EnsSystemTypeI</IndexLocation>
<StreamLocation>^Code.ENS.EnsSystemTypeD</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
