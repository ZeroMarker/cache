//DHCPEPrintCommon.js
//DHCPEPrintBarCommon.js
//DHCPEIAdmItemStatusAdms.PatItemPrint.js
//DHCPEIAdmItemStatusAdms.RequestPrint.js
//DHCPrtComm.js
//DHCWeb.OPCommon.js
//DHCWeb.OPOEData.js
/*复选框说明：
PrintSpecItem：检查条码  大项中设置上打印基本信息条码
PrintBarCode：化验条码
PrintItem：指引单
PrintPisRequest：病理申请单
PrintPersonInfo：基本信息条码  缴费条码
PrintRisRequest：检查申请单
*/


function PrintAllAppForHISUI(iTAdmId,IDType,NoAlert,AllItem,PrePrintType)
{
    //alert(iTAdmId+"^"+IDType+"^"+NoAlert)
    var LocID=session['LOGON.CTLOCID'];
    var AllItemFlag=0;
    if(AllItem=="Y") AllItemFlag=1;
    if (IDType=="PAADM"){
	    
        //类型为PA_Adm表的ID
        
    }else if (IDType=="CRM"){
	    
        //类型为DHC_PE_PreIADM表的ID
        var obj=document.getElementById('GetIADMIDBox');
        if (obj) {var encmeth=obj.value; } else {var encmeth=''; }
        if (encmeth==""){
            iTAdmId=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetIADMPAADMDR",iTAdmId);
        }else{
            iTAdmId=cspRunServerMethod(encmeth,iTAdmId);
        }
        
    }else if (IDType=="PADM"){
	    
        //类型为DHC_PE_IADM表的ID
        
    }else if (IDType=="Spec"){
	    
        iTAdmId=tkMakeServerCall("web.DHCPE.BarPrint","GetPAADMBySpec",iTAdmId);
    }
    
    
     var DefaultPrint=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",LocID,"DefPrintType");
    //var DefaultPrint=tkMakeServerCall("web.DHCPE.HISUICommon","GetDefaultPrintType");
    var DefaultPrintType=DefaultPrint.split("^");
    var BaseInfoFlag=DefaultPrintType[0];
    var PrintItemFlag=DefaultPrintType[1];
    var BarCodeFlag=DefaultPrintType[2];
    var SpecItemFlag=DefaultPrintType[3];
    
    
    if (BaseInfoFlag=="Y") PrintBaseInfoBar(iTAdmId); //基本信息条码
    
    
    var PrintFlag=0;
    if (PrintItemFlag=="Y") PrintFlag=1; //指引单
    if (BarCodeFlag=="Y") PrintFlag=1; //化验条码
    if (SpecItemFlag=="Y") PrintFlag=1; //检查条码
    
    if ( PrintFlag==0) return false;
    
    
    var AlertFlag=1;
    if (NoAlert=="N") AlertFlag="0";
    
    if (AlertFlag==1)
    {
        var encmeth="";
        var obj=document.getElementById("ExistExecItemClass");
        if (obj) encmeth=obj.value;
        if (encmeth==""){
            var ret=tkMakeServerCall("web.DHCPE.PreIADMEx","ExistExecItem",iTAdmId);
        }else{
            var ret=cspRunServerMethod(encmeth,iTAdmId);
        }
        
        var Arr=ret.split("^");
        ret=Arr[0];
        
        if (ret=="-1"){
	        
            $.messager.alert("提示","his中的信息和体检中的信息不一致，请修改信息","info");
            return false;
            
        }else if(ret=="1"){
	        
            if (!confirm("待打印人员存在已执行项目，是否继续打印")) return false;
            
        }else if(ret=="2"){
            
            $.messager.confirm("确认", "指引单已经打印过，是否继续打印？", function(r){
            	if(r){ 
    				PrintAllHISUICommon(iTAdmId,AllItemFlag,DefaultPrint,PrePrintType);
            
            		}
            });

        }else if(ret=="3"){
	        
            $.messager.confirm("确认", "指引单已经打印过并且存在已执行项目，是否继续打印", function(r){
            	if(r){
	            	PrintAllHISUICommon(iTAdmId,AllItemFlag,DefaultPrint,PrePrintType);
            	}
            });
            
        }else if(ret=="5"){
	        
            $.messager.alert("提示","体检日期为"+Arr[1]+"，不允许打印","info");
            return false;
        }else if(ret=="4"){
	        
            $.messager.confirm("确认","体检日期为"+Arr[1]+"，是否继续打印", function(r){
            	if(r){
	            	PrintAllHISUICommon(iTAdmId,AllItemFlag,DefaultPrint,PrePrintType);
                }
            });
            
        }else{
           
			PrintAllHISUICommon(iTAdmId,AllItemFlag,DefaultPrint,PrePrintType);
    }
    
}else{
	
	PrintAllHISUICommon(iTAdmId,AllItemFlag,DefaultPrint,PrePrintType);
	    
    }
}

