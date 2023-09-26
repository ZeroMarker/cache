/// 配包-插一条记录，
Class User.CSSDTrans Extends (%Persistent, User.Abstract) [ SqlRowIdName = CSSDT_Rowid, SqlTableName = CSSD_Trans ]
{

Property CSSDTLabel As %String(COLLATION = "Exact") [ Required, SqlColumnNumber = 5, SqlFieldName = CSSDT_Label ];

/// 当前科室
Property CSSDTCurrLocDR As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = CSSDT_CurrLoc_DR ];

/// 'C':回收、'D'：发放、 'P'：打包、 'R'：接收、 'S'、灭菌、 'U'：使用 、'TC':过期处理
Property CSSDTStatus As %String(COLLATION = "Exact") [ SqlColumnNumber = 8, SqlFieldName = CSSDT_Status ];

/// 关联回收子表dr（本次清洗记录所关联的回收）
Property CSSDTPreCallBackDetailDR As User.CSSDCallbackDetailNew [ SqlColumnNumber = 9, SqlFieldName = CSSDT_PreCallBackDetail_DR ];

Property CSSDTUpdateDate As %Library.Date [ SqlColumnNumber = 10, SqlFieldName = CSSDT_UpdateDate ];

Property CSSDTUpdateTime As %Time [ SqlColumnNumber = 11, SqlFieldName = CSSDT_UpdateTime ];

/// 过期日期
Property CSSDTExpDate As %Library.Date [ SqlColumnNumber = 12, SqlFieldName = CSSDT_ExpDate ];

/// 关联回收主表dr（发放后回收）
Property CSSDTCallBack As User.CSSDPackageCallback [ SqlColumnNumber = 13, SqlFieldName = CSSDT_CallBack_DR ];

/// 关联发放表dr
Property CSSDTDisp As User.CSSDPackageDisp [ SqlColumnNumber = 14, SqlFieldName = CSSDT_Disp_DR ];

/// 关联打包表dr
Property CSSDTPack As User.CSSDPackagePack [ SqlColumnNumber = 15, SqlFieldName = CSSDT_Pack_DR ];

Property CSSDTPackage As User.CSSDPackage [ Required, SqlColumnNumber = 16, SqlFieldName = CSSDT_Package_DR ];

/// 当前最新灭菌dr
Property CSSDTSterilize As User.CSSDPackageSterilize [ SqlColumnNumber = 17, SqlFieldName = CSSDT_Sterilize_DR ];

Property CSSDTClean As User.CSSDCleanDetailPacks [ SqlColumnNumber = 19, SqlFieldName = CSSDT_Clean_DR ];

/// 生成该记录的日期,即标签生成日期
Property CSSDTDate As %Library.Date [ SqlColumnNumber = 20, SqlFieldName = CSSDT_Date ];

/// 生成该记录的时间,即标签生成的时间
Property CSSDTTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = CSSDT_Time ];

/// 关联回收子表dr（发放后回收）
Property CSSDTCallBackDetail As User.CSSDCallbackDetailNew [ SqlColumnNumber = 22, SqlFieldName = CSSDT_CallBackDetail_DR ];

/// 该标签所有灭菌数据dr，不合格、合格
Property CSSDTAllSterilize As %String(COLLATION = "Exact") [ SqlColumnNumber = 23, SqlFieldName = CSSDT_AllSterilize ];

/// 过期处理日期
Property CSSDTExpDealDate As %Library.Date [ SqlColumnNumber = 24, SqlFieldName = CSSDT_ExpDealDate ];

/// 过期处理时间
Property CSSDTExpDealTime As %Library.Time [ SqlColumnNumber = 25, SqlFieldName = CSSDT_ExpDealTime ];

Property CSSDTExpDealUserDr As User.SSUser [ SqlColumnNumber = 26, SqlFieldName = CSSDT_ExpDealUser_DR ];

/// 过期处理重新清洗明细
Property CSSDTExpDealCleanDetailDr As User.CSSDCleanDetailPacks [ SqlColumnNumber = 27, SqlFieldName = CSSDT_ExpDealCleanDetailDr ];

/// 关联调拨表dr(与发放一个表)
Property CSSDTTrfDR As User.CSSDPackageDisp [ SqlColumnNumber = 28, SqlFieldName = CSSDT_Trf_DR ];

