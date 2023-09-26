Class CT.WS.TOOL.DataHandleTool Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 创建一个数据元范畴
ClassMethod CreateDataElementCategory(aEDataElementCategoryInfo As EPRservice.entity.EDataElementCategory) As %String [ WebMethod ]
{

	s res = ##Class(CT.WS.BO.BOStdDictionary).CreateStdDictionary(aEDataElementCategoryInfo)
}

}
