/// 麻醉信息表
Class CIS.AN.Anaesthesia Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Anaesthesia ]
{

/// 手术计划ID
Property OperSchedule As CIS.AN.OperSchedule [ Required, SqlColumnNumber = 2 ];

/// 实施麻醉方法
Property AnaMethod As %String [ SqlColumnNumber = 3 ];

/// 麻醉指导
Property AnaExpert As %String [ SqlColumnNumber = 4 ];

/// 麻醉医生
Property Anesthesiologist As %String [ SqlColumnNumber = 5 ];

/// 麻醉助手
Property AnaAssistant As %String [ SqlColumnNumber = 6 ];

/// 麻醉实习进修医生
Property AnaStaff As %String [ SqlColumnNumber = 7 ];

/// 入手术室日期时间
Property AreaInDT As %TimeStamp [ SqlColumnNumber = 8 ];

/// 离手术室日期时间
Property AreaOutDT As %TimeStamp [ SqlColumnNumber = 9 ];

/// 入手术间日期时间
Property TheatreInDT As %TimeStamp [ SqlColumnNumber = 10 ];

/// 离手术间日期时间
Property TheatreOutDT As %TimeStamp [ SqlColumnNumber = 11 ];

/// 麻醉开始日期时间
Property AnaStartDT As %TimeStamp [ SqlColumnNumber = 12 ];

/// 麻醉结束日期时间
Property AnaFinishDT As %TimeStamp [ SqlColumnNumber = 13 ];

/// 插管日期时间
Property TubeInDT As %TimeStamp [ SqlColumnNumber = 14 ];

/// 拔管日期时间
Property TubeOutDT As %TimeStamp [ SqlColumnNumber = 15 ];

/// 手术开始日期时间
Property OperStartDT As %TimeStamp [ SqlColumnNumber = 16 ];

/// 手术结束日期时间
Property OperFinishDT As %TimeStamp [ SqlColumnNumber = 17 ];

/// 入PACU日期时间
Property PACUInDT As %TimeStamp [ SqlColumnNumber = 18 ];

/// 离PACU日期时间
Property PACUOutDT As %TimeStamp [ SqlColumnNumber = 19 ];

/// ASA分级
Property ASAClass As %String [ SqlColumnNumber = 20 ];

/// 麻醉分级
Property AnaClass As %String [ SqlColumnNumber = 21 ];

/// 术前禁食
Property PreFasting As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 22 ];

/// 术前特殊情况
Property PreOperNote As %String(MAXLEN = 300) [ SqlColumnNumber = 23 ];

/// 术前用药
Property PreMedication As %String(MAXLEN = 100) [ SqlColumnNumber = 24 ];

/// 手术体位
Property OperPosition As %String [ SqlColumnNumber = 25 ];

/// 心电监护医生
Property ECGDoctor As %String [ SqlColumnNumber = 26 ];

/// 术中总入量
Property TotalIn As %String [ SqlColumnNumber = 27 ];

/// 术中胶体液总量
Property ColloidalVol As %String [ SqlColumnNumber = 28 ];

/// 术中晶体液总量
Property CrystalloidVol As %String [ SqlColumnNumber = 29 ];

/// 术中总出量
Property TotalOut As %String [ SqlColumnNumber = 30 ];

/// 术中总尿量
Property UrineVol As %String [ SqlColumnNumber = 31 ];

/// 术中不显失水总量
Property WaterLossVol As %String [ SqlColumnNumber = 32 ];

/// 术中失血总量
Property BloodLossVol As %String [ SqlColumnNumber = 33 ];

/// 离开手术间后去向
Property TheatreOutTransLoc As %String(DISPLAYLIST = ",麻醉恢复室,病房,重症医学科,离院,死亡", VALUELIST = ",PACU,Ward,ICU,Discharge,Death") [ SqlColumnNumber = 34 ];

