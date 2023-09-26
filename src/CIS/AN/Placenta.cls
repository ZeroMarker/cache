/// 胎盘登记
Class CIS.AN.Placenta Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Placenta ]
{

/// 手术申请
Property OperSchedule As CIS.AN.OperSchedule [ SqlColumnNumber = 2 ];

/// 描述
Property Description As %String [ SqlColumnNumber = 3 ];

/// 留取时间
Property PreserveTime As %String [ SqlColumnNumber = 4 ];

/// 创建用户
Property CreateUser As %String [ SqlColumnNumber = 5 ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 6 ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 7 ];

/// 最后更新用户
Property UpdateUser As %String [ SqlColumnNumber = 8 ];

/// 最后更新日期
Property UpdateDate As %Date [ SqlColumnNumber = 9 ];

/// 最后更新时间
Property UpdateTime As %Time [ SqlColumnNumber = 10 ];

/// 手术申请索引
Index IOPS On OperSchedule;

Storage Default
{
<Data name="PlacentaDefaultData">
<Value name="1">
<Value>OperSchedule</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>PreserveTime</Value>
</Value>
<Value name="4">
<Value>CreateUser</Value>
</Value>
<Value name="5">
<Value>CreateDate</Value>
</Value>
<Value name="6">
<Value>CreateTime</Value>
</Value>
<Value name="7">
<Value>UpdateUser</Value>
</Value>
<Value name="8">
<Value>UpdateDate</Value>
</Value>
<Value name="9">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.PlacentaD</DataLocation>
<DefaultData>PlacentaDefaultData</DefaultData>
<IdLocation>^CIS.AN.PlacentaD</IdLocation>
<IndexLocation>^CIS.AN.PlacentaI</IndexLocation>
<StreamLocation>^CIS.AN.PlacentaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
