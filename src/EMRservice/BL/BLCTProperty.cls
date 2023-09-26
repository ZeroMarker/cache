Class EMRservice.BL.BLCTProperty Extends %RegisteredObject
{

ClassMethod CheckIdExist(AID As %String) As %Integer
{
 &sql(SELECT Count(ID)
 into :Result 
 FROM EMRmeta.CTProperty
 WHERE ID = :AID)
 if Result=""
 {s Result=0 }
 QUIT Result
}

Query SELECTALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,PropertyCode:%String,PropertyName:%String,ParentID:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_CTProperty_SELECTALL, SqlProc ]
{
 SELECT ID, PropertyCode, PropertyName, ParentID
 FROM EMRmeta.CTProperty
 ORDER BY ID
}

Query SELECTBYPARENTID(AParentID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,PropertyCode:%String,PropertyName:%String,ParentID:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_CTProperty_SELECTBYPARENTID, SqlProc ]
{
 SELECT ID, PropertyCode, PropertyName, ParentID
 FROM EMRmeta.CTProperty
 WHERE ParentID = :AParentID
 ORDER BY ID
}

}
