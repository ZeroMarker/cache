//// DHCPEPrintBarCommon.js
///DHCNurOPExecPrint.js
///DHCNurOPExceDll.js 
//document.write("<object ID='PEPrnBar' CLASSID='CLSID:B98D3E39-A389-4118-9D41-B1831ED1361C' CODEBASE='../addins/client/PEPrintBar.CAB#version=2,0,0,0'>");
//document.write("</object>");
document.write("<script language='javascript' src='../scripts_lib/lodop/LodopFuncs.js'></script>")
//���������ӡ
function PrintBarRis(value)
{
	if (value==""){return true;}
	var Char_2=String.fromCharCode(2);
	var Char_1=String.fromCharCode(1);
	var Ords=value.split(Char_1);
	var iLLoop=0;
	var PrintInfo=""
	var OrdItem=Ords[0]
	var OrdItem1=OrdItem.split("^")
	// ����
	var PatName=OrdItem1[1];
	// �Ա�
	var Sex=OrdItem1[2];
	// ����
	var Age=OrdItem1[3];
	// ����
	var PatLoc=OrdItem1[4]
	var SpecName =OrdItem1[6];
	var LabelDesc=OrdItem1[5];
	var OrdItem2=Ords[1];
	var OrdItem3=OrdItem2.split(Char_2);
	var PrintInfo="PatName"+Char_2+PatName+"^"+"Sex"+Char_2+Sex+"^"+"Age"+Char_2+Age+"^"+"PatLoc"+Char_2+PatLoc
	//alert(1)
	DHCP_GetXMLConfig("InvPrintEncrypt","PERisPrint") //PERisPrint
	//alert(2)
	for(var iLLoop=0;iLLoop<OrdItem3.length;iLLoop++){
		var OrdItem4=OrdItem3[iLLoop].split("^");
		OrdName=OrdItem4[0];
		RecLoc=OrdItem4[1];
		RegNo=OrdItem4[2];	// �ǼǺţ�����ID��
		TJNo=OrdItem4[3]; //����
		if(RecLoc.indexOf("�����") >= 0){
			BarCode=OrdItem4[3]; 
		}else{
			BarCode=OrdItem4[2];
		}

		var OneInfo=PrintInfo+"^"+"RegNo"+Char_2+RegNo+"^"+"OrdName"+Char_2+OrdName+"^"+"RecLoc"+Char_2+RecLoc+"^"+"BarCode"+Char_2+BarCode
		DHC_PrintByLodop(getLodop(),OneInfo,"","", "");
	}
}

//������Ϣ�����ӡ
function PrintBaseBar(value)
{
	if (value==""){return true;}
	var Char_2=String.fromCharCode(2);
	var PrintInfo="";
	var BaseInfo=value.split("^");
	
	//�ǼǺ�
    var RegNo=BaseInfo[0];
	// ����
	var PatName=BaseInfo[1];
	// �Ա�
	var Sex=BaseInfo[2];
	// ����
	var Age=BaseInfo[3];
	// ���
	var FactAmount=BaseInfo[4];
	
	var BarCode=BaseInfo[5];
	
	var PrintInfo="RegNo"+Char_2+RegNo+"^"+"Name"+Char_2+PatName+"^"+"Sex"+Char_2+Sex+"^"+"Age"+Char_2+Age+"^"+"FactAmount"+Char_2+FactAmount+"^"+"BarCode"+Char_2+BarCode;
	
	DHCP_GetXMLConfig("InvPrintEncrypt","PEBasePrint"); //PEBasePrint ������Ϣ����xml
	
	DHC_PrintByLodop(getLodop(),PrintInfo,"","", "");
	
	
}

//���������ӡ
function PrintBarCodeBL(OrderID,PisID){
	
	
	var MyPara=$.cm({
	    ClassName : "web.DHCDocAPPBL",
	    MethodName : "PrintBarCode",
	    dataType:"text",
	    PisID:PisID,
	    Oeori:OrderID
    },false);
    
    var PrintArr=MyPara.split(String.fromCharCode(1))
    var PrintTemp=PrintArr[0]
    var BaseInfo=PrintArr[1]
    var Specinfo=PrintArr[2]
    if (Specinfo!=""){
	    var SpecinfoArr=Specinfo.split(String.fromCharCode(3))
	    for(var i=0; i<SpecinfoArr.length; i++){
		    var OneSpec=SpecinfoArr[i]
		    var OnePara=BaseInfo+"^"+OneSpec
		    DHCP_GetXMLConfig("InvPrintEncrypt",PrintTemp);
			DHC_PrintByLodop(getLodop(),OnePara,"","","");
		    }
	    }
	    
	}

