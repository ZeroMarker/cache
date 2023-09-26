Class EMRservice.BOBindQuery Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "BindQueryService";

ClassMethod SelectAllQuery() As EMRservice.dataset.EBindQueryDataset [ WebMethod ]
{
	Set result=##class(EMRservice.dataset.EBindQueryDataset).%New()
 	Do result.SetArgs()
 	Quit result
}

ClassMethod SelectFieldByQID(AQID As %String) As EMRservice.dataset.EBindFieldDataset [ WebMethod ]
{
	Set result=##class(EMRservice.dataset.EBindFieldDataset).%New()
 	Do result.SetArgs(AQID)
 	Quit result
}

ClassMethod AddField(ABindField As EMRservice.entity.EBindField) As %String [ WebMethod ]
{
	
 q ##class(EMRservice.BL.BLBindField).AddField(ABindField)
}

ClassMethod AddParameter(ABindParameter As EMRservice.entity.EBindParameter) As %String [ WebMethod ]
{
 q ##class(EMRservice.BL.BLBindParameter).AddParameter(ABindParameter)
}

ClassMethod AddQuery(ABindQuery As EMRservice.entity.EBindQuery) As %String [ WebMethod ]
{
 q ##class(EMRservice.BL.BLBindQuery).AddQuery(ABindQuery)
}

ClassMethod DelFieldByID(AID As %String) As %Boolean [ WebMethod ]
{
  q ##class(EMRservice.BL.BLBindField).DelFieldByID(AID)
}

ClassMethod DelParameterByID(AID As %String) As %Boolean [ WebMethod ]
{
  q ##class(EMRservice.BL.BLBindParameter).DelParameterByID(AID)
}

ClassMethod DelQueryByID(AID As %String) As %Boolean [ WebMethod ]
{
  q ##class(EMRservice.BL.BLBindQuery).DelQueryByID(AID)
}

ClassMethod GetFieldByID(AID As %String) As EMRservice.entity.EBindField [ WebMethod ]
{
 q ##class(EMRservice.BL.BLBindField).GetFieldByID(AID)
}

ClassMethod GetParameterByID(AID As %String) As EMRservice.entity.EBindParameter [ WebMethod ]
{
 q ##class(EMRservice.BL.BLBindParameter).GetParameterByID(AID)
}

ClassMethod GetQueryByID(AID As %String) As EMRservice.entity.EBindQuery [ WebMethod ]
{
  q ##class(EMRservice.BL.BLBindQuery).GetQueryByID(AID)
}

ClassMethod SelectParameterByQID(AQID As %String) As EMRservice.dataset.EBindParameterDataset [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.EBindParameterDataset).%New()
 Do result.SetArgs(AQID)
 Quit result
}

ClassMethod UpdateField(ABindField As EMRservice.entity.EBindField) As %String [ WebMethod ]
{
 q ##class(EMRservice.BL.BLBindField).UpdateField(ABindField)
}

ClassMethod UpdateParameter(ABindParameter As EMRservice.entity.EBindParameter) As %String [ WebMethod ]
{
 q ##class(EMRservice.BL.BLBindParameter).UpdateParameter(ABindParameter)
}

ClassMethod UpdateQuery(ABindQuery As EMRservice.entity.EBindQuery) As %String [ WebMethod ]
{
  q ##class(EMRservice.BL.BLBindQuery).UpdateQuery(ABindQuery)
}

ClassMethod SelectDistinctParameter() As EMRservice.dataset.EDataBindDisDataSet [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.EDataBindDisDataSet).%New()
 Quit result
}

}
