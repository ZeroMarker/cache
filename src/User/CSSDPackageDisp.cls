/// 发放的表
Class User.CSSDPackageDisp Extends (%Persistent, User.Abstract) [ SqlRowIdName = CSSDPD_Rowid, SqlTableName = CSSD_PackageDisp ]
{

Property CSSDPDDate As %TimeStamp [ SqlColumnNumber = 2, SqlFieldName = CSSDPD_Date ];

Property CSSDPDFromLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = CSSDPD_FromLoc_DR ];

Property CSSDPDFromUserDr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = CSSDPD_FromUser_DR ];

Property CSSDPDLabel As %String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = CSSDPD_Label ];

Property CSSDPDQty As %String(COLLATION = "Exact") [ SqlColumnNumber = 7, SqlFieldName = CSSDPD_Qty ];

Property CSSDPDSerialNo As %String(COLLATION = "Exact") [ SqlColumnNumber = 8, SqlFieldName = CSSDPD_SerialNo ];

Property CSSDPDTime As %Time [ SqlColumnNumber = 9, SqlFieldName = CSSDPD_Time ];

Property CSSDPDToLocDr As User.CTLoc [ SqlColumnNumber = 10, SqlFieldName = CSSDPD_ToLoc_DR ];

Property CSSDPDToUserDr As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = CSSDPD_ToUser_DR ];

Property CSSDPDComplateFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 14, SqlFieldName = CSSDPD_ComplateFlag_DR ];

Property CSSDPDPackage As User.CSSDPackage [ SqlColumnNumber = 15, SqlFieldName = CSSDPD_Package_DR ];

Property CSSDPDDispUser As User.SSUser [ SqlColumnNumber = 16, SqlFieldName = CSSDPD_DispUser_DR ];

Property CSSDPDRecDate As %TimeStamp [ SqlColumnNumber = 17, SqlFieldName = CSSDPD_RecDate ];

Property CSSDPDPackageApplyDetail As User.CSSDPackageApplyDetail [ SqlColumnNumber = 19, SqlFieldName = CSSDPD_PackageApplyDetailDR ];

/// 手术护士从手术无菌间领包登记
Property CSSDPDInnurseDr As User.SSUser [ SqlColumnNumber = 22, SqlFieldName = CSSDPD_InnurseDr ];

Property CSSDPDInRegDate As %TimeStamp [ SqlColumnNumber = 23, SqlFieldName = CSSDPD_InRegDate ];

/// 手术护士从手术无菌间归还登记
Property CSSDPDInurBrDr As User.SSUser [ SqlColumnNumber = 24, SqlFieldName = CSSDPD_InurBrDr ];

Property CSSDPDInRegBrDate As %TimeStamp [ SqlColumnNumber = 25, SqlFieldName = CSSDPD_InRegBrDate ];

Property CSSDPDParrefDr As User.CSSDPackageDispMain [ SqlColumnNumber = 26, SqlFieldName = CSSDPD_Parref_DR ];

/// 新加回收明细表id用于生成发放单
Property CSSDPDPackageCallBackDetail As User.CSSDCallbackDetailNew [ SqlColumnNumber = 27, SqlFieldName = CSSDPD_CallBackDetailDR ];

/// 发放标签的数量新加
Property CSSDPDDispQty As %String(COLLATION = "Exact") [ SqlColumnNumber = 28, SqlFieldName = CSSDPD_DispQty ];

/// 包装材料
Property CSSDPDPackMaterial As User.CSSDMaterial [ SqlColumnNumber = 29, SqlFieldName = CSSDPD_PackMaterial ];

/// 未发放数量
Property CSSDPDUnDispQty As %String(COLLATION = "Exact") [ SqlColumnNumber = 30, SqlFieldName = CSSDPD_UnDispQty ];

/// 价格
Property CSSDPDDispPrice As %Numeric [ InitialExpression = 0, Required, SqlColumnNumber = 31, SqlFieldName = CSSDPD_DispPrice ];

Property CSSDPDTotalPrice As %Numeric [ InitialExpression = 0, Required, SqlColumnNumber = 32, SqlFieldName = CSSDPD_TotalPrice ];

/// 提醒回收提交人
Property CSSDPDBackComUser As User.SSUser [ SqlColumnNumber = 33, SqlFieldName = CSSDPD_BackComUser_DR ];

/// 需要回收提交标志
Property CSSDPDBackComFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No,C", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N,C") [ InitialExpression = "N", SqlColumnNumber = 34, SqlFieldName = CSSDPD_BackComFlag_DR ];

Property CSSDPDLevelFlag As %String(COLLATION = "Exact") [ SqlColumnNumber = 35, SqlFieldName = CSSDPD_LevelFlag ];

/// 明细扫码发放日期
Property CSSDPDDispDate As %Library.Date [ SqlColumnNumber = 36, SqlFieldName = CSSDPD_DispDate ];

/// 明细扫码发放时间
Property CSSDPDDispTime As %Library.Time [ SqlColumnNumber = 37, SqlFieldName = CSSDPD_DispTime ];

/// 明细扫码接收日期
Property CSSDPDReceiveDate As %Library.Date [ SqlColumnNumber = 38, SqlFieldName = CSSDPD_ReceiveDate ];

