Class DHCINSU.Model.BJ.INSUPayinfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDATTRIBUTE = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLSEQUENCE = 0;

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "payinfo";

Property mzfee As %String;

Property mzfeein As %String;

Property mzfeeout As %String;

Property mzpayfirst As %String;

Property mzselfpay2 As %String;

Property mzbigpay As %String;

Property mzbigselfpay As %String;

Property mzoutofbig As %String;

Property bcpay As %String;

Property jcbz As %String;

}
