Class web.ARCItemSpecimen Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 105;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "SPEC_RowId";

Parameter SQLDESCRIPTION = "SPEC_RowId";

Parameter SQLROWID = "SPEC_RowId";

Query FindDefaultMedSpecimens(itemid As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "SPECSpecimenDR:%String")
{
SELECT SPEC_Specimen_DR->SPEC_Desc
FROM SQLUser.ARC_ItemSpecimen
WHERE (SPEC_ParRef = :itemid) AND (SPEC_Default = 'Y')
}

Query LookUpMedSpecimens(itemid As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "HIDDEN:%String,SPECSpecimenDR:%String")
{
SELECT SPEC_Specimen_DR->SPEC_Code,SPEC_Specimen_DR->SPEC_Desc
FROM SQLUser.ARC_ItemSpecimen
WHERE (SPEC_ParRef = :itemid)
}

}
