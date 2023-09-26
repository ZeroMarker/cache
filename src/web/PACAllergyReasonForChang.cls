Class web.PACAllergyReasonForChang Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 23;

Parameter SQLDATEFROM = "ALRFC_DateFrom";

Parameter SQLDATETO = "ALRFC_DateTo";

Parameter SQLCODE = "ALRFC_Code";

Parameter SQLDESCRIPTION = "ALRFC_Desc";

Parameter SQLROWID = "ALRFC_RowId";

Parameter SQLFILTER = "((ALRFC_DateFrom <= CURRENT_DATE OR ALRFC_DateFrom IS NULL) AND (ALRFC_DateTo >= CURRENT_DATE OR ALRFC_DateTo IS NULL))";

Property dummy As %Library.String(TRUNCATE = 1);

}
