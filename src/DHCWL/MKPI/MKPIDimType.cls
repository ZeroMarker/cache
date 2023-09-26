/// 表名：DHCWL_MKPI.DHCWLMKPIDimType d ##class(DHCWL.MKPI.MKPIDimType).%BuildIndices()
/// 指标数据维描述表
Class DHCWL.MKPI.MKPIDimType Extends %Persistent [ ClassType = persistent, SqlTableName = DHCWLMKPIDimType ]
{

/// 代码
Property KDTCode As %String [ SqlColumnNumber = 2, SqlFieldName = KDT_Code ];

/// 名称
Property KDTName As %String [ SqlColumnNumber = 3, SqlFieldName = KDT_Name ];

/// 描述
Property KDTDesc As %String [ SqlColumnNumber = 4, SqlFieldName = KDT_Desc ];

/// 用户
Property KDTUser As %String [ SqlColumnNumber = 5, SqlFieldName = KDT_User ];

/// 创建日期
Property KDTUpdateDate As %Date [ SqlColumnNumber = 6, SqlFieldName = KDT_UpdateDate ];

/// 执行代码  3.0不再使用该属性
Property KDTEXCode As %String [ SqlColumnNumber = 7, SqlFieldName = KDT_EXCode ];

/// 备注
Property KDTRemark As %String [ SqlColumnNumber = 8, SqlFieldName = KDT_Remark ];

/// 执行代码  4.2后使用该属性
Property KDTExeCode As %String [ SqlColumnNumber = 9, SqlFieldName = KDT_ExeCode ];

Index DimTypeI On KDTCode As AlphaUp;

Storage Default
{
<Data name="MKPIDimTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KDTCode</Value>
</Value>
<Value name="3">
<Value>KDTDesc</Value>
</Value>
<Value name="4">
<Value>KDTEXCode</Value>
</Value>
<Value name="5">
<Value>KDTName</Value>
</Value>
<Value name="6">
<Value>KDTRemark</Value>
</Value>
<Value name="7">
<Value>KDTUpdateDate</Value>
</Value>
<Value name="8">
<Value>KDTUser</Value>
</Value>
<Value name="9">
<Value>KDTExeCode</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.MKPIDimTypeD</DataLocation>
<DefaultData>MKPIDimTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MKPI.MKPIDimTypeD</IdLocation>
<IndexLocation>^DHCWL.MKPI.MKPIDimTypeI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.MKPIDimTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
