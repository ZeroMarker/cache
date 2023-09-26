Class web.DHCBillPrint12 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 0;

/// /北京地坛医院
ClassMethod AccPWDCLSID() As %String
{
	//32AC5E41-C340-479D-9D90-8C4528959161
	//w "<OBJECT ID='ClsPWD' WIDTH=0 HEIGHT=0 CLASSID='CLSID:5BCA2C96-7C02-4972-ABFB-F6C89111FDCB' CODEBASE='../addins/client/DHCCardInfo.CAB#version=1,0,0,60'  VIEWASTEXT>"
	//w "</OBJECT>",!
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
	//w "<OBJECT ID='ClsHFCard' WIDTH=0 HEIGHT=0 CLASSID='CLSID:1639C0C8-D16A-4069-AADC-CA1CC3E38108' CODEBASE='../addins/client/DHCCardInfo.CAB#version=1,0,0,5' VIEWASTEXT>"
	//w "</OBJECT>"
}

}
