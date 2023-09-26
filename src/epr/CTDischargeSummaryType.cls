Class epr.CTDischargeSummaryType Extends (%Library.Persistent, websys.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 71;

Parameter SQLDATEFROM = "DSTDateFrom";

Parameter SQLDATETO = "DSTDateTo";

Parameter SQLCODE = "DSTCode";

Parameter SQLDESCRIPTION = "DSTDesc";

Parameter SQLROWID = "ID";

/// Code
Property DSTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required ];

/// Description
Property DSTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1);

/// Document Type
Property DSTDocumentType As %String(DISPLAYLIST = ",Word,Crystal Report,HTML", MAXLEN = 14, TRUNCATE = 1, VALUELIST = ",W,C,H");

/// Document Name
Property DSTDocumentName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1);

/// Date From
Property DSTDateFrom As %Date;

/// Date To
Property DSTDateTo As %Date;

/// Multiple Versions
Property DSTMultipleVersions As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N");

/// EpisodeType
Property DSTEpisodeType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1);

/// websys.Report DR
Property DSTReportDR As websys.Report [ Required ];

/// Email Subject Heading
Property DSTEmailSubjectHeading As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1);

/// Email Body value
Property DSTEmailBody As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlListType = SUBNODE ];

/// Uniqueness index for property DSTCode
Index UniqueDSTCodeIndex On DSTCode [ Unique ];

/// Doctors To Exclude
Property DSTExcludeDoctor As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1);

/// Chart book to use for this Discharge Summary Type
Property DSTEPRChartBookDR As epr.ChartBook;

/// Used by both Document Type and Episode Type, as this query is rather generic of websys.StandardType
Query LookUpStdType(type As %String, desc As %String) As %Library.SQLQuery(CONTAINID = 2, ROWSPEC = "Description:%String,Code:%String,HIDDEN:%String")
{
SELECT Description, Code, StoredValue
FROM websys.StandardTypeItem
WHERE (ParRef=:type) 
AND (%ALPHAUP Description %STARTSWITH %ALPHAUP :desc)
}

/// Used by both Document Type and Episode Type, as this method is rather generic of websys.StandardType
ClassMethod LookupStdTypeBroker(itmjs As %String = "", itmjsex As %String = "", type As %String = "", desc As %String = "") As %Boolean
{
}

Query Find(Code As %String, Description As %String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,DSTCode,DSTDesc,DSTDocumentType,DSTDocumentName,DSTDateFrom,DSTDateTo,DSTMultipleVersions,DSTEpisodeType,DSTReportDR,DSTExcludeDoctor")
{
SELECT  ID,DSTCode,DSTDesc,DSTDocumentType,DSTDocumentName,DSTDateFrom,DSTDateTo,DSTMultipleVersions,DSTEpisodeType,DSTReportDR->Description,DSTExcludeDoctor
FROM     epr.CTDischargeSummaryType
WHERE (((%ALPHAUP DSTCode %STARTSWITH %ALPHAUP :Code) OR (:Code IS NULL)) AND ((%ALPHAUP DSTDesc %STARTSWITH %ALPHAUP :Description) OR (:Description IS NULL)))
ORDER BY DSTCode
}

/// Log 42975 - AI - 25-03-2004 : LookUp created to incorporate DateFrom and DateTo values in the CodeTable.
Query LookUpDischSummType(DocumentType As %String = "", Date As %String = "") As %SQLQuery(CONTAINID = 0, ROWSPEC = "DSTDesc,HIDDEN,DSTCode,HIDDEN,HIDDEN,HIDDEN,HIDDEN")
{
SELECT DSTDesc,ID,DSTCode,DSTDocumentType,DSTDocumentName,DSTDateFrom,DSTDateTo 
FROM epr.CTDischargeSummaryType
WHERE ((%ALPHAUP DSTDesc %STARTSWITH %ALPHAUP :DocumentType OR :DocumentType IS NULL)
AND ((DSTDateFrom <= :Date OR DSTDateFrom IS NULL) AND (DSTDateTo >= :Date OR DSTDateTo IS NULL)))
ORDER BY DSTCode
}

ClassMethod LookUpDischSummTypeByGroupClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpDSTypeByGroupFetch ]
{
}

ClassMethod LookUpDSTypeByGroupExecute(ByRef QHandle As %Library.Binary, DocumentType As %String = "", Date As %String = "") As %Library.Status
{
}

ClassMethod LookUpDSTypeByGroupFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = LookUpDSTypeByGroupExecute ]
{
}

ClassMethod LookUpDSTypeByGroupBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", DocumentType As %String = "", Date As %String = "") As %Library.Boolean
{
}

Query LookUpDSTypeByGroup(DocumentType As %String = "", Date As %String = "") As %Query(CONTAINID = 0, ROWSPEC = "DISCSTDesc,HIDDEN,DISCSTCode,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN")
{
}

ClassMethod LookUpDSTypeByGroupClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = LookUpDSTypeByGroupFetch ]
{
}

/// Log 42975 - AI - 25-03-2004 : Broker created to incorporate DateFrom and DateTo values in the CodeTable.
ClassMethod LookUpBrokerDischSummType(itmjs As %Library.String = "", itmjsex As %Library.String = "", DocumentType As %String = "", Date As %String = "") As %Library.Boolean
{
}

Storage Default
{
<Data name="CTDischargeSummaryTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DSTChart</Value>
</Value>
<Value name="3">
<Value>DSTCode</Value>
</Value>
<Value name="4">
<Value>DSTDateFrom</Value>
</Value>
<Value name="5">
<Value>DSTDateTo</Value>
</Value>
<Value name="6">
<Value>DSTDesc</Value>
</Value>
<Value name="7">
<Value>DSTDocumentName</Value>
</Value>
<Value name="8">
<Value>DSTDocumentType</Value>
</Value>
<Value name="9">
<Value>DSTEpisodeType</Value>
</Value>
<Value name="10">
<Value>DSTMultipleVersions</Value>
</Value>
<Value name="11">
<Value>DSTReportDR</Value>
</Value>
<Value name="12">
<Value>DSTEmailBody</Value>
</Value>
<Value name="13">
<Value>DSTEmailSubjectHeading</Value>
</Value>
<Value name="14">
<Value>DSTExcludeDoctor</Value>
</Value>
<Value name="15">
<Value>DSTEPRChartBookDR</Value>
</Value>
</Data>
<DataLocation>^epr.CTDischargeSummaryTypeD</DataLocation>
<DefaultData>CTDischargeSummaryTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^epr.CTDischargeSummaryTypeD</IdLocation>
<IndexLocation>^epr.CTDischargeSummaryTypeI</IndexLocation>
<StreamLocation>^epr.CTDischargeSummaryTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
