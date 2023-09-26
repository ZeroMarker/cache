var sysidobj,sysviewidobj,viewdrobj,viewnameobj,locdrobj,locnameobj,groupdrobj,groupnameobj,ipobj,cnameobj,datefobj,datetobj;
var addobj,updateobj,deleteobj,clearobj;
var ViewTicketCodeObj,HISLogonUrl;
document.body.onload=function(){
	sysidobj=document.getElementById("SysId");
	sysviewidobj=document.getElementById("SysViewId");
	ViewTicketCodeObj = document.getElementById("ViewTicketCode");
	viewdrobj=document.getElementById("ViewViewDr");
	viewnameobj=document.getElementById("ViewViewCaption");
	locdrobj=document.getElementById("ViewLocDr");
	locnameobj=document.getElementById("ViewLocName");
	groupdrobj=document.getElementById("ViewGroupDr");
	groupnameobj=document.getElementById("ViewGroupName");
	HISLogonUrl = document.getElementById("HISLogonUrl");
	if (viewnameobj){
		viewnameobj.onblur = viewnameblur;
	}
	if (groupnameobj){
		groupnameobj.onblur = groupblur;
	}
	if (locnameobj){
		locnameobj.onblur = locblur;
	}
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
	
	if (typeof window.Find_click=="undefined"){ //没有查询按钮 所以没有Find_click方法 不会刷新页面
		window.Find_click=function(){
			try{
				treload();
			}catch(e){}
		}	
	}
}
//ClassMethod Save(Id, SysCode, SysDesc, SysDateFrom, SysDateTo, SysCompany)
function check(){
	if (ViewTicketCodeObj.value==""){alert("提填写[登录代码],登录时作为唯一标识");return false;}
	//if (viewdrobj.value==""){alert("请选择View");return false;}
	//if (locdrobj.value==""){alert("请选择科室");return false;}
	//if (groupdrobj.value==""){alert("请选择安全组");return false;}
	//if(!checkdate(datefobj.value.trim())){
	//	return false;
	//}
	//if(!checkdate(datetobj.value.trim())){
	//	return false;
	//}
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
	var ViewTicketCode = ViewTicketCodeObj.value;
	var encobj=document.getElementById("save");
	var enc=encobj.value;
	var rtn = cspHttpServerMethod(enc,sysviewrowid,sysid,viewdr,locdr,groupdr,ip,cname,datef,datet,ViewTicketCode);
	rtn = parseFloat(rtn);
	if (rtn>0){
		alert("增加成功");
		Find_click();
	}else if(rtn==-100){
		alert("日期格式错误");
	}else if(rtn==-101){
		alert("开始日期不能大于结束日期");
	}else if(rtn==-103){
		alert("登陆代码重复，无法增加");
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
	var ViewTicketCode = ViewTicketCodeObj.value;
	var encobj=document.getElementById("save");
	var enc=encobj.value;

	var rtn = cspHttpServerMethod(enc,sysviewrowid,sysid,viewdr,locdr,groupdr,ip,cname,datef,datet,ViewTicketCode);
	rtn = parseFloat(rtn);
	if (rtn>0){
		alert("修改成功");
		Find_click();
	}else if(rtn==-100){
		alert("日期格式错误");
	}else if(rtn==-101){
		alert("开始日期不能大于结束日期");
	}else if(rtn==-103){
		alert("登陆代码重复，无法修改");
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
	ViewTicketCodeObj.value= "";
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
function getRowCellVal(name,rowIndex){
	var obj = document.getElementById(name+"z"+rowIndex);
	var val = ""; 
	if (obj){
		if(obj.innerText) val = obj.innerText
		if (obj.value) val = obj.value;
	}
	return val;
}
var SelectRowHandler = function(){
	if(selectedRowObj.rowIndex>0){
		var viewname = getRowCellVal("ViewViewCaption",selectedRowObj.rowIndex);
		var locname = getRowCellVal("ViewLocName",selectedRowObj.rowIndex);
		var groupname = getRowCellVal("ViewGroupName",selectedRowObj.rowIndex);
		var ip = getRowCellVal("ViewIP",selectedRowObj.rowIndex);
		var cname = getRowCellVal("ViewCName",selectedRowObj.rowIndex);
		var datef = getRowCellVal("ViewDateFrom",selectedRowObj.rowIndex);
		var datet = getRowCellVal("ViewDateTo",selectedRowObj.rowIndex);
		var sysviewid = getRowCellVal("SysViewRowId",selectedRowObj.rowIndex);
		var viewdr = getRowCellVal("ViewViewDr",selectedRowObj.rowIndex);
		var locdr = getRowCellVal("ViewLoc",selectedRowObj.rowIndex)
		var groupdr = getRowCellVal("ViewGroup",selectedRowObj.rowIndex);
		var ViewTicketCode = getRowCellVal("ViewTicketCode",selectedRowObj.rowIndex);
		
		viewdrobj.value=viewdr;
		viewnameobj.value=viewname;
		locdrobj.value=locdr;
		locnameobj.value=locname;
		groupdrobj.value=groupdr;		
		groupnameobj.value=groupname;
		ViewTicketCodeObj.value = ViewTicketCode;
		ipobj.value=ip.trim();
		cnameobj.value=cname.trim();
		datefobj.value=datef.trim();
		datetobj.value=datet.trim();
		sysviewidobj.value=sysviewid;
		var tmpurl = location.href;
		HISLogonUrl.value  = tmpurl.split("/web/")[0]+"/web/form.htm?TPSID="+ViewTicketCode+"&AES7UserCode=?&USERNAME=?";
		if (locdr==""){
			HISLogonUrl.value += "&DEPARTMENT=?"; //&Hospital=?";
		}
		if (groupdr==""){
			//HISLogonUrl.value += "&SSUSERGROUPDESC=?";
		}
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
		HISLogonUrl.value="";
		ViewTicketCodeObj.value="";
	}
}

function loclook(str) {
	var tem=str.split("^");
	if(locdrobj) locdrobj.value=tem[1];
}
function grouplook(str) {
	var tem=str.split("^");
	if(groupdrobj) groupdrobj.value=tem[1];
}
function locblur(e){
	if (locnameobj.value==""){
		locdrobj.value = "";
	}
}
function groupblur(e){
	if (groupnameobj.value==""){
		groupdrobj.value = "";
	}
}
function viewlook(str) {
	var tem=str.split("^");
	if(viewdrobj) viewdrobj.value=tem[1];
}
function viewnameblur(e){
	if (viewnameobj.value==""){
		viewdrobj.value = "";
	}	
}
