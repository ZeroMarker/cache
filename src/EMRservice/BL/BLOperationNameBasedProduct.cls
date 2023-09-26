/// 名称:EMRservice.BL.BLOperationNameBasedProduct
/// 描述:各产品模块操作病历名称--BL层
/// 编写者：liuyunfei
/// 编写日期: 2020-05-21
Class EMRservice.BL.BLOperationNameBasedProduct Extends %RegisteredObject
{

/// desc：初始化EMRmeta.OperationNameBasedProduct表数据
/// debug： d ##Class(EMRservice.BL.BLOperationNameBasedProduct).Init()
ClassMethod Init()
{
	d ##class(EMRmeta.OperationNameBasedProduct).%BuildIndices()
		
	s Action = "PRINT"
	s ProductSource = "EMR"
	s OperationName = "医生打印"
	d ..insertRecord(Action, ProductSource, OperationName)
	
	s Action = "PRINT"
	s ProductSource = "DHCEPRFS"
	s OperationName = "归档打印"
	d ..insertRecord(Action, ProductSource, OperationName)
	
	s Action = "PRINT"
	s ProductSource = "CENTRALIZEDPRINT"
	s OperationName = "集中打印"
	d ..insertRecord(Action, ProductSource, OperationName)
}

/// desc：插入数据
ClassMethod insertRecord(Action, ProductSource, OperationName)
{
	s id = $O(^DHCEMRM.OperationNameI("IdxProductSource"," "_$zcvt(ProductSource,"U")," "_$zcvt(Action,"U"),""))
	if (id = "")
	{
		s obj = ##Class(EMRmeta.OperationNameBasedProduct).%New()
	}
	else
	{
		s obj = ##Class(EMRmeta.OperationNameBasedProduct).%OpenId(id)
	}
	s obj.Action = Action
	s obj.ProductSource = ProductSource
	s obj.OperationName = OperationName
	d obj.%Save()
}

/// Desc:       根据操作类型（打印）和产品来源取病历状态名称
/// Creator:    liuyunfei
/// DateTime:   2020-05-21
/// Input:      Action:操作类型
///             ProductSource:产品来源名称
/// OutPut:     OperationName：操作名称
/// w ##Class(EMRservice.BL.BLOperationNameBasedProduct).GetOperationName("PRINT","EMR")
ClassMethod GetOperationName(Action As %String, ProductSource As %String) As %String
{
	s OperationName = ""
	s:(ProductSource = "") ProductSource = "EMR"
	s rowId = $o(^DHCEMRM.OperationNameI("IdxProductSource"," "_$zcvt(ProductSource,"U")," "_$zcvt(Action,"U"),""),1)
	q:(rowId = "") OperationName
	s obj = ##class(EMRmeta.OperationNameBasedProduct).%OpenId(rowId)
	s OperationName = obj.OperationName
	q OperationName
}

}
