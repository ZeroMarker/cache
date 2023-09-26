Class web.BBAntibodyRegister Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod AntibodyResultClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = AntibodyResultFetch ]
{
}

ClassMethod AntibodyResultExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String) As %Library.Status
{
}

ClassMethod AntibodyResultFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = AntibodyResultExecute ]
{
}

Query AntibodyResult(PatientID As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ANTRGRowId:%Library.String,ANTRGEpisodeDR:%Library.String,ANTRGTestSetDR:%Library.String,CTTSName:%Library.String,ANTRGDataItemDR:%Library.String,CTTCDesc:%Library.String,ANTRGResult:%Library.String,ANTRGDate:%Library.String,ANTRGTime:%Library.String,ANTRGUserDR:%Library.String,ANTRGVisitTestDR:%Library.String")
{
SELECT 
FROM BBAntibodyRegister
}

}
