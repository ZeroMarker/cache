Class EPRmeta.KnowledgeBase Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Property Description As %String(TRUNCATE = 1);

Property KBCategoryID As %String(TRUNCATE = 1);

Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

Property S1Name As %String(TRUNCATE = 1);

Property S2Name As %String(TRUNCATE = 1);

Property S3Name As %String(TRUNCATE = 1);

Property SegmentNumber As %Integer;

Query SELECTBYCATEID(CATEID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,KBCategoryID:%String,Description:%String,S1Name:%String,S2Name:%String,S3Name:%String,SegmentNumber:%Integer", SELECTMODE = "RUNTIME") [ SqlName = SP_KNowledgeBase_SELECTBYCATEID, SqlProc ]
{
 SELECT ID, Name, KBCategoryID, Description,S1Name,S2Name,S3Name,SegmentNumber
 FROM EPRmeta.KnowledgeBase
 WHERE KBCategoryID = :CATEID
 ORDER BY ID
}

Storage Default
{
<Data name="KnowledgeBaseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>KBCategoryID</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>S1Name</Value>
</Value>
<Value name="6">
<Value>S2Name</Value>
</Value>
<Value name="7">
<Value>S3Name</Value>
</Value>
<Value name="8">
<Value>SegmentNumber</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.KnowledgeBaseD</DataLocation>
<DefaultData>KnowledgeBaseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.KnowledgeBaseD</IdLocation>
<IndexLocation>^DHCEPRM.KnowledgeBaseI</IndexLocation>
<StreamLocation>^DHCEPRM.KnowledgeBaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
