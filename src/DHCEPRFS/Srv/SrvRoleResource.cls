Class DHCEPRFS.Srv.SrvRoleResource Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvRoleResource";

ClassMethod AddResourceLoc(ALocID As %String, ALocDesc As %String, AInitialPinYin As %String, AAliasPinYin As %String, ASequence As %String, AIsValid As %String, ACatalogueCode As %String) As %String [ WebMethod ]
{
	s ret=##class(DHCEPRFS.BL.BLRoleResource).AddResourceLoc(ALocID,ALocDesc,AInitialPinYin,AAliasPinYin,ASequence,AIsValid,ACatalogueCode)
	q ret
}

/// Desc:	修改科室资源数据
/// Debug:	w ##Class(DHCEPRFS.BL.BLRoleResource).UpdateResourceLoc()
ClassMethod UpdateResourceLoc(AResourceLocID As %String, ALocID As %String, ALocDesc As %String, AInitialPinYin As %String, AAliasPinYin As %String, ASequence As %String, AIsValid As %String, ACatalogueCode As %String) As %String [ WebMethod ]
{
	s ret=##class(DHCEPRFS.BL.BLRoleResource).UpdateResourceLoc(AResourceLocID,ALocID,ALocDesc,AInitialPinYin,AAliasPinYin,ASequence,AIsValid,ACatalogueCode)
	q ret
}

/// Desc:	增加病历项目资源数据
/// Debug:	d ##Class(DHCEPRFS.BL.BLRoleResource).AddResourceMRItem()
ClassMethod AddResourceMRItem(AMRItemID As %String, AMRItemName As %String, AInitialPinYin As %String, AAliasPinYin As %String, AIsValid As %String, ACatalogueCode As %String) As %String [ WebMethod ]
{
	s ret=##class(DHCEPRFS.BL.BLRoleResource).AddResourceMRItem(AMRItemID,AMRItemName,AInitialPinYin,AAliasPinYin,AIsValid,ACatalogueCode)
	q ret
}

/// Desc:	更新病历项目资源数据
/// Debug:	d ##Class(DHCEPRFS.BL.BLRoleResource).UpdateResourceMRItem()
ClassMethod UpdateResourceMRItem(AResourceMRItemID As %String, AMRItemID As %String, AMRItemName As %String, AInitialPinYin As %String, AAliasPinYin As %String, AIsValid As %String, ACatalogueCode As %String) As %String [ WebMethod ]
{
	s ret=##class(DHCEPRFS.BL.BLRoleResource).UpdateResourceMRItem(AResourceMRItemID,AMRItemID,AMRItemName,AInitialPinYin,AAliasPinYin,AIsValid,ACatalogueCode)
	q ret
}

/// Desc:	获取资源类型数据
ClassMethod GetAllResourceType() As %XML.DataSet [ WebMethod ]
{
	s ret=##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLRoleResource:GetAllResourceType")
	d ret.SetArgs()
	q ret
}

/// Desc:	增加出院日期资源
/// Debug:	d ##Class(DHCEPRFS.BL.BLRoleResource).AddResourceDisDate()
ClassMethod AddResourceDisDate(AStartDate As %String, AEndDate As %String, ANoExpireFlag As %String, AIsValid As %String) As %String [ WebMethod ]
{
	s ret=##class(DHCEPRFS.BL.BLRoleResource).AddResourceDisDate(AStartDate,AEndDate,ANoExpireFlag,AIsValid)
	q ret
}

/// Desc:	更新出院日期资源
/// Debug:	d ##Class(DHCEPRFS.BL.BLRoleResource).AddResourceDisDate()
ClassMethod UpdateResourceDisDate(AResourceDisDateID As %String, AStartDate As %String, AEndDate As %String, ANoExpireFlag As %String, AIsValid As %String) As %String [ WebMethod ]
{
	s ret=##class(DHCEPRFS.BL.BLRoleResource).UpdateResourceDisDate(AResourceDisDateID,AStartDate,AEndDate,ANoExpireFlag,AIsValid)
	q ret
}

/// Desc:	通过资源类型获取资源全部数据
ClassMethod GetResourceByType(AResourceTypeCode As %String) As %XML.DataSet [ WebMethod ]
{
	s BLMethodName=""
	if (AResourceTypeCode="LOC")
	{s BLMethodName="GetAllResourceLoc"}
	if (AResourceTypeCode="MRITEM")
	{s BLMethodName="GetAllResourceMRItem"}
	if (AResourceTypeCode="DISDATE")
	{s BLMethodName="GetAllResourceDisDate"}
	if (AResourceTypeCode="FUNC")
	{s BLMethodName="GetAllResourceFunc"}
	
	s ret=##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLRoleResource:"_BLMethodName)
	d ret.SetArgs()
	q ret
}

/// Desc:	通过资源ID获取资源数据
ClassMethod GetResourceByID(AResourceTypeCode As %String, AResourceID As %String) As %XML.DataSet [ WebMethod ]
{
	s ret=##class(DHCEPRFS.BL.BLRoleResource).GetResourceByID(AResourceTypeCode,AResourceID)
	q ret
}

/// Desc:	查询资源对应的操作
/// Input：	AResourceTypeCode
/// Debug：	do ##class(DHCEPRFS.Srv.SrvRoleResource).GetResourceOperation("LOC")
ClassMethod GetResourceOperation(AResourceTypeCode As %String) As %XML.DataSet [ WebMethod ]
{
	s ret=##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLRoleResource:GetResourceOperation")
	d ret.SetArgs(AResourceTypeCode)
	q ret
}

ClassMethod SaveRoleResourceLink(ARoleResourceStr As %String) As %String [ WebMethod ]
{
	s ret=##class(DHCEPRFS.BL.BLRoleResource).SaveRoleResourceLink(ARoleResourceStr)
	q ret
}

/// Desc:	获取角色资源关系
ClassMethod GetRoleResourceLink(ARoleID As %String) As %XML.DataSet [ WebMethod ]
{
	s ret=##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLRoleResource:GetRoleResourceLink")
	d ret.SetArgs(ARoleID)
	q ret
}

/// Desc:	查询角色资源对应的操作
/// Input：	ARoleID
/// 	Input:	AResourceTypeCode
/// Debug：	d ##Class(DHCEPRFS.BL.BLRoleResource).GetRoleResourceOperation("6","FUNC")
ClassMethod GetRoleResourceOperation(ARoleID As %String, AResourceTypeCode As %String) As %String [ WebMethod ]
{
	s ret=##class(DHCEPRFS.BL.BLRoleResource).GetRoleResourceOperation(ARoleID,AResourceTypeCode)
	q ret
}

}
