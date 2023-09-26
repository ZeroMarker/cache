Class web.CTSpecimen Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetIdFromCodeOrDescription(val As %Library.String) As %Library.String
{
}

ClassMethod LookUpBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod xxxLookUpNonLabBroker(itmjs As %Library.String, itmjsex As %Library.String, val As %Library.String) As %Library.Boolean
{
}

ClassMethod xxxLookUpSpecimenBroker(itmjs As %Library.String, itmjsex As %Library.String, val As %Library.String) As %Library.Boolean
{
}

ClassMethod xxxLookUpSpecimenClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = xxxLookUpSpecimenFetch ]
{
}

ClassMethod xxxLookUpSpecimenExecute(ByRef QHandle As %Library.Binary, specimen As %Library.String) As %Library.Status
{
}

ClassMethod xxxLookUpSpecimenFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = xxxLookUpSpecimenExecute ]
{
}

/// A query to use either LabTrak or MedTrak Specimen Lists
Query xxxLookUpNonLab(specimen As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT SPEC_Desc, SPEC_RowID, SPEC_Code
FROM SQLUser.CT_Specimen
WHERE (SPEC_Desc %STARTSWITH :specimen) OR
 (:specimen = '')
ORDER BY SPEC_Desc
}

/// A query to use either LabTrak or MedTrak Specimen Lists
Query xxxLookUpSpecimen(specimen As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
}

}
