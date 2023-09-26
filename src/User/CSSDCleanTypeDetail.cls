/// 清洗单手工清洗信息
Class User.CSSDCleanTypeDetail Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_CleanTypeDetail ]
{

Property CSSDCTDCleanDR As User.CSSDClean [ Required, SqlColumnNumber = 2, SqlFieldName = CSSDCTD_Clean_DR ];

Property CSSDCTDType As %String(COLLATION = "Exact") [ Required, SqlColumnNumber = 3, SqlFieldName = CSSDCTD_Type ];

Property CSSDCTDCode As %String(COLLATION = "Exact") [ Required, SqlColumnNumber = 4, SqlFieldName = CSSDCTD_Code ];

Property CSSDCTDValue As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = CSSDCTD_Value ];

Index IndexClean On (CSSDCTDCleanDR As Exact, CSSDCTDCode As Exact);

Storage Default
{
<Data name="CSSDCleanTypeDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDCTDCleanDR</Value>
</Value>
<Value name="3">
<Value>CSSDCTDType</Value>
</Value>
<Value name="4">
<Value>CSSDCTDCode</Value>
</Value>
<Value name="5">
<Value>CSSDCTDValue</Value>
</Value>
</Data>
<DataLocation>^User.CSSDCleanTypeDetailD</DataLocation>
<DefaultData>CSSDCleanTypeDetailDefaultData</DefaultData>
<ExtentSize>1000</ExtentSize>
<IdLocation>^User.CSSDCleanTypeDetailD</IdLocation>
<IndexLocation>^User.CSSDCleanTypeDetailI</IndexLocation>
<StreamLocation>^User.CSSDCleanTypeDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
