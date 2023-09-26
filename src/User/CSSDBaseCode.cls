Class User.CSSDBaseCode Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_BaseCode ]
{

Property CSSDDCCode As %String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = CSSDDC_Code ];

/// 1001-清洗程序, 2001-灭菌程序, 3001-作业流程名称
Property CSSDDCCodeType As %String(COLLATION = "Exact") [ SqlColumnNumber = 3, SqlFieldName = CSSDDC_CodeType ];

Property CSSDDCName As %String(COLLATION = "Exact") [ SqlColumnNumber = 4, SqlFieldName = CSSDDC_Name ];

Property CSSDDCBegLabel As %String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = CSSDDC_BegLabel ];

Property CSSDDCType As User.CSSDBaseDataType [ SqlColumnNumber = 6, SqlFieldName = CSSDDC_BaseTypeDr ];

Property CSSDDCNotUseFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 7, SqlFieldName = CSSDDC_NotUseFlag ];

/// 灭菌方式
Property CSSDDCSterWay As User.CSSDSterType [ SqlColumnNumber = 8, SqlFieldName = CSSDDC_SterWay ];

/// 验收间隔时间(分钟)
Property CSSDDCInterval As %Float [ SqlColumnNumber = 9, SqlFieldName = CSSDDC_Interval ];

Index IndexCSSDDCCodeType On (CSSDDCCode As Exact, CSSDDCCodeType As Exact);

Index IndexCSSDDCNameType On (CSSDDCName As Exact, CSSDDCCodeType As Exact);

Index IndexCSSDDCBegLabelType On (CSSDDCBegLabel As Exact, CSSDDCCodeType As Exact);

Storage Default
{
<Data name="CSSDBaseCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDDCCode</Value>
</Value>
<Value name="3">
<Value>CSSDDCCodeType</Value>
</Value>
<Value name="4">
<Value>CSSDDCName</Value>
</Value>
<Value name="5">
<Value>CSSDDCBegLabel</Value>
</Value>
<Value name="6">
<Value>CSSDDCType</Value>
</Value>
<Value name="7">
<Value>CSSDDCNotUseFlag</Value>
</Value>
<Value name="8">
<Value>CSSDDCSterWay</Value>
</Value>
<Value name="9">
<Value>CSSDDCInterval</Value>
</Value>
</Data>
<DataLocation>^User.CSSDBaseCodeD</DataLocation>
<DefaultData>CSSDBaseCodeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDBaseCodeD</IdLocation>
<IndexLocation>^User.CSSDBaseCodeI</IndexLocation>
<StreamLocation>^User.CSSDBaseCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
