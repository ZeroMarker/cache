Class DHCExternalService.BillInterface.DHCEntity.AdmReason Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property InsuTypeDesc As %String(TRUNCATE = 1);

Property InsuTypeDR As %String(TRUNCATE = 1);

Property AmtSum As %String(TRUNCATE = 1);

Property TarOCCateItems As list Of DHCExternalService.BillInterface.DHCEntity.TarOCCateItem;

}
