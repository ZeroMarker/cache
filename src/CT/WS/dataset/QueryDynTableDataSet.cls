/// 名称: 动态查询数据 
/// 描述: 用于自定义查询返回数据
/// 编写者：yejian
/// 编写日期: 2013-4-24
Class CT.WS.dataset.QueryDynTableDataSet Extends %XML.DataSet [ ClassType = "", ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "CT.WS.dao.DQueryDynTable";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/QueryDynTableDataSet";

Parameter QUERYNAME = "QueryByConfig";

}
