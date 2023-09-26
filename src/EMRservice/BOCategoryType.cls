/// EMRservice.BOCategoryType
Class EMRservice.BOCategoryType Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "CategoryTypeInfo";

/// TODO: add arguments and implementation.
/// CreateCategoryType
ClassMethod CreateCategoryType(AECategoryType As EMRservice.entity.ECategoryType) As %String [ WebMethod ]
{
 set objCategoryType = ##class(EMRmeta.CategoryType).%New()
 Quit:(objCategoryType ="") "ERROR"
 /*set UniqueFlag = ##class(EMRmeta.CategoryType).CheckNameUnique(ASysOption.Name) 
 if '(UniqueFlag=0)
 { 
 Quit "-1"
 } */

 set objCategoryType.TypeName = AECategoryType.TypeName

 set objCategoryType.TypeDescription = AECategoryType.TypeDescription
 if '(objCategoryType.%Save())
 {
 Quit 0
 } 
 Quit objCategoryType.%Id()
}

ClassMethod DeleteCategoryType(AID As %String) As %Boolean [ WebMethod ]
{
 S ExistID =  ##class(EMRservice.BL.BLCategoryType).CheckIdExist(AID)
 if (ExistID = 0) 
 { Quit 1
 }
 set objCategoryType = ##class(EMRmeta.CategoryType).%OpenId(AID)
 Quit objCategoryType.%DeleteId(AID)
}

ClassMethod SelectAllCategoryType() As EMRservice.dataset.ECategoryTypeDataset [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.ECategoryTypeDataset).%New()
 Quit result
}

ClassMethod UpdateCategoryType(AECategoryType As EMRservice.entity.ECategoryType) As %String [ WebMethod ]
{
 set objCategoryType = ##class(EMRmeta.CategoryType).%OpenId(AECategoryType.ID)

 /*S UniqueFlag=##class(EMRmeta.SysOption).CheckUpdateNameUnique(ASysOption.ID,ASysOption.Name)
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
