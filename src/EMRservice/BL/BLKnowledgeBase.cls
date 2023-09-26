Class EMRservice.BL.BLKnowledgeBase Extends %RegisteredObject
{

Query SELECTBYCATEID(CATEID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,KBCategoryID:%String,Description:%String,NodeType:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_KNowledgeBase_SELECTBYCATEID, SqlProc ]
{
 SELECT ID, Name, KBCategoryID, Description,NodeType
 FROM EMRmeta.KnowledgeBase
 WHERE KBCategoryID = :CATEID
 ORDER BY ID
}

}
