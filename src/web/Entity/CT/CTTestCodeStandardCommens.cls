/// 描述：体检 CT_TestCodeStandardCommen 实体类
/// 编写者：基础数据平台组 孙凤超
/// 开发日期：2013-12-02
Class web.Entity.CT.CTTestCodeStandardCommens Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.CT.CTTestCodeStandardCommens";

Property CTTCTRowId As %String;

Property CTTCTCode As %String;

Property ParentRowId As %String;

Property CTTCTComments As %String;

/// 代码
Property CTTCTText As %String;

/// 备注内容
Property CTTCTParRef As %String;

Property CTTCTActivityDR As %String;

Property CTTCTCumPrint As %String;

/// 危机值标记
Property CTTCTSummary As %String;

Property CTTCTFlag As %String;

/// 结果标记
Property CTTCTActiveFlag As %String;

/// /激活标记 
Property CTTCTFormatted As %String;

Property CTTCTCancerCouncilCodes As %String;

}
