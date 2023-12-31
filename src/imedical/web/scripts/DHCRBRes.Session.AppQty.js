var SelectedRow=0;
document.body.onload = BodyLoadHandler;

function BodyLoadHandler() {

	var obj=document.getElementById("Add");
	if (obj){obj.onclick=AddClickHandler;}	
	
	var obj=document.getElementById("Delete");
	if (obj){obj.onclick=DeleteClickHandler;}	
	
	var obj=document.getElementById("Update");
	if (obj){obj.onclick=UpdateClickHandler;}	

  //初始化
  var MethodStr=""
  var obj=document.getElementById('GetMethodStr');
	if (obj) {MethodStr=obj.value;}
	var obj=document.getElementById("PutMethod");
	if (obj) {
		obj.size=1;
		obj.multiple=false;
		if (MethodStr!=""){ 
			var ArrData=MethodStr.split("^");
			for (var i=0;i<ArrData.length;i++) {
			 var ArrData1=ArrData[i].split(String.fromCharCode(1));
			 obj.options[obj.length] = new Option(ArrData1[1],ArrData1[0]);
			}
			obj.selectedIndex=-1;
 
		}
	}	
}
 

function GetValue(name){
	var obj=document.getElementById(name);
	if (obj) {
		if (obj.tagName=="LABEL") {
			return obj.innerText;
		} else {
				return obj.value
		}
	}
	return "";
}
function AddClickHandler(e){
	var MethodRowid=GetValue("PutMethod");
	var Qty=GetValue("PutQty");
	
	if (MethodRowid==""){
		alert(t['MethodIsNull']);
		return false;
	}
 
	if ((Qty=="")||(Qty==0)){
		alert(t['QtyIsNull']);
		return false;
	} 
 
	
 
 var StartNum
=GetValue("PutStartNum");

	var InsertData=MethodRowid+"^"+Qty+"^"+StartNum;	

	var obj=document.getElementById('InsertMethod');
	
	if (obj) {var encmeth=obj.value;}else{var encmeth=""}
	//alert("encmeth:"+encmeth);
	if (encmeth!=''){
		var obj=document.getElementById("ResSessRowId");
		if (obj){
			var ResSessRowId=obj.value;
 
			var retcode=cspRunServerMethod(encmeth,ResSessRowId,InsertData);
			if (retcode==0){
				Add_click();
				return websys_cancel();
			}else if(retcode=="-201"){
				alert(t['QtyIsOver']);
				return websys_cancel();
			}else{
				alert(t['Fail_Insert']);
				return websys_cancel();
			}
		}
	}	
}

function UpdateClickHandler(e){
	if (SelectedRow==0){return;}
	try{
		var AQRowId=GetColumnData("AQRowId",SelectedRow);
		var MethodRowId=GetValue("PutMethod");
 
		var Qty
=GetValue("PutQty");
 
		var StartNum
=GetValue("PutStartNum");
 
		var UpdateData=AQRowId+"^"+MethodRowId+"^"+Qty+"^"+StartNum;

		var obj=document.getElementById('UpdateMethod');
		if (obj) {var encmeth=obj.value;}else{var encmeth=""}
		if (encmeth!=''){
			//alert(UpdateData);
			var retcode=cspRunServerMethod(encmeth,UpdateData);
			if (retcode==0){
				SelectedRow=0;
				Update_click(); 
				return websys_cancel();
			}else if(retcode=="-201"){
				alert(t['QtyIsOver']);
				return websys_cancel();
			}else{
				alert(t['Fail_Update']);
				return websys_cancel();
			}
		}
	}catch(e){
		alert(e.message)
	}
}

function DeleteClickHandler(e){
	if (SelectedRow==0){return;}
	try{
		var AQRowid=GetColumnData("AQRowId",SelectedRow);
		var obj=document.getElementById('DeleteMethod');
		if (obj) {var encmeth=obj.value;}else{var encmeth=""}
		if (encmeth!=''){
			var retcode=cspRunServerMethod(encmeth,AQRowid);
			if (retcode==0){
				SelectedRow=0;
				Delete_click()
;
				return websys_cancel();
			}else{
				alert(t['Fail_Delete']);
				return websys_cancel();
			}
		}
	}catch(e){
		alert(e.message)
;;
	}
}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	
	//alert("selectrow:"+selectrow +" SelectedRow:"+SelectedRow);
	if (selectrow!=SelectedRow){
		var AQMethodDR=GetColumnData("AQMethodDR",selectrow);
		var AQQty=GetColumnData("AQQty",selectrow);
		var AQStartNum=GetColumnData("AQStartNum",selectrow);
		SetValue("PutMethod",cspTrim(AQMethodDR));
 
		SetValue("PutQty",cspTrim(AQQty));
		SetValue("PutStartNum",cspTrim(AQStartNum));
		SelectedRow = selectrow;
	}else{
		SelectedRow=0;
		ClearValue();
		//ResetButton(0)
	}
}
function SetValue(name,value){
	var obj=document.getElementById(name);
	if (obj) {
		if (obj.tagName=="LABEL") {obj.innerText=value;} else {obj.value=value}
	}
} 

function ClearValue(){
	SetValue("PutMethod","");
	SetValue("PutQty","");
	SetValue("PutStartNum","");

}
function GetColumnData(ColName,Row){
	var CellObj=document.getElementById(ColName+"z"+Row);
	//alert(CellObj.id+"^"+CellObj.tagName+"^"+CellObj.value);
	if (CellObj){ 
		if (CellObj.tagName=='LABEL'){
			return CellObj.innerText;
		}else{
			if (CellObj.type=="checkbox"){return CellObj.checked;}else{return CellObj.value;}
		}
	}
	return "";
}
