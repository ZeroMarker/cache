/// Desc:      病历语法公式数据
/// Creator:   yejian
/// CreateDate:2016-1-19
Class EMRservice.entity.ECaseGrammarFormula Extends (%RegisteredObject, %XML.Adaptor)
{

/// rowid
Property ID As %String(TRUNCATE = 1);

/// 代码
Property Code As %String(MAXLEN = 50, TRUNCATE = 1);

/// 名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 描述
Property Description As %String(MAXLEN = 500, TRUNCATE = 1);

/// 脚本
Property Grammar As %String(MAXLEN = 30000, TRUNCATE = 1);

/// 脚本备注
Property GrammarDes As %String(MAXLEN = 20000, TRUNCATE = 1);

/// 显示次序
Property GrammarSeq As %String;

/// 注意（冗余）
Property Remark As %String(MAXLEN = 500, TRUNCATE = 1);

/// 类型 DOC GRID
Property DocumentType As %String(TRUNCATE = 1);

/// 参数 itemName1:ItemValue^itemName2:ItemValue^itemName3:ItemValue
Property Parameter As %String(TRUNCATE = 1);

}
