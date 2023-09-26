Class web.DHCBillPrint0 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 73;

/// /积水潭医院利用=0
ClassMethod AccPWDCLSID() As %String
{
	;加入密码验证类
	s myVer=##class(web.DHCOPConfig).GetVersion()
	if (+myVer=1){
		w "<OBJECT ID='ClsPWD' WIDTH=0 HEIGHT=0 CLASSID='CLSID:E4C9246B-2C59-4324-A8DD-D58E5A36567C' CODEBASE='../addins/client/DHCCardInfo.CAB#version=1,0,0,31'  VIEWASTEXT>"
		w "</OBJECT>",!
	}elseif(+myVer=0){
		w "<OBJECT ID='ClsPWD' WIDTH=0 HEIGHT=0 CLASSID='CLSID:7D9D3AE3-5F37-4438-95CC-7D0658334782' CODEBASE='../addins/client/DHCCardInfo.CAB#version=1,0,0,4'  VIEWASTEXT>"
		w "</OBJECT>",!
	}
}

/// //, websys.Abstract
ClassMethod InvBillPrintCLSID() As %String
{
	w "<object ID='ClsBillPrint' WIDTH=0 HEIGHT=0 CLASSID='CLSID:F30DC1D4-5E29-4B89-902F-2E3DC81AE46D' CODEBASE='../addins/client/DHCOPPrint.CAB#version=1,0,0,43' VIEWASTEXT>"
	w "</object>",!
}

ClassMethod JSTPCSVS() As %String
{
	;;积水潭的PCSC卡VS
	;w "<OBJECT ID='ClsPCSCard' WIDTH=0 HEIGHT=0 CLASSID='CLSID:36479886-8EFD-4288-93FA-91F404C9BC4C' CODEBASE='../addins/client/DHCCardInfo.CAB#version=1,0,0,31' VIEWASTEXT>"
	s myVer=##class(web.DHCOPConfig).GetVersion()
	
	if (+myVer=1){
		w "<OBJECT ID='ClsPCSCard' WIDTH=0 HEIGHT=0 CLASSID='CLSID:36479886-8EFD-4288-93FA-91F404C9BC4C' CODEBASE='../addins/client/DHCCardInfo.CAB#version=1,0,0,31' VIEWASTEXT>"
		w "</object>",!
	}elseif(+myVer=0){
	}
}

ClassMethod JSTPCSVSTest() As %String
{
	;;积水潭的PCSC卡VS
	w "<OBJECT ID='ctlUser' WIDTH=0 HEIGHT=0 CLASSID='CLSID:4F819708-0185-427E-BD26-83B047BDFD8D' CODEBASE='../addins/client/DHCCardInfoTest.CAB#version=1,0,0,2' VIEWASTEXT>"
	w "</object>",!
}

ClassMethod MagCardCLSID() As %String
{
	s myVer=##class(web.DHCOPConfig).GetVersion()
	if (+myVer=1){
		;合肥省力医院
		w "<OBJECT ID='ClsHFCard' WIDTH=0 HEIGHT=0 CLASSID='CLSID:0EFF1526-9C36-4C81-A49C-BBA35B7C854B' CODEBASE='../addins/client/DHCCardInfo.CAB#version=1,0,0,31' VIEWASTEXT>"
		w "</OBJECT>"
	}elseif(+myVer=0){
		;积水潭
		w "<OBJECT ID='ClsHFCard' WIDTH=0 HEIGHT=0 CLASSID='CLSID:1639C0C8-D16A-4069-AADC-CA1CC3E38108' CODEBASE='../addins/client/DHCCardInfo.CAB#version=1,0,0,4' VIEWASTEXT>"
		w "</OBJECT>",!
		
	}
}

}
