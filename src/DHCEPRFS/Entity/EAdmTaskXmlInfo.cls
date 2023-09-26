Class DHCEPRFS.Entity.EAdmTaskXmlInfo Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Property EpisodeID As %String;

Property MRItemID As %String;

//xml 信息

Property XMLInfo As %String(MAXLEN = 10000);

Property OperDate As %Date;

Property OperTime As %Time;

Property PatientID As %String;

Property TypeCode As %String;

}
