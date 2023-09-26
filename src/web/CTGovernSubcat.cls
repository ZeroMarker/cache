Class web.CTGovernSubcat Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 3;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "SUB_Code";

Parameter SQLDESCRIPTION = "SUB_Desc";

Parameter SQLROWID = "SUB_RowId";

/// This returns description,id,code (this is to be consitent with lookups)
ClassMethod GetCodeDescriptionFromId(val As %Library.String) As %Library.String
{
}

}
