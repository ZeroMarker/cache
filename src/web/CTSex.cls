Include webimport

IncludeGenerator webimport

Class web.CTSex Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 136;

Parameter SQLDATEFROM = "CTSEX_DateFrom";

Parameter SQLDATETO = "CTSEX_DateTo";

ClassMethod GetCodeFromDescription(desc As %String) As %String
{
}

Parameter SQLCODE = "CTSEX_Code";

Parameter SQLDESCRIPTION = "CTSEX_Desc";

/// This value of this parameter is appended to the end of the SQL WHERE clause used in both standard lookups and standard broker validation.
/// This is typically used for filtering records to allow only active records to be used.
Parameter SQLFILTER = "((CTSEX_DateFrom <= CURRENT_DATE OR CTSEX_DateFrom IS NULL) AND (CTSEX_DateTo >= CURRENT_DATE OR CTSEX_DateTo IS NULL))";

Parameter SQLROWID = "CTSEX_RowId";

Property dummy As %String(TRUNCATE = 1);

/// KM 27-Sept-2001: Called from RBAppointment.websysSaveApptStatus
/// Once the LookUpBroker method works for this class then should only need method GetCodeFromDescription
ClassMethod GetCodeFromCodeOrDescription(val As %Library.String) As %Library.String
{
}

ClassMethod GetDescriptionFromIdOrCode(RowID As %Library.String = "", code As %Library.String = "") As %Library.String
{
}

ClassMethod LookUpBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod LookUpGroupBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUp(desc As %String) As %Library.Query(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
}

Query LookUpGroup(desc As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String,HIDDEN:%String")
{

  SELECT CTSEX_Desc,CTSEX_RowId,CTSEX_Code,CTSEX_GrouperCode
      FROM SQLUser.CT_Sex 
      WHERE (CTSEX_Desc %STARTSWITH :desc)
      order by CTSEX_Desc
}

}
