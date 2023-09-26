Class EMRservice.entity.EDiseaseRelation Extends (%Library.RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Property ID As %String(TRUNCATE = 1);

/// CT_Loc指针
Property CTLocID As %String [ Required ];

/// 科室病种ID
Property KBDiagnosID As %String [ Required ];

/// ICD10 ID
Property ICDID As %String [ Required ];

/// ICD10编码
Property ICDCode As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

/// ICD10名称
Property ICDName As %String(MAXLEN = 200, TRUNCATE = 1) [ Required ];

}
