Include webimport

IncludeGenerator webimport

Class web.SSUserSettings Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 105;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

/// retired - use GetParam, SetParam instead
ClassMethod EditSave(usr As %String, appCode As %String, key As %String, value As %String)
{
}

/// Preferred course of action is to use webSSAppSettings instead !
ClassMethod GetParam(userid As %String, app As %String, key As %String) As %String
{
}

/// Preferred course of action is to use webSSAppSettings instead !
ClassMethod SetParam(userid As %String, app As %String, key As %String, value As %String)
{
}

Parameter SQLCODE = "SET_AppCode";

Parameter SQLDESCRIPTION = "SET_RowId";

Parameter SQLROWID = "SET_RowId";

Query Find(usr As %String, appcode As %String, key As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,SETParRef:%String,SETAppCode:%String,SETKey:%String,SETParameter:%String")
{
SELECT SET_RowID, SET_ParRef, SET_AppCode, SET_Key, SET_Parameter
FROM SQLUser.SS_UserSettings
WHERE (SET_ParRef = :usr) AND (SET_AppCode = :appcode) AND (SET_Key = :key)
}

}
