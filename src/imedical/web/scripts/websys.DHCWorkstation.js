var SetInputValueByTable = websys_SetValByCol ;
var SelectRowHandler = function(){
	//alert("你选择的是第"+selectedRowObj.rowIndex+"行");
	if(selectedRowObj.rowIndex){
		SetInputValueByTable("TWSRowIdz"+selectedRowObj.rowIndex, "WSRowId");
		SetInputValueByTable("TWSCodez"+selectedRowObj.rowIndex, "WSCode");
		SetInputValueByTable("TWSDescz"+selectedRowObj.rowIndex, "WSDesc");
		document.getElementById("Del").disabled = false;
	}else{
		SetInputValueByTable("", "WSRowId");
		SetInputValueByTable("", "WSCode");
		SetInputValueByTable("", "WSDesc");
		document.getElementById("Del").disabled = true;
	}
}	
var SaveBtnClickHandler = function(){
	var WSRowId = document.getElementById("WSRowId").value;
	var WSCode = document.getElementById("WSCode").value;
	var WSDesc = document.getElementById("WSDesc").value;
	var rtn = tkMakeServerCall("websys.DHCWorkstation","Save",WSRowId, WSCode, WSDesc, "");
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
	var WSRowId = document.getElementById("WSRowId").value;
	var rtn = tkMakeServerCall("websys.DHCWorkstation","Delete",WSRowId);
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
var clearBtnClickHandler = function(){
	SetInputValueByTable("", "WSRowId");
	SetInputValueByTable("", "WSCode");
	SetInputValueByTable("", "WSDesc");
}
var BodyLoadHandler = function(){
	var saveBtn = document.getElementById("Save");
	saveBtn.onclick = SaveBtnClickHandler;
	var deleteBtn = document.getElementById("Del");
	deleteBtn.onclick = DeleteBtnClickHandler;
	deleteBtn.disabled = true;
	var clearBtn = document.getElementById("Clear");
	clearBtn.onclick = clearBtnClickHandler;
}
document.body.onload = BodyLoadHandler;