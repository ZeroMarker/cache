Class DHCINSU.Model.BJ.INSUCardInfo Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "output";

Property ic As DHCINSU.Model.BJ.INSUCardInfoIC(XMLNAME = "ic");

Property net As DHCINSU.Model.BJ.INSUCardInfoNet(XMLNAME = "net");

}
