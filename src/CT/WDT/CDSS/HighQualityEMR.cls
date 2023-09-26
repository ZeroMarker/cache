/// Creator:谷雪萍
/// CreatDate:2023-03-21
/// Description：优质病历字典表
/// Table：CT_WDT_CDSS.HighQualityEMR
Class CT.WDT.CDSS.HighQualityEMR Extends (%Persistent, User.Abstract)
{

/// 病例类型（入院记录/首次病程记录...）
Property EMRType As %String [ Required ];

/// 病历内容（JSON信息）
Property EMRContent As %String(MAXLEN = "") [ Required ];

/// 就诊类型（急诊、门诊、住院）
Property VisitType As %String;

/// 科室名称
Property Loc As %String;

/// 姓名
Property Name As %String;

/// 性别
Property Sex As %String;

/// 年龄
Property Age As %Integer;

/// 婚姻
Property Marriage As %String;

/// 籍贯
Property Birthplace As %String;

/// 民族
Property Nation As %String;

/// 职业
Property Profession As %String;

/// 地址
Property CurrentAddress As %String;

/// 病史表达者
Property Expressionist As %String;

/// 靠谱程度
Property ReliableDegree As %String;

/// 住院日期
Property HospitalDate As %TimeStamp;

/// 记录日期
Property RecordDate As %TimeStamp;

/// 主管医师
Property DoctorName As %String;

/// 血型
Property BloodGroup As %String;

/// 出生日期
Property Birthday As %TimeStamp;

/// 妊娠/产后状态（通过入院诊断等通过识别词来判断）
Property PregStatus As %String;

/// 孕周（通过识别词算法来判断）
Property GestWeek As %String;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 使用标志（0编辑中，1已删除，2已审核）
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 病历编码
Property EMRCode As %String;

Index LocIndex On Loc As Exact;

Index SexIndex On Sex As Exact;

Storage Default
{
<Data name="HighQualityEMRDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EMRType</Value>
</Value>
<Value name="3">
<Value>EMRContent</Value>
</Value>
<Value name="4">
<Value>VisitType</Value>
</Value>
<Value name="5">
<Value>Loc</Value>
</Value>
<Value name="6">
<Value>Name</Value>
</Value>
<Value name="7">
<Value>Sex</Value>
</Value>
<Value name="8">
<Value>Age</Value>
</Value>
<Value name="9">
<Value>Marriage</Value>
</Value>
<Value name="10">
<Value>Birthplace</Value>
</Value>
<Value name="11">
<Value>Nation</Value>
</Value>
<Value name="12">
<Value>Profession</Value>
</Value>
<Value name="13">
<Value>CurrentAddress</Value>
</Value>
<Value name="14">
<Value>Expressionist</Value>
</Value>
<Value name="15">
<Value>ReliableDegree</Value>
</Value>
<Value name="16">
<Value>HospitalDate</Value>
</Value>
<Value name="17">
<Value>RecordDate</Value>
</Value>
<Value name="18">
<Value>DoctorName</Value>
</Value>
<Value name="19">
<Value>BloodGroup</Value>
</Value>
<Value name="20">
<Value>Birthday</Value>
</Value>
<Value name="21">
<Value>PregStatus</Value>
</Value>
<Value name="22">
<Value>GestWeek</Value>
</Value>
<Value name="23">
<Value>Remarks</Value>
</Value>
<Value name="24">
<Value>UseFlag</Value>
</Value>
<Value name="25">
<Value>UpdateUser</Value>
</Value>
<Value name="26">
<Value>UpdateDate</Value>
</Value>
<Value name="27">
<Value>EMRCode</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.HighQualityEMRD</DataLocation>
<DefaultData>HighQualityEMRDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.HighQualityEMRD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.HighQualityEMRI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.HighQualityEMRS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
