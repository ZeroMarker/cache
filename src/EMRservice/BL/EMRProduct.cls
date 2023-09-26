/// 名称:EMRservice.BL.EMRProduct
/// 描述:项目上了公司哪些产品
/// 编写者：Donglulu
/// 编写日期: 2016-08-02
Class EMRservice.BL.EMRProduct Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       判断项目是否上了公司的某个产品
/// Creator:    Donglulu
/// CreateDate: 2016-8-9
/// Input:      ProductCode 产品代码
/// OutPut:     result 1:上了该产品 0:没上该产品   
/// Debug:      w ##Class(EMRservice.BL.EMRProduct).GetProductStatus("DHCEPRFS")      
ClassMethod GetProductStatus(ProductCode As %String) As %String
{
	s result = 0
	s productID = $o(^DHCEMRM.EMRProductI("IdxProductCode"," "_$zcvt(ProductCode,"U"),""))
	s:(productID '= "") result = 1
	q result
}

}
