Class web.DTCDietCycle Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 794;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CYCLE_RowId";

Parameter SQLDESCRIPTION = "CYCLE_RowId";

Parameter SQLROWID = "CYCLE_RowId";

Property Dummy As %Library.String(TRUNCATE = 1);

ClassMethod FindDietTypeListClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindDietTypeListFetch ]
{
}

ClassMethod FindDietTypeListExecute(ByRef QHandle As %Library.Binary, DietType As %Library.String = "", InActiveDiet As %Library.String = "") As %Library.Status
{
}

ClassMethod FindDietTypeListFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindDietTypeListExecute ]
{
}

ClassMethod GenerateDietType(compref As %String)
{
}

ClassMethod UpdateDietMealOS(compref As %String)
{
}

ClassMethod UpdateDietDay(compref As %String)
{
}

ClassMethod UpdateDietCycle(compref As %String)
{
}

ClassMethod UpdateDietType(compref As %String)
{
}

ClassMethod EditDietTypeStruct(compref As %String)
{
}

ClassMethod ReturnDietTypeMealsForDay(Date As %String, DietTypeID As %String, MealType As %String)
{
}

ClassMethod FindDietCycleItemsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindDietCycleItemsFetch ]
{
}

ClassMethod FindDietCycleItemsExecute(ByRef QHandle As %Library.Binary, DOWDay As %Library.String, MEALTCode As %Library.String, ARCOSRowID As %Library.String = "", CycleNumber As %Library.String = "") As %Library.Status
{
}

ClassMethod FindDietCycleItemsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindDietCycleItemsExecute ]
{
}

ClassMethod CheckEpisDateRange(EpisodeID As %String = "", StartDate As %String = "", StartTime As %String = "") As %String
{
}

Query FindDietCycleItems(DOWDay As %String, MEALTCode As %String, ARCOSRowID As %String, CycleNumber As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "Number:%String,ARCIMRowId:%String,ARCIMDesc:%String,CycleRowID:%String")
{
}

Query FindDietCycles(SearchDOW As %Library.String, SearchCycleNum As %Library.Integer, SearchMeal As %Library.String, SearchARCOS As %Library.String, SearchARCIM As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "CYCLERowID:%String,DOW_Name:%String,CYCLE_CycleNumber:%String,MEALTDesc:%String,ARCIM_Desc:%String,ARCOS_Desc:%String")
{
SELECT  CYCLE_RowID, CYCLE_DOW_DR->DOW_Name, CYCLE_CycleNumber, CYCLE_MealType_DR->Mealt_Desc, CYCLE_ARCIM_DR->ARCIM_Desc, CYCLE_ARCOS_DR->ARCOS_Desc
FROM SQLUser.DTC_DietCycle, SQLUser.ARC_ItmMast, SQLUser.ARC_OrdSets, SQLUser.CT_DayOfWeek, SQLUser.DTC_MealType
WHERE SQLUser.DTC_DietCycle.CYCLE_DOW_DR =* SQLUser.CT_DayOfWeek.DOW_RowId
AND SQLUser.DTC_DietCycle.CYCLE_MealType_DR =* SQLUser.DTC_MealType.MEALT_RowId
AND SQLUser.DTC_DietCycle.CYCLE_ARCIM_DR =* SQLUser.ARC_ItmMast.ARCIM_RowId
AND SQLUser.DTC_DietCycle.CYCLE_ARCOS_DR =* SQLUser.ARC_OrdSets.ARCOS_RowId
 AND	((DOW_Name = :SearchDOW) OR (:SearchDOW IS NULL))
 AND	((CYCLE_CycleNumber = :SearchCycleNum) OR (:SearchCycleNum IS NULL))
 AND	((MEALT_Desc = :SearchMeal) OR (:SearchMeal IS NULL))
 AND	((ARCOS_Desc = :SearchARCOS) OR (:SearchARCOS IS NULL))
 AND	((ARCIM_Desc = :SearchARCIM) OR (:SearchARCIM IS NULL))
}

Query FindDietOrderSets(DOWDay As %String, MEALTCode As %String, ARCOSRowID As %String, CycleNumber As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "CYCLERowID,CycleNumber,ARCOSDR")
{
SELECT CYCLE_RowID,CYCLE_CycleNumber,CYCLE_ARCOS_DR->ARCOS_RowId
FROM SQLUser.DTC_DietCycle
WHERE (CYCLE_DOW_DR->DOW_Day=:DOWDay)
AND (CYCLE_MealType_DR->MEALT_Code=:MEALTCode)
AND ((CYCLE_ARCOS_DR->ARCOS_RowId=:ARCOSRowID)or (:ARCOSRowID IS NULL))
AND ((CYCLE_CycleNumber=:CycleNumber)OR (:CycleNumber IS NULL))
}

