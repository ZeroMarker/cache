
//����	DHCPEDietManager.js
//����	�ͻ��Ͳ�
//���	DHCPEDietManager  	
//����	2018.08.23
//������  xy

var TPEADMID=""
var vRoomRecordID=""
function BodyLoadHandler()
{	
	var obj;
	obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_click;
	
	//����
	obj=document.getElementById("BSend");
	if (obj){obj.onclick=BSend_click;}
	
	//ȡ������
	obj=document.getElementById("BCancelDiet");
	if (obj){obj.onclick=BCancelDiet_click;}

	obj=document.getElementById("CardNo");
	if (obj) {
		obj.onchange=CardNo_Change;
		obj.onkeydown=CardNo_KeyDown;
	}
	
	obj=document.getElementById("RegNo");
	if (obj){ obj.onkeydown=RegNo_KeyDown;}	

	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCard_Click;}
	
	obj=document.getElementById("GroupDesc");
	if (obj) { obj.onchange=GroupDesc_Change; }
	
	obj=document.getElementById("BWaitList");
	if (obj) {obj.onclick=BWaitList_Click;}
	
	obj=document.getElementById("BComplete");
	if (obj) {obj.onclick=BComplete_Click;}
	SetRoomID();
	
}

function BCancelDiet_click()
{

	CancelDiet("0");
	return false;
}
function CancelDiet(Type)
{
	var objtbl=$("#tDHCPEDietManager").datagrid('getRows');
	if(selectrow=="-1"){
		$.messager.alert("��ʾ","��ѡ���ȡ���Ͳ͵���","info");
	     return false;
	     }
	var TPEADMID=objtbl[selectrow].TPEADM;
	var TCount=objtbl[selectrow].TCount;
	if (TPEADMID=="")
	{
		$.messager.alert("��ʾ","��ѡ���ȡ���Ͳ͵���","info");
		return false; 
	}
	
	
	var ReturnStr=tkMakeServerCall("web.DHCPE.DietManager","CancelDiet",TPEADMID,Type,TCount);	
if (ReturnStr=="NCancelDiet")
	{ 
		$.messager.alert("��ʾ","����ȡ���Ͳ�","info");
		return true;
	}
if (ReturnStr=="Success")
	{ 
	  
		$.messager.alert("��ʾ","ȡ���Ͳͳɹ�","success");
		//location.reload();
		 BFind_click();
		return true;
	}
	if (ReturnStr=="CancelDiet")
	{
		$.messager.confirm("ȷ��", "�Ƿ�ȷ��ȡ���Ͳͣ�", function(r){
		if (r){
				CancelDiet("1");
			}
		});
	}
	
	return false;
}


//added by xy 20151023
function RegNo_KeyDown(e){
	var Key=websys_getKey(e);
	if ((13==Key)) {
		        
				var iRegNo="",TPEADMID="",Type=0,obj;
				var CTLocID=session['LOGON.CTLOCID'];
				
				var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength",CTLocID);
				var iRegNo=$("#RegNo").val();
				if(iRegNo==""){
					 $.messager.alert("��ʾ","������ǼǺ�","info"); 
					return false; 
					
				}
				if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
						iRegNo=RegNoMask(iRegNo,CTLocID);
						$("#RegNo").val(iRegNo);
				}
				
				var objtbl=$("#tDHCPEDietManager").datagrid('getRows');
				 var TPEADMID=""
				if((selectrow!="-1")&&(selectrow!="0")){
					var TPEADMID=objtbl[selectrow].TPEADM;
					}
				
				if(iRegNo==""){
					var TPEADMID=TPEADMID;
				}else{
					TPEADMID=iRegNo+"^";
				}
				
				if (TPEADMID=="")
				{
					 $.messager.alert("��ʾ","����ѡ����Ͳ͵���","info"); 
					return false; 
				}
              
				var IsDietFlag=tkMakeServerCall("web.DHCPE.DietManager","IsDietFlag",TPEADMID);
				//alert(IsDietFlag)
			
				if(IsDietFlag=="NCanntDiet")
				{
					 $.messager.alert("��ʾ","û�оͲ�Ȩ��","info"); 
					 return true;
				}
				else if(IsDietFlag=="NoPerson")
				{ 
					$.messager.alert("��ʾ","û��ѡ��Ͳ���Ա������Աû�е���","info");
					return false;
				}else if(IsDietFlag=="CanntDiet"){
					$.messager.alert("��ʾ","��ǰ��Ŀ��δ�����,���ܳԷ�","info");
					return false;
				}else if(IsDietFlag=="HadDiet")
				{
					$.messager.confirm("ȷ��", "�Ѿ��Ͳ�,�Ƿ��ٴξͲͣ�", function(r){
					if (r){
						
						 var ReturnStr=tkMakeServerCall("web.DHCPE.DietManager","UpdateDietNew",TPEADMID,1)
						 if (ReturnStr=="Success")
				         { 
				         	$.messager.alert("��ʾ","�Ͳͳɹ�","success");
					      	BFind_click();
					      	return true;
				          }
						}
					else{
						return false;
					}
					});

					
				}else{
					
					var ReturnStr=tkMakeServerCall("web.DHCPE.DietManager","UpdateDietNew",TPEADMID,0)
					if (ReturnStr=="Success")
					{ 
					
						$.messager.popover({msg: "�Ͳͳɹ�", type: "info"});
						//$.messager.alert("��ʾ","�Ͳͳɹ�","success");
						BFind_click();
						return true;
					}
				
				}
				
				return false;
	}
}

