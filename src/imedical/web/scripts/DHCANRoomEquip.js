var SelectedRow = 0;
var EquipRowidold=0,preRowInd=0;
function BodyLoadHandler(){
	var obj=document.getElementById('ADD')
	if(obj) obj.onclick=ADD_click;
	var obj=document.getElementById('UPDATE')
	if(obj) obj.onclick=UPDATE_click;
	var obj=document.getElementById('DELETE')
	if(obj) obj.onclick=DELETE_click;
	
	SetElementEnable();
}

function SetElementEnable()
{
    var limited = document.getElementById("Limited");
	if(!limited || limited.value!="Y")
	   return;
	
    var room = document.getElementById("Room");
    if(room)
        room.disabled=true;
        
    var roomLookUp = document.getElementById("ld52293iRoom");
    if(roomLookUp)
        roomLookUp.style.display="none";
        
    var equip = document.getElementById("Equip");
    if(equip)
        equip.disabled=true;
        
    var equipLookUp = document.getElementById("ld52293iEquip");
    if(equipLookUp)
        equipLookUp.style.display="none";
        
    var userIPAdress = document.getElementById("UserIPAdress");
    if(userIPAdress)
        userIPAdress.disabled=true;
        
    var defaultInterval = document.getElementById("DefaultInterval");
    if(defaultInterval)
        defaultInterval.disabled=true;
}

function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCANRoomEquip');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectRow=rowObj.rowIndex;
	if (!selectRow) return;
	var obj=document.getElementById('RoomRowid');
	var obj1=document.getElementById('Room');
    var obj2=document.getElementById('EquipRowid');
	// var obj3=document.getElementById('Equip'); Delete 2013.03.07
	var obj4=document.getElementById('Port');
	var obj5=document.getElementById('TcpipAddress');
	var obj6=document.getElementById('InterfaceProgram');
	var obj7=document.getElementById('DefaultInterval');
	var obj8=document.getElementById('Rowid');
	//sjq
	var obj9=document.getElementById('UserIPAdress');
	var obj10=document.getElementById('InterfaceProgramRowid');
	
	var SelRowObj=document.getElementById('TRoomRowidz'+selectRow);
	var SelRowObj1=document.getElementById('TRoomz'+selectRow);
	var SelRowObj2=document.getElementById('TEquipRowidz'+selectRow);
	var SelRowObj3=document.getElementById('TEquipz'+selectRow);
	var SelRowObj4=document.getElementById('TPortz'+selectRow);
	var SelRowObj5=document.getElementById('TTcpipAddressz'+selectRow);
	var SelRowObj6=document.getElementById('TInterfaceProgramz'+selectRow);
	var SelRowObj7=document.getElementById('TDefaultIntervalz'+selectRow);
	var SelRowObj8=document.getElementById('TRowidz'+selectRow);
	//sjq
	var SelRowObj9=document.getElementById('TUserIPAddressz'+selectRow);
    var SelRowObj10=document.getElementById('TInterfaceProgramRowidz'+selectRow);
    
    if (preRowInd==selectRow){
	    obj.value="";
    	obj1.value="";
    	obj2.value="";
    	//obj3.value="";
    	obj4.value="";
    	obj5.value="";
    	obj6.value="";
    	obj7.value="";
    	obj8.value="";
    	obj9.value="";
    	preRowInd=0;
    	obj10.value="";
    }
    else {

	    obj.value=SelRowObj.innerText;
		obj1.value=SelRowObj1.innerText;
		obj2.value=SelRowObj2.innerText;
		//obj3.value=SelRowObj3.innerText;
		obj4.value=SelRowObj4.innerText;
		obj5.value=SelRowObj5.innerText;
		obj6.value=SelRowObj6.innerText;
		obj7.value=SelRowObj7.innerText;
		obj8.value=SelRowObj8.innerText;
		obj9.value=SelRowObj9.innerText;
		 preRowInd=selectRow;
		 obj10.value = SelRowObj10.innerText;
    }
	EquipRowidold=SelRowObj2.innerText;
	//SelectedRow=selectRow;
	
	parent.frames['RPBottom'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCANCCollectTypeItem&MDIRowid="+obj10.value; 
    return;
}

