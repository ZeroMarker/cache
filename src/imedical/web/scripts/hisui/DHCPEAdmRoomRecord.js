//名称 DHCPEAdmRoomRecord.js
//功能 诊室调整
//组件 DHCPEAdmRoomRecord 
//创建 2018.09.17
//创建人 xy
document.body.style.padding="10px 10px 0px 10px"
var CurrentSel=0;
function BodyLoadHandler() {
	var obj;
	//设置按钮大小
	$("#BUpdate").css({"width":"120px"});
	$("#BStopRoom").css({"width":"120px"});
	$("#BPauseRoom").css({"width":"120px"});

	$("#BRefuseSelect").css({"width":"150px"});
	$("#BFindRoomInfo").css({"width":"150px"});
	$("#BResumeRoom").css({"width":"150px"});

	var tableWidth = $("#tDHCPEAdmRoomRecord").parent().width();
	//alert(tableWidth)
    var  tableWidth=1280;
    $("#tDHCPEAdmRoomRecord").datagrid("getPanel").panel('resize',{width:tableWidth});

	//调整
	obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_click;
	
	//取消排队 
	obj=document.getElementById("BStopRoom");
	if (obj) obj.onclick=BStopRoom_click;
	
	//暂停排队
	obj=document.getElementById("BPauseRoom");
	if (obj) obj.onclick=BPauseRoom_click;

	//放弃选择诊室
	obj=document.getElementById("BRefuseSelect");
	if (obj) obj.onclick=BRefuseSelect_click;
	
	//恢复诊室
	obj=document.getElementById("BResumeRoom");
	if (obj) obj.onclick=ResumeRoom_click;
	
	var obj=GetObj("Name");
	if (obj) obj.onkeydown=FindDetail;
	
	obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_click;
	
	obj=document.getElementById("RegNo");
	if (obj){
		obj.onchange=RegNo_change;
		obj.onkeydown=RegNo_keydown;
	}
	
	obj=document.getElementById("AreaDesc");
	if (obj) obj.onchange=AreaDesc_change;
	if (obj) obj.onselect=AreaDesc_change;
}

function BRefuseSelect_click()
{
	
	 var objtbl = $("#tDHCPEAdmRoomRecord").datagrid('getRows');
    var rows=objtbl.length;
    var PAADM=getValueById("PAADM");
   if(rows==""){
		$.messager.alert("提示","请选择诊室","info");
	    return false;
	    }
    if(PAADM==""){
	   $.messager.alert("提示","请选择诊室","info");
	    return false;
	    }
	var IfHadChecked=0;
	for (var i=0;i<rows;i++)
	{
		var TSelect=getCmpColumnValue(i,"TSelect","DHCPEAdmRoomRecord")
	    if (TSelect=="1"){
		    IfHadChecked=1
		     var RoomID=objtbl[i].TRoomID;
			var ret=tkMakeServerCall("web.DHCPE.AdmRefuseRoom","Refuse",PAADM,RoomID)
     		$.messager.alert("提示",ret.split("^")[1],"info");	
     		if(ret.split("^")[0]==0)
     		{
	     		// 放弃的
	     		SetValue("RoomRecordID",ret.split("^")[2],1)
	     		
	     		}     
		     	   
	    } 
	}
	if(IfHadChecked==1)
	{
	$("#tDHCPEAdmRoomRecord").datagrid('load',{ComponentID:55895,PAADM:PAADM});
	}
	else{
			$.messager.alert("提示","请选择诊室","info");	
		}
	//window.location.reload();
}


function ResumeRoom_click()
{

	var objtbl = $("#tDHCPEAdmRoomRecord").datagrid('getRows');
    var rows=objtbl.length;
    var PAADM=getValueById("PAADM");
    if(rows==""){
	    $.messager.alert("提示","请选择诊室","info");
	    return false;
	    }
    if(PAADM==""){
	    $.messager.alert("提示","请选择诊室","info");
	    return false;
	    }
	    
	var IfHadChecked=0;
	for (var i=0;i<rows;i++)
	{
		var TSelect=getCmpColumnValue(i,"TSelect","DHCPEAdmRoomRecord");
		
	    if (TSelect=="1"){
		    IfHadChecked=1;
		     var RoomID=objtbl[i].TRoomID;
		     var RSID=tkMakeServerCall("web.DHCPE.AdmRefuseRoom","GetResumeRoomButtonID",PAADM,RoomID);
		     if(RSID==""){
			     $.messager.alert("提示","已经恢复","info");
			     return false;
			     }
			    
		     var ret=tkMakeServerCall("web.DHCPE.AdmRefuseRoom","Resume",RSID);
		      $.messager.alert("提示",ret.split("^")[1],"info");
		     	   
	    } 
	}
	if(IfHadChecked==1){
	$("#tDHCPEAdmRoomRecord").datagrid('load',{ComponentID:55895,PAADM:PAADM});
	}
	else{
		$.messager.alert("提示","请选择诊室","info");
	    return false;
		}
	//window.location.reload();
}

