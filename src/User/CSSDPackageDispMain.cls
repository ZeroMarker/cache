/// 发放主表
Class User.CSSDPackageDispMain Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_PackageDispMain ]
{

Property CSSDPDMFromLocDr As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = CSSDPDM_FromLoc_DR ];

Property CSSDPDMFromUserDr As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = CSSDPDM_FromUser_DR ];

Property CSSDPDMSerialNo As %String(COLLATION = "Exact", TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = CSSDPDM_SerialNo ];

Property CSSDPDMDispUser As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = CSSDPDM_DispUser_DR ];

Property CSSDPDMDate As %TimeStamp [ SqlColumnNumber = 6, SqlFieldName = CSSDPDM_Date ];

Property CSSDPDMToLocDr As User.CTLoc [ SqlColumnNumber = 7, SqlFieldName = CSSDPDM_ToLoc_DR ];

Property CSSDPDMToUserDr As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = CSSDPDM_ToUser_DR ];

Property CSSDPDMComplateFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 9, SqlFieldName = CSSDPDM_ComplateFlag ];

Property CSSDPDMRecDate As %TimeStamp [ SqlColumnNumber = 10, SqlFieldName = CSSDPDM_RecDate ];

Property CSSDPDMHospital As CTHospital [ SqlColumnNumber = 11, SqlFieldName = CSSDPDM_Hospital ];

Property CSSDPDMType As %String(COLLATION = "Exact") [ SqlColumnNumber = 12, SqlFieldName = CSSDPDM_Type ];

Property CSSDPDMCHKDate As %TimeStamp [ SqlColumnNumber = 13, SqlFieldName = CSSDPDM_CHKDate ];

Property CSSDPDMCHKUserDr As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = CSSDPDM_CHKUser_DR ];

/// 是否接收
Property CSSDPDMIsRec As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 15, SqlFieldName = CSSDPDM_IsRec ];

Property CSSDPDMRecStatu As %String(COLLATION = "Exact") [ SqlColumnNumber = 16, SqlFieldName = CSSDPDM_RecStatu ];

Property CSSDPDMReqLevel As %Integer [ SqlColumnNumber = 17, SqlFieldName = CSSDPDM_ReqLevel ];

/// 单据发放日期
Property CSSDPDMDispDate As %Library.Date [ SqlColumnNumber = 18, SqlFieldName = CSSDPDM_DispDate ];

/// 单据发放时间
Property CSSDPDMDispTime As %Library.Time [ SqlColumnNumber = 19, SqlFieldName = CSSDPDM_DispTime ];

/// 单据接收日期
Property CSSDPDMReceiveDate As %Library.Date [ SqlColumnNumber = 20, SqlFieldName = CSSDPDM_ReceiveDate ];

/// 单据接收时间
Property CSSDPDMReceiveTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = CSSDPDM_ReceiveTime ];

/// 单据提交日期
Property CSSDPDMSubmitDate As %Library.Date [ SqlColumnNumber = 22, SqlFieldName = CSSDPDM_SubmitDate ];

/// 单据提交时间
Property CSSDPDMSubmitTime As %Library.Time [ SqlColumnNumber = 23, SqlFieldName = CSSDPDM_SubmitTime ];

/// 关联回收主表
Property CSSDPDMCallBackDr As User.CSSDPackageCallback [ SqlColumnNumber = 24, SqlFieldName = CSSDPDM_CallBackDr ];

/// 单据类型 1调拨类型发放单 其他发放单
Property CSSDPDMDocType As %String(COLLATION = "Exact") [ SqlColumnNumber = 25, SqlFieldName = CSSDPDM_DocType ];

Index CSSDPDMSerialNoIndex On CSSDPDMSerialNo As Exact;

Index CSSDPDMCSSDPDMDateIndex On CSSDPDMDate As Exact;

Index DocTypeDate On (CSSDPDMDocType As Exact, CSSDPDMDispDate As Exact);

Index CSSDPDMCallBackIndex On CSSDPDMCallBackDr As Exact;

Index DispDateIndex On CSSDPDMDispDate As Exact;

Storage Default
{
<Data name="CSSDPackageDispMainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDPDMFromLocDr</Value>
</Value>
<Value name="3">
<Value>CSSDPDMFromUserDr</Value>
</Value>
<Value name="4">
<Value>CSSDPDMSerialNo</Value>
</Value>
<Value name="5">
<Value>CSSDPDMDispUser</Value>
</Value>
<Value name="6">
<Value>CSSDPDMDate</Value>
</Value>
<Value name="7">
<Value>CSSDPDMToLocDr</Value>
</Value>
<Value name="8">
<Value>CSSDPDMToUserDr</Value>
</Value>
<Value name="9">
<Value>CSSDPDMComplateFlag</Value>
</Value>
<Value name="10">
<Value>CSSDPDMRecDate</Value>
</Value>
<Value name="11">
<Value>CSSDPDMHospital</Value>
</Value>
<Value name="12">
<Value>CSSDPDMType</Value>
</Value>
<Value name="13">
<Value>CSSDPDMCHKDate</Value>
</Value>
<Value name="14">
<Value>CSSDPDMCHKUserDr</Value>
</Value>
<Value name="15">
<Value>CSSDPDMIsRec</Value>
</Value>
<Value name="16">
<Value>CSSDPDMRecStatu</Value>
</Value>
<Value name="17">
<Value>CSSDPDMReqLevel</Value>
</Value>
<Value name="18">
<Value>CSSDPDMDispDate</Value>
</Value>
<Value name="19">
<Value>CSSDPDMDispTime</Value>
</Value>
<Value name="20">
<Value>CSSDPDMReceiveDate</Value>
</Value>
<Value name="21">
<Value>CSSDPDMReceiveTime</Value>
</Value>
<Value name="22">
<Value>CSSDPDMSubmitDate</Value>
</Value>
<Value name="23">
<Value>CSSDPDMSubmitTime</Value>
</Value>
<Value name="24">
<Value>CSSDPDMCallBackDr</Value>
</Value>
<Value name="25">
<Value>CSSDPDMDocType</Value>
</Value>
</Data>
<DataLocation>^User.CSSDPackageDispMainD</DataLocation>
<DefaultData>CSSDPackageDispMainDefaultData</DefaultData>
<IdLocation>^User.CSSDPackageDispMainD</IdLocation>
<IndexLocation>^User.CSSDPackageDispMainI</IndexLocation>
<StreamLocation>^User.CSSDPackageDispMainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
