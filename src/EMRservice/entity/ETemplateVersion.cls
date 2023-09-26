Class EMRservice.entity.ETemplateVersion Extends (%Library.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Property Author As %String(TRUNCATE = 1);

Property CreateDate As %Date;

Property CreateTime As %String;

Property ID As %String(TRUNCATE = 1);

Property LastSaveDate As %Date;

Property LastSaveTime As %String;

Property MetaData As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEMRTplVrnStream($J)");

Property PresentationData As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEMRTplVrnStream($J)");

Property GridData As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEMRTplVrnStream($J)");

/// 病历模板规则脚本定义信息
Property ScriptData As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEMRTplVrnStream($J)");

Property MediasData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.TemplateVersionS");

Property InitialData As %GlobalBinaryStream(LOCATION = "^DHCEMRM.TemplateVersionS");

Property PublicationDate As %Date;

Property PublicationTime As %String;

Property Status As %Integer;

Property TemplateID As %String(TRUNCATE = 1);

Property VersionNumber As %Integer;

/// 病历摘要信息
Property TemplateSummary As %String(MAXLEN = 20000, TRUNCATE = 1);

/// Added on 2008-06-04, by houjian@dhcc.com.cn
/// Purpose: 删除与其自身实例对象相关的临时Global 
Method %OnClose() As %Status [ Private ]
{
	s id = ..MetaData.GetStreamId()
	if $find(id,"^CacheTempDHCEMRTplVrnStream($J)")
	{
  		do ..MetaData.Clear()
	}
	
	s id = ..PresentationData.GetStreamId()
	if $find(id,"^CacheTempDHCEMRTplVrnStream($J)")
	{
  		do ..PresentationData.Clear()
	}
	
	s id = ..GridData.GetStreamId()
	if $find(id,"^CacheTempDHCEMRTplVrnStream($J)")
	{
  		do ..GridData.Clear()
	}	

	s id = ..ScriptData.GetStreamId()
	if $find(id,"^CacheTempDHCEMRTplVrnStream($J)")
	{
  		do ..ScriptData.Clear()
	}
	s id = ..MediasData.GetStreamId()
	if $find(id,"^CacheTempDHCEMRTplVrnStream($J)")
	{
  		do ..MediasData.Clear()
	}	
	s id = ..InitialData.GetStreamId()
	if $find(id,"^CacheTempDHCEMRTplVrnStream($J)")
	{
  		do ..InitialData.Clear()
	}
  	quit "1"
}

}
