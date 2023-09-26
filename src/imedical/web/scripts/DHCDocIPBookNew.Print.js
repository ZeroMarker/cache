
/////DHCDocIPBookNew.Print.js
////住院证打印接口

/*  csp需建立以下隐藏元素
	d ##Class(web.DHCBillPrint).InvBillPrintCLSID()
	w "<input TYPE=""HIDDEN"" id=""InvPrintEncrypt"" NAME=""InvPrintEncrypt"" VALUE="""_##Class(%CSP.Page).Encrypt($lb("web.DHCXMLIO.ReadXML"))_""">"_"</input>",!
	w "<input TYPE=""HIDDEN"" id=""GetZYZStrMethod"" NAME=""GetZYZStrMethod"" VALUE="""_""_""">"_"</input>",!

	csp需引用以下js文件
	<script type="text/javascript" src="/csp/broker/cspbroker.js"></script>
	<script type="text/javascript" src="/csp/broker/cspxmlhttp.js"></script>
	<script type="text/javascript" src="../scripts/websys.js"></SCRIPT>
	<script type="text/javascript" src="../scripts/DHCPrtComm.js"></script>
	<script type="text/javascript" src="../scripts/DHCDocIPBookNew.Print.js"></script>
	<script type="text/javascript" src="../scripts/DHCWeb.OPCommon.js"></script>
*/

function ZYZ_Print(EpisodeID){
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCDocIPBookPrt");
	var MyPara='';
	var PDlime=String.fromCharCode(2);
	/*实现GetZYZStrMethod后放开
	if (GetZYZStrMethod=="") return;
	var str=cspRunServerMethod(GetZYZStrMethod,EpisodeID);
	*/
	var PatientName="";
	var Sex="";
	var Age="";
	var PatRegNo="";
	var PatientNo="";
	var Company="";
	var NowAddress="";
	var Telephone="";
	var PatContact="";
	var PatRelation="";
	var PatReTel="";
	var MRDiagnos="";
	var PatInDep="";
	var PatInDays="";
	var PatFirHos="";
	var PatUserCode="";
	var PatDate="";
	
	MyPara=MyPara+"PatName"+PDlime+PatientName+"^"+"PatSex"+PDlime+Sex+"^"+"PatAge"+PDlime+Age;
	MyPara=MyPara+"^"+"PatRegNo"+PDlime+PatientNo+"^"+"PatStat"+PDlime+'预约';
	MyPara=MyPara+"^"+"PatCom"+PDlime+Company+"^"+"PatAdd"+PDlime+NowAddress+"^"+"PatTel"+PDlime+Telephone;
	MyPara=MyPara+"^"+"PatContact"+PDlime+PatContact+"^"+"PatRelation"+PDlime+PatRelation;
	MyPara=MyPara+"^"+"PatReTel"+PDlime+PatReTel+"^"+"PatMR"+PDlime+MRDiagnos;
	MyPara=MyPara+"^"+"PatInDep"+PDlime+PatInDep+"^"+"PatInDays"+PDlime+PatInDays;
	MyPara=MyPara+"^"+"PatFirHos"+PDlime+PatFirHos+"^"+"PatUserCode"+PDlime+PatUserCode;
	MyPara=MyPara+"^"+"PatDocSign"+PDlime+"________"+"^"+"PatDate"+PDlime+PatDate;
	var myobj=document.getElementById("ClsBillPrint");
	PrintFun(myobj,MyPara,"");

}

function PrintFun(PObj,inpara,inlist){
	////DHCPrtComm.js
	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
		var docobj=new ActiveXObject("MSXML2.DOMDocument.4.0");
		docobj.async = false;    //close
		var rtn=docobj.loadXML(mystr);
		if ((rtn)){
			
			////ToPrintDoc(ByVal inputdata As String, ByVal ListData As String, InDoc As MSXML2.DOMDocument40)			
			var rtn=PObj.ToPrintDocNew(inpara,inlist,docobj);
			////var rtn=PObj.ToPrintDoc(myinstr,myList,docobj);
		}
	}catch(e){
		alert(e.message);
		return;
	}
}