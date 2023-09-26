/// EPRservice.BOBindQueryService
Class EPRservice.BOBindQueryService Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "BindQueryService";

ClassMethod AddField(ABindField As EPRservice.entity.EBindField) As %String [ WebMethod ]
{
 TSTART
 set objBindField = ##class(EPRmeta.BindField).%New()
 Quit:(objBindField ="") "ERROR" 
 set objBindField.Name = ABindField.Name
 set objBindField.Description = ABindField.Description
 set objBindField.FieldName = ABindField.FieldName
 set objBindField.FieldType = ABindField.FieldType
 set objBindField.QueryID = ABindField.QueryID
 set objBindField.DicID = ABindField.DicID

 if '(objBindField.%Save())
 {
 TROLLBACK
 Quit 0
 } 
 TCOMMIT
 Quit objBindField.%Id()
}

ClassMethod AddParameter(ABindParameter As EPRservice.entity.EBindParameter) As %String [ WebMethod ]
{
 TSTART
 set objBindParameter = ##class(EPRmeta.BindParameter).%New()
 Quit:(objBindParameter ="") "ERROR" 
 set objBindParameter.Name = ABindParameter.Name
 set objBindParameter.Description = ABindParameter.Description
 set objBindParameter.ParameterName = ABindParameter.ParameterName
 set objBindParameter.ParameterType = ABindParameter.ParameterType
 set objBindParameter.QueryID = ABindParameter.QueryID
 //EPRmeta.BindParameter

 if '(objBindParameter.%Save())
 {
 TROLLBACK
 Quit 0
 } 
 TCOMMIT
 Quit objBindParameter.%Id()
}

ClassMethod AddQuery(ABindQuery As EPRservice.entity.EBindQuery) As %String [ WebMethod ]
{
 TSTART
 set objBindQuery = ##class(EPRmeta.BindQuery).%New()
 Quit:(objBindQuery ="") "ERROR" 
 set objBindQuery.Name = ABindQuery.Name
 set objBindQuery.ClassName = ABindQuery.ClassName
 set objBindQuery.Description = ABindQuery.Description
 set objBindQuery.QueryName = ABindQuery.QueryName
 set objBindQuery.SingleResult = ABindQuery.SingleResult
 set objBindQuery.Mark = ABindQuery.Mark

 if '(objBindQuery.%Save())
 {
 TROLLBACK
 Quit 0
 } 
 TCOMMIT
 Quit objBindQuery.%Id()
}

ClassMethod DelFieldByID(AID As %String) As %Boolean [ WebMethod ]
{
 //B "S"
 TSTART
 set objBindField = ##class(EPRmeta.BindField).%OpenId(AID)
 Quit:(objBindField ="") 0 

 if '(objBindField.%DeleteId(AID))
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
 set objBindParameter = ##class(EPRmeta.BindParameter).%OpenId(AID)
 Quit:(objBindParameter ="") 0 

 if '(objBindParameter.%DeleteId(AID))
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
 set objBindQuery = ##class(EPRmeta.BindQuery).%OpenId(AID)
 Quit:(objBindQuery ="") 0 

 do ##class(EPRmeta.BindField).DelFieldByQueryId(AID) 
 do ##class(EPRmeta.BindParameter).DelParameterByQueryId(AID) 

 if '(objBindQuery.%DeleteId(AID))
 {
 TROLLBACK
 Quit 0
 } 
 TCOMMIT
 Quit 1
}

ClassMethod GetFieldByID(AID As %String) As EPRservice.entity.EBindField [ WebMethod ]
{
 set objBindQuery = ##class(EPRmeta.BindField).%OpenId(AID)
 q:(objBindQuery="") ""
 set Result = ##class(EPRservice.entity.EBindField).%New()
 set Result.ID = objBindQuery.%Id()
 set Result.Name = objBindQuery.Name
 set Result.FieldName = objBindQuery.FieldName
 set Result.FieldType = objBindQuery.FieldType
 Set Result.QueryID = objBindQuery.QueryID
 set Result.Description = objBindQuery.Description
 Quit Result
}

