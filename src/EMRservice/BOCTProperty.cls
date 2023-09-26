/// EMRservice.BOCTProperty
Class EMRservice.BOCTProperty Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// /rameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "CTPropertyInfo";

/// TODO: add arguments and implementation.
/// CreateCTProperty
ClassMethod CreateCTProperty(AECTProperty As EMRservice.entity.ECTProperty) As %String [ WebMethod ]
{
	set objCTProperty = ##class(EMRmeta.CTProperty).%New()
	Quit:(objCTProperty ="") "ERROR"

 	set objCTProperty.PropertyCode = AECTProperty.PropertyCode
 	set objCTProperty.PropertyName = AECTProperty.PropertyName
 	set objCTProperty.ParentID = AECTProperty.ParentID
 	if '(objCTProperty.%Save())
 	{
 		Quit 0
 	}
 	Quit objCTProperty.%Id()
}

/// TODO: add arguments and implementation.
/// DeleteCTProperty
ClassMethod DeleteCTProperty(AID As %String) As %Boolean [ WebMethod ]
{
 S ExistID = ##Class(EMRservice.BL.BLCTProperty).CheckIdExist(AID)
 if (ExistID = 0) 
 { Quit 1
 }
 set objCategoryType = ##class(EMRmeta.CTProperty).%OpenId(AID)
 Quit objCategoryType.%DeleteId(AID)
}

/// TODO: add arguments and implementation.
/// SelectAllCTProperty
ClassMethod SelectAll() As EMRservice.dataset.ECTPropertyDataset [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.ECTPropertyDataset).%New()
 Do result.SetArgs()
 Quit result
}

/// TODO: add arguments and implementation.
/// UpdateCTProperty
ClassMethod UpdateCTProperty(AECTProperty As EMRservice.entity.ECTProperty) As %String [ WebMethod ]
{
 set objCTProperty = ##class(EMRmeta.CTProperty).%OpenId(AECTProperty.ID)

 if (objCTProperty="")
 {Quit "0"}
  
 set objCTProperty.PropertyCode = AECTProperty.PropertyCode
 set objCTProperty.PropertyName = AECTProperty.PropertyName
 if '(objCTProperty.%Save())
 {Quit "0"}
 Quit "1"
}

ClassMethod SELECTBYPARENTID(AParentID As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLCTProperty:SELECTBYPARENTID")
	d result.SetArgs(AParentID)
	q result
}

/// w ##Class(EMRservice.BOCTProperty).SelectByCateID("0")
/// 通过TemplateCategoryID查找其下级节点
ClassMethod SelectByCateID(ACateId As %String) As %XML.DataSet [ WebMethod ]
{
    s cate=##Class(EMRmeta.TemplateCategory).%OpenId(ACateId)
    s code=cate.PropertyCode
    s AParentID = ""
    s AParentID=$O(^DHCEMRM.CTPropertyI("IdxCode", " "_$zcvt(code,"U"), AParentID))
    if (AParentID'="")
    {
	    s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLCTProperty:SELECTBYPARENTID")
	    d result.SetArgs(AParentID)
	    q result
    }
    q ""
}

ClassMethod GetNameByCode(ACode As %String) As %String [ WebMethod ]
{
	q:(ACode="") ""
    s id = ""
    s id=$O(^DHCEMRM.CTPropertyI("IdxCode", " "_$zcvt(ACode,"U"), id))
    s objCTProperty = ##class(EMRmeta.CTProperty).%OpenId(id)
    q objCTProperty.PropertyName
}

}
