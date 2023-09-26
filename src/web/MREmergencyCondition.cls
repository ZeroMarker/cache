Class web.MREmergencyCondition Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 108;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "EMC_RowId";

Parameter SQLDESCRIPTION = "EMC_RowId";

Parameter SQLROWID = "EMC_RowId";

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetImage(mradm As %Library.String, PARAMS As %Library.String, ByRef imgLIST As %Library.String)
{
}

ClassMethod LookUpConditionsClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpConditionsFetch ]
{
}

ClassMethod LookUpConditionsExecute(ByRef QHandle As %Library.Binary, mradm As %Library.String) As %Library.Status
{
}

ClassMethod LookUpConditionsFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpConditionsExecute ]
{
}

ClassMethod websysSaveAll(MRAdmID As %Library.String, Conditions As %Library.String)
{
}

Query Find(mradm As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,EMCEmergCondDR:%String,EMCDesc:%String,EMCIconName:%String,EMCIconPriority:%String")
{
SELECT EMC_RowID, EMC_EmergCond_DR, EMC_EmergCond_DR->EMC_Desc, EMC_EmergCond_DR->EMC_IconName, EMC_EmergCond_DR->EMC_IconPriority
FROM SQLUser.MR_EmergencyCondition
WHERE EMC_ParRef = :mradm
}

Query LookUpConditions(mradm As %Library.String) As %Library.Query(CONTAINID = 0, ROWSPEC = "values:%String,desc:%String")
{
}

}
