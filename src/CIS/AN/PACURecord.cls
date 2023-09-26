/// PACU记录信息
Class CIS.AN.PACURecord Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = PACURecord ]
{

Property OperSchedule As CIS.AN.OperSchedule [ SqlColumnNumber = 2 ];

/// PACU医生
Property PACUDoctor As %String [ SqlColumnNumber = 3 ];

/// PACU护士
Property PACUNurse As %String [ SqlColumnNumber = 4 ];

/// PACU接班医生
Property ShiftDoctor As %String [ SqlColumnNumber = 5 ];

/// PACU医生交接班日期时间
Property DocShiftDT As %TimeStamp [ SqlColumnNumber = 6 ];

/// PACU接班护士
Property ShiftNurse As %String [ SqlColumnNumber = 7 ];

/// PACU护士交接班日期时间
Property NurseShiftDT As %TimeStamp [ SqlColumnNumber = 8 ];

/// PACU床位
Property Bed As CF.AN.Location [ SqlColumnNumber = 9 ];

/// 入PACU Steward评分
Property InSteward As CIS.AN.StewardAssessment [ SqlColumnNumber = 10 ];

/// 出PACU Steward评分
Property OutSteward As CIS.AN.StewardAssessment [ SqlColumnNumber = 11 ];

/// PACU总入量
Property TotalIn As %String [ SqlColumnNumber = 12 ];

/// PACU总出量
Property TotalOut As %String [ SqlColumnNumber = 13 ];

/// 入PACU神志
Property InConsciousness As %String [ SqlColumnNumber = 14 ];

/// 入PACU生命体征
Property InVitalsign As %String [ SqlColumnNumber = 15 ];

/// 入PACU疼痛情况
Property InPain As %String [ SqlColumnNumber = 16 ];

/// 入PACU呕吐情况
Property InVomit As %String [ SqlColumnNumber = 17 ];

/// 入PACU受压皮肤情况
Property InSkinPressure As %String [ SqlColumnNumber = 18 ];

/// 离PACU神志
Property OutConsciousness As %String [ SqlColumnNumber = 19 ];

/// 离PACU生命体征
Property OutVitalsign As %String [ SqlColumnNumber = 20 ];

/// 离PACU疼痛情况
Property OutPain As %String [ SqlColumnNumber = 21 ];

/// 离PACU呕吐情况
Property OutVomit As %String [ SqlColumnNumber = 22 ];

/// 离PACU受压皮肤情况
Property OutSkinPressure As %String [ SqlColumnNumber = 23 ];

/// 离开PACU后去向
Property OutTransLoc As %String(DISPLAYLIST = ",原病区,ICU,离院,死亡,返回术间", VALUELIST = ",Ward,ICU,Discharge,Death,BackOper") [ SqlColumnNumber = 24 ];

/// 随身管道
Property CarriedTube As %String [ SqlColumnNumber = 25 ];

/// 合并症
Property Complication As %String [ SqlColumnNumber = 26 ];

/// 其它
Property PostOperNote As %String [ SqlColumnNumber = 27 ];

/// 接收人（病区）
Property WardReceiveCareProv As %String [ SqlColumnNumber = 28 ];

/// 血压
Property InBloodPressure As %String [ SqlColumnNumber = 29 ];

/// 入室收缩压
Property InSystolic As %String [ SqlColumnNumber = 30 ];

/// 入室舒张压
Property InDiastolic As %String [ SqlColumnNumber = 31 ];

/// 入室心率
Property InHR As %String [ SqlColumnNumber = 32 ];

/// 入室呼吸
Property InRR As %String [ SqlColumnNumber = 33 ];

/// 入室SPO2
Property InSPO2 As %String [ SqlColumnNumber = 34 ];

/// 自控疼痛
Property InSelfControlPain As %String [ SqlColumnNumber = 35 ];

/// 离室血药
Property OutBloodPressure As %String [ SqlColumnNumber = 36 ];

/// 离室收缩压
Property OutSystolic As %String [ SqlColumnNumber = 37 ];

/// 离室舒张压
Property OutDiastolic As %String [ SqlColumnNumber = 38 ];

/// 离室心率
Property OutHR As %String [ SqlColumnNumber = 39 ];

/// 离室呼吸
Property OutRR As %String [ SqlColumnNumber = 40 ];

/// 离室SPO2
Property OutSPO2 As %String [ SqlColumnNumber = 41 ];

/// 离室自控疼痛
Property OutSelfControlPain As %String [ SqlColumnNumber = 42 ];

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
<Data name="PACURecordDefaultData">
<Value name="1">
<Value>OperSchedule</Value>
</Value>
<Value name="2">
<Value>PACUDoctor</Value>
</Value>
<Value name="3">
<Value>PACUNurse</Value>
</Value>
<Value name="4">
<Value>ShiftDoctor</Value>
</Value>
<Value name="5">
<Value>DocShiftDT</Value>
</Value>
<Value name="6">
<Value>ShiftNurse</Value>
</Value>
<Value name="7">
<Value>NurseShiftDT</Value>
</Value>
<Value name="8">
<Value>Bed</Value>
</Value>
<Value name="9">
<Value>InSteward</Value>
</Value>
<Value name="10">
<Value>OutSteward</Value>
</Value>
<Value name="11">
<Value>TotalIn</Value>
</Value>
<Value name="12">
<Value>TotalOut</Value>
</Value>
<Value name="13">
<Value>InConsciousness</Value>
</Value>
<Value name="14">
<Value>InVitalsign</Value>
</Value>
<Value name="15">
<Value>InPain</Value>
</Value>
<Value name="16">
<Value>InVomit</Value>
</Value>
<Value name="17">
<Value>InSkinPressure</Value>
</Value>
<Value name="18">
<Value>OutConsciousness</Value>
</Value>
<Value name="19">
<Value>OutVitalsign</Value>
</Value>
<Value name="20">
<Value>OutPain</Value>
</Value>
<Value name="21">
<Value>OutVomit</Value>
</Value>
<Value name="22">
<Value>OutSkinPressure</Value>
</Value>
<Value name="23">
<Value>OutTransLoc</Value>
</Value>
<Value name="24">
<Value>CarriedTube</Value>
</Value>
<Value name="25">
<Value>Complication</Value>
</Value>
<Value name="26">
<Value>PostOperNote</Value>
</Value>
<Value name="27">
<Value>WardReceiveCareProv</Value>
</Value>
<Value name="28">
<Value>InBloodPressure</Value>
</Value>
<Value name="29">
<Value>InSystolic</Value>
</Value>
<Value name="30">
<Value>InDiastolic</Value>
</Value>
<Value name="31">
<Value>InHR</Value>
</Value>
<Value name="32">
<Value>InRR</Value>
</Value>
<Value name="33">
<Value>InSPO2</Value>
</Value>
<Value name="34">
<Value>InSelfControlPain</Value>
</Value>
<Value name="35">
<Value>OutBloodPressure</Value>
</Value>
<Value name="36">
<Value>OutSystolic</Value>
</Value>
<Value name="37">
<Value>OutDiastolic</Value>
</Value>
<Value name="38">
<Value>OutHR</Value>
</Value>
<Value name="39">
<Value>OutRR</Value>
</Value>
<Value name="40">
<Value>OutSPO2</Value>
</Value>
<Value name="41">
<Value>OutSelfControlPain</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.PACURecordD</DataLocation>
<DefaultData>PACURecordDefaultData</DefaultData>
<IdLocation>^CIS.AN.PACURecordD</IdLocation>
<IndexLocation>^CIS.AN.PACURecordI</IndexLocation>
<StreamLocation>^CIS.AN.PACURecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
