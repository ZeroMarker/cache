/// Creater:wangcc
/// Descriptions:轮转护士详情表
/// Date:2020-07-22
Class DHCINM.Trans.MgRotationDetail Extends %Persistent
{

/// 轮转任务ID
Property PlanDR As %String [ SqlColumnNumber = 2, SqlFieldName = Plan_DR ];

/// 轮转护士ID
Property RotationPerDR As %String [ SqlColumnNumber = 3, SqlFieldName = Rotation_PerDR ];

/// 序号
Property FieldSort As %Integer [ SqlColumnNumber = 4, SqlFieldName = Rotation_FieldSort ];

/// 轮转时长
Property RotationHour As %String [ SqlColumnNumber = 5, SqlFieldName = Rotation_Hour ];

Index plan On PlanDR;

Index ssid On RotationPerDR;

Index ppid On (RotationPerDR, PlanDR);

Index sort On (PlanDR, FieldSort);

Storage Default
{
<Data name="MgRotationDetailDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PlanDR</Value>
</Value>
<Value name="3">
<Value>RotationPerDR</Value>
</Value>
<Value name="4">
<Value>FieldSort</Value>
</Value>
<Value name="5">
<Value>RotationHour</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Trans.MgRotationDetailD</DataLocation>
<DefaultData>MgRotationDetailDefaultData</DefaultData>
<IdLocation>^DHCINM.Trans.MgRotationDetailD</IdLocation>
<IndexLocation>^DHCINM.Trans.MgRotationDetailI</IndexLocation>
<StreamLocation>^DHCINM.Trans.MgRotationDetailS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
