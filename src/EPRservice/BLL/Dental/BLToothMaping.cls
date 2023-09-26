Class EPRservice.BLL.Dental.BLToothMaping Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	指定模板上是否有单元映射为牙位数据
/// Input：	ATemplateID 界面模板ID
/// Return:	1 有，0 无
/// Debug：	w ##Class(EPRservice.BLL.Dental.BLToothMaping).HasMetaItemMapped("37")
ClassMethod HasMetaItemMapped(ATemplateID As %String) As %Boolean
{
	s metaItemCode = $O(^DHCEPRM.Dental.ToothMapingI("IdxMetaItemCode"," "_ATemplateID," "))
	q:(metaItemCode = "") 0
	q 1
}

}
