/// Creator:Lid
/// CreatDate:2012-02-07
/// Description:就诊信息集合类
Class web.DHCEntity.PCA.AdmItems Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// ResultCode
Property ResultCode As %String(TRUNCATE = 1);

/// ErrorMsg
Property ErrorMsg As %String(TRUNCATE = 1);

/// AdmItem	就诊信息列表
Property AdmItems As list Of web.DHCEntity.PCA.AdmItem;

}
