/// 名称:标准版检验-项目组合套
/// 编写者:基础数据平台组 - 钟荣枫
/// 编写日期: 2019-11-6
Class web.Entity.LAB.BTTestSet Extends (%RegisteredObject, web.DHCEntity.ELAbstract) [ ProcedureBlock ]
{

Parameter PersistentClassName = "web.Entity.LAB.BTTestSet";

// RowID

Property RowID As %String;

/// 代码  
Property Code As %String;

/// 名称  
Property CName As %String;

/// 医院  
Property HospitalDR As %String;

/// 英文名称  
Property EName As %String;

/// 描述  
Property Description As %String;

/// HIS对照码  
Property HISCode As %String;

/// 适用性别  
Property SpeciesDR As %String;

/// 允许急诊  
Property Urgent As %String;

/// 默认标本类型  
Property SpecimenDR As %String;

/// 默认容器  
Property ContainerDR As %String;

/// 默认合管类型  
Property MergeType As %String;

/// 默认工作小组  
Property WorkGroupMachineDR As %String;

/// 收费项目  
Property CostItemDR As %String;

/// 采集提示  
Property CollectPromptDR As %String;

/// 取报告提示  
Property ReportPromptDR As %String;

/// 序号  
Property Sequence As %String;

/// 状态  {1:true,0:false}
Property Active As %String;

/// 报告类型  {N:普通,P:模板}
Property ReportType As %String;

/// 关联医嘱串  
Property LinkStr As %String;

/// 关联类型  
Property LinkType As %String;

/// 医嘱所属工作组  
Property WorkGroupDR As %String;

/// 额外标识  {1:true,0:false}
Property ExtraFlag As %String;

/// 报告说明  
Property ReportRemark As %String;

/// 微生物默认耐药机制  
Property MICDefDrugRule As %String;

/// 阳性报警  {1:true,0:false}
Property PositiveAlarn As %String;

/// 工作率  
Property WorkRatio As %String;

/// 报告显示类型  
Property ReportShowType As %String;

/// 接收费用      
Property ReceivableFee As %String;

/// 检测内容  
Property TestContent As %String;

/// 检测方法  
Property TestMethod As %String;

/// 检测结论 
Property TestConclusion As %String;

/// 采集提示(文本) 
Property CollectPrompt As %String;

/// 取报告提示(文本) 
Property ReportPrompt As %String;

/// 同类医嘱归属项目组合套 
Property ToTestSetDR As %String;

/// 自动排样主医嘱名称（排样规则） 
Property EpisRuleName As %String;

}
