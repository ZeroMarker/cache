Include webimport

Class web.PACPregnConsultDegree Extends (%Library.RelationshipObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 6;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CONDEG_Code";

Parameter SQLDESCRIPTION = "CONDEG_Desc";

Parameter SQLROWID = "CONDEG_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

Storage Custom
{
<Type>%Library.CompleteCustomStorage</Type>
}

}
