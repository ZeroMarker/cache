//DHCPEPreIBaseInfo.Edit.js
//document.write("<object ID='ClsIDCode' WIDTH=0 HEIGHT=0 CLASSID='CLSID:299F3F4E-EEAA-4E8C-937A-C709111AECDC' CODEBASE='../addins/client/ReadPersonInfo.CAB#version=1,0,0,11' VIEWASTEXT>");
//document.write("</object>");
document.write("<object ID='ClsIDCode' WIDTH=0 HEIGHT=0 CLASSID='CLSID:299F3F4E-EEAA-4E8C-937A-C709111AECDC' CODEBASE='../addins/client/ReadPersonInfo.CAB#version=1,0,0,8' VIEWASTEXT>");
document.write("</object>");
var FIBIUpdateModel="";
var picType=".jpg"
var PicFilePath="D:\\"
var myItemNameAry=new Array();
var myCombAry=new Array();  ///Add by wangkai
myItemNameAry[1]="PAPMINo";
myItemNameAry[3]="Sex_DR_Name";
myItemNameAry[4]="PatType_DR_Name";
myItemNameAry[5]="Vocation";
myItemNameAry[6]="Blood_DR_Name";
myItemNameAry[7]="Married_DR_Name";
myItemNameAry[8]="DOB";
myItemNameAry[9]="VIPLevel";
myItemNameAry[10]="MobilePhone";
myItemNameAry[11]="Age";
myItemNameAry[2]="Name";
myItemNameAry[0]="CardNo";
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("IBIUpdateModel");
	if (obj) { FIBIUpdateModel=obj.value; }
	
	//����
	obj=document.getElementById("Update");
	if (obj) { obj.onclick=Update_click; }
	
	//���²�ԤԼ
	obj=document.getElementById("BUpdateReg");
	if (obj){ obj.onclick=UpdateReg_click; }
	
	//���²�����
	obj=document.getElementById("BUpdateArrive");
	if (obj){ obj.onclick=UpdateArrive_click; }
	
	obj=document.getElementById("BPhoto");
	if (obj){ obj.onclick=BPhoto_click; }

	var myobj=document.getElementById("ReadRegInfo");
    if (myobj)
	{
		myobj.onclick=ReadRegInfo_OnClick;
		myobj.onkeydown=Doc_OnKeyDown;
	}
	
	var Obj=document.getElementById('ReadInsuCard');
	if (Obj) {Obj.onclick = ReadInsuCard_Click;}

	/*
	 obj=document.getElementById("DOB");
	if (obj){
		obj.onblur=DOB_OnBlur;
	}*/
	$("#DOB").blur(DOB_OnBlur);
	
	obj=document.getElementById("Name");
	if (obj) { obj.onkeydown=Name_keydown;}
	
	//���
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }
	
	//�ǼǺ�
	obj=document.getElementById('PAPMINo');
	if (obj) {
		
		obj.onkeydown= RegNo_keydown;
		//obj.disabled=false;
		if ('NoGen'==FIBIUpdateModel) {
			//obj.disabled=true;
			$("#PAPMINo").attr('disabled',true);
			websys_setfocus("PAPMINo");
			
		}
		if ('Gen'==FIBIUpdateModel) {
			obj.disabled=false;
			websys_setfocus("PAPMINo");
		}
		if ('FreeCreate'==FIBIUpdateModel) {
			obj.disabled=false;
			websys_setfocus("PAPMINo");
		}
	}

	obj=document.getElementById("IDCard");
	if (obj){
		obj.onchange=ChangeIDCard;
		obj.onkeydown=IDCard_keydown; 
	}
	
	obj=document.getElementById("GroupDesc");
	if (obj){
		obj.onchange=ChangeGroup;
	}

	
	obj=document.getElementById("HCRDR");
	if (obj) {obj.onchange=HCRDR_Change;}
	obj=document.getElementById("HCADesc");
	if (obj) {obj.onchange=HCADesc_Change;}
	
	
	obj=document.getElementById("hcpdesc");
	if (obj) {obj.onchange=HCPDesc_Change;}

	obj=document.getElementById("CardNo");

	if (obj) {
		obj.onchange=CardNo_Change;
		obj.onkeydown= CardNo_keydown;
	  
	}
	
	
	
	obj=document.getElementById("Age");
	if (obj){obj.onchange=Age_Change;}
	
	//����
	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCard_Click;}

  	obj=document.getElementById("GroupDesc");
	if (obj) obj.onchange=CleanGroup;
	obj=document.getElementById("TeamDesc");
	if (obj) obj.onchange=CleanTeam;
	Muilt_LookUp("GroupDesc"+"^"+"TeamDesc")
	
	obj=document.getElementById("imgPic");
	if (obj) {obj.onclick=ImgPic_Click;}

    
	intKeydown();

	 if($("#GroupDR").val()!=""){
	    $("#BUpdateReg").linkbutton('disable');
	    $("#BUpdateArrive").linkbutton('disable');
	    $("#BReadCard").linkbutton('disable');
	    $("#ReadRegInfo").linkbutton('disable'); 
    }else{
	    $("#BUpdateReg").linkbutton('enable');
	    $("#BUpdateArrive").linkbutton('enable');
	    $("#BReadCard").linkbutton('enable');
	    $("#ReadRegInfo").linkbutton('enable');
	    }

	iniForm();
	//IniComboxInfo();
	SetDefault();
	PAPMINoFind();
	websys_setfocus("CardNo");
	initialReadCardButton()
	InitPicture();
}

function IniComboxInfo()
{
	//����
	var mydata = DHCWebD_GetObjValue("CTNationData");
	var myobj = document.getElementById("NationDesc");
	if (myobj) {
		myCombAry["NationDesc"] = new dhtmlXComboFromSelect("NationDesc", mydata);
		myCombAry["NationDesc"].enableFilteringMode(true);
	}

}


function ImgPic_Click()
{
	return false;
}

function test(crmid)
{
	var PAADM=tkMakeServerCall("web.DHCPE.PreIADMEx","GetPAADMByPADM",crmid);
					
					obj=document.getElementById('PrintSpecItem');
					if (obj&&obj.checked)  SpecItemPrintLCT(PAADM);
	   				obj=document.getElementById('PrintBarCode');
					if (obj&&obj.checked)  BarCodePrint(PAADM,"1");
					obj=document.getElementById('PrintSpecItem');
					if (obj&&obj.checked)  SpecItemPrint(PAADM,"0"); //������Ѫ��
					obj=document.getElementById('PrintBarCode');
					if (obj&&obj.checked){
						BarCodePrint(PAADM,"2");
						SpecItemPrint(PAADM,"1");  //��ӡѪ��
					}
		
					obj=document.getElementById('PrintItem');
					if (obj&&obj.checked)  PatItemPrint(crmid);
					obj=document.getElementById('PrintPisRequest');
					if (obj&&obj.checked)  PisRequestPrint(PAADM);
					obj=document.getElementById('PrintPersonInfo'); 
					if (obj&&obj.checked) PrintPatBaseInfo(PAADM);
}

/*
function ReadCard_Click()
{
	//var rtn=DHCACC_ReadMagCard();
	//obj=document.getElementById("CardNo");
	//if (obj) obj.value=rtn.split("^")[1];
	//CardNo_Change();
	ReadCardApp("PAPMINo","RegNoChange()","CardNo");
	
}
*/
//����
function ReadCard_Click(){
	var myrtn=DHCACC_GetAccInfo7(CardTypeCallBack);
}

function CardTypeCallBack(myrtn){
   var myary=myrtn.split("^");
   var rtn=myary[0];
	switch (rtn){
		case "0": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			var CardTypeNewID=myary[8];
			$("#CardNo").focus().val(CardNo);
			$("#PAPMINo").val(PatientNo);
			$("#CardTypeNewID").val(CardTypeNewID);
			RegNoChange();
			//LoadOutPatientDataGrid();
			event.keyCode=13; 
			break;
		case "-200": //����Ч
			$.messager.alert("��ʾ","����Ч","info",function(){$("#CardNo").focus();});
			break;
		case "-201": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			var CardTypeNewID=myary[8];
			$("#CardNo").focus().val(CardNo);
			$("#PAPMINo").val(PatientNo);
			$("#CardTypeNewID").val(CardTypeNewID);
			RegNoChange();
			//LoadOutPatientDataGrid();
			event.keyCode=13;
			break;
		default:
	}
}
function Age_Change()
{    
	//����
	obj=document.getElementById("Age");
	if (obj){iAge=obj.value;
	if (iAge=="") return;
	
	if (!(isNaN(iAge)))
	{
		var obj=document.getElementById("DOB");
		if (obj.value!="") return;
		iAge=parseInt(iAge)
		var D   =   new   Date();
	    var Year=D.getFullYear();
	    var Year=Year-iAge
		var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
	    if(dtformat=="DMY"){ obj.value="01/"+"01/"+Year;}
	    if(dtformat=="YMD"){ obj.value=Year+"-01"+"-01";}
	    
	}
	}
}
/*function ReadCardApp(RegNoElementName,FunctionName,CardElementName)
{
	var rtn=DHCACC_GetAccInfo()
    var ReturnArr=rtn.split("^");
    if (ReturnArr[0]=="-200")
    {
	    alert(ReturnArr[9]);
	    return false;
    }
    var obj=document.getElementById(RegNoElementName)
    if (obj)
    {
	    obj.value=ReturnArr[5];
	    eval(FunctionName);
	    obj=document.getElementById(CardElementName);
	    if (obj) obj.value=ReturnArr[1];
	   	
    }
}*/
//function CardNo_KeyDown(e)
function CardNo_keydown(e)
{
	var key=websys_getKey(e);
	if (13==key) {
		CardNo_Change();
	}
}


