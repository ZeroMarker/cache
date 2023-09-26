Include webimport

IncludeGenerator webimport

Class web.PAPersonAlias Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 244;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ALIAS_RowId";

Parameter SQLDESCRIPTION = "ALIAS_RowId";

Parameter SQLROWID = "ALIAS_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod IsDuplicate(PatientID As %Library.String, name As %Library.String = "", id As %Library.String = "", type As %Library.String = "") As %Library.Boolean
{
}

/// 	;&SQL(	
/// 	;	DECLARE AliasFind CURSOR FOR
/// 	;	SELECT ALIAS_RowID
/// 	;	FROM SQLUser.PA_PersonAlias
/// 	;	WHERE ALIAS_ParRef=:FROMPatientID
/// 	;)
/// 	;&SQL(OPEN AliasFind)
/// 	;
/// 	;nextAlias
/// 	;s (FROMAliasObj, TOAliasObj, temp,tempID,save)=""
/// 	;&SQL(FETCH AliasFind INTO :tempID)
/// 	;i SQLCODE {
/// 	;	&SQL(CLOSE AliasFind)
/// 	;	q
/// 	;}
/// 	;s TOAliasObj=##Class(User.PAPersonAlias).%New(TOPatientID)
/// 	;s FROMAliasObj=##Class(User.PAPersonAlias).%OpenId(tempID,0)
/// 	;i (TOAliasObj),(FROMAliasObj) {
/// 	;	d TOAliasObj.ALIASParRefSetObjectId(TOPatientID)
/// 	;	s TOAliasObj.ALIASPatientFromID=FROMPatientID
/// 	;	i FROMAliasObj.ALIASUserDR d TOAliasObj.ALIASUserDRSetObjectId(FROMAliasObj.ALIASUserDR.%Id())
/// 	;	i FROMAliasObj.ALIASActive'="" s TOAliasObj.ALIASActive=FROMAliasObj.ALIASActive
/// 	;	i FROMAliasObj.ALIASDate'="" s TOAliasObj.ALIASDate=FROMAliasObj.ALIASDate
/// 	;	i FROMAliasObj.ALIASDOB'="" s TOAliasObj.ALIASDOB=FROMAliasObj.ALIASDOB
/// 	;	i FROMAliasObj.ALIASSurname'="" s TOAliasObj.ALIASSurname=FROMAliasObj.ALIASSurname
/// 	;	i FROMAliasObj.ALIASTime'="" s TOAliasObj.ALIASTime=FROMAliasObj.ALIASTime
/// 	;	i FROMAliasObj.ALIASText'="" s TOAliasObj.ALIASText=FROMAliasObj.ALIASText
/// 	;	s save=TOAliasObj.%Save(0)
/// 	;	d TOAliasObj.%Close()
/// 	;	d FROMAliasObj.%Close()
/// 	;	g nextAlias
/// 	;} else  {
/// 	;	g nextAlias
/// 	;}
ClassMethod MergeAliases(TOPatientID As %Library.String, FROMPatientID As %Library.String)
{
}

/// KM 20-Sep-2001: Called From component PAPersonAlias.Edit
ClassMethod setAliasFromName(compref As %Library.String, AliasID As %Library.String, PatientID As %Library.String, name As %Library.String, fullname As %Library.String = "", type As %Library.String = "")
{
}

/// log 62415
ClassMethod setAlias(compref As %Library.String)
{
}

/// KM 20-Sep-2001: Called From component PAPersonAlias.Edit
ClassMethod setNameFromAlias(compref As %Library.String, type As %Library.String = "")
{
}

/// Invoked after websysSave - can be used to provide extra websysSave functionality while keeping the default websysSave behaviour.
ClassMethod websysAfterSave(compref As %String, ByRef id As %String, new As %Boolean) As %Boolean
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSaveA(compref As %String, id As %String)
{
}

}
