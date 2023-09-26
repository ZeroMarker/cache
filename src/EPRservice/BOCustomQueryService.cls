/// EPRservice.BOCustomQueryService
Class EPRservice.BOCustomQueryService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "CustomQueryService";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// TODO: add arguments and implementation.
/// Test
ClassMethod AddField(ACustomField As EPRservice.entity.ECustomField) As %String [ WebMethod ]
{
 TSTART
 set objCustomField = ##class(EPRmeta.CustomField).%New()
 Quit:(objCustomField ="") "ERROR" 
 set objCustomField.Name = ACustomField.Name
 set objCustomField.Description = ACustomField.Description
 set objCustomField.FieldName = ACustomField.FieldName
 set objCustomField.FieldType = ACustomField.FieldType
 set objCustomField.QueryID = ACustomField.QueryID


 if '(objCustomField.%Save())
 {
 TROLLBACK
 Quit 0
 } 
 TCOMMIT
 Quit objCustomField.%Id()
}

ClassMethod AddParameter(ACustomParameter As EPRservice.entity.ECustomParameter) As %String [ WebMethod ]
{
 TSTART
 set objCustomParameter = ##class(EPRmeta.CustomParameter).%New()
 Quit:(objCustomParameter ="") "ERROR" 
 set objCustomParameter.Name = ACustomParameter.Name
 set objCustomParameter.Description = ACustomParameter.Description
 set objCustomParameter.ParameterName = ACustomParameter.ParameterName
 set objCustomParameter.ParameterType = ACustomParameter.ParameterType
 set objCustomParameter.QueryID = ACustomParameter.QueryID
 //EPRmeta.CustomParameter

 if '(objCustomParameter.%Save())
 {
 TROLLBACK
 Quit 0
 } 
 TCOMMIT
 Quit objCustomParameter.%Id()
}

ClassMethod AddQuery(ACustomQuery As EPRservice.entity.ECustomQuery) As %String [ WebMethod ]
{
 TSTART
 set objCustomQuery = ##class(EPRmeta.CustomQuery).%New()
 Quit:(objCustomQuery ="") "ERROR" 
 set objCustomQuery.Name = ACustomQuery.Name
 set objCustomQuery.ClassName = ACustomQuery.ClassName
 set objCustomQuery.Description = ACustomQuery.Description
 set objCustomQuery.QueryName = ACustomQuery.QueryName
 set objCustomQuery.SingleResult = ACustomQuery.SingleResult


 if '(objCustomQuery.%Save())
 {
 TROLLBACK
 Quit 0
 } 
 TCOMMIT
 Quit objCustomQuery.%Id()
}

ClassMethod DelFieldByID(AID As %String) As %Boolean [ WebMethod ]
{
 //B "S"
 TSTART
 set objCustomField = ##class(EPRmeta.CustomField).%OpenId(AID)
 Quit:(objCustomField ="") 0 

 if '(objCustomField.%DeleteId(AID))
 {
 TROLLBACK
 Quit 0
 } 
 TCOMMIT
 Quit 1
}

ClassMethod DelParameterByID(AID As %String) As %Boolean [ WebMethod ]
{
 TSTART
 set objCustomParameter = ##class(EPRmeta.CustomParameter).%OpenId(AID)
 Quit:(objCustomParameter ="") 0 

 if '(objCustomParameter.%DeleteId(AID))
 {
 TROLLBACK
 Quit 0
 } 
 TCOMMIT
 Quit 1
}

ClassMethod DelQueryByID(AID As %String) As %Boolean [ WebMethod ]
{
 TSTART
 set objCustomQuery = ##class(EPRmeta.CustomQuery).%OpenId(AID)
 Quit:(objCustomQuery ="") 0 

 do ##class(EPRmeta.CustomField).DelFieldByQueryId(AID) 
 do ##class(EPRmeta.CustomParameter).DelParameterByQueryId(AID) 

 if '(objCustomQuery.%DeleteId(AID))
 {
 TROLLBACK
 Quit 0
 } 
 TCOMMIT
 Quit 1
}

ClassMethod GetFieldByID(AID As %String) As EPRservice.entity.ECustomField [ WebMethod ]
{
 set objCustomQuery = ##class(EPRmeta.CustomField).%OpenId(AID)
 q:(objCustomQuery="") ""
 set Result = ##class(EPRservice.entity.ECustomField).%New()
 set Result.ID = objCustomQuery.%Id()
 set Result.Name = objCustomQuery.Name
 set Result.FieldName = objCustomQuery.FieldName
 set Result.FieldType = objCustomQuery.FieldType
 Set Result.QueryID = objCustomQuery.QueryID
 set Result.Description = objCustomQuery.Description
 Quit Result
}

