/// Creator:wangjian
/// CreatDate:2013-02-19
/// Description:住院预交金获取患者基本信息和住院记录出参
Class DHCExternalService.BillInterface.DHCEntity.IPPatientInfoResponse Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

//=1 导入时忽略不存在的属性；=0 导入时有不存在的属性会报错。

Parameter XMLIGNOREINVALIDTAG = 1;

//=0 导入时有不存在的元素会报错；=1 导入时忽略不存在的元素。

Parameter XMLIGNORENULL = 1;

//=0 导入时空字符将被保存成$C(0),$C(0)导成XML时是空标签(i.e. <tag />)；如果导入时是缺少标签，将保存成"",""导成XML时没有标签。

//=1 导入时缺少标签和空字符串都保存成"";""和$C(0)导成XML时是空标签(i.e. <tag />)

//=inputonly 导入时缺少标签和空字符串都保存成"";$C(0)导成XML时是空标签(i.e. <tag />),""导成XML时没有标签。

/// ResultCode	交易结果 非0 错误
Property ResultCode As %String(TRUNCATE = 1);

/// ResultContent	对错误/异常的详细描述信息
Property ResultContent As %String(TRUNCATE = 1);

/// PatientID	患者ID
Property PatientID As %String(TRUNCATE = 1);

/// PatientName	 患者姓名
Property PatientName As %String(TRUNCATE = 1);

/// SexCode	性别代码
Property SexCode As %String(TRUNCATE = 1);

/// Sex	性别
Property Sex As %String(TRUNCATE = 1);

/// DOB	出生日期
Property DOB As %String(TRUNCATE = 1);

/// MRID	病案号
Property MRID As %String(TRUNCATE = 1);

/// Address	家庭住址
Property Address As %String(TRUNCATE = 1);

/// IDTypeCode	证件类型（代码）
Property IDTypeCode As %String(TRUNCATE = 1);

/// IDType	证件类型（描述）
Property IDType As %String(TRUNCATE = 1);

/// IDNo	证件号
Property IDNo As %String(TRUNCATE = 1);

/// PatType	患者类型描述
Property PatType As %String(TRUNCATE = 1);

/// AdmID	就诊号
Property AdmID As %String(TRUNCATE = 1);

/// AdmDate	就诊日期
Property AdmDate As %String(TRUNCATE = 1);

/// AdmLoc	就诊科室
Property AdmLoc As %String(TRUNCATE = 1);

/// DepositAmount	住院预交金余额
Property DepositAmount As %String(TRUNCATE = 1);

/// 预交金总额
Property PrepayAmout As %String(TRUNCATE = 1);

/// 已结算总额
Property Settled As %String(TRUNCATE = 1);

/// 费用总额
Property TotalAmout As %String(TRUNCATE = 1);

/// 住院号
Property MedcareNo As %String(TRUNCATE = 1);

/// 出院日期
Property DiscChargeDate As %String(TRUNCATE = 1);

/// 住院天数
Property InDays As %String(TRUNCATE = 1);

/// 状态
Property PatVisutus As %String(TRUNCATE = 1);

/// 院区
Property HospitalId As %String(TRUNCATE = 1);

/// 科室代码
Property DeptId As %String(TRUNCATE = 1);

/// 床位
Property BedNo As %String(TRUNCATE = 1);

/// 主管医生
Property ChargeDoctorId As %String(TRUNCATE = 1);

/// 主管医生名
Property ChargeDoctorName As %String(TRUNCATE = 1);

/// 主管护师
Property ChargeNurseId As %String(TRUNCATE = 1);

/// 主管护师名
Property ChargeNurseName As %String(TRUNCATE = 1);

/// 联系电话
Property ConnectPhone As %String(TRUNCATE = 1);

/// 关系人
Property RelatePerson As %String(TRUNCATE = 1);

/// 关系
Property Relation As %String(TRUNCATE = 1);

/// 联系人电话
Property RelatePhone As %String(TRUNCATE = 1);

/// 备注
Property Remark As %String(TRUNCATE = 1);

}
