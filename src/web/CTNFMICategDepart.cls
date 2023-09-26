Class web.CTNFMICategDepart Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 92;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
/// TP 23/11/01: Lookup by Government Category code
/// MD 06/02/2003
/// n depcode,depdesc,depid,retval
/// 	;
/// 	s (depcode,depdesc,depid)=""	
/// 	; Try and find a matching code
/// 	&sql(
/// 	SELECT	DEP_Code, DEP_Desc,DEP_RowID
/// 	INTO	:depcode, :depdesc, :descid
/// 	FROM	SQLUser.CT_NFMI_CategDepart
/// 	WHERE	(DEP_Code = :val)
/// 	AND 	(DEP_ParRef->NFMI_Code =:catcode)
/// 	)
/// 	i SQLCODE s (depcode,depdesc,depid)=""
/// 	;assign the description back to the page
/// 	s retval=itmjs_"('"_$ZCVT(depcode,"O","JS")_"');"
/// 	i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(depcode,"O","JS")_"^"_$ZCVT(depid,"O","JS")_"');"
/// 	&javascript<#(retval)#>
/// 	q 1
ClassMethod LookUpBrokerByCategory(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", catcode As %Library.String = "") As %Library.Boolean
{
}

Parameter SQLCODE = "DEP_Code";

Parameter SQLDESCRIPTION = "DEP_Desc";

Parameter SQLROWID = "DEP_RowId";

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUpByCategory(codel As %String, catdesc As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Code:%String,Description:%String,DepDesciption:%String")
{
SELECT DEP_Code, DEP_Desc, DEP_ParRef->NFMI_Desc
FROM SQLUser.CT_NFMI_CategDepart
WHERE ((DEP_Code %STARTSWITH :codel) OR (%ALPHAUP DEP_Desc %STARTSWITH %ALPHAUP :codel))
AND (%ALPHAUP DEP_ParRef->NFMI_Desc [ %ALPHAUP :catdesc)
ORDER BY DEP_Code
}

}