function CardNo_Change()
{ 
	var CardNo=$("#CardNo").val();
	if (CardNo==""){
		$("#CardTypeNew").val("");
	}
	if (CardNo=="") return;
		var myrtn=DHCACC_GetAccInfo("",CardNo,"","",CardTypeCallBack);
		var myCardNo=myrtn.split("^")[1];
		
		var obj=document.getElementById("CardNo"); 
	    if (obj){ obj.value=myCardNo;}
		return false;
	
	/*
	DHCACC_DisabledCardType("CardTypeDefine",myCardNo);
	combo_CardTypeKeydownHandler(); 
	CardNoChangeApp("PAPMINo","CardNo","RegNoChange()","Clear_click()","1","Name");
	var obj=document.getElementById("CardNo"); 
	if (obj){ obj.value=myCardNo;}
	//CardNoChangeApp("PAPMINo","CardNo","RegNoChange()","Clear_click()","1","Name");
	*/
}
/*function CardNoChangeApp(RegNoElement,CardElement,AppFunction,AppFunctionClear,ClearFlag)
{
	var obj;
	var CardNo="",encmeth;
	obj=document.getElementById(CardElement);
	if (obj) CardNo=obj.value;
	if (CardNo=="") return;
	obj=document.getElementById("GetRegNoByCardNo");
	if (obj) encmeth=obj.value;
	if (encmeth=="") return;
	RegNo=cspRunServerMethod(encmeth,CardNo,"C");
	if (RegNo=="") return;
	if (ClearFlag=="1") eval(AppFunctionClear);
	obj=document.getElementById(RegNoElement);
	if (obj)
	{
		obj.value=RegNo;
		eval(AppFunction);
	}
}*/
 
function HCRDR_Change()
{
	var obj=document.getElementById("HCADR");
	if (obj) obj.value="";
	var obj=document.getElementById("HCADesc");
	if (obj) obj.value="";
	//var obj=document.getElementById("hcpdr");
	//if (obj) obj.value="";
	//var obj=document.getElementById("hcpdesc");
	//if (obj) obj.value="";
}
function HCADesc_Change()
{
	var obj=document.getElementById("HCADR");
	if (obj) obj.value="";
	//var obj=document.getElementById("hcpdr");
	//if (obj) obj.value="";
	//var obj=document.getElementById("hcpdesc");
	//if (obj) obj.value="";
}
function HCPDesc_Change()
{
	var obj=document.getElementById("hcpdr");
	if (obj) obj.value="";
}
function AfterHCAFind(value)
{
	if (value=="") return;
	var ValArr=value.split("^");
	var obj=document.getElementById("HCADR");
	if (obj) obj.value=ValArr[2];
}
function AfterHCPFind(value)
{
	if (value=="") return;
	var ValArr=value.split("^");
	var obj=document.getElementById("hcpdr");
	if (obj) obj.value=ValArr[2];
}
function SetDefault()
{
	var SexNV=""
	var obj=document.getElementById("SexNV");
	if (obj) SexNV=obj.value;
	SexNV=SexNV.split("^");
	
	//�Ա�
	$("#Sex_DR_Name").combobox('setValue',SexNV[1]);
	//����
	$("#PatType_DR_Name").combobox('setValue',SexNV[0]);
	//֤������
    $("#PAPMICardType_DR_Name").combobox('setValue',SexNV[4]);
   
	var Ins=document.getElementById('GetVIPLevel');
	if (Ins) { var encmeth=Ins.value} else {var encmeth=''};
	var VIPApprove=cspRunServerMethod(encmeth);
	obj=document.getElementById("VIPLevel");
	if (obj) { obj.value=VIPApprove; }

	
}
function PAPMINoFind()
{
	var obj=document.getElementById('PAPMINo');
	var PAPMINo="";
	if (obj) PAPMINo=obj.value;
	if (PAPMINo!=""){RegNoChange();}
}

function iniForm(){
	var ID=""
	var obj;

	// 
	obj=document.getElementById("OperType");
	if ( obj && "Q"==obj.value) {
	}else{
			//����
			obj=document.getElementById("Update");
			//if (obj){ obj.style.display="inline"; }
	
			//����
			obj=document.getElementById("BFind");
			//if (obj){ obj.style.display="inline"; }
	
			//���
			obj=document.getElementById("Clear");
			//if (obj){ obj.style.display="inline"; }	
				
			obj=document.getElementById("BUpdateReg");
			//if (obj){ obj.style.display="inline"; }
	}
	
	obj=document.getElementById('ID');
	if (obj && ""!=obj.value) {
		obj=document.getElementById('DataBox');
		if (obj && ""!=obj.value) {
			SetPatient(obj.value);
		}
	}

	
}
function trim(s) {
	if (""==s) { return "";}
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
    return (m == null) ? "" : m[1];
}

//��֤�Ƿ�Ϊ������
function IsFloat(Value) {
	
	var reg;
	
	if(""==trim(Value)) {
		//����Ϊ��
		return true; 
	}else { Value=Value.toString(); }
	
	reg=/^((-?|\+?)\d+)(\.\d+)?$/;

	var r=Value.match(reg);
	if (null==r) { return false; }
	else { return true; }
}

function RegNo_keydown(e) {

	var key=websys_getKey(e);
	if (13==key) {
		RegNoChange();
	}
	
}
function RegNoChange() {
         
	
		var obj;
		var iPAPMINo="";
		obj=document.getElementById('PAPMINo');
		if (obj && ""!=obj.value) { 
			iPAPMINo = obj.value;
			//iPAPMINo = '00000000'.substr(1,8-iPAPMINo.length)+iPAPMINo
			iPAPMINo=RegNoMask(iPAPMINo)
		}
		else { return false; }
		var iPAPMINo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iPAPMINo);
		$("#PAPMINo").val(iPAPMINo);
		var flag=tkMakeServerCall("web.DHCPE.PreIADM","JudgeIGByRegNo",iPAPMINo)
		if(flag=="G"){ 
			$.messager.popover({msg: "������Ա,�������������Ϣά���������", type: "info"});
		    return false;
		}


    var Ins=document.getElementById('GetPatientID');
	if (Ins) { var encmeth=Ins.value} else {var encmeth=''};
	var PatientID=cspRunServerMethod(encmeth,iPAPMINo);
	//ShowPicByPatientID(PatientID,"imgPic")  //DHCPECommon.js
	//var src=PicFilePath+PatientID+picType
	//document.getElementById("imgPic").innerHTML='<img SRC='+src+' BORDER="0" width=110 height=160>&nbsp;'
    //document.getElementById("imgPic").innerHTML='<img SRC='+src+' BORDER="0" width=110 height=160>&nbsp;'	
    iPAPMINo="^"+iPAPMINo+"^";
    var CardTypeNewID=$("#CardTypeNewID").val();
 //iPAPMINo=iPAPMINo+"$"+m_SelectCardTypeRowID;
 iPAPMINo=iPAPMINo+"$"+CardTypeNewID;
	FindPatDetail(iPAPMINo);
	//ҽ����
	obj=document.getElementById("MedicareCode");
	if (obj)
	{
		/*
		if(""!=obj.value) {obj.disabled=true;}
		else{obj.disabled=false;}
		*/
	
	}
   //����
	var obj=document.getElementById("CardNo"); 
	if (obj){ var myCardNo=obj.value;}
	DHCACC_DisabledCardType("CardTypeDefine",myCardNo);
	//combo_CardTypeKeydownHandler(); 
	InitPicture();
	
	
}
//	ID ��ʽ RowId^PAPMINo^Name
function FindPatDetail(ID){
	var Instring=ID;
	//alert(ID)
	var Ins=document.getElementById('GetDetail');
	if (Ins) { var encmeth=Ins.value} else {var encmeth=''};
	var flag=cspRunServerMethod(encmeth,'SetPatient','',Instring);
	
}

function SetPatient(value) {
	if ((""==value)&&(";"==value)) { return false; }
	var Data=value.split(";");
	if(value.split("^")[2]=="δ�ҵ���¼"){
		$.messager.popover({msg: "HIS����δ�ҵ���Ϣ", type: "info"});
		return false;
	}

	Clear_click();
	
	PreData=Data[0];
	HISData=Data[1];
	

	if (""!=PreData) {
		value=PreData;
		var Data=value.split("^");
		var iRowId=Data[0];
		//	PIBI_RowId	0
		obj=document.getElementById("RowId");
		if (obj) { obj.value=iRowId; }
		
		obj=document.getElementById("IBIUpdateModel");
		if (obj && "NoGen"==obj.value) { websys_setfocus("Name"); }
		if (obj && "Gen"==obj.value) { websys_setfocus("PAPMINo"); }
		if (obj && "FreeCreate"==obj.value) { websys_setfocus("PAPMINo"); }		
		
		SetPatient_Sel(value);
		
		return;
	}
	
	if (""!=HISData) {
		
		var value=HISData;
		var Data=value.split("^");
		//var iRowId=Data[0];
		//	PIBI_RowId	0
		obj=document.getElementById("RowId");
		if (obj) { obj.value=""; }
		
		SetPatient_Sel(value);
		obj=document.getElementById("IBIUpdateModel");
		if (obj && "NoGen"==obj.value) { websys_setfocus("Name"); }
		if (obj && "Gen"==obj.value) { websys_setfocus("PatType_DR_Name"); }		
		if (obj && "FreeCreate"==obj.value) { websys_setfocus("PatType_DR_Name"); }
		return;
	}

		//	PIBI_RowId	0
		obj=document.getElementById("RowId");
		if (obj) { obj.value=""; }	
		
		//	PIBI_Name	����	2
		obj=document.getElementById("Name");
		if (obj) { obj.value="δ�ҵ����߼�¼";	}
		
		
		obj=document.getElementById("IBIUpdateModel");
		if (obj && "NoGen"==obj.value) { websys_setfocus("PatType_DR_Name"); }
		if (obj && "Gen"==obj.value) { websys_setfocus("PAPMINo"); }
		
		
}
//
function SetPatient_Sel(value) {

	obj=document.getElementById("Update");
	if(obj) {DisableBElement("Update",false);}

	IBISetPatient_Sel(value);
	
	//���ݵǼǺŴ���������  (��Ϊ��������Clear_click()�������)
	var CardTypeNewStr=tkMakeServerCall("web.DHCPE.PreIBIUpdate","CardTypeByRegNo",$("#PAPMINo").val());
		//alert(CardTypeNewStr)
		if(CardTypeNewStr!=""){
			var CardTypeNewID=CardTypeNewStr.split("^")[0];
			var CardTypeNew=CardTypeNewStr.split("^")[1];
			$("#CardTypeNewID").val(CardTypeNewID);
		    $("#CardTypeNew").val(CardTypeNew);
		}
		
	return true;
}

