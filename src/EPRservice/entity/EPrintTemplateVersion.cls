Class EPRservice.entity.EPrintTemplateVersion Extends (%Library.RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

Property Author As %String(TRUNCATE = 1);

Property CreateDate As %Date;

Property CreateTime As %Time;

Property Data As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRPTplVrnStream($J)");

Property ID As %String(TRUNCATE = 1);

Property LastSaveDate As %Date;

Property LastSaveTime As %Time;

Property PrintTemplateID As %String(TRUNCATE = 1);

Property PublicationDate As %Date;

Property PublicationTime As %Time;

Property ShapeNames As %String(TRUNCATE = 1);

Property Status As %Integer;

Property VersionNumber As %Integer;

Property HeadStartPageNum As %String(TRUNCATE = 1);

Property FootRepeatRowStart As %String(TRUNCATE = 1);

Property FootRepeatRowEnd As %String(TRUNCATE = 1);

Property OnePageRowCount As %String(TRUNCATE = 1);

Property Duplex As %Boolean;

Property MultiplePagesOption As %String(TRUNCATE = 1);

Property NewPageStartOdd As %Boolean;

Property BlankPageStyle As %String(TRUNCATE = 1);

/// Added on 2008-06-04, by houjian@dhcc.com.cn
/// Purpose: 删除与其自身实例对象相关的临时Global
Method %OnClose() As %Status [ Private ]
{
	s id=..Data.GetStreamId()
	if $find(id,"^CacheTempDHCEPRPTplVrnStream($J)")
	{
		do ..Data.Clear()
	}
}

}
