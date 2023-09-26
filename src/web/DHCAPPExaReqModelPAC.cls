Class web.DHCAPPExaReqModelPAC Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

Parameter XMLNAME = "AppBill";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 病案号
Property MedicareNo As %String(TRUNCATE = 1);

/// 卡号
Property CardNo As %String(TRUNCATE = 1);

/// 医保卡号
Property InsuranceNo As %String(TRUNCATE = 1);

/// 登记号
Property RegNo As %String(TRUNCATE = 1);

/// 姓名
Property Name As %String(TRUNCATE = 1);

/// 性别
Property Sex As %String(TRUNCATE = 1);

/// 生日
Property DOB As %String(TRUNCATE = 1);

/// 年龄
Property Age As %String(TRUNCATE = 1);

/// 体重
Property PWeight As %String(TRUNCATE = 1);

/// 身高
Property PHeight As %String(TRUNCATE = 1);

/// 病房
Property Ward As %String(TRUNCATE = 1);

/// 床号
Property BedNo As %String(TRUNCATE = 1);

/// 申请科室
Property InLoc As %String(TRUNCATE = 1);

/// 开单医生
Property AppDoc As %String(TRUNCATE = 1);

/// 执行科室
Property RecLoc As %String(TRUNCATE = 1);

/// 申请日期
Property AppDate As %String(TRUNCATE = 1);

/// 电话
Property TelNo As %String(TRUNCATE = 1);

/// 住址
Property address As %String(TRUNCATE = 1);

/// 医嘱名称
Property OrdName As %String(TRUNCATE = 1);

/// 总价格
Property price As %String(TRUNCATE = 1);

/// 病人类型
Property TypeDesc As %String(TRUNCATE = 1);

/// ""
Property Epissubtype As %String(TRUNCATE = 1);

/// 病人等级
Property PatLevel As %String(TRUNCATE = 1);

/// 秘密等级
Property EncryptLevel As %String(TRUNCATE = 1);

/// ""
Property PerTempl As %String(TRUNCATE = 1);

/// 医嘱Rowid
Property OEorditemID As %String(TRUNCATE = 1);

/// 是否加急
Property ungent As %String(TRUNCATE = 1);

/// 病史及临床所见
Property PatientNow As %String(TRUNCATE = 1);

/// 主诊断
Property MainDiagose As %String(TRUNCATE = 1);

/// 检查目的
Property purpose As %String(TRUNCATE = 1);

/// 体位列表
Property PostureList As %String(TRUNCATE = 1);

/// 选择的体位
Property SelPostureList As %String(TRUNCATE = 1);

/// 部位列表
Property BodyList As %String(TRUNCATE = 1);

/// 选择的部位
Property SelBodyPart As %String(TRUNCATE = 1);

/// 其他部位
Property OtherBodyPart As %String(TRUNCATE = 1);

/// 备用1
Property Content1 As %String(TRUNCATE = 1);

/// 备用2
Property Content2 As %String(TRUNCATE = 1);

/// 备用3
Property Content3 As %String(TRUNCATE = 1);

/// 备用4
Property Content4 As %String(TRUNCATE = 1);

/// 备用5
Property Content5 As %String(TRUNCATE = 1);

/// 备用6
Property Content6 As %String(TRUNCATE = 1);

/// 备用7
Property Content7 As %String(TRUNCATE = 1);

/// 备用8
Property Content8 As %String(TRUNCATE = 1);

/// 备用9
Property Content9 As %String(TRUNCATE = 1);

/// 备用10
Property Content10 As %String(TRUNCATE = 1);

/// 备用11
Property Content11 As %String(TRUNCATE = 1);

/// 期望日期
Property HopeDate As %String(TRUNCATE = 1);

/// ""
Property LocDoctor As %String(TRUNCATE = 1);

Storage Default
{
<Data name="DHCAPPExaReqModelPACDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCAPPExaReqModelPACD</DataLocation>
<DefaultData>DHCAPPExaReqModelPACDefaultData</DefaultData>
<IdLocation>^web.DHCAPPExaReqModelPACD</IdLocation>
<IndexLocation>^web.DHCAPPExaReqModelPACI</IndexLocation>
<StreamLocation>^web.DHCAPPExaReqModelPACS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
