Class EPRservice.entity.EImagePosition Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Property Code As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property ID As %String(TRUNCATE = 1);

Property Description As %String(TRUNCATE = 1);

Property Data As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRImagePosStream($J)");

/// Added on 2008-07-03, by houjian@dhcc.com.cn
/// Purpose: 删除与其自身实例对象相关的临时Global
Method %OnClose() As %Status [ Private ]
{
	s id = ..Data.GetStreamId()
	if $find(id,"^CacheTempDHCEPRImagePosStream($J)")
	{
		do ..Data.Clear()
	}
	
	quit 1
}

}
