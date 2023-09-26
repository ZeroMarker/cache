Class web.CTLocLinkLocation Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 55;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

/// KM 18-Mar-2002: Created for displaying linked locations on epr.floorplan.csp
ClassMethod GetLinkedLocations(LocID As %Library.String, ByRef locArray As %Library.String)
{
}

Parameter SQLCODE = "LINK_RowId";

Parameter SQLDESCRIPTION = "LINK_RowId";

Parameter SQLROWID = "LINK_RowId";

Query Find(LocID As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,LocID,LocDesc")
{
SELECT LINK_Rowid, LINK_CTLOC_DR, LINK_CTLOC_DR->CTLOC_Desc
FROM SQLUser.CT_LocLinkLocation
WHERE LINK_ParRef = :LocID
}

}