function Update_click() {
	var Src=window.event.srcElement;
	if (Src.disabled) { return false; }
	Src.disabled=true;
	Update("0");
	Src.disabled=false;
}
function UpdateReg_click()
{
	Update("1");
}
function UpdateArrive_click()
{
	Update("2");
}
function Update(RegFlag) {	

	var iRowId="",iHPNo="",iHCPDR="",iCardNo,iVIPLevel="";
	var iPAPMINo="", iName="", iSex_DR="", iDOB="", iPatType_DR="", iTel1="", iTel2="", iMobilePhone="", iIDCard="", iVocation="", iPosition="", iCompany="", iPostalcode="", iAddress="", iNation="", iEmail="", iMarriedDR="", iBloodDR="", iUpdateDate="", iUpdateUserDR="",iHCADR="";	  
	var obj;
	var iHospitalCode=""
	
	iHospitalCode=getValueById("HospitalCode");
	
	//	PIBI_RowId	21
	iRowId=getValueById("RowId");
	
	//	PIBI_PAPMINo	�ǼǺ�	1	�����޸�
	iPAPMINo=getValueById("PAPMINo");
	if(iPAPMINo!=""){
			var iPAPMINo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iPAPMINo);
			$("#PAPMINo").val(iPAPMINo)
   		 var flag=tkMakeServerCall("web.DHCPE.PreIADM","JudgeIGByRegNo",iPAPMINo);
		if(flag=="G"){
			$.messager.alert("��ʾ","������Ա,�������������Ϣά���������",'info');
	    	return false;
		}
	}

	//	PIBI_Name	����	2
	iName=getValueById("Name");
	
	//	PIBI_Sex_DR	�Ա�	3
	iSex_DR=getValueById("Sex_DR_Name");
 
	//	PIBI_IDCard	���֤��	9
	iIDCard=getValueById("IDCard");
	iIDCard=trim(iIDCard)
	//if (!isIdCardNo(iIDCard)) return;
	var iPAPMICardType=""
	iPAPMICardType=$("#PAPMICardType_DR_Name").combobox('getText');
	if((iPAPMICardType.indexOf("���֤")!="-1")&&(iIDCard!="")){
		
		var myIsID=isIdCardNo(iIDCard);
		
				if (!myIsID){
					$("#IDCard").focus();
					return false;
				}
				var IDNoInfoStr=GetInfoFromIDCard(iIDCard)
				var IDBirthday=IDNoInfoStr[2]
				var myBirth=getValueById('DOB'); 
				if (myBirth!=IDBirthday){
					$.messager.alert("��ʾ","�������������֤��Ϣ����!","info",function(){
						$("#Birth").focus();
					});
		   		    return false;
				}
				var IDSex=IDNoInfoStr[3]
				var mySex=getValueById('Sex_DR_Name');
				var mySex=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSexDescByID",mySex)
				//alert(mySex+"^"+IDSex)
				if(mySex!=IDSex){
					$.messager.alert("��ʾ","���֤��:"+iIDCard+"��Ӧ���Ա��ǡ�"+IDSex+"��,��ѡ����ȷ���Ա�!","info",function(){
						$('#Sex').next('span').find('input').focus();
					});
					return false;
				}
	}

	//	PIBI_DOB	����	4
	obj=document.getElementById("DOB");
	if(obj.value==""){ Age_Change() } //����ת��������
	else { 
		var flag=DOB_OnBlur();
		if(flag==false){return  false;}
			
		}

	obj=document.getElementById("DOB");
	if (obj) { iDOB=obj.value;}
	var iiDOB=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",iDOB)
	var mydate = new Date();
	var CurMonth=mydate.getMonth()+1;
	if((CurMonth<=9)&&(CurMonth>=0)){var CurMonth="0"+CurMonth;}
	var CurDate=mydate.getFullYear()+"-"+CurMonth+"-"+ mydate.getDate(); 
	var CurDate=tkMakeServerCall("websys.Conversions","DateHtmlToLogical",CurDate)
	if(iiDOB>CurDate) {
		$.messager.alert("��ʾ","�������ڲ��ܴ��ڵ�ǰ����.","info");
		return false;
	}

	//	PIBI_PatType_DR	��������	5
	iPatType_DR=getValueById("PatType_DR_Name");

	
	//	PIBI_Tel2	�绰����2	7
	iTel2=getValueById("Tel2");
    iTel2=trim(iTel2);
	if (iTel2!=""){
		if (!CheckTelOrMobile(iTel2,"Tel2","")) return false;
		
	}
	//	PIBI_MobilePhone	�ƶ��绰	8
	iMobilePhone=getValueById("MobilePhone");
	iMobilePhone=trim(iMobilePhone);
	if (iMobilePhone==""){
		$.messager.alert("��ʾ","�ƶ��绰����Ϊ��!","info",function(){
			$("#MobilePhone").focus();
		});
		return false;
	}else{
		
		if (!CheckTelOrMobile(iMobilePhone,"MobilePhone","")) return false;
	}
	/*
	if (!isMoveTel(iMobilePhone))
	{
		websys_setfocus(obj.id);
		return;
	}*/
	
	
	
	//	PIBI_Tel1	�绰����1	6
	iTel1=getValueById("Tel1");
	iTel1=trim(iTel1);
	if (iTel1!=""){
		if (!CheckTelOrMobile(iTel1,"Tel1","")) return false;
		
	}
	//	PIBI_Vocation	ְҵ	10
	iVocation=getValueById("Vocation");

	//	PIBI_Position	ְλ	11
	iPosition=getValueById("Position");

	//	PIBI_Company	��˾	12
	iCompany=getValueById("Company");

	//	PIBI_Postalcode	�ʱ�	13
	iPostalcode=getValueById("Postalcode");
	if(!IsPostalcode(iPostalcode)){
		websys_setfocus(obj.id);
		return;
	}

	//	PIBI_Address	��ϵ��ַ	14
	iAddress=getValueById("Address");

	//	PIBI_Nation	����	15
	var iNationDesc=""
	//iNationDesc=getValueById("NationDesc");
	//var iNation=tkMakeServerCall("web.DHCPE.PreCommon","GetNationDR",iNationDesc) 
	iNation=getValueById("CTNationDR");
	
	


	//	PIBI_Email	�����ʼ�	16
	//obj=document.getElementById("Email");
	//if (obj) { iEmail=obj.value; }
	var iEmail=$("#Email").val();
	 if(!IsEMail(iEmail)){
			websys_setfocus(obj.id);
			return;
		}

	//	PIBI_Married	����״��	17
	iMarriedDR=getValueById("Married_DR_Name");
	
	//	PIBI_Blood	Ѫ��	18
    iBloodDR=getValueById("Blood_DR_Name");
	
	//	PIBI_UpdateDate	����	19
	//obj=document.getElementById("UpdateDate");
	//if (obj) { iUpdateDate=obj.value; }
	iUpdateDate='';
 
   	//VIP
 	iVIPLevel=getValueById("VIPLevel");

	//	PIBI_UpdateUser_DR	������	20
	//obj=document.getElementById("UpdateUser_DR");
	//if (obj) { iUpdateUser_DR=obj.value; }
	iUpdateUserDR=session['LOGON.USERID'];

	// /////////////////////       ������֤          ////////////////////////////////////
	//�������̵Ĳ�ͬ?����ǼǺ�
	obj=document.getElementById("IBIUpdateModel");
	if (obj && "NoGen"==obj.value) {}
	if (obj && "Gen"==obj.value) {
		// �ǼǺű���
		if (""==iPAPMINo) {
			obj=document.getElementById("PAPMINo")
			if (obj) {
				obj.value="";
				websys_setfocus(obj.id);
			}
			$.messager.alert("��ʾ","�ǼǺŲ���Ϊ��!","info");
			//alert(t['01']);
			return false;
		} 
	}
	if (obj && "FreeCreate"==obj.value) {
		// �ǼǺű���
		if (""==iPAPMINo) {

			obj=document.getElementById("PAPMINo")
			if (obj) {
				obj.value="";
				websys_setfocus(obj.id);
			
			}
			$.messager.alert("��ʾ","�ǼǺŲ���Ϊ��!","info");
			//alert(t['01']);
			return false;
		}
		if (isNaN(iPAPMINo)){
			
			obj=document.getElementById("PAPMINo")
			if (obj) {
				websys_setfocus(obj.id);
				
			}
			alert('�ǼǺŲ�������');
			return false;
		}
	}
	// �������ͱ���
	if (""==iPatType_DR) {
		obj=document.getElementById("PatType_DR_Name")
		if (obj) {
			obj.value="";
			websys_setfocus(obj.id);
		}
		$.messager.alert("��ʾ","���Ͳ���Ϊ��!","info");
		//alert(t['01']);
		return false;
		
	}

	// ��������
	if (""==iName) {
		obj=document.getElementById("Name")
		if (obj) {
			obj.value="";
			websys_setfocus(obj.id);
		}
		$.messager.alert("��ʾ","��������Ϊ��!","info");
		//alert(t['01']);
		return false;
	}

	// �Ա����
	if (""==iSex_DR) {
		obj=document.getElementById("Sex_DR_Name")
		if (obj) {
			obj.value="";
			websys_setfocus(obj.id);
		}
		$.messager.alert("��ʾ","�Ա���Ϊ��!","info");
		//alert(t['01']);
		return false;
	}
	 //���䲻��Ϊ��
	if (iHospitalCode=="LZEY") {
	obj=document.getElementById("Age")
	if (""==obj.value) 
	{	
		websys_setfocus(obj.id);
		$.messager.alert("��ʾ","���䲻��Ϊ��!","info");
		//alert(t['01']);
		return false;
	}
	}
	// ���ձ���
	if (""==iDOB) {
		
		obj=document.getElementById("DOB")
		if (obj) {
			websys_setfocus(obj.id);
		}
		$.messager.alert("��ʾ","���ղ���Ϊ��!","info");
		//alert(t['01']);
		return false;
	}
	/*
   // �ƶ��绰���� 
	if (""==iMobilePhone) {
		obj=document.getElementById("MobilePhone")
		if (obj) {
			websys_setfocus(obj.id);
		}
		alert(t['01']);
		return false;
	}
*/
	iHPNo=getValueById("HPNo");
	iHCPDR=getValueById("hcpdr");
	iHCADR=getValueById("HCADR");
	
	iCardNo=getValueById("CardNo");
	iCardTypeNewID=getValueById("CardTypeNewID");
	if (iCardNo!="") iCardNo=iCardNo+"$"+iCardTypeNewID;
	//if (iCardNo!="") iCardNo=iCardNo+"$"+m_SelectCardTypeRowID;
	//alert("iCardNo:"+iCardNo)
	var iMedicareCode="";
	iMedicareCode=getValueById("MedicareCode");
	
	CardRelate=getValueById("CardRelate");
	

	if ((iHospitalCode=="FX")&(iHCADR==""))
	{
		alert(t["01"])
		var obj=document.getElementById("HCADesc");
		websys_setfocus("HCADesc");
		obj.className='clsInvalid';
		return false;
	}
	
	
	//֤������
	var iPAPMICardType=""
	iPAPMICardType=getValueById("PAPMICardType_DR_Name");
	if((iIDCard!="")&&(iPAPMICardType=="")){
		obj=document.getElementById("PAPMICardType_DR_Name")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		$.messager.alert("��ʾ","֤�����Ͳ���Ϊ��","info");
		return false;
	}
    
    //�жϷ�ҽ�������ܸ���ҽ����,
    var PatFlag=""
    PatFlag=tkMakeServerCall("web.DHCBL.CARD.UCardRefInfo","GetInsurFlag",iPatType_DR)
   
   //alert(iPatType_DR)
    if((PatFlag=="0")&&(iMedicareCode!="")){    
	    $.messager.alert("��ʾ","��ҽ������,ҽ�����Ų�����","info");
		return false;
	    
	    }
	if((PatFlag!="0")&&(iMedicareCode=="")){
	    $.messager.alert("��ʾ","ҽ������,����д��ȷ��ҽ������","info");
		return false;
	    
	    }
	    
	    
	    
    //alert("iPatType_DR="+iPatType_DR)
	
	var Instring=	trim(iRowId)			//			1 
				+"^"+trim(iPAPMINo)			//�ǼǺ�		2
				+"^"+trim(iName)			//����		3
				+"^"+trim(iSex_DR)			//�Ա�		4
				+"^"+trim(iDOB)				//����		5
				+"^"+trim(iPatType_DR)		//��������	6
				+"^"+trim(iTel1)			//�绰����1	7
				+"^"+trim(iTel2)			//�绰����2	8
				+"^"+trim(iMobilePhone)		//�ƶ��绰	9
				+"^"+trim(iIDCard)			//���֤��	10
				+"^"+trim(iVocation)		//ְҵ		11
				+"^"+trim(iPosition)		//ְλ		12
				+"^"+trim(iCompany)			//��˾		13
				+"^"+trim(iPostalcode)		//�ʱ�		14
				+"^"+trim(iAddress)			//��ϵ��ַ	15
				+"^"+trim(iNation)			//����		16
				+"^"+trim(iEmail)			//�����ʼ�	17
				+"^"+trim(iMarriedDR)		//����״��	18
				+"^"+trim(iBloodDR)			//Ѫ��		19
				+"^"+trim(iUpdateDate)		//����		20
				+"^"+trim(iUpdateUserDR)	//������	21
				+"^"+trim(iHPNo)
				+"^"+trim(iHCPDR)
				+"^"+trim(iHCADR)
				+"^"+trim(iCardNo)
				+"^"+trim(iVIPLevel)
				+"^"+trim(iMedicareCode)
				+"^"+trim(iPAPMICardType)
				+";"+FIBIUpdateModel
				
				;
				
			//alert(Instring)
			
	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var flag=cspRunServerMethod(encmeth,'','',Instring)

	//if (""==iRowId) { //�������
		var Data=flag.split("^");
		flag=Data[0];
		iRowId=Data[1];
		iRegNo=Data[2];
	//}
	
		
	if (flag=='0') {
		
		if (RegFlag=="0") { 
			$.messager.alert("��ʾ","���³ɹ�!","info");
			//alert("���³ɹ�");
			} 
		
		obj=document.getElementById("RowId");
		if ((obj)&&(obj.value=="")) { obj.value=iRowId; }
	
		if (RegFlag=="1")
		{
			var TeamObj=document.getElementById("TeamDR");
			var TeamDR=""
			if (TeamObj) TeamDR=TeamObj.value;
			if (TeamDR=="")
			{
				if (iRegNo=="") iRegNo=iPAPMINo
				var lnk="dhcpepreiadm.main.csp?"
					+"PAPMINo="+iRegNo
					;
		
				var wwidth=1250;
				var wheight=1150;
				var xposition = (screen.width - wwidth) / 2;
				var yposition = (screen.height - wheight) / 2;
				var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
					+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
					;
				var cwin=window.open(lnk,"_blank",nwin) 
				return true; 

				//window.location.href=lnk;
			
			}
			else
			{
				var iPIBIDR=iRowId;
				var iPGTeamDR=TeamDR;
				var iPGADMDR=TeamDR.split("||")[0];
				var Ins=document.getElementById('PreClassBox');
				if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
				var flag=cspRunServerMethod(encmeth,iPIBIDR,iPGADMDR,iPGTeamDR)
				if (flag=="Err Audit")
				{
					alert(t[flag]);
					return false;
				}
	
				var Rets=flag.split("^");
				flag=Rets[0];
				if ('0'==flag) {
					IBIClear_click();
					websys_setfocus("Name");

					return false;
				}
				else if ('Err 07'==flag) {
					 $.messager.alert("��ʾ","�ܼ�����������������Ѵ���","info");
					return false;		
				}
				else if ('Err 09'==flag) {          
					var Errflag=Rets[1];
			
					if ('Married Err'==Errflag)
					{  
						$.messager.alert("��ʾ","����״����һ��","info");
						//alert(t[Errflag]);
					    return false;
						}
					else if ('Sex Err'==Errflag)
					{  
						$.messager.alert("��ʾ","�Ա�һ��","info");
						//alert(t[Errflag]);
					    return false;
						}
					else {
						$.messager.alert("��ʾ","�����������Աʧ��","error");
						//alert("�����������Աʧ��")
						}
						//alert(t['Err 09']+":"+Rets[1]);
						return false;		
				}
				else {
					//alert("Insert error.ErrNo="+flag);
					//alert("���´���,�����:"+flag);
					$.messager.alert("��ʾ","���´���,�����:"+flag,"error");
					return false;
				}
			}
			return;
		}
	if (RegFlag=="2")				//add by zl start
		{
			var TeamObj=document.getElementById("TeamDR");
			var TeamDR=""
			if (TeamObj) TeamDR=TeamObj.value;
			if (TeamDR=="")
			{
				 $.messager.alert("��ʾ","��Ҫ�������","info");
				return false;
			}
			else
			{
				var iPIBIDR=iRowId;
				var iPGTeamDR=TeamDR;
				var iPGADMDR=TeamDR.split("||")[0];
				var Ins=document.getElementById('PreClassBox');
				if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
				var flag=cspRunServerMethod(encmeth,iPIBIDR,iPGADMDR,iPGTeamDR)
				//alert(flag)
				if (flag=="Err Audit")
				{
					alert(t[flag]);
					return false;
				}
	
				var Rets=flag.split("^");
				flag=Rets[0];
				if ('0'==flag) 
				{
				
				var encmeth=document.getElementById('GetDataBox');
				if (encmeth) encmeth=encmeth.value;
				if (Rets[1]=="") return;
				var flag=cspRunServerMethod(encmeth,Rets[1],"3");
				if (flag!='0') {
					 if(flag=="NoItem"){ 
                          $.messager.alert("��ʾ","û��ԤԼ��Ŀ","info");
					 }

    			       //alert(t['FailsTrans']+"  error="+flag);
    			       return false;
   				 	}
					var PAADM=tkMakeServerCall("web.DHCPE.PreIADMEx","GetPAADMByPADM",Rets[1]);
					
						
					//ָ����
					obj=document.getElementById('PrintItem');
					if (obj&&obj.checked) PatItemPrint(Rets[1]);
					
					//���˻�����Ϣ
					obj=document.getElementById('PrintPersonInfo'); 
					if (obj&&obj.checked) PrintPatBaseInfo(PAADM);
					

					
	   				obj=document.getElementById('PrintBarCode');
					if (obj&&obj.checked){
						BarCodePrint(PAADM,"2");
						SpecItemPrint(PAADM,"1"); //��ӡѪ��
					}

					//����
	   				obj=document.getElementById('PrintBarCode');
	   				//if (obj&&obj.checked) BarCodePrint(PAADM,"1");
	   				
	   				
					
	   				//��������
	   				obj=document.getElementById('PrintPisRequest');
					if (obj&&obj.checked) PisRequestPrint(PAADM);
					
					//�������
					obj=document.getElementById('PrintSpecItem');
					if (obj&&obj.checked) SpecItemPrintLCT(PAADM);
					
					obj=document.getElementById('PrintSpecItem');
					if (obj&&obj.checked) SpecItemPrint(PAADM,"0"); //������Ѫ��

					
					IBIClear_click();
					websys_setfocus("Name");
					
					return false;
					
				}
				else if ('Err 07'==flag) {
					$.messager.alert("��ʾ","�ܼ�����������������Ѵ���","info");
					//alert("�ܼ�����������������Ѵ���")
					//alert(t['Err 07']);
					return false;		
				}
					else if ('Err 09'==flag) {          //modify  by 20120306 start
					var Errflag=Rets[1];
			
					if ('Married Err'==Errflag)
					{  
						$.messager.alert("��ʾ","����״����һ��","info");
						//alert(t[Errflag]);
					    return false;
						}
					else if ('Sex Err'==Errflag)
					{ 
						$.messager.alert("��ʾ","�Ա�һ��","info");
						//alert(t[Errflag]);
					    return false;
						}
					else {
					$.messager.alert("��ʾ","�����������Աʧ��","error");
					//alert("�����������Աʧ��")
					}
					//alert(t['Err 09']+":"+Rets[1]);
					return false;		
				} 
				else {
					
					$.messager.alert("��ʾ","���´���,�����:"+flag,"error");
					//alert("���´���,�����:"+flag);
					
					return false;
				}
		
			}
			return;
		}
		if (opener)
		{
			//close();
			var  openername=opener.name;
			if (openername=="DHCPEPreIADM.Team")   //Add 20080710
			{                                      //Add 20080710
				opener.SetPatInfo(iRegNo);     		//Add 20080710
			}                                      //Add 20080710
			else                                   //Add 20080710
			{					 //Add 20080710
				var LinkType=""
				var obj=document.getElementById("LinkType")
				if (obj) LinkType=obj.value;
				if (LinkType!="M")
				{
					var ReturnComponent="",GTeam=""
					var obj=document.getElementById("ReturnComponent")
					if (obj) ReturnComponent=obj.value;
				
					var obj=document.getElementById("GTeam")
					if (obj) GTeam=obj.value;
				
					var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+ReturnComponent
					+"&Parref="+GTeam+"&OperType=E"+"&PAPMINo="+iRegNo;
				
					opener.location.href=lnk;
				}
			}
			close();
			//opener.RegNoOnChange();
			return;
		}
	
		//alert(t['info 01']);
		Clear_click(1,iRegNo);
		
		return;}
		else {
		//alert("Insert error.ErrNo="+flag);
		alert(t['02']+flag);
		return false;
		
	}
}
function SpecItemPrintLCT(iTAdmId)
{
	//alert("sss")
	var CRMId=iTAdmId;
	var obj=document.getElementById("GetSpecItemInfo");
	if (obj) var encmeth=obj.value;
	return;		
	//alert('aa')
	var iOEOriId=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","GetIfHadLCT",CRMId);
	var Info=cspRunServerMethod(encmeth,CRMId,iOEOriId);
	//alert("CRMId=="+CRMId+"  iOEOriId=="+iOEOriId+"  Info=="+Info);
	if (Info=="NoPayed"){
		
		alert("����û�и�����Ŀ�����ܴ�ӡ")
		return false;
	}
	PrintBarRis(Info);		
}
//��ӡ��������
function SpecItemPrint(iIAdmId,BloodType)
{
	var obj=document.getElementById("GetSpecItemInfo");
	if (obj) var encmeth=obj.value;
			
	var Info=cspRunServerMethod(encmeth,iIAdmId,"",BloodType);
	//alert(iIAdmId+"^"+Info+"^"+BloodType)
	if (Info=="NoPayed"){
		
		alert("����û�и�����Ŀ�����ܴ�ӡ")
		return false;
	}
	PrintBarRis(Info);
	
}
//��ӡ����
function PisRequestPrint(iIAdmId)
{
	
	//�ж��Ƿ���Ҫ��ӡ  VIP ����Ŀ��
	//var PrintFlag=tkMakeServerCall("web.DHCPE.RisRequestPrint","PISPrintFlag",iIAdmId);
	//if (PrintFlag=="0") continue;
	PrintByTemplate(iIAdmId);	//DHCPEIAdmItemStatusAdms.RequestPrint.js
	
}
function nextfocus() {
	
	var eSrc=window.event.srcElement;
	var key=websys_getKey(e);
	if (key==13) {
		websys_nexttab(eSrc.tabIndex);
	}
	
}

