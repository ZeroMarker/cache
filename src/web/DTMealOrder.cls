Class web.DTMealOrder Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 78;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

Parameter SQLCODE = "ORD_RowId";

Parameter SQLDESCRIPTION = "ORD_RowId";

Parameter SQLROWID = "ORD_RowId";

Query FindMealOrders(SrchDate As %Library.String, SrchLoc As %Library.String, SrchMeal As %Library.Integer, SrchQty As %Library.String, SrchItem As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ORDRowID:%String,ORDDate:%String,CTLOCDesc:%String,MEALTDesc:%String,ORDQty:%String,ARCIM_Desc:%String,ARCIMCode:%String")
{
SELECT  ORD_RowID, ORD_Date,ORD_CTLOC_DR->CTLOC_Desc,ORD_MealType_DR->MEALT_Desc,ORD_Qty,ORD_ARCIM_DR->ARCIM_Desc,ORD_ARCIM_DR->ARCIM_Code
 FROM	SQLUser.DT_MealOrder, SQLUser.CT_Loc, SQLUser.DTC_MealType, SQLUser.ARC_ItmMast
 WHERE	(SQLUser.DT_MealOrder.ORD_CTLOC_DR =* SQLUser.CT_Loc.CTLOC_RowId)
 AND	(SQLUser.DT_MealOrder.ORD_MealType_DR =* SQLUser.DTC_MealType.MEALT_RowId)
 AND	(SQLUser.DT_MealOrder.ORD_ARCIM_DR =* SQLUser.ARC_ItmMast.ARCIM_RowId)	
 AND	((ORD_Qty = :SrchQty) OR (:SrchQty IS NULL))
 AND	((ORD_Date = :SrchDate) OR (:SrchDate IS NULL))
 AND	((MEALT_Desc = :SrchMeal) OR (:SrchMeal IS NULL))
 AND	((CTLOC_Desc = :SrchLoc) OR (:SrchLoc IS NULL))
 AND	((ARCIM_Desc = :SrchItem) OR (:SrchItem IS NULL))
 ORDER BY ORD_Date DESC, ORD_RowId DESC, MEALT_Time ASC
}

}
