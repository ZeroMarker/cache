/// Function: 电子病历-身体部位实体类
/// Creator:  基础数据平台组 sunfengchao
/// CreateDate: 2014-12-17
/// BODP_RowId BODP_Code BODP_Desc BODP_CTLOC_DR
Class web.Entity.CT.MRCBodyParts Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.MRCBodyParts";

/// RowId号
Property BODPRowId As %String;

/// 代码
Property BODPCode As %String;

/// 描述
Property BODPDesc As %String;

/// 科室
Property BODPCTLOCDR As %String;

/// 输液部位标志
Property BODPInfusionFlag As %String;

}
