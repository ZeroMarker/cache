//名称	DHCPEPrintIAdmInfo.hisui.js
//功能	条码打印
//创建	2018.09.06
//创建人  xy
//document.write("<script type='text/javascript' src='../scripts/DHCPEPrintBarCommon.js'></script>");
//document.write("<script language='javascript' src='../scripts/nurse/DHCNUR/DHCNurPrintClickOnce.js'></script>");
//document.write("<script type='text/javascript' src='../scripts/dhcnewpro/dhcapp/printPathBarCode.js'></script>");
$(function(){
	
	InitPrintIAdmInfoDataGrid();
	
	
})
function InitPrintIAdmInfoDataGrid(){
	
	$HUI.datagrid("#dhcpeprintiadmlist",{
		url:$URL,
		nowrap:false,
		queryParams:{
			ClassName:"web.DHCPE.PrintIAdmInfo",
			QueryName:"SearchPrintIAdmInfo", 
			PAADM:IAdmId
		},
		toolbar:[{
		id:"PrintAllBarCode",
		text: '全部打印',
		iconCls: 'icon-print',
		handler: function(){PrintAllBarCode();}
	}],
		columns:[[
			{field:'STation',width:'90',title:'科室'},
			{field:'LabSpecNo',width:'160',title:'标本号'},
			{field:'ARCIMDesc',width:'160',title:'项目'},
			{field:'OrdName',width:'180',title:'检查项目'},
			{field:'Str',title:'操作',width:'40',
			formatter:function(value,row,index){
				if(value!=""){	
					return "<a href='#' onclick='PrintBarCodeTJ(\""+value+"\")'>\
					<img src='../scripts_lib/hisui-0.1.0/dist/css/icons/print.png' border=0/>\
					</a>";
				}
				}}
		]]
		
		
	
	})
}


function PrintAllBarCode()
{
	
	   var iTAdmId=IAdmId;
	    var IADM=$.m({
			"ClassName":"web.DHCPE.DHCPEIAdm",
			"MethodName":"GetIAdmIdByPaadm",
			"paadm":iTAdmId

		}, false);
		
	  
	    var flag=$.m({
			"ClassName":"web.DHCPE.DHCPEIAdm",
			"MethodName":"HaveNoPayedItem",
			"paadm":IADM

		}, false);
		
       if (flag=="1"){
		$.messager.alert("提示","存在没有付费项目，不能打印");
		return false;
	}

       BarCodePrintHISUI(iTAdmId,"1");
    
       SpecItemPrintLCT(iTAdmId);
	
   //window.location.reload();
   return false;
    
}

//打印化验条码
function BarCodePrintHISUI(iTAdmId,OrderFlag)
{
	
	var CRMId=iTAdmId;
	var InString=CRMId+"^";
	
	var IsPrintBarNurseXML="N";
	
	 var IsPrintBarNurseXML=$.m({
			"ClassName":"web.DHCPE.BarPrint",
			"MethodName":"GetPrintBarVersion"

		}, false);
	
	if(IsPrintBarNurseXML=="Y")

	{
		var Str=$.m({
			"ClassName":"web.DHCPE.BarPrint",
			"MethodName":"GetPatOrdItemInfoNew",
			"InString":InString,
			"AllowUnPayed":"Y",
			"BDFlag":"N",
			"OrderFlag":OrderFlag
            
		}, false);
		
		//var Str=tkMakeServerCall("web.DHCPE.BarPrint","GetPatOrdItemInfoNew",InString,"Y","N",OrderFlag)
		if(Str=="NoPayed"){
			$.messager.alert("提示","未付费项目");
		    return false;
			
		}
		var seqNoStr="";
        var Data=Str.split("&");
        var oeordStr=Data[0];
        var seqNoStr=Data[1];
		if(oeordStr==""){ return false;}
		if(seqNoStr==""){ return false;}
		var WebIP=""
		var WebIP=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"getSet"

		}, false);
		
	    //alert("oeordStr:"+oeordStr+"seqNoStr:"+seqNoStr+"WebIP:"+WebIP)
		showNurseExcuteSheetPreview(oeordStr, seqNoStr, "P", "JYDO", WebIP, "true", 1, "NurseOrderOP.xml")
	
	}
	else
	{
	
	var CRMId=iTAdmId;
	var InString=CRMId+"^";
	var flag=$.m({
			"ClassName":"web.DHCPE.Query.IAdmItemStatus",
			"MethodName":"PatOrdItemInfo",
			"InString":InString,
			"AllowUnPayed":"Y",
			"BDFlag":"N",
			"OrderFlag":OrderFlag

		}, false);
	
	BarPrintHISUI(flag);
	}
}

