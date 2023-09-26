



var vRoomInfo="";
var vStatus="";
var vDetailStatus="";

function BodyIni()
{

	var obj;
	SetRoomInfo();
	CreateRoomRecordList();
	
	obj=document.getElementById("RegNo");
	if (obj) obj.onchange=RegNo_onchange;
	
	obj=document.getElementById("SpecNo");
	if (obj) obj.onkeydown=SpecNo_Keydown;
	obj=document.getElementById("BSave");
	if (obj) obj.onclick=BSave_Click;
	
	//ȫѡ
	$('#BSelect').checkbox({
		onCheckChange:function(e,vaule){
			BSelect_Click(vaule);
			
			}
			
	});
	
	//ȡ��  
	obj=document.getElementById("BRef");
	if (obj) obj.onclick=BRef_Click;
	
	//����
	obj=document.getElementById("BRRef");
	if (obj) obj.onclick=BRRef_Click;
	
	
	obj=document.getElementById("BShowSoftKey");
	if (obj) obj.onclick=ShowSoftKey_click;
	
	obj=document.getElementById("BWaitList");
	if (obj) {obj.onclick=BWaitList_Click;}
	
	obj=document.getElementById("BComplete");
	if (obj) {obj.onclick=BComplete_Click;}
	
	obj=document.getElementById("BActiveRoom");
	if (obj) {obj.onclick=BActiveRoom_Click;}	
    
   
	websys_setfocus("SpecNo");
    SetRoomID();
	Init();
	
	
}

//ȫѡ
function BSelect_Click(value)
{
	if (value==true) 
	{
		var SelectAll=1;
	}
	else
	{ 
		var SelectAll=0;
	}
	var objtbl = $("#tDHCPESaveCollectSpec").datagrid('getRows');
    var rows=objtbl.length
	for (var i=0;i<rows;i++)
	{   
		setColumnValue(i,"TSelect",SelectAll)
	
	}
}

//ȡ��
function BRef_Click()
{
	var objtbl = $("#tDHCPESaveCollectSpec").datagrid('getRows');
    var rows=objtbl.length
    for (var i=0;i<rows;i++)
	{

	var TSelect=getCmpColumnValue(i,"TSelect","DHCPESaveCollectSpec")
	 if (TSelect=="1"){
		 
		    var OEStat=objtbl[i].TOSTATDesc;
		    var SpecNo=objtbl[i].TSpecNo;	
		    if(OEStat=="��ʵ") RefuseApp(SpecNo);
		    else{
			  
		       return false;
		    }
	 }

	 }	
	window.location.reload();
}



//����
function BRRef_Click()
{
	
	var objtbl = $("#tDHCPESaveCollectSpec").datagrid('getRows');
    var rows=objtbl.length
    for (var i=0;i<rows;i++)
	{

	var TSelect=getCmpColumnValue(i,"TSelect","DHCPESaveCollectSpec")
	 if (TSelect=="1"){
		    
		    var OEStat=objtbl[i].TOSTATDesc;
		    var SpecNo=objtbl[i].TSpecNo;	
		    if(OEStat=="л�����") RefuseApp(SpecNo);
		    else{
			  
		       return false;
		    }
	 }

	 }	
	window.location.reload();
}

