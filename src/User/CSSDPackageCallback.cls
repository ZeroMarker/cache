Class User.CSSDPackageCallback Extends (%Persistent, User.Abstract) [ SqlRowIdName = CSSDPC_Rowid, SqlTableName = CSSD_PackageCallback ]
{

Property CSSDPCDate As %Date [ SqlColumnNumber = 2, SqlFieldName = CSSDPC_Date ];

Property CSSDPCFromLocDr As User.CTLoc [ SqlColumnNumber = 3, SqlFieldName = CSSDPC_FromLoc_DR ];

Property CSSDPCFromUserDr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = CSSDPC_FromUser_DR ];

Property CSSDPCSerialNo As %String(COLLATION = "Exact", TRUNCATE = 1) [ Required, SqlColumnNumber = 8, SqlFieldName = CSSDPC_SerialNo ];

Property CSSDPCTime As %Time [ SqlColumnNumber = 9, SqlFieldName = CSSDPC_Time ];

Property CSSDPCToLocDr As User.CTLoc [ SqlColumnNumber = 10, SqlFieldName = CSSDPC_ToLoc_DR ];

Property CSSDPCToUserDr As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = CSSDPC_ToUser_DR ];

Property CSSDPCAckDate As %Date [ SqlColumnNumber = 12, SqlFieldName = CSSDPC_AckDate ];

Property CSSDPCAckUserDr As User.SSUser [ SqlColumnNumber = 13, SqlFieldName = CSSDPC_AckUser_DR ];

/// Y提交;N未提交;W用于非循环包借包查看
Property CSSDPCComplateFlag As %String(COLLATION = "Exact") [ SqlColumnNumber = 14, SqlFieldName = CSSDPC_ComplateFlag ];

Property CSSDPCPackage As User.CSSDPackage [ SqlColumnNumber = 16, SqlFieldName = CSSDPC_Package_DR ];

/// 消毒包标签号
Property CSSDPCPackageLabel As %String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = CSSDPC_PackageLabel ];

/// 申请单id
Property CSSDPCPackageApplyDetailDR As User.CSSDPackageApplyDetail [ SqlColumnNumber = 18, SqlFieldName = CSSDPC_PackageApplyDetailDR ];

/// 清点分类
Property CSSDPCBillFlag As %String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = CSSDPC_BillFlag ];

Property CSSDPCISOPRFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 20, SqlFieldName = CSSDPC_ISOPRFlag ];

Property CSSDPCAckTime As %Time [ SqlColumnNumber = 21, SqlFieldName = CSSDPC_AckTime ];

/// 是否生成发放单标志
Property CSSDPCIsDispFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 22, SqlFieldName = CSSDPC_IsDispFlag ];

/// 单据类型why新加
Property CSSDPCApplyType As %String(COLLATION = "Exact", TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = CSSDPC_ApplyType ];

/// 请领单主表Id  wb新加(借包单用)
Property CSSDPCPackageApplyDR As User.CSSDPackageApply [ SqlColumnNumber = 24, SqlFieldName = CSSDPC_PackageApplyDR ];

/// 请领单备注信息
Property CSSDPCRemark As %String(COLLATION = "Exact") [ SqlColumnNumber = 25, SqlFieldName = CSSDPC_Remark ];

Property CSSDPCReqLevel As %Integer [ SqlColumnNumber = 26, SqlFieldName = CSSDPC_ReqLevel ];

Property CSSDPCLendNO As %String(COLLATION = "Exact") [ SqlColumnNumber = 27, SqlFieldName = CSSDPC_LendNO ];

Property CSSDPCConfirmDate As %Date [ SqlColumnNumber = 28, SqlFieldName = CSSDPC_ConfirmDate ];

Property CSSDPCConfirmTime As %Time [ SqlColumnNumber = 29, SqlFieldName = CSSDPC_ConfirmTime ];

Property CSSDPCConfirmFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 30, SqlFieldName = CSSDPC_ConfirmFlag ];

Property CSSDPCConfirmUserDr As User.SSUser [ SqlColumnNumber = 31, SqlFieldName = CSSDPC_ConfirmUser_DR ];

