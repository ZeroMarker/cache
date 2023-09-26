Class web.PAPersonSurnameAlias Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 444;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "SUR_RowId";

Parameter SQLDESCRIPTION = "SUR_RowId";

Parameter SQLROWID = "SUR_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Default implementation of LookUp Query.
ClassMethod FindAllAliasClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindAllAliasFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindAllAliasExecute(ByRef QHandle As %Library.Binary, TSRTITM As %Library.String, TSRTORD As %Library.String, PARREF As %Library.String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindAllAliasFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindAllAliasExecute ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindIncludeCurrSurnameClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindIncludeCurrSurnameFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindIncludeCurrSurnameExecute(ByRef QHandle As %Library.Binary, PARREF As %String) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod FindIncludeCurrSurnameFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindIncludeCurrSurnameExecute ]
{
}

/// checks if that the name passed in is already an alias. If id is passed, ignores that record... 
/// doesn't count as a duplicate so you can update the active/inactive field for that record.
/// Called in websysBeforeSave
ClassMethod IsDuplicate(PatientID As %Library.String, name As %Library.String = "", id As %Library.String = "") As %Library.Boolean
{
}

/// 
/// 	;
/// 	;&SQL(	
/// 	;	DECLARE SurnameAliasFind CURSOR FOR
/// 	;	SELECT SUR_RowID
/// 	;	FROM SQLUser.PA_PersonSurnameAlias
/// 	;	WHERE SUR_ParRef=:FROMPatientID
/// 	;)
/// 	;&SQL(OPEN SurnameAliasFind)
/// 	;
/// 	;nextSurnameAlias
/// 	;
/// 	;&SQL(FETCH SurnameAliasFind INTO :tempID)
/// 	;i SQLCODE {
/// 	;	&SQL(CLOSE SurnameAliasFind)
/// 	;	q
/// 	;}
/// 	
/// 	;i TOSurAliasObj,FROMSurAliasObj {
/// 	;	d TOSurAliasObj.SURParRefSetObjectId(TOPatientID)
/// 	;	s TOSurAliasObj.SURPatientFromID=FROMPatientID
/// 	;	i FROMSurAliasObj.SURUserDR d TOSurAliasObj.SURUserDRSetObjectId(FROMSurAliasObj.SURUserDR.%Id())
/// 	;	i FROMSurAliasObj.SURActive'="" s TOSurAliasObj.SURActive=FROMSurAliasObj.SURActive
/// 	;	i FROMSurAliasObj.SURDate'="" s TOSurAliasObj.SURDate=FROMSurAliasObj.SURDate
/// 	;	i FROMSurAliasObj.SURDob'="" s TOSurAliasObj.SURDob=FROMSurAliasObj.SURDob
/// 	;	i FROMSurAliasObj.SURName'="" s TOSurAliasObj.SURName=FROMSurAliasObj.SURName
/// 	;	i FROMSurAliasObj.SURName2'="" s TOSurAliasObj.SURName2=FROMSurAliasObj.SURName2
/// 	;	i FROMSurAliasObj.SURName3'="" s TOSurAliasObj.SURName3=FROMSurAliasObj.SURName3
/// 	;	i FROMSurAliasObj.SURTime'="" s TOSurAliasObj.SURTime=FROMSurAliasObj.SURTime
/// 	;	d TOSurAliasObj.%Save()
/// 	;	d TOSurAliasObj.%Close()
/// 	;	d FROMSurAliasObj.%Close()
/// 	;} else  {
/// 	;	g nextSurnameAlias
/// 	;}
/// 
ClassMethod MergeSurnameAliases(TOPatientID As %Library.String, FROMPatientID As %Library.String)
{
}

ClassMethod SetDefault(compref As %Library.String)
{
}

/// KM 20-Sep-2001: Called From component PAPersonSurnameAlias.Edit
ClassMethod setAliasFromDOB(compref As %Library.String, AliasID As %Library.String, PatientID As %Library.String, dob As %Library.String = "", type As %Library.String = "")
{
}

/// KM 20-Sep-2001: Called From component PAPersonSurnameAlias.Edit
ClassMethod setAliasFromName(compref As %Library.String, AliasID As %Library.String, PatientID As %Library.String, name As %Library.String = "", name2 As %Library.String = "", name3 As %Library.String = "", fullname As %Library.String = "")
{
}

/// KM 20-Sep-2001: Called From component PAPersonSurnameAlias.Edit
ClassMethod setAliasFromSex(compref As %Library.String, AliasID As %Library.String, PatientID As %Library.String, sex As %Library.String = "", type As %Library.String = "")
{
}

/// KM 20-Sep-2001: Called From component PAPersonSurnameAlias.Edit
ClassMethod setNameFromAlias(compref As %Library.String)
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

ClassMethod websysDeleteAll(id As %Library.String, table As %Library.String, compref As %String)
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

/// Default save method used for updating the database for Components of type Edit.<br>
/// <br>
/// The compref is the  component reference which is the string from which we can deduce the instance of<BR>
/// websysComponent<BR>
/// websysComponentItem<BR>
/// id is the id for the instance of class we wish to update.
ClassMethod websysSaveAll(compref As %String, id As %String)
{
}

Query FindAllAlias(TSRTITM As %Library.String, TSRTORD As %Library.String, PARREF As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "patientid,type,surname,sex,dob,givenname,othername,active,table,rowid")
{
}

Query FindIncludeCurrSurname(PARREF As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,SURName,SURName2,SURName3,SURActive")
{
}

}
