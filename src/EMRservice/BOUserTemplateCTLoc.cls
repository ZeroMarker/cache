/// 名称：		EMRservice.BOUserTemplateCTLoc
/// 描述：		模板科室BO层
/// 编写者：	yejian
/// 编写时间：	2017-12-5
Class EMRservice.BOUserTemplateCTLoc Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "UserTemplateCTLocInfo";

/// Creator: yejian
/// CreatDate: 2017-12-5
/// Description：获取指定科室项下的所有科室ID
/// Input: aItemCode,
/// Return: locid|name^locid|name^locid|name
ClassMethod GetItemLoc(aItemCode As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateCTLoc).GetItemLoc(aItemCode)
}

/// Creator: yejian
/// CreatDate: 2017-12-5
/// Description：保存指定科室项下所适用的科室
/// Input: docID--docID, sltLocs--所有选中的科室ID串(格式为 ID1|name^ID2|name^ID3|name), unSltLocs--所有未选中的科室ID串(格式为 ID1|name^ID2|name^ID3|name)
/// Return: 1
ClassMethod ModifyLoc(aItemCode As %String, sltLocs As %String, unSltLocs As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateCTLoc).ModifyLoc(aItemCode,sltLocs,unSltLocs)
}

}
