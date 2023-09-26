// /名称: 库存管理打印公共方法
// /描述: 库存管理打印公共方法
// /编写者：zhangdongmei
// /编写日期: 2012.11.13


PrtAryData=new Array()

function DHCP_PrintFun(inpara,inlist){
	////myframe=parent.frames["DHCOPOEOrdInput"];
	////DHCPrtComm.js

	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
			
		var docobj=new ActiveXObject("MSXML2.DOMDocument.4.0");
		
		docobj.async = false;    //
		var rtn=docobj.loadXML(mystr);
		//var objRefer=GetPrintObj();
		//document.write(objRefer);		//不再write, 放置在csp或LoadCommonJsM内
		if ((rtn)){
			////ToPrintDoc(ByVal inputdata As String, ByVal ListData As String, InDoc As MSXML2.DOMDocument40)
			var myObj=document.getElementById("ClsBillPrint");
			var rtn=myObj.ToPrintDocNew(inpara,inlist,docobj);		
			////var rtn=PObj.ToPrintDoc(myinstr,myList,docobj);
		}
	}catch(e){
		alert(e.message);
		return;
	}

}

function DHCP_PrintFunNew(inpara,inlist){
	////myframe=parent.frames["DHCOPOEOrdInput"];
	////DHCPrtComm.js
	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
				
		var docobj=new ActiveXObject("MSXML2.DOMDocument.4.0");
		docobj.async = false;    //
		var rtn=docobj.loadXML(mystr);		
		var objRefer=GetPrintObj();
		
		if ((rtn)){
			////ToPrintDoc(ByVal inputdata As String, ByVal ListData As String, InDoc As MSXML2.DOMDocument40)
			var myObj=document.getElementById("ClsBillPrint");
			var rtn=myObj.ToPrintDocNew(inpara,inlist,docobj);
			
			////var rtn=PObj.ToPrintDoc(myinstr,myList,docobj);
		}
	}catch(e){
		alert(e.message);
		return;
	}

}


function DHCP_GetXMLConfig(PFlag){
	try{		
		PrtAryData.length=0
		var response=tkMakeServerCall('web.DHCSTMHUI.Common.XMLCOMMON', 'ReadXML',PFlag);
		PrtAryData[PrtAryData.length]=response;
		
		for (var i= 0; i<PrtAryData.length;i++){
			PrtAryData[i]=DHCP_TextEncoder(PrtAryData[i]) ;
		}
	}catch(e){
		alert(e.message);
		return;
	}
}

function GetPrintObj(){
	////
	/////InvPrintEncrypt
	try{		
		//var url='dhcstm.xmlcommon.csp?actiontype=ClsBillPrint';
		var response=tkMakeServerCall('web.DHCBillPrint', 'InvBillPrintCLSID', '');
		//var response=ExecuteDBSynAccess(url);
		//return ;
		return response;
	}catch(e){
		alert(e.message);
		return;
	}
}


function DHCP_TextEncoder(transtr){
	if (transtr.length==0){
		return "";
	}
	var dst=transtr;
	try{
		dst = DHCWeb_replaceAll(dst, '\\"', '\"');
		dst = DHCWeb_replaceAll(dst, "\\r\\n", "\r\t");
		dst = DHCWeb_replaceAll(dst, "\\r", "\r");
		dst = DHCWeb_replaceAll(dst, "\\n", "\n");
		dst = DHCWeb_replaceAll(dst, "\\t", "\t");
	}catch(e){
		alert(e.message);
		return "";
	}
	return dst;
}

function DHCWeb_replaceAll(src,fnd,rep) 
{ 
	//rep:replace
	//src:source
	//fnd:find
	if (src.length==0) 
	{ 
		return ""; 
	} 
	try{
		var myary=src.split(fnd);
		var dst=myary.join(rep);
	}catch(e){
		alert(e.message);
		return ""
	}
	return dst; 
} 

