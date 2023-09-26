/// ************************************************************
/// * Class Method:	EPRservice.BLL.Query.BLCategoryMgr
/// * Description:	电子病历综合查询分类业务逻辑管理器
/// * Author:		Kumon Xie
/// * Create Date:	2011-06-03
/// * Version:		V2011060301
/// ************************************************************/
Class EPRservice.BLL.Query.BLCategoryMgr Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	根据父节点ID取子节点集合;
/// Input:	ACategoryID为父节点ID, 根目录节点ID为0;
/// 		AIsRecursive指是否递归获取子节点;
/// 		AIsActive指是否有效,如果为空,则不判断有效性;
/// Debug:	d ##Class(EPRservice.BLL.Query.BLCategoryMgr).GetSubCategoriesByID(0,"Y","Y")				
ClassMethod GetSubCategoriesByID(ACategoryID As %String, AIsRecursive As %String = "Y", AIsActive As %String = "") As %ResultSet
{
	s result = ##Class(%ResultSet).%New("EPRservice.DAL.Query.DACategoryInfo:GetSubCategoriesByID")
	d result.Execute(ACategoryID,AIsRecursive,AIsActive)
	q result
}

ClassMethod GetQueryItemsByCatID(ACategoryID As %String, AIsActive As %String = "") As %ResultSet
{
	s result = ##Class(%ResultSet).%New("EPRservice.DAL.Query.DAQueryItemInfo:GetQueryItemsByCatID")
	d result.Execute(ACategoryID,AIsActive)
	q result
}

ClassMethod GetQueryItemsByCatCode(ACategoryCode As %String, AIsActive As %String = "") As %ResultSet
{
	s categoryID = ##Class(EPRservice.DAL.Query.DACategoryInfo).GetCategoryIDByCode(ACategoryCode)
	s result = ##Class(%ResultSet).%New("EPRservice.DAL.Query.DAQueryItemInfo:GetQueryItemsByCatID")
	d result.Execute(categoryID,AIsActive)
	q result
}

/// Debug:	w ##Class(EPRservice.BLL.Query.BLCategoryMgr).GetCategoryIDByCode("HIS")
ClassMethod GetCategoryIDByCode(ACategoryCode As %String) As %String
{
	s ret = ##Class(EPRservice.DAL.Query.DACategoryInfo).GetCategoryIDByCode(ACategoryCode)
	q ret
}

/// Debug:	s objCategory = ##Class(EPRservice.BLL.Query.BLCategoryMgr).GetCategoryByID(1)
ClassMethod GetCategoryByID(ACategoryID As %String) As EPRservice.entity.Query.EQueryCategory
{
	s ret = ##Class(EPRservice.DAL.Query.DACategoryInfo).GetCategoryByID(ACategoryID)
	q ret
}

}
