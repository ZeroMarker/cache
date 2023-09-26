var CurrentSel=0;

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHC_WMR_ContSub_List');
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
     
    //alert(selectrow+"/"+rows)
    
	if (!selectrow) return;
	var SelRowObj
	var obj
	
	if (selectrow==CurrentSel){
		var ContsubRowId=document.getElementById('ContSubRowIdz'+selectrow).value;
		Temp=ContsubRowId.split("||");
		var ContentsRowId=Temp[0];
		if (ContentsRowId=="") return;
		var lnk1="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.ContSub.Edit"+"&ContentsRowId="+ContentsRowId;
		parent.RPbottom.location.href=lnk1;

	    CurrentSel=0
	    return;
		}
	
	CurrentSel=selectrow;
	
	var cContSubRowId="";
	SelRowObj=document.getElementById('ContSubRowIdz'+selectrow);
	cContSubRowId=SelRowObj.value;
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.ContSub.Edit" + "&ContSubRowId="+cContSubRowId;
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.ContSub.Edit" + "&ContSubRowId="+cContSubRowId;
	parent.RPbottom.location.href=lnk;
}

function Edit_click(){
	
	var RowId=document.getElementById("ContSubRowIdz" + 
	                                                window.event.srcElement.id.replace("cmdEditz", "")
	                                                 ).value;
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.ContSub.Edit" + "&ContSubRowId="+RowId;
	parent.RPbottom.location.href=lnk;
}

function Delete_click(){
	
	if(confirm(t['DeleteRecordTrue'])){
		//true
	}else{
		//false
    	return;
    }
	
	var RowId=document.getElementById("ContSubRowIdz" + 
	                                                window.event.srcElement.id.replace("cmdDeletez", "")
	                                                 ).value;
	var Condition=RowId+"^"+"2";
	var obj=document.getElementById("MethodDeleteContInfo");
    
    if (obj) {var encmeth=obj.value} else {var encmeth=''}
    var Id=cspRunServerMethod(encmeth,Condition);
	if (Id<0){
		alert("DeleteFalse");
		return;
	}else{
		location.reload();
		parent.RPbottom.location.reload();
	}
}

function initEvent()
{
	var objtbl=document.getElementById("tDHC_WMR_ContSub_List");
	for (var i=1;i<objtbl.rows.length;i++){
		document.getElementById("cmdEditz"+i).onclick = Edit_click;
		document.getElementById("cmdDeletez"+i).onclick = Delete_click;
	}
}

initEvent();