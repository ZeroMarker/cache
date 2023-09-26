Class EPRservice.entity.Quality.EQualityPhasesModify Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// ID
Property ID As %String(TRUNCATE = 1);

/// 指控项目RowID
Property QualityEntryDR As %String(TRUNCATE = 1);

/// 阶段名称
Property QualityPhaseStatusDR As %String(TRUNCATE = 1);

/// 阶段参数
Property QualityQueryDR As %String(TRUNCATE = 1);

/// 备注
Property PhaseDemo As %String(TRUNCATE = 1);

}
