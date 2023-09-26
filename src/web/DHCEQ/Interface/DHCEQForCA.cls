Class web.DHCEQ.Interface.DHCEQForCA Extends %RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// add by zy 2014-09-15  ZY0117
/// DHCCATOEQ
/// Description:成本核算组 
/// 
/// Description:导出成本数据记录 
/// Creator:cgg
/// CreateDate:090903 
/// 入参:   MonthStr    ;"2014-09"
/// 	   LocID       ;CT_LocID
/// 输出数据存在临时golbale中,golable节点如下：
///   ^DHCEQTemp("Gather","CA",MonthStr,LocID,CatID)=CatDesc^Fee
/// 例子:^DHCEQTemp("Gather","CA","2014-09",80,1)=医疗耗材^1000.00
/// d ##Class(web.DHCEQTest).GetOutCAData("2014-07","151")
ClassMethod GetOutCAData(MonthStr, LocID, CAitemDr)
{
	//q ##Class(web.DHCEQ.Interface.Inner.DHCEQCAFrom).GetOutCAData($e($ZD($H,3),1,7),UseLocDR,ExResourceType)
	q ""
}

Storage Default
{
<Data name="DHCEQForCADefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQ.InterC414.DHCEQForCAD</DataLocation>
<DefaultData>DHCEQForCADefaultData</DefaultData>
<IdLocation>^web.DHCEQ.InterC414.DHCEQForCAD</IdLocation>
<IndexLocation>^web.DHCEQ.InterC414.DHCEQForCAI</IndexLocation>
<StreamLocation>^web.DHCEQ.InterC414.DHCEQForCAS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
