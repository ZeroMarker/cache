/// 名称：		EMRservice.BOEMRNavSchemeItemSSGroup
/// 描述：		方案项安全组BO层
/// 编写者：	yejian
/// 编写时间：	2016-5-17
Class EMRservice.BOEMRNavSchemeItemSSGroup Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "EMRNavSchemeItemSSGroupInfo";

ClassMethod getSSGroup(argGroupName As %String) As %XML.DataSet [ WebMethod ]
{
	Set result=##class(%XML.DataSet).%New()
	s ^globGetSSGrop =argGroupName
	//注：Select出这两个字段的顺序不允许修改
	if (($d(argGroupName)=0)||(argGroupName="")||(argGroupName=$c(0))) {
		Set result=##class(%XML.DataSet).%New("EMRservice.BL.BLPrivAssist:GetAllSSGroup")
		Do result.SetArgs()
	}
	else 
	{
		Set result=##class(%XML.DataSet).%New("EMRservice.BL.BLPrivAssist:GetSSGroupByName")
		Do result.SetArgs(argGroupName)
	}
	
	Quit result
}

/// Creator: yejian
/// CreatDate: 2016-5-17
/// Description：获取指定方案项下的所有安全组ID
/// Input: aSchemeCode,aItemCode
/// Return: 安全组1^安全组2^安全组3
ClassMethod GetItemSSGroups(aSchemeCode As %String, aItemCode As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRNavSchemeItemSSGroup).GetItemSSGroups(aSchemeCode,aItemCode)
}

/// Creator: yejian
/// CreatDate: 2016-5-17
/// Description：保存指定方案项下所适用的安全组
/// Input:aSchemeCode,aItemCode--itemcode^itemname sltSSGroups--所有选中的安全组ID串(格式为 ID1|name^ID2|name^ID3|name), unSltSSGroups--所有未选中的安全组ID串(格式为 ID1|name^ID2|name^ID3|name)
/// Return: 1
ClassMethod ModifySSGroup(aSchemeCode As %String, aItemCode As %String, sltSSGroups As %String, unSltSSGroups As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRNavSchemeItemSSGroup).ModifySSGroup(aSchemeCode,aItemCode,sltSSGroups,unSltSSGroups)
}

}
