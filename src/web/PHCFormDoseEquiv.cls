Include webimport

IncludeGenerator webimport

Class web.PHCFormDoseEquiv Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 192;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "EQ_RowId";

Parameter SQLDESCRIPTION = "EQ_RowId";

Parameter SQLROWID = "EQ_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod LookUpUOMClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpUOMFetch ]
{
}

ClassMethod LookUpUOMExecute(ByRef QHandle As %Library.Binary, drgfrm As %String, desc As %String, itmMast As %Library.String, DoseQty As %Library.String, Broker As %Library.String = "") As %Library.Status
{
}

ClassMethod LookUpUOMFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpUOMExecute ]
{
}

ClassMethod LookUpUOMBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", drgfrm As %Library.String = "", desc As %Library.String = "", OEORIItmMastDR As %Library.String = "", DoseQty As %Library.String = "") As %Library.Boolean
{
}

Query Find(drgfrm As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,CTUOMDesc:%String,EQDefaultDose:%Float,EQQty:%Float")
{
SELECT EQ_RowID, EQ_CTUOM_DR->CTUOM_Desc, EQ_DefaultDose, EQ_Qty
FROM PHC_FormDoseEquiv
WHERE (EQ_ParRef = :drgfrm)
}

Query LookUpByDrugForm(drgfrm As %String, desc As %String) As %Query(CONTAINID = 0, ROWSPEC = "Desc:%String")
{
SELECT EQ_CTUOM_DR->CTUOM_Desc
FROM PHC_FormDoseEquiv
WHERE (EQ_ParRef = :drgfrm) AND (EQ_CTUOM_DR->CTUOM_Desc %STARTSWITH :desc)
}

/// Basic query returning description from a partial description, ordered by description.
/// Compiled will attempt to derive the 'description' property from available properties unless it is explicity
/// set in the SQLDESCRIPTION parameter.
/// SQLROWID may be used to specify the field name to be used as rowid.
Query LookUpUOM(drgfrm As %String, desc As %String, itmMast As %String, DoseQty As %String, Broker As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Description:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

Query LookUpDoseUOM(DrgForm As %String, GenRtFrom As %String, Desc As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Desc:%String")
{
}

ClassMethod LookUpDoseUOMClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpDoseUOMFetch ]
{
}

ClassMethod LookUpDoseUOMExecute(ByRef QHandle As %Library.Binary, DrgForm As %String, GenRtFrom As %String, Desc As %String) As %Library.Status
{
}

ClassMethod LookUpDoseUOMFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpDoseUOMExecute ]
{
}

ClassMethod LookUpDoseUOMBroker(itmjs As %Library.String, itmjsex As %Library.String, DrgForm As %Library.String = "", GenRtFrom As %Library.String = "", Desc As %Library.String = "") As %Library.Boolean
{
}

}
