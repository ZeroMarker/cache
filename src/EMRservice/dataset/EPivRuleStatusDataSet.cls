/// 名称: EMRservice.dataset.EPivRuleStatus
/// 描述: WebService 方法返回值类型
/// 编写者:guozongtao
/// 编写日期:2010-05-8
Class EMRservice.dataset.EPivRuleStatusDataSet Extends %XML.DataSet [ ClassType = "", ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "EMRservice.BL.BLPrivRule";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice/EPivRuleStatusDataSet";

Parameter QUERYNAME = "SelectPrivRuleAll";

}