Index CSSDPCSerialNoIndex On CSSDPCSerialNo As Exact;

Index CSSDPCDateToLoc On (CSSDPCDate As Exact, CSSDPCToLocDr As Exact);

Index IndexLocComplete On (CSSDPCToLocDr As Exact, CSSDPCComplateFlag As Exact);

Index CSSDAckDateToLoc On (CSSDPCAckDate As Exact, CSSDPCToLocDr As Exact);

Index CSSDPCPackageApplyIndex On CSSDPCPackageApplyDR As Exact;

Index CSSDPCApplyComplateIndex On (CSSDPCLendNO As Exact, CSSDPCComplateFlag As Exact);

Index CSSDPCLendNOIndex On CSSDPCLendNO As Exact;

Index CSSDPCAckDateFromLocDrIndex On (CSSDPCAckDate As Exact, CSSDPCFromLocDr As Exact);

Index CSSDPCAckDateIndex On CSSDPCAckDate As Exact;

Index CSSDPCLocCompleteIndex On (CSSDPCToLocDr As Exact, CSSDPCFromLocDr As Exact, CSSDPCComplateFlag As Exact);

Index ApplyDRComplateIndex On (CSSDPCPackageApplyDR As Exact, CSSDPCComplateFlag As Exact);

Storage Default
{
<Data name="CSSDPackageCallbackDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDPCDate</Value>
</Value>
<Value name="3">
<Value>CSSDPCFromLocDr</Value>
</Value>
<Value name="4">
<Value>CSSDPCFromUserDr</Value>
</Value>
<Value name="5"/>
<Value name="6"/>
<Value name="7"/>
<Value name="8">
<Value>CSSDPCSerialNo</Value>
</Value>
<Value name="9">
<Value>CSSDPCTime</Value>
</Value>
<Value name="10">
<Value>CSSDPCToLocDr</Value>
</Value>
<Value name="11">
<Value>CSSDPCToUserDr</Value>
</Value>
<Value name="12">
<Value>CSSDPCAckDate</Value>
</Value>
<Value name="13">
<Value>CSSDPCAckUserDr</Value>
</Value>
<Value name="14">
<Value>CSSDPCComplateFlag</Value>
</Value>
<Value name="15"/>
<Value name="16">
<Value>CSSDPCPackage</Value>
</Value>
<Value name="17">
<Value>CSSDPCPackageLabel</Value>
</Value>
<Value name="18">
<Value>CSSDPCPackageApplyDetailDR</Value>
</Value>
<Value name="19">
<Value>CSSDPCBillFlag</Value>
</Value>
<Value name="20">
<Value>CSSDPCISOPRFlag</Value>
</Value>
<Value name="21">
<Value>CSSDPCAckTime</Value>
</Value>
<Value name="22">
<Value>CSSDPCIsDispFlag</Value>
</Value>
<Value name="23">
<Value>CSSDPCApplyType</Value>
</Value>
<Value name="24">
<Value>CSSDPCPackageApplyDR</Value>
</Value>
<Value name="25">
<Value>CSSDPCRemark</Value>
</Value>
<Value name="26">
<Value>CSSDPCReqLevel</Value>
</Value>
<Value name="27">
<Value>CSSDPCLendNO</Value>
</Value>
<Value name="28">
<Value>CSSDPCConfirmDate</Value>
</Value>
<Value name="29">
<Value>CSSDPCConfirmTime</Value>
</Value>
<Value name="30">
<Value>CSSDPCConfirmFlag</Value>
</Value>
<Value name="31">
<Value>CSSDPCConfirmUserDr</Value>
</Value>
</Data>
<DataLocation>^User.CSSDPackageCallbackD</DataLocation>
<DefaultData>CSSDPackageCallbackDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDPackageCallbackD</IdLocation>
<IndexLocation>^User.CSSDPackageCallbackI</IndexLocation>
<SqlRowIdName>CSSDPC_Rowid</SqlRowIdName>
<StreamLocation>^User.CSSDPackageCallbackS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
