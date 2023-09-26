Class web.OECDentalState Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 62;

Parameter SQLCODE = "DENST_Code";

Parameter SQLDATEFROM = "DENST_DateFrom";

Parameter SQLDATETO = "DENST_DateTo";

Parameter SQLDESCRIPTION = "DENST_Desc";

Parameter SQLROWID = "DENST_RowId";

Property dummy As %String(TRUNCATE = 1);

/// Default implementation of LookUp Query.
ClassMethod LookUpByTeethAreasClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpByTeethAreasFetch ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByTeethAreasExecute(ByRef QHandle As %Library.Binary, val As %Library.String = "", areas As %Library.String = "", date As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

/// Default implementation of LookUp Query.
ClassMethod LookUpByTeethAreasFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpByTeethAreasExecute ]
{
}

Query LookUpByTeethAreas(val As %Library.String = "", areas As %Library.String = "", date As %Library.String = "") As %Library.Query(CONTAINID = 2, ROWSPEC = "DENSTDesc:%String,Hidden:%String,DENSTCode:%String")
{
}

ClassMethod LookUpByTeethAreasBroker(itmjs As %String = "", itmjsex As %String = "", val As %String = "", areas As %String = "", date As %Date = "") As %Library.Boolean
{
}

}
