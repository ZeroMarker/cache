///  名称：		EMRservice.BOUserTemplateGroup
///  描述：		科室模板分组BO层
///  编写者：	yejian
///  编写时间：	2016-9-20
Class EMRservice.BOUserTemplateGroup Extends %SOAP.WebService
{

///  TODO: change this to actual network address.
///  URL for invoking the WebService.
///  Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
///  TODO: change this to actual SOAP namespace.
///  SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

///  Name of the WebService. 
Parameter SERVICENAME = "UserTemplateGroupInfo";

/// 获取科室模板分组
/// Debug: d ##class(EMRservice.BOUserTemplateGroup).GetUserTemplateGroup("50")
ClassMethod GetUserTemplateGroup(ACtLocID As %String) As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLUserTemplateGroup:GetUserTemplateGroup")
	d result.SetArgs(ACtLocID)
	q result
}

/// 获取科室模板分组明细
/// Debug: d ##class(EMRservice.BOUserTemplateGroup).GetUserTemplateGroupItem("50")
ClassMethod GetUserTemplateGroupItem(ACtLocID As %String) As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLUserTemplateGroup:GetUserTemplateGroupItem")
	d result.SetArgs(ACtLocID)
	q result
}

/// 获取科室模板分组明细
/// Debug: d ##class(EMRservice.BOUserTemplateGroup).GetUserTemplateByCtLocID("50")
ClassMethod GetUserTemplateByCtLocID(ACtLocID As %String) As %XML.DataSet [ WebMethod ]
{
	s result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLUserTemplateGroup:GetUserTemplateByCtLocID")
	d result.SetArgs(ACtLocID)
	q result
}

/// 得到最大code编号
/// w ##class(EMRservice.BOUserTemplateGroup).GetMaxID()
ClassMethod GetMaxID() As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateGroup).GetMaxID()
}

/// 根据ID获取科室模板
ClassMethod GetUserTemplateGroupByID(ARowID As %String) As EMRservice.entity.EUserTemplateGroup [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateGroup).GetUserTemplateGroupByID(ARowID)
}

/// 检查科室模板分组
ClassMethod CheckUserTemplateGroup(GroupCode As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateGroup).CheckUserTemplateGroup(GroupCode)
}

/// 添加科室模板分组
ClassMethod AddUserTemplateGroup(AUserTemplateC As EMRservice.entity.EUserTemplateGroup) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateGroup).AddUserTemplateGroup(AUserTemplateC)
}

/// 修改科室模板分组
ClassMethod ModUserTemplateGroup(AUserTemplateC As EMRservice.entity.EUserTemplateGroup) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateGroup).ModUserTemplateGroup(AUserTemplateC)
}

/// 根据ID获取科室模板分组子项
ClassMethod GetUserTemplateGroupItemByCode(AGroupID As %String, ACode As %String) As EMRservice.entity.EUserTemplateGroupItem [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateGroup).GetUserTemplateGroupItemByCode(AGroupID,ACode)
}

/// 修改科室模板分组
/// debug d ##Class(EMRservice.BOUserTemplateGroup).UpUserTemplateGroupItem("m05","0","56")
ClassMethod UpUserTemplateGroupItem(aUserTemplateCode As %String, oldGroupID As %String, newGroupID As %String) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateGroup).UpUserTemplateGroupItem(aUserTemplateCode,oldGroupID,newGroupID)
}

///  creator:yejian
///  CreatDate:2016-8-9
///  Description:修改树节点排序顺序号
///  Return: result是否操作成功
///  do ##class(EMRservice.BOUserTemplateGroup).SwapSequence("1","2")
ClassMethod SwapUserTemplateCatSeq(UserTemplateCID1 As %String, UserTemplateCID2 As %String) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateGroup).SwapUserTemplateCatSeq(UserTemplateCID1,UserTemplateCID2)
}

///  creator:yejian
///  CreatDate:2016-8-9
///  Description:修改树节点排序顺序号
///  Return: result是否操作成功
///  do ##class(EMRservice.BOUserTemplateGroup).SwapSequence("1","2")
ClassMethod SwapUserTemplateItemSeq(UserTemplateCID1 As %String, UserTemplateCID2 As %String) As %Boolean [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateGroup).SwapUserTemplateItemSeq(UserTemplateCID1,UserTemplateCID2)
}

/// 删除科室模板分组
ClassMethod DelUserTemplateGroup(AUserTemplateCID As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLUserTemplateGroup).DelUserTemplateGroup(AUserTemplateCID)
}

}
