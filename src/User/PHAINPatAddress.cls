/// 病人地址表
Class User.PHAINPatAddress Extends (%Persistent, User.Abstract) [ SqlRowIdName = PP_RowId, SqlTableName = PHAIN_PatAddress, StorageStrategy = CacheStorage ]
{

/// 病人id
Property PPPAPMIDR As PAPatMas [ Required, SqlColumnNumber = 2, SqlFieldName = PP_PAPMI_DR ];

/// 处方号
Property PPPrescNo As %String [ Required, SqlColumnNumber = 3, SqlFieldName = PP_PrescNo ];

/// 省(选择字典)
Property PPProvinceDR As CTProvince [ SqlColumnNumber = 4, SqlFieldName = PP_Province_DR ];

/// 市(选择字典)
Property PPCityDR As CTCity [ SqlColumnNumber = 5, SqlFieldName = PP_City_DR ];

/// 区(选择字典)
Property PPCityAreaDR As CTCityArea [ SqlColumnNumber = 6, SqlFieldName = PP_CityArea_DR ];

/// 详细地址
Property PPAdress As %String [ SqlColumnNumber = 7, SqlFieldName = PP_Adress ];

/// 省(录入)
Property PPProvince As %String [ SqlColumnNumber = 8, SqlFieldName = PP_Province ];

/// 市(录入)
Property PPCity As %String [ SqlColumnNumber = 9, SqlFieldName = PP_City ];

/// 区(录入)
Property PPCityArea As %String [ SqlColumnNumber = 10, SqlFieldName = PP_CityArea ];

/// 收件人
Property PPName As %String [ SqlColumnNumber = 11, SqlFieldName = PP_Name ];

/// 联系电话
Property PPTel As %String [ SqlColumnNumber = 12, SqlFieldName = PP_Tel ];

/// 发票id
Property PPPrtDR As User.DHCINVPRT [ SqlColumnNumber = 13, SqlFieldName = PP_Prt_DR ];

/// 发票号
Property PPPrtNo As %String [ SqlColumnNumber = 14, SqlFieldName = PP_PrtNo ];

/// 快递单号
Property PPExpressNo As %String [ SqlColumnNumber = 15, SqlFieldName = PP_ExpressNo ];

/// 类型(1:快递，2:自取)
Property PPType As %String [ SqlColumnNumber = 16, SqlFieldName = PP_Type ];

/// 作废标记(Y作废)
Property PPInvalidFlag As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = PP_InvalidFlag ];

/// 插入日期
Property PPDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 18, SqlFieldName = PP_Date ];

/// 插入时间
Property PPTime As %Library.Time [ SqlColumnNumber = 19, SqlFieldName = PP_Time ];

/// 收费日期
Property PPPayDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 20, SqlFieldName = PP_PayDate ];

/// 收费时间
Property PPPayTime As %Library.Time [ SqlColumnNumber = 21, SqlFieldName = PP_PayTime ];

/// 作废日期
Property PPInvalidDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = PP_InvalidDate ];

/// 作废时间
Property PPInvalidTime As %Library.Time [ SqlColumnNumber = 23, SqlFieldName = PP_InvalidTime ];

/// 病人id索引
Index IndexPAPMIDR On PPPAPMIDR As Exact;

/// 处方号索引
Index IndexPrescNo On PPPrescNo As Exact;

/// 发票id索引
Index IndexPrt On PPPrtDR As Exact;

/// 发票号索引
Index IndexPrtno On PPPrtNo As Exact;

/// 快递单号索引
Index IndexExpressNo On PPExpressNo As Exact;

/// 收费日期索引
Index IndexPayDate On PPPayDate As Exact;

Storage CacheStorage
{
<Data name="PHAINPatAddressDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PPPAPMIDR</Value>
</Value>
<Value name="3">
<Value>PPPrescNo</Value>
</Value>
<Value name="4">
<Value>PPProvinceDR</Value>
</Value>
<Value name="5">
<Value>PPCityDR</Value>
</Value>
<Value name="6">
<Value>PPCityAreaDR</Value>
</Value>
<Value name="7">
<Value>PPAdress</Value>
</Value>
<Value name="8">
<Value>PPProvince</Value>
</Value>
<Value name="9">
<Value>PPCity</Value>
</Value>
<Value name="10">
<Value>PPCityArea</Value>
</Value>
<Value name="11">
<Value>PPName</Value>
</Value>
<Value name="12">
<Value>PPTel</Value>
</Value>
<Value name="13">
<Value>PPPrtDR</Value>
</Value>
<Value name="14">
<Value>PPPrtNo</Value>
</Value>
<Value name="15">
<Value>PPExpressNo</Value>
</Value>
<Value name="16">
<Value>PPType</Value>
</Value>
<Value name="17">
<Value>PPInvalidFlag</Value>
</Value>
<Value name="18">
<Value>PPDate</Value>
</Value>
<Value name="19">
<Value>PPTime</Value>
</Value>
<Value name="20">
<Value>PPPayDate</Value>
</Value>
<Value name="21">
<Value>PPPayTime</Value>
</Value>
<Value name="22">
<Value>PPInvalidDate</Value>
</Value>
<Value name="23">
<Value>PPInvalidTime</Value>
</Value>
</Data>
<DataLocation>^BS.PHA.IN.PatAddress</DataLocation>
<DefaultData>PHAINPatAddressDefaultData1</DefaultData>
<IdLocation>^BS.PHA.IN.PatAddress</IdLocation>
<IndexLocation>^BS.PHA.IN.PatAddressi</IndexLocation>
<StreamLocation>^User.PHAINPatAddressS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
