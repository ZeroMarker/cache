/// 名称：		EMRservice.BL.BLTemplateSignConfigConfig
/// 描述：		签名配置BL层
/// 编写者：	yejian
/// 编写时间：	2018-12-5
Class EMRservice.BL.BLTemplateSignConfig Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator:	yejian
/// CreatDate:  2022-8-23
/// Desc:		获取签名配置信息
/// Input：		
/// Return：	1 有签名单元，0 无签名单元
/// Debug:		w ##class(EMRservice.BL.BLTemplateSignConfig).GetSignConfig(1,1)	
ClassMethod GetSignConfig(ATemplateID As %String, ATemplateVID As %String) As EMRservice.entity.ETemplateSignCofing
{
	s objItem = ##class(EMRservice.entity.ETemplateSignCofing).%New()
	q:(ATemplateID="")||(ATemplateVID="") objItem
	s id=$O(^DHCEMRM.TemplateSignConfigI("IndexTIDVersion"," "_$zcvt(ATemplateID,"U"),ATemplateVID,""))
	s objConfig = ##class(EMRmeta.TemplateSignConfig).%OpenId(id)
	q:(objConfig="") objItem
	s objItem.ID = id
	s objItem.TemplateID = ATemplateID
	s objItem.TemplateVersion = ATemplateVID
	s objItem.HasSign = objConfig.HasSign
	q objItem
}

/// Creator:	yejian
/// CreatDate:  2018-12-5
/// Desc:		更新签名配置
/// Input：		
/// Return：	1 成功，-1 失败
/// Debug:		w ##class(EMRservice.BL.BLTemplateSignConfig).GetSignConfig(UpSignConfig)	
ClassMethod UpSignConfig(ASignCofig As EMRservice.entity.ETemplateSignCofing) As %String
{
	s strRes = "1"
	s id=$O(^DHCEMRM.TemplateSignConfigI("IndexTIDVersion"," "_$zcvt(ASignCofig.TemplateID,"U"),ASignCofig.TemplateVersion,""))
	if ( id = "")
	{
		s obj = ##Class(EMRmeta.TemplateSignConfig).%New()
	}
	else
	{
		s obj = ##Class(EMRmeta.TemplateSignConfig).%OpenId(id)
	}
	
	s obj.TemplateID = ASignCofig.TemplateID
	s obj.TemplateVersion = ASignCofig.TemplateVersion
	s obj.HasSign = ASignCofig.HasSign
	s sc= obj.%Save()
	s:('sc) strRes="-1"
	q strRes
}

}
