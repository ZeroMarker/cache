/// 名称: 电子病历维护程序角色表DataSet 
/// 描述: 用于BO业务查询返回结果集
/// 编写者：yejian
/// 编写日期: 2014-2-13
Class EMRservice.dataset.EMainRoleAllDataSet Extends %XML.DataSet [ ClassType = "", ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "EMRservice.BL.BLMainRole";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/MainRoleAllDataSet";

Parameter QUERYNAME = "SelectAll";

}
