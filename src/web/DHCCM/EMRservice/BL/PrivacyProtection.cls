/// Desc:隐私保存
/// Creator:Candy
/// CreateDate:2015-10-26
Class web.DHCCM.EMRservice.BL.PrivacyProtection Extends (%RegisteredObject, %XML.Adaptor)
{

/// Desc:       隐私项集合
/// Creator:    candy
/// CreateDate: 2015-10-26
/// Input:      AInstanceID 实例ID
///             ASSgroupID 安全组ID
///             AOperation 操作
/// Output:     result: 隐私集合
ClassMethod PrivateDomains(AInstanceID As %String, ASSgroupID As %String, AOperation As %String) As %GlobalBinaryStream
{
	s result = ##Class(%GlobalBinaryStream).%New()
	q:(AInstanceID = "")||(ASSgroupID = "") result
	s domainId = ..GetPrivateDomainId(ASSgroupID,AOperation)
	q:(domainId = "") result
	s ecrecordId = $p(AInstanceID,"||",1)
    s templateId = ""
    s count = 0
    for
    {
	    s templateId = $o(^DHCPHI.InstanceDataI("IdxEcrecordTemplateStatus",ecrecordId,templateId))
	    q:(templateId = "")
	    continue:($d(^DHCPHI.InstanceDataI("IdxEcrecordTemplateStatus",ecrecordId,templateId," SAVE"))<0)
	    s tempId = $tr(templateId," ")
	    s tempDomainItem = ..GetTemplatePrivateDomain(tempId,domainId)
	    d:(count '=0) result.Write(",")
	    d result.Write(tempDomainItem)
	    s count = count + 1
	}
	q result
}

/// Desc:       通过安全组获取用户操作隐私域
/// Creator:    Candy
/// CreateDate: 2015-10-26
/// Input:      ASSGroupID 安全组ID
///             AOperation 操作代码
/// OutPut:     privateDomainId 用户角色下关联隐私域
/// Debug:      w ##Class(EMRservice.BL.Test).GetPrivateDomainId(100,"view")
ClassMethod GetPrivateDomainId(ASSGroupID As %String, AOperation As %String) As %String
{
	s result = ""
	q:(ASSGroupID = "") result
	s operationId = $o(^DHCEPRRBAC.META.OperDFI("IdxMain"," "_$zcvt(AOperation,"U"),""))
	q:(operationId = "") result

	s roleId = ""
	for
	{
		s roleId = $o(^DHCEPRRBAC.INST.DefaultRoleI("IdxSSGroupRoleID"," "_ASSGroupID,roleId))
		q:(roleId = "")
		continue:($d(^DHCEPRRBAC.INST.ResourceRItemI("IdxRolePrivateDomain",roleId," "_operationId))<0)
		s privateDomainId = $o(^DHCEPRRBAC.INST.ResourceRItemI("IdxRolePrivateDomain",roleId," "_operationId,""))
		s result = $tr(privateDomainId," ")
		q
	}
	q result
}

/// Desc:       获取模板隐藏元素
/// Creator:    Candy
/// CreateDate: 2015-10-26
/// Input:      ATemplateID 模板ID
///             APrivateDomainID 隐私域ID
/// Output:     result 模板隐私项目集
/// Debug:      w ##Class(EMRservice.BL.PrivacyProtection).GetTemplatePrivateDomain(16,2)
ClassMethod GetTemplatePrivateDomain(ATemplateID As %String, APrivateDomainID As %String) As %String
{
	s result = ""
	q:(ATemplateID = "") result	
	s count = 0
	s glossaryItemId = ""
	for {
	   s glossaryItemId = $o(^DHCEPRM.GlossaryItemI("IdxTemplateID",ATemplateID,glossaryItemId))
	   q:(glossaryItemId = "")
	   s objGlossaryItem = ##Class(EPRmeta.GlossaryItem).%OpenId(glossaryItemId)
	   continue:(objGlossaryItem = "")
	   s glossaryId = objGlossaryItem.GlossaryID
	   continue:(glossaryId = "")
	   s objGlossary = ##Class(EPRmeta.Glossary).%OpenId(glossaryId)
	   continue:(objGlossary = "")
	   s InternalId = objGlossary.InternalID
	   continue:(InternalId = "")
	   s elementId = $o(^DHCEPRRBAC.META.ElementDFI("IdxElementCode"," "_$zcvt(InternalId,"U"),""))
	   continue:(elementId = "")
	   if ($d(^DHCEPRRBAC.INST.RSRCElementI("IdexPrivateDomainElementID"," "_APrivateDomainID," "_elementId))>0)
	   {
		   s glossaryItemCode = objGlossaryItem.ItemCode
		   continue:(glossaryItemCode = "")
		   s tempPath = $p(glossaryItemCode,"#",3)
		   s path = ""
		   for i=1:1:$L(tempPath,"|")
		   {
			   s tempCode = $p(tempPath,"|",i)
			   s:(i'=1) path = path_"_"
			   s tempCode = $p(tempCode,":",2)
			   s:(tempCode = "HEADER") tempCode = "Header" 
			   s:(tempCode = "FOOTER") tempCode = "Footer"  
			   s path = path_tempCode
		   }
		   s:(count '= 0) result = result_","
		   s result = result_""""_path_"""" 
		   s count = count + 1
	   }
	}
	s templateGuid = ""
	s objTemplate = ##Class(EMRmeta.Template).%OpenId(ATemplateID)
	s:(objTemplate '= "") templateGuid = objTemplate.GUID
	s result = "{""TemplateGUID"":"""_templateGuid_""",""items"":["_result_"]}"
	q result
}

}
