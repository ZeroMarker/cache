/// 角色与知识树的关联
Class EMRservice.dataset.EMainRoleKBDataSet Extends %XML.DataSet [ ClassType = "", ProcedureBlock ]
{

/// The class name that contains the query for typed DataSet
Parameter CLASSNAME = "EMRservice.BL.BLMainRoleFuntion";

/// The XML namespace for typed DataSets
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice/MainRoleKBDataSet";

Parameter QUERYNAME = "SelectKBTreeByRoleID";

}
