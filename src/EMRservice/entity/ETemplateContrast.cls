/// 名称: EMRservice.entity.ETemplateContrast
/// 描述: 病历模板对比数据项维护表
/// 编写者：叶剑
/// 编写日期: 2018-5-24
Class EMRservice.entity.ETemplateContrast Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String(TRUNCATE = 1);

Property TemplateID As %String(TRUNCATE = 1);

Property TemplateVersion As %String(TRUNCATE = 1);

Property Author As %String(TRUNCATE = 1);

Property LastSaveDate As %String;

Property PathCode As %String(TRUNCATE = 1);

/// PathCode有效
Property isValid As %Boolean;

Property ItemCode As %String(MAXLEN = 500, TRUNCATE = 1);

Property Text As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEMRTempContStream($J)");

Property StyleText As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEMRTempContStream($J)");

/// Purpose: 删除与其自身实例对象相关的临时Global 
Method %OnClose() As %Status [ Private ]
{
	s id = ..Text.GetStreamId()
	if $find(id,"^CacheTempDHCEMRTempContStream($J)")
	{
  		do ..Text.Clear()
	}
	
	s id = ..StyleText.GetStreamId()
	if $find(id,"^CacheTempDHCEMRTempContStream($J)")
	{
  		do ..StyleText.Clear()
	}
  	quit "1"
}

}
