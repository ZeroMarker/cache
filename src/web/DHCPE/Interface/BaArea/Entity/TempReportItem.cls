/// 体检小项
Class web.DHCPE.Interface.BaArea.Entity.TempReportItem Extends (%RegisteredObject, %XML.Adaptor)
{

/// 体检编号
Property recordno As %String;

/// 科室名称
Property sectionname As %String;

/// 项目名称
Property itemname As %String;

/// 项目结果
Property examdetail As %String;

/// 参考范围
Property refranger As %String;

/// 单位
Property unit As %String;

/// 项目标示
Property itemmemo As %String;

/// 排序
Property orderid As %String;

}
