/// 清洗方式
Class User.CSSDCleanType Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_CleanType ]
{

/// 清洗名称
Property CSSDCTCleanMode As %String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = CSSDCT_CleanMode ];

/// 清洗编码
Property CSSDCTCleanCode As %String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = CSSDCT_CleanCode ];

/// 启用标志 Y启用，N禁用
Property CSSDCTNotUseFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 4, SqlFieldName = CSSDCT_NotUseFlag ];

/// 是否手工清洗
Property CSSDCTIsManualTemp As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 5, SqlFieldName = CSSDCT_IsManualTemp ];

Index IndexCleanCode On CSSDCTCleanCode As Exact;

Index IndexCleanMode On CSSDCTCleanMode As Exact;

Storage Default
{
<Data name="CSSDCleanTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDCTCleanMode</Value>
</Value>
<Value name="3">
<Value>CSSDCTCleanCode</Value>
</Value>
<Value name="4">
<Value>CSSDCTNotUseFlag</Value>
</Value>
<Value name="5">
<Value>CSSDCTIsManualTemp</Value>
</Value>
</Data>
<DataLocation>^User.CSSDCleanTypeD</DataLocation>
<DefaultData>CSSDCleanTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDCleanTypeD</IdLocation>
<IndexLocation>^User.CSSDCleanTypeI</IndexLocation>
<StreamLocation>^User.CSSDCleanTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
