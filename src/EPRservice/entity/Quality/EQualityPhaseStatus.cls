Class EPRservice.entity.Quality.EQualityPhaseStatus Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// ID
Property ID As %String(TRUNCATE = 1);

/// 阶段名称
Property PhaseName As %String(TRUNCATE = 1);

/// 阶段描述
Property PhaseDesc As %String(MAXLEN = 500, TRUNCATE = 1);

/// 颜色代码
Property ColorID As %String(TRUNCATE = 1);

/// 顺序
Property Sequence As %String(TRUNCATE = 1);

}
