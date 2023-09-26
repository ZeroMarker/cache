Class BILL.EINV.DTO.TBTCA.DiseaseDetails Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 疾病分类
Property DiseaseItem As list Of BILL.EINV.DTO.TBTCA.DiseaseItem(XMLPROJECTION = "ELEMENT");

}