Query FindDietTypeList(DietType As %String, InActiveDiet As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,Desc,CycleDesc,DayDesc,MealDesc,CycleSttDate,HidID,HidCycleDesc,HidDayDesc,DietCode,CycleCode,DayCode,MealCode,DateFrom,Active,Location,Hospital")
{
}

Query FindDietType(DietType As %String, InActiveDiet As %String, LocationID As %String, HospitalID As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "DietID,DietDesc,DietDateFrom,DietCycleSttDate")
{
SELECT 	ID,Description,DateFrom,FirstCycleSttDate
FROM 	epr.CTDietType
WHERE 	((:DietType IS NULL) OR (Description=:DietType))
AND 	((DateFrom <= Current_Date) OR (DateFrom IS NULL))
AND		((:InActiveDiet='on' AND Active NOT='Y') OR (:InActiveDiet IS NULL AND Active ='Y'))
AND 	((CTLocDR=:LocationID) OR (:LocationID IS NULL))
AND		((CTHospDR=:HospitalID) OR (:HospitalID IS NULL))
}

Query FindDietTypeLookUp(DietType As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "Description,Code,HIDDEN")
{
SELECT Description,Code,ID
FROM epr.CTDietType
WHERE ((:DietType IS NULL) OR (%ALPHAUP Description %STARTSWITH %ALPHAUP :DietType) OR (%ALPHAUP Code = %ALPHAUP :DietType))
AND ((DateFrom <= Current_Date) OR (DateFrom IS NULL))
}

ClassMethod FindDietTypeLookUpBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", DietType As %Library.String = "") As %Library.Boolean
{
}

Query FindDietTypeListTree(DietType As %String, InActiveDiet As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,Desc,CycleDesc,CycleSttDate,HidID,HidCycleDesc,DietCode,CycleCode,DateFrom,Active,Location,Hospital")
{
}

ClassMethod FindDietTypeListTreeClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindDietTypeListTreeFetch ]
{
}

ClassMethod FindDietTypeListTreeExecute(ByRef QHandle As %Library.Binary, DietType As %Library.String = "", InActiveDiet As %Library.String = "") As %Library.Status
{
}

ClassMethod FindDietTypeListTreeFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindDietTypeListTreeExecute ]
{
}

Query FindDietDayListTree(ID As %String, CycleCode As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "DayDesc,DayCode,ID,CycleCode")
{
}

ClassMethod FindDietDayListTreeClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindDietDayListTreeFetch ]
{
}

ClassMethod FindDietDayListTreeExecute(ByRef QHandle As %Library.Binary, ID As %Library.String = "", CycleCode As %Library.String = "") As %Library.Status
{
}

ClassMethod FindDietDayListTreeFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindDietDayListTreeExecute ]
{
}

Query FindDietMealListTree(ID As %String, CycleCode As %String, DayCode As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "MealDesc,MealCode,DayCode,ID,CycleCode,CycleDesc,DayDesc,OrderSetsFound")
{
}

ClassMethod FindDietMealListTreeClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindDietMealListTreeFetch ]
{
}

ClassMethod FindDietMealListTreeExecute(ByRef QHandle As %Library.Binary, ID As %Library.String = "", CycleCode As %Library.String = "", DayCode As %Library.String = "") As %Library.Status
{
}

ClassMethod FindDietMealListTreeFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindDietMealListTreeExecute ]
{
}

ClassMethod SaveOSItemsForDay(compref As %String)
{
}

Query ShowMealOSForDay(Date As %String, MealTypeID As %String, ORDERSETID As %String) As %Library.Query(CONTAINID = 1, ROWSPEC = "desc,ItemRowid,Quantity")
{
}

ClassMethod ShowMealOSForDayClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = ShowMealOSForDayFetch ]
{
}

ClassMethod ShowMealOSForDayExecute(ByRef QHandle As %Library.Binary, Date As %Library.String = "", MealTypeID As %Library.String = "", ORDERSETID As %Library.String = "") As %Library.Status
{
}

ClassMethod ShowMealOSForDayFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = ShowMealOSForDayExecute ]
{
}

ClassMethod UpdateMealOrder(compref As %String)
{
}

ClassMethod GetNutritionalInfo(id As %String)
{
}

}
