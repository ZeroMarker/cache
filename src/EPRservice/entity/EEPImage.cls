Class EPRservice.entity.EEPImage Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Property ID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property EPRLogsID As %String(TRUNCATE = 1);

Property PageWidth As %Float;

Property PageHeight As %Float;

Property PrintType As %String(TRUNCATE = 1);

Property SaveType As %String(TRUNCATE = 1);

Property PageCount As %Integer;

Property HasTitlePage As %String(TRUNCATE = 1);

}
