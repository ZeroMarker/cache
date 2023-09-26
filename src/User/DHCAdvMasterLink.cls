Class User.DHCAdvMasterLink Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_AdvMasterLink ]
{

/// 不良事件主表ID 
Property MLMasterDr As User.DHCAdvMaster;

/// 关联项类型    医嘱： "Order"
Property MLType As %String;

/// 关联项指向  医嘱ID （同一个报告可能存在多条关联医嘱记录）
Property MLLinkDr As %String;

Storage Default
{
<Data name="DHCAdvMasterLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MLMasterDr</Value>
</Value>
<Value name="3">
<Value>MLType</Value>
</Value>
<Value name="4">
<Value>MLLinkDr</Value>
</Value>
</Data>
<DataLocation>^User.DHCAdvMasterLinkD</DataLocation>
<DefaultData>DHCAdvMasterLinkDefaultData</DefaultData>
<IdLocation>^User.DHCAdvMasterLinkD</IdLocation>
<IndexLocation>^User.DHCAdvMasterLinkI</IndexLocation>
<StreamLocation>^User.DHCAdvMasterLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

/// 不良事件主表id关联表类型与指向
Index IndexMatTyeLink On (MLMasterDr, MLType);

/// 关联类型与指向
Index IndexTyeLink On (MLType, MLLinkDr);

}
