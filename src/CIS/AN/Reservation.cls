/// 麻醉物品预约
Class CIS.AN.Reservation Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Reservation ]
{

/// 手术日期
Property OperDate As %Date [ SqlColumnNumber = 2 ];

/// 手术间
Property OperRoom As CF.AN.Location [ SqlColumnNumber = 3 ];

/// 麻醉物品
Property Article As CF.AN.NarcoticArticle [ SqlColumnNumber = 4 ];

/// 预约数量
Property Qty As %Float [ SqlColumnNumber = 5 ];

/// 数量单位
Property Uom As CT.AN.Uom [ SqlColumnNumber = 6 ];

/// 预约医生
Property ResnProv As %String [ SqlColumnNumber = 7 ];

/// 预约日期
Property ResnDate As %Date [ SqlColumnNumber = 8 ];

/// 预约时间
Property ResnTime As %Time [ SqlColumnNumber = 9 ];

/// 备货护士
Property PrepareProv As %String [ SqlColumnNumber = 10 ];

/// 备货日期
Property PrepareDate As %Date [ SqlColumnNumber = 11 ];

/// 备货时间
Property PrepareTime As %Time [ SqlColumnNumber = 12 ];

/// 状态
Property Status As %String(DISPLAYLIST = ",已预约,已备货,已作废", MAXLEN = 3, VALUELIST = ",R,P,C") [ SqlColumnNumber = 13 ];

/// 备货数量
Property PrepareQty As %Float [ SqlColumnNumber = 14 ];

/// 最后更新用户
Property UpdateUser As %String [ SqlColumnNumber = 15 ];

/// 最后更新日期
Property UpdateDate As %Date [ SqlColumnNumber = 16 ];

/// 最后更新时间
Property UpdateTime As %Time [ SqlColumnNumber = 17 ];

/// 预约医生所在科室
Property Dept As %String [ SqlColumnNumber = 18 ];

Index DeptDate On (Dept, OperDate);

Storage Default
{
<Data name="ReservationDefaultData">
<Value name="1">
<Value>OperDate</Value>
</Value>
<Value name="2">
<Value>OperRoom</Value>
</Value>
<Value name="3">
<Value>Article</Value>
</Value>
<Value name="4">
<Value>Qty</Value>
</Value>
<Value name="5">
<Value>Uom</Value>
</Value>
<Value name="6">
<Value>ResnProv</Value>
</Value>
<Value name="7">
<Value>ResnDate</Value>
</Value>
<Value name="8">
<Value>ResnTime</Value>
</Value>
<Value name="9">
<Value>PrepareProv</Value>
</Value>
<Value name="10">
<Value>PrepareDate</Value>
</Value>
<Value name="11">
<Value>PrepareTime</Value>
</Value>
<Value name="12">
<Value>Status</Value>
</Value>
<Value name="13">
<Value>PrepareQty</Value>
</Value>
<Value name="14">
<Value>UpdateUser</Value>
</Value>
<Value name="15">
<Value>UpdateDate</Value>
</Value>
<Value name="16">
<Value>UpdateTime</Value>
</Value>
<Value name="17">
<Value>Dept</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.ReservationD</DataLocation>
<DefaultData>ReservationDefaultData</DefaultData>
<IdLocation>^CIS.AN.ReservationD</IdLocation>
<IndexLocation>^CIS.AN.ReservationI</IndexLocation>
<StreamLocation>^CIS.AN.ReservationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