//����������Ϣ
function Clear_click(Type,RegNo) {
	var obj;
	
	obj=document.getElementById("IBIUpdateModel");
	
	if (obj && "NoGen"==obj.value) {
		obj=document.getElementById("PAPMINo");
		if (obj&&RegNo!="") { 
		//obj.disabled=false;
		$("#PAPMINo").attr('disabled',true);
		
		obj.value=RegNo; }
		if (Type!=1){IBIClear_click();}
		obj=document.getElementById("GroupDesc");
	     if (obj) { obj.value=""; }

	    obj=document.getElementById("TeamDesc");
	    if (obj) { obj.value=""; }

		obj=document.getElementById("GroupDR");
	     if (obj) { obj.value=""; }

	    obj=document.getElementById("TeamDR");
	    if (obj) { obj.value=""; }


		 $("#CardTypeNew").val("");
		websys_setfocus("Name");
		 var ref="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreIBaseInfo.Edit";
		//location.href=ref;
		var src="../images/uiimages/patdefault.png"
	    //PEShowPicBySrc(src,"","imgPic");

		return;
	}
	
	if (obj && "Gen"==obj.value) {
		obj=document.getElementById("PAPMINo");
		if (obj) { obj.disabled=false; }
		IBIClear_click();
		var src="../images/uiimages/patdefault.png"
	    PEShowPicBySrc(src,"","imgPic");
		websys_setfocus("PAPMINo");

		return;
	}
	if (obj && "FreeCreate"==obj.value) {
		obj=document.getElementById("PAPMINo");
		if (obj) { obj.disabled=false; }
		IBIClear_click();
		var src="../images/uiimages/patdefault.png"
	    PEShowPicBySrc(src,"","imgPic");
		websys_setfocus("PAPMINo");

		return;
	}	
	
}

