Class web.DHCENS.STBLL.DRUG.MODEL.Body Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Body";

Property addrList As list Of web.DHCENS.STBLL.DRUG.MODEL.DrugStockAddress(XMLNAME = "DrugStockAddressList");

Property OPDrugOrds As list Of web.DHCENS.STBLL.DRUG.MODEL.OPDrugOrdInfo;

Property IPDrugOrds As list Of web.DHCENS.STBLL.DRUG.MODEL.IPDrugOrdInfo;

Property DrugOrdInfos As list Of web.DHCENS.STBLL.DRUG.MODEL.DrugPackageLab;

}
