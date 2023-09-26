Class web.PACADLCareTypeSub Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 54;

Parameter SQLDATEFROM = "SUB_DateFrom";

Parameter SQLDATETO = "SUB_DateTo";

Property dummy As %String(TRUNCATE = 1);

Parameter SQLCODE = "SUB_RowId";

Parameter SQLDESCRIPTION = "SUB_RowId";

Parameter SQLROWID = "SUB_RowId";

ClassMethod GetMaxMinScore(code As %Library.String = "", adlcaretype As %Library.String = "")
{
}

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", adlcaretype As %String = "", rdate As %Date) As %Boolean
{
}

Query FindADLWithDate(desc As %String, adlcaretype As %String, rdate As %Date) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ADLSTDesc,HIDDEN,ADLSTCode,HIDDEN,HIDDEN")
{
SELECT SUB_ADLSubType_DR->ADLST_Desc,SUB_ADLSubType_DR->ADLST_RowId,SUB_ADLSubType_DR->ADLST_Code,SUB_Min,SUB_Max  
FROM SQLUser.PAC_ADLCareTypeSub
WHERE  SUB_ParRef->ADLCT_Code= :adlcaretype
AND ((SUB_ADLSubType_DR->ADLST_Desc %STARTSWITH :desc)
OR	 (SUB_ADLSubType_DR->ADLST_Code=:desc))
AND	((SUB_DateFrom IS NULL) OR (SUB_DateFrom<= :rdate))
AND	((SUB_DateTo IS NULL) OR (SUB_DateTo>= :rdate))
}

}
