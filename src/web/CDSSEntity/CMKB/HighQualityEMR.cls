/// 名称:优质病历字典表
/// 描述:实体类
/// 编写者:基础数据平台组 - 丁亚男
/// 编写日期:2023-3-27
Class web.CDSSEntity.CMKB.HighQualityEMR Extends (%RegisteredObject, web.DHCEntity.ELAbstract)
{

Parameter PersistentClassName = "web.CDSSEntity.CMKB.HighQualityEMR";

/// rowid
Property RowId As %String;

/// 病例类型（入院记录/首次病程记录...）
Property EMRType As %String;

/// 病历内容（JSON信息）
Property EMRContent As %String;

/// 就诊类型（急诊、门诊、住院）
Property VisitType As %String;

/// 科室名称
Property Loc As %String;

/// 姓名
Property Name As %String;

/// 性别
Property Sex As %String;

/// 年龄
Property Age As %String;

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
Property HospitalDate As %String;

/// 记录日期
Property RecordDate As %String;

/// 主管医师
Property DoctorName As %String;

/// 血型
Property BloodGroup As %String;

/// 出生日期
Property Birthday As %String;

/// 妊娠/产后状态
Property PregStatus As %String;

/// 孕周（通过识别词算法来判断）
Property GestWeek As %String;

/// 备注
Property Remarks As %String;

/// 使用标志（0编辑中，1已删除，2已审核）
Property UseFlag As %String;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %String;

/// 病历编码
Property EMRCode As %String;

}
