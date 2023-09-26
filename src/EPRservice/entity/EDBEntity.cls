Class EPRservice.entity.EDBEntity Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Property ReceiveStream As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRStream");

Property SendStream As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRStream");

/// Added on 2008-06-04, by houjian@dhcc.com.cn
/// Purpose: 删除与其自身实例对象相关的临时Global
Method %OnClose() As %Status [ Private ]
{
	s id = ..ReceiveStream.GetStreamId()
	if $find(id,"^CacheTempDHCEPRStream")
	{
		do ..ReceiveStream.Clear()
  	
	}
	
	s id = ..SendStream.GetStreamId()
	if $find(id,"^CacheTempDHCEPRStream")
	{
		do ..SendStream.Clear()
	}

  	quit "1"
}

}