function PrintAllHISUICommon(iTAdmId,AllItemFlag,DefaultPrint,PrePrintType)
{
	//alert(iTAdmId+"^"+AllItemFlag+"^"+DefaultPrint+"^"+PrePrintType)
	
	var DefaultPrintType=DefaultPrint.split("^");
    var BaseInfoFlag=DefaultPrintType[0]; 
    var PrintItemFlag=DefaultPrintType[1];
    var BarCodeFlag=DefaultPrintType[2];
    var SpecItemFlag=DefaultPrintType[3];
    
     var encmeth="";
	 var Info="";
     var obj=document.getElementById("GetSpecItemInfo");//超声
     if (obj) var encmeth=obj.value;
     if (encmeth==""){
     	var Info=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","GetPrintItem",iTAdmId,"");
     }else{
      	var Info=cspRunServerMethod(encmeth,iTAdmId,"");
     }
    if ((Info=="NoPayed")&&(PrePrintType!="PrePrint")){
         $.messager.alert("提示","存在未付费项目，不能打印","info");
        return false;
    }
    
    if (PrintItemFlag=="Y") PatItemPrint(iTAdmId,AllItemFlag);//指引单
    
    if (SpecItemFlag=="Y") SpecItemPrintLCT(iTAdmId,PrePrintType); //检查条码
    
    if (BarCodeFlag=="Y")  BarCodePrint(iTAdmId,"",PrePrintType); //检验条码
        
    
}
function PrintAllCommon(iTAdmId,AllItemFlag,BloodFlag)
{
	 var encmeth="";
	 var Info="";
     var obj=document.getElementById("GetSpecItemInfo");//超声
     if (obj) var encmeth=obj.value;
     if (encmeth==""){
     	var Info=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","GetPrintItem",iTAdmId,"");
      }else{
      	var Info=cspRunServerMethod(encmeth,iTAdmId,"");
       }
       
     if (Info=="NoPayed"){
     	$.messager.alert("提示","存在未付费项目，不能打印","info");
      	return false;
       }
      
     //检查条码
     var obj=document.getElementById('PrintSpecItem');  
     if (obj&&obj.checked)  SpecItemPrintLCT(iTAdmId);
    
     //检验条码 
     var obj=document.getElementById('PrintBarCode');
     if (obj&&obj.checked) BarCodePrint(iTAdmId,BloodFlag);    
 
      
     //指引单
     var obj=document.getElementById('PrintItem'); 
     if (obj&&obj.checked)  PatItemPrint(iTAdmId,AllItemFlag);
     
     //病理申请单
     var obj=document.getElementById('PrintPisRequest');  
     if (obj&&obj.checked)  PisRequestPrint(iTAdmId);
       
     //检查申请单         
     var obj=document.getElementById('PrintRisRequest');  
     if (obj&&obj.checked)  PrintRisRequest(iTAdmId,"");
}


//参数： iTAdmId (根据参数IDType变化)
//		 IDType（"PAADM","CRM","Spec","PADM")
//       NoAlert()
//       AllItem(Y:导诊单打印所有项目)
//       BloodFlag(2:血,1:非血,空:所有标本类型)

