Class web.DHCENS.STBLL.DICTNew.MODEL.Body Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Body";

Property SSMainDataApply As list Of web.DHCENS.STBLL.DICTNew.MODEL.SSMDAApply(XMLNAME = "SS_MainDataApply", XMLPROJECTION = "ELEMENT");

Property ssuser As list Of web.DHCENS.STBLL.DICTNew.MODEL.SSUser(XMLNAME = "SS_UserList");

Property CTEnsSystems As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTEnsSystem(XMLNAME = "CT_EnsSystemList");

Property CTEnsSystemTypes As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTEnsSystemType(XMLNAME = "CT_EnsSystemTypeList");

}
