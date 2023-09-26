/// Desc:      病历语法公式数据
/// Creator:   yejian
/// CreateDate:2016-1-19
Class EMRmeta.CaseGrammarFormula Extends %Persistent
{

Index IdxCode On Code;

/// 代码
Property Code As %String(MAXLEN = 50, TRUNCATE = 1);

/// 名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 描述（冗余）
Property Description As %String(MAXLEN = 500, TRUNCATE = 1);

/// 脚本
Property Grammar As %String(MAXLEN = 30000, TRUNCATE = 1);

/// 脚本备注
Property GrammarDes As %String(MAXLEN = 20000, TRUNCATE = 1);

/// 显示次序
Property GrammarSeq As %Integer;

/// 注意（冗余）
Property Remark As %String(MAXLEN = 500, TRUNCATE = 1);

/// 类型 DOC GRID
Property DocumentType As %String(TRUNCATE = 1);

/// 参数 itemName1:ItemValue^itemName2:ItemValue^itemName3:ItemValue
Property Parameter As %String(TRUNCATE = 1);

Storage Default
{
<Data name="CaseGrammarFormulaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>Grammar</Value>
</Value>
<Value name="6">
<Value>GrammarDes</Value>
</Value>
<Value name="7">
<Value>Remark</Value>
</Value>
<Value name="8">
<Value>SchemSeq</Value>
</Value>
<Value name="9">
<Value>GrammarSeq</Value>
</Value>
<Value name="10">
<Value>DocumentType</Value>
</Value>
<Value name="11">
<Value>Parameter</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.CaseGrammarFormulaD</DataLocation>
<DefaultData>CaseGrammarFormulaDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.CaseGrammarFormulaD</IdLocation>
<IndexLocation>^DHCEMRM.CaseGrammarFormulaI</IndexLocation>
<StreamLocation>^DHCEMRM.CaseGrammarFormulaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
