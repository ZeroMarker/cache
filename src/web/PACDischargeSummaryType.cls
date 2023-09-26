Class web.PACDischargeSummaryType Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 51;

Parameter SQLDATEFROM = "DISCST_DateFrom";

Parameter SQLDATETO = "DISCST_DateTo";

Parameter SQLCODE = "DISCST_RowID";

Parameter SQLDESCRIPTION = "DISCST_RowID";

Parameter SQLROWID = "DISCST_RowID";

ClassMethod GetIdFromCodeOrDescription(desc As %String = "") As %Library.String
{
}

ClassMethod GetIdFromDescription(desc As %String = "") As %Library.String
{
}

ClassMethod GetDescriptionFromId(id As %String = "") As %Library.String
{
}

ClassMethod LookUpDischSummTypeByGroupClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpDSTypeByGroupFetch ]
{
}

ClassMethod LookUpDSTypeByGroupExecute(ByRef QHandle As %Library.Binary, DocumentType As %String = "") As %Library.Status
{
}

ClassMethod LookUpDSTypeByGroupClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpDSTypeByGroupExecute ]
{
}

ClassMethod LookUpDSTypeByGroupFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpDSTypeByGroupExecute ]
{
}

ClassMethod LookUpDSTypeByGroupBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", DocumentType As %String = "") As %Library.Boolean
{
}

Query LookUpDSTypeByGroup(DocumentType As %String = "") As %Query(CONTAINID = 0, ROWSPEC = "DISCSTDesc,HIDDEN,DISCSTCode,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN")
{
}

/// Log 42975 - AI - 25-03-2004 : LookUp created to incorporate DateFrom and DateTo values in the CodeTable.
Query LookUpDischSummType(DocumentType As %String = "", Date As %String = "") As %SQLQuery(CONTAINID = 0, ROWSPEC = "DISCSTDesc,HIDDEN,DISCSTCode,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN")
{
SELECT DISCST_Desc,DISCST_RowId,DISCST_Code,DISCST_DocumentType,DISCST_DocumentName,DISCST_Chart,DISCST_DateFrom,DISCST_DateTo 
FROM SQLUser.PAC_DischargeSummaryType
WHERE ((%ALPHAUP DISCST_Desc %STARTSWITH %ALPHAUP :DocumentType OR :DocumentType IS NULL)
AND ((DISCST_DateFrom <= :Date OR DISCST_DateFrom IS NULL) AND (DISCST_DateTo >= :Date OR DISCST_DateTo IS NULL)))
}

/// Log 42975 - AI - 25-03-2004 : Broker created to incorporate DateFrom and DateTo values in the CodeTable.
ClassMethod LookUpBrokerDischSummType(itmjs As %Library.String = "", itmjsex As %Library.String = "", DocumentType As %String = "", Date As %String = "") As %Library.Boolean
{
}

}
