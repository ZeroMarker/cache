/// 输血成分
Class CIS.AN.BloodTransCmpt Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = BloodTransCmpt ]
{

/// 输血申请
Property Transfusion As CIS.AN.BloodTransfusion [ Required, SqlColumnNumber = 2 ];

/// 输血成分
Property Component As %String [ Required, SqlColumnNumber = 3 ];

/// 输血量
Property Volume As %String [ SqlColumnNumber = 4 ];

/// 输血单位
Property Unit As %String [ SqlColumnNumber = 5 ];

/// 输血申请索引
Index ITransfusion On Transfusion;

/// 输血成分索引
Index IComponent On Component [ Unique ];

/// 输血申请索引外键约束
ForeignKey FKTransfusion(Transfusion) References CIS.AN.BloodTransfusion() [ OnDelete = cascade ];

Storage Default
{
<Data name="BloodTransCmptDefaultData">
<Value name="1">
<Value>Transfusion</Value>
</Value>
<Value name="2">
<Value>Component</Value>
</Value>
<Value name="3">
<Value>Volume</Value>
</Value>
<Value name="4">
<Value>Unit</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.BloodTransCmptD</DataLocation>
<DefaultData>BloodTransCmptDefaultData</DefaultData>
<IdLocation>^CIS.AN.BloodTransCmptD</IdLocation>
<IndexLocation>^CIS.AN.BloodTransCmptI</IndexLocation>
<StreamLocation>^CIS.AN.BloodTransCmptS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
