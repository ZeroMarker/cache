Include webimport

IncludeGenerator webimport

/// Methods and queries used by other classes
Class web.PAAdm2 Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 6;

Parameter SQLCODE = "PAADM2_RowId";

Parameter SQLDESCRIPTION = "PAADM2_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod GetIdFromCodeOrDescription(number As %Library.String) As %Library.String
{
}

Parameter SQLROWID = "PAADM2_RowId";

ClassMethod GetIdFromDateCodeOrDesc(number As %Library.String, date As %Library.Date = "") As %Library.String
{
}

ClassMethod GetCodeDescriptionFromId(id As %Library.String) As %Library.String
{
}

ClassMethod zzGetDataForQuery(TSRTITM As %Library.String, EpisodeID As %Library.String, PARAMS As %Library.String, ByRef ARY As %Library.String, ByRef sort As %Library.String, ByRef sCount As %Library.Integer) As %Library.Integer
{
}

ClassMethod zzGetModifiersbyEpID(EpisodeID As %Library.String, ByRef OrderName As %Library.String, ByRef Modifiers As %Library.String, ByRef MainMeal1 As %Library.String, ByRef MainMeal2 As %Library.String, ByRef MainMeal3 As %Library.String, dimgList As %Library.String, ddescList As %Library.String)
{
}

Storage Default
{
<Data name="PAAdm2DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>dummy</Value>
</Value>
</Data>
<Data name="PAAdm2State">
<Subscript>"web.PAAdm2"</Subscript>
<Value name="1">
<Value>dummy</Value>
</Value>
</Data>
<DataLocation>^web.PAAdm2D</DataLocation>
<DefaultData>PAAdm2DefaultData</DefaultData>
<IdLocation>^web.PAAdm2D</IdLocation>
<IndexLocation>^web.PAAdm2I</IndexLocation>
<State>PAAdm2State</State>
<StreamLocation>^web.PAAdm2S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
