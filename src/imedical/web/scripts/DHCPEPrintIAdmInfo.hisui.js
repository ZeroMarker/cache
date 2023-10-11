//名称	DHCPEPrintIAdmInfo.hisui.js
//功能	条码打印
//创建	2018.09.06
//创建人  xy
//document.write("<script type='text/javascript' src='../scripts/DHCPEPrintBarCommon.js'></script>");
//document.write("<script language='javascript' src='../scripts/nurse/DHCNUR/DHCNurPrintClickOnce.js'></script>");
//document.write("<script type='text/javascript' src='../scripts/dhcnewpro/dhcapp/printPathBarCode.js'></script>");

$(function(){
	
	InitPrintIAdmInfoDataGrid();
	
	
	$("#PrintAllBarCode").click(function() {
		PrintAllBarCode();
    });
	
})

function InitPrintIAdmInfoDataGrid(){
	$HUI.datagrid("#dhcpeprintiadmlist",{
		url:$URL,
		fit : true,
		border : false,
		striped : false,
		fitColumns : false,
		autoRowHeight : true,
		rownumbers:true,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: false,
		checkOnSelect: true, //如果为false, 当用户仅在点击该复选框的时候才会被选中或取消
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.PrintIAdmInfo",
			QueryName:"SearchPrintIAdmInfo", 
			PAADM:IAdmId
		},columns:[[
			{field:'STation',width:'90',title:'站点'},
			{field:'LabSpecNo',width:'160',title:'标本号'},
			{field:'ARCIMDesc',width:'260',title:'医嘱名称'},
			{field:'IsPrint',width:'200',title:'是否已打印',align:'center',
				formatter:function(value,rowData,rowIndex){
					var rvalue="",checked="";
					if(value!=""){
	   					if (value=="Y") {checked="checked=checked"}
						else{checked=""}
						var rvalue=rvalue+"<input type='checkbox'  disabled='true' "+checked+">"	
						return rvalue;
					}
				
				}},
			{field:'Str',title:'打印',width:'60',
				formatter:function(value,row,index){
				if(value!=""){
					return "<span style='cursor:pointer;' class='icon-print' title='打印条码' onclick='PrintBarCodeTJ(\""+value+"\")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
				}
				}}
		]]
		
		
	
	})
}

