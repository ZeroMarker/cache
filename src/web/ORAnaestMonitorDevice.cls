Class web.ORAnaestMonitorDevice Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 23;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "MON_RowId";

Parameter SQLDESCRIPTION = "MON_RowId";

Parameter SQLROWID = "MON_RowId";

Property dummy As %String(TRUNCATE = 1);

ClassMethod LookUpMonDevClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpMonDevFetch ]
{
}

ClassMethod LookUpMonDevExecute(ByRef QHandle As %Library.Binary, AnaeId As %Library.String = "") As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
}

ClassMethod LookUpMonDevFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpMonDevExecute ]
{
}

ClassMethod websysSaveAll(AnaeId As %Library.String, Items As %Library.String)
{
}

Query Find(AnaeId As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "ID,OPMON_Desc,MON_Monit_DR")
{
SELECT 
MON_RowId, 
MON_Monit_DR->OPMON_Desc, 
MON_Monit_DR
FROM SQLUser.OR_AnaestMonitorDevice
WHERE MON_ParRef = :AnaeId
}

Query LookUpMonDev(ID As %Library.String) As %Library.Query(CONTAINID = 1, ROWSPEC = "values:%String,desc:%String")
{
}

}
