Class epr.Palm Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod FindApptsForUserClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindApptsForUserFetch ]
{
}

ClassMethod FindApptsForUserExecute(ByRef QHandle As %Library.Binary, UserId As %Library.String = "", ApptDays As %Library.String = "", LocId As %Library.String = "") As %Library.Status
{
}

ClassMethod FindApptsForUserFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindApptsForUserExecute ]
{
}

ClassMethod FindObservationItemsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindObservationItemsFetch ]
{
}

ClassMethod FindObservationItemsExecute(ByRef QHandle As %Library.Binary, WardRowId As %Library.String = "") As %Library.Status
{
}

ClassMethod FindObservationItemsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindObservationItemsExecute ]
{
}

ClassMethod FindOrderExecStatusClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindOrderExecStatusFetch ]
{
}

ClassMethod FindOrderExecStatusExecute(ByRef QHandle As %Library.Binary) As %Library.Status
{
}

ClassMethod FindOrderExecStatusFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindOrderExecStatusExecute ]
{
}

ClassMethod FindOrdersForApptsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindOrdersForApptsFetch ]
{
}

ClassMethod FindOrdersForApptsExecute(ByRef QHandle As %Library.Binary, UserId As %Library.String = "", DayCounter As %Library.String = "", LocId As %Library.String = "") As %Library.Status
{
}

ClassMethod FindOrdersForApptsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindOrdersForApptsExecute ]
{
}

ClassMethod FindOrdersForWardClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindOrdersForWardFetch ]
{
}

ClassMethod FindOrdersForWardExecute(ByRef QHandle As %Library.Binary, WardRowId As %Library.String, RoomRowIds As %Library.String) As %Library.Status
{
}

ClassMethod FindOrdersForWardFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindOrdersForWardExecute ]
{
}

ClassMethod FindPatExtraForApptsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindPatExtraForApptsFetch ]
{
}

ClassMethod FindPatExtraForApptsExecute(ByRef QHandle As %Library.Binary, UserId As %Library.String = "", DayCounter As %Library.String = "", LocId As %Library.String = "") As %Library.Status
{
}

ClassMethod FindPatExtraForApptsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindPatExtraForApptsExecute ]
{
}

ClassMethod FindPatExtraForWardClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindPatExtraForWardFetch ]
{
}

ClassMethod FindPatExtraForWardExecute(ByRef QHandle As %Library.Binary, WardRowId As %Library.String = "", RoomRowIds As %Library.String = "") As %Library.Status
{
}

ClassMethod FindPatExtraForWardFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindPatExtraForWardExecute ]
{
}

ClassMethod FindPatientForApptsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindPatientForApptsFetch ]
{
}

ClassMethod FindPatientForApptsExecute(ByRef QHandle As %Library.Binary, UserId As %Library.String = "", DayCounter As %Library.String = "", LocId As %Library.String = "", ClinNotesDayCounter As %Library.String = "") As %Library.Status
{
}

ClassMethod FindPatientForApptsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindPatientForApptsExecute ]
{
}

ClassMethod FindPatientForWardClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindPatientForWardFetch ]
{
}

ClassMethod FindPatientForWardExecute(ByRef QHandle As %Library.Binary, WardRowId As %Library.String = "", RoomRowIds As %Library.String = "", ClinNotesDayCounter As %Library.String = "") As %Library.Status
{
}

ClassMethod FindPatientForWardFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindPatientForWardExecute ]
{
}

ClassMethod FindQuestionnaireItemsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindQuestionnaireItemsFetch ]
{
}

ClassMethod FindQuestionnaireItemsExecute(ByRef QHandle As %Library.Binary) As %Library.Status
{
}

ClassMethod FindQuestionnaireItemsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindQuestionnaireItemsExecute ]
{
}

ClassMethod FindRoomsByWardClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindRoomsByWardFetch ]
{
}

ClassMethod FindRoomsByWardExecute(ByRef QHandle As %Library.Binary, WardRowId As %Library.String = "") As %Library.Status
{
}

ClassMethod FindRoomsByWardFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindRoomsByWardExecute ]
{
}

ClassMethod FindTranslationsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindTranslationsFetch ]
{
}

ClassMethod FindTranslationsExecute(ByRef QHandle As %Library.Binary, userid As %Library.String = "") As %Library.Status
{
}

ClassMethod FindTranslationsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindTranslationsExecute ]
{
}

ClassMethod GetAllWards(LocType As %Library.String = "") As %Library.String
{
}

/// returns location locid_"^"_loctype
ClassMethod GetCTLoc(val As %Library.String = "") As %Library.String
{
}

ClassMethod GetCTUOMIdFromCode(UOMCode As %Library.String = "") As %Library.String
{
}

ClassMethod GetFileName(type As %Library.String) As %Library.String
{
}

