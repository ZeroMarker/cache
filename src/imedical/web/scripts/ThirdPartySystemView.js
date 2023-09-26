var sysidobj,sysviewidobj,viewdrobj,viewnameobj,locdrobj,locnameobj,groupdrobj,groupnameobj,ipobj,cnameobj,datefobj,datetobj;
var addobj,updateobj,deleteobj,clearobj;

document.body.onload=function(){
	sysidobj=document.getElementById("SysId");
	sysviewidobj=document.getElementById("SysViewId");
	
	viewdrobj=document.getElementById("ViewViewDr");
	viewnameobj=document.getElementById("ViewViewCaption");
	locdrobj=document.getElementById("ViewLocDr");
	locnameobj=document.getElementById("ViewLocName");
	groupdrobj=document.getElementById("ViewGroupDr");
	groupnameobj=document.getElementById("ViewGroupName");
	
	ipobj=document.getElementById("ViewIP");
	cnameobj=document.getElementById("ViewCName");
	datefobj=document.getElementById("ViewDateFrom");
	datetobj=document.getElementById("ViewDateTo");
	
	addobj=document.getElementById("Add");
	updateobj=document.getElementById("Update");
	deleteobj=document.getElementById("Delete");
	clearobj=document.getElementById("Clear");
	
	if (addobj) addobj.onclick=add_click;
	if (updateobj) updateobj.onclick=update_click;
	if (deleteobj) deleteobj.onclick=delete_click;
	if (clearobj) clearobj.onclick=clear_click;
	
}
//ClassMethod Save(Id, SysCode, SysDesc, SysDateFrom, SysDateTo, SysCompany)
function check(){
	if (viewdrobj.value==""){alert("请选择View");return false;}
	if (locdrobj.value==""){alert("请选择科室");return false;}
	if (groupdrobj.value==""){alert("请选择安全组");return false;}
	if(!checkdate(datefobj.value.trim())){
		return false;
	}
	if(!checkdate(datetobj.value.trim())){
		return false;
	}
	return true;
}
function checkdate(str){
	if(str!=""){
		var DATE_FORMAT = /^[0-3]{1}[0-9]{1}\/[0-1]{1}[0-9]{1}\/[0-9]{4}$/;  
		if(!DATE_FORMAT.test(str)){  
			alert("日期格式错误！\r\n请使用右侧日历框输入日期，或者按照22/08/2016的格式输入");  
			return false;
		} 
	}
	return true;
	
}

function add_click(){
	if(!check()){return false;}
	var sysid=sysidobj.value;
	var sysviewrowid=""
	var viewdr=viewdrobj.value;
	var locdr=locdrobj.value;
	var groupdr=groupdrobj.value;
	var ip=ipobj.value;
	var cname=cnameobj.value;
	var datef=datefobj.value;
	var datet=datetobj.value;
	var encobj=document.getElementById("save");
	var enc=encobj.value;
	
	var rtn = cspHttpServerMethod(enc,sysviewrowid,sysid,viewdr,locdr,groupdr,ip,cname,datef,datet);

	rtn = parseFloat(rtn);
	if (rtn>0){
		alert("增加成功");
		Find_click();
	}else if(rtn=-101){
		alert("开始日期不能大于结束日期");
	}else{
		alert("失败");
	}
}
function update_click(){
	var sysviewrowid=sysviewidobj.value;
	if(sysviewrowid=="") {alert("请选择要修改的行");return false;}	
	if(!check()){return false;}
	var sysid=sysidobj.value;
	var viewdr=viewdrobj.value;
	var locdr=locdrobj.value;
	var groupdr=groupdrobj.value;
	var ip=ipobj.value;
	var cname=cnameobj.value;
	var datef=datefobj.value;
	var datet=datetobj.value;
	
	var encobj=document.getElementById("save");
	var enc=encobj.value;
	var rtn = cspHttpServerMethod(enc,sysviewrowid,sysid,viewdr,locdr,groupdr,ip,cname,datef,datet);
	rtn = parseFloat(rtn);
	if (rtn>0){
		alert("修改成功");
		Find_click();
	}else if(rtn=-101){
		alert("开始日期不能大于结束日期");
	}else{
		alert("失败");
	}
}
function clear_click(){
	viewdrobj.value="";
	viewnameobj.value="";
	locdrobj.value="";
	locnameobj.value="";
	groupdrobj.value="";		
	groupnameobj.value="";
	ipobj.value="";
	cnameobj.value="";
	datefobj.value="";
	datetobj.value="";
	sysviewidobj.value="";
	Find_click();
}
function delete_click(){
	var sysviewrowid=sysviewidobj.value;
	if(sysviewrowid=="") {alert("请选择要删除的行");return false;}
	var encobj=document.getElementById("del");
	var enc=encobj.value;
	
	var rtn = cspHttpServerMethod(enc,sysviewrowid);
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
		var viewname = document.getElementById("ViewViewCaptionz"+selectedRowObj.rowIndex).innerText;
		var locname = document.getElementById("ViewLocNamez"+selectedRowObj.rowIndex).innerText;
		var groupname = document.getElementById("ViewGroupNamez"+selectedRowObj.rowIndex).innerText;
		var ip = document.getElementById("ViewIPz"+selectedRowObj.rowIndex).innerText;
		var cname = document.getElementById("ViewCNamez"+selectedRowObj.rowIndex).innerText;
		var datef = document.getElementById("ViewDateFromz"+selectedRowObj.rowIndex).innerText;
		var datet = document.getElementById("ViewDateToz"+selectedRowObj.rowIndex).innerText;
		
		var sysviewid = document.getElementById("SysViewRowIdz"+selectedRowObj.rowIndex).innerText;
		var viewdr = document.getElementById("ViewViewDrz"+selectedRowObj.rowIndex).value;
		var locdr = document.getElementById("ViewLocz"+selectedRowObj.rowIndex).value;
		var groupdr = document.getElementById("ViewGroupz"+selectedRowObj.rowIndex).value;
		
		viewdrobj.value=viewdr;
		viewnameobj.value=viewname;
		locdrobj.value=locdr;
		locnameobj.value=locname;
		groupdrobj.value=groupdr;		
		groupnameobj.value=groupname;
		ipobj.value=ip.trim();
		cnameobj.value=cname.trim();
		datefobj.value=datef.trim();
		datetobj.value=datet.trim();
		sysviewidobj.value=sysviewid;
	}else{
		viewdrobj.value="";
		viewnameobj.value="";
		locdrobj.value="";
		locnameobj.value="";
		groupdrobj.value="";		
		groupnameobj.value="";
		ipobj.value="";
		cnameobj.value="";
		datefobj.value="";
		datetobj.value="";
		sysviewidobj.value="";
	}
	
}

function loclook(str) {
var tem=str.split("^");
//alert(tem[1]);
if(locdrobj) locdrobj.value=tem[1];

}
function grouplook(str) {
var tem=str.split("^");
//alert(tem[1]);
if(groupdrobj) groupdrobj.value=tem[1];

}
function viewlook(str) {
var tem=str.split("^");
//alert(tem[1]);
if(viewdrobj) viewdrobj.value=tem[1];

}

