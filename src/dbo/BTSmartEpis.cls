/// 排样规则 表
Class dbo.BTSmartEpis Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_SmartEpis ]
{

/// Foreign Key FKBTSmartEpisWorkGroupMachineDR created via DDL
ForeignKey FKBTSmartEpisWorkGroupMachineDR(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_BTSmartEpisWorkGroupMachineDR ];

/// Foreign Key FKBTSmartEpisWorkGroupDR created via DDL
ForeignKey FKBTSmartEpisWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BTSmartEpisWorkGroupDR ];

/// Foreign Key FKBTSmartEpisSYSRuleDR created via DDL
ForeignKey FKBTSmartEpisSYSRuleDR(SYSRuleDR) References dbo.SYSRuleNoBase(PKSYSRULENOBASE) [ SqlName = FK_BTSmartEpisSYSRuleDR ];

/// Foreign Key FKBTSmartEpisSYSRuleDR created via DDL
ForeignKey FKBTSmartEpisTSGroupDR(SmartEpisTSGroupDR) References dbo.BTSmartEpisTSGroup(PKBTSmartEpisTSGroup) [ SqlName = FK_BTSmartEpisTSGroupDR ];

/// DDL Primary Key Specification
Index PKBTSmartEpis On RowID [ PrimaryKey, SqlName = PK_BT_SmartEpis, Type = index, Unique ];

Index IndexMaster On (WorkGroupDR, Code) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexPriority On (WorkGroupDR, Priority) [ SqlName = Index_Priority, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

/// 名称
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

/// 工作小组	
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 号段
Property SYSRuleDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 匹配方式  0:包含匹配,1:精确匹配
Property MatchWay As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 7 ];

/// 匹配医嘱 医嘱有分堆，则分堆内的医嘱走完全匹配找规则，分堆外的医嘱找规则。医嘱不包含分堆，则需要所有的医嘱都完全匹配找规则。数据格式：A,A+B,B+C。
Property MTestSets As %Library.String(COLLATION = "Exact", MAXLEN = 2000) [ SqlColumnNumber = 8 ];

/// 排样规则医嘱分堆
Property SmartEpisTSGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 就诊类型Code(可多个)逗号分割
Property AdmTypeGP As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 10 ];

/// 医嘱加急
Property TSUrgentGP As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 11 ];

/// 开始时间
Property SttTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 结束时间
Property EndTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 优先级
Property Priority As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 孔位数   后两位最大号
Property LastMaxNo As %Library.Integer(MAXVAL = 99, MINVAL = 1) [ SqlColumnNumber = 15 ];

/// 打印份数
Property PrintNum As %Library.Integer(MAXVAL = 99, MINVAL = 1) [ SqlColumnNumber = 16 ];

/// 激活
Property Active As %Library.Boolean [ SqlColumnNumber = 17 ];

/// 工作组
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 18 ];

/// 开始号
Property StartNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

/// 结束号
Property MaxNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

Storage Default
{
<Data name="BTSmartEpisDefaultData">
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
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="5">
<Value>SYSRuleDR</Value>
</Value>
<Value name="6">
<Value>MatchWay</Value>
</Value>
<Value name="7">
<Value>MTestSets</Value>
</Value>
<Value name="8">
<Value>SmartEpisTSGroupDR</Value>
</Value>
<Value name="9">
<Value>AdmTypeGP</Value>
</Value>
<Value name="10">
<Value>TSUrgentGP</Value>
</Value>
<Value name="11">
<Value>SttTime</Value>
</Value>
<Value name="12">
<Value>EndTime</Value>
</Value>
<Value name="13">
<Value>Priority</Value>
</Value>
<Value name="14">
<Value>LastMaxNo</Value>
</Value>
<Value name="15">
<Value>PrintNum</Value>
</Value>
<Value name="16">
<Value>Active</Value>
</Value>
<Value name="17">
<Value>WorkGroupDR</Value>
</Value>
<Value name="18">
<Value>StartNo</Value>
</Value>
<Value name="19">
<Value>MaxNo</Value>
</Value>
</Data>
<DataLocation>^dbo.BTSmartEpisD</DataLocation>
<DefaultData>BTSmartEpisDefaultData</DefaultData>
<IdLocation>^dbo.BTSmartEpisD</IdLocation>
<IndexLocation>^dbo.BTSmartEpisI</IndexLocation>
<StreamLocation>^dbo.BTSmartEpisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
