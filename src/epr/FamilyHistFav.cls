Class epr.FamilyHistFav Extends %Library.Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

ClassMethod GetPrefs(ID As %String = "") As %String
{
}

ClassMethod SavePrefs(compid As %Library.String, level As %String = "")
{
}

ClassMethod DeletePrefs(compref As %Library.String, level As %String = "")
{
}

ClassMethod SaveMultiDiagnosis(compref As %String = "", DiagCodes As %String = "", FamilyList As %String = "", PatientID As %String = "")
{
}

Query LookUpDiagList(PrefID As %String, List As %String, UserID As %String, LocID As %String, GroupID As %String, SiteCode As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Code:%String,Description:%String")
{
}

ClassMethod LookUpDiagListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpDiagListFetch ]
{
}

/// ab 21.07.06 59776
ClassMethod LookUpDiagListExecute(ByRef QHandle As %Library.Binary, PrefID As %String = "", List As %String = "", UserID As %String = "", LocID As %String = "", GroupID As %String = "", SiteCode As %String = "") As %Library.Status
{
}

ClassMethod LookUpDiagListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpDiagListExecute ]
{
}

Storage Default
{
<Data name="FamilyHistFavDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^epr.FamilyHistFavD</DataLocation>
<DefaultData>FamilyHistFavDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.FamilyHistFavD</IdLocation>
<IndexLocation>^epr.FamilyHistFavI</IndexLocation>
<StreamLocation>^epr.FamilyHistFavS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
