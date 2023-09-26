/// 定义每个消毒包条码
Class User.CSSDCodeDict Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_CodeDict ]
{

Property CSSDCDCode As %String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CSSDCD_Code ];

Property CSSDCDCycleCount As %Integer [ SqlColumnNumber = 3, SqlFieldName = CSSDCD_CycleCount ];

Property CSSDCDDatatable As %String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = CSSDCD_Datatable ];

Property CSSDCDPackDR As User.CSSDPackage [ SqlColumnNumber = 5, SqlFieldName = CSSDCD_PackDR ];

Property CSSDCDPackName As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CSSDCD_PackName ];

Property CSSDCDPackTypeDetail As %Integer [ SqlColumnNumber = 7, SqlFieldName = CSSDCD_PackTypeDetail ];

Property CSSDCDTableRowID As %Integer [ SqlColumnNumber = 8, SqlFieldName = CSSDCD_TableRowID ];

Property CSSDCDOPRLocID As User.CTLoc [ SqlColumnNumber = 9, SqlFieldName = CSSDCD_OPRLocID ];

Property CSSDCDBskPackNum As %Integer [ SqlColumnNumber = 10, SqlFieldName = CSSDCD_BskPackNum ];

Property CSSDCDBskPackDr As User.CSSDPackage [ SqlColumnNumber = 11, SqlFieldName = CSSDCD_BskPackDr ];

Property CSSDCDEmergencySigns As %Integer [ SqlColumnNumber = 12, SqlFieldName = CSSDCD_EmergencySigns ];

Property CSSDCDHospital As CTHospital [ SqlColumnNumber = 13, SqlFieldName = CSSDCD_Hospital ];

Property CSSDCDZrw As %String(COLLATION = "Exact") [ SqlColumnNumber = 14, SqlFieldName = CSSDCD_Zrw ];

Property CSSDCDCreateLocDr As User.CTLoc [ SqlColumnNumber = 15, SqlFieldName = CSSDCD_CreateLocDr ];

Property CSSDCDRemark As %String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 16, SqlFieldName = CSSDCD_Remark ];

/// 可用状态:Y-可用,N-停用; 名称上有Not字样,不要纠结
Property CSSDCDNotUseFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 17, SqlFieldName = CSSDCD_NotUseFlag ];

Index CSSDCDCodePackType On (CSSDCDPackTypeDetail As Exact, CSSDCDCode As Exact);

Index PACKDR On CSSDCDPackDR As Exact;

Index CSSDCDCodeIndex On CSSDCDCode As Exact;

Index CSSDCDCodeTypeDetailIndex On (CSSDCDCode As Exact, CSSDCDPackTypeDetail As Exact);

Index CSSDCDPackNameIndex On CSSDCDPackName As Exact;

Storage Default
{
<Data name="CSSDCodeDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDCDCode</Value>
</Value>
<Value name="3">
<Value>CSSDCDCycleCount</Value>
</Value>
<Value name="4">
<Value>CSSDCDDatatable</Value>
</Value>
<Value name="5">
<Value>CSSDCDPackDR</Value>
</Value>
<Value name="6">
<Value>CSSDCDPackName</Value>
</Value>
<Value name="7">
<Value>CSSDCDPackTypeDetail</Value>
</Value>
<Value name="8">
<Value>CSSDCDTableRowID</Value>
</Value>
<Value name="9">
<Value>CSSDCDOPRLocID</Value>
</Value>
<Value name="10">
<Value>CSSDCDBskPackNum</Value>
</Value>
<Value name="11">
<Value>CSSDCDBskPackDr</Value>
</Value>
<Value name="12">
<Value>CSSDCDEmergencySigns</Value>
</Value>
<Value name="13">
<Value>CSSDCDHospital</Value>
</Value>
<Value name="14">
<Value>CSSDCDZrw</Value>
</Value>
<Value name="15">
<Value>CSSDCDCreateLocDr</Value>
</Value>
<Value name="16">
<Value>CSSDCDRemark</Value>
</Value>
<Value name="17">
<Value>CSSDCDNotUseFlag</Value>
</Value>
</Data>
<DataLocation>^User.CSSDCodeDictD</DataLocation>
<DefaultData>CSSDCodeDictDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDCodeDictD</IdLocation>
<IndexLocation>^User.CSSDCodeDictI</IndexLocation>
<StreamLocation>^User.CSSDCodeDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
