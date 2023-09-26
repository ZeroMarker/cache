/// 名称: 电子病历维护程序角色权限表DataSet 
/// 描述: 用于BO业务查询返回结果集
/// 编写者：LingChen
/// 编写日期: 2010-10-22
Class EPRservice.dataset.MainRoleFuncDataSet Extends %XML.DataSet [ ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "EPRservice.dao.DMainRoleFunction";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/MainRoleFuncDataSet";

Parameter QUERYNAME = "SelectFuncNameByRoleID";

}
