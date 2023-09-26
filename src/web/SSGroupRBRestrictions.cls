Class web.SSGroupRBRestrictions Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 35;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

ClassMethod AvailableLocation(SSGroupID As %Library.String = "", LocationID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod AvailableResource(SSGroupID As %Library.String = "", ResourceID As %Library.String = "") As %Library.Boolean
{
}

ClassMethod AvailableService(SSGroupID As %Library.String = "", ServiceID As %Library.String = "") As %Library.Boolean
{
}

/// A routine to determine if a Security Group has booking Restrictions
ClassMethod RBRestricted(SSGroupID As %Library.String = "") As %Library.Boolean
{
}

Parameter SQLCODE = "RB_LineCode";

Parameter SQLDESCRIPTION = "RB_RowId";

Parameter SQLROWID = "RB_RowId";

}
