Class DHCExternalService.RegInterface.Entity.ImportApptToHISRt Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// ExtOrgCode	预约机构
Property ExtOrgCode As %String(TRUNCATE = 1);

/// ClientType	客户端类型
Property ClientType As %String(TRUNCATE = 1);

/// HospitalId	医院ID
Property HospitalId As %String(TRUNCATE = 1);

/// HIS	HIS厂商
Property HIS As %String(TRUNCATE = 1);

/// TransactionId	交易流水号
Property TransactionId As %String(TRUNCATE = 1);

/// PatientNo	病人主索引号
Property PatientNo As %String(TRUNCATE = 1);

/// CardNo	卡号
Property CardNo As %String(TRUNCATE = 1);

/// ExtUserID	操作员
Property ExtUserID As %String(TRUNCATE = 1);

/// RBASId	门诊排班标识
Property RBASId As %String(TRUNCATE = 1);

/// ApptDate	预约日期(YYYY-MM-DD)
Property ApptDate As %String(TRUNCATE = 1);

/// Method	预约方式
Property Method As %String(TRUNCATE = 1);

/// CredTypeCode	证件类型代码
Property CredTypeCode As %String(TRUNCATE = 1);

/// IDCardNo	身份证
Property IDCardNo As %String(TRUNCATE = 1);

/// TelePhoneNo	联系电话
Property TelePhoneNo As %String(TRUNCATE = 1);

/// MobileNo	手机号码
Property MobileNo As %String(TRUNCATE = 1);

/// PatientName	姓名
Property PatientName As %String(TRUNCATE = 1);

/// PayFlag	支付标记
Property PayFlag As %String(TRUNCATE = 1);

/// PayModeCode	支付方式代码
Property PayModeCode As %String(TRUNCATE = 1);

/// PayBankCode	银行代码
Property PayBankCode As %String(TRUNCATE = 1);

/// PayCardNo	银行卡卡号
Property PayCardNo As %String(TRUNCATE = 1);

/// PayFee	支付费用
Property PayFee As %String(TRUNCATE = 1);

/// PayTradeNo	支付交易号
Property PayTradeNo As %String(TRUNCATE = 1);

/// OrderCode	预约单号
Property OrderCode As %String(TRUNCATE = 1);

/// PayInsuFee	医保支付金额
Property PayInsuFee As %String(TRUNCATE = 1);

/// PayInsuFeeStr	医保挂号结果字符串
Property PayInsuFeeStr As %String(MAXLEN = 5000, TRUNCATE = 1);

/// ApptId	His预约ID
Property ApptId As %String(TRUNCATE = 1);

}
