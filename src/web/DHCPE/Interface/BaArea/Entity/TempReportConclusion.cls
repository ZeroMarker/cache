/// 体检小结
Class web.DHCPE.Interface.BaArea.Entity.TempReportConclusion Extends (%RegisteredObject, %XML.Adaptor)
{

/// 体检系统中的唯一编号
Property RecordNO As %String;

/// 科室名称
Property SectionName As %String;

/// 科室小结
Property Conclusion As %String;

/// 检查人
Property CheckUser As %String;

/// 检查时间
Property CheckTime As %String;

}
