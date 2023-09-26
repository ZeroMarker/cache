/// 名称:场景关联厂商表 Entity
/// 编写者:基础数据平台-likefan
/// 编写日期: 2020-09-25
Class web.Entity.ASR.ASRCommandCompany Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.ASR.ASRCommandCompany";

/// RowId
Property ASRCCID As %String;

/// 应用场景DR
Property ASRCCScenesDR As %String;

/// 厂商DR
Property ASRCCCompanyDR As %String;

/// 开始日期
Property ASRCCDateFrom As %String;

/// 结束日期
Property ASRCCDateTo As %String;

}
