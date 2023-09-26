Class BILL.EINV.BL.COM.Config Extends %RegisteredObject
{

/// Creator：	wangjian
/// CreatDate：	2019-08-23
/// Desc:		获取系统参数表配置
/// Table:		 BILL_Invoice_PO.InvUpConfig
ClassMethod GetUploadConfig(ConfigObj As BILL.EINV.PO.InvUpConfig) As %ObjectHandle
{
	Set IUCRowID=$o(^BILL.Invoice.PO.InvUpConfigD(0))
	Set ConfigObj=##class(BILL.EINV.PO.InvUpConfig).%OpenId(IUCRowID)
	
	q ConfigObj
}

/// Creator：	wangjian
/// CreatDate：	2019-08-23
/// Desc:		根据接口代码获取系统接口配置
/// Table:		 BILL_Invoice_PO.InvLogicPath
/// w ##class(BILL.EINV.BL.COM.Config).GetUploadPath("02","I")
ClassMethod GetUploadPath(PathCode As %String, PathType As %String = "I") As %String
{
	
	Set PathInfo="^"
	Quit:PathCode="" PathInfo
	
	Set id=""
	For  Set id=$o(^BILL.EINV.PO.InvLogicPathI("IDataKey",PathType,PathCode,id)) Quit:id=""  Do
	.Set obj=##class(BILL.EINV.PO.InvLogicPath).%OpenId(id)
	.Set ActiveFlag=obj.IUPActive
	.Quit:ActiveFlag'="Y"
	.Set ClassName=obj.IUPClassName
	.Set MethodName=obj.IUPMethodName
	.Set PathInfo=ClassName_"^"_MethodName
	Quit PathInfo
}

}