function PrintAllApp(iTAdmId,IDType,NoAlert,AllItem,BloodFlag)
{
	//alert(iTAdmId+"^"+IDType+"^"+NoAlert+"^"+AllItem+"^"+BloodFlag)
    var AllItemFlag=0;
    if(AllItem=="Y") AllItemFlag=1;
    
    if (IDType=="PAADM"){

        ////类型为PA_Adm表的ID

    }else if (IDType=="CRM"){

        ////类型为DHC_PE_PreIADM表的ID
        var obj=document.getElementById('GetIADMIDBox');
        if (obj) {var encmeth=obj.value; } else {var encmeth=''; }
        if (encmeth==""){
            iTAdmId=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetIADMPAADMDR",iTAdmId);
        }else{
            iTAdmId=cspRunServerMethod(encmeth,iTAdmId);
        }

    }else if (IDType=="PADM"){

        //类型为DHC_PE_IADM表的ID

    }else if (IDType=="Spec"){

		var OEOrdRowID=tkMakeServerCall("web.DHCPE.BarPrint","GetOEORDBySpecNo",iTAdmId);
        iTAdmId=tkMakeServerCall("web.DHCPE.BarPrint","GetPAADMBySpec",iTAdmId);
        iTAdmId=iTAdmId+"^"+OEOrdRowID;
    }
    
	 //基本信息条码
    obj=document.getElementById('PrintPersonInfo'); 
    if (obj&&obj.checked)  PrintBaseInfoBar(iTAdmId);
    
    var PrintFlag=0;
    var PrintItemFlag=0;

	 //检查条码病理
    obj=document.getElementById('PrintSpecItem'); 
    if (obj&&obj.checked) PrintFlag=1;

   //检验条码
    obj=document.getElementById('PrintBarCode'); 
    if (obj&&obj.checked) PrintFlag=1;
    
	//指引单
    obj=document.getElementById('PrintItem'); 
    if (obj&&obj.checked) {PrintFlag=1; PrintItemFlag=1;}

    //病理申请单
    obj=document.getElementById('PrintPisRequest'); 
    if (obj&&obj.checked) PrintFlag=1;

    //检查申请单
    obj=document.getElementById('PrintRisRequest');  
    if (obj&&obj.checked) PrintFlag=1;

    if ( PrintFlag==0) return false;

    var AlertFlag=1;
    if (NoAlert=="N") AlertFlag="0";

    if (AlertFlag==1){
        var encmeth="";
        var obj=document.getElementById("ExistExecItemClass");
        if (obj) encmeth=obj.value;
        if (encmeth==""){
            var ret=tkMakeServerCall("web.DHCPE.PreIADMEx","ExistExecItem",iTAdmId);
        }else{
            var ret=cspRunServerMethod(encmeth,iTAdmId);
        }
        var Arr=ret.split("^");
      
        ret=Arr[0];
        if (ret=="-1"){

            $.messager.alert("提示","his中的信息和体检中的信息不一致，请修改信息","info");
            return false;

        }else if(ret=="1"){
            
           $.messager.confirm("确认","待打印人员存在已执行项目，是否继续打印", function(r){
			if(r){
            	PrintAllCommon(iTAdmId,AllItemFlag,BloodFlag);
				}
            });
            
        }else if(ret=="2"){
			 $.messager.confirm("确认", "指引单已经打印过，是否继续打印？", function(r){
            	if(r){
                	PrintAllCommon(iTAdmId,AllItemFlag,BloodFlag);
           		 }else{
	           		var encmeth="";
	 				var Info="";
     				var obj=document.getElementById("GetSpecItemInfo");//超声
     				if (obj) var encmeth=obj.value;
     				if (encmeth==""){
     					var Info=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","GetPrintItem",iTAdmId,"");
      				}else{
      					var Info=cspRunServerMethod(encmeth,iTAdmId,"");
       				}
       
     				if (Info=="NoPayed"){
     					$.messager.alert("提示","存在未付费项目，不能打印","info");
      					return false;
       				}
      
     				//检查条码
     				var obj=document.getElementById('PrintSpecItem');  
     				if (obj&&obj.checked)  SpecItemPrintLCT(iTAdmId);
    
     				//检验条码 
     				var obj=document.getElementById('PrintBarCode');
     				if (obj&&obj.checked) BarCodePrint(iTAdmId,BloodFlag);    
 
   
     				//病理申请单
     				var obj=document.getElementById('PrintPisRequest');  
     				if (obj&&obj.checked)  PisRequestPrint(iTAdmId);
       
     				//检查申请单         
     				var obj=document.getElementById('PrintRisRequest');  
     				if (obj&&obj.checked)  PrintRisRequest(iTAdmId,"");
	            
	            
            	}
            });
          
        }else if(ret=="3"){
			$.messager.confirm("确认","指引单已经打印过并且存在已执行项目，是否继续打印", function(r){
            	if(r){
                	PrintAllCommon(iTAdmId,AllItemFlag,BloodFlag);
            	}
            });
           
        }else if(ret=="5"){
              
				$.messager.alert("提示","体检日期为"+Arr[1]+"，不允许打印","info");
                 return false;

        }else if(ret=="4"){
			 $.messager.confirm("确认","体检日期为"+Arr[1]+"，是否继续打印", function(r){
            	if(r){
                	PrintAllCommon(iTAdmId,AllItemFlag,BloodFlag);
            		}
            	});
        }else{
			PrintAllCommon(iTAdmId,AllItemFlag,BloodFlag);        
        }

    }else{

		PrintAllCommon(iTAdmId,AllItemFlag,BloodFlag);
           
    }
    
}

