Class DHCExternalService.RegInterface.Entity.SelfReg.CanclePatientCardRq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

//交易代码21003

Property TradeCode As %String(TRUNCATE = 1);

//渠道代码（交易发起方）

Property ClientType As %String(TRUNCATE = 1);

//医院代码

Property HospitalID As %String(TRUNCATE = 1);

//交易日期YYYY-MM-DD

Property TradeDate As %String(TRUNCATE = 1);

//交易时间hh:mm:ss

Property TradeTime As %String(TRUNCATE = 1);

//收费员代码（自助机在HIS登记的代码）

Property Userid As %String(TRUNCATE = 1);

//患者ID

Property PatientID As %String(TRUNCATE = 1);

//卡类型代码

Property CardTypeCode As %String(TRUNCATE = 1);

//卡号

Property PatientCard As %String(TRUNCATE = 1);

//证件类型

Property IDType As %String(TRUNCATE = 1);

//证件号码

Property IDNo As %String(TRUNCATE = 1);

//手机号码

Property Mobile As %String(TRUNCATE = 1);

//患者姓名

Property PatientName As %String(TRUNCATE = 1);

//是否重发标志(Y=重发,N=非重发)

Property RepeatFlag As %String(TRUNCATE = 1);

//业务流水号

Property TransactionId As %String(TRUNCATE = 1);

}
