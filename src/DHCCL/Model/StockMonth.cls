/// 库存月报主表
Class DHCCL.Model.StockMonth Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = StockMonth ]
{

Property Month As %String [ SqlColumnNumber = 2 ];

Property LocationDr As %String [ SqlColumnNumber = 3 ];

Property FromDate As %Date [ Required, SqlColumnNumber = 4 ];

Property ToDate As %Date [ Required, SqlColumnNumber = 5 ];

Property CreatedDate As %Date [ SqlColumnNumber = 6 ];

Property CreatedUserDr As %String [ SqlColumnNumber = 7 ];

Property FromTime As %Time [ SqlColumnNumber = 8 ];

Property ToTime As %Time [ SqlColumnNumber = 9 ];

Property Status As %String(DISPLAYLIST = ",已审核,未审核", VALUELIST = ",A,U") [ SqlColumnNumber = 10 ];

Property CreatedTime As %Time [ SqlColumnNumber = 11 ];

/// 审核用户
Property AuditUser As %String [ SqlColumnNumber = 12 ];

/// 审核日期
Property AuditDate As %Date [ SqlColumnNumber = 13 ];

/// 审核时间
Property AuditTime As %Time [ SqlColumnNumber = 14 ];

Index LocDate On (LocationDr, FromDate);

Storage Default
{
<Data name="StockMonthDefaultData">
<Value name="1">
<Value>Month</Value>
</Value>
<Value name="2">
<Value>LocationDr</Value>
</Value>
<Value name="3">
<Value>FromDate</Value>
</Value>
<Value name="4">
<Value>ToDate</Value>
</Value>
<Value name="5">
<Value>CreatedDate</Value>
</Value>
<Value name="6">
<Value>CreatedUserDr</Value>
</Value>
<Value name="7">
<Value>FromTime</Value>
</Value>
<Value name="8">
<Value>ToTime</Value>
</Value>
<Value name="9">
<Value>Status</Value>
</Value>
<Value name="10">
<Value>CreatedTime</Value>
</Value>
<Value name="11">
<Value>AuditUser</Value>
</Value>
<Value name="12">
<Value>AuditDate</Value>
</Value>
<Value name="13">
<Value>AuditTime</Value>
</Value>
</Data>
<DataLocation>^DHCCL.Model.StockMonthD</DataLocation>
<DefaultData>StockMonthDefaultData</DefaultData>
<IdLocation>^DHCCL.Model.StockMonthD</IdLocation>
<IndexLocation>^DHCCL.Model.StockMonthI</IndexLocation>
<StreamLocation>^DHCCL.Model.StockMonthS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
