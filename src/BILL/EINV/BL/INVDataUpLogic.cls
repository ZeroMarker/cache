/// 票据信息上传逻辑处理类
Class BILL.EINV.BL.INVDataUpLogic Extends %RegisteredObject
{

ClassMethod InvDataUpBill(BusinessCode As %String, PayAdmType As %String, HISPrtRowID As %String, OrgHISPrtRowID As %String, PathCode As %String, ExpStr As %String) As %String
{
	//1.电子发票服务商基本配置信息获取
	
	//2.基本信息和就诊信息
	
	//3.业务入参验证、业务逻辑验证  根据业务类型写对应的验证方法，但是 数据业务是否已经存在的逻辑方法可共用 业务是否已经存在，以及最新的业务流水数据ID
	
	//4.发票数据对象数据获取
	
	
	//5.调用服务前给交易表保存信息
	
	//6.调用第三方接口ADP层业务
	
	//7.服务成功后,保存交易结果
}

/// 任务方法编写

}
