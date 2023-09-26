///   DHCWL_CodeCfg.DHCWLCodeCfgContrast   d ##class(DHCWL.CodeCfg.Contrast).%BuildIndices()
Class DHCWL.CodeCfg.Contrast Extends %Persistent [ ClassType = persistent, SqlTableName = DHCWLCodeCfgContrast ]
{

/// 关联接口表
Property ContrInterfaceDr As DHCWL.CodeCfg.Interface [ SqlColumnNumber = 2, SqlFieldName = Contr_Interface_Dr ];

/// 关联类型表
Property ContrTypeDr As DHCWL.CodeCfg.Type [ SqlColumnNumber = 3, SqlFieldName = Contr_Type_Dr ];

/// HIS项目ID
Property ContrHisItemDr As %String [ SqlColumnNumber = 4, SqlFieldName = Contr_HisItem_Dr ];

/// 接口对照代码
Property ContrInterItemDr As %String [ SqlColumnNumber = 5, SqlFieldName = Contr_InterItem_Dr ];

Index InterfaceDr On ContrInterfaceDr;

Index TypeItem On (ContrInterfaceDr, ContrTypeDr, ContrInterItemDr, ContrHisItemDr);

Storage Default
{
<Data name="ContrastDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ContrHisItemDr</Value>
</Value>
<Value name="3">
<Value>ContrInterItemDr</Value>
</Value>
<Value name="4">
<Value>ContrInterfaceDr</Value>
</Value>
<Value name="5">
<Value>ContrTypeDr</Value>
</Value>
</Data>
<DataLocation>^DHCWL.CodeCfg.ContrastD</DataLocation>
<DefaultData>ContrastDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.CodeCfg.ContrastD</IdLocation>
<IndexLocation>^DHCWL.CodeCfg.ContrastI</IndexLocation>
<StreamLocation>^DHCWL.CodeCfg.ContrastS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