Property CSSDTCodeDictDR As User.CSSDCodeDict [ SqlColumnNumber = 29, SqlFieldName = CSSDT_CodeDict_DR ];

Property CSSDTCodeDict As %String(COLLATION = "Exact") [ SqlColumnNumber = 30, SqlFieldName = CSSDT_CodeDict ];

Index IndexCSSDTDate On CSSDTDate As Exact;

Index IndexDate On CSSDTUpdateDate As Exact;

Index IndexCSSDTPack On CSSDTPack As Exact;

Index IndexCSSDTSterilize On CSSDTSterilize As Exact;

Index IndexCSSDTCallBack On CSSDTCallBack As Exact;

Index IndexCSSDTDisp On CSSDTDisp As Exact;

Index CSSDTLabelDate On (CSSDTLabel As Exact, CSSDTUpdateDate As Exact);

Index CSSDTLabelStatus On (CSSDTLabel As Exact, CSSDTStatus As Exact);

Index IndexCSSDTStatus On CSSDTStatus As Exact;

Index CSSDTCallbackPackageIndex On (CSSDTCallBack As Exact, CSSDTPackage As Exact);

Index CSSDTLabel On CSSDTLabel As Exact;

Index CSSDTPackageIndex On CSSDTPackage As Exact;

Index CSSDTExpDealDateIndex On CSSDTExpDealDate As Exact;

Index Trf On CSSDTTrfDR As Exact;

Index CallBackItm On CSSDTCallBackDetail As Exact;

Index CodeDictDR On CSSDTCodeDictDR As Exact;

Index CodeDict On CSSDTCodeDict As Exact;

Index LocLabel On (CSSDTCurrLocDR As Exact, CSSDTLabel As Exact);

Index DateLocLabel On (CSSDTDate As Exact, CSSDTCurrLocDR As Exact, CSSDTLabel As Exact);

Index PreCallBackItm On CSSDTPreCallBackDetailDR As Exact;

Storage Default
{
<Data name="CSSDTransDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="5">
<Value>CSSDTLabel</Value>
</Value>
<Value name="6">
<Value>CSSDTCurrLocDR</Value>
</Value>
<Value name="8">
<Value>CSSDTStatus</Value>
</Value>
<Value name="9">
<Value>CSSDTPreCallBackDetailDR</Value>
</Value>
<Value name="10">
<Value>CSSDTUpdateDate</Value>
</Value>
<Value name="11">
<Value>CSSDTUpdateTime</Value>
</Value>
<Value name="12">
<Value>CSSDTExpDate</Value>
</Value>
<Value name="13">
<Value>CSSDTCallBack</Value>
</Value>
<Value name="14">
<Value>CSSDTDisp</Value>
</Value>
<Value name="15">
<Value>CSSDTPack</Value>
</Value>
<Value name="16">
<Value>CSSDTPackage</Value>
</Value>
<Value name="17">
<Value>CSSDTSterilize</Value>
</Value>
<Value name="19">
<Value>CSSDTClean</Value>
</Value>
<Value name="20">
<Value>CSSDTDate</Value>
</Value>
<Value name="21">
<Value>CSSDTTime</Value>
</Value>
<Value name="22">
<Value>CSSDTCallBackDetail</Value>
</Value>
<Value name="23">
<Value>CSSDTAllSterilize</Value>
</Value>
<Value name="24">
<Value>CSSDTExpDealDate</Value>
</Value>
<Value name="25">
<Value>CSSDTExpDealTime</Value>
</Value>
<Value name="26">
<Value>CSSDTExpDealUserDr</Value>
</Value>
<Value name="27">
<Value>CSSDTExpDealCleanDetailDr</Value>
</Value>
<Value name="28">
<Value>CSSDTTrfDR</Value>
</Value>
<Value name="29">
<Value>CSSDTCodeDictDR</Value>
</Value>
<Value name="30">
<Value>CSSDTCodeDict</Value>
</Value>
</Data>
<DataLocation>^User.CSSDTransD</DataLocation>
<DefaultData>CSSDTransDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.CSSDTransD</IdLocation>
<IndexLocation>^User.CSSDTransI</IndexLocation>
<SqlRowIdName>CSSDT_Rowid</SqlRowIdName>
<StreamLocation>^User.CSSDTransS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
