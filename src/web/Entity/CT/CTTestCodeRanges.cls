/// 开发日期：2013-12-2
/// 开发人：基础数据平台组 孙凤超
/// 功能描述：7.	检验项目范围实体类
Class web.Entity.CT.CTTestCodeRanges Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTTestCodeRanges";

Property CTTCRAge As %String;

Property CTTCRClinicalConditionsDR As %String;

Property CTTCRDate As %String;

Property CTTCRHighRange As %String;

Property CTTCRLowRange As %String;

Property CTTCROrder As %String;

Property CTTCRPanicHigh As %String;

Property CTTCRPanicLow As %String;

Property CTTCRParRef As %String;

Property CTTCRPatientLocationDR As %String;

Property CTTCRPregnantHighRange As %String;

Property CTTCRPregnantLowRange As %String;

Property CTTCRPregnantPanicHighRange As %String;

Property CTTCRPregnantPanicLowRange As %String;

Property CTTCRRangesType As %String;

Property CTTCRRowId As %String;

Property CTTCRSpeciesDR As %String;

Property CTTCRWeeksOfPregnancy As %String;

}