/// 离开手术室后去向
Property AreaOutTransLoc As %String(DISPLAYLIST = ",病房,重症医学科,离院,死亡,重返术间", VALUELIST = ",Ward,ICU,Discharge,Death,BackOper") [ SqlColumnNumber = 35 ];

/// 室外麻醉预约
Property OutRoomAna As %String [ SqlColumnNumber = 36 ];

/// 麻醉室外预约申请医生电话
Property AppDocConNo As %String [ SqlColumnNumber = 37 ];

/// 麻醉接班医生
Property ShiftDoctor As %String [ SqlColumnNumber = 38 ];

/// 气胸
Property Pneumothorax As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 39 ];

/// 气腹
Property Pneumoperitoneum As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 40 ];

/// 撤销监护用户
Property RevokeUser As %String [ SqlColumnNumber = 41 ];

/// 撤销日期
Property RevokeDate As %Date [ SqlColumnNumber = 42 ];

/// 撤销时间
Property RevokeTime As %Time [ SqlColumnNumber = 43 ];

/// 麻醉操作情况
Property AnaOperInfo As %String(MAXLEN = 200) [ SqlColumnNumber = 44 ];

/// 困难气道
Property DifficultAirway As %String [ SqlColumnNumber = 45 ];

/// 术后镇痛
Property PostAnalgesia As %String(MAXLEN = 200) [ SqlColumnNumber = 46 ];

/// 麻醉效果
Property AnaEffect As %String [ SqlColumnNumber = 47 ];

/// 排班麻醉指导
Property ArrAnaExpert As %String [ SqlColumnNumber = 48 ];

/// 排班麻醉医生
Property ArrAnesthesiologist As %String [ SqlColumnNumber = 49 ];

/// 排班麻醉助手
Property ArrAnaAssistant As %String [ SqlColumnNumber = 50 ];

/// 排班麻醉方法
Property ArrAnaMethod As %String [ SqlColumnNumber = 51 ];

/// 排班实习进修医生
Property ArrAnaStaff As %String [ SqlColumnNumber = 52 ];

/// 拟施麻醉
Property PrevAnaMethod As %String [ SqlColumnNumber = 53 ];

/// 术中输血总量
Property BloodTransVol As %String [ SqlColumnNumber = 54 ];

/// 自体血总量
Property SelfBloodVol As %String [ SqlColumnNumber = 55 ];

/// 积水潭用,结束人
Property AnaEndStaff As %String [ SqlColumnNumber = 56 ];

/// 无痛分娩开始
Property LaborStartDT As %TimeStamp [ SqlColumnNumber = 57 ];

/// 无痛分娩结束
Property LaborEndDT As %TimeStamp [ SqlColumnNumber = 58 ];

/// 无痛分娩结束后去向
Property LaborEndTransLoc As %String(DISPLAYLIST = ",病房,重症医学科,离院,死亡,重返术间", VALUELIST = ",Ward,ICU,Discharge,Death,BackOper") [ SqlColumnNumber = 59 ];

/// 安排麻醉护士
Property ArrAnaNurse As %String [ SqlColumnNumber = 60 ];

/// 麻醉护士
Property AnaNurse As %String [ SqlColumnNumber = 61 ];

/// 手术申请索引
Index IOPS On OperSchedule;

