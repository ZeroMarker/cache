/// 首页手术取值接口
Class DHCWMR.FP.IOOperation Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// 记录ID
Property IOORecordID As %String(TRUNCATE = 1);

/// 手术ICD10
Property IOOICD10 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术名称
Property IOOICDDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 类型（手术、操作）
Property IOOType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术日期
Property IOOOperDate As %String(MAXLEN = 100, TRUNCATE = 1);

/// 术者（SS_User.ID）
Property IOOOperator As %String(MAXLEN = 100, TRUNCATE = 1);

/// 术者-姓名
Property IOOOperatorTxt As %String(MAXLEN = 100, TRUNCATE = 1);

/// 一助（SS_User.ID）
Property IOOAssistant1 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 一助-姓名
Property IOOAssistant1Txt As %String(MAXLEN = 100, TRUNCATE = 1);

/// 二助（SS_User.ID）
Property IOOAssistant2 As %String(MAXLEN = 100, TRUNCATE = 1);

/// 二助-姓名
Property IOOAssistant2Txt As %String(MAXLEN = 100, TRUNCATE = 1);

/// 麻醉方式
Property IOONarcosisType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 麻醉医师（SS_User.ID）
Property IOONarcosisDoc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 麻醉医师-姓名
Property IOONarcosisDocTxt As %String(MAXLEN = 100, TRUNCATE = 1);

/// 切口类型
Property IOOCutType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 愈合情况
Property IOOHealing As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术级别
Property IOOOperLevel As %String(MAXLEN = 100, TRUNCATE = 1);

}
