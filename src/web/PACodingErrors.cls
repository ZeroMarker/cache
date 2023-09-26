Class web.PACodingErrors Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 75;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Property dummy As %Library.String(TRUNCATE = 1);

ClassMethod GetErrorDescription(RowId As %Library.String, SMRErrorDesc As %Library.String, Parameters As %Library.String)
{
}

Parameter SQLCODE = "CODERR_AdmCoding_DR";

Parameter SQLDESCRIPTION = "CODERR_RowId";

Parameter SQLROWID = "CODERR_RowId";

Query FindErrors(AdmCoding As %Library.String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "RowId,SMRErrorCode,SMRErrorDesc,ID,Code,NationalCode,AdmCoding,Parameters")
{
SELECT CODERR_RowId,CODERR_SMRError_DR->SMRERR_Code,CODERR_SMRError_DR->SMRERR_Desc,CODERR_ID,CODERR_Code,CODERR_NationalCode,CODERR_AdmCoding_DR->COD_RowId,CODERR_Parameters
FROM SQLUser.PA_CodingErrors
WHERE CODERR_AdmCoding_DR->COD_RowId = :AdmCoding
}

}
