Class web.CTDBSpecimen Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 47;

Parameter SQLCODE = "DBSPEC_Code";

Parameter SQLDATEFROM = "DBSPEC_DateFrom";

Parameter SQLDESCRIPTION = "DBSPEC_RowId";

Parameter SQLDATETO = "DBSPEC_DateTo";

Parameter SQLROWID = "DBSPEC_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetDBSpecTypeCodesAndDescs(ItemID, EpID, Order) As %String
{
}

ClassMethod GetDBSpecTypeByDate(Site) As %String
{
}

ClassMethod GetDBSpecTypes() As %String
{
}

}