function IDCard_keydown(e)
{
	var key=websys_getKey(e);
	if (13==key) {
		ChangeIDCard();
	}
}
function ChangeIDCard()
{
	var obj=document.getElementById("IDCard");
	var num=obj.value;
	var iRowId="";
	obj=document.getElementById("RowId");
	if (obj) { iRowId=obj.value; }
	if (iRowId!="") return false;
	
	var iPAPMICardType=""
	iPAPMICardType=$("#PAPMICardType_DR_Name").combobox('getText');
	if((iPAPMICardType.indexOf("���֤")!="-1")&&(num!="")){
		var ret=isIdCardNo(num);
		if(ret==true){GetInfoByIdCard(num)}
	}

	var RegNo=tkMakeServerCall("web.DHCPE.PreIBaseInfo","GetRegNoByIDCard",num);
	if (RegNo==""){
		return false;
	}
	var obj=document.getElementById("PAPMINo");
	if (obj){
		obj.value=RegNo;
		RegNoChange();
	}
	
	return false;
	
	
}
function GetInfoByIdCard(num)
{
	
	if (num=="") return true;
	var len = num.length;
	var re;	
	var ShortNum=num.substr(0,num.length-1)
	var ShortNum=ShortNum+"1"
	if (len == 15) re = new RegExp(/^(\d{6})()?(\d{2})(\d{2})(\d{2})(\d{2})$/);
	else if (len == 18) re = new RegExp(/^(\d{6})()?(\d{4})(\d{2})(\d{2})(\d{3})(\d)$/);
	var a = (ShortNum).match(re);
	if (a != null)
	{
	if (len==15)
		{
			var D = new Date("19"+a[3]+"/"+a[4]+"/"+a[5]);
			var B = D.getFullYear()==a[3]&&(D.getMonth()+1)==a[4]&&D.getDate()==a[5];
		}
		else
		{
			var D = new Date(a[3]+"/"+a[4]+"/"+a[5]);
			var B = D.getFullYear()==a[3]&&(D.getMonth()+1)==a[4]&&D.getDate()==a[5];
		}
		var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
		if (dtformat=="YMD"){
			var mybirth=a[3]+"-"+a[4]+"-"+a[5];
		}else if (dtformat=="DMY"){
			var mybirth=a[5]+"/"+a[4]+"/"+a[3];
		}
       
		var obj=document.getElementById("DOB");
		if(obj){obj.value=mybirth;}

		var Dateinit=new Date          	
        var Yearinit=Dateinit.getFullYear();
	    var Year=Yearinit-a[3]
		
		var myAge=tkMakeServerCall("web.DHCDocCommon","GetAgeDescNew",mybirth,"")
		DHCWebD_SetObjValueA("Age",myAge);

		if (len==15)
		{
			var SexFlag=num.substr(14,1);
		}
		else
		{
			var SexFlag=num.substr(16,1);
		}
		var SexNV=""
		var obj=document.getElementById("SexNV");
		if (obj) SexNV=obj.value;
		SexNV=SexNV.split("^");
		if (SexFlag%2==1)
		{
			$("#Sex_DR_Name").combobox('setValue',SexNV[2]);
			
		}
		else
		{
			$("#Sex_DR_Name").combobox('setValue',SexNV[3]);
			
		}
		
	}
	return true;
}
///�ж����֤��?�����������Ϊ���Զ���������
/*
function isIdCardNo(num) {
	if (num=="") return true;
	var ShortNum=num.substr(0,num.length-1)
	if (isNaN(ShortNum))
	{
		alert("����Ĳ�������?");
		return false;
	}
	var len = num.length;
	var re;
	//if (len == 15) re = new RegExp(/^(\d{6})()?(\d{2})(\d{2})(\d{2})(\d{3})$/);
	if (len == 15) re = new RegExp(/^(\d{6})()?(\d{2})(\d{2})(\d{2})(\d{2})$/);
	else if (len == 18) re = new RegExp(/^(\d{6})()?(\d{4})(\d{2})(\d{2})(\d{3})(\d)$/);
	else {
		alert("���֤�����������λ������?");
		websys_setfocus("IDCard");
		return false;
		}
	var ShortNum=ShortNum+"1"
	var a = (ShortNum).match(re);
	if (a != null)
	{
		if (len==15)
		{
			var D = new Date("19"+a[3]+"/"+a[4]+"/"+a[5]);
			var B = D.getFullYear()==a[3]&&(D.getMonth()+1)==a[4]&&D.getDate()==a[5];
		}
		else
		{
			var D = new Date(a[3]+"/"+a[4]+"/"+a[5]);
			var B = D.getFullYear()==a[3]&&(D.getMonth()+1)==a[4]&&D.getDate()==a[5];
		}
		if (!B)
		{
			alert("��������֤�� "+ a[0] +" ��������ڲ���?");
			websys_setfocus("IDCard"); //DGV2DGV2
			return false;
		}
		
		var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
		if (dtformat=="YMD"){
			var mybirth=a[3]+"-"+a[4]+"-"+a[5];
		}else if (dtformat=="DMY"){
			var mybirth=a[5]+"/"+a[4]+"/"+a[3];
		}
       
		var obj=document.getElementById("DOB");
		if(obj){obj.value=mybirth;}

		var Dateinit=new Date           //add by zhouli start	�������֤�ź�tab�������Զ���������	
        //var Yearinit=Dateinit.getYear()
        var Yearinit=Dateinit.getFullYear();
	    var Year=Yearinit-a[3]
		//var obj=document.getElementById("Age");
		//if (obj) obj.value=Year;       //add by zhouli end 
		var myAge=tkMakeServerCall("web.DHCDocCommon","GetAgeDescNew",mybirth,"")
		DHCWebD_SetObjValueA("Age",myAge);

		if (len==15)
		{
			var SexFlag=num.substr(14,1);
		}
		else
		{
			var SexFlag=num.substr(16,1);
		}
		var SexNV=""
		var obj=document.getElementById("SexNV");
		if (obj) SexNV=obj.value;
		SexNV=SexNV.split("^");
		var obj=document.getElementById("Sex_DR_Name");
		if (SexFlag%2==1)
		{
			obj.value=SexNV[2];
		}
		else
		{
			obj.value=SexNV[3];
		}
		
	}
	return true;
}
*/
function isIdCardNo(pId){
	pId=pId.toLowerCase();
    var arrVerifyCode = [1,0,"x",9,8,7,6,5,4,3,2]; 
    var Wi = [7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2]; 
    var Checker = [1,9,8,7,6,5,4,3,2,1,1]; 
    if(pId.length != 15 && pId.length != 18){
		 $.messager.alert("��ʾ","���֤�Ź���15λ��18λ","info");
		return false;
    }
    var Ai=pId.length==18?pId.substring(0,17):pId.slice(0,6)+"19"+pId.slice(6,15); 
    
    if (!/^\d+$/.test(Ai))
    {
	     $.messager.alert("��ʾ","���֤�����һλ�����Ϊ����","info");
    	return false;
    }
    var yyyy=Ai.slice(6,10), mm=Ai.slice(10,12)-1, dd=Ai.slice(12,14);
    var d=new Date(yyyy,mm,dd) , now=new Date(); 
    var year=d.getFullYear() , mon=d.getMonth() , day=d.getDate();
    if (year!=yyyy||mon!=mm||day!=dd||d>now||year<1901){
	    $.messager.alert("��ʾ","���֤�������","info");
	    return false;
    }
	for(var i=0,ret=0;i<17;i++) ret+=Ai.charAt(i)*Wi[i]; 
	Ai+=arrVerifyCode[ret%=11];
	
	if (pId.length == 18){
		if(!validId18(pId)){
			 $.messager.alert("��ʾ","���֤��������,����!","info");
			return false;
		}
	}
	if (pId.length == 15){
		if(!validId15(pId)){
			 $.messager.alert("��ʾ","���֤��������,����!","info");
			return false;
		}
	}
	return true;
}

