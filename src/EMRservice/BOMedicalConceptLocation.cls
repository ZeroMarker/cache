Class EMRservice.BOMedicalConceptLocation Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "MedicalConceptLocationInfo";

ClassMethod SELECTALL() As EMRservice.dataset.EMedicalConceptLocDataSet [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.EMedicalConceptLocDataSet).%New()
 ;Do result.SetArgs("")
 Quit result
}

ClassMethod SELECTALLMED() As EMRservice.dataset.EMedicalConLocValuesDataSet [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.EMedicalConLocValuesDataSet).%New()
 Quit result
}

ClassMethod SelectByConceptCode(aConceptCode As %String) As EMRservice.dataset.EMedicalConLocByCodeDataSet [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.EMedicalConLocByCodeDataSet).%New()
 Do result.SetArgs(aConceptCode)
 Quit result
}

/// 增加一个医学概念关联
ClassMethod CreateMedConceptLoc(aMedConceptMedConceptLoc As EMRservice.entity.EMedicalConceptLocation) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLMedicalConceptLocation).CreateMedConceptLoc(aMedConceptMedConceptLoc)
}

/// 删除一个医学概念关联
ClassMethod DeleteMedConceptLocByID(aMedConceptMedConceptLocId As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLMedicalConceptLocation).DeleteMedConceptLocByID(aMedConceptMedConceptLocId)
}

/// 更新一个医学概念关联
ClassMethod UpdateMedConceptLoc(aID As %String, aCode As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLMedicalConceptLocation).UpdateMedConceptLoc(aID,aCode)
}

/// 判断编码是否已经存在
ClassMethod selectMaxByCode(aCode As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLMedicalConceptLocation).selectMaxByCode(aCode)
}

/// 判断编码是否已经存在
ClassMethod GetMaxID() As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLMedicalConceptLocation).GetMaxID()
}

}
