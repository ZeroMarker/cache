/// 名称: 病人类型(新框架)
/// 描述: 在模板权限中，如果一个科室有多套模板，那么需要增加一个病人类型来控制，本表保存选中的病人类型
/// 编写者：lifengbo
/// 编写日期: 2023-03-20
Class EMR.DOC.DTO.AdmPatType Extends (%RegisteredObject, %XML.Adaptor)
{

/// 病人就诊号
Property EpisodeID As %String;

/// 指定到科室
Property PatType As %String;

/// 指定病人类型的医生ID
Property AppointUserID As %String;

/// 患者关联的疾病种类
Property EMRDOCDiagnosID As %String;

}
