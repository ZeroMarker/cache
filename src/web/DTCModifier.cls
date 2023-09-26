Class web.DTCModifier Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 52;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

/// Used to control sql fields to be used in generated queries.<br>
/// Applies to LookupExecute,Fetch,Close.<br>
/// Applies to GetIdFromCodeOrDescription.<br>
Parameter SQLCODE = "MODIF_Code";

Parameter SQLDESCRIPTION = "MODIF_Desc";

Parameter SQLROWID = "MODIF_RowID";

Property dummy As %Library.String(TRUNCATE = 1);

Query FindModifiers() As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "MODIFDesc:%String")
{
SELECT MODIF_Desc
FROM SQLUser.DTC_Modifier
}

}
