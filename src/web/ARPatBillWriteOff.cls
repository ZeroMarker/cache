Class web.ARPatBillWriteOff Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 737;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "WO_RowId";

Parameter SQLDESCRIPTION = "WO_RowId";

Parameter SQLROWID = "WO_RowId";

/**
 * RQG 12.05.03 LOG 33282: This method is called from ARPatBillWriteOff component. This will convert
 * string of ids to string of descriptions delimited by comma.
 */
ClassMethod ConvertCodeStrToDescriptions(PlanStr As %Library.String = "") As %Library.String
{
}

ClassMethod FindPayorPatientBill(EpisodeID As %Library.String = "", PayorID As %Library.String = "") As %Library.String
{
}

ClassMethod websysAfterSave(compref As %Library.String, ByRef id As %Library.String, new As %Library.Boolean) As %Library.Boolean
{
}

ClassMethod websysBeforeSave(compref As %Library.String, ByRef id As %Library.String) As %Library.Boolean
{
}

/**
 * To be called instead of websysDelete to update total Write Off Amount from
 * ARPatbill (Parent table) as well as this child table. This function will then call the websysDelete
 */
ClassMethod websysDeleteWriteOff(compref As %Library.String, id As %Library.String)
{
}

/** 
 * This method gets called instead of websysSave to update total Write Off Amount from ARPatBillWriteOff.Edit screen 
 */
ClassMethod websysSaveWriteOff(compref As %Library.String, id As %Library.String, EpisodeID As %Library.String = "")
{
}

/** 
 *  log 36922: This method will be called when a WO allocation exists, and the 
 *  WO is being transferred to the other party's bill (ie. Patient->Payor or Payor->Patient)
 *  The WO allocations will be negated, to coincide with the negated WO amounts
 */
ClassMethod TransferWOAllocation(NewWOAmt As %String = "", FromBillRowID As %String = "", ToBillRowID As %String = "", GroupType As %String = "I")
{
}

/** 
 * log 36922: This method saves the WO against the payment allocations for each Item/BillGroup/Subgroup in the bill
 * It calls d updamt^MVBARPB8 to save it to db.
 */
ClassMethod SaveWriteOffAllocation(BillRowID As %String = "", WORowID As %String = "")
{
}

/**
 * 
 */
ClassMethod AllocateWriteOff(BillRowID As %Library.String = "", WriteOffAmount As %Library.String = "0", OutstandAmt As %Library.String = "0")
{
}

/**
 * log 36922: This method will be called to delete all payment allocations
 * which were allocated using the WO which we are deleting via websysDeleteWriteOff
 * It will also be called when updating an existing WO.
 */
ClassMethod DeleteWOPaymAllocs(BillRowID As %String = "", WORowID As %String = "")
{
}

}