function GetInfoFromIDCard(pId){
	 
    var pId=Get18IdFromCardNo(pId)
    if (pId==""){
			return ["0","","","","","",""];
		}
	
    var id=String(pId);
    if (id.length==18){
	    var sex=id.slice(14,17)%2?"��":"Ů";
			///prov=areaCode[id.slice(0,6)] || areaCode[id.slice(0,4)] || areaCode[id.slice(0,2)] || "δ֪����";
	    var prov="";
	    ///var birthday=(new Date(id.slice(6,10),id.slice(10,12)-1,id.slice(12,14))).toLocaleDateString();
	    var myMM=(id.slice(10,12)).toString();
	    var myDD=id.slice(12,14).toString();
	    var myYY=id.slice(6,10).toString();
	  }else{
	  	var prov="";
	  	var sex=id.slice(14,15)%2?"��":"Ů";
	    var myMM=(id.slice(8,10)).toString();
	    var myDD=id.slice(10,12).toString();
	    var myYY=id.slice(6,8).toString();
			if(parseInt(myYY)<10) {
				myYY = '20'+myYY;
			}else{
				myYY = '19'+myYY;
			} 
	    
	  }
    var myMM=myMM.length==1?("0"+myMM):myMM;
    var myDD=myDD.length==1?("0"+myDD):myDD;
    var sysDateFormat=tkMakeServerCall('websys.Conversions','DateFormat');
    if (sysDateFormat=="3"){
	    var birthday=myYY+"-"+ myMM +"-"+myDD;
	}
    if (sysDateFormat=="4"){
	    var birthday=myDD+"/"+ myMM +"/"+myYY;
	}
    var myAge=DHCWeb_GetAgeFromBirthDayA(birthday);
    
    return ["1",prov,birthday,sex, myAge];
}

function Get18IdFromCardNo(pId){
	
	pId=pId.toLowerCase();
	
    var arrVerifyCode = [1,0,"x",9,8,7,6,5,4,3,2]; 
    var Wi = [7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2]; 
    var Checker = [1,9,8,7,6,5,4,3,2,1,1]; 

    if(pId.length != 15 && pId.length != 18){
		alert("���֤�Ź��� 15λ��18λ"); 
		return "";
    }
	if (pId.length == 18){
		if(!validId18(pId)){
			alert("���֤��������,����!");
			return "";
		}
	}
	if (pId.length == 15){
		if(!validId15(pId)){
			alert("���֤��������,����!");
			return "";
		}
	}
    var Ai=pId.length==18?pId.substring(0,17):pId.slice(0,6)+"19"+pId.slice(6,15); 
    
    if (!/^\d+$/.test(Ai))
    {
    	alert("���֤�����һλ�����Ϊ����");
    	return "";
    }
    var yyyy=Ai.slice(6,10), mm=Ai.slice(10,12)-1, dd=Ai.slice(12,14);
    var d=new Date(yyyy,mm,dd) , now=new Date(); 
    var year=d.getFullYear() , mon=d.getMonth() , day=d.getDate();
    if (year!=yyyy||mon!=mm||day!=dd||d>now||year<1901){
	    alert( "���֤�������");
	    return "";
    }
    
    
	for(var i=0,ret=0;i<17;i++) ret+=Ai.charAt(i)*Wi[i]; 
	Ai+=arrVerifyCode[ret%=11];
	
	return Ai;
}


//��֤�绰���ƶ��绰
function CheckTelOrMobile(telephone,Name,Type){
	if (isMoveTel(telephone)) return true;
	if (telephone.indexOf('-')>=0){
		$.messager.alert("��ʾ",Type+"�̶��绰���ȴ���,�̶��绰���ų���Ϊ��3����4��λ,�̶��绰���볤��Ϊ��7����8��λ,�������ӷ���-������,���ʵ!","info",function(){
			$("#"+Name).focus();
		});
        return false;
	}else{
		if(telephone.length!=11){
			$.messager.alert("��ʾ",Type+"��ϵ�绰�绰����ӦΪ��11��λ,���ʵ!","info",function(){
				$("#"+Name).focus();
			});
	        return false;
		}else{
			$.messager.alert("��ʾ",Type+"�����ڸúŶε��ֻ���,���ʵ!","info",function(){
				$("#"+Name).focus();
			});
	        return false;
		}
	}
	return true;
}
/* 
��;����������Ƿ���ȷ�ĵ绰���ֻ��� 
���룺 �绰��
value���ַ��� 
���أ� ���ͨ����֤����true,���򷵻�false 
*/  
function isMoveTel(telephone){
 	
	var teleReg1 = /^((0\d{2,3})-)(\d{7,8})$/;
	var teleReg2 = /^((0\d{2,3}))(\d{7,8})$/; 
	var mobileReg =/^1[3|4|5|6|7|8|9][0-9]{9}$/;
	if (!teleReg1.test(telephone)&& !teleReg2.test(telephone) && !mobileReg.test(telephone)){ 
		return false; 
	}else{ 
		return true; 
	} 

}
/*
///�ж��ƶ��绰
function isMoveTel(elem){
	
	if (elem=="") return true;
	//var pattern=/^0{0,1}13|15|18|14|17[0-9]{9}$/;
	var pattern=/^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$/;
	
	if(pattern.test(elem)){   
	return true;
	}else{
	
  	alert("�ƶ��绰���벻��ȷ");
	return false;
 	}
}
*/
//�̶��绰(С��ͨ????��ͥ�绰)
function isFixTel(elem){
 var pattern=/(^[0-9]{3,4}\-[0-9]{3,8}$)|(^[0-9]{3,8}$)|(^\([0-9]{3,4}\)[0-9]{3,8}$)/;
 if(pattern.test(elem)){
  return true;
 }else{
  //alert("�绰�����ʽ����ȷ");
  return false;
 }
}

