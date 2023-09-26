/// 名称: 权限规则明细
/// 描述: 用于新框架模板权限
/// 编写者：guozongtao
/// 编写日期: 2014-1-7
Class EMRservice.EMRDoc.BLDocRestriction Extends %RegisteredObject
{

Query SelectAll(parGroupID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,GroupID:%String,RuleItemIDs:%String,RuleItemNames:%String")
{
	SELECT ID,GroupID,RuleItemIDs,RuleItemDesc
	FROM EMRmeta_EMRDocRestriction.DocRestriction
	WHERE GroupID=:parGroupID ORDER BY ID
}

}
