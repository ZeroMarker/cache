/// 名称: 目录查看权限规则
/// 描述: 新框架病历结构目录的查看权限（只控制第一层）
/// 编写者：guozongtao
/// 编写日期: 2014-1-7
Class EMRservice.EMRDoc.BLCatalogSSGroup Extends %RegisteredObject
{

ClassMethod GetEPRCatalogSSGroupCount(parEMRDocID As %String) As %String
{
	
	q:(parEMRDocID=0) 0 
	s count=0	
	&sql(select count(ID) into :count from EMRmeta_EMRDocRestriction.CatalogSSGroup WHERE EMRDocID = :parEMRDocID)
	q count
}

}
