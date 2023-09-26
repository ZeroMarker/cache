//DHCRisLocRoomSet.js

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
	
	var ModiObj=document.getElementById("Modi");
	if (ModiObj)
	{
		ModiObj.onclick=Modi_click;
	}
	
	
	//��ȡ������Ϣ
    GetALLLoc();
 
		
}

function Add_click()
{
	var OperateCode="I";
	var Rowid="";
	var RoomCode=document.getElementById("RoomCode").value;
	var RoomName=document.getElementById("RoomName").value;
	 
	 if(RoomCode=="")
	 {
		 var error="�����뷿�����!";
		 alert(error);
		 return ;
	 }
	 if(RoomName=="")
	 {
		 var error="�����뷿�����!";
		 alert(error);
		 return ;
	 }
	 
	 var SelLocObj=document.getElementById("SelLocList");
	 if (SelLocObj)
	 {
		 var LocID=SelLocObj.value;
	 }
     
	 var Info=Rowid+"^"+RoomCode+"^"+RoomName+"^"+LocID;
	 SetLocRoomFun(Info,OperateCode);
	
	
}

function Delete_click()
{
	var OperateCode="D"
	var SelRowid=document.getElementById("SelRowid").value;
	
	if (SelRowid=="")
	{
		alert("δѡ���¼����ɾ��!")
		return;
		
	}
	
	var str="^^^";
    var Info=SelRowid+str;
    SetLocRoomFun(Info,OperateCode);
	
}

function Modi_click()
{
	var SelRowid=document.getElementById("SelRowid").value;
	var OperateCode="U";
	
	if (SelRowid=="")
	{
		alert("δѡ���¼���ܸ���!")
		return;	
	}
	
	 
	 var RoomCode=document.getElementById("RoomCode").value;
	 var RoomName=document.getElementById("RoomName").value;
	 
	 if(RoomCode=="")
	 {
		 var error="�����뷿�����!";
		 alert(error);
		 return ;
	 }
	 if(RoomName=="")
	 {
		 var error="�����뷿�����!";
		 alert(error);
		 return ;
	 }
	 
	 var SelLocObj=document.getElementById("SelLocList");
	 if (SelLocObj)
	 {
		 var LocID=SelLocObj.value;
	 }
     
	 var Info=SelRowid+"^"+RoomCode+"^"+RoomName+"^"+LocID;
	 SetLocRoomFun(Info,OperateCode);
	
}



function SelectRowHandler()
{
	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCRisLocRoomSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
    
    var Selected=false;
    
 	var SelRowid=document.getElementById("TRowidz"+selectrow).value;
	var RoomCode=document.getElementById("TRoomCodez"+selectrow).innerText;
	var RoomName=document.getElementById("TRoomNamez"+selectrow).innerText;
	var LocName=document.getElementById("TLocNamez"+selectrow).innerText
	var LocID=document.getElementById("TLocIDz"+selectrow).value;
	
	
	
	var SeleRowidObj=document.getElementById("SelRowid");
	if (SeleRowidObj)
	{
		SeleRowidObj.value=SelRowid;
	}
	
	var RoomCodeObj=document.getElementById("RoomCode");
	if (RoomCodeObj)
	{
		RoomCodeObj.value=RoomCode;
	}
	var RoomNameObj=document.getElementById("RoomName");
	if (RoomNameObj)
	{
		RoomNameObj.value=RoomName;
	}

	var SelLocObj=document.getElementById("SelLocList");
	if (SelLocObj)
	{
		SelLocObj.value=LocID;
		SelLocObj.text=LocName;
	}
	
	Selected=true;
	
	if(Selected)
	{
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisRoomEquipment"+"&RoomDR="+SelRowid;
       	parent.frames['RoomEquipment'].location.href=lnk; 
	}
	
}


//��ʼ��������Ϣ
function GetALLLoc()
{
    tTypeObj=document.getElementById("SelLocList");
    if (tTypeObj)
    {
 		combo("SelLocList");
		var GetAllLocFunction=document.getElementById("GetAllLoc").value;
		var Info1=cspRunServerMethod(GetAllLocFunction);
    	AddItem("SelLocList",Info1);
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


function SetLocRoomFun(Info,OperateCode)
{
	var SetLocRoomFun=document.getElementById("SetRoomFun").value;
	var value=cspRunServerMethod(SetLocRoomFun,Info,OperateCode);
	if (value!="0")
	{  
	     if(OperateCode=="I")
	     {
		    var Info="����ʧ��:SQLCODE="+value;
		 }
	     if(OperateCode=="U")
	     {
		    var Info="����ʧ��:SQLCODE="+value;
		 }
		 else
		 {
			 if ( value=="-999")
			 {
				 var Info="����ɾ���豸��������ɾ�����!";
			 }
			 else
			 {
				var Info="ɾ��ʧ��:SQLCODE="+value;
			 }
	     }	 
		
	     alert(Info);
	}
	else
	{   
		var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCRisLocRoomSet";
   		location.href=lnk; 
	}
	
}



document.body.onload = BodyLoadHandler;


