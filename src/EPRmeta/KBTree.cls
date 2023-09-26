Class EPRmeta.KBTree Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Index IdxKnowledgeBaseID On KnowledgeBaseID;

Index IdxParentID On ParentID;

Property Description As %String(TRUNCATE = 1);

Property KnowledgeBaseID As %String(TRUNCATE = 1);

Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

Property ParentID As %String(TRUNCATE = 1);

Property ResChildCount As %Integer;

Property Sequence As %Integer;

Property PersonalKBUserID As %String(TRUNCATE = 1);

Query SELECTALL(AKnowledgeBaseID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,ParentID:%String,KnowledgeBaseID:%String,Description:%String,ResChildCount:%Integer,PersonalKBUserID:%String,Sequence:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_KBTree_SELECTALL, SqlProc ]
{
 SELECT ID, Name, ParentID,KnowledgeBaseID, Description,ResChildCount,PersonalKBUserID,Sequence
 FROM EPRmeta.KBTree
 WHERE KnowledgeBaseID = :AKnowledgeBaseID
 ORDER BY Sequence
}

Query SELECTBYPARANTID(ParentID As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,ParentID:%String,KnowledgeBaseID:%String,Description:%String,ResChildCount:%Integer,PersonalKBUserID:%String,Sequence:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_KBTree_SELECTBYPARENTID, SqlProc ]
{
 SELECT ID, Name, ParentID,KnowledgeBaseID, Description,ResChildCount,PersonalKBUserID,Sequence
 FROM EPRmeta.KBTree
 WHERE ParentID = :ParentID
 ORDER BY Sequence
}

Storage Default
{
<Data name="KBTreeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>KnowledgeBaseID</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>ParentID</Value>
</Value>
<Value name="6">
<Value>ResChildCount</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
<Value name="8">
<Value>PersonalKBUserID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.KBTreeD</DataLocation>
<DefaultData>KBTreeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.KBTreeD</IdLocation>
<IndexLocation>^DHCEPRM.KBTreeI</IndexLocation>
<StreamLocation>^DHCEPRM.KBTreeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
