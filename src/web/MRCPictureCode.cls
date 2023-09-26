Class web.MRCPictureCode Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 40;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "PIC_RowId";

Parameter SQLDESCRIPTION = "PIC_Desc";

Parameter SQLROWID = "PIC_RowId";

ClassMethod LookupPictureBroker(itmjs As %Library.String, itmjsex As %Library.String, val As %String = "", CTLOCDR As %Library.String = "")
{
}

Query LookupPicture(val As %String, CTLOCDR As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "Description:%String, HIDDEN:%String, Filename:%String")
{
SELECT PIC_Desc, PIC_RowId, PIC_FileName
FROM SQLUser.MRC_PictureCode
WHERE ((%ALPHAUP PIC_Desc %STARTSWITH %ALPHAUP :val) OR (:val is null))
AND ((PIC_CTLOC_DR=:CTLOCDR) OR (:CTLOCDR is null))
}

}
