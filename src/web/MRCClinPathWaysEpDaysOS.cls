Class web.MRCClinPathWaysEpDaysOS Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1006;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "OS_RowId";

Parameter SQLDESCRIPTION = "OS_RowId";

Parameter SQLROWID = "OS_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

/// Method to change the status of order item to "D- Discontinued"
ClassMethod ChangeOrderStatus(OEORIROWID As %Library.String)
{
}

/// log 57856 TedT discontinue intervention and appointments
ClassMethod DiscontinueOrdersAndAppt(oeitm)
{
}

/// log 57856 TedT
ClassMethod GetLinkedOrders(oeitm As %String) As %String
{
}

/// log 57856 TedT
Query FindLinkedOrders(oeitm As %String = "") As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "orderid:%String")
{
Select OEORI_RowId From SQLUser.OE_ORDItem
WHERE OEORI_LinkToOrder=:oeitm OR OEORI_OEORI_DR=:oeitm
}

ClassMethod GetDaysNumberByStepPathID(StepPathString As %Library.String, OEORIROWID As %Library.String)
{
}

ClassMethod FindCPWItemsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindCPWItemsFetch ]
{
}

ClassMethod FindCPWItemsExecute(ByRef QHandle As %Library.Binary, PatientID As %Library.String = "", EpisodeID As %Library.String = "", mradm As %Library.String = "", StepPathIds As %Library.String = "") As %Library.Status
{
}

ClassMethod FindCPWItemsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindCPWItemsExecute ]
{
}

ClassMethod FindOSItemsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindOSItemsFetch ]
{
}

/// PatientID,EpisodeID,mradm is only there to pass on for paging
ClassMethod FindOSItemsExecute(ByRef QHandle As %Library.Binary, PathwayID As %Library.String, PathEpID As %Library.String, StepID As %Library.String, PatientID As %Library.String = "", EpisodeID As %Library.String = "", mradm As %Library.String = "") As %Library.Status
{
}

ClassMethod FindOSItemsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindOSItemsExecute ]
{
}

ClassMethod InsertGoalDate(CPWROWID As %Library.String = "")
{
}

ClassMethod GetItemLoc(OrdID As %String) As %String
{
}

ClassMethod websysInsertStep(mradm As %Library.String, PathwayId As %Library.String, PathEpID As %Library.String, StepID As %Library.String, ByRef CPWRowId As %Library.String, CPWNurseAction As %Library.String = "")
{
}

ClassMethod websysSaveItems(compref As %Library.String, id As %Library.String)
{
}

ClassMethod websysSaveStep(compref As %Library.String, id As %Library.String, mradm As %Library.String)
{
}

/// PatientID,EpisodeID,mradm is only there to pass on for paging
Query FindCPWItems(PatientID As %String, EpisodeID As %String, mradm As %String, StepPathIds As %String) As %Query(CONTAINID = 0, ROWSPEC = "ItemRowid:%String,OrderTypeCode:%String,itmCatid:%String,desc:%String,setid:%String,OSParRef:%String,itmLinked:%String,SetDefDetails:%String,PathwayDesc:%String,DAYSDesc:%String,DAYSParRef:%String,CPWRowId:%String,CPWGoalText:%String,OEORIROWID:%String,itemLoc:%String,OrdType:%String")
{
}

/// log 61602 TedT added OEORI_ItmMast_DR and rec dep dr
Query FindFreeGoalItems(CPWRowId As %String = "") As %SQLQuery(CONTAINID = 0, ROWSPEC = "ItemRowid1:%Library.String,desc1:%Library.String,ItemMastID:%Library.String,RecDep:%Library.String")
{
 SELECT	OEORI_RowId,OEORI_ItmMast_DR->ARCIM_Desc,OEORI_ItmMast_DR,OEORI_RecDep_DR
 FROM	SQLUser.OE_OrdItem
 WHERE	OEORI_ClinPathways_DR=:CPWRowId
}

/// PatientID,EpisodeID,mradm is only there to pass on for paging
Query FindOSItems(PathwayID As %String, PathEpID As %String, StepID As %String, PatientID, EpisodeID, mradm) As %Query(CONTAINID = 0, ROWSPEC = "ItemRowid:%String,OrderTypeCode:%String,itmCatid:%String,OEMessage:%String,RangeFrom:%String,RangeTo:%String,UOM:%String,defdur:%String,desc:%String,setid:%String,OSParRef:%String,itmLinked:%String,SetDefDetails:%String,PathwayDesc:%String,DAYSDesc:%String,DAYSParRef:%String,OrdType:%String")
{
}

Query FindPathwayDescFromID(PathwayID As %Library.String, PathEpID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "PathwayDesc:%String")
{
SELECT  OS_ParRef->DAYS_ParRef->EP_ParRef->CPW_Desc
FROM SQLUser.MRC_ClinPathWaysEpDaysOS
WHERE (OS_OrdSet_DR IS NOT NULL) 
AND ((OS_ParRef->DAYS_ParRef =:PathEpID) OR (:PathEpID IS NULL))
AND (OS_ParRef->DAYS_ParRef->EP_ParRef =:PathwayID)
}

Query FindSetsByStepsID(StepID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "OSRowID:%Library.String,OSOrdSetID:%Library.String,ARCOSDesc:%String")
{
SELECT OS_RowId, OS_OrdSet_DR, OS_OrdSet_DR->ARCOS_Desc
FROM SQLUser.MRC_ClinPathWaysEpDaysOS
WHERE (OS_ParRef = :StepID) AND (OS_OrdSet_DR IS NOT NULL)
ORDER BY OS_RowId
}

}
