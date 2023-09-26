/// 名称: EMRservice.dataset.EPrivRuleTypeDataSet
/// 描述: WebService 方法返回值类型
/// 编写者:guozongtao
/// 编写日期:2010-05-10
Class EMRservice.dataset.EPrivRuleTypeDataSet Extends %XML.DataSet [ ClassType = "", ProcedureBlock ]
{

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/EPrivRuleTypeDataSet";

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "EMRservice.BL.BLPrivRuleType";

Parameter QUERYNAME = "SELECTALL";

}
