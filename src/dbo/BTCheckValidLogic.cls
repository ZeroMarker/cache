/// BTCheckValidLogic
Class dbo.BTCheckValidLogic Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_CheckValidLogic, StorageStrategy = Default ]
{

/// Foreign Key FKCheckValidLogic created via DDL
ForeignKey FKCheckValidLogic(CheckValidRulesDR) References dbo.BTCheckValidRules(PKBTCHECKVALIDRULES) [ SqlName = FK_CheckValidLogic ];

Index IndexDataMaster On (CheckValidRulesDR, Code) [ SqlName = Index_DataMaster, Type = index, Unique ];

Index PKBTCHECKVALIDLOGIC On RowID [ PrimaryKey, SqlName = PK_BT_CHECKVALIDLOGIC, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 审核规则  
Property CheckValidRulesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 4 ];

/// 公式名称 
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 5 ];

/// 校验规则公式描述  
Property FormulaDesc As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 6 ];

/// 判断公式
Property CheckFormula As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 7 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

/// 优先级 (1:优先级最高)
Property Priority As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 是否继续判断其他规则  (01:条件不满足继续，02：条件不满足退出，11:条件满足继续,12:条件满足退出)
Property CheckType As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 10 ];

/// 规则类别  1：错误/禁止，2：警告/提升，3：人工（禁止），4：人工（提示），5：自动
Property RuleClass As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 11 ];

/// 规则条件
Property PreFormulaItems As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 12 ];

/// 取反
Property Negated As %Library.Boolean [ SqlColumnNumber = 13 ];

/// 规则通过说明
Property PassRemark As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 14 ];

/// 规则违反说明
Property UnPassRemark As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="BTCheckValidLogicDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckValidRulesDR</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>CName</Value>
</Value>
<Value name="5">
<Value>FormulaDesc</Value>
</Value>
<Value name="6">
<Value>CheckFormula</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
<Value name="8">
<Value>Priority</Value>
</Value>
<Value name="9">
<Value>CheckType</Value>
</Value>
<Value name="10">
<Value>RuleClass</Value>
</Value>
<Value name="11">
<Value>PreFormulaItems</Value>
</Value>
<Value name="12">
<Value>Negated</Value>
</Value>
<Value name="13">
<Value>PassRemark</Value>
</Value>
<Value name="14">
<Value>UnPassRemark</Value>
</Value>
</Data>
<DataLocation>^dbo.BTCheckValidLogicD</DataLocation>
<DefaultData>BTCheckValidLogicDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTCheckValidLogicD</IdLocation>
<IndexLocation>^dbo.BTCheckValidLogicI</IndexLocation>
<StreamLocation>^dbo.BTCheckValidLogicS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