/*
function PrintAllBarCode()
{
	var Rows=$('#dhcpeprintiadmlist').datagrid('getRows');
	 if(Rows.length=="0"){
		 $.messager.alert("提示","没有待打印的数据","info");
		 return false;
	 } 

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

       BarCodePrintHISUI(iTAdmId,"");
    
       SpecItemPrintLCT(iTAdmId);
	
   return false;
    
}
*/
function PrintAllBarCode()
{
	 var Rows=$('#dhcpeprintiadmlist').datagrid('getRows');
	 if(Rows.length=="0"){
		 $.messager.alert("提示","没有待打印的数据","info");
		 return false;
	 } 

	 var iTAdmId=IAdmId;
	 var IADM=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetIAdmIdByPaadm",iTAdmId);
	 if(IADM==""){
		   	   return false;   
	   }
	 var flag=tkMakeServerCall("web.DHCPE.DHCPEIAdm","HaveNoPayedItem",IADM);
	  
      if (flag=="1"){
			$.messager.alert("提示","存在未付费项目，不能打印！","info");
			return false;
		}else{

       		BarCodePrintHISUI(iTAdmId,"");
    
       		SpecItemPrintLCT(iTAdmId);
		}
	
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
			$.messager.alert("提示","存在未付费项目，不能打印！","info");
		    return false;
			
		}
		var seqNoStr="";
        var Data=Str.split("&");
        var oeordStr=Data[0];
        var seqNoStr=Data[1];
		if(oeordStr==""){ return false;}
		if(seqNoStr==""){ return false;}
		/*
		var WebIP=""
		var WebIP=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"getSet"

		}, false);
		*/
		var WebIP="",web="http://"
		var rtn=$.m({
			"ClassName":"websys.Configuration",
			"MethodName":"IsHTTPS"

		}, false);
		
		if(rtn=="1"){var web="https://"}
		else{var web="http://"}
		var WebIP=web+window.status.split("服务器IP:")[1]

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
		$.messager.alert("提示","存在未付费项目，不能打印！","info");
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
	//alert(ID)
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
	}else{	
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
		$.messager.alert("提示","未付费项目","info");
		return false;
	}
	
	var IsRISFlag=$.m({
			"ClassName":"web.DHCPE.CRM.RisGateway",
			"MethodName":"IsRISOrdItem",
			"ID":OEORI
		}, false);	
		
		
	if( IsRISFlag=="1"){PrintBarRis(Info);}
	if((IsPISFlag=="0")&&(IsRISFlag=="0")) {PrintBarRis(Info);}
	var IsPISFlag=$.m({
			"ClassName":"web.DHCPE.CRM.RisGateway",
			"MethodName":"IsPISOrdItem",
			"ID":OEORI
		}, false);	
		
	var flag=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"GetSendPisFBWay"
		}, false);	
	
	 //alert(flag+"^"+IsPISFlag+"^"+OEORI)
	var PISAPPID=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"GetPISAPPIDByOeordID",
			"Oeori":OEORI
		}, false);

	if((flag=="F")&&(IsPISFlag=="1")){
		if(PISAPPID==""){
			$.messager.alert("提示","病理申请未发送","info");
			return false;
		}else{
			PrintBarCodeBL(OEORI,"")
			//PrintPisBarCode(OEORI); //新产品

		} 
}

	if((flag=="B")&&(IsPISFlag=="1")){PrintBarRis(Info); }

	$("#dhcpeprintiadmlist").datagrid('load',{
			ClassName:"web.DHCPE.PrintIAdmInfo",
			QueryName:"SearchPrintIAdmInfo",
			PAADM:IAdmId
	});	
	
	//window.location.reload();
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
		$.messager.alert("提示","请选择一个标本号","info");
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
	
		$.messager.confirm("确认", "该条码已被接收，是否再次打印？", function(r){
			
		if (r){
			
			
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
			$.messager.alert("提示","存在未付费项目，不能打印！","info");
		    return false;
			
		}
		var seqNoStr="";
        var Data=Str.split("&");
        var oeordStr=Data[0];
        var seqNoStr=Data[1];
        
		if(oeordStr==""){ return false;}
		if(seqNoStr==""){ return false;}
	
		var WebIP="",web="http://"
		var rtn=$.m({
			"ClassName":"websys.Configuration",
			"MethodName":"IsHTTPS"

		}, false);
		
		if(rtn=="1"){var web="https://"}
		else{var web="http://"}
		var WebIP=web+window.status.split("服务器IP:")[1]

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
		$.messager.alert("提示","存在未付费项目，不能打印！","info");
		return false;
	}
    
	PrintBarApp(value,SpecNo)
	}
	$("#dhcpeprintiadmlist").datagrid('load',{
			ClassName:"web.DHCPE.PrintIAdmInfo",
			QueryName:"SearchPrintIAdmInfo",
			PAADM:IAdmId
	});	
	//window.location.reload();
	return;
	
		}
	});
	}else{
	
	
			
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
			$.messager.alert("提示","未付费项目","info");
		    return false;
			
		}
		var seqNoStr="";
        var Data=Str.split("&");
        var oeordStr=Data[0];
        var seqNoStr=Data[1];
        
		if(oeordStr==""){ return false;}
		if(seqNoStr==""){ return false;}
	
		var WebIP="",web="http://"
		var rtn=$.m({
			"ClassName":"websys.Configuration",
			"MethodName":"IsHTTPS"

		}, false);
		
		if(rtn=="1"){var web="https://"}
		else{var web="http://"}
		var WebIP=web+window.status.split("服务器IP:")[1]

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
		$.messager.alert("提示","存在未付费项目，不能打印！","info");
		return false;
	}
    
	PrintBarApp(value,SpecNo)
	}
	$("#dhcpeprintiadmlist").datagrid('load',{
			ClassName:"web.DHCPE.PrintIAdmInfo",
			QueryName:"SearchPrintIAdmInfo",
			PAADM:IAdmId
	});	
	
	return;
	
		}	

}
