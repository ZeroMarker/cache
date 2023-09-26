Class EPRservice.entity.ETemplateVersion Extends (%Library.RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

Property Author As %String(TRUNCATE = 1);

Property CreateDate As %Date;

Property CreateTime As %Time;

Property ID As %String(TRUNCATE = 1);

Property InitialData As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRTplVrnStream($J)");

Property LastSaveDate As %Date;

Property LastSaveTime As %Time;

Property MetaData As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRTplVrnStream($J)");

Property PresentationData As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRTplVrnStream($J)");

Property GridData As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRTplVrnStream($J)");

Property PublicationDate As %Date;

Property PublicationTime As %Time;

Property Status As %Integer;

Property TemplateID As %String(TRUNCATE = 1);

Property VersionNumber As %Integer;

/// Added on 2008-06-04, by houjian@dhcc.com.cn
/// Purpose: 删除与其自身实例对象相关的临时Global 
Method %OnClose() As %Status [ Private ]
{
	s id = ..MetaData.GetStreamId()
	if $find(id,"^CacheTempDHCEPRTplVrnStream($J)")
	{
  		do ..MetaData.Clear()
	}
	
	s id = ..PresentationData.GetStreamId()
	if $find(id,"^CacheTempDHCEPRTplVrnStream($J)")
	{
  		do ..PresentationData.Clear()
	}
	
	s id = ..GridData.GetStreamId()
	if $find(id,"^CacheTempDHCEPRTplVrnStream($J)")
	{
  		do ..GridData.Clear()
	}	
	
	s id = ..InitialData.GetStreamId()
	if $find(id,"^CacheTempDHCEPRTplVrnStream($J)")
	{
		do ..InitialData.Clear()
	}
	
  	quit "1"
}

}
