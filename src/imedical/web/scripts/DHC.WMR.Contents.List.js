function Delete_click(){
	if(confirm(t['DeleteRecordTrue'])){
	}else{
    	return;
    }
	var RowId=document.getElementById("ContentsRowIdz" + 
	                                                window.event.srcElement.id.replace("cmdDeletez", "")
	                                                 ).value;
	var Condition=RowId+"^"+"1";
	var obj=document.getElementById("MethodDeleteContInfo");
    if (obj) {var encmeth=obj.value} else {var encmeth=''}
    var Id=cspRunServerMethod(encmeth,Condition);
	if (Id<0){
		alert("DeleteFalse");
		return;
	}else{
		location.reload();
	}
}

function initEvent()
{
	var objtbl=document.getElementById("tDHC_WMR_Contents_List");
	for (var i=1;i<objtbl.rows.length;i++){
		document.getElementById("cmdDeletez"+i).onclick = Delete_click;
	}
}
initEvent();