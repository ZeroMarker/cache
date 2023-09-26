
//名称	DHCPERoomManager.js
//组件  DHCPERoomManager
//功能	诊室调整
//创建	2018.09.18
//创建人  xy

document.body.onload = BodyLoadHandler;


function BodyLoadHandler() {
	//设置按钮大小
	//$.messager.alert("提示","请选择待操作的人员","info");
	$("#BRoomAdjust").css({"width":"150px"});
	$("#RoomPlace").css({"width":"150px"});
	$("#BUpdateRoomInfo").css({"width":"150px"});
	
	var obj=GetObj("BActive");
	var NoActive=getValueById("NoActive");
	 if( NoActive){
		 SetCElement("BActive","启用");
		 if (obj) obj.onclick=ActiveRoom;
		 
		 }
	 else{
		 SetCElement("BActive","禁用");
		 if (obj) obj.onclick=UnActiveRoom;
		 
		 }
	
	
	 
	var obj=GetObj("BReload");
	if (obj) obj.onclick=BReload_click;
	var obj=GetObj("BUpdateRoomInfo");
	if (obj) obj.onclick=BUpdateRoomInfo_click;
	
	var obj=GetObj("RegNo");
	if (obj) obj.onkeydown=RegNo_keydown;
	
	var obj=GetObj("Name");
	//if (obj) obj.onkeydown=FindDetail;
	
	var obj=GetObj("IDCard");
	//if (obj) obj.onkeydown=FindDetail;
	
	var Info=GetValue("WaitInfo");
	var obj=GetObj("cNextRoomInfo");
	if (obj) obj.innerHTML=Info;
	
	
	$("#VIPLevel").combobox({
       onSelect:function(){
			BReload_click();
	}
	});
	

	
	$('#NoActive').checkbox({
		onCheckChange:function(e,vaule){
			//BReload_click(vaule);
			SetButtonName(vaule);
			BReload_click();
			
			
			}
			
	});
	
	websys_setfocus("RegNo")
	
}

function SetButtonName(vaule)
{
	//alert(vaule)
	if(vaule==true)
	{
		SetCElement("BActive","启用");
		 $("#BActive").click(function() { 
			 ActiveRoom(); 
        }); 

	}else{
		SetCElement("BActive","禁用");
		 $("#BActive").click(function() { 
			UnActiveRoom(); 
        }); 

	}
	
}
function FindDetail(e)
{
	var Key=websys_getKey(e);
	if (Key=="13")
	{    
		var Name=GetValue("Name");
		var IDCard=GetValue("IDCard");
		
		
		var url='websys.lookup.csp';
		url += "?ID=&CONTEXT=K"+"web.DHCPE.RoomManagerEx:SearchRoomDetail";
		url += "&P1="+websys_escape(Name);
		url += "&P2="+websys_escape(IDCard);
		
		websys_lu(url,1,'');
		return websys_cancel();
		
		
	}
}


/*
function BReload_click()
{
	
	var VIPLevel=getValueById("VIPLevel")
	if (VIPLevel==""){
		$.messager.alert("提示","请选择诊室位置","info")
		return false;
	}
	var NoActive=getValueById("NoActive")
	if(NoActive){NoActive="1";}
	else{NoActive="0";}
	
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPERoomManager"
			+"&VIPLevel="+VIPLevel
			+"&NoActive="+NoActive;
	//location.href=lnk;
	window.location.reload();

}
*/

function BUpdateRoomInfo_click()
{
	//var RoomID=
	var RoomID=getValueById("RoomID");
	if(RoomID==""){
	$.messager.alert("提示","请选择诊室","info");
		
		return false;
	}
	var sURL="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPERoomModify"
				+"&RoomID="+RoomID; //_$P(%request.Get("RoomID"),"$",1)
	var ret=window.showModalDialog(sURL,"","dialogWidth=600px;dialogHeight=450px");
	
	BReload_click();
	
	//var lnk="dhcpepreauditlist.hiui.csp?CRMADM="+ID+"&ADMType="+Type+"&GIADM="+"&RowID=";
	//websys_lu(lnk,false,'iconCls=icon-w-edit,width=1400,height=600,hisui=true,title=费用')

	return true;
	
	}

function BReload_click()
{
	
	var VIPLevel=getValueById("VIPLevel")
	if (VIPLevel==""){
		$.messager.alert("提示","请选择诊室位置","info")
		return false;
	}
	var NoActive="Y";
	var NoActive=getValueById("NoActive")
	if(NoActive){NoActive="N";}
	else{NoActive="Y";}
	
	$("#tDHCPERoomManager").datagrid('load',{ComponentID:56148,VIPLevel:VIPLevel,NoActive:NoActive});
}


