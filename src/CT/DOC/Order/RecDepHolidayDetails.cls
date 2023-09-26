/// 门急诊假日、上下班接收科室设置明细
Class CT.DOC.Order.RecDepHolidayDetails Extends (%Persistent, User.Abstract) [ Owner = {_SYSTEM}, SqlTableName = RecDepHolidayDetails ]
{

Index ConfigTypeIndex On (RDHConfigType, RDHOrdLocDr);

Index ConfigTypeHoliIndex On (RDHConfigType, RDHRecHolidayDr, RDHOrdLocDr);

/// 配置类型
Property RDHConfigType As %String(DISPLAYLIST = ",上下班接受科室配置,节假日接受科室配置", MAXLEN = 30, TRUNCATE = 1, VALUELIST = ",OffWorkTimesRecStr,HolidaysRecStr") [ Required, SqlColumnNumber = 2, SqlFieldName = RDH_ConfigType ];

/// 节假日指向，节假日接受科室配置时必填
Property RDHRecHolidayDr As User.DHCOPRecDepHoliday [ SqlColumnNumber = 3, SqlFieldName = RDH_RecHolidayDr ];

/// 开单科室
Property RDHOrdLocDr As User.CTLoc [ Required, SqlColumnNumber = 4, SqlFieldName = RDH_OrdLocDr ];

/// 接受科室列表 User.CTLoc
Property RDHRecLocDr As list Of %String [ SqlColumnNumber = 5, SqlFieldName = RDH_RecLocDr ];

/// 是否可用标识
Property RDHIsActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = RDH_IsActiveFlag ];

/// 院区
Property RDHHospDR As User.CTHospital [ SqlColumnNumber = 7, SqlFieldName = RDH_Hosp_DR ];

/// 条件：医嘱类型
Property RDHOrderPrior As User.OECPriority [ SqlColumnNumber = 8, SqlFieldName = RDH_OrderPrior ];

/// 条件：是否加急
Property RDHNotifyClinician As %String(DISPLAYLIST = ",All,Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",All,Y,N") [ SqlColumnNumber = 9, SqlFieldName = RDH_NotifyClinician ];

/// 创建时间
Property RDHLastUpdateDate As %Date [ SqlColumnNumber = 10, SqlFieldName = RDH_LastUpdateDate ];

/// 创建时间
Property RDHLastUpdateTime As %Time [ SqlColumnNumber = 11, SqlFieldName = RDH_LastUpdateTime ];

/// 子类列表
Property RDHItemCatDr As list Of %String [ SqlColumnNumber = 12, SqlFieldName = RDH_ItemCatDr ];

/// 例外的医嘱项列表
Property RDHExceptionArcimDr As list Of %String [ SqlColumnNumber = 13, SqlFieldName = RDH_ExceptionArcimDr ];

Storage Default
{
<Data name="DHCOPRecDepHolidayDetailsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RDHConfigType</Value>
</Value>
<Value name="3">
<Value>RDHRecHolidayDr</Value>
</Value>
<Value name="4">
<Value>RDHOrdLocDr</Value>
</Value>
<Value name="5">
<Value>RDHRecLocDr</Value>
</Value>
<Value name="6">
<Value>RDHIsActiveFlag</Value>
</Value>
<Value name="7">
<Value>RDHHospDR</Value>
</Value>
<Value name="8">
<Value>RDHOrderPrior</Value>
</Value>
<Value name="9">
<Value>RDHNotifyClinician</Value>
</Value>
<Value name="10">
<Value>RDHLastUpdateDate</Value>
</Value>
<Value name="11">
<Value>RDHLastUpdateTime</Value>
</Value>
<Value name="12">
<Value>RDHItemCatDr</Value>
</Value>
<Value name="13">
<Value>RDHExceptionArcimDr</Value>
</Value>
</Data>
<DataLocation>^CF.DOC.Order.RecDepHoliDayD</DataLocation>
<DefaultData>CF.DOC.Order.RecDepHolidayDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CF.DOC.Order.RecDepHoliDayD</IdLocation>
<IndexLocation>^CF.DOC.Order.RecDepHoliDayI</IndexLocation>
<StreamLocation>^CF.DOC.Order.RecDepHoliDayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
