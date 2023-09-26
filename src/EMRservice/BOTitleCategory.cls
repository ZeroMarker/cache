Class EMRservice.BOTitleCategory Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

//标题目录

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TitleCategoryInfo";

//增加一个目录

ClassMethod CreateTitleCategory(aETitleCategory As EMRservice.entity.ETitleCategory) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTitleCategory).CreateTitleCategory(aETitleCategory)
}

//更新一个目录

ClassMethod UpdateTitleCategory(aETitleCategory As EMRservice.entity.ETitleCategory) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTitleCategory).UpdateTitleCategory(aETitleCategory)
}

//删除一个目录

ClassMethod DeleteTitleCategory(aTitleCategoryID As %String, aTitleId As %String, aTitleConfigID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTitleCategory).DeleteTitleCategory(aTitleCategoryID,aTitleId,aTitleConfigID)
}

// 更新标题顺序

ClassMethod UpdateSequences(argStr As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTitleCategory).UpdateSequences(argStr)
}

//查询标题目录

ClassMethod SelectAllTitleCategory() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLTitleCategory:SelectAllTitleCategory")
	d result.SetArgs()
	q result
}

/// Desc:       根据docID取标题
/// Creator:    Candy
/// CreateDate: 2015-4-3
/// Input:      ADocID 目录展现结构ID
ClassMethod GetTitleByDocID(ADocID As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLTitleConfig:GetTitleByDocID")
	d result.SetArgs(ADocID)
	q result
}

}
