/// 名称: EPRservice.BOGloassaryTest
/// 描述: 术语测试BO层
/// 编写者：yejian
/// 编写日期: 2017-6-23
Class EPRservice.BOGloassaryTest Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "BOGloassaryTestInfo";

/// w ##Class(EPRservice.BOGloassaryTest).GetInstanceIDByTInterID("339","HDSD00.13.01")
ClassMethod GetInstanceIDByTInterID(AEpisodeID As %String, ACategoryInternalID As %String, ByRef Aversion As %String) As %List [ WebMethod ]
{
	S ret = ""
	q:($d(AEpisodeID) = 0)||(AEpisodeID = "") ret
	q:($d(ACategoryInternalID) = 0)||(ACategoryInternalID = "") ret

	s glossaryCategoryID = $O(^DHCEPRM.GlossaryCategoryI("IdxOnInternalID"," "_ACategoryInternalID,""))
	q:(glossaryCategoryID="") ret
	//通过术语集目录获取关联的模板ID
	s objGlossaryCategory =  ##Class(EPRmeta.GlossaryCategory).%OpenId(glossaryCategoryID)
	q:(objGlossaryCategory="") ret
	s templateCategoryID = objGlossaryCategory.TemplateCategroyID
	q:(templateCategoryID="") ret
	s Aversion = ##Class(EMRservice.BL.BLScatterData).GetDataVersion(AEpisodeID)
	q:(Aversion = "") ret
	if (Aversion = 3)
	{
		//获取InstanceID集合
		S ret = ##CLASS(EPRservice.BLL.BLGlossaryTest).GetInstanceIDByTInterID(AEpisodeID,templateCategoryID)
	}
	
	q ret
}

/// w ##Class(EPRservice.BOGloassaryTest).GetNewStdDataByGlossary("339","HDSD00.13.01","359||3")
ClassMethod GetNewStdDataByGlossary(AEpisodeID As %String, ACategoryInternalID As %String, AInstanceID) As %ArrayOfDataTypes [ WebMethod ]
{
	s ret = ""
	s version = ##Class(EMRservice.BL.BLScatterData).GetDataVersion(AEpisodeID)
	q:(version = "") ret
	if (version = 2)
	{
		s ret = ##Class(EPRservice.BLL.BLGlossaryTest).GetDataByGlossaryCategory(AEpisodeID,ACategoryInternalID)
	}
	else
	{
		s ret= ##Class(EPRservice.BLL.BLGlossaryTest).GetNewStdDataByGlossary(AEpisodeID,ACategoryInternalID,AInstanceID)
	}
	q ret
}

}
