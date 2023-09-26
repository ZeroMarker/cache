/// 检验医嘱
Class dbo.BTTestSet Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestSet, StorageStrategy = Default ]
{

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexCodeHosp On (Code, HospitalDR) [ SqlName = Index_CodeHosp, Type = index ];

Index IndexHISCode On (HospitalDR, HISCode) [ SqlName = Index_HISCode, Type = index ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTTESTSET On RowID [ PrimaryKey, SqlName = PK_BT_TESTSET, Type = index, Unique ];

/// Foreign Key FKTestSetCollect created via DDL
ForeignKey FKTestSetCollect(CollectPromptDR) References dbo.BTCollectPrompt(PKBTCOLLECTPROMPT) [ SqlName = FK_TestSetCollect ];

/// Foreign Key FKTestSetCostItem created via DDL
ForeignKey FKTestSetCostItem(CostItemDR) References dbo.BTCostItem(PKBTCOSTITEM) [ SqlName = FK_TestSetCostItem ];

/// Foreign Key FKTestSetDefContainer created via DDL
ForeignKey FKTestSetDefContainer(ContainerDR) References dbo.BTContainer(PKBTCONTAINER) [ SqlName = FK_TestSetDefContainer ];

/// Foreign Key FKTestSetDefSpecimen created via DDL
ForeignKey FKTestSetDefSpecimen(SpecimenDR) References dbo.BTSpecimen(PKBTSPECIMEN) [ SqlName = FK_TestSetDefSpecimen ];

/// Foreign Key FKTestSetHospital created via DDL
ForeignKey FKTestSetHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_TestSetHospital ];

/// Foreign Key FKTestSetReport created via DDL
ForeignKey FKTestSetReport(ReportPromptDR) References dbo.BTReportPrompt(PKBTREPORTPROMPT) [ SqlName = FK_TestSetReport ];

/// Foreign Key FKTestSetSex created via DDL
ForeignKey FKTestSetSex(SpeciesDR) References dbo.BTSpecies(PKBTSPECIES) [ SqlName = FK_TestSetSex ];

/// Foreign Key FKTestSetWorkGroup created via DDL
ForeignKey FKTestSetWorkGroup(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_TestSetWorkGroup ];

/// Foreign Key FKToTestSet created via DDL
ForeignKey FKToTestSet(ToTestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_ToTestSet ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 英文名称  
Property EName As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 6 ];

/// 描述  
Property Description As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

/// HIS对照码  
Property HISCode As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 8 ];

/// 适用性别  
Property SpeciesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 允许急诊  
Property Urgent As %Library.Boolean [ SqlColumnNumber = 10 ];

/// 默认标本类型  
Property SpecimenDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 默认容器  
Property ContainerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 默认合管类型  
Property MergeType As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 13 ];

/// 默认工作小组  
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 收费项目  
Property CostItemDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 采集提示  
Property CollectPromptDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 取报告提示  
Property ReportPromptDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 状态  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 19 ];

/// 报告类型  {N:普通,P:模板}
Property ReportType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 20 ];

/// 关联医嘱串  
Property LinkStr As %Library.String(COLLATION = "Exact", MAXLEN = 2000) [ SqlColumnNumber = 21 ];

/// 关联类型  
Property LinkType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 22 ];

/// 医嘱所属工作组  
Property WorkGroupDR As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 23 ];

/// 额外标识  {1:true,0:false}
Property ExtraFlag As %Library.Boolean [ SqlColumnNumber = 24 ];

/// 报告说明  
Property ReportRemark As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 25 ];

/// 微生物默认耐药机制  
Property MICDefDrugRule As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 26 ];

/// 阳性报警  {1:true,0:false}
Property PositiveAlarn As %Library.Boolean [ SqlColumnNumber = 27 ];

/// 工作率  
Property WorkRatio As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 28 ];

/// 报告显示类型  
Property ReportShowType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 29 ];

/// 接收费用      
Property ReceivableFee As %Library.Numeric(MAXVAL = 999999999999999.9999, MINVAL = -999999999999999.9999, SCALE = 4) [ SqlColumnNumber = 30 ];

/// 检测内容  
Property TestContent As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 31 ];

/// 检测方法  
Property TestMethod As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 32 ];

/// 检测结论 
Property TestConclusion As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 33 ];

/// 采集提示(文本) 
Property CollectPrompt As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 34 ];

/// 取报告提示(文本) 
Property ReportPrompt As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 35 ];

/// 同类医嘱归属项目组合套 
Property ToTestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 36 ];

/// 自动排样主医嘱名称（排样规则） 
Property EpisRuleName As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 37 ];

Storage Default
{
<Data name="BTTestSetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>HospitalDR</Value>
</Value>
<Value name="5">
<Value>EName</Value>
</Value>
<Value name="6">
<Value>Description</Value>
</Value>
<Value name="7">
<Value>HISCode</Value>
</Value>
<Value name="8">
<Value>SpeciesDR</Value>
</Value>
<Value name="9">
<Value>Urgent</Value>
</Value>
<Value name="10">
<Value>SpecimenDR</Value>
</Value>
<Value name="11">
<Value>ContainerDR</Value>
</Value>
<Value name="12">
<Value>MergeType</Value>
</Value>
<Value name="13">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="14">
<Value>CostItemDR</Value>
</Value>
<Value name="15">
<Value>CollectPromptDR</Value>
</Value>
<Value name="16">
<Value>ReportPromptDR</Value>
</Value>
<Value name="17">
<Value>Sequence</Value>
</Value>
<Value name="18">
<Value>Active</Value>
</Value>
<Value name="19">
<Value>ReportType</Value>
</Value>
<Value name="20">
<Value>LinkStr</Value>
</Value>
<Value name="21">
<Value>LinkType</Value>
</Value>
<Value name="22">
<Value>WorkGroupDR</Value>
</Value>
<Value name="23">
<Value>ExtraFlag</Value>
</Value>
<Value name="24">
<Value>ReportRemark</Value>
</Value>
<Value name="25">
<Value>MICDefDrugRule</Value>
</Value>
<Value name="26">
<Value>PositiveAlarn</Value>
</Value>
<Value name="27">
<Value>WorkRatio</Value>
</Value>
<Value name="28">
<Value>ReportShowType</Value>
</Value>
<Value name="29">
<Value>ReceivableFee</Value>
</Value>
<Value name="30">
<Value>TestContent</Value>
</Value>
<Value name="31">
<Value>TestMethod</Value>
</Value>
<Value name="32">
<Value>TestConclusion</Value>
</Value>
<Value name="33">
<Value>CollectPrompt</Value>
</Value>
<Value name="34">
<Value>ReportPrompt</Value>
</Value>
<Value name="35">
<Value>ToTestSetDR</Value>
</Value>
<Value name="36">
<Value>EpisRuleName</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestSetD</DataLocation>
<DefaultData>BTTestSetDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTTestSetD</IdLocation>
<IndexLocation>^dbo.BTTestSetI</IndexLocation>
<StreamLocation>^dbo.BTTestSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
