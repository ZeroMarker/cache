Class EMRservice.entity.EKBNode Extends (%Library.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Property Description As %String(TRUNCATE = 1);

Property ID As %String(TRUNCATE = 1);

Property KBTreeID As %String(TRUNCATE = 1);

Property KnowledgeBaseID As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property PresentationData As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEMRKBNodeStream($J)");

Property MetaData As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEMRKBNodeStream($J)");

Property ScriptData As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEMRKBNodeStream($J)");

Property MediasData As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEMRKBNodeStream($J)");

Property InitialData As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEMRKBNodeStream($J)");

Property Sequence As %String(TRUNCATE = 1);

Property IsCommon As %String(TRUNCATE = 1);

/// 是否启用知识接点 （Y：启用-默认，N：停用）
Property IsInUse As %String(TRUNCATE = 1) [ InitialExpression = "Y" ];

/// 创建者UserID
Property UserID As %String(TRUNCATE = 1);

/// 使用状态 ALL 通用，DOC 文档型，GRID 网格型。
Property NodeType As %String(TRUNCATE = 1);

/// 纯文本内容
Property TextData As %String(MAXLEN = 30000, TRUNCATE = 1);

/// 是否分享个人知识库节点 （Y：分享，N：不分享-默认）
Property IsShare As %String(TRUNCATE = 1);

/// Added on 2008-06-04, by houjian@dhcc.com.cn
/// Purpose: 删除与其自身实例对象相关的临时Global 
Method %OnClose() As %Status [ Private ]
{
	s id = ..PresentationData.GetStreamId()
	if $find(id,"^CacheTempDHCEMRKBNodeStream($J)")
	{
		do ..PresentationData.Clear()
	}
	
	s id = ..MetaData.GetStreamId()
	if $find(id,"^CacheTempDHCEMRKBNodeStream($J)")
	{
  		do ..MetaData.Clear()
	}
	
	s id = ..ScriptData.GetStreamId()
	if $find(id,"^CacheTempDHCEMRKBNodeStream($J)")
	{
  		do ..ScriptData.Clear()
	}	

  
  	quit "1"
}

}
