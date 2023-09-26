Class web.DHCEQ.Interface.DHCEQForST Extends %RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 获取耗材项信息
ClassMethod GetConsumableItemInfo(ExType, ExID)
{
	n ConsumableItemInfo
	s ConsumableItemInfo=""
	if ExType="DHC-ST"
	{
		s ConsumableItemInfo=##Class(web.DHCEQ.Interface.Inner.DHCEQSTFrom).GetConsumableItemInfo(ExID)
	}
	q ConsumableItemInfo
}

}
