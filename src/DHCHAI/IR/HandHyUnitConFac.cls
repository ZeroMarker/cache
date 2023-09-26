/// 名称: DHCHAI.IR.HandHyUnitConFac
/// 描述: 手卫生用品单位换算关系
/// 编写者：zhoubo
/// 编写日期: 2017-12-20
Class DHCHAI.IR.HandHyUnitConFac Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// From Unit ("HandHyUnit")
Property HHUFromUnitDr As DHCHAI.BT.Dictionary;

/// To Unit ("HandHyUnit")
Property HHUToUnitDr As DHCHAI.BT.Dictionary;

/// 转换系数
Property HHUConFactor As %Float;

/// 是否有效
Property HHUActive As %Boolean;

/// 唯一性
Index IndexFromToUnit On (HHUFromUnitDr, HHUToUnitDr) [ Unique ];

/// From Unit 
Index IndexFromUnit On HHUFromUnitDr As Exact;

Storage Default
{
<Data name="HandHyUnitConFacDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HHUFromUnitDr</Value>
</Value>
<Value name="3">
<Value>HHUToUnitDr</Value>
</Value>
<Value name="4">
<Value>HHUConFactor</Value>
</Value>
<Value name="5">
<Value>HHUActive</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.IR.HandHyUnitConFacD</DataLocation>
<DefaultData>HandHyUnitConFacDefaultData</DefaultData>
<IdLocation>^DHCHAI.IR.HandHyUnitConFacD</IdLocation>
<IndexLocation>^DHCHAI.IR.HandHyUnitConFacI</IndexLocation>
<StreamLocation>^DHCHAI.IR.HandHyUnitConFacS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
