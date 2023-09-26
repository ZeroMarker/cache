/// Desc：   BL层类，实现与得到“查询方案”有关的业务逻辑
/// Creator: 牛才才
Class EPRservice.BLL.Query.BLGetQueryCaseInfo Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod GetCaseName(CaseNameDesc As %String, QueryAreaName As %String, QueryAreaID As %String)
{
	s result = ##Class(%ResultSet).%New("EPRservice.DAL.Query.DAQueryCaseInfo:GetCaseName")
	d result.Execute(CaseNameDesc,QueryAreaName,QueryAreaID)
	Quit result
}

ClassMethod GetCaseConditionInfo(CaseID As %String)
{
	s result = ##Class(%ResultSet).%New("EPRservice.DAL.Query.DAQueryCaseInfo:GetCaseCondition")
	d result.Execute(CaseID)
	Quit result
}

ClassMethod GetCaseResultColsInfo(CaseID As %String)
{
	s result = ##Class(%ResultSet).%New("EPRservice.DAL.Query.DAQueryCaseInfo:GetCaseResultCols")
	d result.Execute(CaseID)
	Quit result
}

ClassMethod GetAllSSGroup()
{
	s result = ##Class(%ResultSet).%New("EPRservice.DAL.Query.DAQueryCaseInfo:GetAllGroup")
	d result.Execute()
	Quit result
}

ClassMethod GetCTLocByCaseID(CaseID As %String)
{
	s result = ##Class(%ResultSet).%New("EPRservice.DAL.Query.DAQueryCaseInfo:getCTLocByCaseID")
	d result.Execute(CaseID)
	Quit result
}

ClassMethod GetGroupByCaseID(CaseID As %String)
{
	s result = ##Class(%ResultSet).%New("EPRservice.DAL.Query.DAQueryCaseInfo:getGroupByCaseID")
	d result.Execute(CaseID)
	Quit result
}

/// Desc：  根据方案ID删除 方案名称
/// return：0：删除成功; -1：删除方案名称失败;
ClassMethod DeleteCaseById(CaseID As %String)
{
	s ret = ##Class(EPRservice.DAL.Query.DAQueryCaseInfo).DeleteCaseById(CaseID)
	Quit ret
}

/// Desc：  根据方案ID删除 查询条件
/// return：0：删除成功; -1：删除查询条件失败;
ClassMethod DeleteConditionByCaseID(curCaseID As %String)
{
	d ##Class(EPRservice.DAL.Query.DAQueryCaseInfo).DeleteConditionByCaseID(curCaseID)
}

/// Desc：  根据方案ID删除 结果列
/// return：0：删除成功; -1：删除结果列失败;
ClassMethod DeleteResultColsByCaseID(curCaseID As %String)
{
	d ##Class(EPRservice.DAL.Query.DAQueryCaseInfo).DeleteResultColsByCaseID(curCaseID)
}

/// Desc：   根据方案ID检查该方案是否还存在
/// return： 0: 不存在; 1: 存在
ClassMethod CheckCaseID(CaseID As %String)
{
	s ret = ##Class(EPRservice.DAL.Query.DAQueryCaseInfo).CheckCaseID(CaseID)
	Quit ret
}

}
