/// Desc: 		送病案室操作字典表Bl层 
/// Creator:	Donglulu
/// CreatDate:	2019-06-21
Class EMRservice.BL.BLConfirmAction Extends (%RegisteredObject, %XML.Adaptor)
{

/// Debug: d ##Class(EMRservice.BL.BLConfirmAction).Init()
ClassMethod Init() As %String
{
	//操作规则
	d ##class(EMRmeta.ConfirmAction).%BuildIndices()
	
	s ActionCode = "WithDraw"
	s ActionDesc = "退回"
	d ..InsertRule(ActionCode, ActionDesc)
	
	s ActionCode = "Revoke"
	s ActionDesc = "撤销"
	d ..InsertRule(ActionCode, ActionDesc)
	
	s ActionCode = "Confirm"
	s ActionDesc = "提交"
	d ..InsertRule(ActionCode, ActionDesc)
	
	s ActionCode = "Recall"
	s ActionDesc = "召回"
	d ..InsertRule(ActionCode, ActionDesc)
}

/// Debug: d ##Class(EMRservice.BL.BLProducts).InsertRule("","")
ClassMethod InsertRule(AActionCode As %String, AActionDesc As %String) As %String
{
	s id=$O(^DHCEMRM.ProductsI("IdxActionCode"," "_$zcvt(AActionCode,"U"),""))
	if ( id = "")
	{
		s obj = ##Class(EMRmeta.ConfirmAction).%New()
	}
	else
	{
		s obj = ##Class(EMRmeta.ConfirmAction).%OpenId(id)
	}
	
	s obj.ActionCode = AActionCode
	s obj.ActionName = AActionDesc
	d obj.%Save()
}

}
