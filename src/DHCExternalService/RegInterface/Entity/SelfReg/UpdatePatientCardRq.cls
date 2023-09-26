Class DHCExternalService.RegInterface.Entity.SelfReg.UpdatePatientCardRq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

//交易代码21002

Property TradeCode As %String(TRUNCATE = 1);

//患者ID

Property PatientID As %String(TRUNCATE = 1);

//渠道代码

Property ClientType As %String(TRUNCATE = 1);

//卡类型代码

Property CardTypeCode As %String(TRUNCATE = 1);

//卡号

Property PatientCard As %String(TRUNCATE = 1);

//手机号

Property Mobile As %String(TRUNCATE = 1);

//证件类型

Property IDType As %String(TRUNCATE = 1);

//证件号码

Property IDNo As %String(TRUNCATE = 1);

//患者姓名

Property PatientName As %String(TRUNCATE = 1);

//患者地址

Property Address As %String(TRUNCATE = 1);

//联系人姓名(联系人)

Property ContactName As %String(TRUNCATE = 1);

//联系人电话(联系电话)

Property ContactTelNo As %String(TRUNCATE = 1);

//性别

Property Sex As %String(TRUNCATE = 1);

//出生日期 YYYY-MM-DD

Property DOB As %String(TRUNCATE = 1);

//是否重发标志(Y=重发,N=非重发)

Property RepeatFlag As %String(TRUNCATE = 1);

//签约标志(0=没有签约， 1= 签约)

Property SignedStatus As %String(TRUNCATE = 1);

//是否接收短信提醒(Y=接收,N=不接收)

Property RecSMSFlag As %String(TRUNCATE = 1);

//业务流水号

Property TransactionId As %String(TRUNCATE = 1);

}
