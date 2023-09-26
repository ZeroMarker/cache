Class User.DHCCLLabResult Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = CLLR_RowId, SqlTableName = DHC_CL_LabResult, StorageStrategy = CacheStorage ]
{

Property CLLRLabResultNo As %String [ SqlColumnNumber = 2, SqlFieldName = CLLR_LabResultNo ];

Property CLLRPaadmDr As %String [ SqlColumnNumber = 3, SqlFieldName = CLLR_Paadm_Dr ];

Property CLLROeoriNo As %String(COLLATION = "Exact", MAXLEN = 128, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CLLR_OeoriNo ];

Property CLLRLabNo As %String [ SqlColumnNumber = 5, SqlFieldName = CLLR_LabNo ];

Property CLLRSpecimenDr As User.DHCCLCLabSpecimen [ SqlColumnNumber = 6, SqlFieldName = CLLR_Specimen_Dr ];

Property CLLRTestCodeDr As User.DHCCLCLabTestCode [ SqlColumnNumber = 7, SqlFieldName = CLLR_TestCode_Dr ];

Property CLLRTestCodeDesc As %String [ SqlColumnNumber = 8, SqlFieldName = CLLR_TestCodeDesc ];

Property CLLRCollectDate As %Date [ SqlColumnNumber = 9, SqlFieldName = CLLR_CollectDate ];

Property CLLRCollectTime As %Time [ SqlColumnNumber = 10, SqlFieldName = CLLR_CollectTime ];

Property CLLRReceivedDate As %Date [ SqlColumnNumber = 11, SqlFieldName = CLLR_ReceivedDate ];

Property CLLRReceivedTime As %Time [ SqlColumnNumber = 12, SqlFieldName = CLLR_ReceivedTime ];

Property CLLRResultDate As %Date [ SqlColumnNumber = 13, SqlFieldName = CLLR_ResultDate ];

Property CLLRResultTime As %Time [ SqlColumnNumber = 14, SqlFieldName = CLLR_ResultTime ];

Property CLLRTestResult As %String [ SqlColumnNumber = 15, SqlFieldName = CLLR_TestResult ];

Property CLLRTestResultUnitCode As %String [ SqlColumnNumber = 16, SqlFieldName = CLLR_TestResultUnitCode ];

Property CLLRTestResultRange As %String [ SqlColumnNumber = 17, SqlFieldName = CLLR_TestResultRange ];

Property CLLRTestConclusion As %String [ SqlColumnNumber = 18, SqlFieldName = CLLR_TestConclusion ];

Property CLLRMicroorganismType As %String(DISPLAYLIST = ",Microorganism", VALUELIST = ",M") [ SqlColumnNumber = 19, SqlFieldName = CLLR_MicroorganismType ];

Property CLLRLabLocCode As %String [ SqlColumnNumber = 20, SqlFieldName = CLLR_LabLocCode ];

Index LabResultNo On CLLRLabResultNo As Exact;

Index TestCodeDate On (CLLRPaadmDr As Exact, CLLRTestCodeDr As Exact, CLLRCollectDate As Exact);

Storage CacheStorage
{
<Data name="DHCCLLabResultClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCCLLabResultDefaultData">
<Value name="1">
<Value>CLLRLabResultNo</Value>
</Value>
<Value name="2">
<Value>CLLRPaadmDr</Value>
</Value>
<Value name="3">
<Value>CLLROeoriNo</Value>
</Value>
<Value name="4">
<Value>CLLRLabNo</Value>
</Value>
<Value name="5">
<Value>CLLRSpecimenDr</Value>
</Value>
<Value name="6">
<Value>CLLRTestCodeDr</Value>
</Value>
<Value name="7">
<Value>CLLRTestCodeDesc</Value>
</Value>
<Value name="8">
<Value>CLLRCollectDate</Value>
</Value>
<Value name="9">
<Value>CLLRCollectTime</Value>
</Value>
<Value name="10">
<Value>CLLRReceivedDate</Value>
</Value>
<Value name="11">
<Value>CLLRReceivedTime</Value>
</Value>
<Value name="12">
<Value>CLLRResultDate</Value>
</Value>
<Value name="13">
<Value>CLLRResultTime</Value>
</Value>
<Value name="14">
<Value>CLLRTestResult</Value>
</Value>
<Value name="15">
<Value>CLLRTestResultUnitCode</Value>
</Value>
<Value name="16">
<Value>CLLRTestResultRange</Value>
</Value>
<Value name="17">
<Value>CLLRTestConclusion</Value>
</Value>
<Value name="18">
<Value>CLLRMicroorganismType</Value>
</Value>
<Value name="19">
<Value>CLLRLabLocCode</Value>
</Value>
</Data>
<DataLocation>^DHCCLLabResult</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCLLabResult</IdLocation>
<IndexLocation>^DHCCLLabResult(0)</IndexLocation>
<StreamLocation>^User.DHCCLLabResultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
