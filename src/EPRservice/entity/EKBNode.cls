Class EPRservice.entity.EKBNode Extends (%Library.RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

Property Description As %String(TRUNCATE = 1);

Property ID As %String(TRUNCATE = 1);

Property KBTreeID As %String(TRUNCATE = 1);

Property KnowledgeBaseID As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property S1InstanceData As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRKBNodeStream($J)");

Property S1MetaData As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRKBNodeStream($J)");

Property S2InstanceData As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRKBNodeStream($J)");

Property S2MetaData As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRKBNodeStream($J)");

Property S3InstanceData As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRKBNodeStream($J)");

Property S3MetaData As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRKBNodeStream($J)");

Property Sequence As %String(TRUNCATE = 1);

Property IsCommon As %String(TRUNCATE = 1);

/// 是否启用知识接点 （Y：启用-默认，N：停用）
Property IsInUse As %String(TRUNCATE = 1) [ InitialExpression = "Y" ];

/// Added on 2008-06-04, by houjian@dhcc.com.cn
/// Purpose: 删除与其自身实例对象相关的临时Global 
Method %OnClose() As %Status [ Private ]
{
	s id = ..S1InstanceData.GetStreamId()
	if $find(id,"^CacheTempDHCEPRKBNodeStream($J)")
	{
		do ..S1InstanceData.Clear()
	}
	
	s id = ..S1MetaData.GetStreamId()
	if $find(id,"^CacheTempDHCEPRKBNodeStream($J)")
	{
  		do ..S1MetaData.Clear()
	}
	
	s id = ..S2InstanceData.GetStreamId()
	if $find(id,"^CacheTempDHCEPRKBNodeStream($J)")
	{
  		do ..S2InstanceData.Clear()
	}
	
	s id = ..S2MetaData.GetStreamId()
	if $find(id,"^CacheTempDHCEPRKBNodeStream($J)")
	{
  		do ..S2MetaData.Clear()
	}
	
    s id = ..S3InstanceData.GetStreamId()
    if $find(id,"^CacheTempDHCEPRKBNodeStream($J)")
    {
  		do ..S3InstanceData.Clear()
    }
    
    s id = ..S3MetaData.GetStreamId()
    if $find(id,"^CacheTempDHCEPRKBNodeStream($J)")
    {
    	do ..S3MetaData.Clear()
    }
  
  	quit "1"
}

}
