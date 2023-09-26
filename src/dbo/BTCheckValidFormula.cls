/// BTCheckValidFormula
Class dbo.BTCheckValidFormula Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_CheckValidFormula, StorageStrategy = Default ]
{

/// Foreign Key FKCheckValidFormula created via DDL
ForeignKey FKCheckValidFormula(CheckValidRulesDR) References dbo.BTCheckValidRules(PKBTCHECKVALIDRULES) [ SqlName = FK_CheckValidFormula ];

/// Foreign Key FKCheckValidFormulaLocation created via DDL
ForeignKey FKCheckValidFormulaLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_CheckValidFormulaLocation ];

ForeignKey FKCheckValidFormulaTestCode(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_CheckValidFormulaTestCode ];

/// Foreign Key FKCheckValidFormulaTestCode created via DDL
Index IndexDataMaster On (CheckValidRulesDR, OrderNo) [ SqlName = Index_DataMaster, Type = index, Unique ];

Index IndexTestCode On (TestCodeDR, OrderNo, CheckValidRulesDR) [ SqlName = Index_TestCode, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTCHECKVALIDFORMULA On RowID [ PrimaryKey, SqlName = PK_BT_CHECKVALIDFORMULA, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 审核规则  
Property CheckValidRulesDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 序号  
Property OrderNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 校验规则公式 
Property FormulaItems As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 5 ];

/// 校验规则公式描述  
Property FormulaDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 6 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

/// 规则类型  
Property FormulaType As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

/// 科室  
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// ApproType  
Property ApproType As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 10 ];

/// 结果天数  
Property ResDays As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 11 ];

/// 规则条件
Property PreFormulaItems As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 12 ];

/// 规则分组  (01:条件不满足继续，02：条件不满足退出，11:条件满足继续,12:条件满足退出)
Property CheckType As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ SqlColumnNumber = 13 ];

/// 检测项目 
Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 14 ];

/// 取反( true false)
Property Negated As %Library.Boolean [ SqlColumnNumber = 15 ];

/// 规则说明
Property RuleRemark As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 16 ];

/// 规则通过说明
Property PassRemark As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 17 ];

/// 规则违反说明
Property UnPassRemark As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 18 ];

/// 检测项目  
/// 取反( true false)
/// 规则说明
/// 规则通过说明
/// 规则违反说明
Storage Default
{
<Data name="BTCheckValidFormulaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckValidRulesDR</Value>
</Value>
<Value name="3">
<Value>OrderNo</Value>
</Value>
<Value name="4">
<Value>FormulaItems</Value>
</Value>
<Value name="5">
<Value>FormulaDesc</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
<Value name="7">
<Value>FormulaType</Value>
</Value>
<Value name="8">
<Value>LocationDR</Value>
</Value>
<Value name="9">
<Value>ApproType</Value>
</Value>
<Value name="10">
<Value>ResDays</Value>
</Value>
<Value name="11">
<Value>PreFormulaItems</Value>
</Value>
<Value name="12">
<Value>CheckType</Value>
</Value>
<Value name="13">
<Value>TestCodeDR</Value>
</Value>
<Value name="14">
<Value>Negated</Value>
</Value>
<Value name="15">
<Value>RuleRemark</Value>
</Value>
<Value name="16">
<Value>PassRemark</Value>
</Value>
<Value name="17">
<Value>UnPassRemark</Value>
</Value>
</Data>
<DataLocation>^dbo.BTCheckValidFormulaD</DataLocation>
<DefaultData>BTCheckValidFormulaDefaultData</DefaultData>
<Description>
<![CDATA[检测项目  
取反( true false)
规则说明
规则通过说明
规则违反说明]]></Description>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTCheckValidFormulaD</IdLocation>
<IndexLocation>^dbo.BTCheckValidFormulaI</IndexLocation>
<StreamLocation>^dbo.BTCheckValidFormulaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
