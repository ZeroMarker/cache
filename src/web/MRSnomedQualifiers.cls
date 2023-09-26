Class web.MRSnomedQualifiers Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 7;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "SNQ_RowId";

Parameter SQLDESCRIPTION = "SNQ_RowId";

Parameter SQLROWID = "SNQ_RowId";

ClassMethod SaveQualifier(Qualifiers, ConceptID, SUBFID As %Library.String = "", MRDIAID As %Library.String = "")
{
}

}
