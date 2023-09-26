Class EPRservice.entity.EEPImagePage Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Property ID As %String(TRUNCATE = 1);

Property EPImageID As %String(TRUNCATE = 1);

Property PageIndex As %Integer;

Property ImageData As %GlobalBinaryStream(LOCATION = "^CacheTempDHCEPREPImagePageStream($J)");

Method %OnClose() As %Status [ Private ]
{
	s id = ..ImageData.GetStreamId()
	if $find(id,"^CacheTempDHCEPREPImagePageStream($J)")
	{
		do ..ImageData.Clear()
	}
	
	q "1"
}

}
