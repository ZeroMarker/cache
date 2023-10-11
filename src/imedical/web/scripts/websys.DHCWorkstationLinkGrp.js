var model=["WSLGRowId","WSLGGrpDr","WSLGGrpDesc","WSLGLocDr","WSLGLocDesc",];
var WSLGWSDr = "";
var SetInputValueByTable = websys_SetValByCol ;
var SelectRowHandler = function(){
	//alert("你选择的是第"+selectedRowObj.rowIndex+"行");
	if(selectedRowObj.rowIndex){
		for(var i=0; i<model.length; i++){
			websys_SetValByCol("T"+model[i]+"z"+selectedRowObj.rowIndex, model[i])
		}
		document.getElementById("Del").disabled = false;
	}else{
		for(var i=0; i<model.length; i++){
			websys_SetValByCol("",model[i])
		}
		document.getElementById("Del").disabled = true;
	}
}	
var SaveBtnClickHandler = function(){
	var WSLGRowId = document.getElementById("WSLGRowId").value;
	var WSLGGrpDr = "";
	if(document.getElementById("WSLGGrpDesc").value!=""){
		WSLGGrpDr = document.getElementById("WSLGGrpDr").value;
	}else{
		WSLGGrpDr = "";
	}
	
	var WSLGLocDr =""
	if (document.getElementById("WSLGLocDesc").value!=""){
		WSLGLocDr = document.getElementById("WSLGLocDr").value;
	}else{
		WSLGLocDr = "";
	}
	if (document.getElementById("WSLGGrpDesc").value == "" && document.getElementById("WSLGLocDesc").value == ""){
		alert(t["GrpLocDescIsNull"]);
		return ;
	}
	var rtn = tkMakeServerCall("websys.DHCWorkstationLnkGrp","Save",WSLGRowId, WSLGWSDr, WSLGGrpDr, WSLGLocDr);
	if (rtn>0){
		alert(t["SaveSucc"]);
		clearBtnClickHandler();
		Find_click();
	}else{
		var rtnArr = rtn.split("^");
		if (rtnArr.length==2){
			alert(rtnArr[1]);
		}else{
			alert(t["SaveFail"]);
		}
	}
}
var DeleteBtnClickHandler = function(){
	var WSLGRowId = document.getElementById("WSLGRowId").value;
	var rtn = tkMakeServerCall("websys.DHCWorkstationLnkGrp","Delete",WSLGRowId);
	if (rtn>0){
		alert(t["DelSucc"]);
		clearBtnClickHandler();
		Find_click();
	}else{
		var rtnArr = rtn.split("^");
		if (rtnArr.length==2){
			alert(rtnArr[1]);
		}else{
			alert(t["DelFail"]);
		}
	}
}
var GroupSelect = function(str){
	var arr = str.split("^");
	document.getElementById("WSLGGrpDr").value = arr[1];
}
var LocSelect = function(str){
	var arr = str.split("^");
	document.getElementById("WSLGLocDr").value = arr[1];
}
var clearBtnClickHandler = function(){
	for(var i=0; i<model.length; i++){
		websys_SetValByCol("",model[i])
	}
}
var BodyLoadHandler = function(){
	WSLGWSDr = document.getElementById("WSLGWSDr").value;
	var saveBtn = document.getElementById("Save");
	saveBtn.onclick = SaveBtnClickHandler;
	var deleteBtn = document.getElementById("Del");
	deleteBtn.onclick = DeleteBtnClickHandler;
	deleteBtn.disabled = true;
	var clearBtn = document.getElementById("Clear");
	clearBtn.onclick = clearBtnClickHandler;
	var WSLGLocDescObj = document.getElementById("WSLGLocDesc");
}
document.body.onload = BodyLoadHandler;