function PrintBarApp(value,SpecNo)
{
	var HospitalCode=""
	var obj=document.getElementById("HospitalCode");
	if (obj) HospitalCode=obj.value;
	PrintBarCommon(HospitalCode,value,SpecNo)
}

function PrintBarCommon(HospitalCode,value,SpecNo)
{   
	var Char_2=String.fromCharCode(2);
	var Ords=value.split(";");
	var iLLoop=1;
	DHCP_GetXMLConfig("InvPrintEncrypt","PELisPrint") //PERisPrint
    for (var iLLoop=1;iLLoop<Ords.length;iLLoop++) 
	{
		var OrdNameArray=Ords[iLLoop].split("\\!");
		var OrdItems=OrdNameArray[0].split("^");
		var OneSpecNo=OrdItems[6];
		if ((OneSpecNo!=SpecNo)&&(SpecNo!="")) continue;
		var PrintInfo=""
		var LabNo=OrdItems[6];
		
		var RecLoc=OrdNameArray[2];
		var LabelDesc=OrdItems[7].split("%%")[2];
        var PatLoc=OrdItems[4]; //patLoc;
        var OrdName=OrdNameArray[1];
        var SpecName =OrdItems[7].split("%%")[0];
		 if((OrdItems[7].split("%%")[0].indexOf("��")>-1)||(OrdItems[7].split("%%")[0].indexOf("��")>-1)){
        	var LabelDesc=OrdItems[7].split("%%")[0]+" "+LabelDesc.split("ml")[0];
        	var SpecName =OrdItems[7].split("%%")[2];
        }else{
	        var SpecName =LabelDesc.split("ml")[1]; //������ɫ
        	var LabelDesc=OrdItems[7].split("%%")[0]+" "+LabelDesc.split("ml")[0]+"ml";
        }

        var PatName=OrdItems[1];
        var Sex=OrdItems[3];
        var Age=OrdItems[2];
        var RegNo=OrdItems[0];
        /*
        if (OrdName.length<10){
	        PrintInfo=PrintInfo+Split1+"T"+Split2+"40"+Split2+"180"+Split2+"6"+Split2+OrdName+Split2+"0";
        }else{
	        PrintInfo=PrintInfo+Split1+"T"+Split2+"40"+Split2+"180"+Split2+"6"+Split2+OrdName.substr(0,10)+Split2+"0";
	        PrintInfo=PrintInfo+Split1+"T"+Split2+"40"+Split2+"340"+Split2+"6"+Split2+OrdName.substr(10,10)+Split2+"0";
        }
        */
        var OneInfo="RegNo"+Char_2+RegNo+"^"+"PatName"+Char_2+PatName+"^"+"Sex"+Char_2+Sex+"^"+"Age"+Char_2+Age
        var OneInfo=OneInfo+"^"+"RecLoc"+Char_2+RecLoc+"^"+"BarCode"+Char_2+LabNo+"^"+"PatLoc"+Char_2+PatLoc
        var OneInfo=OneInfo+"^"+"LabelDesc"+Char_2+LabelDesc+"^"+"SpecName"+Char_2+SpecName

        var OrdName=tkMakeServerCall("web.DHCPE.ReportGetInfor","Replace",OrdName,"^"," ");
        if (OrdName.length<20){
	        
	        var OneInfo=OneInfo+"^"+"OrdName"+Char_2+OrdName
        }else{ 
	        var OneInfo=OneInfo+"^"+"OrdName"+Char_2+OrdName.substr(0,20)+"^"+"OrdName2"+Char_2+OrdName.substr(20,40) 
        }

        
        
		DHC_PrintByLodop(getLodop(),OneInfo,"","", "");
	}
}
//Split1 ^ //ÿ������֮��ķָ�
//Split2 & //ÿ���������Լ�ķָ�
//PrintInfo  T&20&20&8&0000000002 ����� �� 22&0^T&40&500&8&����ʵ����&0^T&40&660&8&Ѫ��&0^T&40&180&8&CEA+AFP&0^T&500&660&8&71&0^B&160&40&210&90&71
//PrintName  Ϊ��ӡ������tiaoma
//BΪ����   B^X^Y^Width(������)^Height(����߶�)^SpecNo(��������)
//TΪ�ı�   T^X^Y^Font(�ֺ�)^Str(��ӡ����)^Bold(�Ƿ����0��1)
function PrintBarCodeApp(PrintInfo,Split1,Split2,PrintName)
{
	var Bar; 
	//Bar= new ActiveXObject("PEPrintBar.PrnBar");
	Bar = PEPrnBar;
	Bar.PrintName=PrintName;//��ӡ������
    Bar.Split1=Split1  //ÿ������֮��ķָ�
    Bar.Split2=Split2  //ÿ���������Լ�ķָ�
    Bar.PrintInfo=PrintInfo;
    Bar.PrintZebraBar();
}

