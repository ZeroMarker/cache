Class User.CSSDPackageApplyDetail Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_PackageApplyDetail ]
{

Property CSSDPADParref As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CSSDPAD_Parref ];

Property CSSDPADPackageDr As User.CSSDPackage [ SqlColumnNumber = 4, SqlFieldName = CSSDPAD_PackageDr ];

Property CSSDPADQty As %Integer [ SqlColumnNumber = 5, SqlFieldName = CSSDPAD_Qty ];

Property CSSDPADUseDate As %Date [ SqlColumnNumber = 6, SqlFieldName = CSSDPAD_UseDate ];

Property CSSDPADFlag As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = CSSDPAD_Flag ];

Property CSSDPADBackQty As %Integer [ SqlColumnNumber = 8, SqlFieldName = CSSDPAD_BackQty ];

Property CSSDPADOutQty As %Integer [ SqlColumnNumber = 9, SqlFieldName = CSSDPAD_OutQty ];

Property CSSDPADPackLBL As %String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = CSSDPAD_PackLBL ];

Property CSSDPADReqQty As %Integer [ SqlColumnNumber = 11, SqlFieldName = CSSDPAD_ReqQty ];

Property CSSDPADDesc As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = CSSDPAD_Desc ];

Property CSSDPADPrice As %String(COLLATION = "Exact") [ SqlColumnNumber = 13, SqlFieldName = CSSDPAD_Price ];

Property CSSDPADZCompany As User.CSSDVen [ SqlColumnNumber = 15, SqlFieldName = CSSDPAD_ZCompanyDr ];

/// 紧急
Property CSSDPADZExpress As %String(COLLATION = "Exact") [ SqlColumnNumber = 16, SqlFieldName = CSSDPAD_ZExpress ];

/// 植入物
Property CSSDPADZRW As %String(COLLATION = "Exact") [ SqlColumnNumber = 17, SqlFieldName = CSSDPAD_ZRW ];

/// 外来器械使用科室
Property CSSDPADUseDept As User.CTLoc [ SqlColumnNumber = 18, SqlFieldName = CSSDPAD_UseDept ];

/// 二次回收标志信息
Property CSSDPADZReWash As %String(COLLATION = "Exact") [ SqlColumnNumber = 19, SqlFieldName = CSSDPAD_ZReWash ];

Property CSSDPADZReWashDr As User.SSUser [ SqlColumnNumber = 20, SqlFieldName = CSSDPAD_ZReWashDr ];

Property CSSDPADZReWashDate As %TimeStamp [ SqlColumnNumber = 21, SqlFieldName = CSSDPAD_ZReWashDate ];

/// 是否清洗
Property CSSDPADISCLEAN As %String(COLLATION = "Exact") [ SqlColumnNumber = 22, SqlFieldName = CSSDPAD_ISCLEAN ];

/// 供应室反馈给手术设备的信息
Property CSSDPADRemark As %String(COLLATION = "Exact") [ SqlColumnNumber = 23, SqlFieldName = CSSDPAD_Remark ];

/// 包装材料字典
Property CSSDPADMaterialDR As User.CSSDMaterial [ SqlColumnNumber = 24, SqlFieldName = CSSDPAD_Material_DR ];

/// 感染标志
Property CSSDPADBeInfected As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 25, SqlFieldName = CSSDPAD_BeInfected ];

/// 明细确认标志
Property CSSDPADRecycConfirmFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 26, SqlFieldName = CSSDPAD_RecycConfirmFlag ];

/// 感染详情
Property CSSDPADInfectRemark As %String(COLLATION = "Exact") [ SqlColumnNumber = 27, SqlFieldName = CSSDPAD_InfectRemark ];

/// 标签号
Property CSSDPADBarCode As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = CSSDPAD_BarCode ];

Index CSSDPADParrefIndex On CSSDPADParref As Exact;

Index CSSDPADApplyNoReqQtyIndex On (CSSDPADParref As Exact, CSSDPADReqQty As Exact);

Index CSSDPADApplyNoFlagIndex On (CSSDPADParref As Exact, CSSDPADFlag As Exact);

Index CSSDPADParrefPackageDrIndex On (CSSDPADParref As Exact, CSSDPADPackageDr As Exact);

Index CSSDPADPackageDrIndex On CSSDPADPackageDr As Exact;

Index ParrefBarCodeIndex On (CSSDPADParref As Exact, CSSDPADBarCode As Exact);

Index BarCodeParref On (CSSDPADBarCode As Exact, CSSDPADParref As Exact);

Storage Default
{
<Data name="CSSDPackageApplyDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2"/>
<Value name="3">
<Value>CSSDPADParref</Value>
</Value>
<Value name="4">
<Value>CSSDPADPackageDr</Value>
</Value>
<Value name="5">
<Value>CSSDPADQty</Value>
</Value>
<Value name="6">
<Value>CSSDPADUseDate</Value>
</Value>
<Value name="7">
<Value>CSSDPADFlag</Value>
</Value>
<Value name="8">
<Value>CSSDPADBackQty</Value>
</Value>
<Value name="9">
<Value>CSSDPADOutQty</Value>
</Value>
<Value name="10">
<Value>CSSDPADPackLBL</Value>
</Value>
<Value name="11">
<Value>CSSDPADReqQty</Value>
</Value>
<Value name="12">
<Value>CSSDPADDesc</Value>
</Value>
<Value name="13">
<Value>CSSDPADPrice</Value>
</Value>
<Value name="14"/>
<Value name="15">
<Value>CSSDPADZCompany</Value>
</Value>
<Value name="16">
<Value>CSSDPADZExpress</Value>
</Value>
<Value name="17">
<Value>CSSDPADZRW</Value>
</Value>
<Value name="18">
<Value>CSSDPADUseDept</Value>
</Value>
<Value name="19">
<Value>CSSDPADZReWash</Value>
</Value>
<Value name="20">
<Value>CSSDPADZReWashDr</Value>
</Value>
<Value name="21">
<Value>CSSDPADZReWashDate</Value>
</Value>
<Value name="22">
<Value>CSSDPADISCLEAN</Value>
</Value>
<Value name="23">
<Value>CSSDPADRemark</Value>
</Value>
<Value name="24">
<Value>CSSDPADMaterialDR</Value>
</Value>
<Value name="25">
<Value>CSSDPADBeInfected</Value>
</Value>
<Value name="26">
<Value>CSSDPADRecycConfirmFlag</Value>
</Value>
<Value name="27">
<Value>CSSDPADInfectRemark</Value>
</Value>
<Value name="28">
<Value>CSSDPADBarCode</Value>
</Value>
</Data>
<DataLocation>^User.CSSDPackageApplyDetailD</DataLocation>
<DefaultData>CSSDPackageApplyDetailDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDPackageApplyDetailD</IdLocation>
<IndexLocation>^User.CSSDPackageApplyDetailI</IndexLocation>
<StreamLocation>^User.CSSDPackageApplyDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
