Class EMRservice.BOMedicalConceptValues Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "MedicalConceptValuesInfo";

ClassMethod SELECTALLBYCategoryID(aCategoryID As %String) As EMRservice.dataset.EMedConceptValuesDataSet [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.EMedConceptValuesDataSet).%New()
 Do result.SetArgs(aCategoryID)
 Quit result
}

/// 查询医学概念
ClassMethod SelectMedConceptVByID(AMedConceptVByID As %String) As EMRservice.entity.EMedicalConceptValues [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLMedicalConceptValues).SelectMedConceptVByID(AMedConceptVByID)
}

/// 增加一个医学概念
ClassMethod CreateMedConceptV(aEMedConceptValues As EMRservice.entity.EMedicalConceptValues) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLMedicalConceptValues).CreateMedConceptV(aEMedConceptValues)
}

/// 删除一个医学概念
ClassMethod DeleteMedConceptVByID(aEMedConceptVId As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLMedicalConceptValues).DeleteMedConceptVByID(aEMedConceptVId)
}

/// 更新一个医学概念
ClassMethod UpdateMedConceptV(aEMedConceptValues As EMRservice.entity.EMedicalConceptValues) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLMedicalConceptValues).UpdateMedConceptV(aEMedConceptValues)
}

/// 更新一个医学概念
ClassMethod selectMaxRowID() As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLMedicalConceptValues).selectMaxRowID()
}

ClassMethod GetSubItemsByID(AMedID As %String) As %Stream [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLMedicalConceptValues).GetSubItemsByID(AMedID)
}

/// 通过ID获取医学概念xml结构流
ClassMethod GetStreamByID(AMedConceptID As %String, AMedCode As %String, ByRef argOutData As %GlobalBinaryStream) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLMedicalConceptValues).GetStreamByID(AMedConceptID,AMedCode,.argOutData)
}

}
