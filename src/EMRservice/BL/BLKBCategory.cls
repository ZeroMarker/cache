Class EMRservice.BL.BLKBCategory Extends %RegisteredObject
{

Query SELECTALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,ParentID:%String,Description:%String,ResChildCount:%Integer", SELECTMODE = "RUNTIME") [ SqlName = SP_KBCategory_SELECTALL, SqlProc ]
{
 SELECT ID, Name, ParentID, Description,ResChildCount
 FROM EMRmeta.KBCategory
 ORDER BY ID
}

}
