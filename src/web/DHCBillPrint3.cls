Class web.DHCBillPrint3 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 76;

/// /山西大同专用=3
ClassMethod AccPWDCLSID() As %String
{
	;加入密码验证类
	w "<OBJECT ID='ClsPWD' WIDTH=0 HEIGHT=0 CLASSID='CLSID:35FB1FAF-FDE3-4189-91FB-0AAA359C0210' CODEBASE='../addins/client/DHCCardInfo.CAB#version=1,0,0,1'  VIEWASTEXT>"
	w "</OBJECT>",!
}

/// //, websys.Abstract
ClassMethod InvBillPrintCLSID() As %String
{
}

ClassMethod JSTPCSVS() As %String
{
}

ClassMethod JSTPCSVSTest() As %String
{
}

ClassMethod MagCardCLSID() As %String
{
}

}