function SetRoomID()
{
	var Info=GetComputeInfo("");  //���������  DHCPECommon.js
	var encmeth=GetValue("GetRoomIDClass");
	var RoomID=cspRunServerMethod(encmeth,Info);
	var Arr=RoomID.split("$")
	var Flag=Arr[1];
	/*
	if (Flag=="N"){
		var obj=GetObj("BActiveRoom");
		if (obj) obj.innerText="��������";
	}*/
	var RoomID=Arr[0];
	SetValue("RoomID",RoomID);
	var encmeth=GetValue("GetCheckInfoClass");
	var UserID=session['LOGON.USERID'];
	var CheckInfo=cspRunServerMethod(encmeth,RoomID,UserID);
	var Arr=CheckInfo.split("$");
	var NumInfo=Arr[0];
	var NumArr=NumInfo.split("^");
	var PersonInfo=Arr[1];
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPENoCheckDetail&AdmStr="+PersonInfo
	var Info="��<font color=red size=6>"+NumArr[0]+"</font>��,�Ѽ�<font color=red size=6>"+NumArr[1]+"</font>��,<a href="+lnk+" target='_blank' >δ��<font size=6>"+NumArr[2]+"</font>��</a>"
	var obj=document.getElementById("cCheckInfo");
	//if (obj) obj.innerHTML=Info;
	
}


//�ȴ��б�
function BWaitList_Click()
{
	if (vRoomRecordID!=""){
		if (!confirm("��ǰ�����,��û�����,�Ƿ�ʼ��һ��?")){
			return false;
		}
	}
	vRoomRecordID="";
	var RoomID=GetValue("RoomID");
	if (RoomID==""){
		alert("����û�����ö�Ӧ������");
		return false;
	}
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPERoomRecordDetail&RoomID="+RoomID;
	var PWidth=window.screen.width
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,titlebar=yes,'
			+'height='+400+',width='+720+',left='+260+',top=0'
			;

	var ALertWin=window.open(lnk,"AlertWin",nwin)
	return false;
}
function BComplete_Click()
{
	var RecordID=vRoomRecordID;
	var RoomID=GetValue("RoomID");
	var encmeth=GetValue("CompleteClass");
	
	var objtbl=$("#tDHCPEDietManager").datagrid('getRows');
	var PAADM=objtbl[selectrow].TPAADM;
	if (PAADM==""){
		alert("û�о��ﻼ��");
		return false;
	}
	var ret=cspRunServerMethod(encmeth,RecordID,PAADM,RoomID);
	var Arr=ret.split("^");
	vRoomRecordID="";
	var obj=document.getElementById("cCheckInfo");
	if (obj) obj.innerText=Arr[1];
	alert(Arr[1]);
	BWaitList_Click();
}

function GroupDesc_Change()
{
	var obj=document.getElementById("GroupID");
	if (obj) { obj.value=""; }
}

function AfterGroupSelected(value){
	if (""==value){return false}
	var aiList=value.split("^");
	SetCtlValueByID("GroupID",aiList[0],true);
	SetCtlValueByID("GroupDesc",aiList[1],true);
	
}

function CardNo_Change()
{
	CardNoChangeApp("RegNo","CardNo","BFind_click()","Clear_click()","0");
}

function ReadCard_Click()
{
	ReadCardApp("RegNo","BFind_click()","CardNo");
	
}

function BSend_click()
{	
	
	Update("0")
	return false;
}


