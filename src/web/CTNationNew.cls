Include webimport

IncludeGenerator webimport

Class web.CTNationNew Extends %Persistent
{

Query LookUp(lookDefaultNationDR As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,HIDDEN:%String,Prov:%String")
{
SELECT	CTNAT_Desc,CTNAT_RowId,CTNAT_Code
FROM	CT_Nation
WHERE	((CTNAT_Desc=:lookDefaultNationDR)
OR	    (CTNAT_Desc [:lookDefaultNationDR) OR (:lookDefaultNationDR is null))
AND ((CTNAT_StartDate IS NULL) OR (CTNAT_StartDate <= CURRENT_DATE))
	AND ((CTNAT_EndDate IS NULL) OR (CTNAT_EndDate >= CURRENT_DATE))
	AND (CTNAT_Activity="Y")
}

Storage Default
{
<Data name="CTNationNewDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.CTNationNewD</DataLocation>
<DefaultData>CTNationNewDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.CTNationNewD</IdLocation>
<IndexLocation>^web.CTNationNewI</IndexLocation>
<StreamLocation>^web.CTNationNewS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
