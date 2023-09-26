/// 通用字典类型表
Class CT.HRP.MAT.ComDictType Extends (%Persistent, User.Abstract) [ SqlTableName = ComDictType ]
{

/// 类型代码
Property ComDITypeCode As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = ComDI_TypeCode ];

/// 类型描述
Property ComDITypeDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = ComDI_TypeDesc ];

Index Code On ComDITypeCode As Exact;

Index Desc On ComDITypeDesc As Exact;

Storage Default
{
<Data name="ComDictTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ComDITypeCode</Value>
</Value>
<Value name="3">
<Value>ComDITypeDesc</Value>
</Value>
</Data>
<DataLocation>^CT.HRP.MAT.ComDictTypeD</DataLocation>
<DefaultData>ComDictTypeDefaultData</DefaultData>
<IdLocation>^CT.HRP.MAT.ComDictTypeD</IdLocation>
<IndexLocation>^CT.HRP.MAT.ComDictTypeI</IndexLocation>
<StreamLocation>^CT.HRP.MAT.ComDictTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
