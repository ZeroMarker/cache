Class web.CTContainer Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetIdFromCodeOrDescription(val As %Library.String) As %Library.String
{
}

ClassMethod LookUpBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

/// Log 41647 - AI - 25-02-2004 : Create Method for restricting container LookUpBroker based on specimen.
ClassMethod LookUpBrokerBySpecimen(itmjs As %Library.String = "", itmjsex As %Library.String = "", TestSetCode As %String, speccode As %String, container As %String = "") As %Library.Status
{
}

/// Log 41647 - AI - 25-02-2004 : Create Method for restricting container LookUp based on specimen.
ClassMethod LookUpBySpecimenClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpBySpecimenFetch ]
{
}

/// Log 41647 - AI - 25-02-2004 : Create Method for restricting container LookUp based on specimen.
ClassMethod LookUpBySpecimenExecute(ByRef QHandle As %Library.Binary, TestSetCode As %String, speccode As %String, container As %String = "") As %Library.Status
{
}

/// Log 41647 - AI - 25-02-2004 : Create Method for restricting container LookUp based on specimen.
ClassMethod LookUpBySpecimenFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpBySpecimenExecute ]
{
}

/// Log 41647 - AI - 25-02-2004 : Create Query definition for restricting container LookUp based on specimen.
Query LookUpBySpecimen(specbuffer As %String, position As %String, container As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
}

}
