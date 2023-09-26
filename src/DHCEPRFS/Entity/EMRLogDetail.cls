Class DHCEPRFS.Entity.EMRLogDetail Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", ProcedureBlock ]
{

Property ID As %String(TRUNCATE = 1);

Property TheMRLogID As %String(TRUNCATE = 1);

/// 2
Property DetailNum As %String(TRUNCATE = 1);

/// 3
Property PrevStatus As %String(TRUNCATE = 1);

/// 4
Property PostStatus As %String(TRUNCATE = 1);

/// 5
Property MRAction As %String(TRUNCATE = 1);

/// 6
Property ActDate As %Date;

/// 7
Property ActTime As %Time;

/// 8
Property ActUserID As %String(TRUNCATE = 1);

/// 9
Property ActPages As %String(TRUNCATE = 1);

/// 10
Property ActPrice As %String(TRUNCATE = 1);

/// 11
Property ActSchemeID As %String(TRUNCATE = 1);

/// 12
Property Remark As %String(TRUNCATE = 1);

Property MREpisodeID As %String(TRUNCATE = 1);

Property MRMedRecordID As %String(TRUNCATE = 1);

}
