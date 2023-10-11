//DHCPEPrintCommon.js
//DHCPEPrintBarCommon.js
//DHCPEIAdmItemStatusAdms.PatItemPrint.js
//DHCPEIAdmItemStatusAdms.RequestPrint.js
//DHCPrtComm.js
//DHCWeb.OPCommon.js
//DHCWeb.OPOEData.js
/*��ѡ��˵����
PrintSpecItem���������  �����������ϴ�ӡ������Ϣ����
PrintBarCode����������
PrintItem��ָ����
PrintPisRequest���������뵥
PrintPersonInfo��������Ϣ����  �ɷ�����
PrintRisRequest��������뵥
*/


function PrintAllAppForHISUI(iTAdmId,IDType,NoAlert,AllItem,PrePrintType)
{
    //alert(iTAdmId+"^"+IDType+"^"+NoAlert)
    var LocID=session['LOGON.CTLOCID'];
    var AllItemFlag=0;
    if(AllItem=="Y") AllItemFlag=1;
    if (IDType=="PAADM"){
	    
        //����ΪPA_Adm���ID
        
    }else if (IDType=="CRM"){
	    
        //����ΪDHC_PE_PreIADM���ID
        var obj=document.getElementById('GetIADMIDBox');
        if (obj) {var encmeth=obj.value; } else {var encmeth=''; }
        if (encmeth==""){
            iTAdmId=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetIADMPAADMDR",iTAdmId);
        }else{
            iTAdmId=cspRunServerMethod(encmeth,iTAdmId);
        }
        
    }else if (IDType=="PADM"){
	    
        //����ΪDHC_PE_IADM���ID
        
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
    
    
    if (BaseInfoFlag=="Y") PrintBaseInfoBar(iTAdmId); //������Ϣ����
    
    
    var PrintFlag=0;
    if (PrintItemFlag=="Y") PrintFlag=1; //ָ����
    if (BarCodeFlag=="Y") PrintFlag=1; //��������
    if (SpecItemFlag=="Y") PrintFlag=1; //�������
    
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
	        
            $.messager.alert("��ʾ","his�е���Ϣ������е���Ϣ��һ�£����޸���Ϣ","info");
            return false;
            
        }else if(ret=="1"){
	        
            if (!confirm("����ӡ��Ա������ִ����Ŀ���Ƿ������ӡ")) return false;
            
        }else if(ret=="2"){
            
            $.messager.confirm("ȷ��", "ָ�����Ѿ���ӡ�����Ƿ������ӡ��", function(r){
            	if(r){ 
    				PrintAllHISUICommon(iTAdmId,AllItemFlag,DefaultPrint,PrePrintType);
            
            		}
            });

        }else if(ret=="3"){
	        
            $.messager.confirm("ȷ��", "ָ�����Ѿ���ӡ�����Ҵ�����ִ����Ŀ���Ƿ������ӡ", function(r){
            	if(r){
	            	PrintAllHISUICommon(iTAdmId,AllItemFlag,DefaultPrint,PrePrintType);
            	}
            });
            
        }else if(ret=="5"){
	        
            $.messager.alert("��ʾ","�������Ϊ"+Arr[1]+"���������ӡ","info");
            return false;
        }else if(ret=="4"){
	        
            $.messager.confirm("ȷ��","�������Ϊ"+Arr[1]+"���Ƿ������ӡ", function(r){
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
     var obj=document.getElementById("GetSpecItemInfo");//����
     if (obj) var encmeth=obj.value;
     if (encmeth==""){
     	var Info=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","GetPrintItem",iTAdmId,"");
     }else{
      	var Info=cspRunServerMethod(encmeth,iTAdmId,"");
     }
    if ((Info=="NoPayed")&&(PrePrintType!="PrePrint")){
         $.messager.alert("��ʾ","����δ������Ŀ�����ܴ�ӡ","info");
        return false;
    }
    
    if (PrintItemFlag=="Y") PatItemPrint(iTAdmId,AllItemFlag);//ָ����
    
    if (SpecItemFlag=="Y") SpecItemPrintLCT(iTAdmId,PrePrintType); //�������
    
    if (BarCodeFlag=="Y")  BarCodePrint(iTAdmId,"",PrePrintType); //��������
        
    
}
function PrintAllCommon(iTAdmId,AllItemFlag,BloodFlag)
{
	 var encmeth="";
	 var Info="";
     var obj=document.getElementById("GetSpecItemInfo");//����
     if (obj) var encmeth=obj.value;
     if (encmeth==""){
     	var Info=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","GetPrintItem",iTAdmId,"");
      }else{
      	var Info=cspRunServerMethod(encmeth,iTAdmId,"");
       }
       
     if (Info=="NoPayed"){
     	$.messager.alert("��ʾ","����δ������Ŀ�����ܴ�ӡ","info");
      	return false;
       }
      
     //�������
     var obj=document.getElementById('PrintSpecItem');  
     if (obj&&obj.checked)  SpecItemPrintLCT(iTAdmId);
    
     //�������� 
     var obj=document.getElementById('PrintBarCode');
     if (obj&&obj.checked) BarCodePrint(iTAdmId,BloodFlag);    
 
      
     //ָ����
     var obj=document.getElementById('PrintItem'); 
     if (obj&&obj.checked)  PatItemPrint(iTAdmId,AllItemFlag);
     
     //�������뵥
     var obj=document.getElementById('PrintPisRequest');  
     if (obj&&obj.checked)  PisRequestPrint(iTAdmId);
       
     //������뵥         
     var obj=document.getElementById('PrintRisRequest');  
     if (obj&&obj.checked)  PrintRisRequest(iTAdmId,"");
}


//������ iTAdmId (���ݲ���IDType�仯)
//		 IDType��"PAADM","CRM","Spec","PADM")
//       NoAlert()
//       AllItem(Y:���ﵥ��ӡ������Ŀ)
//       BloodFlag(2:Ѫ,1:��Ѫ,��:���б걾����)

function PrintAllApp(iTAdmId,IDType,NoAlert,AllItem,BloodFlag)
{
	//alert(iTAdmId+"^"+IDType+"^"+NoAlert+"^"+AllItem+"^"+BloodFlag)
    var AllItemFlag=0;
    if(AllItem=="Y") AllItemFlag=1;
    
    if (IDType=="PAADM"){

        ////����ΪPA_Adm���ID

    }else if (IDType=="CRM"){

        ////����ΪDHC_PE_PreIADM���ID
        var obj=document.getElementById('GetIADMIDBox');
        if (obj) {var encmeth=obj.value; } else {var encmeth=''; }
        if (encmeth==""){
            iTAdmId=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetIADMPAADMDR",iTAdmId);
        }else{
            iTAdmId=cspRunServerMethod(encmeth,iTAdmId);
        }

    }else if (IDType=="PADM"){

        //����ΪDHC_PE_IADM���ID

    }else if (IDType=="Spec"){

		var OEOrdRowID=tkMakeServerCall("web.DHCPE.BarPrint","GetOEORDBySpecNo",iTAdmId);
        iTAdmId=tkMakeServerCall("web.DHCPE.BarPrint","GetPAADMBySpec",iTAdmId);
        iTAdmId=iTAdmId+"^"+OEOrdRowID;
    }
    
	 //������Ϣ����
    obj=document.getElementById('PrintPersonInfo'); 
    if (obj&&obj.checked)  PrintBaseInfoBar(iTAdmId);
    
    var PrintFlag=0;
    var PrintItemFlag=0;

	 //������벡��
    obj=document.getElementById('PrintSpecItem'); 
    if (obj&&obj.checked) PrintFlag=1;

   //��������
    obj=document.getElementById('PrintBarCode'); 
    if (obj&&obj.checked) PrintFlag=1;
    
	//ָ����
    obj=document.getElementById('PrintItem'); 
    if (obj&&obj.checked) {PrintFlag=1; PrintItemFlag=1;}

    //�������뵥
    obj=document.getElementById('PrintPisRequest'); 
    if (obj&&obj.checked) PrintFlag=1;

    //������뵥
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

            $.messager.alert("��ʾ","his�е���Ϣ������е���Ϣ��һ�£����޸���Ϣ","info");
            return false;

        }else if(ret=="1"){
            
           $.messager.confirm("ȷ��","����ӡ��Ա������ִ����Ŀ���Ƿ������ӡ", function(r){
			if(r){
            	PrintAllCommon(iTAdmId,AllItemFlag,BloodFlag);
				}
            });
            
        }else if(ret=="2"){
			 $.messager.confirm("ȷ��", "ָ�����Ѿ���ӡ�����Ƿ������ӡ��", function(r){
            	if(r){
                	PrintAllCommon(iTAdmId,AllItemFlag,BloodFlag);
           		 }else{
	           		var encmeth="";
	 				var Info="";
     				var obj=document.getElementById("GetSpecItemInfo");//����
     				if (obj) var encmeth=obj.value;
     				if (encmeth==""){
     					var Info=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","GetPrintItem",iTAdmId,"");
      				}else{
      					var Info=cspRunServerMethod(encmeth,iTAdmId,"");
       				}
       
     				if (Info=="NoPayed"){
     					$.messager.alert("��ʾ","����δ������Ŀ�����ܴ�ӡ","info");
      					return false;
       				}
      
     				//�������
     				var obj=document.getElementById('PrintSpecItem');  
     				if (obj&&obj.checked)  SpecItemPrintLCT(iTAdmId);
    
     				//�������� 
     				var obj=document.getElementById('PrintBarCode');
     				if (obj&&obj.checked) BarCodePrint(iTAdmId,BloodFlag);    
 
   
     				//�������뵥
     				var obj=document.getElementById('PrintPisRequest');  
     				if (obj&&obj.checked)  PisRequestPrint(iTAdmId);
       
     				//������뵥         
     				var obj=document.getElementById('PrintRisRequest');  
     				if (obj&&obj.checked)  PrintRisRequest(iTAdmId,"");
	            
	            
            	}
            });
          
        }else if(ret=="3"){
			$.messager.confirm("ȷ��","ָ�����Ѿ���ӡ�����Ҵ�����ִ����Ŀ���Ƿ������ӡ", function(r){
            	if(r){
                	PrintAllCommon(iTAdmId,AllItemFlag,BloodFlag);
            	}
            });
           
        }else if(ret=="5"){
              
				$.messager.alert("��ʾ","�������Ϊ"+Arr[1]+"���������ӡ","info");
                 return false;

        }else if(ret=="4"){
			 $.messager.confirm("ȷ��","�������Ϊ"+Arr[1]+"���Ƿ������ӡ", function(r){
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

//�������
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
        
        $.messager.alert("��ʾ","����δ������Ŀ�����ܴ�ӡ��");
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
//��ӡ��������
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
        var WebIP=web+window.status.split("������IP:")[1]

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
         $.messager.alert("��ʾ","δ�ҵ�������Ŀ","info");
         return false;
    }
    if ((value=="NoPayed")&&(PrePrintType!="PrePrint"))
    {
        $.messager.alert("��ʾ","δ����,���ܴ�ӡ!","info");
        return false;
    }
    var ArrStr=value.split("$$");
    var Num=0;
    if (ArrStr.length>1){ Num=ArrStr[1];}
    value=ArrStr[0];
    PrintBarApp(value,"")  //DHCPEPrintBarCommon.js
    return false;
}

//��ӡ��������
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
        
       $.messager.alert("��ʾ","����δ������Ŀ�����ܴ�ӡ��");
        return false;
    }
    
    PrintBarRis(Info); //DHCPEPrintBarCommon.JS
}


// ��ӡ���쵥
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

   /* lodop �� ��ͨ��ӡ ���³�����2��
    var Ins=document.getElementById('GetOEOrdItemBox'); 
    if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
    if (encmeth==""){
        var value=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","GetPatOrdItemInfo",'','',Instring);
    }else{
        var value=cspRunServerMethod(encmeth,'','',Instring);
    }
    if (value=="NoPayed")
    {
         $.messager.alert("��ʾ","����δ�շѵ���Ŀ","info");
        return false;
    }
    */
    //����ӡ���
    var NoPrintAmount="N";
    var NoPrintAmount=$("#NoPrintAmount").checkbox('getValue');
    if(NoPrintAmount==false){
        NoPrintAmount="N"
    }else{
    	NoPrintAmount="Y";
	}
	
	//AllItemFlag��ȫ����ӡ��NoPrintAmount:�Ƿ��ӡ��
    var ExStrs=AllItemFlag+"^"+NoPrintAmount;
   
    PrintDJDByType(iIAdmId, "PAADM", "P", "",ExStrs);  // DHCPEPrintDJDCommon.js
    //PEPrintDJD("P",iIAdmId+"^"+NoPrintAmount+"^"+AllItemFlag,"");//DHCPEPrintDJDCommon.js  lodop��ӡ
    //Print(value,PrintFlag,"N");  //DHCPEIAdmItemStatusAdms.PatItemPrint.js
    var PFlag=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","PatItemPrintFlag",iIAdmId);
}
//��ӡ�����굥
//document.write("<script type='text/javascript' src='../scripts/dhcnewpro/dhcapp/pisprintcom.js'></script>");  //�²�Ʒ��
document.write("<script type='text/javascript' src='../scripts/dhcdoc/dhcapp/pisprintcom.js'></script>");  //ҽ��վ
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

//��ӡ������Ϣ����
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

//������뵥
function PrintRisRequest(iIAdmId,crmOrder)
{
    PrintRisRequestApp(iIAdmId,crmOrder,"PAADM"); //DHCPEIAdmItemStatusAdms.PatItemPrint.js
}