function Update(Type)  
{
	var iRegNo="",TPEADMID="",obj;
	obj=document.getElementById("RegNo");
	if(obj){
		var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
		iRegNo=obj.value;
		if (iRegNo.length<RegNoLength && iRegNo.length>0) { iRegNo=RegNoMask(iRegNo);}
	}
	
	var objtbl=$("#tDHCPEDietManager").datagrid('getRows');
	var TPEADMID=""
	if(selectrow!="-1"){
		var TPEADMID=objtbl[selectrow].TPEADM;
		}
	
	if(iRegNo==""){
		var TPEADMID=TPEADMID;
	}else{
		TPEADMID=iRegNo+"^";
	}
	
	
	if (TPEADMID=="")
	{
		 $.messager.alert("��ʾ","����ѡ����Ͳ͵���","info"); 
		return false; 
	}
	
	var IsDietFlag=tkMakeServerCall("web.DHCPE.DietManager","IsDietFlag",TPEADMID);
	
	if(IsDietFlag=="NCanntDiet")
	{
		 $.messager.alert("��ʾ","û�оͲ�Ȩ��","info"); 
		return true;
	}
	else if(IsDietFlag=="NoPerson")
	{
		 $.messager.alert("��ʾ","û��ѡ��Ͳ���Ա������Աû�е���","info"); 
		return false;
	}else if(IsDietFlag=="CanntDiet"){
		$.messager.alert("��ʾ","��ǰ��Ŀ��δ�����,���ܳԷ�","info");
		return false;
	}else if(IsDietFlag=="HadDiet")
	{
	
		$.messager.confirm("ȷ��", "�Ѿ��Ͳ�,�Ƿ��ٴξͲͣ�", function(r){
		if (r){
			 var ReturnStr=tkMakeServerCall("web.DHCPE.DietManager","UpdateDietNew",TPEADMID,1)
			 if (ReturnStr=="Success")
			 { 
				  $.messager.alert("��ʾ","�Ͳͳɹ�","success");
				BFind_click();
				return true;
			}
			
			}
		else{
			
		}
		});

		
	}else{
	

		var ReturnStr=tkMakeServerCall("web.DHCPE.DietManager","UpdateDietNew",TPEADMID,0)
		if (ReturnStr=="Success")
		{ 
	    	$.messager.alert("��ʾ","�Ͳͳɹ�","success");
        	BFind_click();
			return true;
		}
	
	}
	
	return false;
	
	
}


function BFind_click()
{
	var CTLocID=session['LOGON.CTLOCID'];
	var iBeginDate="",iEndDate="",GroupID="",RegNo="",DietFlag="",iVIPID="";
	var iBeginDate=getValueById("BeginDate")
	var iEndDate=getValueById("EndDate")	
	var GroupID=getValueById("GroupID")
	var RegNo=getValueById("RegNo")
	var DietFlag=getValueById("DietFlag")
	if(DietFlag){DietFlag="Y";}
	else{DietFlag="N";}
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength",CTLocID);
	if (RegNo.length<RegNoLength&&RegNo.length>0) { 
		RegNo=RegNoMask(RegNo,CTLocID);
		$("#RegNo").val(RegNo)
	}
	var iVIPID=getValueById("VIPLevel")
	var lnk= "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEDietManager"           
    +"&BeginDate="+iBeginDate
    +"&EndDate="+iEndDate
    +"&GroupID="+GroupID
    +"&RegNo="+RegNo
    +"&DietFlag="+DietFlag
    +"&VIPLevel="+iVIPID
	;
	//alert(lnk)
	//location.href=lnk;
	$("#tDHCPEDietManager").datagrid('load',{ComponentID:55926,BeginDate:iBeginDate,EndDate:iEndDate,GroupID:GroupID,RegNo:RegNo,DietFlag:DietFlag,VIPLevel:iVIPID});
	SelectRowHandler(-1);
}


var selectrow=-1;
function SelectRowHandler(index,rowdata) {
	selectrow=index;
	if(index==selectrow)
	{
		var TPEADMID=rowdata.TPEADM;
		var Count=rowdata.TCount;
		$("#RegNo").val("");
		
	}else
	{
		selectrow=-1;
	
	}

}


function GetObj(ElementName)
{
	return document.getElementById(ElementName)
}
function GetValue(ElementName)
{
	var obj=GetObj(ElementName)
	if (obj){
		return obj.value;
	}else{
		return "";
	}
}
function SetValue(ElementName,value)
{
	var obj=GetObj(ElementName)
	if (obj){
		obj.value=value;
	}
}

document.body.onload = BodyLoadHandler;