function FindDetail()
{
	var Key=websys_getKey(e);
	if (Key=="13")
	{
		var Name=GetValue("Name");
		var IDCard=GetValue("IDCard");
		var url='websys.lookup.csp';
		url += "?ID=&CONTEXT=K"+"web.DHCPE.RoomManagerEx:SearchRoomDetail";
		url += "&TLUJSF=SelectByName";
		url += "&P1="+websys_escape(Name);
		url += "&P2="+websys_escape(IDCard);
		websys_lu(url,1,'');
		return websys_cancel();
	}
}
function SelectByName(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	var RegNo=Arr[0];
	obj=document.getElementById("RegNo");
	if (obj){
		obj.value=RegNo;
		RegNo_change();
	}
}
function BPauseRoom_click()
{
	var ID=GetValue("RoomRecordID",1);
	//alert(ID)
	if (ID!=""){
		$.messager.alert("提示","请先输入暂停排队的人员","info");
		$.messager.confirm("操作提示", "是否需要把原来诊室，进行重新分配新诊室?", function (data) {
            		if (data) {
	            		//$.messager.alert("提示","请先输入暂停排队的人员","info");
	        		var encmeth=GetValue("StopRoomClass",1);
					var rtn=cspRunServerMethod(encmeth,ID);
					
					var PAADM=GetValue("PAADM",1);
					if (PAADM==""){
					$.messager.alert("提示","请先输入暂停排队的人员","info");
					return false;
					}
	
			var encmeth=GetValue("PauseRoomClass",1);
			var rtn=cspRunServerMethod(encmeth,PAADM);
			//alert(rtn)
			window.location.reload();
					
	        		}
            		else {
                		return false;
            		}
        			});
		
			
		
	}
	else{
		
		var PAADM=GetValue("PAADM",1);
	if (PAADM==""){
		$.messager.alert("提示","请先输入暂停排队的人员","info");
		return false;
	}
	
	var encmeth=GetValue("PauseRoomClass",1);
	var rtn=cspRunServerMethod(encmeth,PAADM);
	//alert(rtn)
	window.location.reload();
		
		}
	
	
	
}
function BStopRoom_click()
{
	var PAADM=GetValue("PAADM",1);
	if (PAADM==""){
		$.messager.alert("提示","请先输入待取消排队的人员","info");
		return false;
	}
	var ID=GetValue("RoomRecordID",1);
	if (ID==""){
		$.messager.alert("提示","原诊室不存在,不能取消排队","info");
		return false;
	}
	var encmeth=GetValue("StopRoomClass",1);
	var rtn=cspRunServerMethod(encmeth,ID);
	//alert(rtn)
	window.location.reload();
	
}
function BUpdate_click()
{
	var ID=GetValue("RoomRecordID",1);
	var RoomID=GetValue("RoomID",1);
	if (ID==""){
		$.messager.alert("提示","原诊室不存在,不能调整","info");
		return false;
	}
	if (RoomID==""){
		$.messager.alert("提示","调整为诊室不存在,不能调整","info");
		return false;
	}

	var objtbl=$("#tDHCPEAdmRoomRecord").datagrid('getRows');
	//alert(selectrow+"selectrow")
	if(selectrow>=0){
	var RefuseRoom=objtbl[selectrow].TRefuseRoom;
	if (RefuseRoom=="放弃"){
		$.messager.alert("提示","该诊室已放弃,不能调整到该诊室","info");
		return false;
	}
	}

		//alert(ID+"^"+RoomID)
	var rtn=tkMakeServerCall("web.DHCPE.RoomManager","UpdateAdmRoomRecord",ID,RoomID,1);

	if (rtn.split("^")[0]=="-1"){
			$.messager.alert("提示","更新失败:"+rtn.split("^")[1],"info");
		//alert("更新失败"+rtn.split("^")[1],"info")
	}else{
		window.location.reload();
	}
}
function BClose_click()
{
	window.close();
}


