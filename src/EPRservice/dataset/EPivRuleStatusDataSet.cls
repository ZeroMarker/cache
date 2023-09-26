/// 名称: EPRservice.dataset.EPivRuleStatus
/// 描述: WebService 方法返回值类型
/// 编写者:guozongtao
/// 编写日期:2010-05-8
Class EPRservice.dataset.EPivRuleStatusDataSet Extends %XML.DataSet [ ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "EPRservice.Privilege.BOPrivRule";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/EPivRuleStatusDataSet";

Parameter QUERYNAME = "SelectPrivRuleAll";

}
