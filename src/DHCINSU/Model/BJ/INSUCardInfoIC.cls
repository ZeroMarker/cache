Class DHCINSU.Model.BJ.INSUCardInfoIC Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", ProcedureBlock ]
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 1;

Property cardno As %String(XMLNAME = "card_no") [ Required ];

Property icno As %String(XMLNAME = "ic_no") [ Required ];

Property idno As %String(XMLNAME = "id_no") [ Required ];

Property personname As %String [ Required ];

Property sex As %String [ Required ];

Property birthday As %String;

Property fromhosp As %String;

Property fromhospdate As %String;

Property fundtype As %String;

Property isyt As %String;

Property jclevel As %String;

Property hospflag As %String;

}
