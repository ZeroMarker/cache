/// 患者信息
Class DWR.PAT.MSG.Patient Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ Inheritance = right ]
{

Parameter XMLNAME = "Patient";

/// 患者ID
Property PatientID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 患者编号
Property PatientNo As %String(MAXLEN = 50, TRUNCATE = 1);

/// 患者姓名
Property PatientName As %String(MAXLEN = 50, TRUNCATE = 1);

/// 性别代码   (F-女,M-男)
Property SexCode As %String(MAXLEN = 50, TRUNCATE = 1);

/// 性别名称
Property Sex As %String(MAXLEN = 50, TRUNCATE = 1);

/// 年龄
Property Age As %String(MAXLEN = 50, TRUNCATE = 1);

/// 身高
Property Height As %String(MAXLEN = 50, TRUNCATE = 1);

/// 体重
Property Weight As %String(MAXLEN = 50, TRUNCATE = 1);

/// 血型
Property BloodType As %String(MAXLEN = 50, TRUNCATE = 1);

/// 职业
Property Occupation As %String(MAXLEN = 50, TRUNCATE = 1);

/// 婚姻状况
Property Marital As %String(MAXLEN = 50, TRUNCATE = 1);

/// 就诊号
Property EpisodeID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 入院日期       (YYYY-MM-DD)
Property InDate As %String(MAXLEN = 50, TRUNCATE = 1);

/// 住院天数       
Property InDays As %String(MAXLEN = 50, TRUNCATE = 1);

/// 床号      
Property BedNo As %String(MAXLEN = 50, TRUNCATE = 1);

/// 房间号      
Property RoomNo As %String(MAXLEN = 50, TRUNCATE = 1);

/// 病区ID    
Property WardID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 病区
Property WardName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 科室ID    
Property DepartmentID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 科室名称
Property DepartmentName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 主管医生用户ID
Property DoctorUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 主管医生
Property Doctor As %String(MAXLEN = 50, TRUNCATE = 1);

/// 病情状况名称
Property Condition As %String(MAXLEN = 50, TRUNCATE = 1);

/// 病情状况数字
Property ConditionNum As %String(MAXLEN = 50, TRUNCATE = 1);

/// 护理等级名称
Property CareLevel As %String(MAXLEN = 50, TRUNCATE = 1);

/// 护理等级数字
Property CareLevelNum As %String(MAXLEN = 50, TRUNCATE = 1);

/// 重症监护状态
Property ICStatus As %String(MAXLEN = 50, TRUNCATE = 1);

/// 重症监护状态数字
Property ICStatusNum As %String(MAXLEN = 50, TRUNCATE = 1);

/// 过敏史
Property Allergies As %String(MAXLEN = 1000, TRUNCATE = 1);

/// 查房状态           (1-查房进行中,2-未查房,3-已查房)
Property WardRoundStatus As %String(MAXLEN = 50, TRUNCATE = 1);

/// 患者照片URL
Property PatientPhotoURL As %String(MAXLEN = 500, TRUNCATE = 1);

/// 默认患者头像文件
Property PatientPhotoFile As %String(MAXLEN = 100, TRUNCATE = 1);

Storage Default
{
<Data name="PatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Age</Value>
</Value>
<Value name="3">
<Value>BedNo</Value>
</Value>
<Value name="4">
<Value>CareLevel</Value>
</Value>
<Value name="5">
<Value>CareLevelNum</Value>
</Value>
<Value name="6">
<Value>Condition</Value>
</Value>
<Value name="7">
<Value>ConditionNum</Value>
</Value>
<Value name="8">
<Value>Doctor</Value>
</Value>
<Value name="9">
<Value>EpisodeNo</Value>
</Value>
<Value name="10">
<Value>ICStatus</Value>
</Value>
<Value name="11">
<Value>ICStatusNum</Value>
</Value>
<Value name="12">
<Value>InDate</Value>
</Value>
<Value name="13">
<Value>InDays</Value>
</Value>
<Value name="14">
<Value>PatientID</Value>
</Value>
<Value name="15">
<Value>PatientName</Value>
</Value>
<Value name="16">
<Value>PatientNo</Value>
</Value>
<Value name="17">
<Value>PatientPhotoFile</Value>
</Value>
<Value name="18">
<Value>PatientPhotoURL</Value>
</Value>
<Value name="19">
<Value>Sex</Value>
</Value>
<Value name="20">
<Value>SexCode</Value>
</Value>
<Value name="21">
<Value>BloodType</Value>
</Value>
<Value name="22">
<Value>Height</Value>
</Value>
<Value name="23">
<Value>Marital</Value>
</Value>
<Value name="24">
<Value>Occupation</Value>
</Value>
<Value name="25">
<Value>RoomNo</Value>
</Value>
<Value name="26">
<Value>Ward</Value>
</Value>
<Value name="27">
<Value>weight</Value>
</Value>
<Value name="28">
<Value>WardRoundStatus</Value>
</Value>
<Value name="29">
<Value>DoctorUserID</Value>
</Value>
<Value name="30">
<Value>Allergies</Value>
</Value>
</Data>
<DataLocation>^DWR.PAT.MSG.PatientD</DataLocation>
<DefaultData>PatientDefaultData</DefaultData>
<IdLocation>^DWR.PAT.MSG.PatientD</IdLocation>
<IndexLocation>^DWR.PAT.MSG.PatientI</IndexLocation>
<StreamLocation>^DWR.PAT.MSG.PatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
