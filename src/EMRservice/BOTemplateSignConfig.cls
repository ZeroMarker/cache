/// 名称：		EMRservice.BOTemplateSignConfig
/// 描述：		签名配置BO层
/// 编写者：	yejian
/// 编写时间：	2022-8-23
Class EMRservice.BOTemplateSignConfig Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TemplateSignCInfo";

/// Creator:	yejian
/// CreatDate:  2022-8-23
/// Desc:		获取签名配置信息
/// Input：		
/// Return：	EMRservice.entity.ETemplateSignCofing
/// Debug:		w ##class(EMRservice.BL.BLTemplateSignConfig).GetSignConfig(1,1)	
ClassMethod GetSignConfig(ATemplateID As %String, ATemplateVID As %String) As EMRservice.entity.ETemplateSignCofing [ WebMethod ]
{
	
	s strRes=##class(EMRservice.BL.BLTemplateSignConfig).GetSignConfig(ATemplateID,ATemplateVID)	
	q strRes
}

/// Creator:	yejian
/// CreatDate:  2022-8-23
/// Desc:		更新签名配置信息
/// Input：		
/// Return：	EMRservice.entity.ETemplateSignCofing
/// Debug:		d ##Class(%ResultSet).RunQuery("EMRservice.BL.BLTemplateSignConfig","1","1")
ClassMethod UpSignConfig(aTemplateSConfig As EMRservice.entity.ETemplateSignCofing) As %String [ WebMethod ]
{
	
	s strRes=##class(EMRservice.BL.BLTemplateSignConfig).UpSignConfig(aTemplateSConfig)	
	q strRes
}

}
