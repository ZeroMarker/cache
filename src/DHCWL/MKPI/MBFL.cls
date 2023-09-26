/// DHCWL_MKPI.DHCWLMBFL 码表分类，用于区别时间、年龄等
Class DHCWL.MKPI.MBFL Extends %Persistent [ SqlTableName = DHCWLMBFL ]
{

/// 代码
Property MBFLCode As %String [ SqlColumnNumber = 2, SqlFieldName = MBFL_Code ];

/// 名称
Property MBFLName As %String [ SqlColumnNumber = 3, SqlFieldName = MBFL_Name ];

/// 描述
Property MBFLDesc As %String [ SqlColumnNumber = 4, SqlFieldName = MBFL_Desc ];

/// 用户
Property MBFLUser As %String [ SqlColumnNumber = 5, SqlFieldName = MBFL_User ];

/// 创建日期
Property MBFLUpdateDate As %Date [ SqlColumnNumber = 6, SqlFieldName = MBFL_UpdateDate ];

/// 备注
Property MBFLRemark As %String [ SqlColumnNumber = 7, SqlFieldName = MBFL_Remark ];

Storage Default
{
<Data name="MBFLDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MBFLCode</Value>
</Value>
<Value name="3">
<Value>MBFLDesc</Value>
</Value>
<Value name="4">
<Value>MBFLName</Value>
</Value>
<Value name="5">
<Value>MBFLRemark</Value>
</Value>
<Value name="6">
<Value>MBFLUpdateDate</Value>
</Value>
<Value name="7">
<Value>MBFLUser</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.MBFLD</DataLocation>
<DefaultData>MBFLDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MKPI.MBFLD</IdLocation>
<IndexLocation>^DHCWL.MKPI.MBFLI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.MBFLS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
