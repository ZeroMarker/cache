Class web.OECBodySite Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 54;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "BODS_Code";

Parameter SQLDESCRIPTION = "BODS_Desc";

Parameter SQLROWID = "BODS_RowID";

Property dummy As %Library.String(TRUNCATE = 1);

Query LookUpForListBox() As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "Code,Desc")
{
	SELECT	BODS_Code,BODS_Desc
	FROM	SQLUser.OEC_BodySite
	ORDER	BY BODS_Desc
}

}
