/// 手术诊断
Class CIS.AN.OperDiagnosis Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = OperDiagnosis ]
{

/// 手术申请
Property OperSchedule As CIS.AN.OperSchedule [ Required, SqlColumnNumber = 2 ];

/// 诊断字典ID
Property MRCDiagID As %String [ SqlColumnNumber = 3 ];

/// 诊断描述
Property Diagosis As %String(MAXLEN = 200) [ SqlColumnNumber = 4 ];

/// 手术诊断类型
Property OPDiagType As %String(DISPLAYLIST = ",术前诊断,术后诊断,术中诊断", VALUELIST = ",PRE,POST,INO") [ SqlColumnNumber = 5 ];

/// 手术申请索引
Index IOPS On OperSchedule;

/// 手术申请外键约束
ForeignKey FKOperSchedule(OperSchedule) References CIS.AN.OperSchedule() [ OnDelete = cascade ];

Trigger AfterInsert [ Event = INSERT, Foreach = row/object, Time = AFTER ]
{
    set id = {OperSchedule}
    do ##class(CIS.AN.OperSchedule).OnUpdate(id)
}

Trigger AfterUpdate [ Event = UPDATE, Foreach = row/object, Time = AFTER ]
{
    set id = {OperSchedule}
    do ##class(CIS.AN.OperSchedule).OnUpdate(id)
}

Trigger AfterDelete [ Event = DELETE, Foreach = row/object, Time = AFTER ]
{
    set id = {OperSchedule}
    do ##class(CIS.AN.OperSchedule).OnUpdate(id)
}

Storage Default
{
<Data name="OperDiagnosisDefaultData">
<Value name="1">
<Value>OperSchedule</Value>
</Value>
<Value name="2">
<Value>MRCDiagID</Value>
</Value>
<Value name="3">
<Value>Diagosis</Value>
</Value>
<Value name="4">
<Value>OPDiagType</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.OperDiagnosisD</DataLocation>
<DefaultData>OperDiagnosisDefaultData</DefaultData>
<IdLocation>^CIS.AN.OperDiagnosisD</IdLocation>
<IndexLocation>^CIS.AN.OperDiagnosisI</IndexLocation>
<StreamLocation>^CIS.AN.OperDiagnosisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
