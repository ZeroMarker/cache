Class EPRservice.TemplatePriv.BOATemplatesInGroup Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://192.168.0.15/trakcarejst/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TemplatePriv.TemplatesInGroup";

ClassMethod Add(argTemplatesInGroup As EPRservice.entity.TemplatePriv.ETemplatesInGroup) As %String [ WebMethod ]
{
	q:($d(argTemplatesInGroup)=0)||(argTemplatesInGroup="") 0
	s aTemplatesInGroup="" 
	s aTemplatesInGroup=##class(EPRmeta.TemplatePriv.TemplatesInGroup).%New()
	q:(aTemplatesInGroup="") 0
	
	s aTemplatesInGroup.TemplateGroup=##Class(EPRmeta.TemplatePriv.TemplateGroup).%OpenId(argTemplatesInGroup.TemplateGroup)
	s aTemplatesInGroup.Template=argTemplatesInGroup.Template //##Class(EPRmeta.Template).%OpenId(argTemplatesInGroup.Template)
	
	s result=""
	s result=aTemplatesInGroup.%Save()
	q aTemplatesInGroup.%Id()
}

ClassMethod Delete(argTemplatesInGroupID As %String) As %String [ WebMethod ]
{
	q:($d(argTemplatesInGroupID)=0)||(argTemplatesInGroupID="") 0
	s aTemplatesInGroup="",result=""
	s aTemplatesInGroup=##class(EPRmeta.TemplatePriv.TemplatesInGroup).%OpenId(argTemplatesInGroupID)
	q:(aTemplatesInGroup="") 0
	s aTemplatesInGroup=""
	s result=##class(EPRmeta.TemplatePriv.TemplatesInGroup).%DeleteId(argTemplatesInGroupID)
	q result
}

ClassMethod Update(argTemplatesInGroupID As %String, argTemplatesInGroup As EPRservice.entity.TemplatePriv.ETemplatesInGroup) As %String [ WebMethod ]
{
	q:($d(argTemplatesInGroupID)=0)||($d(argTemplatesInGroup)=0)||(argTemplatesInGroupID="")||(argTemplatesInGroup="") 0
	s aTemplatesInGroup="",result=""
	s aTemplatesInGroup=##class(EPRmeta.TemplatePriv.TemplatesInGroup).%OpenId(argTemplatesInGroupID)
	q:(aTemplatesInGroup="") 0
	
	s aTemplatesInGroup.TemplateGroup=argTemplatesInGroup.TemplateGroup
	s aTemplatesInGroup.Template=argTemplatesInGroup.Template
	
	s result=""
	s result=aTemplatesInGroup.%Save()
	q result
}

ClassMethod GetById(argTemplatesInGroupID As %String) As EPRservice.entity.TemplatePriv.ETemplatesInGroup [ WebMethod ]
{
	s result="",id="",tmpResult=""
	s result=##class(EPRservice.entity.TemplatePriv.ETemplatesInGroup).%New()
	
	s tmpResult=##class(EPRmeta.TemplatePriv.TemplatesInGroup).%OpenId(argTemplatesInGroupID)
	q:(tmpResult="") result
	s result.ID=argTemplatesInGroupID
	s result.TemplateGroup=tmpResult.TemplateGroup
	s result.Template=tmpResult.Template
		
	q result
}

ClassMethod GetAllByGroupId(argTemplatesInGroupID As %String) As EPRservice.dataset.TemplatePriv.ETemplatesInGroupDatasetAll [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.TemplatePriv.ETemplatesInGroupDatasetAll).%New()
 d result.SetArgs(argTemplatesInGroupID)
 Quit result
}

Query SelectAll(parGroupId As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,childsub:%String,TemplateGroup:%String,Template:%String,TemplateDesc:%String,CategoryDesc:%String")
{
	SELECT t.ID as ID,t.childsub as childsub,t.TemplateGroup as TemplateGroupId,t.Template as TemplateId,temp.Name as TemplateName,c.Name as CategoryName
 	FROM EPRmeta_TemplatePriv.TemplatesInGroup t, EPRmeta.TemplateCategory c, EPRmeta.Template temp
	where TemplateGroup->ID = :parGroupId and temp.ID = t.Template and temp.TemplateCategoryID = c.ID
}

Query SelectAllNew(parGroupId As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,childsub:%String,TemplateGroup:%String,Template:%String,TemplateDesc:%String,CategoryDesc:%String")
{
	SELECT t.ID as ID,t.childsub as childsub,t.TemplateGroup as TemplateGroupId,t.Template as TemplateId, c.CategoryName as TemplateName, c.CategoryName as CategoryName
	FROM EPRmeta_TemplatePriv.TemplatesInGroup t, EPRmeta.EPRTemplateCategory c
	where TemplateGroup->ID = :parGroupId and t.Template = c.ID
}

//delete records by templateId

ClassMethod DeleteByTemplateId(parTemplateId As %String) As %String
{
	q ##class(EPRmeta.TemplatePriv.TemplatesInGroup).DeleteByTemplateId(parTemplateId)
}

ClassMethod GetGroupByTemplateID(parTemplateId As %String, parType As %String) As %String [ WebMethod ]
{
	q:($d(parTemplateId)=0)||($d(parType)=0)||(parTemplateId="")||(parType="") "^^"
	
	k SQLCODE
	set templatesInGroupID = 0
	&sql(select id into :templatesInGroupID from EPRmeta_TemplatePriv.TemplatesInGroup
			 where Template=:parTemplateId)
	q:((+templatesInGroupID) < 1) "^^"
	
	s objTemplatesInGroup = ##class(EPRmeta.TemplatePriv.TemplatesInGroup).%OpenId(templatesInGroupID)
	q:(objTemplatesInGroup = "") "^^"
	
	s groupID = objTemplatesInGroup.TemplateGroup.%Id()
	s groupName = objTemplatesInGroup.TemplateGroup.GroupName
	
	q templatesInGroupID_"^"_groupID_"^"_groupName
}

/// Creator: 陈文俊
/// CreatDate: 2008-06-29
/// Description：系统参数中设置的是否采用新框架
/// Table:
/// Input:
/// Output:
/// Return:1--老框架  2--新框架
ClassMethod GetEPRFWVersion() As %String
{
	 s eprFWVersion = "1"
	 s eprFWVersionRowId = ""
	 
     s eprFWVersionRowId = $o(^DHCEPRM.SysOptionI("NameIndex"," EPRFWVERSION",""))
	 if eprFWVersionRowId'=""
	 {
		s eprFWVersion=$li(^DHCEPRM.SysOptionD(eprFWVersionRowId),4)	
	 }
	 
	 if eprFWVersion '= "2"
	 {
		s eprFWVersion = "1"
	 }
	 
	 q eprFWVersion
}

}