ClassMethod GetPACWardId(val As %Library.String = "") As %Library.String
{
}

ClassMethod GetUserCareProvider(UserID As %Library.String) As %Library.String
{
}

ClassMethod IsFileExtensionExists(ext As %Library.String = "", type As %Library.String = "") As %Library.String
{
}

ClassMethod IsValidUser(username As %String = "", password As %String = "") As %String
{
}

ClassMethod palmDeductExecutedfromStock(Barcode As %Library.String, OrderExecRowId As %Library.String) As %Library.String
{
}

ClassMethod palmSaveApptArrive(sApptID As %Library.String = "", sStartDate As %Library.String = "", sStartTime As %Library.String = "", sEndDate As %Library.String = "", sEndTime As %Library.String = "", sUserID As %Library.String = "") As %Library.String
{
}

ClassMethod palmSaveObservations(AdmRowID As %Library.String = "", ObsRowDR As %Library.String = "", Result As %Library.String = "", Comment As %Library.String = "", Date As %Library.String = "", Time As %Library.String = "", User As %Library.String = "", OEExecID As %Library.String = "") As %Library.String
{
}

ClassMethod palmSaveOrdExec(ByRef sOrderExecRowId As %Library.String = "", sOrderRowID As %Library.String = "", sDosage As %Library.String = "", sUOM As %Library.String = "", sFilePath As %Library.String = "", sUserCareProv As %Library.String = "", sExecutedStatus As %Library.String = "", sDateExecuted As %Library.String = "", sTimeExecuted As %Library.String = "", gUserRowID As %Library.String = "", sIsPrimary As %Library.String = "") As %Library.String
{
}

ClassMethod palmSaveQuestionnaires(qid As %Library.String = "", papmiid As %Library.String = "", paadmid As %Library.String = "", oeexecid As %Library.String = "", date As %Library.String = "", timestr As %Library.String = "", userid As %Library.String = "", numval As %Library.String = "", vals As %Library.String = "") As %Library.String
{
}

ClassMethod palmSignatureStore(signature As %Library.String = "", oeexe As %Library.String = "") As %Library.String
{
}

Query FindApptsForUser(UserId As %String, ApptDays As %String, LocId As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID:%String,Buffer:%String,Code:%String")
{
}

Query FindFilePath(ID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%String,PATHPath:%String")
{
SELECT PATH_RowID,PATH_Path
FROM SQLUser.CF_SystemFilePath
WHERE PATH_ParRef=:ID
}

Query FindFilePathByExtension(FileExt As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Path:%Library.String")
{
SELECT PATH_Path
FROM SQLUser.CF_SystemFilePath
WHERE PATH_ParRef->FILE_FileExtension=:FileExt
}

Query FindObservationItems(WardRowId As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID:%String,Buffer:%String,Code:%String")
{
}

Query FindOrderExecStatus() As %Library.Query(CONTAINID = 0, ROWSPEC = "ID:%String,Buffer:%String,Code:%String")
{
}

Query FindOrdersForAppts(UserId As %String, DayCounter As %String, LocId As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID:%String,Buffer:%String,Code:%String")
{
}

Query FindOrdersForWard(WardRowId As %String, RoomRowIds As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID:%String,Buffer:%String,Code:%String")
{
}

Query FindPatExtraForAppts(UserId As %String, DayCounter As %String, LocId As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID:%String,Buffer:%String,Code:%String")
{
}

Query FindPatExtraForWard(WardRowId As %String, RoomRowIds As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID:%String,Buffer:%String,Code:%String")
{
}

Query FindPatientForAppts(UserId As %String, DayCounter As %String, LocId As %Library.String, ClinNotesDayCounter As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID:%String,Buffer:%String,Code:%String")
{
}

Query FindPatientForWard(WardRowId As %String, RoomRowIds As %String, ClinNotesDayCounter As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID:%String,Buffer:%String,Code:%String")
{
}

Query FindQuestionnaireItems() As %Library.Query(CONTAINID = 0, ROWSPEC = "ID:%String,Buffer:%String,Code:%String")
{
}

Query FindRoomsByWard(WardRowId As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID:%String,PACRMCode:%String,Code:%String")
{
}

Query FindTranslations(userid As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID:%String,Buffer:%String,Code:%String")
{
}

Query Edit(ID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,ARRCPDiscAmt:%Float,ARCDIDesc:%String,ARRCPDiscRate:%Float,ARRCPRemarks:%List")
{
 SELECT ARRCP_RowID, ARRCP_DiscAmt, ARRCP_Discount_DR->ARCDI_Desc, ARRCP_DiscRate, ARRCP_Remarks
 FROM SQLUser.AR_Receipts
 WHERE ARRCP_RowID = :ID
}

}
