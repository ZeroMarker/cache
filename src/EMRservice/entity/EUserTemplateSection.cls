/// 名称:用户模板知识库节点表
/// 描述:用户模板知识库节点表
/// 编写者：yejian
/// 编写日期: 2017-11-7
Class EMRservice.entity.EUserTemplateSection Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String(TRUNCATE = 1);

/// 分组代码EMRmeta.UserTemplate的Code
Property Code As %String(MAXLEN = 200, TRUNCATE = 1);

/// 模板章节编码
Property SectionCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// KbBaseID
Property KbBaseID As %String;

/// 有效标志
Property ActiveFlag As %String;

/// 元数据
Property MetaData As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEMRTplVrnStream($J)");

/// 脚本信息
Property ScriptData As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEMRTplVrnStream($J)");

/// 展现数据
Property PresentationData As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEMRTplVrnStream($J)");

/// 媒体数据
Property MediasData As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEMRTplVrnStream($J)");

/// 默认值
Property InitialData As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEMRTplVrnStream($J)");

/// Added on 2008-06-04, by houjian@dhcc.com.cn
/// Purpose: 删除与其自身实例对象相关的临时Global 
Method %OnClose() As %Status [ Private ]
{
	s id = ..MetaData.GetStreamId()
	if $find(id,"^CacheTempDHCEMRTplVrnStream($J)")
	{
  		do ..MetaData.Clear()
	}
	s id = ..ScriptData.GetStreamId()
	if $find(id,"^CacheTempDHCEMRTplVrnStream($J)")
	{
  		do ..ScriptData.Clear()
	}
	s id = ..PresentationData.GetStreamId()
	if $find(id,"^CacheTempDHCEMRTplVrnStream($J)")
	{
  		do ..PresentationData.Clear()
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
