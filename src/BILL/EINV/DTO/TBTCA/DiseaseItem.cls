Class BILL.EINV.DTO.TBTCA.DiseaseItem Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 疾病诊断编码
Property DiseaseCode As %String(XMLPROJECTION = "ELEMENT");

/// 疾病诊断名称
Property DiseaseName As %String(XMLPROJECTION = "ELEMENT");

/// 疾病是否主诊断
Property DiseaseFlag As %String(XMLPROJECTION = "ELEMENT");

}
