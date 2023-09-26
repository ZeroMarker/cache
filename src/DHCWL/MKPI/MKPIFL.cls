/// DHCWL_MKPI.DHCWLMKPIFL
Class DHCWL.MKPI.MKPIFL Extends %Persistent [ ClassType = persistent, SqlTableName = DHCWLMKPIFL ]
{

/// 代码
Property MKPIFLCode As %String [ SqlColumnNumber = 2, SqlFieldName = MKPIFL_Code ];

/// 名称
Property MKPIFLName As %String [ SqlColumnNumber = 3, SqlFieldName = MKPIFL_Name ];

/// 描述
Property MKPIFLDesc As %String [ SqlColumnNumber = 4, SqlFieldName = MKPIFL_Desc ];

/// 用户
Property MKPIFLUser As %String [ SqlColumnNumber = 5, SqlFieldName = MKPIFL_User ];

/// 创建日期
Property MKPIFLUpdateDate As %Date [ SqlColumnNumber = 6, SqlFieldName = MKPIFL_UpdateDate ];

/// 备注
Property MKPIFLRemark As %String [ SqlColumnNumber = 7, SqlFieldName = MKPIFL_Remark ];

Index FLCode On MKPIFLCode As AlphaUp;

Index FLName On MKPIFLName As AlphaUp;

Storage Default
{
<Data name="MKPIFLDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MKPIFLCode</Value>
</Value>
<Value name="3">
<Value>MKPIFLDesc</Value>
</Value>
<Value name="4">
<Value>MKPIFLKPIDr</Value>
</Value>
<Value name="5">
<Value>MKPIFLName</Value>
</Value>
<Value name="6">
<Value>MKPIFLRemark</Value>
</Value>
<Value name="7">
<Value>MKPIFLUpdateDate</Value>
</Value>
<Value name="8">
<Value>MKPIFLUser</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.MKPIFLD</DataLocation>
<DefaultData>MKPIFLDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MKPI.MKPIFLD</IdLocation>
<IndexLocation>^DHCWL.MKPI.MKPIFLI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.MKPIFLS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
