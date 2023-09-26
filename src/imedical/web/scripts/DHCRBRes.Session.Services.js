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
  var ServiceStr="";
  var obj=document.getElementById('GetServiceStr');
	if (obj) {ServiceStr=obj.value;} 
	
	var obj=document.getElementById("PutService");
	if (obj) {
		obj.size=1;
		obj.multiple=false;
		if (ServiceStr!=""){
			var ArrData=ServiceStr.split("^");
			for (var i=0;i<ArrData.length;i++) {
			 var ArrData1=ArrData[i].split(String.fromCharCode(1));
			 obj.options[obj.length] = new Option(ArrData1[1],ArrData1[0]);
			}
		}
		obj.selectedIndex=-1;
	}	

	var obj=document.getElementById("PutReminderDays");
	if (obj) {
		obj.size=1;
		obj.multiple=false;
	 	obj.options[obj.length] = new Option("挂号费",1);
	 	obj.options[obj.length] = new Option("诊查费",2);   
		obj.options[obj.length] = new Option("假日费",3); 
		obj.options[obj.length] = new Option("预约费",4); 

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
	var ServiceRowid=GetValue("PutService");
  var ReminderDaysCode=GetValue("PutReminderDays");
	
	if (ServiceRowid==""){
		alert(t['ServiceIsNull']);
		return
	}

	if (ReminderDaysCode==""){
		alert(t['ReminderDaysCodeIsNull']);
		return
	}
		
	var InsertData=ServiceRowid+"^"+ReminderDaysCode;

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
		var ServiceRowid=GetValue("PutService");
		var ReminderDaysCode=GetValue("PutReminderDays"); 
		if (ServiceRowid==""){
			alert(t['ServiceIsNull']);
			return
		}
	
		if (ReminderDaysCode==""){
			alert(t['ReminderDaysCodeIsNull']);
			return
		}
		var SerRowid=GetColumnData("SerRowid",SelectedRow);
		var UpdateData=SerRowid+"^"+ServiceRowid+"^"+ReminderDaysCode;
	
		var obj=document.getElementById('UpdateMethod');
		if (obj) {var encmeth=obj.value;}else{var encmeth=""}
		if (encmeth!=''){
 
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
		var SerRowid=GetColumnData("SerRowid",SelectedRow);
		var obj=document.getElementById('DeleteMethod');
		if (obj) {var encmeth=obj.value;}else{var encmeth=""}
		if (encmeth!=''){
			var retcode=cspRunServerMethod(encmeth,SerRowid);
			if (retcode==0){

				SelectedRow=0;
				Delete_click();
				return websys_cancel();
			}else{
				alert(t['Fail_Delete']);
				return websys_cancel();
			}
		}
	}catch(e){ alert(e.message);}
}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	
	//alert("selectrow:"+selectrow +" SelectedRow:"+SelectedRow);
	if (selectrow!=SelectedRow){
		var SerRBCServiceDR=GetColumnData("SerRBCServiceDR",selectrow);
		var SerReminderDaysCode=GetColumnData("SerReminderDaysCode",selectrow);  
		SetValue("PutService",SerRBCServiceDR);
		SetValue("PutReminderDays",SerReminderDaysCode);
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
	SetValue("PutService","");
	SetValue("PutReminderDays","");

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
