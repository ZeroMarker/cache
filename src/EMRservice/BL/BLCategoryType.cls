Class EMRservice.BL.BLCategoryType Extends %RegisteredObject
{

ClassMethod CheckIdExist(AID As %String) As %Integer
{
 &sql(SELECT Count(ID)
 into :Result 
 FROM EPRmeta.CategoryType
 WHERE ID = :AID)
 if Result=""
 {s Result=0 }
 QUIT Result
}

Query SELECTALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,TypeName:%String,TypeDescription:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EMR_CategoryType_SELECTALL, SqlProc ]
{
 SELECT ID, TypeName,  TypeDescription
 FROM EMRmeta.CategoryType
 ORDER BY ID
}

}
