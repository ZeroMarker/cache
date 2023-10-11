String.prototype.trim = function(){
	return this.replace(/(^\s+)|(\s+$)/g,"");
}
var SetInputValueByTable = function(colname, inname){
	if (inname=="") return ;
	var inputObj = document.getElementById(inname);
	if (!inputObj) return ;
	if (colname=="") {
		if (inputObj.type.toUpperCase()=="CHECKBOX"){
			inputObj.checked = false;
		}else{
			inputObj.value = "";
		}
		return ;
	}
	var obj = document.getElementById(colname);
	var val;
	if (obj){
		if (obj.tagName=="LABEL"){
			val = obj.innerText;
		}
		if (obj.tagName=="INPUT"){
			val = obj.value;
		}
		if (inputObj.type.toUpperCase()=="CHECKBOX"){
			if (val=="Y"){
				inputObj.checked = true;
			}else{
				inputObj.checked = false;
			}
		}else{
			inputObj.value = val.trim();
		}
	}
}
var SelectRowHandler = function(){
	if(selectedRowObj.rowIndex){
		SetInputValueByTable("Namez"+selectedRowObj.rowIndex, "ViewName");
		SetInputValueByTable("Captionz"+selectedRowObj.rowIndex, "ViewCaption");
		SetInputValueByTable("LinkUrlz"+selectedRowObj.rowIndex, "ViewLinkUrl");
		SetInputValueByTable("LinkComponentz"+selectedRowObj.rowIndex, "ViewLinkComponent");
		SetInputValueByTable("IDz"+selectedRowObj.rowIndex, "ViewID");
		document.getElementById("Delete").disabled = false;
	}else{
		Clear();
	}
}	
var Clear = function(){
	SetInputValueByTable("", "ViewName");
	SetInputValueByTable("", "ViewCaption");
	SetInputValueByTable("", "ViewLinkUrl");
	SetInputValueByTable("", "ViewLinkComponent");
	SetInputValueByTable("", "ViewID");
	document.getElementById("Delete").disabled = true;
}
var ClearAndFindHandler = function(){
	Clear();
	Find_click();
}
var SaveBtnClickHandler = function(){
	
	var ViewID = document.getElementById("ViewID").value;
	var ViewName = document.getElementById("ViewName").value;
	var ViewCaption = document.getElementById("ViewCaption").value;
	var ViewLinkUrl = document.getElementById("ViewLinkUrl").value;
	var ViewLinkComponent = document.getElementById("ViewLinkComponent").value;
	var enc = document.getElementById("SaveEnc").value;
	
	var rtn = cspRunServerMethod(enc,ViewID,ViewName,ViewCaption,ViewLinkUrl,ViewLinkComponent);
	// tkMakeServerCall("websys.View","Save",ViewID,ViewName,ViewCaption,ViewLinkUrl,ViewLinkComponent) ; //
	var rtnArr = rtn.split("^");
	if (rtnArr.length==2){
		if (rtnArr[0]=="0"){
			alert(t["SaveSucc"]);
			ClearAndFindHandler();
		}else{
			alert(t["SaveFail"]);
		}
	}else{
		alert(t["SaveFail"]);
	}
}
var DeleteBtnClickHandler = function(){
	if(confirm(t["DelConfirm"]||"确定要删除吗？")){
		var sid = document.getElementById("ViewID").value;
		var enc = document.getElementById("DeleteEnc").value;
		var rtn = cspRunServerMethod(enc,sid);
		var rtnArr = rtn.split("^");
		if (rtnArr.length==2){
			if (rtnArr[0]=="0"){
				alert(t["DelSucc"]);
				ClearAndFindHandler();
			}else if(rtnArr[0]=="-102"){
				var msg=t["DelFail"]+"\n"
					   +(t["Err102"]||"此视图被以下第三方系统引用,禁止删除")+"\n"
					   +"  "+rtnArr[1].split("|").join("\n  ");
				alert(msg);
			}else{
				alert(t["DelFail"]);
			}
		}else{
			alert(t["DelFail"]);
		}
	}
}
var BodyLoadHandler = function(){
	var saveBtn = document.getElementById("Save");
	saveBtn.onclick = SaveBtnClickHandler;
	var deleteBtn = document.getElementById("Delete");
	deleteBtn.onclick = DeleteBtnClickHandler;
	deleteBtn.disabled = true;
}
document.body.onload = BodyLoadHandler;