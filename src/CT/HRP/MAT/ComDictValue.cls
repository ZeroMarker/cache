/// 通用字典类型值表
Class CT.HRP.MAT.ComDictValue Extends (%Persistent, User.Abstract) [ SqlTableName = ComDictValue ]
{

/// 类型代码(CT.HRP.MAT.ComDictType)
Property ComDIValType As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 2, SqlFieldName = ComDI_ValType ];

/// 类型值代码
Property ComDIValCode As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 3, SqlFieldName = ComDI_ValCode ];

/// 类型值描述
Property ComDIValDesc As %Library.String(COLLATION = "Exact", MAXLEN = 60) [ SqlColumnNumber = 4, SqlFieldName = ComDI_ValDesc ];

Index CodeType On (ComDIValCode As Exact, ComDIValType As Exact);

Index Type On ComDIValType As Exact;

Storage Default
{
<Data name="ComDictValueDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ComDIValType</Value>
</Value>
<Value name="3">
<Value>ComDIValCode</Value>
</Value>
<Value name="4">
<Value>ComDIValDesc</Value>
</Value>
</Data>
<DataLocation>^CT.HRP.MAT.ComDictValueD</DataLocation>
<DefaultData>ComDictValueDefaultData</DefaultData>
<IdLocation>^CT.HRP.MAT.ComDictValueD</IdLocation>
<IndexLocation>^CT.HRP.MAT.ComDictValueI</IndexLocation>
<StreamLocation>^CT.HRP.MAT.ComDictValueS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
