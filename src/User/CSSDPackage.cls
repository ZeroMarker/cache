Class User.CSSDPackage Extends (%Persistent, User.Abstract) [ SqlRowIdName = CSSDP_Rowid, SqlTableName = CSSD_Package ]
{

Property CSSDPIsExt As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", Required, SqlColumnNumber = 2, SqlFieldName = CSSDP_IsExt ];

/// 包的描述的每个字的首字母
Property CSSDPAlias As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CSSDP_Alias ];

Property CSSDPCode As %Integer [ SqlColumnNumber = 4, SqlFieldName = CSSDP_Code ];

Property CSSDPDesc As %String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = CSSDP_Desc ];

Property CSSDPUom As User.CTUOM [ SqlColumnNumber = 6, SqlFieldName = CSSDP_UOM_DR ];

Property CSSDPNotUseFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", Required, SqlColumnNumber = 7, SqlFieldName = CSSDP_NotUseFlag ];

Property CSSDWorkCost As %Numeric [ InitialExpression = 0, Required, SqlColumnNumber = 8, SqlFieldName = CSSDP_WorkCost ];

Property CSSDPUnitPrice As %Numeric [ InitialExpression = 0, Required, SqlColumnNumber = 9, SqlFieldName = CSSDP_UnitPrice ];

Property CSSDPPackType As %String(COLLATION = "Exact", MAXLEN = 4, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = CSSDP_PackType ];

Property CSSDPPackPhoto As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = CSSDP_PackPhoto ];

Property CSSDPPackClass As User.CSSDPackageClass [ SqlColumnNumber = 12, SqlFieldName = CSSDP_PackClassdr ];

Property CSSDPWorkTimes As %Integer [ SqlColumnNumber = 13, SqlFieldName = CSSDP_WorkTimes ];

Property CSSDPPerSterCount As %Integer [ SqlColumnNumber = 14, SqlFieldName = CSSDP_PerSterCount ];

Property CSSDPPackTypeDetail As %Integer [ SqlColumnNumber = 15, SqlFieldName = CSSDP_PackTypeDetail ];

Property CSSDPPerCleanCount As %Integer [ SqlColumnNumber = 16, SqlFieldName = CSSDP_PerCleanCount ];

Property CSSDPVolumn As %Numeric [ SqlColumnNumber = 17, SqlFieldName = CSSDP_Volumn ];

Property CSSDPLOCDR As User.CTLoc [ SqlColumnNumber = 18, SqlFieldName = CSSDP_LOCDR ];

Property CSSDPRemark As %String(COLLATION = "Exact", MAXLEN = 2000) [ SqlColumnNumber = 19, SqlFieldName = CSSDP_Remark ];

Property CSSDPHospital As CTHospital [ SqlColumnNumber = 20, SqlFieldName = CSSDP_Hospital ];

Property CSSDPSterType As User.CSSDSterType [ SqlColumnNumber = 21, SqlFieldName = CSSDP_SterType ];

Property CSSDPZCompany As User.CSSDVen [ SqlColumnNumber = 22, SqlFieldName = CSSDP_ZCompany ];

Property CSSDPNotBioFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", Required, SqlColumnNumber = 23, SqlFieldName = CSSDP_NotBioFlag ];

/// 紧急价
Property CSSDPUrgentPrice As %Numeric [ InitialExpression = 0, SqlColumnNumber = 24, SqlFieldName = CSSDP_UrgentPrice ];

/// 180天包装价
Property CSSDPPackPrice As %Numeric [ InitialExpression = 0, SqlColumnNumber = 25, SqlFieldName = CSSDP_PackPrice ];

Property CSSDPCreateLocDr As User.CTLoc [ SqlColumnNumber = 26, SqlFieldName = CSSDP_CreateLocDr ];

/// 消毒包规格 大 中 小
Property CSSDPSpecDr As CT.STER.CSSD.PackageSpec [ SqlColumnNumber = 27, SqlFieldName = CSSDP_SpecDr ];

/// 器械数
Property CSSDPPackItmQty As %Integer [ SqlColumnNumber = 28, SqlFieldName = CSSDP_PackItmQty ];

/// 借包标志
Property CSSDPBorrowFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 29, SqlFieldName = CSSDP_BorrowFlag ];

Index CSSDPackageCodeIndex On CSSDPCode As Exact;

Index CSSDPackageDescIndex On CSSDPDesc As Exact;

Index CSSDPackageClassIndex On CSSDPPackClass As Exact;

Storage Default
{
<Data name="CSSDPackageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDPIsExt</Value>
</Value>
<Value name="3">
<Value>CSSDPAlias</Value>
</Value>
<Value name="4">
<Value>CSSDPCode</Value>
</Value>
<Value name="5">
<Value>CSSDPDesc</Value>
</Value>
<Value name="6">
<Value>CSSDPUom</Value>
</Value>
<Value name="7">
<Value>CSSDPNotUseFlag</Value>
</Value>
<Value name="8">
<Value>CSSDWorkCost</Value>
</Value>
<Value name="9">
<Value>CSSDPUnitPrice</Value>
</Value>
<Value name="10">
<Value>CSSDPPackPhoto</Value>
</Value>
<Value name="11">
<Value>CSSDPPackType</Value>
</Value>
<Value name="12">
<Value>CSSDPPackClass</Value>
</Value>
<Value name="13">
<Value>CSSDPWorkTimes</Value>
</Value>
<Value name="14">
<Value>CSSDPPerSterCount</Value>
</Value>
<Value name="15">
<Value>CSSDPPackTypeDetail</Value>
</Value>
<Value name="16">
<Value>CSSDPPerCleanCount</Value>
</Value>
<Value name="17">
<Value>CSSDPVolumn</Value>
</Value>
<Value name="18">
<Value>CSSDPLOCDR</Value>
</Value>
<Value name="19">
<Value>CSSDPRemark</Value>
</Value>
<Value name="20">
<Value>CSSDPHospital</Value>
</Value>
<Value name="21">
<Value>CSSDPSterType</Value>
</Value>
<Value name="22">
<Value>CSSDPZCompany</Value>
</Value>
<Value name="23">
<Value>CSSDPNotBioFlag</Value>
</Value>
<Value name="24">
<Value>CSSDPUrgentPrice</Value>
</Value>
<Value name="25">
<Value>CSSDPPackPrice</Value>
</Value>
<Value name="26">
<Value>CSSDPCreateLocDr</Value>
</Value>
<Value name="27">
<Value>CSSDPSpecDr</Value>
</Value>
<Value name="28">
<Value>CSSDPPackItmQty</Value>
</Value>
<Value name="29">
<Value>CSSDPBorrowFlag</Value>
</Value>
</Data>
<DataLocation>^User.CSSDPackageD</DataLocation>
<DefaultData>CSSDPackageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDPackageD</IdLocation>
<IndexLocation>^User.CSSDPackageI</IndexLocation>
<SqlRowIdName>CSSDP_Rowid</SqlRowIdName>
<StreamLocation>^User.CSSDPackageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
