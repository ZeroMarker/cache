/// 规则编号基础
Class dbo.SYSRuleNoBase Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_RuleNoBase ]
{

Index IndexHospital On HospitalDR [ SqlName = Index_Hospital, Type = index ];

Index IndexWorkGroup On WorkGroupDR [ SqlName = Index_WorkGroup, Type = index ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKSYSRULENOBASE On RowID [ PrimaryKey, SqlName = PK_SYS_RULENOBASE, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

/// 规则串  
Property RuleStr As %Library.String(COLLATION = "Exact", MAXLEN = 4000) [ SqlColumnNumber = 5 ];

/// 当前号  
Property CurNo As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 6 ];

/// 类型  {0:系统,1:检验,2:微生物,3:血库,4:试剂,5:其他}
Property Type As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 7 ];

/// 是否连续编号  {1:true,0:false}
Property IsContinuousNo As %Library.Boolean [ SqlColumnNumber = 8 ];

/// 日期变化是否重置号  {1:true,0:false}
Property IsIsDateNoReset As %Library.Boolean [ SqlColumnNumber = 9 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 11 ];

/// 是否处理数字  {1:true,0:false}
Property IsToNumber As %Library.Boolean [ SqlColumnNumber = 12 ];

/// 最大号  
Property MaxNo As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 13 ];

/// 前缀  
Property StartStr As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 14 ];

/// 重置标识  
Property ResetFlag As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 开始号  
Property StartNo As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 16 ];

/// 所属医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 所属工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Storage Default
{
<Data name="SYSRuleNoBaseDefaultData">
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
<Value>RuleStr</Value>
</Value>
<Value name="5">
<Value>CurNo</Value>
</Value>
<Value name="6">
<Value>Type</Value>
</Value>
<Value name="7">
<Value>IsContinuousNo</Value>
</Value>
<Value name="8">
<Value>IsIsDateNoReset</Value>
</Value>
<Value name="9">
<Value>Sequence</Value>
</Value>
<Value name="10">
<Value>Active</Value>
</Value>
<Value name="11">
<Value>IsToNumber</Value>
</Value>
<Value name="12">
<Value>MaxNo</Value>
</Value>
<Value name="13">
<Value>StartStr</Value>
</Value>
<Value name="14">
<Value>ResetFlag</Value>
</Value>
<Value name="15">
<Value>StartNo</Value>
</Value>
<Value name="16">
<Value>HospitalDR</Value>
</Value>
<Value name="17">
<Value>WorkGroupDR</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSRuleNoBaseD</DataLocation>
<DefaultData>SYSRuleNoBaseDefaultData</DefaultData>
<IdLocation>^dbo.SYSRuleNoBaseD</IdLocation>
<IndexLocation>^dbo.SYSRuleNoBaseI</IndexLocation>
<StreamLocation>^dbo.SYSRuleNoBaseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
