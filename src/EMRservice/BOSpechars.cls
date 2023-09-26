Class EMRservice.BOSpechars Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

//标题目录

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "SpecharsInfo";

//查询符号目录

ClassMethod SelectSpecharsCategory() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLSpechars:SelectSpecharsCategory")
	d result.SetArgs()
	q result
}

//查询符号目录

ClassMethod SelectAllSpechars() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLSpechars:SelectAllSpechars")
	d result.SetArgs()
	q result
}

//查询符号目录

ClassMethod SelectSpecharsByCategory(aCategoryID As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLSpechars:SelectSpecharsByCategory")
	d result.SetArgs(aCategoryID)
	q result
}

/// 得到最大code编号
ClassMethod GetCategroyMaxSeq() As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLSpechars).GetCategroyMaxSeq()
}

/// 得到最大code编号
ClassMethod GetSpecharMaxSeq() As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLSpechars).GetSpecharMaxSeq()
}

//增加一个目录

ClassMethod CreateSpecharsCategory(aESpecharsCategory As EMRservice.entity.ESpecharsCategory) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLSpechars).CreateSpecharsCategory(aESpecharsCategory)
}

//更新一个目录

ClassMethod UpdateSpecharsCategory(aESpecharsCategory As EMRservice.entity.ESpecharsCategory) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLSpechars).UpdateSpecharsCategory(aESpecharsCategory)
}

//删除一个目录

ClassMethod DeleteSpecharsCategory(aSpecharsCategoryID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLSpechars).DeleteSpecharsCategory(aSpecharsCategoryID)
}

//增加一个符号

ClassMethod CreateSpechars(aSpecharsCategoryID As %String, aESpechars As EMRservice.entity.ESpechars) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLSpechars).CreateSpechars(aSpecharsCategoryID,aESpechars)
}

//更新一个符号

ClassMethod UpdateSpechars(aESpechars As EMRservice.entity.ESpechars) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLSpechars).UpdateSpechars(aESpechars)
}

//删除一个符号

ClassMethod DeleteSpechars(aSpecharsID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLSpechars).DeleteSpechars(aSpecharsID)
}

}
