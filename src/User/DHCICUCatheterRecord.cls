/// 数据-导管使用记录
Class User.DHCICUCatheterRecord Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DHC_ICU_CatheterRecord ]
{

/// 重症记录
Property Arrange As User.DHCICUArrange [ Required, SqlColumnNumber = 2 ];

/// 导管
Property Catheter As User.DHCICUCCatheter [ Required, SqlColumnNumber = 3 ];

/// 导管型号
Property Type As %String [ SqlColumnNumber = 4 ];

/// 置入位置
/// Property Position As User.DHCICUCCatheterPos [ SqlColumnNumber = 5 ];
Property Position As %String [ SqlColumnNumber = 5 ];

/// 来源
Property Source As %String(DISPLAYLIST = ",科内置管,外部带入", VALUELIST = ",Inside,Outside") [ SqlColumnNumber = 6 ];

/// 状态
Property Status As %String(DISPLAYLIST = ",计划置管,使用中,已拔管", VALUELIST = ",Plan,Using,Extubated") [ SqlColumnNumber = 7 ];

/// 数据编辑状态
Property EditFlag As %String(DISPLAYLIST = ",正常,删除", VALUELIST = ",Normal,Deleted") [ SqlColumnNumber = 8 ];

/// 置管日期
Property IntubateDate As %Date [ SqlColumnNumber = 9 ];

/// 置管时间
Property IntubateTime As %Time [ SqlColumnNumber = 10 ];

/// 带入日期
Property TakeInDate As %Date [ SqlColumnNumber = 11 ];

/// 带入时间
Property TakeInTime As %Time [ SqlColumnNumber = 12 ];

/// 拔管日期
Property ExtubateDate As %Date [ SqlColumnNumber = 13 ];

/// 拔管时间
Property ExtubateTime As %Time [ SqlColumnNumber = 14 ];

/// 置管长度
Property TotalLength As %String [ SqlColumnNumber = 15 ];

/// 外露长度
Property ExposedLenth As %String [ SqlColumnNumber = 16 ];

/// 外露刻度
Property ExposedScale As %String [ SqlColumnNumber = 17 ];

/// 体表标志
Property MarkOnSkin As %String [ SqlColumnNumber = 18 ];

/// 末端位置
Property TailPos As %String [ SqlColumnNumber = 19 ];

/// 调整时间
Property AdjustDateTime As %TimeStamp [ SqlColumnNumber = 20 ];

/// 提醒更换日期
Property AlertDate As %Date [ SqlColumnNumber = 21 ];

/// 更换辅料时间
Property DressingReplaceTime As %TimeStamp [ SqlColumnNumber = 22 ];

/// 备注
Property Note As %String(MAXLEN = 200) [ SqlColumnNumber = 23 ];

/// 创建者
Property CreateUser As %String [ SqlColumnNumber = 24 ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 25 ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {+$p($h,",",2)}, SqlColumnNumber = 26 ];

/// 操作者
Property UpdateUser As %String [ SqlColumnNumber = 27 ];

/// 变更日期
Property UpdateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 28 ];

/// 变更时间
Property UpdateTime As %Time [ InitialExpression = {+$p($h,",",2)}, SqlColumnNumber = 29 ];

Property ParaItem As %String(MAXLEN = 200) [ SqlColumnNumber = 30 ];

/// 压力传感器更换日期
Property PSensorsReplaceDate As %Date [ SqlColumnNumber = 31 ];

/// 导管描述
Property CatheterDesc As %String [ SqlColumnNumber = 32 ];

Index Arr On Arrange;

Index Catheter On (Arrange, Catheter);

Storage Default
{
<Data name="DHCICUCatheterRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Arrange</Value>
</Value>
<Value name="3">
<Value>Catheter</Value>
</Value>
<Value name="4">
<Value>Type</Value>
</Value>
<Value name="5">
<Value>Position</Value>
</Value>
<Value name="6">
<Value>Source</Value>
</Value>
<Value name="7">
<Value>Status</Value>
</Value>
<Value name="8">
<Value>EditFlag</Value>
</Value>
<Value name="9">
<Value>IntubateDate</Value>
</Value>
<Value name="10">
<Value>IntubateTime</Value>
</Value>
<Value name="11">
<Value>TakeInDate</Value>
</Value>
<Value name="12">
<Value>TakeInTime</Value>
</Value>
<Value name="13">
<Value>ExtubateDate</Value>
</Value>
<Value name="14">
<Value>ExtubateTime</Value>
</Value>
<Value name="15">
<Value>TotalLength</Value>
</Value>
<Value name="16">
<Value>ExposedLenth</Value>
</Value>
<Value name="17">
<Value>ExposedScale</Value>
</Value>
<Value name="18">
<Value>MarkOnSkin</Value>
</Value>
<Value name="19">
<Value>TailPos</Value>
</Value>
<Value name="20">
<Value>AdjustDateTime</Value>
</Value>
<Value name="21">
<Value>AlertDate</Value>
</Value>
<Value name="22">
<Value>DressingReplaceTime</Value>
</Value>
<Value name="23">
<Value>Note</Value>
</Value>
<Value name="24">
<Value>CreateUser</Value>
</Value>
<Value name="25">
<Value>CreateDate</Value>
</Value>
<Value name="26">
<Value>CreateTime</Value>
</Value>
<Value name="27">
<Value>UpdateUser</Value>
</Value>
<Value name="28">
<Value>UpdateDate</Value>
</Value>
<Value name="29">
<Value>UpdateTime</Value>
</Value>
<Value name="30">
<Value>ParaItem</Value>
</Value>
<Value name="31">
<Value>PSensorsReplaceDate</Value>
</Value>
<Value name="32">
<Value>CatheterDesc</Value>
</Value>
</Data>
<DataLocation>^User.DHCICUCatheterRecordD</DataLocation>
<DefaultData>DHCICUCatheterRecordDefaultData</DefaultData>
<IdLocation>^User.DHCICUCatheterRecordD</IdLocation>
<IndexLocation>^User.DHCICUCatheterRecordI</IndexLocation>
<StreamLocation>^User.DHCICUCatheterRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