function BActiveRoom_Click()
{
	var eSrc=window.event.srcElement;
	var ActiveFlag="Y";
	if (eSrc.innerText=="�ر�����"){
		ActiveFlag="N";
	}
	var ID=GetValue("RoomID");
	var encmeth=GetValue("ActiveRoomClass");
	var rtn=cspRunServerMethod(encmeth,ID,ActiveFlag);
	var Arr=rtn.split("^");
	if (Arr[0]=="-1"){
		messageShow("","","",Arr[1]);
	}
	window.location.reload();
}
function SetRoomID()
{

	var RoomID=GetValue("RoomID");;
	if (RoomID==""){
		var obj=GetObj("BWaitList");
		if (obj) obj.style.display='none';
		var obj=GetObj("BComplete");
		if (obj) obj.style.display='none';
		var obj=GetObj("BActiveRoom");
		if (obj) obj.style.display='none';
		var TotalLnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPENoCheckDetail";
		var Info="<a href="+TotalLnk+" target='_blank' >�����Ϣ</a>"
	}else{
		var encmeth=GetValue("GetCheckInfoClass");
		var UserID=session['LOGON.USERID'];
		var CheckInfo=cspRunServerMethod(encmeth,RoomID,UserID);
		var Arr=CheckInfo.split("$");
		var NumInfo=Arr[0];
		var HadCheckStr=Arr[1];
		var NoCheckStr=Arr[2];
		var NumArr=NumInfo.split("^");
		var TotalPerson=NumArr[0];
		var HadCheckNum=NumArr[1];
		var NoCheckNum=NumArr[2];
		var NoCheckLnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPENoCheckDetail&AdmStr="+RoomID+NoCheckStr;
		var HadCheckLnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPENoCheckDetail&AdmStr="+RoomID+HadCheckStr;
		var TotalLnk="websys.defaul.thisui.csp?WEBSYS.TCOMPONENT=DHCPENoCheckDetail&StationID="+RoomID;
		var Info="<a href="+TotalLnk+" target='_blank' >��<font color=red size=6>"+TotalPerson+"</font>��</a>,<a href="+HadCheckLnk+" target='_blank' >�Ѽ�<font color=red size=6>"+HadCheckNum+"</font>��</a>,<a href="+NoCheckLnk+" target='_blank' >δ��<font size=6>"+NoCheckNum+"</font>��</a>"
	}
	var obj=document.getElementById("cCheckInfo");
	if (obj) obj.innerHTML=Info;
	
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

//�ȴ��б�
function BWaitList_Click()
{
	var RoomID=GetValue("RoomID");
	if (RoomID==""){
		alert("����û�����ö�Ӧ������");
		return false;
	}
	
	if (vRoomRecordID!=""){
		if (!confirm("��ǰ�����,��û�����,�Ƿ�ʼ��һ��?")){
			return false;
		}
	}
	vRoomRecordID="";
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPERoomRecordDetail&RoomID="+RoomID+"&WaitInfo="+vRoomInfo;
	var PWidth=window.screen.width
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,titlebar=yes,'
			+'height='+400+',width='+720+',left='+260+',top=0'
			;

	var ALertWin=window.open(lnk,"AlertWin",nwin)
	return false;
}


function ShowSoftKey_click()
{
	var shell = new ActiveXObject("wscript.shell");

    	shell.run("osk.exe");
	return false;
}
function RegNo_onchange()
{
	/*
	if (vRoomRecordID!="")
	{
		if (!confirm("��ǰ�����,��û�����,�Ƿ�ʼ��һ��?")){
			return false;
		}
	}
	vRoomRecordID="";
	*/
	var CurRegNo="";
	obj=document.getElementById("RegNo");
	if (obj) CurRegNo=obj.value;
	if (CurRegNo=="") return false;
	var Status=tkMakeServerCall("web.DHCPE.PreIADM","GetStatusByRegNo",CurRegNo);
	if(Status=="REGISTERED"){
	var url="dhcpecustomconfirmbox.csp?Type=Arrived";   
  	var  iWidth=300; //ģ̬���ڿ��
  	var  iHeight=130;//ģ̬���ڸ߶�
  	var  iTop=(window.screen.height-iHeight)/2;
  	var  iLeft=(window.screen.width-iWidth)/2;
  	var dialog=window.showModalDialog(url, CurRegNo, "dialogwidth:300px;dialogheight:130px;center:1"); 
 	if(dialog){
		if(dialog!=1){
			return false;
		}
  		}
  	else{
    		return false;
  		}
	}
	Find();
}
function SpecNo_Keydown(e)
{
	var key=websys_getKey(e);
	if (13==key) 
	{
		/*
		if (vRoomRecordID!="")
		{
			if (!confirm("��ǰ�����,��û�����,�Ƿ�ʼ��һ��?")){
				return false;
			}
		}
		vRoomRecordID="";
		*/
		
			
		BSave_Click();
		
		
		
	}
	
}
function BSave_Click()
{
	var obj;
	vStatus="";
	vDetailStatus="";
	obj=document.getElementById("SpecNo");
	var SpecNo="",encmeth="",ReturnValue="";
	if (obj) SpecNo=obj.value;
	if (SpecNo=="") return false;
	obj=document.getElementById("IsCurDate");
	if (obj) encmeth=obj.value;
	if (encmeth=="") return false;
	Value=cspRunServerMethod(encmeth,SpecNo);
	
	var Arr=Value.split("^");
	var RegNoFlag=Arr[3];
	if (RegNoFlag=="1"){
		var Status=tkMakeServerCall("web.DHCPE.PreIADM","GetStatusByRegNo",SpecNo);
		
		if(Status=="REGISTERED"){
			var url="dhcpecustomconfirmbox.csp?Type=Arrived";   
			var  iWidth=300; //ģ̬���ڿ��
			var  iHeight=130;//ģ̬���ڸ߶�
			var  iTop=(window.screen.height-iHeight)/2;
			var  iLeft=(window.screen.width-iWidth)/2;
			var dialog=window.showModalDialog(url, SpecNo, "dialogwidth:300px;dialogheight:130px;center:1");
			if(dialog!=1){
				return false;
			}
			var PIADM=tkMakeServerCall("web.DHCPE.PreIADM","GetPIADMByRegNo",SpecNo);
			if(PIADM==""){return false}
			var ArriveFlag=tkMakeServerCall("web.DHCPE.DHCPEIAdm","UpdateIADMInfo",PIADM,"3");
			if(ArriveFlag!="0"){alert("����ʧ��")}
	  	}
		obj=document.getElementById("SpecNo");
		if (obj) obj.value="";
		obj=document.getElementById("RegNo");
		if (obj) obj.value=SpecNo;
		obj=document.getElementById("PAADM");
		if (obj) obj.value=Arr[2];
	}else{
		obj=document.getElementById("RegNo");
		if (obj) obj.value="";
		var PAADM=Arr[2];
		var Status=tkMakeServerCall("web.DHCPE.PreIADM","GetStatusByPAADM",PAADM);
		var AdmArr=Status.split("^");
		
		if(AdmArr[0]=="REGISTERED"){
			var url="dhcpecustomconfirmbox.csp?Type=Arrived";   
			var  iWidth=300; //ģ̬���ڿ��
			var  iHeight=130;//ģ̬���ڸ߶�
			var  iTop=(window.screen.height-iHeight)/2;
			var  iLeft=(window.screen.width-iWidth)/2;
			var dialog=window.showModalDialog(url, AdmArr[2], "dialogwidth:300px;dialogheight:130px;center:1");
			if(dialog!=1){
				return false;
			}
			var PIADM=AdmArr[1];
			if(PIADM==""){return false}
			var ArriveFlag=tkMakeServerCall("web.DHCPE.DHCPEIAdm","UpdateIADMInfo",PIADM,"3");
			if(ArriveFlag!="0"){alert("����ʧ��")}
	  	}
	}
	if (Arr[0]=="0"){
		messageShow("","","",Arr[1]);
		return false;	
	}
	else if (Arr[0]=="1"){
		if (!(confirm("�ñ걾����߲��ǵ��쵽��,�Ƿ�����걾�˶�?"))) {  return false; }
	}
	
	var RoomID=GetValue("RoomID");
	if (RoomID!=""){
	
		var CurRoomID=Value.split("^")[1];
		vStatus=Value.split("^")[4];
		vDetailStatus=Value.split("^")[5];
		if ((CurRoomID!=vRoomRecordID)&&(vRoomRecordID!="")) //
		{
			if (!confirm("�����ߺͽк��߲���ͬһ����,�Ƿ����?")) return false;
			
		}else if(vRoomRecordID==""){
			if (!confirm("û�нк�,�Ƿ����?")) return false;
		}	
	}
	//parent.vRoomRecordID="";
	vRoomRecordID=CurRoomID;
	if (vStatus=="N"){  //�ж��ǲ���ͬһ����
		if (vDetailStatus!="E"){  //��������״̬�ģ��������죬����
			var encmeth=GetValue("ArriveCurRoomClass");
			var UserID=session['LOGON.USERID'];
			var ret=cspRunServerMethod(encmeth,vRoomRecordID,UserID,RoomID);
		}
	}
	

	Find()
}
function Find()
{
	
	var obj;
	var RegNo="",SpecNo="",PAADM="";
	obj=document.getElementById("PAADM");
	if (obj) PAADM=obj.value;
	
	
	obj=document.getElementById("SpecNo");
	if (obj) SpecNo=obj.value;
	obj=document.getElementById("RegNo");
	if (obj) RegNo=obj.value;
	
	if ((vRoomRecordID=="")&&(SpecNo=="")&&(PAADM=="")){
		alert("��ǰ�����ߺͱ걾�Ų��ܶ�Ϊ��");
		return false;
	}
	
	var RoomID=GetValue("RoomID");
	if (RoomID==""){
	vRoomRecordID="";
	
	}
	var flag=tkMakeServerCall("web.DHCPE.BarPrint","JugeSpecNoByPAADMInfo",PAADM,RoomID,SpecNo);
	if(flag!="0"){
		messageShow("","","",flag);
		return false;
		}
	
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPESaveCollectSpec&SpecNo="+SpecNo+"&RoomRecordID="+vRoomRecordID+"&RoomID="+RoomID+"&PAADM="+PAADM+"&RegNo="+RegNo;		
	//messageShow("","","",lnk)
	try{
		if (SpecNo!=""){
			PrintAllApp(SpecNo,"Spec","N")
		}
		else if(PAADM!="")
		{
			PrintAllApp(PAADM,"PAADM","N")
		}
	}catch(e){}
	location.href=lnk;
}

var selectrow=-1;
function SelectRowHandler(index,rowdata) {
	selectrow=index;
	if(index==selectrow)
	{		
	}else
	{
		selectrow=-1;
	}
}

var onAfterRender = $.fn.datagrid.defaults.view.onAfterRender;
        $.extend($.fn.datagrid.defaults.view, {
            onAfterRender: function(target){
                onAfterRender.call(this, target);
          
               var objtbl = $(target).datagrid('getRows');
	           var rows=objtbl.length
	         for (var j=0;j<rows;j++) {
		 
		      	var placerCode=objtbl[j].TPlacerColor;
		      	messageShow("","","",placerCode)
				var strCell=objtbl[j].TDate;	
		 		strCell=strCell.replace(" ","")
				if(strCell=="")
				{
					index=j;
					$("td .datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"]").css({"background-color":"#FF0000"}); 
					//<div class="datagrid-cell datagrid-cell-c1-TItemName" style="height: auto; text-align: left;">Ѫ����</div>
					//$("td .datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"]").css({"background-color":"#FF0000"});
				}
			}

	           
            }
});



function Init()
{
	
	var obj;
	var SpecNo="",RegNo="",encmeth;
	obj=document.getElementById("SpecNo");
	if (obj) SpecNo=obj.value;
	obj=document.getElementById("RegNo");
	if (obj) RegNo=obj.value;
	if ((SpecNo=="")&&(RegNo=="")) return false;
	obj=document.getElementById("GetInfoClass");
	if (obj) encmeth=obj.value;
	if (encmeth=="") return false;
	var Str=cspRunServerMethod(encmeth,RegNo,SpecNo);
	Str=Str.split("^");
	obj=document.getElementById("Name");
	if (obj) obj.value=Str[0];
	obj=document.getElementById("Sex");
	if (obj) obj.value=Str[1];
	obj=document.getElementById("CardID");
	if (obj) obj.value=Str[2];
	obj=document.getElementById("RegNo");
	if (obj) obj.value=Str[3];

	//ColorTblColumn();
}

function ColorTblColumn(){
	var tbl=document.getElementById('tDHCPESaveCollectSpec'); //ȡ���Ԫ��?����
	var row=tbl.rows.length;
	row=row-1;
	for (var j=1;j<row+1;j++) {
		
	var objArcim=document.getElementById('TItemNamez'+j).parentElement;
	var objPlacerCode=document.getElementById('TPlacerColorz'+j);
	var placerCode="";
	
	if (objPlacerCode) {placerCode=objPlacerCode.value;}
	objArcim.bgColor=placerCode;
	
	
	
	}
}

//ȥ���ַ������˵Ŀո�
function Trim(String)
{
	if (""==String) { return ""; }
	var m = String.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

function RefuseItem()
{
	var eSrc=window.event.srcElement;
	var ID=eSrc.id;
	var encmeth=GetValue("RefuseClass");
	cspRunServerMethod(encmeth,ID);
	window.location.reload();
}
function RefuseApp(ID)
{
	var encmeth=GetValue("RefuseClass");
	cspRunServerMethod(encmeth,ID);
	//messageShow("","","",11)
}
document.body.onload = BodyIni;