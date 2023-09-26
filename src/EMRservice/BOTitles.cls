Class EMRservice.BOTitles Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TitlesInfo";

ClassMethod SelectALLTitleS() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLTitles:SELECTALLTITLES")
	d result.SetArgs()
	q result
}

ClassMethod SelectAllTitle() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLTitles:SelectAllTitle")
	d result.SetArgs()
	q result
}

ClassMethod SelectUserLevel() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLTitles:SelectUserLevel")
	d result.SetArgs()
	q result
}

/// 增加一个章节
ClassMethod CreateTitles(aETitleInfo As EMRservice.entity.ETitles, aETitleConfig As EMRservice.entity.ETitleConfig) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTitles).CreateTitles(aETitleInfo,aETitleConfig)
}

/// 删除一个标题
ClassMethod DeleteTitlesByID(aTitleId As %String, aTitleConfigID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTitles).DeleteTitlesByID(aTitleId,aTitleConfigID)
}

/// 更新一个章节
ClassMethod UpdateTitles(aETitleInfo As EMRservice.entity.ETitles, aETitleConfig As EMRservice.entity.ETitleConfig) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTitles).UpdateTitles(aETitleInfo,aETitleConfig)
}

/// 更新标题顺序
ClassMethod UpdateSequences(argStr As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTitles).UpdateSequences(argStr)
}

/// 获取标题配置信息
/// d ##Class(EMRservice.BOTitles).SelectAllTitileConfig()
ClassMethod SelectAllTitileConfig() As EMRservice.dataset.ETitleConfigDataSet [ WebMethod ]
{
	 s result=##class(EMRservice.dataset.ETitleConfigDataSet).%New()
	 ;d result.SetArgs("")
	 q result
}

/// 得到最大code编号
ClassMethod GetMaxCode() As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTitles).GetMaxCode()
}

/// 判断code编号是否存在
ClassMethod CheckCodeExist(Acode As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTitles).CheckCodeExist(Acode)
}

//增加手术目录属性时设置标题唯一属性

ClassMethod updateUniqueCreateByTitleCategoryID(aTitleCategoryID As %String, aUniqueCreate As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTitles).updateUniqueCreateByTitleCategoryID(aTitleCategoryID,aUniqueCreate)
}

}
