var SelectedRow=0;
document.body.onload = BodyLoadHandler;
function BodyLoadHandler() {

	var obj=document.getElementById("Add");
	if (obj){obj.onclick=AddClickHandler;}	
	
	var obj=document.getElementById("Delete");
	if (obj){obj.onclick=DeleteClickHandler;}	
	
	var obj=document.getElementById("Update");
	if (obj){obj.onclick=UpdateClickHandler;}	
	
  //≥ı ºªØ
  var ReasonStr=""
  var obj=document.getElementById('GetReasonStr');
	if (obj) {ReasonStr=obj.value;}
	var obj=document.getElementById("PutReason");
	if ((obj)&&(ReasonStr!="")) {
		obj.size=1;
		obj.multiple=false;
 
		var ArrData=ReasonStr.split("^");
		for (var i=0;i<ArrData.length;i++) {
		 var ArrData1=ArrData[i].split(String.fromCharCode(1));
		 obj.options[obj.length] = new Option(ArrData1[1],ArrData1[0]);
		}
		obj.selectedIndex=-1;
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
	var ReasonRowId=GetValue("PutReason");
	var PutFrDate=GetValue("PutFrDate");
	var PutToDate=GetValue("PutToDate");
	var PutRemarks=GetValue("PutRemarks");
	
	if (PutFrDate==""){
		alert(t['PutFrDateIsNull']);
		return false;
	} 
 
	var InsertData=PutFrDate+"^"+PutToDate+"^"+ReasonRowId+"^"+PutRemarks;	
	
	var obj=document.getElementById('InsertMethod');
	if (obj) {var encmeth=obj.value;}else{var encmeth=""}
	//alert("encmeth:"+encmeth);
	if (encmeth!=''){
		var obj=document.getElementById("ResSessRowId");
		if (obj){
			var ResSessRowId=obj.value;
			//alert(ResSessRowId+"^"+InsertData);
			var retcode=cspRunServerMethod(encmeth,ResSessRowId,InsertData);
			if (retcode==0){
				Add_click();
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
		var RowId=GetColumnData("RowId",SelectedRow);
		var ReasonRowId=GetValue("PutReason");
		var PutFrDate=GetValue("PutFrDate");
		var PutToDate=GetValue("PutToDate");
		var PutRemarks=GetValue("PutRemarks");
		
		var UpdateData=RowId+"^"+PutFrDate+"^"+PutToDate+"^"+ReasonRowId+"^"+PutRemarks;

		if (PutFrDate==""){
			alert(t['FrDateIsNull']);
			return false;
		} 
	
		var obj=document.getElementById('UpdateMethod');
		if (obj) {var encmeth=obj.value;}else{var encmeth=""}
		if (encmeth!=''){
			//alert(UpdateData);
			var retcode=cspRunServerMethod(encmeth,UpdateData);
			if (retcode==0){
				SelectedRow=0;
				Update_click(); 
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
		var Rowid=GetColumnData("RowId",SelectedRow);
		var obj=document.getElementById('DeleteMethod');
		if (obj) {var encmeth=obj.value;}else{var encmeth=""}
		if (encmeth!=''){
			var retcode=cspRunServerMethod(encmeth,Rowid);
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
		var FrDate=GetColumnData("FrDate",selectrow);
		var ToDate=GetColumnData("ToDate",selectrow);
		var ReasonRowId=GetColumnData("ReasonRowId",selectrow);
		var Remarks=GetColumnData("Remarks",selectrow);

		SetValue("PutFrDate",FrDate);
		SetValue("PutToDate",ToDate);
		SetValue("PutReason",ReasonRowId);
		SetValue("PutRemarks",Remarks);
		SelectedRow = selectrow;
	}else{
		SelectedRow=0;
		ClearValue();
		//ResetButton(0)
	}
}
function SetValue(name,val){
	var obj=document.getElementById(name);
	if (obj) {
		if (obj.tagName=="LABEL") {obj.innerText=val;} else {obj.value=val}
	}
} 

function ClearValue(){
		SetValue("PutFrDate","");
		SetValue("PutToDate","");
		SetValue("PutReason","");
		SetValue("PutRemarks","");

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
