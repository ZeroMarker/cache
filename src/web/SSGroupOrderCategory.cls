Class web.SSGroupOrderCategory Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 47;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "SSORD_RowId";

Parameter SQLDESCRIPTION = "SSORD_RowId";

Parameter SQLROWID = "SSORD_RowId";

Query FindSubCatRestrictions(GroupID As %Library.String, Category As %Library.String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "ARCICDesc:%String")
{
SELECT SSORD_OrdSubCategory->ARCIC_Desc
FROM  SQLUser.SS_GroupOrderCategory
WHERE (SSORD_OrdCat_DR->ORCAT_Desc= :Category) AND (SSORD_ParRef= :GroupID)
}

}
