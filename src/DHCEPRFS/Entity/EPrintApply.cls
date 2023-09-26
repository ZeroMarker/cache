Class DHCEPRFS.Entity.EPrintApply Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Property MRPatientID As %String(TRUNCATE = 1);

Property MREpisodeID As %String(TRUNCATE = 1);

Property ApplyDate As %Date;

Property ApplyTime As %Time;

Property Reason As %String(TRUNCATE = 1);

Property Applicant As %String(TRUNCATE = 1);

Property ApplicantIDCard As %String(TRUNCATE = 1);

Property Relation As %String(TRUNCATE = 1);

Property UserID As %String(TRUNCATE = 1);

Property Picture1 As %GlobalBinaryStream;

Property Picture2 As %GlobalBinaryStream;

Property Picture3 As %GlobalBinaryStream;

Property Picture4 As %GlobalBinaryStream;

Property CardType As %String(TRUNCATE = 1);

}
