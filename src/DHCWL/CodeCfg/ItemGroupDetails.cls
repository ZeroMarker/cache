/// 大组项目明细
Class DHCWL.CodeCfg.ItemGroupDetails Extends (%Persistent, DHCWL.ABSCodeCFG) [ ClassType = persistent, Inheritance = right, SqlTableName = DHCWLCodeCfgItemGroupDetails ]
{

/// 关联大组
Property ItmGrpDetGrpDr As DHCWL.CodeCfg.ItemGroup [ SqlColumnNumber = 2, SqlFieldName = ItmGrpDet_Grp_Dr ];

/// 明细项目ID
Property ItmGrpDetItemDR As %String [ SqlColumnNumber = 3, SqlFieldName = ItmGrpDet_Item_DR ];

/// 值类型
Property ItmGrpDetValueFlag As %String [ SqlColumnNumber = 4, SqlFieldName = ItmGrpDet_ValueFlag ];

/// 排序
Property ItmGrpDetSort As %Integer [ SqlColumnNumber = 5, SqlFieldName = ItmGrpDet_Sort ];

Index GrpIM On (ItmGrpDetGrpDr, ItmGrpDetItemDR);

Index GrpIMSort On (ItmGrpDetGrpDr, ItmGrpDetSort, ItmGrpDetItemDR);

///   DHCWL_CodeCfg.DHCWLCodeCfgItemGroupDetails    d ##class(DHCWL.CodeCfg.ItemGroupDetails).%BuildIndices()

Storage Default
{
<Data name="ItemGroupDetailsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItmGrpDetGrpDr</Value>
</Value>
<Value name="3">
<Value>ItmGrpDetItemDR</Value>
</Value>
<Value name="4">
<Value>ItmGrpDetValueFlag</Value>
</Value>
<Value name="5">
<Value>ItmGrpDetSort</Value>
</Value>
</Data>
<DataLocation>^DHCWL.CodeCfg.ItemGroupDetailsD</DataLocation>
<DefaultData>ItemGroupDetailsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.CodeCfg.ItemGroupDetailsD</IdLocation>
<IndexLocation>^DHCWL.CodeCfg.ItemGroupDetailsI</IndexLocation>
<StreamLocation>^DHCWL.CodeCfg.ItemGroupDetailsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
