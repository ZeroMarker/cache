Include webimport

IncludeGenerator webimport

Class web.MRCObservationGroupItems Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 101;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %String(TRUNCATE = 1);

/// SA 5.4.01:  Implemented for ChartFX graph. This method gets the number of graphable 
/// observation items defined against the observation group.
/// 
/// Required because ChartFX needs to know the number of items it's graphing (ie. Series)
/// before query is made. Count is incremented every time a record is retrieved.
ClassMethod GetGraphItemsCount(ObsGrpID As %Library.String) As %Library.Integer
{
}

Parameter SQLCODE = "ITM_RowId";

Parameter SQLDESCRIPTION = "ITM_RowId";

Parameter SQLROWID = "ITM_RowId";

/// KM 14-Feb-2001: This Query is used in the method getItemsForGroup
Query FindEMR(ObsGrpID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID,ObsItemID:%String")
{
SELECT ITM_Rowid,ITM_ObsItem_DR
FROM MRC_ObservationGroupItems
WHERE ITM_ParRef = :ObsGrpID
ORDER BY ITM_RowPosition
}

/// SA 5.4.01:  Implemented for ChartFX graph to be called by 
/// class method GetGraphItemsCount. 
/// 
/// ITM_RowID was just the random field chosen.
/// 
/// An item with a value against ITM_YAxisOnGraph is assmued to be 
/// a graphable observation item.
Query ListGraphItemsForGroup(ObsGrpID As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID")
{
SELECT ITM_RowID
FROM MRC_ObservationGroupItems
WHERE ITM_ParRef = :ObsGrpID
 AND ITM_YAxisOnGraph IS NOT NULL
}

}