function GetObj(Name)
{
	var obj=document.getElementById(Name);
	return obj;	
}
function GetValue(Name,Type)
{
	var Value="";
	var obj=GetObj(Name);
	if (obj){
		if (Type=="2"){
			Value=obj.innerText;
		}else{
			Value=obj.value;
		}
	}
	return Value;
}
function SetValue(Name,Value,Type)
{
	var obj=GetObj(Name);
	if (obj){
		if (Type=="2"){
			obj.innerText=Value;
		}else{
			obj.value=Value;
		}
	}
}


var selectrow=-1;		
function SelectRowHandler(index,rowdata) {
	var objtbl = $("#tDHCPEAdmRoomRecord").datagrid('getRows');
    var rows=objtbl.length;
	selectrow=index;
	
	if(index==selectrow)
	{ 
	    var RoomID=rowdata.TRoomID;
	     setValueById("RoomID",RoomID);
	    var RoomDesc=rowdata.TRoomDesc;
	     setValueById("RoomDesc",RoomDesc);
	     var AreaID=rowdata.TAreaID;
	     setValueById("AreaID",AreaID);
	    var AreaDesc=rowdata.TAreaDesc;
	     setValueById("AreaDesc",AreaDesc);
	    		
	}else
	{
		selectrow=-1;
		
	}
	
}

function SetAreaInfo(value)
{
	//alert(value+"value")
	if (value=="") return false;
	var Arr=value.split("^");
	//alert(GetValue("AreaID",1))
	var OldAreaID=GetValue("AreaID",1)
	if(OldAreaID!=Arr[0]){
		 AreaDesc_change();
	}
	SetValue("AreaDesc",Arr[2],1);
	SetValue("AreaID",Arr[0],1);
}
function SetRoomInfo(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	SetValue("RoomDesc",Arr[2],1);
	SetValue("RoomID",Arr[0],1);
}

function AreaDesc_change()
{
	
	SetValue("AreaID","",1);
	SetValue("RoomDesc","",1);
	SetValue("RoomID","",1);
}
function RoomDesc_change()
{
	SetValue("RoomID","",1);
}
function RegNo_keydown(e)
{
	var Key=websys_getKey(e);
	if ((9==Key)||(13==Key)) {
		RegNo_change();
	}
}
function RegNo_change()
{
	var RegNo=GetValue("RegNo");
	if (RegNo==""){
		var Info="0^^^^^^^^^^^^";
	}else{
		var encmeth=GetValue("GetInfoMethod");
		var Info=cspRunServerMethod(encmeth,RegNo);
	}
	var Char_1=String.fromCharCode(1);
	var Arr=Info.split(Char_1);
	var BaseInfo=Arr[0];
	var BaseArr=BaseInfo.split("^");
	var PAADM="";
	var PauseFlag=0;
	if (BaseArr[0]=="0"){
		var RoomInfo=Arr[1];
		var RoomArr=RoomInfo.split("^");
		SetValue("Name",BaseArr[1],1)
		SetValue("Sex",BaseArr[2],1)
		SetValue("Dob",BaseArr[3],1)
		SetValue("IDCard",BaseArr[4],1)
		SetValue("RegNo",BaseArr[5],1)
		SetValue("PAADM",BaseArr[9],1)
		SetValue("RoomRecordID",RoomArr[0],1)
		SetValue("CurRoomInfo",RoomArr[1],1)
		PAADM=BaseArr[9];
		PauseFlag=BaseArr[10];
	}else{
		//alert(BaseArr[1])
		 $.messager.popover({msg: BaseArr[1], type: "info"});
		SetValue("Name","",1)
		
		SetValue("Sex","",1)
		SetValue("Dob","",1)
		SetValue("IDCard","",1)
		SetValue("RoomRecordID","",1)
		SetValue("CurRoomInfo","",1)
		SetValue("PAADM","",1)
	}
	if (PauseFlag!="0"){
		var obj=GetObj("BPauseRoom");
		if (obj){SetCElement("BPauseRoom","恢复排队");}
		
	}else{
		var obj=GetObj("BPauseRoom");
		if (obj){SetCElement("BPauseRoom","暂停排队");}
		
	}
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEAdmRoomRecordList&PAADM="+PAADM;
	//alert(lnk)
	$("#tDHCPEAdmRoomRecord").datagrid('load',{ComponentID:getValueById("GetComponentID"),PAADM:PAADM});
	//parent.frames["RecordList"].location.href=lnk;
}
document.body.onload = BodyLoadHandler;