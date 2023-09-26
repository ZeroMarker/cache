/// EPRservice.BOCategoryType
Class EPRservice.BOCategoryType Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "CategoryTypeInfo";

/// TODO: add arguments and implementation.
/// CreateCategoryType
ClassMethod CreateCategoryType(AECategoryType As EPRservice.entity.ECategoryType) As %String [ WebMethod ]
{
 TSTART
 set objCategoryType = ##class(EPRmeta.CategoryType).%New()
 Quit:(objCategoryType ="") "ERROR"
 /*set UniqueFlag = ##class(EPRmeta.CategoryType).CheckNameUnique(ASysOption.Name) 
 if '(UniqueFlag=0)
 { 
 Quit "-1"
 } */

 set objCategoryType.TypeName = AECategoryType.TypeName

 set objCategoryType.TypeDescription = AECategoryType.TypeDescription
 if '(objCategoryType.%Save())
 {
 TROLLBACK
 Quit 0
 } 
 TCOMMIT
 Quit objCategoryType.%Id()
}

ClassMethod DeleteCategoryType(AID As %String) As %Boolean [ WebMethod ]
{
 S ExistID =  ##class(EPRmeta.CategoryType).CheckIdExist(AID)
 if (ExistID = 0) 
 { Quit 1
 }
 set objCategoryType = ##class(EPRmeta.CategoryType).%OpenId(AID)
 Quit objCategoryType.%DeleteId(AID)
}

ClassMethod SelectAllCategoryType() As EPRservice.dataset.ECategoryTypeDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.ECategoryTypeDataset).%New()
 Quit result
}

ClassMethod UpdateCategoryType(AECategoryType As EPRservice.entity.ECategoryType) As %String [ WebMethod ]
{
 set objCategoryType = ##class(EPRmeta.CategoryType).%OpenId(AECategoryType.ID)

 /*S UniqueFlag=##class(EPRmeta.SysOption).CheckUpdateNameUnique(ASysOption.ID,ASysOption.Name)
 if '(UniqueFlag=0)
 { 
 Quit "-1"
 } */
 if (objCategoryType="")
 {Quit "0"}
 set objCategoryType.TypeName = AECategoryType.TypeName
 set objCategoryType.TypeDescription = AECategoryType.TypeDescription
 if '(objCategoryType.%Save())
 {Quit "0"}
 Quit "1"
}

}
