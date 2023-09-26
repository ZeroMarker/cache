/// 术语扩展属性父表
Class User.TKBTremBaseExtend Extends %Persistent [ SqlTableName = TKB_TremBaseExtend ]
{

Relationship ChildCat As User.TKBTremBaseExtendCat [ Cardinality = children, Inverse = ParRef ];

Property TKBTRBECode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = TKBTRBE_Code ];

Property TKBTRBEDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = TKBTRBE_Desc ];

Property TKBTRBEType As %String(DISPLAYLIST = ",列表,树形,文本,数据来源,引用属性", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",L,T,TX,S,C") [ SqlColumnNumber = 4, SqlFieldName = TKBTRBE_Type ];

Property TKBTRBEBaseDr As User.TKBTremBase [ SqlColumnNumber = 5, SqlFieldName = TKBTRBE_Base_Dr ];

Property TKBTRBESourceDr As User.TKBTremBase [ SqlColumnNumber = 6, SqlFieldName = TKBTRBE_Source_Dr ];

Property TKBTRBEName As %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = TKBTRBE_Name ];

Property TKBTRBEFlag As %String(DISPLAYLIST = ",诊断展示名", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",S") [ SqlColumnNumber = 8, SqlFieldName = TKBTRBE_Flag ];

Index TremBaseIdx On TKBTRBEBaseDr As Exact;

Index CodeIndex On (TKBTRBEBaseDr, TKBTRBECode) [ Unique ];

Index DescIndex On (TKBTRBEBaseDr, TKBTRBEDesc) [ Unique ];

Index FlagIndex On (TKBTRBEBaseDr, TKBTRBEFlag) [ Unique ];

Storage Default
{
<Data name="TKBTremBaseExtendDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TKBTRBECode</Value>
</Value>
<Value name="3">
<Value>TKBTRBEDesc</Value>
</Value>
<Value name="4">
<Value>TKBTRBEType</Value>
</Value>
<Value name="5">
<Value>TKBTRBEBaseDr</Value>
</Value>
<Value name="6">
<Value>TKBTRBESourceDr</Value>
</Value>
<Value name="7">
<Value>TKBTRBEName</Value>
</Value>
<Value name="8">
<Value>TKBTRBEFlag</Value>
</Value>
</Data>
<DataLocation>^User.TKBTremBaseExtendD</DataLocation>
<DefaultData>TKBTremBaseExtendDefaultData</DefaultData>
<IdLocation>^User.TKBTremBaseExtendD</IdLocation>
<IndexLocation>^User.TKBTremBaseExtendI</IndexLocation>
<StreamLocation>^User.TKBTremBaseExtendS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
