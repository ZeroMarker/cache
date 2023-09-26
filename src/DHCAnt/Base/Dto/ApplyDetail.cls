/// CTOR: QP
/// DATE: 2019-04-18
/// DESC: 抗菌药物申请单信息DTO
Class DHCAnt.Base.Dto.ApplyDetail Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 1使用目的
Property usePurpose As %Library.String(TRUNCATE = 1);

/// 2用药指征
Property drugIndication As %Library.String(TRUNCATE = 1);

/// 3感染部位
Property bodyPart As %Library.String(TRUNCATE = 1);

/// 4用药时机
Property useTime As %Library.String(TRUNCATE = 1);

/// 5特抗药指征
Property kss3Indication As %Library.String(TRUNCATE = 1);

/// 6是否送检
Property isLab As %Library.String(TRUNCATE = 1);

/// 7是否越级
Property emergency As %Library.String(TRUNCATE = 1);

/// 8越级原因
Property emergencyReason As %Library.String(TRUNCATE = 1);

// Property BLInfo As %Library.String(TRUNCATE = 1);

// ======================会诊信息=========================

/// 26病历摘要
/// 9会诊科室1
Property CLoc1 As %Library.String(TRUNCATE = 1);

/// 10会诊医生1
Property CDoc1 As %Library.String(TRUNCATE = 1);

/// 11会诊结果1
Property CAgree1 As %Library.String(TRUNCATE = 1);

/// 12会诊建议1
Property CNote1 As %Library.String(TRUNCATE = 1);

/// 13会诊时间1
Property CDT1 As %Library.String(TRUNCATE = 1);

/// 14会诊科室2
Property CLoc2 As %Library.String(TRUNCATE = 1);

/// 15会诊医生2
Property CDoc2 As %Library.String(TRUNCATE = 1);

/// 16会诊结果2
Property CAgree2 As %Library.String(TRUNCATE = 1);

/// 17会诊建议2
Property CNote2 As %Library.String(TRUNCATE = 1);

/// 18会诊时间2
Property CDT2 As %Library.String(TRUNCATE = 1);

/// 19会诊科室3
Property CLoc3 As %Library.String(TRUNCATE = 1);

/// 20会诊医生3
Property CDoc3 As %Library.String(TRUNCATE = 1);

/// 21会诊结果3
Property CAgree3 As %Library.String(TRUNCATE = 1);

/// 22会诊建议3
Property CNote3 As %Library.String(TRUNCATE = 1);

/// 23会诊时间3
Property CDT3 As %Library.String(TRUNCATE = 1);

// ======================医嘱信息=========================

/// 24用法
Property instruc As %Library.String(TRUNCATE = 1);

/// 25频次
Property freq As %Library.String(TRUNCATE = 1);

}
