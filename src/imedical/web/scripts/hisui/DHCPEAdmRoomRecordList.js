

//名称	DHCPEAdmRoomRecordList.js
//组件  DHCPEAdmRoomRecordList
//功能	诊室调整
//创建	2018.09.19
//创建人  xy
document.body.style.padding="0px 10px 10px 10px"
document.body.onload=LoadHandler1;
function LoadHandler1()
{
	
	//放弃选择科室
	var obj=document.getElementById("BRefuseSelect");
	if (obj) obj.onclick=BRefuseSelect_click;
	
	
	//恢复诊室
	var obj=document.getElementById("BResumeRoom");
	if (obj) obj.onclick=ResumeRoom;

	

	 ///全选
	$('#BAllSeletct').checkbox({
		onCheckChange:function(e,value){
			BAllSeletct_click(value);
			
			}		
	});
	
}

function BAllSeletct_click(value)
{
	
	if (value==true) 
	{
		var SelectAll=1;
	}
	else
	{ 
		var SelectAll=0;
	}
	var objtbl = $("#tDHCPEAdmRoomRecordList").datagrid('getRows');
    var rows=objtbl.length
	for (var i=0;i<rows;i++)
	{   
		setColumnValue(i,"TSelect",SelectAll)
	}	
	
}

function BRefuseSelect_click()
{
	
	 var objtbl = $("#tDHCPEAdmRoomRecordList").datagrid('getRows');
    var rows=objtbl.length
	for (var i=0;i<rows;i++)
	{
		var TSelect=getCmpColumnValue(i,"TSelect","DHCPEAdmRoomRecordList")
	    if (TSelect=="1"){
		     var PAADM=objtbl[i].TPAADM;
		     var RoomID=objtbl[i].TRoomID;
		     var ret=RefuseRoomApp(PAADM,RoomID)
		     	   
	    } 
	}

	window.location.reload();
}

function DblClickRowHandler(rowIndex,rowdata)
{
	
	
	if (rowIndex=="-1") return;
	var AreaDesc=rowdata.TAreaDesc;
	var RoomDesc=rowdata.TRoomDesc;
	var RoomID=rowdata.TRoomID;
	
	obj=parent.frames["Record"].document.getElementById("RoomID");
	if (obj) obj.value=RoomID;
	obj=parent.frames["Record"].document.getElementById("RoomDesc");
	if (obj) obj.value=RoomDesc;
	obj=parent.frames["Record"].document.getElementById("AreaDesc");
	if (obj) obj.value=AreaDesc;
	obj=parent.frames["Record"].document.getElementById("AreaID");
	if (obj) obj.value=RoomID.split("||")[0];
	
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
/*
function RefuseRoom()
{
	var eSrc=window.event.srcElement;
	var Info=eSrc.id
	var Arr=Info.split("^");
	var PAADM=Arr[0];
	var RoomID=Arr[1];
	//var encmeth=GetValue("RefuseClass",1)
	var ret=RefuseRoomApp(PAADM,RoomID)
	alert(ret);
	window.location.reload();
}
*/
function RefuseRoomApp(PAADM,RoomID)
{
	
	var encmeth=GetValue("RefuseClass",1)
	//alert(PAADM+"^"+RoomID)
	var ret=cspRunServerMethod(encmeth,PAADM,RoomID);
	alert(ret)
	return ret
}

function ResumeRoom()
{
	
	
	 var objtbl = $("#tDHCPEAdmRoomRecordList").datagrid('getRows');
    var rows=objtbl.length
	for (var i=0;i<rows;i++)
	{
		var TSelect=getCmpColumnValue(i,"TSelect","DHCPEAdmRoomRecordList")
	    if (TSelect=="1"){
		     var PAADM=objtbl[i].TPAADM;
		     var RoomID=objtbl[i].TRoomID;
		     var RSID=tkMakeServerCall("web.DHCPE.AdmRefuseRoom","GetResumeRoomButtonID",PAADM,RoomID);
		     if(RSID==""){return false;}
		     var encmeth=GetValue("ResumeClass",1)
		     var ret=cspRunServerMethod(encmeth,RSID);
		     alert(ret);
		     	   
	    } 
	}
	
	window.location.reload();
}