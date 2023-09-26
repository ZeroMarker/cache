//DHCRisRoomEquipment.js

function BodyLoadHandler()
{
	var AddObj=document.getElementById("Add");
	if (AddObj)
	{
		AddObj.onclick=Add_click;
	}
	
	var DeleteObj=document.getElementById("Delete");
	if (DeleteObj)
	{
		DeleteObj.onclick=Delete_click;
	}
	
	var UpdateObj=document.getElementById("Update");
	if (UpdateObj)
	{
		UpdateObj.onclick=Update_click;
	}
	
	
	//设备科室信息
    GetAllEquipment();
 
		
}

function Add_click()
{
	var OperateCode="I";
	var Rowid="";
	 
	var RoomDR=document.getElementById("RoomDR").value;
	if(RoomDR=="")
	{
		error="请选中诊室记录!";
		return;
	}
	
	var SelEqObj=document.getElementById("SelEquipList");
	if (SelEqObj)
	{
		 var EquipmentDR=SelEqObj.value;
		 var EquipmentDesc=SelEqObj.text;
		 
	}
	
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisRoomEquipment');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	
    for (i=1;i<rows;i++)
    {
	    var TRoomDR=document.getElementById("TRoomDRz"+i).value;
	    var TEquipDr=document.getElementById("TEquipDrz"+i).value;
	    
	    if ((RoomDR==TRoomDR)&&(EquipmentDR==TEquipDr))
	    {
		    alert("记录存在,不能重复添加");
		    return;
	    }
	}
	
	 var Info=Rowid+"^"+RoomDR+"^"+EquipmentDR;
	 SetRoomEquipment(Info,OperateCode);
	
	
}

function Delete_click()
{
	var OperateCode="D"
	var SelRowid=document.getElementById("SelRowid").value;
	
	if (SelRowid=="")
	{
		alert("未选择记录不能删除!")
		return;
		
	}
	
	var str="^^";
    var Info=SelRowid+str;
    SetRoomEquipment(Info,OperateCode);
	
}

function Update_click()
{
	var SelRowid=document.getElementById("SelRowid").value;
	var OperateCode="U";
	
	if (SelRowid=="")
	{
		alert("未选择记录不能更新!")
		return;	
	}
	
	 
	var RoomDR=document.getElementById("RoomDR").value;
	if(RoomDR=="")
	{
		error="请选中诊室记录!";
		return;
	}
	
	var SelEqObj=document.getElementById("SelEquipList");
	if (SelEqObj)
	{
		 var EquipmentDR=SelEqObj.value;
		 var EquipmentDesc=SelEqObj.text;
		 
	}
     
	 var Info=SelRowid+"^"+RoomDR+"^"+EquipmentDR;
	 SetRoomEquipment(Info,OperateCode);
	
}



function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisRoomEquipment');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

 	var SelRowid=document.getElementById("TRowidz"+selectrow).value;
	var RoomName=document.getElementById("TRoomNamez"+selectrow).innerText;
	var EquipName=document.getElementById("TEquipNamez"+selectrow).innerText
	var EquipDr=document.getElementById("TEquipDrz"+selectrow).value;
	var RoomDr=document.getElementById("TRoomDRz"+selectrow).value;
	
	
	var SeleRowidObj=document.getElementById("SelRowid");
	if (SeleRowidObj)
	{
		SeleRowidObj.value=SelRowid;
	}
	
	var SelEqObj=document.getElementById("SelEquipList");
	if (SelEqObj)
	{
		 SelEqObj.value=EquipDr;
		 SelEqObj.text=EquipName;
	}
    var SeleRoomDRObj=document.getElementById("RoomDR");
    if(SeleRoomDRObj)
    {
	    SeleRoomDRObj.value=RoomDr
	}
	
}


//初始化科室信息
function GetAllEquipment()
{
    SelEquipObj=document.getElementById("SelEquipList");
    if (SelEquipObj)
    {
 		combo("SelEquipList");
		var GetAllEquipmentFun=document.getElementById("GetAllEquipment").value;
		var Info1=cspRunServerMethod(GetAllEquipmentFun);
    	AddItem("SelEquipList",Info1);
    }
}


function combo(cmstr)
{
	var obj=document.getElementById(cmstr);
	obj.size=1; 
	obj.multiple=false;
}

function AddItem(ObjName, Info)
{
	var Obj=document.getElementById(ObjName);
    if (Obj.options.length>0)
 	{
		for (var i=Obj.options.length-1; i>=0; i--) Obj.options[i] = null;
	}
	
    var ItemInfo=Info.split("^");
 	for (var i=0;i<ItemInfo.length;i++)
 	{
	 	perInfo=ItemInfo[i].split(String.fromCharCode(1))
	 	var sel=new Option(perInfo[1],perInfo[0]);
		Obj.options[Obj.options.length]=sel;
	} 
}


function SetRoomEquipment(Info,OperateCode)
{
	var SetRoomEquipmentFun=document.getElementById("SetRoomEquipmentFun").value;
	var value=cspRunServerMethod(SetRoomEquipmentFun,Info,OperateCode);
	if (value!="0")
	{  
	     if(OperateCode=="I")
	     {
		    var Info="增加失败:SQLCODE="+value;
		 }
	     if(OperateCode=="U")
	     {
		    var Info="更新失败:SQLCODE="+value;
		 }
		 else
		 {
			var Info="删除失败:SQLCODE="+value;
	     }	 
		
	     alert(Info);
	}
	else
	{  
	    var RoomDR=document.getElementById("RoomDR").value; 
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisRoomEquipment"+"&RoomDR="+RoomDR;
   		location.href=lnk; 
	}
	
}



document.body.onload = BodyLoadHandler;