function BarPrintHISUI(value) {
    
   // alert(value)
    if (""==value) {
		//alert("未找到检验项目");
		return false;
	}
	if (value=="NoPayed")
	{
		$.messager.alert("提示","未付费项目");
		return false;
	}
	var ArrStr=value.split("$$");
	var Num=0;
	if (ArrStr.length>1){ Num=ArrStr[1];}
	value=ArrStr[0];
	PrintBarApp(value,"")  //DHCPEPrintBarCommon.js
	return false;
}


function PrintBarCodeTJ(ID)
{
	
	var Str=ID.split("^")
	if (Str[2]=="Lis"){
		PrintOneLisBarCode(Str[0],Str[3],Str[1])
	}
	else if(Str[2]=="Ris"){
		PrintOneRisBarCode(Str[0],Str[1])
	}
	else if(Str[2]=="EKG"){
		PrintOneRisBarCode(Str[0],Str[1])
	}
	else if(Str[2]=="FK"){	
		PrintOneRisBarCode(Str[0],Str[1])
	}
	else if(Str[2]=="YK"){	
		PrintOneRisBarCode(Str[0],Str[1])
	}
	return false;
	
}


//检查条码

function PrintOneRisBarCode(IAdmId,OEORI)
{
	//alert(IAdmId+"^"+OEORI)
	if (IAdmId=="") return;
	if (OEORI=="") return;
	
	var Info=$.m({
			"ClassName":"web.DHCPE.Query.IAdmItemStatus",
			"MethodName":"GetPrintItem",
			"PAADM":IAdmId, 
			"OEORDID":OEORI

		}, false);

	if (Info=="NoPayed"){
		$.messager.alert("提示","未付费项目");
		return false;
	}
	
	var IsRISFlag=$.m({
			"ClassName":"web.DHCPE.CRM.RisGateway",
			"MethodName":"IsRISOrdItem",
			"ID":OEORI
		}, false);	
		
		
	if( IsRISFlag=="1"){PrintBarRis(Info);}
	
	var IsPISFlag=$.m({
			"ClassName":"web.DHCPE.CRM.RisGateway",
			"MethodName":"IsPISOrdItem",
			"ID":OEORI
		}, false);	
		
	var flag=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"GetPrintPISTiaoma"
		}, false);	
	
	 alert(flag+"^"+IsPISFlag+"^"+OEORI)
	
	if((flag=="1")&&(IsPISFlag=="1")){PrintPisBarCode(OEORI); }
	if((flag=="0")&&(IsPISFlag=="1")){PrintBarRis(Info); }

	window.location.reload();
	return;

		
}
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];

}


function PrintOneLisBarCode(IAdmId,SpecNo,OeOroId)
{
	if (SpecNo=="") {
		$.messager.alert("提示","请选择一个标本号");
		return;
		}
	//alert(IAdmId+"^"+OeOroId)
	if (IAdmId=="") return;
	var Status=$.m({
			"ClassName":"web.DHCPE.BarPrint",
			"MethodName":"GetOEOrdItemStat",
			"Type":"Lis",
			"OEOriId":OeOroId

		}, false);
	var Status=trim(Status)
	if(Status=="6")
	{
		$.messager.confirm("确认", "该条码已被接受，是否再次打印？", function(r){if (!r) { return false; }});
	
		}
	
	
	var IsPrintBarNurseXML="N";
	var IsPrintBarNurseXML=$.m({
			"ClassName":"web.DHCPE.BarPrint",
			"MethodName":"GetPrintBarVersion"

		}, false);
	
	if(IsPrintBarNurseXML=="Y")
	{
		var Str=$.m({
			"ClassName":"web.DHCPE.BarPrint",
			"MethodName":"GetPatOrdItemInfoNew",
			"InString":IAdmId+"^"+OeOroId+"^"+SpecNo

		}, false);
		
		if(Str=="NoPayed"){
			$.messager.alert("提示","未付费项目");
		    return false;
			
		}
		var seqNoStr="";
        var Data=Str.split("&");
        var oeordStr=Data[0];
        var seqNoStr=Data[1];
        
		if(oeordStr==""){ return false;}
		if(seqNoStr==""){ return false;}
		var WebIP=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"getSet"

		}, false);
		
		//var WebIP="http://"+window.status.split("服务器IP:")[1];
	    //alert("oeordStr:"+oeordStr+"seqNoStr:"+seqNoStr+"WebIP:"+ WebIP);
		showNurseExcuteSheetPreview(oeordStr, seqNoStr, "P", "JYDO", WebIP, "true", 1, "NurseOrderOP.xml")
	}
	else{
	var InString=IAdmId+"^"+OeOroId+"^"
	
	var value=$.m({
			"ClassName":"web.DHCPE.Query.IAdmItemStatus",
			"MethodName":"PatOrdItemInfo",
			"InString":InString

		}, false);
	
	if (value=="NoPayed")
	{
		$.messager.alert("提示","未付费项目");
		return false;
	}

	PrintBarApp(value,SpecNo)
	}
	window.location.reload();
	return;
}
