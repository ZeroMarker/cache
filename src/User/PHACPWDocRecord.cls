Class User.PHACPWDocRecord Extends %Persistent [ SqlTableName = PHACPW_DocRecord ]
{

Index RecDate On PCDRRecordDate As Exact;

Relationship ChildPHACPWItm As User.PHACPWDocRecordItm [ Cardinality = children, Inverse = PCDRIParRef ];

Property PCDRTitle As %String [ SqlColumnNumber = 2, SqlFieldName = PCDR_Title ];

Property PCDRDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = PCDR_Date ];

Property PCDRTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = PCDR_Time ];

Property PCDRAuthor As %String [ SqlColumnNumber = 5, SqlFieldName = PCDR_Author ];

Property PCDRMainContent As %String(COLLATION = "Exact", MAXLEN = 350, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PCDR_MainContent ];

Property PCDRReferences As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = PCDR_References ];

Property PCDRKeywords As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = PCDR_Keywords ];

Property PCDRRecorder As User.SSUser [ SqlColumnNumber = 9, SqlFieldName = PCDR_Recorder ];

Property PCDRRecordDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = PCDR_RecordDate ];

Property PCDRRecordTime As %Library.Time [ SqlColumnNumber = 11, SqlFieldName = PCDR_RecordTime ];

Property PCDRRemark As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = PCDR_Remark ];

Property PCDRStudent As User.DHCPHBasManStudent [ SqlColumnNumber = 13, SqlFieldName = PCDR_Student ];

Storage Default
{
<Data name="PHACPWDocRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PCDRTitle</Value>
</Value>
<Value name="3">
<Value>PCDRDate</Value>
</Value>
<Value name="4">
<Value>PCDRTime</Value>
</Value>
<Value name="5">
<Value>PCDRAuthor</Value>
</Value>
<Value name="6">
<Value>PCDRMainContent</Value>
</Value>
<Value name="7">
<Value>PCDRReferences</Value>
</Value>
<Value name="8">
<Value>PCDRKeywords</Value>
</Value>
<Value name="9">
<Value>PCDRRecorder</Value>
</Value>
<Value name="10">
<Value>PCDRRecordDate</Value>
</Value>
<Value name="11">
<Value>PCDRRecordTime</Value>
</Value>
<Value name="12">
<Value>PCDRRemark</Value>
</Value>
<Value name="13">
<Value>PCDRStudent</Value>
</Value>
</Data>
<DataLocation>^BS.PHA.CPW.DocRec</DataLocation>
<DefaultData>PHACPWDocRecordDefaultData</DefaultData>
<IdLocation>^BS.PHA.CPW.DocRec</IdLocation>
<IndexLocation>^BS.PHA.CPW.DocReci</IndexLocation>
<StreamLocation>^User.PHACPWDocRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
