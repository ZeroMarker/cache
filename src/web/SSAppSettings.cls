Include webimport

IncludeGenerator webimport

Class web.SSAppSettings Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 93;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

ClassMethod LookUpOrdProfilesClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpOrdProfilesFetch ]
{
}

ClassMethod LookUpOrdProfilesExecute(ByRef QHandle As %Library.Binary, SSUSR As %String, SSGRP As %String) As %Library.Status
{
}

ClassMethod LookUpOrdProfilesFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpOrdProfilesExecute ]
{
}

ClassMethod ProfileSave(usrID As %String, profileCode As %String)
{
}

/// Set an application parameter.<br>
/// id is anonymouse and depends on type.<br>
/// e.g. if type is "U" (user) then the id is the id of SSUser<br>
/// if type is "G" (group) then the is is the id of SSGroup.
ClassMethod SetParam(type As %String, id As %String, app As %String, key As %String, value As %String)
{
}

/// Retired - better to use GetParam, SetParam !
ClassMethod getColorHex(oestatus As %String) As %String
{
}

ClassMethod getParams(type As %Library.String, id As %Library.String, app As %Library.String, key As %Library.String) As %Library.String
{
}

/// Retired - better to use GetParam, SetParam - they are more generic
ClassMethod getProfileParameters(id As %String, ByRef PL As %String)
{
}

Parameter SQLCODE = "SET_AppCode";

Parameter SQLDESCRIPTION = "SET_Key";

Parameter SQLROWID = "SET_RowId";

Query Find(type As %String, settingId As %String, appcode As %String, key As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,SETType:%String,SETId:%String,SETAppCode:%String,SETKey:%String,SETParameter:%String")
{
SELECT SET_RowID, SET_Type, SET_Id, SET_AppCode, SET_Key, SET_Parameter
FROM SS_AppSettings
WHERE (SET_Type = :type) AND (SET_Id = :settingId) AND (SET_AppCode = :appcode) AND (SET_Key = :key)
}

Query Find2(id As %String, type As %String, appcode As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,SETKey:%String,SETParameter:%String")
{
SELECT SET_Rowid, SET_Key, SET_Parameter
FROM SS_AppSettings
WHERE (SET_Id = :id) AND (SET_Type = :type) AND (SET_AppCode = :appcode)
}

/// This Query is called from the getProfileparameters method
Query FindByProfile(id As %String) As %SQLQuery(CONTAINID = 0, ROWSPEC = "SETParameter:%String")
{
SELECT SET_Parameter
FROM SS_AppSettings
WHERE (SET_Rowid = :id)
}

Query LookUpOrdProfiles(SSUSR As %String, SSGRP As %String) As %Query(CONTAINID = 0, ROWSPEC = "Profile:%String,HIDDEN:%String,HIDDEN:%String")
{
}

}
