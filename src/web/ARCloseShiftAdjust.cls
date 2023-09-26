Class web.ARCloseShiftAdjust Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 10;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ADJ_RowId";

Parameter SQLDESCRIPTION = "ADJ_RowId";

Parameter SQLROWID = "ADJ_RowId";

ClassMethod websysSaveAdjust(compref As %Library.String, id As %Library.String)
{
}

Query FindAdjustments(PARREF As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "RowId:%String,Amount:%String,Date:%Date,Time:%Time,Reason:%String,Comments:%String")
{
	SELECT ADJ_RowId,ADJ_Amount, ADJ_Date, ADJ_Time, ADJ_Reason_DR->CSAD_Desc, ADJ_Comments
	FROM SQLUser.AR_CloseShiftAdjust
	WHERE ADJ_ParRef =:PARREF
}

}
