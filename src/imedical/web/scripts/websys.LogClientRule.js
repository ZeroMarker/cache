var idobj,codeobj,descobj,typeobj,typecodeobj,keycodeobj,keydescobj,altobj,ctrlobj,activeobj;
var addobj,updateobj,deleteobj,clearobj;
var alt,ctrl,act;
document.body.onload=function(){
	idobj=document.getElementById("LogCRId");
	codeobj=document.getElementById("LogCRCode");
	descobj=document.getElementById("LogCRDesc");
	typecodeobj = document.getElementById("LogCRTypeCode");
	typeobj=document.getElementById("LogCRType");
	keydescobj=document.getElementById("LogCRKeyDesc");
	keycodeobj=document.getElementById("LogCRKeyCode");
	altobj=document.getElementById("LogCRAlt");
	ctrlobj=document.getElementById("LogCRCtrl");
	activeobj=document.getElementById("LogCRActive");
	
	activeobj.checked=true;
	
	addobj=document.getElementById("Add");
	updateobj=document.getElementById("Update");
	deleteobj=document.getElementById("Delete");
	clearobj=document.getElementById("Clear");

	if (addobj) addobj.onclick=add_click;
	if (updateobj) updateobj.onclick=update_click;
	if (deleteobj) deleteobj.onclick=delete_click;
	if (clearobj) clearobj.onclick=clear_click;
	
}
function check(){
	if(codeobj.value=="") {alert("请输入代码");return false;}
	if(descobj.value=="") {alert("请输入名称");return false;}
	if(typeobj.value=="") {alert("请输入类型：M表示鼠标，K表示键盘");return false;}
    if(keycodeobj.value=="") {alert("请输入键值");return false;}
	return true;
}
function LogCRTypeHandler(str){
	typecodeobj.value = str.split("^")[1];
}
function LogCRKeyDescHandler(str){
	keycodeobj.value = str.split("^")[1];
}

//   Save(Id, Code, Desc, hldimgname, hldIsLunar, hldDays, hldActive)
function add_click(){
	if(!check()){return false;}
	var id="";
	var code=codeobj.value;
	var desc=descobj.value;
	var type=typecodeobj.value;
	var keycode=keycodeobj.value;
	
	if(altobj.checked){
		alt="Y";
	}else{
		alt="N";
	}
	
	if(ctrlobj.checked){
		ctrl="Y";
	}else{
		ctrl="N";
	}
	
	if(activeobj.checked){
		act="Y";
	}else{
		act="N";
	}
	
	var encobj=document.getElementById("encsave");
	var enc=encobj.value;
	//ClassMethod Save(Id, LogCRCode, LogCRDesc, LogCRType, LogCRKeyCode, LogCRAlt, LogCRCtrl, LogCRActive)
	var rtn = cspHttpServerMethod(enc,id,code,desc,type,keycode,alt,ctrl,act);
	rtn = parseFloat(rtn);
	if (rtn>0){
		alert("增加成功");
		Find_click();
	}else{
		alert("失败");
	}
}
function update_click(){
	var id=idobj.value;
	if(id=="") {alert("请选择要修改的行");return false;}
	if(!check()){return false;}
	var code=codeobj.value;
	var desc=descobj.value;
	var type=typecodeobj.value;
	var keycode=keycodeobj.value;
	
	if(altobj.checked){
		alt="Y";
	}else{
		alt="N";
	}
	
	if(ctrlobj.checked){
		ctrl="Y";
	}else{
		ctrl="N";
	}
	
	if(activeobj.checked){
		act="Y";
	}else{
		act="N";
	}
	
	var encobj=document.getElementById("encsave");
	var enc=encobj.value;
	//ClassMethod Save(Id, LogCRCode, LogCRDesc, LogCRType, LogCRKeyCode, LogCRAlt, LogCRCtrl, LogCRActive)
	var rtn = cspHttpServerMethod(enc,id,code,desc,type,keycode,alt,ctrl,act);
	rtn = parseFloat(rtn);
	if (rtn>0){
		alert("更新成功");
		Find_click();
	}else{
		alert("失败");
	}
}
function clear_click(){
	codeobj.value="";
	descobj.value="";
	typecodeobj.value="";
	typeobj.value="";
	keycodeobj.value="";
	keydescobj.value="";
	altobj.checked=false;
	ctrlobj.checked=false;
	activeobj.checked=true;
	
	idobj.value="";
	Find_click();
}
function delete_click(){
	var id=idobj.value;
	if(id=="") {alert("请选择要删除的行");return false;}
	var encobj=document.getElementById("encdel");
	var enc=encobj.value;
	
	var rtn = cspHttpServerMethod(enc,id);
	rtn = parseFloat(rtn);
	if (rtn>0){
		alert("删除成功");
		clear_click();
	}else{
		alert("失败");
	}
}

var SelectRowHandler = function(){
	if(selectedRowObj.rowIndex>0){
		var code = document.getElementById("LogCRCodez"+selectedRowObj.rowIndex).innerText;
		var desc = document.getElementById("LogCRDescz"+selectedRowObj.rowIndex).innerText;
		var type = document.getElementById("LogCRTypez"+selectedRowObj.rowIndex).innerText;
		var typecode = document.getElementById("LogCRTypeCodez"+selectedRowObj.rowIndex).value;
		
		var keycode = document.getElementById("LogCRKeyCodez"+selectedRowObj.rowIndex).value;
		var keydesc = document.getElementById("LogCRKeyDescz"+selectedRowObj.rowIndex).innerText;
		
		var altz = document.getElementById("LogCRAltz"+selectedRowObj.rowIndex).innerText;
		var ctrlz = document.getElementById("LogCRCtrlz"+selectedRowObj.rowIndex).innerText;
		var actz = document.getElementById("LogCRActivez"+selectedRowObj.rowIndex).innerText;
		var id = document.getElementById("LogCRIdz"+selectedRowObj.rowIndex).value;
		
		
		codeobj.value=code;
		descobj.value=desc;
		typeobj.value=type;
		typecodeobj.value=typecode;
		keycodeobj.value=keycode;
		keydescobj.value=keydesc;
		if(altz=="Y"){
			altobj.checked=true;
		}else{
			altobj.checked=false;
		}
		if(ctrlz=="Y"){
			ctrlobj.checked=true;
		}else{
			ctrlobj.checked=false;
		}
		if(actz=="Y"){
			activeobj.checked=true;
		}else{
			activeobj.checked=false;
		}		
		idobj.value=id;
	}else{
		codeobj.value="";
		descobj.value="";
		typeobj.value="";
		keycodeobj.value="";
		altobj.checked=false;
		ctrlobj.checked=false;
		activeobj.checked=true;	
		idobj.value="";
		typecodeobj.value="";
		keydescobj.value="";
	}
	
}