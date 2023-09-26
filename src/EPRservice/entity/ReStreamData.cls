Class EPRservice.entity.ReStreamData Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

//Property Des As %String;

//不再使用^CacheTempDHCEPRReStream($I(CacheTemp))这个临时存储位置，无法自动清除这个临时global

//Property StreamData As %Stream(LOCATION = "^CacheTempDHCEPRReStream($I(CacheTemp))") [ Collection = characterstream ];

Property StreamData As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRReStream($J)");

/// Added on 2008-06-04, by houjian@dhcc.com.cn
/// Purpose: 删除与其自身实例对象相关的临时Global 
Method %OnClose() As %Status [ Private ]
{
	s id = ..StreamData.GetStreamId()
	if $find(id,"^CacheTempDHCEPRReStream($J)")
	{
		do ..StreamData.Clear()
 	}
 	 
  	quit "1"
}

}
