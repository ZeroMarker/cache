Class web.DHCBillPrint7 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 82;

/// /成都华西一院医院利用=0
ClassMethod AccPWDCLSID() As %String
{
	w "<OBJECT ID='ClsPWD' WIDTH=0 HEIGHT=0 CLASSID='CLSID:E4C9246B-2C59-4324-A8DD-D58E5A36567C' CODEBASE='../addins/client/DHCCardInfo.CAB#version=1,0,0,45'  VIEWASTEXT>"
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
	;;积水潭的PCSC卡VS
	w "<OBJECT ID='ctlUser' WIDTH=0 HEIGHT=0 CLASSID='CLSID:4F819708-0185-427E-BD26-83B047BDFD8D' CODEBASE='../addins/client/DHCCardInfoTest.CAB#version=1,0,0,2' VIEWASTEXT>"
	w "</object>",!
}

ClassMethod MagCardCLSID() As %String
{
	w "<OBJECT ID='ClsHFCard' WIDTH=0 HEIGHT=0 CLASSID='CLSID:1639C0C8-D16A-4069-AADC-CA1CC3E38108' CODEBASE='../addins/client/DHCCardInfo.CAB#version=1,0,0,5' VIEWASTEXT>"
	w "</OBJECT>"
}

}
