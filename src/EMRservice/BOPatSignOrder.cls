/// 名称：		EMRservice.BOPatSignOrder
/// 描述：		患者签名排序BO层
/// 编写者：	yejian
/// 编写时间：	2021-11-4
Class EMRservice.BOPatSignOrder Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService. 
Parameter SERVICENAME = "PatSignOrderInfo";

/// Creator: yejian
/// CreatDate: 2021-11-4
/// Description：根据模板ID获取原始签名数据
/// Input: 	aTemplateID 模板ID,
/// 		aVersionNum 版本
/// Return: 签名数据 [{"displayName":"患者签名","path":"S015_V008_L0013"},{"displayName":"委托人签名","path":"S015_V008_L0014"}]}
/// Debug:	w ##Class(EMRservice.BOPatSignOrder).GetPatSignData("111","2")
ClassMethod GetPatSignData(aTemplateID As %String, aVersionNum As %String) As %String [ WebMethod ]
{
	q ##class(EMRservice.XmlParser.XML2JSON).GetTplSignInfoJson(aTemplateID,aVersionNum)
}

/// Creator: yejian
/// CreatDate: 2021-11-4
/// Description：获取签名排序数据
/// Input: 	aTemplateID 模板ID,
/// 		aVersionNum 版本
/// Return: EMRservice.entity.EPatSignOrder 签名排序对象
/// Debug:	w ##Class(EMRservice.BOPatSignOrder).GetPatSignOrderData("111","2")
ClassMethod GetPatSignOrderData(aTemplateID As %String, aVersionNum As %String) As EMRservice.entity.EPatSignOrder [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLPatSignOrder).GetPatSignOrderData(aTemplateID,aVersionNum)
}

/// Creator: yejian
/// CreatDate: 2021-11-4
/// Description：更新签名排序数据
/// Input: 	ePatSignOrder 签名排序对象
/// Return: 1 成功，0 失败
/// Debug:	w ##Class(EMRservice.BOPatSignOrder).UpPatSignOrderData()
ClassMethod UpPatSignOrderData(ePatSignOrder As EMRservice.entity.EPatSignOrder) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLPatSignOrder).UpPatSignOrderData(ePatSignOrder)
}

/// Creator: yejian
/// CreatDate: 2021-11-4
/// Description：新增版本时，添加患者签数据
/// Input: 	aTemplateID 模板ID,
/// 		aOVersion 上一个版本
/// 		aNVersion 新增的版本
/// Return: 1 成功，0 失败
/// Debug:	w ##Class(EMRservice.BOPatSignOrder).AddSignOrderByVersion(111,1,2)
ClassMethod AddSignOrderByVersion(aTemplateID As %String, aOVersion As %String, aNVersion As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLPatSignOrder).AddSignOrderByVersion(aTemplateID,aOVersion,aNVersion)
}

/// Creator: yejian
/// CreatDate: 2022-3-7
/// Description：获取签名类型
/// Input: 	
/// Return:  DataSet
/// Debug:	w ##Class(EMRservice.BOPatSignOrder).SelectSignType()
ClassMethod SelectSignType() As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLPatSignOrder:SelectSignType")
	d result.SetArgs()
	q result
}

/// Creator: yejian
/// CreatDate: 2022-3-7
/// Description：获取签名者类型
/// Input: 	
/// Return:  DataSet
/// Debug:	w ##Class(EMRservice.BOPatSignOrder).SelectSignerType()
ClassMethod SelectSignerType() As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLPatSignOrder:SelectSignerType")
	d result.SetArgs()
	q result
}

}
