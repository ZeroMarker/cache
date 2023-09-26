Class EPRservice.BLL.BLSelfPrintScheme Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod GetPrintItems(ASchemeName) As %String
{
	s id = ..GetSchemeIDByName(ASchemeName)
	q:(id="") ""
	
	s obj = ##Class(EPRmeta.SelfPrintScheme).%OpenId(id)
	q:(obj="") ""
	
	s printItems = obj.PrintItems
	q:(printItems=$c(0)) ""
	
	q printItems
}

ClassMethod GetSchemeIDByName(ASchemeName) As %String
{
	s id = $O(^DHCEPRM.SelfPrintSchemeI("IdxOnSchemeName"," "_$zcvt(ASchemeName,"u"),""))
	q id
}

/// Debug:	w ##Class(EPRservice.BLL.BLSelfPrintScheme).SetScheme("OutPatientSelfPrint","门诊自助打印方案","29","11")
ClassMethod SetScheme(ASchemeName, ASchemeDesc, APrintItems, AUserID) As %String
{
	//b "s"
	s id = ..GetSchemeIDByName(ASchemeName)
	if (id = "")
	{
		s obj = ##Class(EPRmeta.SelfPrintScheme).%New()
		s obj.SchemeName = ASchemeName
		s obj.CreateDate = $p($h,",",1)
		s obj.CreateTime = $p($h,",",2)
		s obj.CreateUserID = AUserID
	}
	else
	{
		s obj = ##Class(EPRmeta.SelfPrintScheme).%OpenId(id)
	}
	
	s obj.SchemeDesc = ASchemeDesc
	s obj.PrintItems = APrintItems
	s obj.ModifyDate = $p($h,",",1)
	s obj.ModifyTime = $p($h,",",2)
	s obj.ModifyUserID = AUserID
	
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		q obj.%Id()
	}
	else
	{
		q ""
	}
}

}
