/// 血袋
Class CIS.AN.BloodBag Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = BloodBag ]
{

/// 输血申请
Property Transfusion As CIS.AN.BloodTransfusion [ Required, SqlColumnNumber = 2 ];

/// 血袋条码
Property BarCode As %String(MAXLEN = 200) [ Required, SqlColumnNumber = 3 ];

/// 成分码
Property ComponentCode As %String(MAXLEN = 200) [ SqlColumnNumber = 4 ];

/// 采集时间
Property CollectedDT As %String [ SqlColumnNumber = 5 ];

/// 入库时间
Property RespInDT As %String [ SqlColumnNumber = 6 ];

/// 失效时间
Property ExpiredDT As %String [ SqlColumnNumber = 7 ];

/// 血制品ABO血型
Property ABO As %String [ SqlColumnNumber = 8 ];

/// 血制品RH血型
Property RH As %String [ SqlColumnNumber = 9 ];

/// 血液品种
Property BloodSpecies As %String(MAXLEN = 200) [ SqlColumnNumber = 10 ];

/// 输血申请索引
Index ITrans On Transfusion;

/// 血袋条码索引
Index IBarCode On BarCode [ Unique ];

/// 输血申请外键约束
ForeignKey FKTransfusion(Transfusion) References CIS.AN.BloodTransfusion() [ OnDelete = cascade ];

Storage Default
{
<Data name="BloodBagDefaultData">
<Value name="1">
<Value>Transfusion</Value>
</Value>
<Value name="2">
<Value>BarCode</Value>
</Value>
<Value name="3">
<Value>ComponentCode</Value>
</Value>
<Value name="4">
<Value>CollectedDT</Value>
</Value>
<Value name="5">
<Value>RespInDT</Value>
</Value>
<Value name="6">
<Value>ExpiredDT</Value>
</Value>
<Value name="7">
<Value>ABO</Value>
</Value>
<Value name="8">
<Value>RH</Value>
</Value>
<Value name="9">
<Value>BloodSpecies</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.BloodBagD</DataLocation>
<DefaultData>BloodBagDefaultData</DefaultData>
<IdLocation>^CIS.AN.BloodBagD</IdLocation>
<IndexLocation>^CIS.AN.BloodBagI</IndexLocation>
<StreamLocation>^CIS.AN.BloodBagS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
