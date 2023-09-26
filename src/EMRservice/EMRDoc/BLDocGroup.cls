Class EMRservice.EMRDoc.BLDocGroup Extends %RegisteredObject
{

Query SelectAll() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,GroupName:%String")
{
	SELECT ID,GroupName
	FROM EMRmeta_EMRDocRestriction.DocGroup
	ORDER BY ID
}

}
