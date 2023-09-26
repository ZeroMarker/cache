Class web.DHCENS.STBLL.DICTNew.MODEL.MedicalMaterialBody Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Body";

Property MedicineMaterialList As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTMedicineMaterial(XMLNAME = "CT_MedicineMaterialList");

}
