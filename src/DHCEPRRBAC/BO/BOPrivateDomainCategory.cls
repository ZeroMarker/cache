Class DHCEPRRBAC.BO.BOPrivateDomainCategory Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

//隐私域目录

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "PrivateDomain";

/// 添加隐私域目录
ClassMethod CreatePrivateDomain(aEPrivateDomain As DHCEPRRBAC.Entity.EPrivateDomainDefinition) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLPrivateDomainDefinition).CreatePrivateDomain(aEPrivateDomain)
}

/// 更新隐私域目录
ClassMethod UpdatePrivateDomain(aEPrivateDomain As DHCEPRRBAC.Entity.EPrivateDomainDefinition) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLPrivateDomainDefinition).UpdatePrivateDomain(aEPrivateDomain)
}

/// 检查隐私级别是否添加
ClassMethod CheckPrivateDomainLevel(aRPDLevel As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLPrivateDomainDefinition).CheckPrivateDomainLevel(aRPDLevel)
}

/// 删隐私域目录
ClassMethod DeletePrivateDomain(aPrivateDomainID As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLPrivateDomainDefinition).DeletePrivateDomain(aPrivateDomainID)
}

/// Desc:      获取隐私域目录
/// Creator:    FLC
/// CreateDate: 2015-10-19
/// Input:      隐私域目录结构
ClassMethod GetPrivateDomainCategory() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("DHCEPRRBAC.BL.BLPrivateDomainDefinition:GetPrivateDomain")
	d result.SetArgs()
	q result
}

/// 添加隐私域项目
ClassMethod CreateItemDefinition(aEItemDefinitionn As DHCEPRRBAC.Entity.EItemDefinition) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLItemDefinition).CreateItemDefinition(aEItemDefinitionn)
}

/// 更新隐私域项目
ClassMethod UpdateItemDefinition(aEItemDefinitionn As DHCEPRRBAC.Entity.EItemDefinition) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLItemDefinition).UpdateItemDefinition(aEItemDefinitionn)
}

/// 添加隐私域项目关联
ClassMethod CreateDomainItemRelation(aEPrivateDomain As DHCEPRRBAC.Entity.EPrivateDomainDefinition, aEItemDefinitionn As DHCEPRRBAC.Entity.EItemDefinition) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLResourceItem).CreateDomainItemRelation(aEPrivateDomain,aEItemDefinitionn)
}

/// 检查隐私域项目关联是否添加
ClassMethod CheckResourceItem(PrivateDomainID As %String, ItemID As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLResourceItem).CheckResourceItem(PrivateDomainID,ItemID)
}

/// 更新隐私域项目关联
ClassMethod UpdateDomainItemRelation(aEPrivateDomain As DHCEPRRBAC.Entity.EPrivateDomainDefinition, aEItemDefinitionn As DHCEPRRBAC.Entity.EItemDefinition) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLResourceItem).UpdateDomainItemRelation(aEPrivateDomain,aEItemDefinitionn)
}

/// 检查隐私项CODE是否添加
ClassMethod CheckItemDefinitionCode(ItemType As %String, aItemCode As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLItemDefinition).CheckItemDefinitionCode(ItemType,aItemCode)
}

/// 删除隐私域项目
ClassMethod DeleteItemDefinition(APrivateDomainID As %String, aItemDefinitionID As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLItemDefinition).DeleteItemDefinition(APrivateDomainID,aItemDefinitionID)
}

/// 获取所有的项目
ClassMethod GetItemDefinition() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("DHCEPRRBAC.BL.BLItemDefinition:GetItemDefinition")
	d result.SetArgs()
	q result
}

/// 获取指定隐私域ID下是项目
ClassMethod GetItemByPDDID(APrivateDomainID As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("DHCEPRRBAC.BL.BLPrivateDomainDefinition:GetItemByPDDID")
	d result.SetArgs(APrivateDomainID)
	q result
}

/// 通过项目ID获取隐私域ID
ClassMethod GetPrivateDomainIDByItemID(aItemID As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLItemDefinition).GetPrivateDomainIDByItemID(aItemID)
}

/// 添加项目术语
ClassMethod CreateElementDefinition(aPrivateDomainID As %String, aElementID As %String, aElementDefinition As DHCEPRRBAC.Entity.EElementDefinition) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLElementDefinition).CreateElementDefinition(aPrivateDomainID,aElementID,aElementDefinition)
}

/// 检查术语项是否添加
ClassMethod CheckElementDefinitionCode(aElementCode As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLElementDefinition).CheckElementDefinitionCode(aElementCode)
}

/// 删除术语项
ClassMethod DeleteElementDefinition(APrivateDomainID As %String, aItemID As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLElementDefinition).DeleteElementDefinition(APrivateDomainID,aItemID)
}

