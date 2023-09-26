Class CIS.AN.OperCareData Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OperCareData ]
{

/// 手术麻醉表单
Property RecordSheet As CIS.AN.RecordSheet [ Required, SqlColumnNumber = 2 ];

/// 心率
Property HR As %String [ SqlColumnNumber = 3 ];

/// 呼吸
Property Resp As %String [ SqlColumnNumber = 4 ];

/// 无创收缩压
Property NBP As %String [ SqlColumnNumber = 5 ];

// Property NBPD As %String [ SqlColumnNumber = 6 ];

/// 无创舒张压
/// 有创收缩压
Property ABP As %String [ SqlColumnNumber = 6 ];

// Property ABPD As %String [ SqlColumnNumber = 8 ];

/// 有创舒张压
/// 血氧饱和度
Property SPO2 As %String [ SqlColumnNumber = 7 ];

/// 术中用药
Property Medication As %String(MAXLEN = 500) [ SqlColumnNumber = 8 ];

/// 病情
Property Illness As %String(MAXLEN = 1000) [ SqlColumnNumber = 9 ];

/// 开始日期
Property StartDate As %Date [ SqlColumnNumber = 10 ];

/// 开始时间
Property StartTime As %Time [ SqlColumnNumber = 11 ];

/// 结束日期
Property EndDate As %Date [ SqlColumnNumber = 12 ];

/// 结束时间
Property EndTime As %Time [ SqlColumnNumber = 13 ];

/// 最后更新用户
Property UpdateUser As %String [ SqlColumnNumber = 14 ];

/// 最后更新日期
Property UpdateDate As %Date [ SqlColumnNumber = 15 ];

/// 最后更新时间
Property UpdateTime As %Time [ SqlColumnNumber = 16 ];

/// 数据编辑标志
Property EditFlag As %String(DISPLAYLIST = ",正常,删除", VALUELIST = ",N,D") [ SqlColumnNumber = 17 ];

Index IRecordSheet On RecordSheet;

ForeignKey FKRecordSheet(RecordSheet) References CIS.AN.RecordSheet() [ OnDelete = cascade ];

Storage Default
{
<Data name="OperCareDataDefaultData">
<Value name="1">
<Value>RecordSheet</Value>
</Value>
<Value name="2">
<Value>HR</Value>
</Value>
<Value name="3">
<Value>Resp</Value>
</Value>
<Value name="4">
<Value>NBP</Value>
</Value>
<Value name="5">
<Value>ABP</Value>
</Value>
<Value name="6">
<Value>SPO2</Value>
</Value>
<Value name="7">
<Value>Medication</Value>
</Value>
<Value name="8">
<Value>Illness</Value>
</Value>
<Value name="9">
<Value>StartDate</Value>
</Value>
<Value name="10">
<Value>StartTime</Value>
</Value>
<Value name="11">
<Value>EndDate</Value>
</Value>
<Value name="12">
<Value>EndTime</Value>
</Value>
<Value name="13">
<Value>UpdateUser</Value>
</Value>
<Value name="14">
<Value>UpdateDate</Value>
</Value>
<Value name="15">
<Value>UpdateTime</Value>
</Value>
<Value name="16">
<Value>EditFlag</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.OperCareDataD</DataLocation>
<DefaultData>OperCareDataDefaultData</DefaultData>
<IdLocation>^CIS.AN.OperCareDataD</IdLocation>
<IndexLocation>^CIS.AN.OperCareDataI</IndexLocation>
<StreamLocation>^CIS.AN.OperCareDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
