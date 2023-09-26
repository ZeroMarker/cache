Class web.ARPatBillDiscAlloc Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 294;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "DSAL_RowId";

Parameter SQLROWID = "DSAL_RowId";

Parameter SQLDESCRIPTION = "DSAL_RowId";

/// log 46811
ClassMethod DiscountAllocate(compref As %String, BillRowID As %Library.String, GroupType As %Library.String)
{
}

ClassMethod GetDiscountAmount(BillRowID As %Library.String)
{
}

//Used by ARPatBill.DiscEdit

ClassMethod GetField(FieldName As %Library.String, ByRef obj As %Library.String)
{
}

ClassMethod GetAllocPercentage(BillRowID As %Library.String)
{
}

ClassMethod GetGroupType(BillRowID As %Library.String)
{
}

ClassMethod GetAllocationMethod(BillRowID As %Library.String)
{
}

Query FindDisc(BillRowID, GroupType, ClearAlloc) As %Library.Query(CONTAINID = 0, ROWSPEC = "ListDescription,BilledAmount,AllocatePercentage,DiscAmount,SubRows")
{
}

ClassMethod FindDiscClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindDiscFetch ]
{
}

ClassMethod FindDiscExecute(ByRef QHandle As %Library.Binary, BillRowID As %Library.String, GroupType As %Library.String, ClearAlloc As %Library.String = "") As %Library.Status
{
}

ClassMethod FindDiscFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindDiscExecute ]
{
}

}
