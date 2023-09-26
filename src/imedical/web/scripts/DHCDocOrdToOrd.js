document.body.onload = BodyLoadHandler;
var SelectedRow=0;
function BodyLoadHandler()
{
	var obj=document.getElementById("Add");
	if (obj){ obj.onclick=AddClickHandler;}
	var obj=document.getElementById("Delete");
	if (obj){ obj.onclick=DelClickHandler;}
	var obj=document.getElementById("Update");
	if (obj){ obj.onclick=UpdateClickHandler;}
	var obj=document.getElementById("arcimDesc");
	if (obj){ obj.onchange=ArcimChangeHandler;}
	var obj=document.getElementById("linkArcimDesc");
	if (obj){ obj.onchange=LinkArcimChangeHandler;}
	
}
function ArcimChangeHandler(e){
	var obj=document.getElementById("arcimDesc");
	if (obj){
		if (obj.value=="") {
			var obj=document.getElementById('arcimID');
			if (obj) obj.value="";
		}
	}
}
function LinkArcimChangeHandler(e){
	var obj=document.getElementById("linkArcimDesc");
	if (obj){
		if (obj.value=="") {
			var obj=document.getElementById('linkArcimID');
			if (obj) obj.value="";
		}
	}
}
function LookUpMasterItem(value){
   var temp;
   temp=value.split("^");
   arcimId=temp[1];
   document.getElementById('arcimID').value=arcimId
}
function LookUpLinkItem(value){
	var temp;
 	temp=value.split("^");
 	LinkArcimId=temp[1];
 	document.getElementById('linkArcimID').value=LinkArcimId;
}
function AddClickHandler(){ 
	var arcimID,linkArcimID,StDate,EndDate,encmeth;
	var obj1=document.getElementById('arcimID');
	if(obj1){ arcimID=obj1.value;}
	if(arcimID==""){
		alert(t['ARCIMEmpty'])
		return;
		}
	var obj2=document.getElementById('linkArcimID');
	if(obj2){ linkArcimID=obj2.value;}
	if(linkArcimID==""){
		//alert(t['LINKARCIMEmpty']);
		alert("关联医嘱项为空！")
		return;
		}
	var StDateOBJ=document.getElementById('StDate');
	if (StDateOBJ){StDate=StDateOBJ.value;}
	if(StDate==""){
		alert("开始时间不能为空")
		return;
		}
	var EndDateOBJ=document.getElementById('EndDate');
	if (EndDateOBJ){EndDate=EndDateOBJ.value;}
	if(EndDate==""){
		//alert("结束时间不能为空")
		//return;
	}
	var InserMethodOBJ=document.getElementById('insert')
	if(InserMethodOBJ){ var encmeth=InserMethodOBJ.value;}  else{var encmeth=""};
		if(encmeth!=""){
			var ret=cspRunServerMethod(encmeth,arcimID,linkArcimID,StDate,EndDate);
			if(ret==0){
				alert(t['AddSuccess']);
				location.reload();   
				}else{
					alert(t['AddFail'])};
			}
	}
function DelClickHandler(){
	if (SelectedRow==0){
		alert("请选择一条记录")
		return;
		}
	var TarcimID,TlinkArcimID;
	var TarcimID=document.getElementById("arcimID").value;
	var TlinkArcimID=document.getElementById("linkArcimID").value;
	var LRowid=document.getElementById("LRowidz"+SelectedRow).value
	var DelMethodOBJ=document.getElementById('DeleteMethod')
	if(DelMethodOBJ){ var encmeth=DelMethodOBJ.value;}  else{var encmeth=""};
		if (encmeth!=""){
			var ret=cspRunServerMethod(encmeth,TarcimID,TlinkArcimID,LRowid)
			if (ret==0){
				alert(t['DelSuccess']);
				location.reload();   
				}else{
					alert(t['DelFail'])};
			}	
	}
function UpdateClickHandler(){
	if (SelectedRow==0){
		alert("请选择一条记录")
		return;
	}
	var TarcimIDOld=document.getElementById("TarcimIDz"+SelectedRow).value
	var TlinkArcimIDOld=document.getElementById("TlinkArcimIDz"+SelectedRow).value
	var obj1=document.getElementById('arcimID');
	if(obj1){ arcimID=obj1.value;}
	if(arcimID==""){
		alert(t['ARCIMEmpty'])
		return;
	}
	var obj2=document.getElementById('linkArcimID');
	if(obj2){ linkArcimID=obj2.value;}
	if(linkArcimID==""){
		//alert(t['LINKARCIMEmpty']);
		alert("关联医嘱项为空！")
		return;
	}
	var StDateOBJ=document.getElementById('StDate');
	if (StDateOBJ){StDate=StDateOBJ.value;}
	if(StDate==""){
		alert("开始时间不能为空")
		return;
	}
	var EndDateOBJ=document.getElementById('EndDate');
	if (EndDateOBJ){EndDate=EndDateOBJ.value;}
	/*if(EndDate==""){
		alert("结束时间不能为空")
		return;
	}*/
	var LRowid=document.getElementById("LRowidz"+SelectedRow).value
	var InserMethodOBJ=document.getElementById('Up')
	if(InserMethodOBJ){ var encmeth=InserMethodOBJ.value;}  else{var encmeth=""};
	if(encmeth!=""){
			var ret=cspRunServerMethod(encmeth,arcimID,linkArcimID,StDate,EndDate,TarcimIDOld,TlinkArcimIDOld,LRowid);
			if(ret==0){
				alert(t['UpdateSuccess']);
				location.reload();   
			}else{
				alert(t['UpdateFail'])
			};
	}
}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCDocOrdToOrd');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (selectrow!=SelectedRow){
		var arcimDesc=document.getElementById('arcimDesc');
		var linkArcimDesc=document.getElementById('linkArcimDesc');
		var StDate=document.getElementById('StDate');
		var EndDate=document.getElementById('EndDate');
		var arcimID=document.getElementById('arcimID');
		var linkArcimID=document.getElementById('linkArcimID');
	 
		var TArcimDesc=document.getElementById('TArcimDescz'+selectrow);
		var TlinkArcimDesc=document.getElementById('TlinkArcimDescz'+selectrow);
		var TStDate=document.getElementById('TStDatez'+selectrow);
		var TEndDate=document.getElementById('TEndDatez'+selectrow);
		var TarcimID=document.getElementById('TarcimIDz'+selectrow);
		var TlinkArcimID=document.getElementById('TlinkArcimIDz'+selectrow);
	    arcimDesc.value=TArcimDesc.innerText;
		linkArcimDesc.value=TlinkArcimDesc.innerText;
		StDate.value=TStDate.innerText;
		//if (TEndDate.innerText!=" "){
			EndDate.value=TEndDate.innerText.replace(/(^\s*)|(\s*$)/g, "");  ;
		//}
		arcimID.value=TarcimID.value;
		linkArcimID.value=TlinkArcimID.value;
		SelectedRow=selectrow;
		return;
	}else{
		SelectedRow=0;
		clearNull();
	}
}
function clearNull()
{
	var obj=document.getElementById('arcimDesc');
	if(obj){obj.value="";}
	var obj=document.getElementById('linkArcimDesc');
	if(obj){obj.value="";}
	var obj=document.getElementById('StDate');
	if(obj){obj.value="";}
	var obj=document.getElementById('EndDate');
	if(obj){obj.value="";}
	var obj=document.getElementById('arcimID');
	if(obj){obj.value="";}
	var obj=document.getElementById('linkArcimID');
	if(obj){obj.value="";}
}