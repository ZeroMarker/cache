Include webimport

IncludeGenerator webimport

Class web.CTCountryNew Extends %Persistent
{

Query LookUp(desc As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,ID:%String")
{
SELECT	CTCOU_Desc,CTCOU_RowId
FROM	CT_Country
WHERE	((CTCOU_Desc=:desc)
OR	    (CTCOU_Desc [:desc) OR (:desc is null))
AND ((CTCOU_DateActiveFrom IS NULL) OR (CTCOU_DateActiveFrom <= CURRENT_DATE))
	AND ((CTCOU_DateActiveTo IS NULL) OR (CTCOU_DateActiveTo >= CURRENT_DATE))
	AND (CTCOU_Active ="Y")
}

Storage Default
{
<Data name="CTCountryNewDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.CTCountryNewD</DataLocation>
<DefaultData>CTCountryNewDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.CTCountryNewD</IdLocation>
<IndexLocation>^web.CTCountryNewI</IndexLocation>
<StreamLocation>^web.CTCountryNewS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