//检查条码
document.write("<script type='text/javascript' src='../scripts/dhcnewpro/dhcapp/printPathBarCode.js'></script>");
function SpecItemPrintLCT(iTAdmId,PrePrintType)
{
    var CRMId=iTAdmId;
    var iOEOriId="";
    //var iOEOriId=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","GetIfHadLCT",CRMId);
    //if(iOEOriId==""){return false;}
    var obj=document.getElementById("GetSpecItemInfo");
    var encmeth="";
    if (obj) var encmeth=obj.value;
    if (encmeth==""){
        var Info=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","GetPrintItem",CRMId,iOEOriId);
    }else{
        var Info=cspRunServerMethod(encmeth,CRMId,iOEOriId);
    }
    if ((Info=="NoPayed")&&(PrePrintType!="PrePrint")){
        
        $.messager.alert("提示","存在未付费项目，不能打印！");
        return false;
    }
    
    PrintBarRis(Info);  //DHCPEPrintBarCommon.JS
    
    var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSendPisFBWay");

    if(flag=="F"){
        var OrderItemId=tkMakeServerCall("web.DHCPE.PreIADM","GetPISOrdRowId",CRMId,"T");
        if(OrderItemId==""){return false;}
        //alert("OrderItemId:"+OrderItemId)
        if(OrderItemId.indexOf(";")>0){
            var ordid=OrderItemId.split(";")
            for(var i=0;i<ordid.length;i++){
                //alert("ordid:"+ordid[i])
                //PrintPisBarCode(ordid[i]);
                PrintBarCodeBL(ordid[i],"");
            }
        
        }else{
            //PrintPisBarCode(OrderItemId); 
            PrintBarCodeBL(OrderItemId,"");
        
            }
        }
    
    
}