function PrintGetReportPT(value)
{
	if (value==""){return true;}
	var LocID=session['LOGON.CTLOCID']
	var HOSPID=session['LOGON.HOSPID']
    var HospitalName=tkMakeServerCall("web.DHCPE.DHCPECommon","GetHospitalName",HOSPID)
    //if (HospitalName.indexOf("[")>-1){var HospitalName=HospitalName.split("[")[0];}
	var OrdItem=value.split("^");
	var iLLoop=0;
	
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCPEFetchReportPT") 
	var Char_2=String.fromCharCode(2);
	
	
    //�ǼǺ�
	var RegNo=OrdItem[0];
	// ����
	var PatName=OrdItem[1];
	// �Ա�
	var Sex=OrdItem[2];
	// ����
	var Age=OrdItem[3];
	//�ƻ���ȡ��������
    var PEDate=OrdItem[4];
    var OrderSetsDesc=OrdItem[5];
    var CheckDate=OrdItem[6];
    var HpNo=OrdItem[7];
    
    
      var OneInfo="RegNo"+Char_2+RegNo+"^"+"PatName"+Char_2+PatName+"^"+"Sex"+Char_2+Sex+"^"+"Age"+Char_2+Age
      var OneInfo=OneInfo+"^"+"PEDate"+Char_2+PEDate+"^"+"OrderSetsDesc"+Char_2+OrderSetsDesc+"^"+"CheckDate"+Char_2+CheckDate
     var OneInfo=OneInfo+"^"+"HpNo"+Char_2+HpNo
     //alert(OneInfo)
     DHC_PrintByLodop(getLodop(),OneInfo,"","", "");
   
}

function BarCodePrintByCrm(crmid)
{
	if (""==crmid) {
		return ;
	}
	var encmeth=GetCtlValueById("GetAdmID");
	if (""==encmeth) return;
	
	var admid=cspRunServerMethod(encmeth,crmid);
	var info=admid.split("^");
	admid=info[1];
	BarCodePrintCRM(admid);
}

function BarCodePrintCRM(paadmid) 
{
	var encmeth="";
	var result="";
	
	if (""==paadmid) {
		return ;
	}
	
	//��ȡ��Ϣ
	var Ins=document.getElementById("PatOrdItemInfo");
	if (Ins) {var encmeth=Ins.value; }
	if (""!=encmeth) result=cspRunServerMethod(encmeth,"BarPrintCRM","",paadmid+"^");
}
function BarPrintCRM(value)
{
	if (value=="NoPayed")
	{
		alert(t["NoPayed"])
		return false;
	}
	PrintBarApp(value,"");
	return 
}
//��ӡ���˻�����Ϣ
function OnePersonInfoCodePrint(InString)
{
	var Char_2=String.fromCharCode(2);
	var Ins=document.getElementById("PersonInfoClass");
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,InString);
	var TxtInfo="",ListInfo="";
	//SortNo_"^"_PatName_"^"_PatAge_"^"_Sex_"^"_PatLoc_"^"_BedCode_"^"_RegNo_"^"_GroupDesc
	var Arr=flag.split("^")
	var Name=Arr[1]+" "+Arr[3]+" "+Arr[2]
	var GroupDesc=Arr[7]
	if (GroupDesc=="")  {var GroupDesc="�������"}
	var RegNo=Arr[6]
	TxtInfo="Name"+Char_2+Name+"^"+"GroupDesc"+Char_2+GroupDesc+"^"+"RegNoBar"+Char_2+"*"+RegNo+"*"+"^"+"RegNo"+Char_2+RegNo;
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);
}