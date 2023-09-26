/// Desc:用户数据加载规则
/// Creator:Candy
Class DHCEPRFS.Entity.EQueryDataLoadRule Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock ]
{

/// 出院科室
Property DisLoc As %XML.DataSet;

/// 出院开始日期
Property DisSDate As %String(TRUNCATE = 1);

/// 出院结束日期
Property DisEDate As %String(TRUNCATE = 1);

/// 病案号^病案号
Property MedNos As %String(TRUNCATE = 1);

/// 可查看的病历目录
Property RecordCategory As %String(TRUNCATE = 1);

}
