Include webimport

IncludeGenerator webimport

Class web.MRObservations Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 2003;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "OBS_RowId";

Parameter SQLDESCRIPTION = "OBS_RowId";

Parameter SQLROWID = "OBS_RowId";

Property dummy As %String(TRUNCATE = 1);

/// This returns description,id,code (this is to be consitent with lookups)
/// overwrite generic code as it was not meaningful for this class
/// replace description with: patient registration number plus description of the mrc_observationitem (':' separated)
/// replace the code with: patient rowid plus rowid of the mrc_observationitem ('^' separated)
ClassMethod GetCodeDescriptionFromId(id As %Library.String) As %Library.String
{
}

ClassMethod FindEMRClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindEMRFetch ]
{
}

/// If the order by of the query is changed it will affect obsSummaryGet which is used in the EPR.
/// If changed make sure that still works showing only the most recent result for an hour.
/// Any question see John H or Trung
ClassMethod FindEMRExecute(ByRef QHandle As %Library.Binary, mradm As %Library.String = "", itm As %Library.String = "", stdate As %Library.Date = "", enddate As %Library.Date = "", sttime As %Library.Time = "", endtime As %Library.Time = "") As %Library.Status
{
}

ClassMethod FindEMRFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindEMRExecute ]
{
}

/// If the order by of the query is changed it will affect obsSummaryGet which is used in the EPR.
/// If changed make sure that still works showing only the most recent result for an hour.
/// Any question see John H or Trung
ClassMethod FindItemsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindItemsFetch ]
{
}

/// If the order by of the query is changed it will affect obsSummaryGet which is used in the EPR.
/// If changed make sure that still works showing only the most recent result for an hour.
/// Any question see John H or Trung
ClassMethod FindItemsExecute(ByRef QHandle As %Library.Binary, mradm As %Library.String = "", ObsGrpID As %Library.String = "", oeordexecid As %Library.String = "", ObsDate As %Library.Date = "", ObsTime As %Library.Time = "", ID As %Library.String = "", node As %String = "") As %Library.Status
{
}

/// If the order by of the query is changed it will affect obsSummaryGet which is used in the EPR.
/// If changed make sure that still works showing only the most recent result for an hour.
/// Any question see John H or Trung
ClassMethod FindItemsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindItemsExecute ]
{
}

/// SA 5.4.01:  Implemented for ChartFX graph. This method gets the number of graphable 
/// observation items for a YAxis defined against the observation group for an mradm. 
/// Required because ChartFX needs to know the number of items it's graphing (ie. Series)
/// before query is made. Count is incremented every time a record is retrieved whose 
/// observation item differs from what has been retrieved on the previous "fetch" (noting that
/// this query is sorted by Observation Item). 
ClassMethod GetObsItemGraphCount(MRAdm As %Library.String, ObsGrpID As %Library.String, YAxisNumber As %Library.String, StartDate As %Library.String, EndDate As %Library.String, StartTime As %Library.String, EndTime As %Library.String) As %Library.Integer
{
}

ClassMethod GetValueFromOEOrdExec(mradm As %Library.String, oeordexecid As %Library.String, obsitm As %Library.String, ByRef MRObsAnswerID As %Library.String = "", ByRef Value As %Library.String = "", ByRef ShortDesc As %Library.String = "", ByRef Status As %Library.String = "")
{
}

/// Note : obstime is in hours
ClassMethod GetValueFromObsGrpID(mradm As %Library.String, obsdate As %Library.String, obstime As %Library.String, obsitm As %Library.String, ByRef MRObsAnswerID As %Library.String = "", ByRef Value As %Library.String = "", ByRef ShortDesc As %Library.String = "", ByRef Status As %Library.String = "", node As %String = "")
{
}

ClassMethod TotalFluidProgressive(mradm As %Library.String, ObsGrpID As %Library.String, ByRef input As %Library.String, ByRef output As %Library.String, ByRef balance As %Library.String, currentdate As %Library.String, currenttime As %Library.String, hours As %Library.Numeric = 0)
{
}

ClassMethod TotalFluidSession(mradm As %Library.String, ObsGrpID As %Library.String, ByRef input As %Library.String, ByRef output As %Library.String, ByRef balance As %Library.String, currentdate As %Library.String, currenttime As %Library.String)
{
}

/// Displays a table of editable observations for ChartFX Partogram (MRObservations.ChartFX.EditList)
ClassMethod DisplayChartFXListEdit()
{
}

/// Saves data from table of editable observations for ChartFX Partogram (MRObservations.ChartFX.EditList)
ClassMethod websysSaveChartFXListEdit(compref As %String = "")
{
}

ClassMethod DisplayObservation()
{
}

/// mradm: the MRAdm id
/// Logs 29736,42221 - AI : mradm is no longer used in this function, although it is still passed.
/// ObsGrpIDs: a comma separated list of MRCObservationItem ids
/// minslots:  the number of minutes for each slot
/// stdate: the start date to start retrieving the observations from
/// enddate: the end date for retrieving observations to
/// dtmLIST: => a list to return the dates and times for each slot
/// chLIST: => a list to return the observation values for each slot
/// Log 42221 - AI - 10-02-2004 : Pass studentchart to determine whether to us Main MRADMDR or Student MRADMDR.
ClassMethod obsSummaryGet(mradm As %String = "", ObsGrpIDs As %String = "", minslots As %String = "", stdate As %Library.Date = "", enddate As %Library.Date = "", sttime As %Library.Time = "", endtime As %Library.Time = "", ByRef refLIST As %Library.String = "", ObsGrpID As %Library.String = "", studentchart As %Library.Boolean = 0, EpisodeIDs = "", Start As %Library.String, Columns As %Library.String = 20)
{
}

