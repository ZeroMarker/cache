Class EMRservice.entity.EECRcord Extends (%RegisteredObject, %XML.Adaptor)
{

Property ID As %String;

Property CategoryID As %String(TRUNCATE = 1);

Property CategoryType As %String(TRUNCATE = 1);

Property ChartItemID As %String(TRUNCATE = 1);

Property ChartItemType As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property EpisodeType As %String(TRUNCATE = 1);

Property GroupCategoryID As %String(TRUNCATE = 1);

Property InstanceCount As %Integer;

Property PatientID As %String(TRUNCATE = 1);

Property DocumentType As %String(TRUNCATE = 1);

Property DocumentCharacteristic As %String(TRUNCATE = 1);

}
