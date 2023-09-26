Class EPRservice.entity.EEPImageLog Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Property ID As %String(TRUNCATE = 1);

Property CreateDate As %Date;

Property CreateTime As EPRmeta.Time;

Property PatientID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property EPRLogsID As %String(TRUNCATE = 1);

Property PrintType As %String(TRUNCATE = 1);

Property PrintTemplateID As %String(TRUNCATE = 1);

Property PrintDocID As %String(TRUNCATE = 1);

Property InstanceDataID As %String(TRUNCATE = 1);

Property UserID As %String(TRUNCATE = 1);

Property ClientIP As %String(TRUNCATE = 1);

}
