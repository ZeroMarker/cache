Include webimport

IncludeGenerator webimport

Class web.DHCeprWorklistItemDefinitionList Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query eprWorklistItemDefinitionList(Description, Name, Url, Component) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,WITName:%String,WITDesc:%String,WITUrl:%String,Component:%String")
{
SELECT ID,WITName,WITDesc,WITUrl,WITComponentDR->Name Component
FROM epr.CTWorklistItemDef
WHERE ((WITDesc %STARTSWITH :Description) or (:Description IS NULL))
AND ((WITName %STARTSWITH :Name) or (:Name IS NULL))
AND ((WITUrl %STARTSWITH :Url) or (:Url IS NULL))
AND ((WITComponentDR->Name %STARTSWITH :Component) or (:Component IS NULL))
}

}
