/// For Order Entry Diet Orders
Class web.DTCMealType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 258;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "MEALT_Code";

Parameter SQLDESCRIPTION = "MEALT_Desc";

Parameter SQLROWID = "MEALT_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetAllMealInfo()
{
}

ClassMethod GetDischargeDate(EpisodeID As %Library.String = "") As %Library.String
{
}

ClassMethod GetMeals(MealType As %Library.String = "", allmeals As %Library.String = "") As %Library.String
{
}

ClassMethod GetNextMeal() As %Library.String
{
}

/// This is for OEOrder.Diet and is used ot generate a list of meals available for selectoin based upon start meal, end meal and current time
ClassMethod GetStartEndDateMeals(StartMeal As %Library.String = "", EndMeal As %Library.String = "", StartDate As %Library.Date = "", EndDate As %Library.Date = "") As %Library.String
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerMealBulkTimes(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerMealTypeTimes(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

/// Called by the web broker.
/// The main purpose is to convert from code to description dynamically.
/// itmjs - javascript function e.g. Location_lookupsel
/// itmjsex - extended javascript function
ClassMethod LookUpBrokerAllMealTypeTimes(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "") As %Library.Boolean
{
}

ClassMethod MealTypeLookUpClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = MealTypeLookUpFetch ]
{
}

ClassMethod MealTypeLookUpExecute(ByRef QHandle As %Library.Binary, Linking As %Library.String = "", DietPage As %Library.String = "") As %Library.Status
{
}

ClassMethod MealTypeLookUpFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = MealTypeLookUpExecute ]
{
}

Query FindAllMealTypeTime() As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "MEALTTime:%String,MEALTDesc:%String")
{
SELECT MEALT_CutOffTime, MEALT_Desc
FROM SQLUser.DTC_MealType
ORDER BY MEALT_CutOffTime
}

Query FindAllMeals(StartMealTime As %Library.String, EndMealTime As %Library.String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "MEALTDesc:%String,HIDDEN:%String")
{
SELECT MEALT_Desc, MEALT_RowId
FROM SQLUser.DTC_MealType
WHERE ((MEALT_Time>= :StartMealTime) OR (:StartMealTime IS NULL)) AND ((MEALT_Time<=:EndMealTime) OR (:EndMealTime IS NULL)) AND (MEALT_MainMeal= 'Y')
ORDER BY MEALT_Time
}

Query FindDischargeDate(EpisodeID As %Library.String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "EndDate:%String")
{
SELECT PAADM_EstimDischargeDate
FROM SQLUser.PA_Adm
WHERE (PAADM_RowID= :EpisodeID)
}

Query FindMealTypeByTime() As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "MEALTDesc:%String,HIDDEN:%String")
{
SELECT MEALT_Desc, MEALT_Time
FROM SQLUser.DTC_MealType
WHERE MEALT_Time>= CURRENT_TIME
}

Query FindMealTypeTime() As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "MEALTTime:%String,MEALTDesc:%String")
{
SELECT MEALT_CutOffTime, MEALT_Desc
FROM SQLUser.DTC_MealType
WHERE (MEALT_MainMeal= 'Y')
ORDER BY MEALT_CutOffTime
}

Query FindMealTypeTimeBulk() As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "MEALTTime:%String,MEALTDesc:%String")
{
SELECT MEALT_CutOffBulkTime, MEALT_Desc
FROM SQLUser.DTC_MealType
ORDER BY MEALT_CutOffBulkTime
}

Query FindMeals(StartMealTime As %Library.String, EndMealTime As %Library.String, CurTime As %Library.Time) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "MEALTDesc:%String,HIDDEN:%String")
{
SELECT MEALT_Desc, MEALT_RowId
FROM SQLUser.DTC_MealType
WHERE ((MEALT_Time>= :StartMealTime) OR (:StartMealTime IS NULL)) AND ((MEALT_Time<=:EndMealTime) OR (:EndMealTime IS NULL)) AND ((MEALT_CUTOFFTIME >= :CurTime) OR (:CurTime IS NULL)) AND (MEALT_MainMeal= 'Y')
ORDER BY MEALT_Time
}

