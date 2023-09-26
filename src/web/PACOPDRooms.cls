Class web.PACOPDRooms Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right ]
{

Parameter BUILD = 6;

Parameter SQLCODE = "OPD_Code";

Parameter SQLDATEFROM = "OPD_DateFrom";

Parameter SQLDATETO = "OPD_DateTo";

Parameter SQLDESCRIPTION = "OPD_Desc";

Parameter SQLROWID = "OPD_RowId";

ClassMethod GetDescriptionFromId(id As %Library.String) As %Library.String
{
}

}
