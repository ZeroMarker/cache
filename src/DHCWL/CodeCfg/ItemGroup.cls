/// 大组维护
Class DHCWL.CodeCfg.ItemGroup Extends (%Persistent, DHCWL.ABSCodeCFG) [ ClassType = persistent, Inheritance = right, SqlTableName = DHCWLCodeCfgItemGroup ]
{

/// 编码
Property ItemGrpCode As %String [ SqlColumnNumber = 2, SqlFieldName = ItemGrp_Code ];

/// 描述
Property ItemGrpDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ItemGrp_Desc ];

/// 关联配置类型表
Property ItemGrpTypeDr As DHCWL.CodeCfg.Type [ SqlColumnNumber = 4, SqlFieldName = ItemGrp_Type_Dr ];

/// 创建日期
Property ItemGrpCreateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = ItemGrp_CreateDate ];

/// 创建时间
Property ItemGrpCreateTime As %Time [ SqlColumnNumber = 6, SqlFieldName = ItemGrp_CreateTime ];

/// 创建人
Property ItemGrpCreateUse As %String [ SqlColumnNumber = 7, SqlFieldName = ItemGrp_CreateUse ];

/// 关联纬度
Property ItemGrpDimDr As DHCWL.MKPI.MKPIDimType [ SqlColumnNumber = 8, SqlFieldName = ItemGrp_Dim_Dr ];

Index TypeDr On ItemGrpTypeDr;

Index Code On ItemGrpCode;

Index DimDr On ItemGrpDimDr;

///     DHCWL_CodeCfg.DHCWLCodeCfgItemGroup    d ##class(DHCWL.CodeCfg.ItemGroup).%BuildIndices()

Storage Default
{
<Data name="ItemGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemGrpCode</Value>
</Value>
<Value name="3">
<Value>ItemGrpDesc</Value>
</Value>
<Value name="4">
<Value>ItemGrpTypeDr</Value>
</Value>
<Value name="5">
<Value>ItemGrpCreateDate</Value>
</Value>
<Value name="6">
<Value>ItemGrpCreateTime</Value>
</Value>
<Value name="7">
<Value>ItemGrpCreateUse</Value>
</Value>
<Value name="8">
<Value>ItemGrpDimDr</Value>
</Value>
</Data>
<DataLocation>^DHCWL.CodeCfg.ItemGroupD</DataLocation>
<DefaultData>ItemGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.CodeCfg.ItemGroupD</IdLocation>
<IndexLocation>^DHCWL.CodeCfg.ItemGroupI</IndexLocation>
<StreamLocation>^DHCWL.CodeCfg.ItemGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