/// 明细扫码接收时间
Property CSSDPDReceiveTime As %Library.Time [ SqlColumnNumber = 39, SqlFieldName = CSSDPD_ReceiveTime ];

/// 明细扫码领用日期
Property CSSDPDUseDate As %Library.Date [ SqlColumnNumber = 40, SqlFieldName = CSSDPD_UseDate ];

/// 明细扫码领用时间
Property CSSDPDUseTime As %Library.Time [ SqlColumnNumber = 41, SqlFieldName = CSSDPD_UseTime ];

/// 明细扫码归还日期
Property CSSDPDReturnDate As %Library.Date [ SqlColumnNumber = 42, SqlFieldName = CSSDPD_ReturnDate ];

/// 明细扫码归还时间
Property CSSDPDReturnTime As %Library.Time [ SqlColumnNumber = 43, SqlFieldName = CSSDPD_ReturnTime ];

Index CSSDPDToLocCompleteFlag On (CSSDPDToLocDr As Exact, CSSDPDComplateFlag As Exact);

Index CSSDPDSerialNoLabel On (CSSDPDSerialNo As Exact, CSSDPDLabel As Exact);

Index CSSDPDLabel On CSSDPDLabel As Exact;

Index CSSDPDCParrefDr On CSSDPDParrefDr As Exact;

Index CSSDPDCallBackDetailIndex On CSSDPDPackageCallBackDetail As Exact;

Index CSSDPDParrefDrIndex On (CSSDPDParrefDr As Exact, CSSDPDPackage As Exact);

Storage Default
{
<Data name="CSSDPackageDispDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDPDDate</Value>
</Value>
<Value name="3">
<Value>CSSDPDFromLocDr</Value>
</Value>
<Value name="4">
<Value>CSSDPDFromUserDr</Value>
</Value>
<Value name="5">
<Value>CSSDPDLabel</Value>
</Value>
<Value name="6"/>
<Value name="7">
<Value>CSSDPDQty</Value>
</Value>
<Value name="8">
<Value>CSSDPDSerialNo</Value>
</Value>
<Value name="9">
<Value>CSSDPDTime</Value>
</Value>
<Value name="10">
<Value>CSSDPDToLocDr</Value>
</Value>
<Value name="11">
<Value>CSSDPDToUserDr</Value>
</Value>
<Value name="12"/>
<Value name="13"/>
<Value name="14">
<Value>CSSDPDComplateFlag</Value>
</Value>
<Value name="15">
<Value>CSSDPDPackage</Value>
</Value>
<Value name="16">
<Value>CSSDPDDispUser</Value>
</Value>
<Value name="17">
<Value>CSSDPDRecDate</Value>
</Value>
<Value name="18"/>
<Value name="19">
<Value>CSSDPDPackageApplyDetail</Value>
</Value>
<Value name="20"/>
<Value name="21"/>
<Value name="22">
<Value>CSSDPDInnurseDr</Value>
</Value>
<Value name="23">
<Value>CSSDPDInRegDate</Value>
</Value>
<Value name="24">
<Value>CSSDPDInurBrDr</Value>
</Value>
<Value name="25">
<Value>CSSDPDInRegBrDate</Value>
</Value>
<Value name="26">
<Value>CSSDPDParrefDr</Value>
</Value>
<Value name="27">
<Value>CSSDPDPackageCallBackDetail</Value>
</Value>
<Value name="28">
<Value>CSSDPDDispQty</Value>
</Value>
<Value name="29">
<Value>CSSDPDPackMaterial</Value>
</Value>
<Value name="30">
<Value>CSSDPDUnDispQty</Value>
</Value>
<Value name="31">
<Value>CSSDPDDispPrice</Value>
</Value>
<Value name="32">
<Value>CSSDPDTotalPrice</Value>
</Value>
<Value name="33">
<Value>CSSDPDBackComUser</Value>
</Value>
<Value name="34">
<Value>CSSDPDBackComFlag</Value>
</Value>
<Value name="35">
<Value>CSSDPDLevelFlag</Value>
</Value>
<Value name="36">
<Value>CSSDPDDispDate</Value>
</Value>
<Value name="37">
<Value>CSSDPDDispTime</Value>
</Value>
<Value name="38">
<Value>CSSDPDReceiveDate</Value>
</Value>
<Value name="39">
<Value>CSSDPDReceiveTime</Value>
</Value>
<Value name="40">
<Value>CSSDPDUseDate</Value>
</Value>
<Value name="41">
<Value>CSSDPDUseTime</Value>
</Value>
<Value name="42">
<Value>CSSDPDReturnDate</Value>
</Value>
<Value name="43">
<Value>CSSDPDReturnTime</Value>
</Value>
</Data>
<DataLocation>^User.CSSDPackageDispD</DataLocation>
<DefaultData>CSSDPackageDispDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDPackageDispD</IdLocation>
<IndexLocation>^User.CSSDPackageDispI</IndexLocation>
<SqlRowIdName>CSSDPD_Rowid</SqlRowIdName>
<StreamLocation>^User.CSSDPackageDispS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
