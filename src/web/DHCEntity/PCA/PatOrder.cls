/// Creator:Lid
/// CreatDate:2012-02-07
/// Description:病人医嘱信息类
Class web.DHCEntity.PCA.PatOrder Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// ResultCode
Property ResultCode As %String(TRUNCATE = 1);

/// ErrorMsg
Property ErrorMsg As %String(TRUNCATE = 1);

/// AdmReasonCount
Property AdmReasonCount As %String(TRUNCATE = 1);

/// 门诊分类集合
Property AdmReasons As list Of web.DHCEntity.PCA.AdmReason;

}
