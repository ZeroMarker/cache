/// BTCheckValidRules
Class dbo.BTCheckValidRules Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_CheckValidRules, StorageStrategy = Default ]
{

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

Index IndexRuleType On (HospitalDR, RuleType) [ SqlName = Index_RuleType, Type = index ];

/// DDL Primary Key Specification
Index PKBTCHECKVALIDRULES On RowID [ PrimaryKey, SqlName = PK_BT_CHECKVALIDRULES, Type = index, Unique ];

/// Foreign Key FKCheckValidRulesHosp created via DDL
ForeignKey FKCheckValidRulesHosp(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_CheckValidRulesHosp ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 规则类型 (1限值，2差值，3比值,  4公式, 5逻辑 6新逻辑 9新公式审核规则) 
Property RuleType As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 规则分组  
Property RuleGroup As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 7 ];

/// 工作小组  
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 9 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 10 ];

/// 优先级 (1:优先级最高)
Property Priority As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 规则是否继续判断其他规则  (01:条件不满足继续，02：条件不满足退出，11:条件满足继续,12:条件满足退出)
Property CheckType As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 12 ];

/// 规则类别  (1：错误/禁止，2：警告/提升，3：人工（禁止），4：人工（提示），5：自动)
Property RuleClass As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 13 ];

/// 是否使用通配公式  {1:true,0:false}
Property IsMatch As %Library.Boolean [ SqlColumnNumber = 14 ];

/// 通配公式  
Property MatchFormula As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="BTCheckValidRulesDefaultData">
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
<Value>RuleType</Value>
</Value>
<Value name="6">
<Value>RuleGroup</Value>
</Value>
<Value name="7">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
<Value name="9">
<Value>Sequence</Value>
</Value>
<Value name="10">
<Value>Priority</Value>
</Value>
<Value name="11">
<Value>CheckType</Value>
</Value>
<Value name="12">
<Value>RuleClass</Value>
</Value>
<Value name="13">
<Value>IsMatch</Value>
</Value>
<Value name="14">
<Value>MatchFormula</Value>
</Value>
</Data>
<DataLocation>^dbo.BTCheckValidRulesD</DataLocation>
<DefaultData>BTCheckValidRulesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTCheckValidRulesD</IdLocation>
<IndexLocation>^dbo.BTCheckValidRulesI</IndexLocation>
<StreamLocation>^dbo.BTCheckValidRulesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