/// Log 42221 - AI - 10-02-2004 : Pass studentchart to determine whether to us Main MRADMDR or Student MRADMDR.
ClassMethod obsSummaryShow(ByRef refLIST As %Library.String, minslots As %Library.String = 60, PatientID As %Library.String = "", mradm As %Library.String = "", EpisodeID As %Library.String = "", Obsitm As %Library.String, Obsitmparams As %Library.String, ObsGrpID As %Library.String = "", ChartID As %Library.String = "", Context As %Library.String = "", Start As %Library.String, Columns As %Library.String = 20, studentchart As %Library.Boolean = 0, ColumnWidth As %Library.String, EpisodeIDs = "")
{
}

/// ab 1.11.06 55575 - used in Profile Show and obs entry csp
ClassMethod GetNoteData(mr As %String, dt As %String, tm As %String, node As %String, rev As %String, delim As %String = "", exec As %String = "")
{
}

/// Invoked before websysSave - can be used to cancel the save.<br>
ClassMethod websysBeforeSave(compref As %String, ByRef id As %String) As %Boolean
{
}

ClassMethod websysDeleteGroupItems(compref As %Library.String = "")
{
}

ClassMethod websysSaveGroupItems(compref As %Library.String = "")
{
}

/// ab 14.08.06 60513 - moved from SaveGroupItems, also called from SSUserDefinedWindow
ClassMethod SetHeightWeight(mradm, ITMCode, OBSvalue)
{
}

/// ab 12.04.07 62937 - if this item is a fluid input, add or update the session and progressive totals
ClassMethod UpdateFluidTotals(ObsID As %String = "", compref As %String = "")
{
}

ClassMethod ProgressiveTotals(mradm As %String, ByRef objMRObserv As %RegisteredObject, dateexec As %String, timeexec As %String)
{
}

ClassMethod GetObservation(mradm As %Library.String, item As %Library.String, date As %Library.String = "", time As %Library.String = "") As %String
{
}

ClassMethod SetObservation(mradm As %Library.String, item As %Library.String, value As %String, date As %Library.String, time As %Library.String)
{
}

ClassMethod GetEarliestObsDateAndTime(mradm As %Library.String) As %Library.String
{
}

/// KM 14-Feb-2001: This Query is used in the ..obsSummaryGet method()
/// KM 15-Nov-2001: Changed this to be an Execute/Fetch/Close query so that it could be limited to the first 12 observations.
Query FindEMR(mradm As %Library.String, itm As %Library.String, stdate As %Library.Date, enddate As %Library.Date, sttime As %Library.Time, endtime As %Library.Time) As %Library.Query(CONTAINID = 1, ROWSPEC = "ID,OBSItem:%String,OBSValue:%String,OBSDate:%Date,OBSTime:%Time,SSUSRName:%String,OBSShortDesc:%Time,ITMInputType:%String,ITMLowRange:%String,ITMHighRange:%String,OBSOEExecDR:%String,ITMCode:%String,cacheDate:%String,cacheTime:%String")
{
}

/// SA 4.1.01: Implemented for ChartFX graph. This query only returns graphable 
/// observation items (ie. Are numeric and have a graph marker/colour/pattern 
/// associated with them for the observation group and EMR.
/// 
/// Only items defined against the Y Axis number passed should be returned by the query
/// 
/// ORDER BY is specifically required for data to be returned by order item type.
Query FindEMRForGraph(MRAdm As %Library.String, ObsGrpID As %Library.String, YAxisNumber As %Library.String, StartDate As %Library.Date, EndDate As %Library.Date, StartTime As %Library.Time, EndTime As %Library.Time) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ITMDesc:%String,OBSValue:%String,OBSDate:%Date,OBSTime:%Time")
{
SELECT OBS_Item_DR->ITM_Desc,OBS_Value,OBS_Date,OBS_Time
FROM MR_Observations,MRC_ObservationGroupItems
WHERE OBS_ParRef = :MRAdm
 AND OBS_Item_DR = ITM_ObsItem_DR
 AND ITM_ParRef = :ObsGrpID
 AND ITM_YAxisOnGraph = :YAxisNumber
 AND (OBS_Date  > :StartDate OR :StartDate IS NULL OR ((OBS_Time > :StartTime OR :StartTime IS NULL) AND OBS_Date = :StartDate))
 AND (OBS_Date  < :EndDate OR :EndDate IS NULL OR (OBS_Time < :EndTime AND OBS_Date = :EndDate))
ORDER BY OBS_Item_DR->ITM_Desc,OBS_Date,OBS_Time
}

/// KM 14-Feb-2001: This Query is used in the ..obsSummaryGet method()
/// KM 15-Nov-2001: Changed this to be an Execute/Fetch/Close query so that it could be limited to the first 12 observations.
Query FindItems(mradm As %Library.String, ObsGrpID As %Library.String, oeordexecid As %Library.String, ObsDate As %Library.Date, ObsTime As %Library.Time, ID As %String, node As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "ObsItemID,ObsItemAnsweredID,OBSDesc:%Library.String,OBSItemType:%Library.String,OBSLowRange:%Library.String,OBSHighRange:%Library.String,OBSValue:%Library.String,OBSShortDesc:%Library.String,systemtype:%Library.Boolean,OBSLength:%Library.String,OBSInputType:%Library.String,OBSStatus:%Library.String,OBSCode:%Library.String")
{
}

}