//document.write("<script language='javascript' src='../scripts/nurse/DHCNUR/DHCNurPrintClickOnce.js'></script>");
//打印化验条码
function BarCodePrint(iTAdmId,OrderFlag,PrePrintType)
{

    var iTAdmIdArr=iTAdmId.split("^");
    var CRMId=iTAdmIdArr[0];
    var OEOrdID=iTAdmIdArr[1];
    var InString=CRMId+"^"+OEOrdID;
   /*
    var IsPrintBarNurseXML="N";
    var IsPrintBarNurseXML=tkMakeServerCall("web.DHCPE.BarPrint","GetPrintBarVersion")
    if(IsPrintBarNurseXML=="Y")

    {
        var Str=tkMakeServerCall("web.DHCPE.BarPrint","GetPatOrdItemInfoNew",InString,"Y","N",OrderFlag)
        if(Str=="NoPayed"){
            alert(t["NoPayed"]);
            return false;
            
        }
        var seqNoStr="";
        var Data=Str.split("&");
        var oeordStr=Data[0];
        var seqNoStr=Data[1];
        if(oeordStr==""){ return false;}
        if(seqNoStr==""){ return false;}
        
        var WebIP="",web="http://"
        var rtn=tkMakeServerCall("websys.Configuration","IsHTTPS")
        if(rtn=="1"){var web="https://"}
        else{var web="http://"}
        var WebIP=web+window.status.split("服务器IP:")[1]

        //alert("oeordStr:"+oeordStr+"seqNoStr:"+seqNoStr+"WebIP:"+WebIP)
        showNurseExcuteSheetPreview(oeordStr, seqNoStr, "P", "JYDO", WebIP, "true", 1, "NurseOrderOP.xml")
        //showNurseExcuteSheetPreview(oeordStr, seqNoStr, "P", "JYDO", session['WebIP'], "true", 1, "NurseOrderOP.xml")
        
    }
    else
    {
		 var CRMId=iTAdmId;
   	 	var InString=CRMId+"^";
    	var encmeth="";
    	var Ins=document.getElementById("PatOrdItemInfo");
    	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
    	if (encmeth==""){
        	var flag=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","PatOrdItemInfo","","",InString,"Y","N",OrderFlag);
    	}else{
        	var flag=cspRunServerMethod(encmeth,"","",InString,"Y","N",OrderFlag);
   	 	}
    	
    	BarPrint(flag);
	}
    */
    var CRMId=iTAdmId;
    var InString=CRMId+"^";
    var encmeth="";
    var Ins=document.getElementById("PatOrdItemInfo");
    if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
    if (encmeth==""){
        var flag=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","PatOrdItemInfo","","",InString,"Y","N",OrderFlag);
    }else{
        var flag=cspRunServerMethod(encmeth,"","",InString,"Y","N",OrderFlag);
    }
    BarPrint(flag,PrePrintType);
   
}

function BarPrint(value) {
    
    if (""==value) {
         $.messager.alert("提示","未找到检验项目","info");
         return false;
    }
    if ((value=="NoPayed")&&(PrePrintType!="PrePrint"))
    {
        $.messager.alert("提示","未付费,不能打印!","info");
        return false;
    }
    var ArrStr=value.split("$$");
    var Num=0;
    if (ArrStr.length>1){ Num=ArrStr[1];}
    value=ArrStr[0];
    PrintBarApp(value,"")  //DHCPEPrintBarCommon.js
    return false;
}

//打印超声条码
function SpecItemPrint(iIAdmId,BloodType)
{
    
    var obj=document.getElementById("GetSpecItemInfo");
    if (obj) var encmeth=obj.value;
    
    if (encmeth==""){
        var Info=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","GetPrintItem",iIAdmId,"",BloodType);
    }else{
        var Info=cspRunServerMethod(encmeth,iIAdmId,"",BloodType);
    }
    if (Info=="NoPayed"){
        
       $.messager.alert("提示","存在未付费项目，不能打印！");
        return false;
    }
    
    PrintBarRis(Info); //DHCPEPrintBarCommon.JS
}


