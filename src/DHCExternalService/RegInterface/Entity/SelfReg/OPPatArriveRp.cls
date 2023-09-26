Class DHCExternalService.RegInterface.Entity.SelfReg.OPPatArriveRp Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

/// 交易结果：0：成功 非0：错误
Property ResultCode As %String(TRUNCATE = 1);

/// 对错误/异常的详细描述信息
Property ResultContent As %String(TRUNCATE = 1);

/// 就诊科室
Property Department As %String(TRUNCATE = 1);

/// 医生
Property Doctor As %String(TRUNCATE = 1);

/// 前面病人
Property FrontNum As %String(TRUNCATE = 1);

/// 报到日期
Property ArriveDate As %String(TRUNCATE = 1);

/// 报道时间
Property ArriveTime As %String(TRUNCATE = 1);

}
