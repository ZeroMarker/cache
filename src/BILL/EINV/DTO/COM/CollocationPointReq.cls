Class BILL.EINV.DTO.COM.CollocationPointReq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// ConfigCode	配置点
Property ConfigCode As %String(TRUNCATE = 1);

/// AdmReasonCode	费别
Property AdmReasonCode As %String(TRUNCATE = 1);

/// AdmTypeCode	就诊类型
Property AdmTypeCode As %String(TRUNCATE = 1);

/// DepartCode 科室
Property DepartCode As %String(TRUNCATE = 1);

/// HospitalNo	医院
Property HospitalNo As %String(TRUNCATE = 1);

/// PaymodeCode	支付方式
Property PaymodeCode As %String(TRUNCATE = 1);

/// UserGrpCode	安全组
Property UserGrpCode As %String(TRUNCATE = 1);

/// UserCode	用户
Property UserCode As %String(TRUNCATE = 1);

}
