Class web.ARCloseShift Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 224;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "CLS_RowId";

Parameter SQLDESCRIPTION = "CLS_RowId";

Parameter SQLROWID = "CLS_RowId";

ClassMethod FindShiftClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindShiftFetch ]
{
}

ClassMethod FindShiftExecute(ByRef QHandle As %Library.Binary, CLSCashier As %String = "", CLSShiftNumber As %String = "", CLSStatus As %String = "", CLSLocation As %String = "", CLSHospital As %String = "", CLSDateFrom As %Library.Date = "", CLSDateTo As %Library.Date = "") As %Library.Status
{
}

ClassMethod FindShiftFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindShiftExecute ]
{
}

ClassMethod GetTotalAdjsutments(ShiftId As %Library.String) As %Library.Float
{
}

ClassMethod GetTotalPayments(ShiftId As %Library.String) As %Library.String
{
}

Query FindShift(CLSCashier As %String, CLSShiftNumber As %String, CLSStatus As %String, CLSLocation As %String, CLSHospital As %String, CLSDateFrom As %Library.Date, CLSDateTo As %Library.Date) As %Library.Query(CONTAINID = 0, ROWSPEC = "ID,Number,CreateDate,CreateTime,CreateUser,CreateUserCode,CancelDate,CancelTime,CancelUser,Status,Location,RecDate,RecCashier,RecTimeFrom,RecTimeTo,Hospital,Cash,Card,Cheque,Direct,GrandTot,OpenBal,CloseBal")
{
}

/// 60188
Query LookUpShiftByCashier(cashier As %Library.String, val As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "Shift:%String,Date:%Date,Cashier:%String,Location:%String,Hospital:%String")
{
	SELECT CLS_Number, %EXTERNAL(CLS_CreateDate), CLS_CreateUser_DR->SSUSR_Name, CLS_RecLocation_DR->CTLOC_Desc, CLS_RecLocation_DR->CTLOC_Hospital_DR->HOSP_Desc
	FROM SQLUser.AR_CloseShift
	WHERE ((CLS_CreateUser_DR->SSUSR_Name = :cashier) OR (:cashier IS NULL))
	AND ((CLS_Number %STARTSWITH :val) OR (:val IS NULL))
	ORDER BY CLS_CreateDate DESC,CLS_CreateTime DESC
}

/// 60188
ClassMethod LookUpShiftByCashierBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", cashier As %Library.String, val As %Library.String)
{
}

ClassMethod websysCancel(compref As %Library.String = "", id As %Library.String)
{
}

ClassMethod websysClose(shift As %Library.String)
{
}

/*ClassMethod LongTextHtmlToString(str As %Library.String, delim As %Library.String = "|")
{
 n j
 
 f j=1:1:$l(str,delim) {
	s ^zTRAK("GC2","60188","str",j)= $p(str,delim,j)
 	;d prp.Insert($p(str,delim,j))
 }
 q
}*/
ClassMethod websysReopen(shift As %Library.String)
{
}

ClassMethod GetOpenShift(User As %Library.String) As %Library.String
{
}

ClassMethod websysSave(compref As %Library.String, id As %Library.String = "")
{
}

}
