Include webimport

IncludeGenerator webimport

Class web.PHCGeneric Extends (websys.Abstract, %Library.RegisteredObject) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 20;

Parameter SQLDATEFROM = "PHCGE_DateFrom";

Parameter SQLDATETO = "PHCGE_DateTo";

Parameter SQLCODE = "PHCGE_Code";

Parameter SQLDESCRIPTION = "PHCGE_Name";

Parameter SQLROWID = "PHCGE_RowID";

Property dummy As %String(TRUNCATE = 1);

}
