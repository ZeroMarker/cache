/// EPRservice.BOCTProperty
Class EPRservice.BOCTProperty Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// /rameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "CTPropertyInfo";

/// TODO: add arguments and implementation.
/// CreateCTProperty
ClassMethod CreateCTProperty(AECTProperty As EPRservice.entity.ECTProperty) As %String [ WebMethod ]
{
 TSTART
 //B "S"
 set objCTProperty = ##class(EPRmeta.CTProperty).%New()
 Quit:(objCTProperty ="") "ERROR"
 /*set UniqueFlag = ##class(EPRmeta.CTProperty).CheckNameUnique(ASysOption.Name) 
 if '(UniqueFlag=0)
 { 
 Quit "-1"
 } */

 set objCTProperty.PropertyName = AECTProperty.PropertyName

 set objCTProperty.PropertyDesc = AECTProperty.PropertyDesc
 if '(objCTProperty.%Save())
 {
 TROLLBACK
 Quit 0
 } 
 TCOMMIT
 Quit objCTProperty.%Id()
}

/// TODO: add arguments and implementation.
/// DeleteCTProperty
ClassMethod DeleteCTProperty(AID As %String) As %Boolean [ WebMethod ]
{
 S ExistID =  ##class(EPRmeta.CTProperty).CheckIdExist(AID)
 if (ExistID = 0) 
 { Quit 1
 }
 set objCategoryType = ##class(EPRmeta.CTProperty).%OpenId(AID)
 Quit objCategoryType.%DeleteId(AID)
}

/// TODO: add arguments and implementation.
/// SelectAllCTProperty
ClassMethod SelectAllCTProperty() As EPRservice.dataset.ECTPropertyDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.ECTPropertyDataset).%New()
 Quit result
}

/// TODO: add arguments and implementation.
/// UpdateCTProperty
ClassMethod UpdateCTProperty(AECTProperty As EPRservice.entity.ECTProperty) As %String [ WebMethod ]
{
 set objCTProperty = ##class(EPRmeta.CTProperty).%OpenId(AECTProperty.ID)

 /*S UniqueFlag=##class(EPRmeta.SysOption).CheckUpdateNameUnique(ASysOption.ID,ASysOption.Name)
 if '(UniqueFlag=0)
 { 
 Quit "-1"
 } */
 if (objCTProperty="")
 {Quit "0"}
 set objCTProperty.PropertyName = AECTProperty.PropertyName
 set objCTProperty.PropertyDesc = AECTProperty.PropertyDesc
 if '(objCTProperty.%Save())
 {Quit "0"}
 Quit "1"
}

}
