Class web.DHCBillPrint Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 90;

ClassMethod AccPWDCLSID() As %String
{
	;加入密码验证类
	s myVer=##class(web.DHCOPConfig).GetVersion()
	
	if (+myVer=0){
		d ##class(web.DHCBillPrint0).AccPWDCLSID()
	}elseif(+myVer=1){
		d ##class(web.DHCBillPrint1).AccPWDCLSID()
	}elseif(+myVer=3){
		///大同
		d ##class(web.DHCBillPrint3).AccPWDCLSID()
	}else{
		s myClsName="web.DHCBillPrint"_myVer
		s myflag=##class(websys.Conversions).IsValidMethodName(myClsName,"AccPWDCLSID")
		if (myflag)
		{
			d $ZOBJCLASSMETHOD(myClsName, "AccPWDCLSID")
		}		
	}
}

/// //, websys.Abstract
ClassMethod InvBillPrintCLSID() As %String
{

	//w "<object ID='ClsBillPrint' WIDTH=0 HEIGHT=0 CLASSID='CLSID:F30DC1D4-5E29-4B89-902F-2E3DC81AE46D' CODEBASE='../addins/client/DHCOPPrint.CAB#version=1,0,0,43' VIEWASTEXT>"
	//w "</object>",!
	
	;支持二维码
	;w "<object ID='ClsBillPrint' WIDTH=0 HEIGHT=0 CLASSID='CLSID:F30DC1D4-5E29-4B89-902F-2E3DC81AE46D' CODEBASE='../addins/client/DHCOPPrint.CAB#version=1,0,0,61' VIEWASTEXT style=""display:none;height:0px;width:0px;"">"
	;w "</object>",!
	w "<object ID='ClsBillPrint' WIDTH=0 HEIGHT=0 CLASSID='CLSID:F30DC1D4-5E29-4B89-902F-2E3DC81AE46D' CODEBASE='../addins/client/DHCOPPrint.CAB#version=1,0,0,64' VIEWASTEXT style=""display:none;height:0px;width:0px;"">"
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
	;d ##class(web.DHCBillPrint).MagCardCLSID()
	s myVer=##class(web.DHCOPConfig).GetVersion()
	if (+myVer=0){
		d ##class(web.DHCBillPrint0).MagCardCLSID()
	}elseif(+myVer=1){
		d ##class(web.DHCBillPrint1).MagCardCLSID()
	}elseif(+myVer=3){
		d ##class(web.DHCBillPrint3).MagCardCLSID()
	}elseif(+myVer=10){
		;厦门医院
		d ##class(web.DHCBillPrint10).MagCardCLSID()
	}else{
		s myClsName="web.DHCBillPrint"_myVer
		s myflag=##class(websys.Conversions).IsValidMethodName(myClsName,"MagCardCLSID")
		if (myflag)
		{
			d $ZOBJCLASSMETHOD(myClsName, "MagCardCLSID")
		}
	}
}

}
