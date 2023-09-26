Class User.EnsSystem Extends (%Persistent, %XML.Adaptor) [ SqlTableName = Ens_System ]
{

/// 系统代码
Property ESysCode As %String(COLLATION = "EXACT", MAXLEN = 32767) [ Required, SqlFieldName = ESys_Code ];

/// 系统描述
Property ESysDesc As %String(COLLATION = "EXACT", MAXLEN = 32767) [ Required, SqlFieldName = ESys_Desc ];

/// 有效标志（Y:启用；N:停用）
Property ESysEffectiveFlag As %String(COLLATION = "EXACT") [ SqlFieldName = ESys_EffectiveFlag ];

/// 系统分类代码 对应表：Ens_SystemType
Property ESysTypeCode As %String(COLLATION = "EXACT", MAXLEN = 32767) [ SqlFieldName = ESys_TypeCode ];

Index IndexESysCode On ESysCode [ PrimaryKey, Type = index, Unique ];

Index IndexEffectiveESysCode On (ESysEffectiveFlag, ESysCode);

Index IndexSysTypeESysCode On (ESysTypeCode, ESysCode);

Storage Default
{
<Data name="EnsSystemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ESysCode</Value>
</Value>
<Value name="3">
<Value>ESysDesc</Value>
</Value>
<Value name="4">
<Value>ESysEffectiveFlag</Value>
</Value>
<Value name="5">
<Value>ESysTypeCode</Value>
</Value>
</Data>
<DataLocation>^Config.ENS.EnsSystemD</DataLocation>
<DefaultData>EnsSystemDefaultData</DefaultData>
<IdLocation>^Config.ENS.EnsSystemD</IdLocation>
<IndexLocation>^Config.ENS.EnsSystemI</IndexLocation>
<StreamLocation>^Config.ENS.EnsSystemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
