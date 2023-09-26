/// 消毒包回收明细表，
Class User.CSSDCallbackDetailNew Extends (%Persistent, User.Abstract) [ SqlRowIdName = CSSDCD_Rowid, SqlTableName = CSSD_CallBackDetailNew ]
{

Property CSSDCDParref As User.CSSDPackageCallback [ SqlColumnNumber = 2, SqlFieldName = CSSDCD_Parref_DR ];

Property CSSDCDPackageDr As User.CSSDPackage [ Required, SqlColumnNumber = 3, SqlFieldName = CSSDCD_Package_DR ];

Property CSSDCDQty As %Numeric [ SqlColumnNumber = 4, SqlFieldName = CSSDCD_Qty ];

Property CSSDCDDispQty As %Numeric [ SqlColumnNumber = 5, SqlFieldName = CSSDCD_DispQty ];

/// 消毒包标签号
Property CSSDPCPackageLabel As %String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CSSDPC_PackageLabel ];

Property CSSDCDPackageApplyDetailDR As User.CSSDPackageApplyDetail [ SqlColumnNumber = 7, SqlFieldName = CSSDCD_PackageApplyDetailDR ];

Property CSSDCDPrice As %String(COLLATION = "Exact") [ SqlColumnNumber = 8, SqlFieldName = CSSDCD_Price ];

Property CSSDPCDictLabel As %String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CSSDPC_DictLabel ];

/// hisui是否清洗
Property CSSDCDIsClean As %String(COLLATION = "Exact") [ SqlColumnNumber = 10, SqlFieldName = CSSDCD_IsClean ];

Property CSSDCDMaterial As User.CSSDMaterial [ SqlColumnNumber = 11, SqlFieldName = CSSDCD_Material ];

Property CSSDCDLevelFlag As %String(COLLATION = "Exact") [ SqlColumnNumber = 12, SqlFieldName = CSSDCD_LevelFlag ];

/// 感染标志
Property CSSDCDPBeInfected As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 13, SqlFieldName = CSSDCDP_BeInfected ];

Index CSSDCDParrefItmIndex On (CSSDCDParref As Exact, CSSDCDPackageDr As Exact);

Index CSSDCDParrefIndex On CSSDCDParref As Exact;

Index CSSDCDPackageLabelIndex On CSSDPCPackageLabel As Exact;

Index CSSDCDPackageApplyDetailDRIndex On CSSDCDPackageApplyDetailDR As Exact;

Index CSSDCDPackageIndex On CSSDCDPackageDr As Exact;

Index CSSDPCDictLabelIndex On CSSDPCDictLabel As Exact;

Storage Default
{
<Data name="CSSDCallbackDetailNewDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDCDParref</Value>
</Value>
<Value name="3">
<Value>CSSDCDPackageDr</Value>
</Value>
<Value name="4">
<Value>CSSDCDQty</Value>
</Value>
<Value name="5">
<Value>CSSDCDDispQty</Value>
</Value>
<Value name="6">
<Value>CSSDPCPackageLabel</Value>
</Value>
<Value name="7">
<Value>CSSDCDPackageApplyDetailDR</Value>
</Value>
<Value name="8">
<Value>CSSDCDPrice</Value>
</Value>
<Value name="9">
<Value>CSSDPCDictLabel</Value>
</Value>
<Value name="10">
<Value>CSSDCDIsClean</Value>
</Value>
<Value name="11">
<Value>CSSDCDMaterial</Value>
</Value>
<Value name="12">
<Value>CSSDCDLevelFlag</Value>
</Value>
<Value name="13">
<Value>CSSDCDPBeInfected</Value>
</Value>
</Data>
<DataLocation>^User.CSSDCallbackDetailNewD</DataLocation>
<DefaultData>CSSDCallbackDetailNewDefaultData</DefaultData>
<IdLocation>^User.CSSDCallbackDetailNewD</IdLocation>
<IndexLocation>^User.CSSDCallbackDetailNewI</IndexLocation>
<SqlRowIdName>CSSDCD_Rowid</SqlRowIdName>
<StreamLocation>^User.CSSDCallbackDetailNewS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
