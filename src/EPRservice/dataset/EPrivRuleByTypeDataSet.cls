/// 名称: EPRservice.dataset.EPrivRuleByTypeDataSet
/// 描述: WebService 方法返回值类型
///       依据规则类型返回规则数据集合
/// 编写者:guozongtao
/// 编写日期:2010-05-13
Class EPRservice.dataset.EPrivRuleByTypeDataSet Extends %XML.DataSet [ ProcedureBlock ]
{

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/EPrivRuleByTypeDataSet";

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "EPRservice.Privilege.BOPrivRule";

Parameter QUERYNAME = "SelectPrivRuleByType";

}