ClassMethod GetParameterByID(AID As %String) As EPRservice.entity.EBindParameter [ WebMethod ]
{
 set objBindParameter = ##class(EPRmeta.BindParameter).%OpenId(AID)
 q:(objBindParameter="") ""
 set Result = ##class(EPRservice.entity.EBindParameter).%New()
 set Result.ID = objBindQuery.%Id()
 set Result.ParameterName = objBindParameter.ParameterName
 set Result.ParameterType = objBindParameter.ParameterType
 Set Result.Name = objBindParameter.Name
 Set Result.Description = objBindParameter.Description
 set Result.QueryID = objBindParameter.QueryID
 Quit Result
}

ClassMethod GetQueryByID(AID As %String) As EPRservice.entity.EBindQuery [ WebMethod ]
{
 set objBindQuery = ##class(EPRmeta.BindQuery).%OpenId(AID)
 q:(objBindQuery="") ""
 set Result = ##class(EPRservice.entity.EBindQuery).%New()
 set Result.ID = objBindQuery.%Id()
 set Result.ClassName = objBindQuery.ClassName
 set Result.QueryName = objBindQuery.QueryName
 Set Result.SingleResult = objBindQuery.SingleResult
 set Result.Description = objBindQuery.Description
 Quit Result
}

ClassMethod SelectAllQuery() As EPRservice.dataset.EBindQueryDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.EBindQueryDataset).%New()
 Quit result
}

ClassMethod SelectFieldByQID(AQID As %String) As EPRservice.dataset.EBindFieldDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.EBindFieldDataset).%New()
 Do result.SetArgs(AQID)
 Quit result
}

ClassMethod SelectParameterByQID(AQID As %String) As EPRservice.dataset.EBindParameterDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.EBindParameterDataset).%New()
 Do result.SetArgs(AQID)
 Quit result
}

ClassMethod UpdateField(ABindField As EPRservice.entity.EBindField) As %String [ WebMethod ]
{
 TSTART
 set objBindField = ##class(EPRmeta.BindField).%OpenId(ABindField.ID)
 Quit:(objBindField ="") "0"

 set objBindField.Name = ABindField.Name
 set objBindField.Description = ABindField.Description
 set objBindField.FieldName = ABindField.FieldName
 set objBindField.FieldType = ABindField.FieldType
 set objBindField.QueryID = ABindField.QueryID
 set objBindField.DicID = ABindField.DicID


 if '(objBindField.%Save())
 {
 TROLLBACK
 Quit "0"
 } 
 TCOMMIT
 Quit "1"
}

ClassMethod UpdateParameter(ABindParameter As EPRservice.entity.EBindParameter) As %String [ WebMethod ]
{
 TSTART
 set objBindParameter = ##class(EPRmeta.BindParameter).%OpenId(ABindParameter.ID)
 Quit:(objBindParameter ="") "0"
 set objBindParameter.Name = ABindParameter.Name
 set objBindParameter.Description = ABindParameter.Description
 set objBindParameter.ParameterName = ABindParameter.ParameterName
 set objBindParameter.ParameterType = ABindParameter.ParameterType
 set objBindParameter.QueryID = ABindParameter.QueryID


 if '(objBindParameter.%Save())
 {
 TROLLBACK
 Quit "0"
 } 
 TCOMMIT
 Quit "1"
}

ClassMethod UpdateQuery(ABindQuery As EPRservice.entity.EBindQuery) As %String [ WebMethod ]
{
 TSTART
 set objBindQuery = ##class(EPRmeta.BindQuery).%OpenId(ABindQuery.ID)

 Quit:(objBindQuery ="") "0"
 set ^AAAA(1)=ABindQuery.ID_"^"_ABindQuery.Name_"^"_ABindQuery.ClassName_"^"_ABindQuery.Description_"^"_ABindQuery.QueryName_"^"_ABindQuery.SingleResult
 set objBindQuery.Name = ABindQuery.Name
 set objBindQuery.ClassName = ABindQuery.ClassName
 set objBindQuery.Description = ABindQuery.Description
 set objBindQuery.QueryName = ABindQuery.QueryName
 set objBindQuery.SingleResult = ABindQuery.SingleResult
 set objBindQuery.Mark = ABindQuery.Mark

 if '(objBindQuery.%Save())
 {
 TROLLBACK
 Quit "0"
 } 
 TCOMMIT
 Quit "1"
}

ClassMethod SelectDistinctParameter() As EPRservice.dataset.EDataBindDisDataSet [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.EDataBindDisDataSet).%New()
 Quit result
}

}
