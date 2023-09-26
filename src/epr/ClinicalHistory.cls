Class epr.ClinicalHistory Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod websysDeleteHISTAllergen(compref As %String, rowID)
{
}

ClassMethod websysSaveHISTAllergen(compref As %String)
{
}

ClassMethod websysAuthorise(compref As %String)
{
}

ClassMethod GetConsultFromAppt(apptID As %String = "")
{
}

}
