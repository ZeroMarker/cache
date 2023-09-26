Class web.DHCSTMService.Lis.Model.Response Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter ELEMENTQUALIFIED = 0;

Parameter NAMESPACE = "http://his.ws.scm.dhcc.com/";

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property SourceSystem As %String(MAXLEN = "", XMLNAME = "SourceSystem");

Property MessageID As %String(MAXLEN = "", XMLNAME = "MessageID");

Property ResultCode As %String(MAXLEN = "", XMLNAME = "ResultCode");

Property ResultContent As %String(MAXLEN = "", XMLNAME = "ResultContent");

}
