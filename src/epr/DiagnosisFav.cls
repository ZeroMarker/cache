Class epr.DiagnosisFav Extends %Library.Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// ab 27.07.06 - called from lookup MRCICDDx.LookUpWithAlias() to pass back to epr.DiagnosisFav.Edit
ClassMethod GetOrderStringForDiag(DiagCode As %String = "", SaveLvl As %String = "") As %String
{
}

ClassMethod GetPrefs(ID As %String = "") As %String
{
}

ClassMethod CopyPrefs(ID As %String = "")
{
}

ClassMethod SavePrefs(compid As %Library.String, level As %String = "")
{
}

ClassMethod DeletePrefs(compref As %Library.String, level As %String = "")
{
}

/// called from MRDiagnos.websysSave
ClassMethod SaveMultiDiagnosis(compref As %String = "", DiagCodes As %String = "")
{
}

Query LookUpOrderList(OrderString As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Code:%String,Description:%String")
{
}

ClassMethod LookUpOrderListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpOrderListFetch ]
{
}

/// ab 20.07.06 59776
ClassMethod LookUpOrderListExecute(ByRef QHandle As %Library.Binary, OrderString As %String = "") As %Library.Status
{
}

ClassMethod LookUpOrderListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpOrderListExecute ]
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

Query LookUpCurrIllness(mradm As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Code:%String,Description:%String")
{
}

ClassMethod LookUpCurrIllnessClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpCurrIllnessFetch ]
{
}

/// ab 7.08.06 59776
ClassMethod LookUpCurrIllnessExecute(ByRef QHandle As %Library.Binary, mradm As %String = "") As %Library.Status
{
}

ClassMethod LookUpCurrIllnessFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpCurrIllnessExecute ]
{
}

Storage Default
{
<Data name="DiagnosisFavDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^epr.DiagnosisFavD</DataLocation>
<DefaultData>DiagnosisFavDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.DiagnosisFavD</IdLocation>
<IndexLocation>^epr.DiagnosisFavI</IndexLocation>
<StreamLocation>^epr.DiagnosisFavS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
