Class DHCBILL.SelfPay.Entity.IPRegister.Req.Request Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// TradeCode 交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// HospitalID 院区ID
Property HospitalID As %String(TRUNCATE = 1);

/// CardNo 卡号
Property CardNo As %String(TRUNCATE = 1);

/// CardType 卡类型
Property CardType As %String(TRUNCATE = 1);

/// SecrityNo 校验码
Property SecrityNo As %String(TRUNCATE = 1);

/// PatientID 患者ID(HIS登记号)
Property PatientID As %String(TRUNCATE = 1);

/// MedicalNo 病案号
Property MedicalNo As %String(TRUNCATE = 1);

/// UserCode 用户代码
Property UserCode As %String(TRUNCATE = 1);

/// TerminalID 终端号（自助机编号）
Property TerminalID As %String(TRUNCATE = 1);

/// IPBookID 住院证ID
Property IPBookID As %String(TRUNCATE = 1);

/// AdmReason 就诊费别
Property AdmReason As %String(TRUNCATE = 1);

/// Dept 就诊科室
Property Dept As %String(TRUNCATE = 1);

/// Ward 就诊病区
Property Ward As %String(TRUNCATE = 1);

/// Doctor 入院医生
Property Doctor As %String(TRUNCATE = 1);

}