//�绰����(���϶���)
function  isTel(elem){
 var pattern=/(^[0-9]{3,4}\-[0-9]{3,8}$)|(^[0-9]{3,8}$)|(^\([0-9]{3,4}\)[0-9]{3,8}$)|(^0{0,1}13[0-9]{9}$)/;
 if(pattern.test(elem)){
  return true;
 }else{
  //elert("�绰�����ʽ����ȷ");
  return false;
 }
}
/*
function Birth_OnBlur(){
	alert("1")
	var mybirth=DHCWebD_GetObjValue("DOB");
	alert(mybirth)
	if ((mybirth!="")&&((mybirth.length!=8)&&((mybirth.length!=10)))){
		var obj=document.getElementById("DOB");
		alert("��������ȷ������");
	
	}else{
	
	}
	if ((mybirth.length==8)){
		var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8)
		DHCWebD_SetObjValueA("DOB",mybirth);
	}
	if (mybirth!=""){
	var myrtn=DHCWeb_IsDate(mybirth,"-")
	if (!myrtn){
		var obj=document.getElementById("DOB");
		////obj.className='clsInvalid';
		alert("��������ȷ������");
		websys_setfocus("DOB");
		return websys_cancel();
	}else{
		
	}
	}
	if (myrtn){
		var myAge=DHCWeb_GetAgeFromBirthDay("DOB");
		var obj=document.getElementById("Age");
		if (obj){obj.value=myAge}
		
	}

}
*/
function DOB_OnBlur()
{
	
	var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
	var mybirth=$("#DOB").val();
	if ((mybirth!="")&&((mybirth.length!=8)&&((mybirth.length!=10)))){
		$.messager.alert("��ʾ","��������ȷ�ĳ�������!","info",function(){
			$("#DOB").addClass("newclsInvalid"); 
			$("#DOB").focus();
		});
		return false;
	}
	$("#DOB").removeClass("newclsInvalid")
	if ((mybirth.length==8)){
	
		if (dtformat=="YMD"){
			var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8)
		}
		if (dtformat=="DMY"){
			var mybirth=mybirth.substring(6,8)+"/"+mybirth.substring(4,6)+"/"+mybirth.substring(0,4)
		}
       $("#DOB").val(mybirth)
		
	}
    if (mybirth!="") {
		if (dtformat=="YMD"){
			var reg=/^(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)$/;
		}
		if (dtformat=="DMY"){
			var reg=/^(((0[1-9]|[12][0-9]|3[01])\/((0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)\/(0[469]|11))|(0[1-9]|[1][0-9]|2[0-8])\/(02))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(29\/02\/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))$/;
		}
		var ret=mybirth.match(reg);
	  if(ret==null){
		    $.messager.alert("��ʾ","��������ȷ�ĳ�������!","info",function(){
				$("#DOB").addClass("newclsInvalid"); 
				$("#DOB").focus();
			});
			return false;
		}
	    if (dtformat=="YMD"){
		  var myrtn=DHCWeb_IsDate(mybirth,"-")
	  }
	  if (dtformat=="DMY"){
		  var myrtn=DHCWeb_IsDate(mybirth,"/")
	  }

	//var myrtn=DHCWeb_IsDate(mybirth,"-")
	if (!myrtn){
	
		$.messager.alert("��ʾ","��������ȷ�ĳ�������!","info",function(){
				$("#DOB").addClass("newclsInvalid"); 
				$("#DOB").focus();
			});
			return false;
			
	}else{
			var mybirth1=$("#DOB").val();
			var Checkrtn=CheckBirth(mybirth1);
			if(Checkrtn==false){
				$.messager.alert("��ʾ","�������ڲ��ܴ��ڽ������С�ڡ�����1840��!","info",function(){
					$("#DOB").addClass("newclsInvalid"); 
					$("#DOB").focus();
				});
				return false;
			}
			var myAge=DHCWeb_GetAgeFromBirthDay("DOB");
			$("#Age").val(myAge);
		}
	}else{
		$("#DOB").removeClass("newclsInvalid");
	}
	

}
function findNameAfter(value)
{
	if (value=="") return;
	var RegNo=value.split("^")[1];
	obj=document.getElementById("PAPMINo");
	obj.value=RegNo;
	RegNoChange();
}
function intKeydown()
{	

	
	var myCount=myItemNameAry.length;
	for (var myIdx=0;myIdx<myCount;myIdx++){
		if ((myItemNameAry[myIdx]!="PAPMINo")&&(myItemNameAry[myIdx]!="Name")&&(myItemNameAry[myIdx]!="CardNo")){
		
			
			var myobj=document.getElementById(myItemNameAry[myIdx]);
			if (myobj){
				myobj.onkeydown = nextfocus;
			}
		}
	}	

		
}
function CheckBirth(Birth)
{
	var Year,Mon,Day,Str;
	var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
	if (dtformat=="YMD"){
			Str=Birth.split("-")
			Year=Str[0];
			Mon=Str[1];
			Day=Str[2];
			
		}
		if (dtformat=="DMY"){
			Str=Birth.split("/")
			Year=Str[2];
			Mon=Str[1];
			Day=Str[0];
			
		}

	
	var Today,ToYear,ToMon,ToDay;
	Today=new Date();
	//ToYear=Today.getYear();
	ToYear=Today.getFullYear();
	ToMon=(Today.getMonth()+1);
	ToDay=Today.getDate();
	if((Year > ToYear)||(Year<=1840)){
		return false;
	}
	else if((Year==ToYear)&&(Mon>ToMon)){
		return false;
	}
	else if((Year==ToYear)&&(Mon==ToMon)&&(Day>ToDay)){
		return false;
	}
	else return true;
}
function SetGroup(value)
{
	///alert(value);
	list=value.split("^");
	var obj=document.getElementById("GroupDR");
	if (obj){obj.value=list[1]}
		
}
function SetTeam(value)
{
	///alert(value);
	list=value.split("^");
	var obj=document.getElementById("TeamDR");
	if (obj){obj.value=list[1]}
	var obj=document.getElementById("TeamDesc");
	if (obj){obj.value=list[4]}
}
function CleanGroup()
{
	var obj=document.getElementById("GroupDR");
	if (obj){obj.value=""}
	var obj=document.getElementById("TeamDR");
	if (obj){obj.value=""}
	var obj=document.getElementById("TeamDesc");
	if (obj){obj.value=""}
}
function CleanTeam()
{
	var obj=document.getElementById("TeamDR");
	if (obj){obj.value=""}
	
}

function BPhoto_click()
{   
   var PAPMINo ="" 
    PAPMINo=getValueById('PAPMINo')
    
	//����Ϊjpg�ļ�
	var PatientID=tkMakeServerCall("web.DHCPE.PreIADM","GetPatientID",PAPMINo);

	if(PatientID==""){
		$.messager.alert("��ʾ","������ϢID����Ϊ�ա�","info");
		return;
	}

	var lnk="dhcpephoto.csp?RegNo="+PAPMINo;
	var ret=window.showModalDialog(lnk, "", "dialogwidth:800px;dialogheight:600px;center:1"); 
	InitPicture()
}
function BPhoto_clickBak()
{   
    var PAPMINo ="" 
    var obj=document.getElementById('PAPMINo');
    if(obj){PAPMINo=obj.value}
	//����Ϊjpg�ļ�
	var Ins=document.getElementById('GetPatientID');
	if (Ins) { var encmeth=Ins.value} else {var encmeth=''};
	var PatientID=cspRunServerMethod(encmeth,PAPMINo);
	if(PatientID==""){
		alert("������ϢID����Ϊ��.");
		return;
	}
	var PicHeight=300;
	var Picwidth=200;
	if (PhotoFtpInfo==""){
		PEPhoto.FTPFlag="0" //�Ƿ��ϴ���ftp������  0
	}else{
		var FTPArr=PhotoFtpInfo.split("^");
		PEPhoto.DBFlag = "0" //�Ƿ񱣴浽���ݿ�  0  1
		PEPhoto.FTPFlag = "1" //�Ƿ񱣴浽FTP  0  1
		PEPhoto.AppName = FTPArr[4]+"/" //ftpĿ¼
		PEPhoto.FTPString = FTPArr[0]+"^"+FTPArr[1]+"^"+FTPArr[2]+"^"+FTPArr[3] //FTP������
		PicHeight=FTPArr[5];
		Picwidth=FTPArr[6];
	}
	PEPhoto.PicWidth=Picwidth;
	PEPhoto.PicHeight=PicHeight;
	PEPhoto.PatientID=PatientID //PA_PatMas���ID
	PEPhoto.ShowWin()
	
	InitPicture()
}
function InitPicture()
{
	
    var PAPMINo ="" 
    var obj=document.getElementById('PAPMINo');
    if(obj){PAPMINo=obj.value}
	//����Ϊjpg�ļ�
	var Ins=document.getElementById('GetPatientID');
	if (Ins) { var encmeth=Ins.value} else {var encmeth=''};
	var PatientID=cspRunServerMethod(encmeth,PAPMINo);
	
	PEShowPicByPatientID(PatientID,"imgPic")  //DHCPECommon.js
	//var src=PicFilePath+PatientID+picType
	//document.getElementById("imgPic").innerHTML='<img SRC='+src+' BORDER="0" width=110 height=160>&nbsp;'
  
}
function Name_keydown(e) {
	var key=websys_getKey(e);
	if (13==key) {
		NameChange();
		nextfocus();
	}
	
}
function NameChange() {
	var iName="";
	var obj=document.getElementById('Name');
	if (obj && ""!=obj.value) { iName = obj.value; }
	else { return false; }

	var info=tkMakeServerCall("web.DHCPE.PreIBaseInfo","GetPersonInfo",iName);
	//alert("info:"+info)
	if (info==0) return;
	
	//FindPatDetailByName(iName);
}

function FindPatDetailByName(iName){
	
	
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEPreIBI.List"
			+"&PatName="+iName;
    //alert(lnk)
	var wwidth=800;
	var wheight=500;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	//var cwin=window.open(lnk,"_blank",nwin)	
	window.open(lnk,"_blank",nwin)
	
	
}
function TransRegNo(RegNo){
	var obj=document.getElementById("PAPMINo");
	obj.value=RegNo;
	RegNoChange();
}
// ��ӡ���쵥A4
//document.write("<script language='javascript' src='../SCRIPTS/DHCPEPrintDJDCommon.js'></script>")
function PatItemPrint(CRMId)  
{
	var Instring=CRMId+"^"+""+"^CRM"+"^"+"";
	 var PAADM=tkMakeServerCall("web.DHCPE.DHCPECommon","GetPaadmByPIADM",CRMId)
	 if(PAADM==""){
		 $.messager.alert("��ʾ","����IDΪ��","info")
		 return;
	 }

	/* var Ins=document.getElementById('GetOEOrdItemBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,'','',Instring);
	 Print(value,1,1);
	 */
	  PEPrintDJD("P",PAADM,"");//DHCPEPrintDJDCommon.js lodop��ӡ
}

//��ӡ����
document.write("<script language='javascript' src='../scripts/nurse/DHCNUR/DHCNurPrintClickOnce.js'></script>");
function BarCodePrint(iTAdmId,OrderFlag)
{
	//alert(OrderFlag)
	var CRMId=iTAdmId;
	var InString=CRMId+"^";
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
		
	}else{
	//s val=##Class(%CSP.Page).Encrypt($lb("web.DHCPE.Query.IAdmItemStatus.PatOrdItemInfo"))
	var Ins=document.getElementById("PatOrdItemInfo");
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,"","",InString,"Y","N",OrderFlag);
	
	BarPrint(flag);
	}

	
}

//���˻�����Ϣ��ӡ
function PrintPatBaseInfo(CRMId)
{ 
	//RegNo^Name^Sex^Age^PatLoc$C(1)^
	//String.fromCharCode(1)
	var obj;
	var RegNo="",Name="",Sex="",Age="",SexNV=""
	obj=document.getElementById("PAPMINo");
	if (obj) RegNo=obj.value;
	obj=document.getElementById("Name");
	if (obj) Name=obj.value;
	obj=document.getElementById("Sex_DR_Name");
	if (obj) Sex=obj.value;
	obj=document.getElementById("SexNV");
	if (obj) SexNV=obj.value;
	var SexNVArr=SexNV.split("^");
	if (Sex==SexNVArr[0]){
		Sex="Ů";
	}else{
		Sex="��";
	}
	obj=document.getElementById("Age");
	if (obj) Age=obj.value;
	
	var Amount=tkMakeServerCall("web.DHCPE.HandlerPreOrds","IGetAmount4Person",CRMId); 
	var FactAmount=Amount.split('^')[1]+'Ԫ';
	var NewHPNo=tkMakeServerCall("web.DHCPE.Query.IAdmItemStatus","GetHPNoByPreIADM",CRMId);
	
	var Info=RegNo+"^"+Name+" "+FactAmount+"^"+"^"+"^"+"^"+Sex+String.fromCharCode(1)+"^"+Age+"^"+RegNo+"^"+NewHPNo;
	PrintBarRis(Info)
	
}


