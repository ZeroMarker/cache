/// 科室病区扩展表
/// 基础数据-likefan
/// 2020-12-24
Class web.Entity.CT.CTLocExtend Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTLocExtend";

/// RowId
Property CTLOCERowID As %String;

/// itro	简介
Property CTLOCEItro As %String;

/// depttype	诊疗科目类别
Property CTLOCEDeptType As %String;

/// aprvbedcnt	批准床位数量
Property CTLOCEAprvBedCnt As %String;

/// hicrtfbedcnt	医保认可床位数
Property CTLOCEHiCrtfBedCnt As %String;

/// poolareano	统筹区编号
Property CTLOCEPoolareaNo As %String;

/// drpsncnt	医师人数
Property CTLOCEDrPsncnt As %String;

/// pharpsncnt	药师人数
Property CTLOCEPharPsncnt As %String;

/// nurspsncnt	护士人数
Property CTLOCENursPsncnt As %String;

/// tecnpsncnt	技师人数
Property CTLOCETecnPsncnt As %String;

/// 标准编码
Property CTLOCEStandardCode As %String;

/// 标准名称
Property CTLOCEStandardDesc As %String;

/// 是否医技科室
Property CTLOCEMedtechFlag As %String;

/// 科室医疗服务范围
Property CTLOCEDeptMedServScp As %String;

/// 医疗服务类型
Property CTLOCEMedservType As %String;

/// 备注
Property CTLOCEMemo As %String;

}
