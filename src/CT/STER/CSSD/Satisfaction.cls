Class CT.STER.CSSD.Satisfaction Extends (%Persistent, User.Abstract) [ SqlTableName = Satisfaction ]
{

Property SCode As %String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = S_Code ];

Property SDesc As %String(COLLATION = "Exact", TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = S_Desc ];

/// 调查类型 I：Input 输入框  R:radio勾选框
Property SType As %String(COLLATION = "Exact") [ SqlColumnNumber = 4, SqlFieldName = S_Type ];

/// 是否可用
Property SUseFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 5, SqlFieldName = S_UseFlag ];

Index CSSDSCodeIndex On SCode As Exact;

Index CSSDSDescIndex On SDesc As Exact;

Storage Default
{
<Data name="SatisfactionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SCode</Value>
</Value>
<Value name="3">
<Value>SDesc</Value>
</Value>
<Value name="4">
<Value>SType</Value>
</Value>
<Value name="5">
<Value>SUseFlag</Value>
</Value>
</Data>
<DataLocation>^CT.STER.CSSD.SatisfactionD</DataLocation>
<DefaultData>SatisfactionDefaultData</DefaultData>
<IdLocation>^CT.STER.CSSD.SatisfactionD</IdLocation>
<IndexLocation>^CT.STER.CSSD.SatisfactionI</IndexLocation>
<StreamLocation>^CT.STER.CSSD.SatisfactionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