function BarPrint(value) {
 
    if (""==value) {
		//alert("δ�ҵ�������Ŀ");
		return false;
	}

	/*
	if (value=="NoPayed")
	{
		alert(t["NoPayed"])
		return false;
	}
	*/
	var ArrStr=value.split("$$");
	var Num=0
	if (ArrStr.length>1) Num=ArrStr[1];
	value=ArrStr[0];
	PrintBarApp(value,"")
	return;	
}
function ReadInsuCard_Click()
{
	var CardType=1;
	var rtnInsuCardInfo=ReadINSUCard("",CardType);
	if(rtnInsuCardInfo==""){alert("��ȡҽ����ʧ��?"); return;}
	//var rtnInsuCardInfo="0|3990003311^3990004522^^���ݲ���^1^^^130302193302020021^39901101^^^����^80^QHDA^0^0^0|^^^|"
	var InsuArr=rtnInsuCardInfo.split("|");
	if(InsuArr[0]!=0){alert("��ȡҽ����ʧ��?");return;}
	var InsuArr1=InsuArr[1].split("^");
	//if(InsuArr1[7]=="") 
	var BirthDay=InsuArr1[6].split(" ")[0];
	if (InsuArr1[7].length==18){
		var BirthDay=InsuArr1[7].substring(6,10)+"-"+InsuArr1[7].substring(10,12)+"-"+InsuArr1[7].substring(12,14);
	} else if(InsuArr1[7].length==15) {
		var BirthDay="19"+InsuArr1[7].substring(6,8)+"-"+InsuArr1[7].substring(8,10)+"-"+InsuArr1[7].substring(10,12);
	}
	
	DHCWebD_SetObjValueC("DOB",BirthDay);
	var myAge=DHCWeb_GetAgeFromBirthDay("DOB");
	DHCWebD_SetObjValueA("Age",myAge);
	
	var PatYBCode,Name,Sex,Birth,Age,CredNo,EmployeeCompany,PatType;
	//ת��
	if (InsuArr1[4]==2){
		Sex=1;
	}else if (InsuArr1[4]==1){
		Sex=2;
	}else{
		Sex=4;
	}
	Obj=document.getElementById('Sex_DR_Name');
	if(Obj)
	{
		Obj.value=Sex;
		}
		
	
	if (InsuArr1[12]==50){PatType=2;}
	if (InsuArr1[12]==60){PatType=3;}
	if (InsuArr1[12]==80){PatType=4;}
	if (InsuArr1[12]==70){PatType=4;}
	DHCWebD_SetObjValueA("Name",InsuArr1[3]);
	Obj=document.getElementById('PatType_DR_Name');
	if(Obj)
	{
		Obj.value=PatType;
		}
    DHCWebD_SetObjValueA("Company",InsuArr1[8]);		
	DHCWebD_SetObjValueA("IDCard",InsuArr1[7]);	
	DHCWebD_SetObjValueA("MedicareCode",InsuArr1[0]);	
	

}
function Doc_OnKeyDown()
   {   
	   if (event.keyCode==115)
       {
		ReadRegInfo_OnClick();
       }
   }
function ReadRegInfo_OnClick()
  {
	  var GroupDesc,GroupDR,TeamDesc,TeamDR;
	  var obj=document.getElementById("GroupDR");
		if (obj){GroupDR=obj.value}
		 var obj=document.getElementById("GroupDesc");
		if (obj){GroupDesc=obj.value}
	var obj=document.getElementById("TeamDR");
	if (obj){TeamDR=obj.value}
	var obj=document.getElementById("TeamDesc");
	if (obj){TeamDesc=obj.value}
	
	
   //var myInfo=ClsIDCode.ReadPersonInfo();
     var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
	 var rtn=tkMakeServerCall("DHCDoc.Interface.Inside.Service","GetIECreat")
	var myHCTypeDR=rtn.split("^")[0];
	var myInfo=DHCWCOM_PersonInfoRead(myHCTypeDR);

   var myary=myInfo.split("^");
    
     if (myary[0]=="0")
    { 
      SetPatInfoByXML(myary[1]); 
	     
		 //Sex �Ա�
          var mySexobj=document.getElementById("Sex");
      if (mySexobj){$("#Sex_DR_Name").combobox('setValue',mySexobj.value);}
		
		//NationDesc ����
	   var myNationDescobj=document.getElementById("NationDesc");
	   if (myNationDescobj){
		  var NationDR=tkMakeServerCall("web.DHCPE.PreCommon","GetNationDR",myNationDescobj.value)
		   $("#CTNationDR").combobox('setValue',NationDR);
	   }

		//��ϵ��ַ
		var myAddressobj=document.getElementById("Address");
	    var Addressobj=document.getElementById('Address'); 
	    if ((myAddressobj)&&(Addressobj)){
			Addressobj.value=myAddressobj.value; 
		}
     
	 //��������
	  var myBirobj=document.getElementById("Birth");
	    if(myBirobj){
	    var mybirth=myBirobj.value;
		 if(mybirth!=""){
		  if (dtformat=="YMD"){
			 if (mybirth.length==10){
			var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(5,7)+"-"+mybirth.substring(8,10)
 	 		}else{
 			var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8) 
  			}
		}
		if (dtformat=="DMY"){
			if (mybirth.length==10){
				var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(5,7)+"-"+mybirth.substring(8,10)
  			}else{
				var mybirth=mybirth.substring(6,8)+"/"+mybirth.substring(4,6)+"/"+mybirth.substring(0,4)
 			}
		}
		 }
	  }
    if (myBirobj){$("#DOB").val(mybirth);}

		
		 //ʹ�ö�ȡ����Ƭ�����ļ�
	var photoobj=document.getElementById("PhotoInfo");
	if ((photoobj)&&(photoobj.value!="")){var src="data:image/png;base64,"+photoobj.value}
	else{var src='c://'+mycredobj.value+".bmp"}
	ShowPicBySrcNew(src,"imgPic");

	  var mycredobj=document.getElementById("CredNo");
	  var myidobj=document.getElementById('IDCard');
		if ((mycredobj)&&(myidobj)){
			myidobj.value=mycredobj.value;
			var RegNo=tkMakeServerCall("web.DHCPE.PreIBaseInfo","GetRegNoByIDCard",myidobj.value);
			if (RegNo==""){
				return false;
			}else{
				var obj=document.getElementById("PAPMINo");
				if (obj){
					obj.value=RegNo;
					RegNoChange();
				}
			}
		}
		
		
     }
     
    
     var obj=document.getElementById("GroupDR");
		if (obj){obj.value=GroupDR}
		 var obj=document.getElementById("GroupDesc");
		if (obj){obj.value=GroupDesc}
	var obj=document.getElementById("TeamDR");
	if (obj){obj.value=TeamDR}
	var obj=document.getElementById("TeamDesc");
	if (obj){obj.value=TeamDesc}
     
    IDReadControlDisable(true);
     
   }
function IDReadControlDisable(bFlag)
{
	
	var myobj=document.getElementById("IDCard");
	if (myobj){
		myobj.readOnly=bFlag;
	}
	var myobj=document.getElementById("Name");
	if (myobj){
		myobj.readOnly=bFlag;
	}
	var myobj=document.getElementById("Sex_DR_Name");
	if (myobj){
		myobj.readOnly=bFlag;
	}

	var myobj=document.getElementById("DOB");
	if (myobj){
		myobj.readOnly=bFlag;
	}
	var myobj=document.getElementById("Address");
	if (myobj){
		myobj.readOnly=bFlag;
	}
	var myobj=document.getElementById("Age");
	if (myobj){
		myobj.readOnly=bFlag;
	}
	
}

function SetPatInfoByXML(XMLStr)
{
	///XMLStr ="<PatInfo>"+XMLStr;
	///XMLStr +="</PatInfo>";
	XMLStr ="<?xml version='1.0' encoding='gb2312'?>"+XMLStr
	
	var xmlDoc=DHCDOM_CreateXMLDOM();
	xmlDoc.async = false;
	xmlDoc.loadXML(XMLStr);
	if(xmlDoc.parseError.errorCode != 0) 
	{    
		$.messager.alert("��ʾ",xmlDoc.parseError.reason,"info");
		//alert(xmlDoc.parseError.reason); 
		return; 
	}

	var nodes = xmlDoc.documentElement.childNodes; 
	for(var i=0; i<nodes.length; i++) 
	{
		
		var myItemName=nodes(i).nodeName;
		var myItemValue= nodes(i).text;
		if (myCombAry[myItemName]){
			myCombAry[myItemName].setComboValue(myItemValue);

		}else{
			DHCWebD_SetObjValueXMLTrans(myItemName, myItemValue);
		}
	}
	delete(xmlDoc);
}
//��������
function  IsPostalcode(elem){
if (elem=="") return true;
 var pattern=/[0-9]\d{5}(?!\d)/;
 if(pattern.test(elem)){
  return true;
 }else{
   $.messager.alert("��ʾ","���������ʽ����ȷ","info");
   //alert("���������ʽ����ȷ");
  return false;
 }
}
//�������� 
function  IsEMail(elem){
if (elem=="") return true;
 var pattern=/^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
 if(pattern.test(elem)){
  return true;
 }else{
	 $.messager.alert("��ʾ","���������ʽ����ȷ","info");
  return false;
 }
}


function ChangeGroup()
{
	var obj=document.getElementById("TeamDesc");
	if (obj){obj.value=""}
	var obj=document.getElementById("TeamDR");
	if (obj){obj.value=""}
	
}

document.body.onload = BodyLoadHandler;