// 打印导检单
document.write("<script language='javascript' src='../SCRIPTS/DHCPEPrintDJDCommon.js'></script>")
function PatItemPrint(iIAdmId,AllItemFlag) {
	/*
    var CRMId=iIAdmId;
    var PrintFlag=1;
    var PFlag=1;
	var NoPrintAmount="N";
    NoPrintAmount=getValueById("NoPrintAmount");
    if(NoPrintAmount==false){
        NoPrintAmount="N"
    }else{
    	NoPrintAmount="Y";
	}
    var Instring=CRMId+"^"+PrintFlag+"^PAADM"+"^"+AllItemFlag; 
	*/

   /* lodop 和 普通打印 导致程序走2遍
    var Ins=document.getElementById('GetOEOrdItemBox'); 
    if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
    if (encmeth==""){
        var value=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","GetPatOrdItemInfo",'','',Instring);
    }else{
        var value=cspRunServerMethod(encmeth,'','',Instring);
    }
    if (value=="NoPayed")
    {
         $.messager.alert("提示","存在未收费的项目","info");
        return false;
    }
    */
    //不打印金额
    var NoPrintAmount="N";
    var NoPrintAmount=$("#NoPrintAmount").checkbox('getValue');
    if(NoPrintAmount==false){
        NoPrintAmount="N"
    }else{
    	NoPrintAmount="Y";
	}
	
	//AllItemFlag：全部打印；NoPrintAmount:是否打印金额；
    var ExStrs=AllItemFlag+"^"+NoPrintAmount;
   
    PrintDJDByType(iIAdmId, "PAADM", "P", "",ExStrs);  // DHCPEPrintDJDCommon.js
    //PEPrintDJD("P",iIAdmId+"^"+NoPrintAmount+"^"+AllItemFlag,"");//DHCPEPrintDJDCommon.js  lodop打印
    //Print(value,PrintFlag,"N");  //DHCPEIAdmItemStatusAdms.PatItemPrint.js
    var PFlag=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","PatItemPrintFlag",iIAdmId);
}
//打印病理申单
//document.write("<script type='text/javascript' src='../scripts/dhcnewpro/dhcapp/pisprintcom.js'></script>");  //新产品组
document.write("<script type='text/javascript' src='../scripts/dhcdoc/dhcapp/pisprintcom.js'></script>");  //医生站
function PisRequestPrint(iIAdmId)
{
    //w ##class(web.DHCPE.DHCPECommon).GetSendPisInterface()
        
    var LocID=session['LOGON.CTLOCID'];
    var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSendPisInterface",LocID);
    var OrderItemId=tkMakeServerCall("web.DHCPE.PreIADM","GetPISOrdRowId",iIAdmId,"A");
    
    if(OrderItemId!=""){
        if(OrderItemId.indexOf(";")>0){
        
            var ordid=OrderItemId.split(";")
            for(var i=0;i<ordid.length;i++){
                if(flag=="1"){
                //alert(ordid[i])
               //PrintPis_OE(ordid[i]);
			    var PisID=tkMakeServerCall("web.DHCPE.RisRequestPrint","GetPisAppID",ordid[i]);
                PrintPis_REQ(PisID)
                }else{
                BatchPrint(ordid[i]);
                }
                }
        
        }else{
            if(flag=="1"){
                //alert(OrderItemId)
               // PrintPis_OE(OrderItemId);
			   var PisID=tkMakeServerCall("web.DHCPE.RisRequestPrint","GetPisAppID",OrderItemId);
                PrintPis_REQ(PisID)
            }else{
            BatchPrint(OrderItemId);
            }
        
        }
    }

    
    //PrintByTemplate(iIAdmId); //DHCPEIAdmItemStatusAdms.RequestPrint.js 
}


/*
function PisRequestPrint(iIAdmId)
{
    PrintByTemplate(iIAdmId);   //DHCPEIAdmItemStatusAdms.RequestPrint.js   
}*/

//打印基本信息条码
/*
function PrintBaseInfoBar(iIAdmId)
{
    //var Info=RegNo+"^"+Name+"  "+FactAmount+"^"+"^"+"^"+"^"+Sex+String.fromCharCode(1)+"^"+Age+"^"+RegNo+"^"+NewHPNo;
    var Ins=document.getElementById('GetBaseInfo'); 
    if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
    if (encmeth==""){
        var Info=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","GetBaseInfo",iIAdmId);
    }else{
        var Info=cspRunServerMethod(encmeth,iIAdmId);
    }

    PrintBarRis(Info); //DHCPEPrintBarCommon.JS
}
*/

function PrintBaseInfoBar(iIAdmId)
{
   var Info=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","GetBaseInfoNew",iIAdmId);
   PrintBaseBar(Info); //DHCPEPrintBarCommon.js
}

//检查申请单
function PrintRisRequest(iIAdmId,crmOrder)
{
    PrintRisRequestApp(iIAdmId,crmOrder,"PAADM"); //DHCPEIAdmItemStatusAdms.PatItemPrint.js
}