function ActiveRoom()
{
	Active("Y");
}
function UnActiveRoom()
{
	Active("N");
}
function UpdateRoomMinute(e)
{
	var RoomID=e.id
	var Minute=GetValue(RoomID+"M");
	var encmeth=GetValue("UpdateMinuteClass");
	var rtn=cspRunServerMethod(encmeth,RoomID,Minute);
	var Arr=rtn.split("^");
	if (Arr[0]=="-1"){
		alert(Arr[1]);
	}
	window.location.reload();
}
function Active(ActiveFlag)
{
	
	var ID=""
	 var objtbl = $("#tDHCPERoomManager").datagrid('getRows');
    var rows=objtbl.length
	for (var i=0;i<rows;i++)
	{
		var TSelect=getCmpColumnValue(i,"TSelect","DHCPERoomManager")
	    if (TSelect=="1"){
		     if(ID=="") {var ID=objtbl[i].TRoomID;}
		     else{var ID=ID+"^"+objtbl[i].TRoomID;}
		     	   
	    } 
	}

	
	if (ID==""){
		$.messager.alert("提示","请选择诊室","info");
		
		return false;
	}
	var encmeth=GetValue("ActiveRoomClass");
   	for (var j=0;j<ID.split("^").length;j++)
	{
		
		var rtn=cspRunServerMethod(encmeth,ID.split("^")[j],ActiveFlag);
		
		var Arr=rtn.split("^");
		if (Arr[0]=="-1"){
			alert(Arr[1]);
		}
	}
	BReload_click();
	//window.location.reload();
}

function RegNo_keydown(e)
{
	var Key=websys_getKey(e);
	if ((9==Key)||(13==Key)) {
		var obj=window.event.srcElement;
		var RegNo=obj.value;
		if (RegNo=="") return false;
		//是否存在未到达记录，选择到达操作
		var RegisterRecord=tkMakeServerCall("web.DHCPE.PreIADMEx","GetRegisterRecord",RegNo)
		if (RegisterRecord!="")
		{
			var ArriveRecord="";
			var RecordArr=RegisterRecord.split("^");
			if (RecordArr.length>1){
				var url="dhcpearrived.csp?RegisterRecord="+RegisterRecord;   
  				var  iWidth=600; //模态窗口宽度
  				var  iHeight=330;//模态窗口高度
  				var  iTop=(window.screen.height-iHeight)/2;
  				var  iLeft=(window.screen.width-iWidth)/2;
  				var ArriveRecord=window.showModalDialog(url, RegisterRecord, "dialogwidth:600px;dialogheight:330px;center:1"); 
			}else{
				
				ArriveRecord=RegisterRecord;
			}
			if (ArriveRecord!=""){
				//判断是否未付费、是否存在另外未总检的记录
				var ret=tkMakeServerCall("web.DHCPE.DHCPEIAdm","HadNoGenRecord",ArriveRecord);
				if (ret!=""){
					alert(ret);
					return false;
				}else{
					var ret=tkMakeServerCall("web.DHCPE.DHCPEIAdm","IAdmArrived",ArriveRecord);
				}
			}
		}
		//End
		var encmeth=GetValue("RoomClass");
		if (encmeth=="") return false;
		var ret=cspRunServerMethod(encmeth,RegNo);
		var ret=ret.split("^");
		var Flag=ret[0];
		//alert(ret[1]);
		var lnk=window.location.href.split("&WaitInfo")[0];
		window.location.href=lnk+"&WaitInfo="+ret[1];
	}
}
function GetObj(Name)
{
	var obj=document.getElementById(Name);
	return obj;	
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
function SelectRowHandler(index,rowdata) {
	
	var eSrc=window.event.srcElement;
	
	var objtbl = $("#tDHCPERoomManager").datagrid('getRows');
    var rows=objtbl.length;
    //alert(index+"index")
    
    
	selectrow=index;
	//alert(selectrow+"selectrow")
	setColumnValue(selectrow,"TSelect",1)
	//alert(rowdata.TRoomID+"rowdata.TRoomID")
	setValueById("RoomID",rowdata.TRoomID);
	//alert(2)
	
	
	if(-1==eSrc.id.indexOf("TSeclect"))
	{ //如果单击一行?改变前面的选择框?方法在DHCPE.Toolets.Common.JS
		
		//ChangeCheckStatus("TSeclect");
		
		
	}

	
	
	if(index==selectrow)
	{ 
		
		
	  
			
	}else
	{
		selectrow=-1;
		
	}

   
	//ShowCurRecord(selectrow);

}