
//名称	DHCPEChangeRoomPlace.js
//功能	诊室维护
//组件	DHCPEChangeRoomPlace
//创建	2018.09.03
//创建人  xy
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("BSave");
	if (obj) obj.onclick=BSave_click;
	
	obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_click;
	
	obj=document.getElementById("RegNo");
	if (obj) obj.onkeydown=RegNo_keydown;

	Info();
	
}

function Info(){
	var HospID=session['LOGON.HOSPID']
	var PreIADM=$("#PreIADM").val()
	var BaseInfo=tkMakeServerCall("web.DHCPE.PreIADMReplace","GetPreInfo",PreIADM,HospID);
	var Arr=BaseInfo.split("^");
		
	$("#Status").val(Arr[0]);
	$("#GDesc").val(Arr[1]);
	$("#TeamDesc").val(Arr[2]);
	$("#VIPLevel").val(Arr[3]);
	$("#HPNo").val(Arr[4]);
	$("#OldRoomPlace").val(Arr[5]);
	$("#RegNo").val(Arr[7]);
	$("#Name").val(Arr[8]);
	$("#Sex").val(Arr[9]);
	$("#IDCard").val(Arr[11]); 

}


function BFind_click()
{
	
	   var RegNo=getValueById("RegNo");
		if (RegNo=="") return false;
		if(RegNo!="") {
			var RegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",RegNo);
			$("#RegNo").val(RegNo);
		}

		var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEChangeRoomPlace"
			+"&RegNo="+RegNo;
			//alert(lnk)
		//window.location.href=lnk;
				
	var ComponentID=tkMakeServerCall("websys.Component","GetIdFromCodeOrDescription","DHCPEChangeRoomPlace") 
	$("#tDHCPEChangeRoomPlace").datagrid('load',{ComponentID:ComponentID,RegNo:RegNo,RoomPlace:"",HospID:session['LOGON.HOSPID']});


}

function RegNo_keydown(e)
{
	var key=websys_getKey(e);
	if ( 13==key) {
		BFind_click()
	}
}

function BSave_click()
{
	var PreIADM=GetValue("PreIADM",1);
	if (PreIADM==""){
		$.messager.alert("提示","请先选择调整记录","info");
		return false;
	}
	var RoomPlace=getValueById("RoomPlace")
	var encmeth=GetValue("SaveClass",1);
	//alert("RoomPlace:"+RoomPlace)
	if((RoomPlace=="undefined")||(RoomPlace=="")){
		$.messager.alert("提示","请选择诊室位置","info");
		return false;
		}

	var rtn=cspRunServerMethod(encmeth,"I",PreIADM,RoomPlace);
	
	if (rtn.split("^")[0]=="-1"){
		$.messager.alert("提示","更新失败"+rtn.split("^")[1],"info");
	}else{
		var DeleteOldRoom=tkMakeServerCall("web.DHCPE.RoomManager","NeedDeleteOldRoom",PreIADM);
		if (DeleteOldRoom==1){
			
			
			$.messager.confirm("操作提示", "是否需要把原来诊室，进行重新分配新诊室?", function (data) {
            		if (data) {
	        		var ret=tkMakeServerCall("web.DHCPE.RoomManager","DeleteOldRoom",PreIADM);
					$.messager.alert("提示",ret.split("^")[1],"info");
	        		
	        		}
            		else {
                		return false;
            		}
        			});
			
		}
		//window.location.reload();
		BFind_click();
	}
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


var CurrentSel=-1;
function SelectRowHandler(index,rowdata) {
	CurrentSel=index;
	if (CurrentSel=="-1") return;
	if(index==CurrentSel)
	{
		var ID=rowdata.PIADM_RowId;
		if(ID==""){	
			$("#RegNo,#Name,#Sex,#IDCard,#GDesc,#TeamDesc,#VIPLevel,#HPNo,#OldRoomPlace").val("");	
		}else{

	    setValueById("PreIADM",ID);
		  var HospID=session['LOGON.HOSPID'];
	   var encmeth=GetValue("GetOneMethod",1);
	   var OneStr=cspRunServerMethod(encmeth,ID,HospID);
	   var StrArr=OneStr.split("^");
		SetValue("RegNo",StrArr[7],1);
		SetValue("Name",StrArr[8],1);
		SetValue("Sex",StrArr[9],1);
		SetValue("IDCard",StrArr[11],1);
		SetValue("GDesc",StrArr[1],1);
		SetValue("TeamDesc",StrArr[2],1);
		SetValue("VIPLevel",StrArr[3],1);
		SetValue("HPNo",StrArr[4],1);
		SetValue("OldRoomPlace",StrArr[5],1);
		}
			
	}else
	{
		CurrentSel=-1;
	
	}
	
	

}			


document.body.onload = BodyLoadHandler;