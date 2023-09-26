/// 消毒包申请主表
Class User.CSSDPackageApply Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_PackageApply ]
{

Property CSSDPACreateDate As %Date [ SqlColumnNumber = 3, SqlFieldName = CSSDPA_CreateDate ];

Property CSSDPADATE As %Library.TimeStamp [ SqlColumnNumber = 4, SqlFieldName = CSSDPA_DATE ];

Property CSSDPANO As %String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CSSDPA_NO ];

Property CSSDPALOCDR As User.CTLoc [ Required, SqlColumnNumber = 6, SqlFieldName = CSSDPA_LOCDR ];

Property CSSDPAAPPLYLOCDR As User.CTLoc [ Required, SqlColumnNumber = 7, SqlFieldName = CSSDPA_APPLYLOCDR ];

Property CSSDPAAPPLYUSERDR As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = CSSDPA_APPLYUSERDR ];

Property CSSDPAFlag As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = CSSDPA_Flag ];

Property CSSDPABackDateTime As %TimeStamp [ SqlColumnNumber = 10, SqlFieldName = CSSDPA_BackDateTime ];

Property CSSDPACreateUser As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = CSSDPA_CreateUser ];

Property CSSDPAIsBack As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = CSSDPA_IsBack ];

Property CSSDPAIsSend As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = CSSDPA_IsSend ];

Property CSSDPAReqLevel As %Integer [ SqlColumnNumber = 14, SqlFieldName = CSSDPA_ReqLevel ];

Property CSSDPASendDateTime As %TimeStamp [ SqlColumnNumber = 15, SqlFieldName = CSSDPA_SendDateTime ];

Property CSSDPASenderDR As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = CSSDPA_SenderDR ];

Property CSSDPAType As %Integer [ SqlColumnNumber = 17, SqlFieldName = CSSDPA_Type ];

Property CSSDPAUseDate As %Date [ SqlColumnNumber = 18, SqlFieldName = CSSDPA_UseDate ];

Property CSSDPAYearMonth As %String(COLLATION = "Exact") [ SqlColumnNumber = 19, SqlFieldName = CSSDPA_YearMonth ];

Property CSSDPAIsCount As %String(COLLATION = "Exact", TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = CSSDPA_IsCount ];

Property CSSDPASendTime As %Time [ SqlColumnNumber = 21, SqlFieldName = CSSDPA_SendTime ];

/// 新加医院字段
Property CSSDPAHospital As User.CTHospital [ SqlColumnNumber = 23, SqlFieldName = CSSDPA_Hospital ];

/// 新加拒绝原因字段
Property CSSDPARefuseReason As %String(COLLATION = "Exact") [ SqlColumnNumber = 24, SqlFieldName = CSSDPA_RefuseReason ];

/// 请领单据提交日期
Property CSSDPASubmitDate As %Library.Date [ SqlColumnNumber = 25, SqlFieldName = CSSDPA_SubmitDate ];

/// 请领单据提交时间
Property CSSDPASubmitTime As %Library.Time [ SqlColumnNumber = 26, SqlFieldName = CSSDPA_SubmitTime ];

/// 归还单关联借包单
Property CSSDPALendNO As %String(COLLATION = "Exact") [ SqlColumnNumber = 27, SqlFieldName = CSSDPA_LendNO ];

/// 感染标志
Property CSSDPABeInfected As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 28, SqlFieldName = CSSDPA_BeInfected ];

/// 消毒包分类id
Property CSSDPAPackageClassDr As User.CSSDPackageClass [ SqlColumnNumber = 29, SqlFieldName = CSSDPA_PackageClassDr ];

/// 备注
Property CSSDPARemark As %String(COLLATION = "Exact") [ SqlColumnNumber = 30, SqlFieldName = CSSDPA_Remark ];

Index IndexApplyLocDate On (CSSDPAAPPLYLOCDR As Exact, CSSDPADATE As Exact);

Index IndexAPPLYLOC On CSSDPAAPPLYLOCDR As Exact;

Index IndexNO On CSSDPANO As Exact;

Index IndexCSSDPADATE On CSSDPADATE As Exact;

Index IndexApplyLocDateFlag On (CSSDPAAPPLYLOCDR As Exact, CSSDPADATE As Exact, CSSDPAFlag As Exact);

Index IndexApplyLocDrType On (CSSDPAAPPLYLOCDR As Exact, CSSDPAType As Exact);

Index IndexLendNO On CSSDPALendNO As Exact;

Index LocDate On (CSSDPAAPPLYLOCDR As Exact, CSSDPACreateDate As Exact);

Storage Default
{
<Data name="CSSDPackageApplyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2"/>
<Value name="3">
<Value>CSSDPACreateDate</Value>
</Value>
<Value name="4">
<Value>CSSDPADATE</Value>
</Value>
<Value name="5">
<Value>CSSDPANO</Value>
</Value>
<Value name="6">
<Value>CSSDPALOCDR</Value>
</Value>
<Value name="7">
<Value>CSSDPAAPPLYLOCDR</Value>
</Value>
<Value name="8">
<Value>CSSDPAAPPLYUSERDR</Value>
</Value>
<Value name="9">
<Value>CSSDPAFlag</Value>
</Value>
<Value name="10">
<Value>CSSDPABackDateTime</Value>
</Value>
<Value name="11">
<Value>CSSDPACreateUser</Value>
</Value>
<Value name="12">
<Value>CSSDPAIsBack</Value>
</Value>
<Value name="13">
<Value>CSSDPAIsSend</Value>
</Value>
<Value name="14">
<Value>CSSDPAReqLevel</Value>
</Value>
<Value name="15">
<Value>CSSDPASendDateTime</Value>
</Value>
<Value name="16">
<Value>CSSDPASenderDR</Value>
</Value>
<Value name="17">
<Value>CSSDPAType</Value>
</Value>
<Value name="18">
<Value>CSSDPAUseDate</Value>
</Value>
<Value name="19">
<Value>CSSDPAYearMonth</Value>
</Value>
<Value name="20">
<Value>CSSDPAIsCount</Value>
</Value>
<Value name="21">
<Value>CSSDPASendTime</Value>
</Value>
<Value name="22"/>
<Value name="23">
<Value>CSSDPAHospital</Value>
</Value>
<Value name="24">
<Value>CSSDPARefuseReason</Value>
</Value>
<Value name="25">
<Value>CSSDPASubmitDate</Value>
</Value>
<Value name="26">
<Value>CSSDPASubmitTime</Value>
</Value>
<Value name="27">
<Value>CSSDPALendNO</Value>
</Value>
<Value name="28">
<Value>CSSDPABeInfected</Value>
</Value>
<Value name="29">
<Value>CSSDPAPackageClassDr</Value>
</Value>
<Value name="30">
<Value>CSSDPARemark</Value>
</Value>
</Data>
<DataLocation>^User.CSSDPackageApplyD</DataLocation>
<DefaultData>CSSDPackageApplyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDPackageApplyD</IdLocation>
<IndexLocation>^User.CSSDPackageApplyI</IndexLocation>
<StreamLocation>^User.CSSDPackageApplyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
