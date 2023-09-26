document.body.onload = BodyLoadHandler;

function DocumentUnloadHandler(e){
}
function BodyLoadHandler() {
	
	var obj=document.getElementById('Dep');
	if (obj) obj.onchange=DepchenageHandler;

	var obj=document.getElementById('Save');
	if (obj) obj.onclick=SaveClickhandler;
	
	var GroupRowId=DHCC_GetElementData('GroupRowId');
	var encmeth=DHCC_GetElementData('GetGroupResLocMethod');
	if (encmeth!=''){
		var retDetail=cspRunServerMethod(encmeth,"SetDepList",GroupRowId);
		if (retDetail==1) return true;
	}
}

function SetDepList(text,val){
	var obj=document.getElementById('Dep');
	obj.options[obj.length] = new Option(text,val);
}

function SaveClickhandler(e){
	var ResRowIdStr="";
	var doclist=document.getElementById('RegDoc');
	for (var i=0;i<doclist.length;i++) {
		if (doclist.options[i].selected){
			var ResRowId=doclist.options[i].value;
			if (ResRowIdStr==""){
				ResRowIdStr=ResRowId;
			}else{
				ResRowIdStr=ResRowIdStr+"!"+ResRowId;
			}
		}
	}

  var obj=document.getElementById('Dep');
	if (obj.selectedIndex!=-1){
		var Arr=obj.options[obj.selectedIndex].value.split(String.fromCharCode(1));
		Arr[1]=ResRowIdStr;
		DepResRowIdStr=Arr.join(String.fromCharCode(1));
		obj.options[obj.selectedIndex].value=DepResRowIdStr;
	}else{
		alert("未选择任何数据，请确认");
  		return;
	}

	var ResRowIdStr="";
	for (var j=0;j<obj.length;j++){
		var val=obj.options[j].value;
		var Arr=val.split(String.fromCharCode(1));
		if (Arr[1]!=""){
			if (ResRowIdStr==""){
				ResRowIdStr=Arr[1];
			}else{
				ResRowIdStr=ResRowIdStr+"!"+Arr[1];
			}
		}
	}
	/*if (ResRowIdStr=="") {
  		alert("未选择任何数据，请确认");
  		return;
  	}*/
  	
	var encmeth=DHCC_GetElementData('SaveGroupResMethod');
	if (encmeth!=''){
		var GroupRowId=DHCC_GetElementData('GroupRowId');
		var retDetail=cspRunServerMethod(encmeth,GroupRowId,ResRowIdStr);
		alert(t['SaveOK']);
	}
}

function DepchenageHandler(e){
	var obj=window.event.srcElement;
	var obj1=document.getElementById('RegDoc');
	DHCC_ClearAllList(obj1);
	if (obj) {
		if (obj.selectedIndex!=-1){
			var val=obj.options[obj.selectedIndex].value;
			var Arr=val.split(String.fromCharCode(1));
			var LocID=Arr[0];
			SetResDocList(LocID);

			var Arr1=Arr[1].split("!")
			for (var i=0;i<Arr1.length;i++) {
				var DocRowId=Arr1[i];
				for (var j=0;j<obj1.length;j++) {
					if (obj1.options[j].value==DocRowId){
						obj1.options[j].selected=true;
					}
				}
			}			
		}
	}
}

function SetResDocList(LocID){
	var obj=document.getElementById('GetResDocMethod');
	if (obj) {
		var encmeth=obj.value;
		//alert("encmeth:"+encmeth);
		if (encmeth!=''){
			var retDetail=cspRunServerMethod(encmeth,"AddToResDocList",LocID);
			if (retDetail==1) return true;
		}
	}	
}

function AddToResDocList(val){
	var obj=document.getElementById('RegDoc');
	var DocArray=val.split("^");
	for (var i=0;i<DocArray.length;i++) {
		var DocData=DocArray[i].split(String.fromCharCode(1));
		obj.options[obj.length] = new Option(DocData[1],DocData[0]);
	}
}