/// Used to gather meals between a start and end meal taking into account current time
Query FindMealsByTime(StartMeal As %Library.String = "", EndMeal As %Library.String = "", StartDate As %Library.Date = "") As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "MEALTDesc:%String,HIDDEN:%String")
{
SELECT MEALT_Desc, MEALT_RowId
FROM SQLUser.DTC_MealType
WHERE ((MEALT_Time>= (select MEALT_Time FROM SQLUser.DTC_MealType where MEALT_Desc = :StartMeal))
 OR (:StartMeal IS NULL)) 
AND ((MEALT_Time<=(select MEALT_Time FROM SQLUser.DTC_MealType where MEALT_Desc = :EndMeal)) OR (:EndMeal IS NULL)) 
AND ((MEALT_CUTOFFTIME >= CURRENT_TIME) OR (:StartDate > CURRENT_DATE))
ORDER BY MEALT_Time
}

Query FindMealsByTimeWithoutCutoff(StartMeal As %Library.String = "", EndMeal As %Library.String = "") As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "MEALTDesc:%String,HIDDEN:%String")
{
SELECT MEALT_Desc, MEALT_RowId
FROM SQLUser.DTC_MealType
WHERE ((MEALT_Time>= (select MEALT_Time FROM SQLUser.DTC_MealType where MEALT_Desc = :StartMeal))
 OR (:StartMeal IS NULL)) 
AND ((MEALT_Time<=(select MEALT_Time FROM SQLUser.DTC_MealType where MEALT_Desc = :EndMeal)) OR (:EndMeal IS NULL)) 
ORDER BY MEALT_Time
}

Query FindNextMeals(StartMealTime As %Library.String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "MEALTDesc:%String,MEALT_Time:%String,MEALT_CutOffTime:%String")
{
SELECT MEALT_Desc, MEALT_Time, MEALT_CutOffTime
FROM SQLUser.DTC_MealType
WHERE (MEALT_CutOffTime>= :StartMealTime) AND (MEALT_MainMeal='Y')
ORDER BY MEALT_CutOffTime
}

Query LookUpMealBulkTimes(MealTypeDesc As %Library.String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "MEALDesc:%String,MEALCode:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
SELECT MEALT_Desc, MEALT_Code, MEALT_Time, MEALT_RowId, MEALT_CutOffBulkTime
FROM SQLUser.DTC_MealType
WHERE ((MEALT_Desc %STARTSWITH :MealTypeDesc) OR (MEALT_Code = :MealTypeDesc))
ORDER BY MEALT_CutOffBulkTime
}

Query LookUpMealType2() As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "MealRowId:%String,MEALTDesc:%String")
{
SELECT MEALT_RowId, MEALT_Desc
FROM SQLUser.DTC_MealType
}

Query LookUpMealTypeTimes(MealTypeDesc As %Library.String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "MEALDesc:%String,MEALCode:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{

SELECT MEALT_Desc, MEALT_Code, MEALT_Time, MEALT_RowId, MEALT_CutOffTime, MEALT_MainMeal
FROM SQLUser.DTC_MealType
WHERE (
     (MEALT_Desc %STARTSWITH :MealTypeDesc)
     and 
     (MEALT_MainMeal='Y')
 )
ORDER BY MEALT_Time
}

/// All meals sorted by time
Query LookUpAllMealTypeTimes(MealTypeDesc As %Library.String) As %Library.SQLQuery(CONTAINID = "", ROWSPEC = "MEALDesc:%String,MEALCode:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,Main Meal:%String")
{

SELECT MEALT_Desc, MEALT_Code, MEALT_Time, MEALT_RowId, MEALT_CutOffTime, MEALT_MainMeal
FROM SQLUser.DTC_MealType
WHERE (
     (MEALT_Desc %STARTSWITH :MealTypeDesc)
 )
ORDER BY MEALT_Time
}

Query MealTypeLookUp(Link) As %Library.Query(CONTAINID = "", ROWSPEC = "Time,MealType")
{
}

ClassMethod websysSaveMeals(compref As %Library.String, id As %Library.String)
{
}

ClassMethod SetInsertVars(compref As %Library.String, id As %Library.String, OrderedRowIDs As %Library.String = "")
{
}

}
