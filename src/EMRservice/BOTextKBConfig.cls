///  名称：		EMRservice.BOTextKBConfig
///  描述：		专科病历BO层
///  编写者：	yejian
///  编写时间：	2018-1-12
Class EMRservice.BOTextKBConfig Extends %SOAP.WebService
{

///  TODO: change this to actual network address.
///  URL for invoking the WebService.
///  Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
///  TODO: change this to actual SOAP namespace.
///  SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

///  Name of the WebService. 
Parameter SERVICENAME = "TextKBConfigInfo";

/// 获取所有目录数据
/// Debug: ##class(EMRservice.BOTextKBConfig).GetCategorys("6")
ClassMethod GetCategorys() As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New("EMRservice.BL.BLTextKBConfig:GetCategorys")
	d result.SetArgs()
	Quit result
}

/// 获取所有科室数据
/// Debug: ##class(EMRservice.BOTextKBConfig).GetAllLoc()
ClassMethod GetAllLoc() As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New("EMRservice.BL.BLTextKBConfig:SelectAllLoc")
	Quit result
}

ClassMethod SelectCategoryBYID(AID As %String) As EMRservice.entity.ETextKBCategory [ WebMethod ]
{
	q ##class(EMRservice.BL.BLTextKBConfig).SelectCategoryBYID(AID)
}

/// Debug:w ##class(EMRservice.BOTextKBConfig).GetBindLocByID(1)
ClassMethod GetBindLocByID(CateID As %String) As %String [ WebMethod ]
{
	q ##class(EMRservice.BL.BLTextKBConfig).GetBindLocByID(CateID)
}

ClassMethod CreateCategory(AECategory As EMRservice.entity.ETextKBCategory) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTextKBConfig).CreateCategory(AECategory)
}

ClassMethod DeleteCategory(AID As %String) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTextKBConfig).DeleteCategory(AID)
}

ClassMethod UpdateCategory(AECategory As EMRservice.entity.ETextKBCategory) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTextKBConfig).UpdateCategory(AECategory)
}

/// Description:修改树节点排序顺序号
/// Input:CategoryID1树节点1，CategoryID2树节点2
/// Output:无
/// Return: result是否操作成功
/// do ##class(EMRservice.BOTextKBConfig).SwapSequence("1","2")
ClassMethod SwapSequence(CategoryID1 As %String, CategoryID2 As %String) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTextKBConfig).SwapSequence(CategoryID1,CategoryID2)
}

/// Debug:w ##class(EMRservice.BOTextKBConfig).SaveBindLoc(10,"8^13^17")
ClassMethod SaveBindLoc(CateID As %String, LocIDStr As %String) As %String [ WebMethod ]
{
	q ##class(EMRservice.BL.BLTextKBConfig).SaveBindLoc(CateID,LocIDStr)
}

/// 获取所有用户模板
/// Debug: d ##class(EMRservice.BOUserTemplate).GetAllUserTemplate()
ClassMethod GetAllTextKBContent(aCTLocName As %String = "") As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLTextKBConfig:GetAllTextKBContent")
	d result.SetArgs(aCTLocName)
	q result
}

//获取专科文本对象

ClassMethod GetContent(ACategoryID As %String) As EMRservice.entity.ETextKBContent [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTextKBConfig).GetContent(ACategoryID)
}

ClassMethod UpdateContent(AECategory As EMRservice.entity.ETextKBCategory, AEKBContent As EMRservice.entity.ETextKBContent) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTextKBConfig).UpdateContent(AECategory,AEKBContent)
}

/// 修改用户模板状态
ClassMethod ModContentStatus(AContentIDS As %String, Atatus As %String, aAuditID As %String, Remark As %String = "") As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLTextKBConfig).ModContentStatus(AContentIDS,Atatus,aAuditID,Remark)
}

}
