Class epr.SocialHistFav Extends %Library.Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Query LookUpSocHistList(PrefID As %String, UserID As %String, LocID As %String, GroupID As %String, SiteCode As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Code:%String,Description:%String")
{
}

ClassMethod LookUpSocHistListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpSocHistListFetch ]
{
}

/// PJC - 13/10/2006 - 60087
ClassMethod LookUpSocHistListExecute(ByRef QHandle As %Library.Binary, PrefID As %String = "", UserID As %String = "", LocID As %String = "", GroupID As %String = "", SiteCode As %String = "") As %Library.Status
{
}

ClassMethod LookUpSocHistListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpDiagListExecute ]
{
}

ClassMethod GetPrefs(ID As %String = "") As %String
{
}

ClassMethod SavePrefs(compid As %Library.String, level As %String = "")
{
}

ClassMethod DeletePrefs(compref As %Library.String, level As %String = "")
{
}

ClassMethod SaveMultiHabits(compref As %String = "", HabitIds As %String = "", PatientID As %String = "")
{
}

Storage Default
{
<Data name="SocialHistFavDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^epr.SocialHistFavD</DataLocation>
<DefaultData>SocialHistFavDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.SocialHistFavD</IdLocation>
<IndexLocation>^epr.SocialHistFavI</IndexLocation>
<StreamLocation>^epr.SocialHistFavS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
