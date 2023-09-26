Class DHCENS.IIP.Model.PatEMR Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "EMR";

Property FileNo As %String(MAXLEN = 32767, XMLNAME = "FileNo");

Property DocName As %String(MAXLEN = 32767, XMLNAME = "DocName");

Property DateTime As %String(MAXLEN = 32767, XMLNAME = "DateTime");

Property Content As %String(MAXLEN = 32767, XMLNAME = "Content");

}
