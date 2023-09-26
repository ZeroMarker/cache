Class EPRservice.entity.EReportVersion Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Property Author As %String(TRUNCATE = 1);

Property CreateDate As %Date;

Property CreateTime As %Time;

Property Data As %GlobalCharacterStream(LOCATION = "^CacheTempDHCEPRRPTVrnStream($J)");

Property ID As %String(TRUNCATE = 1);

Property LastSaveDate As %Date;

Property LastSaveTime As %Time;

Property PublicationDate As %Date;

Property PublicationTime As %Time;

Property ReportID As %String(TRUNCATE = 1);

Property Status As %Integer;

Property VersionNumber As %Integer;

Property Conditions As %String(TRUNCATE = 1);

/// Added on 2008-06-04, by houjian@dhcc.com.cn
/// Purpose: 删除与其自身实例对象相关的临时Global
Method %OnClose() As %Status [ Private ]
{
	s id = ..Data.GetStreamId()
	if $find(id,"^CacheTempDHCEPRRPTVrnStream($J)")
	{
		do ..Data.Clear()
	}
}

}
