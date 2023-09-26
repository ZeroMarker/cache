Class web.PACSNAPCareTypeADLType Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 23;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ADL_RowId";

Parameter SQLDESCRIPTION = "ADL_RowId";

Parameter SQLROWID = "ADL_RowId";

ClassMethod LookUpBrokerWithDate(itmjs As %String = "", itmjsex As %String = "", val As %String = "", snapcare As %String = "", rdate As %Date) As %Boolean
{
}

Query FindADLTypeWithDate(desc As %String, snapcare As %String, rdate As %Date) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "SNAPCTDesc,HIDDEN,SNAPCTCode")
{
SELECT ADL_ADLCareType_DR->ADLCT_Desc,ADL_ADLCareType_DR->ADLCT_RowId,ADL_ADLCareType_DR->ADLCT_Code
FROM SQLUser.PAC_SNAPCareTypeADLType
WHERE  ADL_ParRef->SNAPCT_Desc= :snapcare
AND ((ADL_ADLCareType_DR->ADLCT_Desc %STARTSWITH :desc)
OR	 (ADL_ADLCareType_DR->ADLCT_Code=:desc))
AND	((ADL_ParRef->SNAPCT_DateFrom IS NULL) OR (ADL_ParRef->SNAPCT_DateFrom<= :rdate))
AND	((ADL_ParRef->SNAPCT_DateTo IS NULL) OR (ADL_ParRef->SNAPCT_DateTo>= :rdate))
AND	((ADL_ADLCareType_DR->ADLCT_DateFrom IS NULL) OR (ADL_ADLCareType_DR->ADLCT_DateFrom<= :rdate))
AND	((ADL_ADLCareType_DR->ADLCT_DateTo IS NULL) OR (ADL_ADLCareType_DR->ADLCT_DateTo>= :rdate))
}

}
