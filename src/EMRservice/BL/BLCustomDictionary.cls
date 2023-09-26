Class EMRservice.BL.BLCustomDictionary Extends %RegisteredObject
{

ClassMethod GetCtmDictLinkByCode(parCtmDictCode As %String) As %String
{
 &sql(SELECT CtmDictLink
 into :Result
 FROM EMRmeta.CustomDictionary
 WHERE CtmDictCode = :parCtmDictCode)
 
 s:(SQLCODE'=0) Result=""
 
 QUIT Result
}

}
