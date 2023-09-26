/// 名称:标准版检验-取报告提示
/// 编写者:基础数据平台组 - 钟荣枫
/// 编写日期: 2019-11-18
Class web.Entity.LAB.BTReportPrompt Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.LAB.BTReportPrompt";

// rowid

Property RowID As %String;

// 代码

Property Code As %String;

// 名称

Property CName As %String;

// 医院

Property HospitalDR As %String;

// 提示详情

Property PmtDT As %String;

// 地点

Property Place As %String;

// 备注

Property Remark As %String;

// 序号

Property Sequence As %String;

// 激活

Property Active As %String;

}
