Class web.print.DHCListData Extends (%RegisteredObject, %XML.Adaptor)
{

Property PrintType As %String(XMLPROJECTION = "ATTRIBUTE");

Property YStep As %String(XMLPROJECTION = "ATTRIBUTE");

Property XStep As %String(XMLPROJECTION = "ATTRIBUTE");

Property CurrentRow As %String(XMLPROJECTION = "ATTRIBUTE");

Property PageRows As %String(XMLPROJECTION = "ATTRIBUTE");

Property RePrtHeadFlag As %String(XMLPROJECTION = "ATTRIBUTE");

Property BackSlashWidth As %String(XMLPROJECTION = "ATTRIBUTE");

Property BackSlashHeight As %String(XMLPROJECTION = "ATTRIBUTE");

Property Listdatapara As list Of web.print.DHCListDataPara(XMLPROJECTION = "ELEMENT");

}
