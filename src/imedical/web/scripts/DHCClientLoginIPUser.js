//自动生成，请酌情修改
var addObj,deleteObj,updateObj,findObj,clearObj,encsaveObj,encdelObj,IdObj,CLIUActiveObj,CLIUComputerIpObj,CLIUComputerMacObj,CLIUComputerNameObj,CLIUUserIdObj;
var SetInputValueByTable = websys_SetValByCol ;
var GetInputValue = function(id){
	var obj = document.getElementById(id);
	if (obj.tagName=="LABEL"){
		return obj.innerText;
	}
	if (obj.tagName=="INPUT"){
		if (obj.type.toUpperCase()=="CHECKBOX"){
		if (obj.checked){
				return "Y";
			}else{
				return "N";
			}
		}
		return obj.value;
	}
	
	return obj.value;
}
var SelectRowHandler = function(){
	//alert('你选择的是第'+selectedRowObj.rowIndex+'行');
	if(selectedRowObj.rowIndex){
		SetInputValueByTable("TIdz"+selectedRowObj.rowIndex, "Id");
		SetInputValueByTable("TCLIUActivez"+selectedRowObj.rowIndex, "CLIUActive");
		SetInputValueByTable("TCLIUComputerIpz"+selectedRowObj.rowIndex, "CLIUComputerIp");
		SetInputValueByTable("TCLIUComputerMacz"+selectedRowObj.rowIndex, "CLIUComputerMac");
		SetInputValueByTable("TCLIUComputerNamez"+selectedRowObj.rowIndex, "CLIUComputerName");
		SetInputValueByTable("TCLIUUserIdz"+selectedRowObj.rowIndex, "CLIUUserId");
		SetInputValueByTable("TCLIUUserNamez"+selectedRowObj.rowIndex, "CLIUUserName");
		deleteObj.disabled = false;
		CLIUComputerIpObj.value=websys_trim(CLIUComputerIpObj.value);
		CLIUComputerMacObj.value=websys_trim(CLIUComputerMacObj.value);
		CLIUComputerNameObj.value=websys_trim(CLIUComputerNameObj.value);
		
	}else{
		SetInputValueByTable("", "Id");
		SetInputValueByTable("", "CLIUActive");
		SetInputValueByTable("", "CLIUComputerIp");
		SetInputValueByTable("", "CLIUComputerMac");
		SetInputValueByTable("", "CLIUComputerName");
		SetInputValueByTable("", "CLIUUserId");
		SetInputValueByTable("", "CLIUUserName");
		deleteObj.disabled = true;
	}
}
var AddBtnClickHandler = function(){
	
	var Id=IdObj.value;
	var CLIUActive=GetInputValue("CLIUActive");
	var CLIUComputerIp=CLIUComputerIpObj.value.trim();
	var CLIUComputerMac=CLIUComputerMacObj.value.trim();
	var CLIUComputerName=CLIUComputerNameObj.value.trim();
	var CLIUUserId=CLIUUserIdObj.value;
	if (CLIUUserId>0 && ((CLIUComputerIp!="")||(CLIUComputerMac!="")||(CLIUComputerName!=""))){
		var Id="";
		var enc=encsaveObj.value;
		var rtn = cspHttpServerMethod(enc,Id,CLIUActive,CLIUComputerIp,CLIUComputerMac,CLIUComputerName,CLIUUserId)
		if (rtn>0){
			alert("增加成功");
			Find_click();
		}else{
			alert("失败");
		}
	}else{
		if((CLIUComputerIp=="")&&(CLIUComputerMac=="")&&(CLIUComputerName=="")) {
			alert("客户端IP地址,客户端MAC地址,计算机名不能全为空！");
		}else if(CLIUUserId==""){
			alert("请选择用户");
		}
	}
}
var UpdateBtnClickHandler = function(){
	var Id=IdObj.value;
	var CLIUActive=GetInputValue("CLIUActive");
	var CLIUComputerIp=CLIUComputerIpObj.value.trim();
	var CLIUComputerMac=CLIUComputerMacObj.value.trim();
	var CLIUComputerName=CLIUComputerNameObj.value.trim();
	var CLIUUserId=CLIUUserIdObj.value;
	if (CLIUUserId>0 && ((CLIUComputerIp!="")||(CLIUComputerMac!="")||(CLIUComputerName!=""))){
		var enc=encsaveObj.value;
		var rtn = cspHttpServerMethod(enc,Id,CLIUActive,CLIUComputerIp,CLIUComputerMac,CLIUComputerName,CLIUUserId)
		if (rtn>0){
			alert("更新成功");
			Find_click();
		}else{
			alert("失败");
		}
	}else{
		if((CLIUComputerIp=="")&&(CLIUComputerMac=="")&&(CLIUComputerName=="")) {
			alert("客户端IP地址,客户端MAC地址,计算机名不能全为空！");
		}else if(CLIUUserId==""){
			alert("请选择用户");
		}
	}
}
var DeleteBtnClickHandler = function(){
	var Id=IdObj.value;
	if(id=="") {alert("请选择要删除的行");return false;}
	var enc=encdelObj.value;
	var rtn = cspHttpServerMethod(enc,Id);
	if (rtn>0){
		alert("删除成功");
		ClearBtnClickHandler();
	}else{
		alert("失败");
	}
}
var ClearBtnClickHandler = function(){
	var enc=encsaveObj.value;
	/*
	var rtn =  tkMakeServerCall("websys.Broker","Download","BO.bmp","http://127.0.0.1/dthealth/web/images/","HTTP");
	location.href = rtn;
	return ;
	var rtn = $cm({act:"download",fileName:"BO.bmp",dirName:"http://127.0.0.1/dthealth/web/images/",serverType:"HTTP"},false);
    location.href = rtn.href;
    return ;
    */
	SetInputValueByTable("", "Id");
	SetInputValueByTable("", "CLIUActive");
	SetInputValueByTable("", "CLIUComputerIp");
	SetInputValueByTable("", "CLIUComputerMac");
	SetInputValueByTable("", "CLIUComputerName");
	SetInputValueByTable("", "CLIUUserId");
	SetInputValueByTable("", "CLIUUserName");
	Find_click();
}
var BodyLoadHandler = function(){
	IdObj=document.getElementById("Id");
	CLIUActiveObj=document.getElementById("CLIUActive");
	CLIUComputerIpObj=document.getElementById("CLIUComputerIp");
	CLIUComputerMacObj=document.getElementById("CLIUComputerMac");
	CLIUComputerNameObj=document.getElementById("CLIUComputerName");
	CLIUUserIdObj=document.getElementById("CLIUUserId");
	CLIUUserNameObj=document.getElementById("CLIUUserName");
	addObj=document.getElementById("Add");
	addObj.onclick=AddBtnClickHandler;
	deleteObj=document.getElementById("Delete");
	deleteObj.onclick=DeleteBtnClickHandler;
	updateObj=document.getElementById("Update");
	updateObj.onclick=UpdateBtnClickHandler;
	findObj=document.getElementById("Find");
	clearObj=document.getElementById("Clear");
	clearObj.onclick=ClearBtnClickHandler;
	encsaveObj=document.getElementById("encsave");
	encdelObj=document.getElementById("encdel");
	var obj = document.getElementById("SingleHospId");
	var comp = GenUserHospComp({defaultValue:obj.value||(session&&session['LOGON.HOSPID'])});
	comp.options().onSelect = function(ind,row){
		//var curHospCode = row["HOSPCode"];
		var obj = document.getElementById("SingleHospId");
		if (obj){
			obj.value = row["HOSPRowId"];
			Find_click();
		}
	}

}
var CLIUUserNameSelectRow = function(str){
	CLIUUserNameObj.value=str.split("^")[1];
	CLIUUserIdObj.value = str.split("^")[0];
}
document.body.onload = BodyLoadHandler;
