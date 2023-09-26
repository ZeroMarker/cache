Class EPRservice.entity.EKBDiagnos Extends (%Library.RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

Property ID As %String(TRUNCATE = 1);

/// 病种代码
Property Name As %String(TRUNCATE = 1);

/// 病种名称
Property Description As %String(TRUNCATE = 1);

/// 病种分组代码
Property GroupName As %String(TRUNCATE = 1);

/// 病种分组名称
Property GroupDescription As %String(TRUNCATE = 1);

/// ICD诊断代码串
Property Diagnos As %String(TRUNCATE = 1);

/// CT_Loc指针
Property CTLocID As %String(TRUNCATE = 1);

/// 创建者UserID
Property UserID As %String(TRUNCATE = 1);

/// 创建时间
Property CreateDate As %String(TRUNCATE = 1);

}