ClassMethod GetParameterByID(AID As %String) As EPRservice.entity.ECustomParameter [ WebMethod ]
{
 set objCustomParameter = ##class(EPRmeta.CustomParameter).%OpenId(AID)
 q:(objCustomParameter="") ""
 set Result = ##class(EPRservice.entity.ECustomParameter).%New()
 set Result.ID = objCustomQuery.%Id()
 set Result.ParameterName = objCustomParameter.ParameterName
 set Result.ParameterType = objCustomParameter.ParameterType
 Set Result.Name = objCustomParameter.Name
 Set Result.Description = objCustomParameter.Description
 set Result.QueryID = objCustomParameter.QueryID
 Quit Result
}

ClassMethod GetQueryByID(AID As %String) As EPRservice.entity.ECustomQuery [ WebMethod ]
{
 set objCustomQuery = ##class(EPRmeta.CustomQuery).%OpenId(AID)
 q:(objCustomQuery="") ""
 set Result = ##class(EPRservice.entity.ECustomQuery).%New()
 set Result.ID = objCustomQuery.%Id()
 set Result.ClassName = objCustomQuery.ClassName
 set Result.QueryName = objCustomQuery.QueryName
 Set Result.SingleResult = objCustomQuery.SingleResult
 set Result.Description = objCustomQuery.Description
 Quit Result
}

ClassMethod SelectAllQuery() As EPRservice.dataset.ECustomQueryDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.ECustomQueryDataset).%New()
 Quit result
}

ClassMethod SelectFieldByQID(AQID As %String) As EPRservice.dataset.ECustomFieldDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.ECustomFieldDataset).%New()
 Do result.SetArgs(AQID)
 Quit result
}

ClassMethod SelectParameterByQID(AQID As %String) As EPRservice.dataset.ECustomParameterDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.ECustomParameterDataset).%New()
 Do result.SetArgs(AQID)
 Quit result
}

ClassMethod UpdateField(ACustomField As EPRservice.entity.ECustomField) As %String [ WebMethod ]
{
 TSTART
 set objCustomField = ##class(EPRmeta.CustomField).%OpenId(ACustomField.ID)
 Quit:(objCustomField ="") "0"

 set objCustomField.Name = ACustomField.Name
 set objCustomField.Description = ACustomField.Description
 set objCustomField.FieldName = ACustomField.FieldName
 set objCustomField.FieldType = ACustomField.FieldType
 set objCustomField.QueryID = ACustomField.QueryID


 if '(objCustomField.%Save())
 {
 TROLLBACK
 Quit "0"
 } 
 TCOMMIT
 Quit "1"
}

ClassMethod UpdateParameter(ACustomParameter As EPRservice.entity.ECustomParameter) As %String [ WebMethod ]
{
 TSTART
 set objCustomParameter = ##class(EPRmeta.CustomParameter).%OpenId(ACustomParameter.ID)
 Quit:(objCustomParameter ="") "0"
 set objCustomParameter.Name = ACustomParameter.Name
 set objCustomParameter.Description = ACustomParameter.Description
 set objCustomParameter.ParameterName = ACustomParameter.ParameterName
 set objCustomParameter.ParameterType = ACustomParameter.ParameterType
 set objCustomParameter.QueryID = ACustomParameter.QueryID


 if '(objCustomParameter.%Save())
 {
 TROLLBACK
 Quit "0"
 } 
 TCOMMIT
 Quit "1"
}

ClassMethod UpdateQuery(ACustomQuery As EPRservice.entity.ECustomQuery) As %String [ WebMethod ]
{
 TSTART
 set objCustomQuery = ##class(EPRmeta.CustomQuery).%OpenId(ACustomQuery.ID)

 Quit:(objCustomQuery ="") "0"
 set ^AAAA(1)=ACustomQuery.ID_"^"_ACustomQuery.Name_"^"_ACustomQuery.ClassName_"^"_ACustomQuery.Description_"^"_ACustomQuery.QueryName_"^"_ACustomQuery.SingleResult
 set objCustomQuery.Name = ACustomQuery.Name
 set objCustomQuery.ClassName = ACustomQuery.ClassName
 set objCustomQuery.Description = ACustomQuery.Description
 set objCustomQuery.QueryName = ACustomQuery.QueryName
 set objCustomQuery.SingleResult = ACustomQuery.SingleResult

 if '(objCustomQuery.%Save())
 {
 TROLLBACK
 Quit "0"
 } 
 TCOMMIT
 Quit "1"
}

ClassMethod TestQuery()
{
  set aa=##class(EPRservice.entity.ECustomQuery).%New()
  
 set aa.ID = "2" 
 set aa.Name = "55"
 set aa.ClassName = "UuUu"
 set aa.Description = "55"
 set aa.QueryName = "QQQ"
 set aa.SingleResult = "11"
 d ##class(EPRservice.BOCustomQueryService).UpdateQuery(aa)
}

}
