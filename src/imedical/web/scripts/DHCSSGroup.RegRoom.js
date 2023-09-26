document.body.onload = BodyLoadHandler;

function DocumentUnloadHandler(e){
}
function BodyLoadHandler() {
	var obj=document.getElementById('Save');
	if (obj) obj.onclick=SaveClickhandler;
	
	var RoomStr=DHCC_GetElementData('RoomStr');
	var obj=document.getElementById('Room');
	if (obj) {
		DHCC_AddItemToListByStr('Room',RoomStr);
	}

	var GroupRegRoomStr=DHCC_GetElementData('GroupRegRoomStr');
	//alert(GroupRegRoomStr);

	var obj=document.getElementById('Save');
	if (obj) obj.onclick=SaveClickhandler;
	
	var obj=document.getElementById('Room');
	if (obj) {
		var Arr1=GroupRegRoomStr.split("!")
		for (var i=0;i<Arr1.length;i++) {
			var RoomRowId=Arr1[i];
			for (var j=0;j<obj.length;j++) {
				if (obj.options[j].value==RoomRowId){
					obj.options[j].selected=true;
				}
			}
		}		
	}
}

function SaveClickhandler(e){
	var GroupRegRoomStr="";
	
	var roomlist=document.getElementById('Room');
	for (var i=0;i<roomlist.length;i++) {
		if (roomlist.options[i].selected){
			var RoomRowId=roomlist.options[i].value;
			if (GroupRegRoomStr==""){
				GroupRegRoomStr=RoomRowId;
			}else{
				GroupRegRoomStr=GroupRegRoomStr+"!"+RoomRowId;
			}
		}
	}
	
	var encmeth=DHCC_GetElementData('SaveGroupRegRoomMethod');
	if (encmeth!=''){
		var GroupRowId=DHCC_GetElementData('GroupRowId');
		//alert(GroupRegRoomStr);
		var retDetail=cspRunServerMethod(encmeth,GroupRowId,GroupRegRoomStr);
		alert(t['SaveOK']);
	}	
}