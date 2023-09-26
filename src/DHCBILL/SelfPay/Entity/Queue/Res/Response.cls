Class DHCBILL.SelfPay.Entity.Queue.Res.Response Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// ResultCode 结果标志
Property ResultCode As %String(TRUNCATE = 1);

/// ResultMsg 结果描述
Property ResultMsg As %String(TRUNCATE = 1);

/// PatientID 登记号
Property PatientID As %String(TRUNCATE = 1);

/// PatName 患者姓名
Property PatName As %String(TRUNCATE = 1);

/// Sex 性别
Property Sex As %String(TRUNCATE = 1);

/// DOB 出生日期
Property DOB As %String(TRUNCATE = 1);

/// Medical 病案号
Property Medical As %String(TRUNCATE = 1);

/// AimFlag 业务类型（IPReg:入院登记,OPDep:门诊交押金,IPDep:住院交押金,IPPay:出院结算）
Property AimFlag As %String(TRUNCATE = 1);

/// IsActiveAdm 就诊标识
Property IsActiveAdm As %String(TRUNCATE = 1);

/// QueueNo 队列号
Property QueueNo As %String(TRUNCATE = 1);

/// CreatDate 生成日期
Property CreatDate As %String(TRUNCATE = 1);

/// CreatTime 生成时间
Property CreatTime As %String(TRUNCATE = 1);

/// AdmInfoList	就诊信息列表
Property AdmInfoList As list Of DHCBILL.SelfPay.Entity.GetIPAdmInfo.Res.AdmInfo(XMLITEMNAME = "AdmInfo", XMLPROJECTION = "COLLECTION");

}