/// 手术申请外键索引
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
<Data name="AnaesthesiaDefaultData">
<Value name="1">
<Value>OperSchedule</Value>
</Value>
<Value name="2">
<Value>AnaMethod</Value>
</Value>
<Value name="3">
<Value>AnaExpert</Value>
</Value>
<Value name="4">
<Value>Anesthesiologist</Value>
</Value>
<Value name="5">
<Value>AnaAssistant</Value>
</Value>
<Value name="6">
<Value>AnaStaff</Value>
</Value>
<Value name="7">
<Value>AreaInDT</Value>
</Value>
<Value name="8">
<Value>AreaOutDT</Value>
</Value>
<Value name="9">
<Value>TheatreInDT</Value>
</Value>
<Value name="10">
<Value>TheatreOutDT</Value>
</Value>
<Value name="11">
<Value>AnaStartDT</Value>
</Value>
<Value name="12">
<Value>AnaFinishDT</Value>
</Value>
<Value name="13">
<Value>TubeInDT</Value>
</Value>
<Value name="14">
<Value>TubeOutDT</Value>
</Value>
<Value name="15">
<Value>OperStartDT</Value>
</Value>
<Value name="16">
<Value>OperFinishDT</Value>
</Value>
<Value name="17">
<Value>PACUInDT</Value>
</Value>
<Value name="18">
<Value>PACUOutDT</Value>
</Value>
<Value name="19">
<Value>ASAClass</Value>
</Value>
<Value name="20">
<Value>AnaClass</Value>
</Value>
<Value name="21">
<Value>PreFasting</Value>
</Value>
<Value name="22">
<Value>PreOperNote</Value>
</Value>
<Value name="23">
<Value>PreMedication</Value>
</Value>
<Value name="24">
<Value>OperPosition</Value>
</Value>
<Value name="25">
<Value>ECGDoctor</Value>
</Value>
<Value name="26">
<Value>TotalIn</Value>
</Value>
<Value name="27">
<Value>ColloidalVol</Value>
</Value>
<Value name="28">
<Value>CrystalloidVol</Value>
</Value>
<Value name="29">
<Value>TotalOut</Value>
</Value>
<Value name="30">
<Value>UrineVol</Value>
</Value>
<Value name="31">
<Value>WaterLossVol</Value>
</Value>
<Value name="32">
<Value>BloodLossVol</Value>
</Value>
<Value name="33">
<Value>TheatreOutTransLoc</Value>
</Value>
<Value name="34">
<Value>AreaOutTransLoc</Value>
</Value>
<Value name="35">
<Value>OutRoomAna</Value>
</Value>
<Value name="36">
<Value>AppDocConNo</Value>
</Value>
<Value name="37">
<Value>ShiftDoctor</Value>
</Value>
<Value name="38">
<Value>Pneumothorax</Value>
</Value>
<Value name="39">
<Value>Pneumoperitoneum</Value>
</Value>
<Value name="40">
<Value>RevokeUser</Value>
</Value>
<Value name="41">
<Value>RevokeDate</Value>
</Value>
<Value name="42">
<Value>RevokeTime</Value>
</Value>
<Value name="43">
<Value>AnaOperInfo</Value>
</Value>
<Value name="44">
<Value>DifficultAirway</Value>
</Value>
<Value name="45">
<Value>PostAnalgesia</Value>
</Value>
<Value name="46">
<Value>AnaEffect</Value>
</Value>
<Value name="47">
<Value>ArrAnaExpert</Value>
</Value>
<Value name="48">
<Value>ArrAnesthesiologist</Value>
</Value>
<Value name="49">
<Value>ArrAnaAssistant</Value>
</Value>
<Value name="50">
<Value>ArrAnaMethod</Value>
</Value>
<Value name="51">
<Value>ArrAnaStaff</Value>
</Value>
<Value name="52">
<Value>PrevAnaMethod</Value>
</Value>
<Value name="53">
<Value>BloodTransVol</Value>
</Value>
<Value name="54">
<Value>SelfBloodVol</Value>
</Value>
<Value name="55">
<Value>AnaEndStaff</Value>
</Value>
<Value name="56">
<Value>LaborStartDT</Value>
</Value>
<Value name="57">
<Value>LaborEndDT</Value>
</Value>
<Value name="58">
<Value>LaborEndTransLoc</Value>
</Value>
<Value name="59">
<Value>ArrAnaNurse</Value>
</Value>
<Value name="60">
<Value>AnaNurse</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.AnaesthesiaD</DataLocation>
<DefaultData>AnaesthesiaDefaultData</DefaultData>
<IdLocation>^CIS.AN.AnaesthesiaD</IdLocation>
<IndexLocation>^CIS.AN.AnaesthesiaI</IndexLocation>
<StreamLocation>^CIS.AN.AnaesthesiaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
