/// 分组子归集明细项目
/// TABLE:DHCWL_CodeCfg.DHCWLCodeCfgSubGroupItem
Class DHCWL.CodeCfg.SubGroupItem Extends (%Persistent, DHCWL.ABSCodeCFG) [ ClassType = persistent, Inheritance = right, SqlTableName = DHCWLCodeCfgSubGroupItem ]
{

/// 关联分类子组
Property SGrpIMSGrpDr As DHCWL.CodeCfg.SubGroup [ SqlColumnNumber = 2, SqlFieldName = SGrpIM_SGrp_Dr ];

/// 明细项目ID
Property SGrpIMItemDR As %String [ SqlColumnNumber = 3, SqlFieldName = SGrpIM_Item_DR ];

/// 关联分组大类ID
Property SGrpIMGrpDr As DHCWL.CodeCfg.Group [ SqlColumnNumber = 4, SqlFieldName = SGrpIM_Grp_Dr ];

/// 值类型
Property SGrpIMValueFlag As %String [ SqlColumnNumber = 5, SqlFieldName = SGrpIM_ValueFlag ];

/// 明细项目CODE
Property SGrpIMItemCode As %String [ SqlColumnNumber = 6, SqlFieldName = SGrpIM_Item_Code ];

/// 排序
Property SGrpIMSort As %Integer [ SqlColumnNumber = 7, SqlFieldName = SGrpIM_Sort ];

Index SGrpIM On (SGrpIMSGrpDr, SGrpIMItemDR);

Index SGrp On (SGrpIMItemDR, SGrpIMSGrpDr, SGrpIMGrpDr);

Index Grp On (SGrpIMGrpDr, SGrpIMItemDR);

Index SGrpSort On (SGrpIMSGrpDr, SGrpIMSort, SGrpIMItemDR);

///      DHCWL_CodeCfg.DHCWLCodeCfgSubGroupItem   d ##class(DHCWL.CodeCfg.SubGroupItem).%BuildIndices()

Storage Default
{
<Data name="SubGroupItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SGrpIMItemDR</Value>
</Value>
<Value name="3">
<Value>SGrpIMSGrpDr</Value>
</Value>
<Value name="4">
<Value>SGrpIMGrpDr</Value>
</Value>
<Value name="5">
<Value>SGrpIMValueFlag</Value>
</Value>
<Value name="6">
<Value>SGrpIMItemCode</Value>
</Value>
<Value name="7">
<Value>SGrpIMSort</Value>
</Value>
</Data>
<DataLocation>^DHCWL.CodeCfg.SubGroupItemD</DataLocation>
<DefaultData>SubGroupItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.CodeCfg.SubGroupItemD</IdLocation>
<IndexLocation>^DHCWL.CodeCfg.SubGroupItemI</IndexLocation>
<StreamLocation>^DHCWL.CodeCfg.SubGroupItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