/// 获取项目下的术语
ClassMethod GetElementByItemID(APrivateDomainID As %String, aItemID As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("DHCEPRRBAC.BL.BLPrivateDomainDefinition:GetElementByItemID")
	d result.SetArgs(APrivateDomainID,aItemID)
	q result
}

/// 添加隐私域角色
ClassMethod CreateRoleDefinition(aRoleDefinition As DHCEPRRBAC.Entity.ERoleDefinition) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLRoleDefinition).CreateRoleDefinition(aRoleDefinition)
}

/// 更新隐私域角色
ClassMethod UpdateRoleDefinition(aRoleDefinition As DHCEPRRBAC.Entity.ERoleDefinition) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLRoleDefinition).UpdateRoleDefinition(aRoleDefinition)
}

/// 删除隐私域角色
ClassMethod DeleteRoleDefinition(aRoleDefinitionID As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLRoleDefinition).DeleteRoleDefinition(aRoleDefinitionID)
}

/// 检查隐私域角色是否添加
ClassMethod CheckRoleDefinitionCode(aRoleCode As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLRoleDefinition).CheckRoleDefinitionCode(aRoleCode)
}

///  获取所有隐私域角色
ClassMethod GetRoleDefinition() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("DHCEPRRBAC.BL.BLPrivateDomainDefinition:GetRoleDefinition")
	d result.SetArgs()
	q result
}

/// 添加隐私域角色操作
ClassMethod CreateOperationDefinition(aOperationDefinition As DHCEPRRBAC.Entity.EOperationDefinition) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLOperationDefinition).CreateOperationDefinition(aOperationDefinition)
}

/// 更新隐私域角色操作
ClassMethod UpdateOperationDefinition(aOperationDefinition As DHCEPRRBAC.Entity.EOperationDefinition) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLOperationDefinition).UpdateOperationDefinition(aOperationDefinition)
}

/// 检查隐私域角色操作是否添加
ClassMethod CheckOperationDefinitionCode(aOpCode As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLOperationDefinition).CheckOperationDefinitionCode(aOpCode)
}

/// 删除隐私域角色操作
ClassMethod DeleteOperationDefinition(aOperationDefinitionID As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLOperationDefinition).DeleteOperationDefinition(aOperationDefinitionID)
}

///  获取所有隐私域角色操作
ClassMethod GetOperation() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("DHCEPRRBAC.BL.BLOperationDefinition:GetOperation")
	d result.SetArgs()
	q result
}

/// 添加隐私域、角色、操作关联关系
ClassMethod CreateResourceRoleItem(aResourceRoleItem As DHCEPRRBAC.Entity.EResourceRoleItem) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLResourceRoleItem).CreateResourceRoleItem(aResourceRoleItem)
}

/// 更新隐私域、角色、操作关联关系
ClassMethod UpdateResourceRoleItem(aResourceRoleItem As DHCEPRRBAC.Entity.EResourceRoleItem) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLResourceRoleItem).UpdateResourceRoleItem(aResourceRoleItem)
}

/// 检查隐私域、角色、操作关联关系
ClassMethod CheckResourceRoleItem(RoleID As %String, OperationID As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLResourceRoleItem).CheckResourceRoleItem(RoleID,OperationID)
}

/// 删除隐私域、角色、操作关联关系
ClassMethod DeleteResourceRoleItem(aResourceRoleItemID As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLResourceRoleItem).DeleteResourceRoleItem(aResourceRoleItemID)
}

///  获取所有隐私域、角色、操作关联关系
ClassMethod GetResourceRoleItem() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("DHCEPRRBAC.BL.BLResourceRoleItem:GetResourceRoleItem")
	d result.SetArgs()
	q result
}

/// 添加隐私域角色与安全组关联
ClassMethod CreateDefaultRole(aDefaultRole As DHCEPRRBAC.Entity.EDefaultRole) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLDefaultRole).CreateDefaultRole(aDefaultRole)
}

/// 更新隐私域角色与安全组关联
ClassMethod UpdateDefaultRole(aDefaultRole As DHCEPRRBAC.Entity.EDefaultRole) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLDefaultRole).UpdateDefaultRole(aDefaultRole)
}

/// 删除隐私域角色与安全组关联
ClassMethod DeleteDefaultRole(aDefaultRoleID As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLDefaultRole).DeleteDefaultRole(aDefaultRoleID)
}

/// 获取角色与安全组关联列表
ClassMethod GetDefaultRoleByRoleID(aRoleID As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("DHCEPRRBAC.BL.BLDefaultRole:GetDefaultRoleByRoleID")
	d result.SetArgs(aRoleID)
	q result
}

/// 检查隐角色、安全组关联是否添加
ClassMethod CheckDefaultRole(SSGroupID As %String, RoleID As %String) As %String [ WebMethod ]
{
	q ##Class(DHCEPRRBAC.BL.BLDefaultRole).CheckDefaultRole(SSGroupID,RoleID)
}

}
