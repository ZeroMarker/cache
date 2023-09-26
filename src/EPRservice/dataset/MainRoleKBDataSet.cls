/// 角色与知识树的关联
Class EPRservice.dataset.MainRoleKBDataSet Extends %XML.DataSet [ ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "EPRservice.dao.DMainRoleFunction";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/MainRoleKBDataSet";

Parameter QUERYNAME = "SelectKBTreeByRoleID";

}
