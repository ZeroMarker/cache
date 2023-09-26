/// Creator:wangjian
/// CreatDate:2013-02-19
/// Description:住院预交金获取患者基本信息和住院记录入参
Class DHCExternalService.BillInterface.DHCEntity.IPPatientInfoRequest Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

//=1 导入时忽略不存在的属性；=0 导入时有不存在的属性会报错。

Parameter XMLIGNOREINVALIDTAG = 1;

//=0 导入时有不存在的元素会报错；=1 导入时忽略不存在的元素。

Parameter XMLIGNORENULL = 0;

//=0 导入时空字符将被保存成$C(0),$C(0)导成XML时是空标签(i.e. <tag />)；如果导入时是缺少标签，将保存成"",""导成XML时没有标签。

//=1 导入时缺少标签和空字符串都保存成"";""和$C(0)导成XML时是空标签(i.e. <tag />)

//=inputonly 导入时缺少标签和空字符串都保存成"";$C(0)导成XML时是空标签(i.e. <tag />),""导成XML时没有标签。

/// TradeCode	交易代码
Property TradeCode As %String(TRUNCATE = 1);

/// TransactionId	交易流水号
Property TransactionId As %String(TRUNCATE = 1);

/// ExtOrgCode	外部机构
Property ExtOrgCode As %String(TRUNCATE = 1);

/// ClientType	客户端类型
Property ClientType As %String(TRUNCATE = 1);

/// TerminalID	终端编码
Property TerminalID As %String(TRUNCATE = 1);

/// HospitalId	医院唯一编号
Property HospitalId As %String(TRUNCATE = 1);

/// ExtUserID	操作员代码
Property ExtUserID As %String(TRUNCATE = 1);

/// PatientCard	卡号
Property PatientCard As %String(TRUNCATE = 1);

/// CardType	卡类型
Property CardType As %String(TRUNCATE = 1);

/// SecrityNo	就诊卡校验码
Property SecrityNo As %String(TRUNCATE = 1);

/// PatientID	患者ID
Property PatientID As %String(TRUNCATE = 1);

}
