///zhouxin 2016-08-25

PrtAryData=new Array()


function DHCP_GetXMLConfig(encName,PFlag){
	////
	/////InvPrintEncrypt
	try{		
		PrtAryData.length=0

		$.ajax({
		  async:false,
		  dataType:'script',	 
          url : "websys.Broker.cls", 
          data : {ClassName:"web.DHCXMLIO",
          		  MethodName:"ReadXML",
          		  JSFunName:'DHCP_RecConStr',
          		  CFlag:PFlag}
    	}); 
		for (var i= 0; i<PrtAryData.length;i++){
			PrtAryData[i]=DHCP_TextEncoder(PrtAryData[i]) ;
		}
	}catch(e){
		alert(e.message);
		return;
	}
}

function DHCP_PrintFun(PObj,inpara,inlist){
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

		if ((rtn)){
			////ToPrintDoc(ByVal inputdata As String, ByVal ListData As String, InDoc As MSXML2.DOMDocument40)
			var rtn=PObj.ToPrintDoc(inpara,inlist,docobj);
		
			////var rtn=PObj.ToPrintDoc(myinstr,myList,docobj);
		}
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
function DHCP_RecConStr(ConStr){
	///var myIdx=PrtAryData.length
	PrtAryData[PrtAryData.length]=ConStr;
	
}


///腕带打印
function newProPrtWd(EmPCLvID,EpisodeID,LgHospID){
	var className="",methodName="",objParam={};
	if(EmPCLvID!="") {
		className ="web.DHCEMPatCheckLevQuery";
		methodName = "GetEmPatWDPrintData";
		objParam = {"EmPCLvID":EmPCLvID,HospDr:LgHospID};
	}
	if(EpisodeID!="") {
		className ="web.DHCEMPatCheckLevQuery";
		methodName = "GetEmPatWDPrintDataById";
		objParam = {"EpisodeID":EpisodeID,HospDr:LgHospID};
	}
	 
	var PrintData=serverCall(className,methodName,objParam);
	
	if(PrintData==""){
		$.messager.alert("提示","数据获取异常！");
		return;
	}
	var CH2 = String.fromCharCode(2);
	var str = "RegNo" + CH2 + PrintData.split("^")[0]+ "^" + "Name" + CH2 + PrintData.split("^")[1];
	str = str + "^" + "Sex" + CH2 + PrintData.split("^")[2] + "^" + "Age" + CH2 + PrintData.split("^")[3];
	str = str + "^" + "BirthDate" + CH2 + PrintData.split("^")[4] + "^" + "AdmDate" + CH2 + PrintData.split("^")[5];
	str = str + "^" + "HospitalName" + CH2 + PrintData.split("^")[6];
	str = str+ "^" + "RegNoBarCode" + CH2 + PrintData.split("^")[0];
	str = str+ "^" + "AdmDep" + CH2 + PrintData.split("^")[7];   //添加科室 add by 
	
	
	DHCP_GetXMLConfig("InvPrintEncrypt","PrtWCinctureo"); 
	if (typeof getLodop ==="function") {
		var LODOP = getLodop();
    	LODOP.PRINT_INIT("CST PRINT");
		DHC_CreateByXML(LODOP,str,"",[],"PRINT-CST-NT");  //MyPara 为xml打印要求的格式
    	var printRet = LODOP.PRINT();
	}else{
		var myobj=document.getElementById("ClsBillPrint");
		DHCP_PrintFunHDLP(myobj,str,"");
	}
	return;

}