function ADD_click(){
	var RoomRowid,EquipRowid,Room,Equip,InterfaceProgramRowid,Port,TcpipAddress,DefaultInterval,UserIPAdress;
	var obj=document.getElementById('Room')
	if(obj) var Room=obj.value;
	if(Room==""){
		alert(t['alert:RoomFill']) 
		return;
		}
	/*
	// delete 2013年3月7日
	//var obj=document.getElementById('Equip')
	//if(obj) var Equip=obj.value;
	//if(Equip==""){
	//	alert(t['alert:EquipFill']) 
	//	return;
	//	}
	var Equip="";
	var EquipRowid=document.getElementById('EquipRowid').value
	var obj=document.getElementById('RepRoomEquip')
	if(obj) Rerencmeth=obj.value;
	//alert(EquipRowid)
    var repflag=cspRunServerMethod(Rerencmeth,EquipRowid)
    if(repflag=="Y"){
		alert(t['alert:RoomOREruiprepeat'])
		 return;
		}
	*/
    var obj2=document.getElementById('RoomRowid');
    if(obj2) RoomRowid=obj2.value;
	var obj3=document.getElementById('TcpipAddress');
    if(obj3) TcpipAddress=obj3.value; 
	var obj4=document.getElementById('Port');
	if(obj4) Port=obj4.value;
	var obj5=document.getElementById('InterfaceProgramRowid');
	if(obj5) InterfaceProgramRowid=obj5.value;
	var obj6=document.getElementById('DefaultInterval');
	if(obj6) DefaultInterval=obj6.value;
	//sjq
	var obj9=document.getElementById('UserIPAdress');
	if(obj9) UserIPAdress=obj9.value;
	
	var obj=document.getElementById('Insert')
	if(obj) {
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,RoomRowid,EquipRowid,TcpipAddress,Port,InterfaceProgramRowid,DefaultInterval,UserIPAdress);
	    if (resStr==100) {alert(t['alert:FillError'])
		 return}
	    if (resStr!='0'){
			alert(t['alert:baulk']+resStr);
			return;
			}	
		else  alert(t['alert:success']);
		}
}
function UPDATE_click(){
	if (preRowInd<1) return;
	var Rowid
	var obj=document.getElementById('Rowid')
	if(obj) Rowid=obj.value;
	if(Rowid==""){
		alert(t['alert:Please Select One']) 
		return;
		}
	var RoomRowid,EquipRowid,Room,Equip,InterfaceProgramRowid,Port,TcpipAddress,DefaultInterval,UserIPAdress;
	var obj=document.getElementById('Room')
	if(obj) var Room=obj.value;
	if(Room==""){
		alert(t['alert:RoomFill']) 
		return;
		}
	/*
	// delete2013年3月7日
	var obj=document.getElementById('Equip')
	if(obj) var Equip=obj.value;
	if(Equip==""){
		alert(t['alert:EquipFill']) 
		return;
		}
	
	var EquipRowid=document.getElementById('EquipRowid').value	
	if(EquipRowidold!=EquipRowid) {
	var obj=document.getElementById('RepRoomEquip')
	if(obj) Rerencmeth=obj.value;
    var repflag=cspRunServerMethod(Rerencmeth,EquipRowid)
    if(repflag=="Y"){
		alert(t['alert:RoomOREruiprepeat'])
		 return;
		}
	}*/
    var obj2=document.getElementById('RoomRowid');
    if(obj2) RoomRowid=obj2.value;
	var obj3=document.getElementById('TcpipAddress');
    if(obj3) TcpipAddress=obj3.value; 
	var obj4=document.getElementById('Port');
	if(obj4) Port=obj4.value;
	var obj5=document.getElementById('InterfaceProgramRowid');
	if(obj5) InterfaceProgramRowid=obj5.value;
	var obj6=document.getElementById('DefaultInterval');
	if(obj6) DefaultInterval=obj6.value;
	//sjq
	var obj9=document.getElementById('UserIPAdress');
	if(obj9) UserIPAdress=obj9.value;
	var obj=document.getElementById('updateRoomEquip')
	if(obj) {
		var encmeth=obj.value;
	    var resStr=cspRunServerMethod(encmeth,Rowid,RoomRowid,EquipRowid,TcpipAddress,Port,InterfaceProgramRowid,DefaultInterval,UserIPAdress);
	    if (resStr!='0'){
			alert(t['alert:baulk']+":"+resStr);
			return;
			}	
		else  alert(t['alert:success']);
		}
}
function DELETE_click(){
	if (preRowInd<1) return;
	var Rowid
	var obj=document.getElementById('Rowid')
	if(obj) Rowid=obj.value;
	if(Rowid==""){
		alert(t['alert:Please Select One']) 
		return;
		}
	var obj=document.getElementById('DeleteRoomEquip')
	if(obj) var encmeth=obj.value;
	var resStr=cspRunServerMethod(encmeth,Rowid)
	if (resStr!='0')
		{alert(t['alert:baulk']);
		return;}	
	else alert(t['alert:success']);	
}
function addok(value)
	{if (value==0) {
		var findobj=document.getElementById('Find');
		if (findobj) findobj.click();
	//	window.location.reload();
		}}
function LookUpRoom(value){
var temp
 temp=value.split("^")
 RoomRowid=temp[1]
 document.getElementById('RoomRowid').value=RoomRowid
}
function LookUpEquip(value){
 temp=value.split("^")
 EquipRowid=temp[1]
document.getElementById('EquipRowid').value=EquipRowid
}

function LookUpInterfaceProgram(value){
    var temp=value.split("^")
    document.getElementById("InterfaceProgram").value = temp[2]
    document.getElementById("InterfaceProgramRowid").value=temp[0];
    }
document.body.onload = BodyLoadHandler;