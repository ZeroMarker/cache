Class User.DHCANRCCheckItem Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = ANRCCI_RowId, SqlTableName = DHC_ANRC_CheckItem, StorageStrategy = CacheStorage ]
{

Property ANRCCICode As %String [ SqlColumnNumber = 2, SqlFieldName = ANRCCI_Code ];

Property ANRCCIDesc As %String [ SqlColumnNumber = 3, SqlFieldName = ANRCCI_Desc ];

Property ANRCCIDefAnrcmcDr As User.DHCANRCManageClass [ SqlColumnNumber = 4, SqlFieldName = ANRCCI_DefAnrcmc_Dr ];

Property ANRCCIClcmsDr As User.DHCCLCMedicalSpecialty [ SqlColumnNumber = 5, SqlFieldName = ANRCCI_Clcms_Dr ];

Property ANRCCIType As %String(DISPLAYLIST = ",Therapy,Lab,Exam,Consultation,Risk", MAXLEN = 12, SELECTIVITY = "16.6667%", VALUELIST = ",T,L,E,C,R") [ SqlColumnNumber = 6, SqlFieldName = ANRCCI_Type ];

Property ANRCCITestCode As %String [ SqlColumnNumber = 7, SqlFieldName = ANRCCI_TestCode ];

Property ANRCCIExamCode As %String [ SqlColumnNumber = 8, SqlFieldName = ANRCCI_ExamCode ];

Property ANRCCIConsultationCode As %String [ SqlColumnNumber = 9, SqlFieldName = ANRCCI_ConsultationCode ];

Storage CacheStorage
{
<Data name="DHCANRCCheckItemClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>0</Subscript>
</Data>
<Data name="DHCANRCCheckItemDefaultData">
<Value name="1">
<Value>ANRCCICode</Value>
</Value>
<Value name="2">
<Value>ANRCCIDesc</Value>
</Value>
<Value name="3">
<Value>ANRCCIDefAnrcmcDr</Value>
</Value>
<Value name="4">
<Value>ANRCCIClcmsDr</Value>
</Value>
<Value name="5">
<Value>ANRCCIType</Value>
</Value>
<Value name="6">
<Value>ANRCCITestCode</Value>
</Value>
<Value name="7">
<Value>ANRCCIExamCode</Value>
</Value>
<Value name="8">
<Value>ANRCCIConsultationCode</Value>
</Value>
</Data>
<DataLocation>^DHCANRC("CheckItem")</DataLocation>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCANRC("CheckItem")</IdLocation>
<IndexLocation>^DHCANRC("CheckItem",0)</IndexLocation>
<StreamLocation>^User.DHCANRCCheckItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
