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
	
	if (typeof window.Find_click=="undefined"){ //û�в�ѯ��ť ����û��Find_click���� ����ˢ��ҳ��
		window.Find_click=function(){
			try{
				treload();
			}catch(e){}
		}	
	}
}
//ClassMethod Save(Id, SysCode, SysDesc, SysDateFrom, SysDateTo, SysCompany)
function check(){
	if (ViewTicketCodeObj.value==""){alert("����д[��¼����],��¼ʱ��ΪΨһ��ʶ");return false;}
	//if (viewdrobj.value==""){alert("��ѡ��View");return false;}
	//if (locdrobj.value==""){alert("��ѡ�����");return false;}
	//if (groupdrobj.value==""){alert("��ѡ��ȫ��");return false;}
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
			alert("���ڸ�ʽ����\r\n��ʹ���Ҳ��������������ڣ����߰���22/08/2016�ĸ�ʽ����");  
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
		alert("���ӳɹ�");
		Find_click();
	}else if(rtn==-100){
		alert("���ڸ�ʽ����");
	}else if(rtn==-101){
		alert("��ʼ���ڲ��ܴ��ڽ�������");
	}else if(rtn==-103){
		alert("��½�����ظ����޷�����");
	}else{
		alert("ʧ��");
	}
}
function update_click(){
	var sysviewrowid=sysviewidobj.value;
	if(sysviewrowid=="") {alert("��ѡ��Ҫ�޸ĵ���");return false;}	
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
		alert("�޸ĳɹ�");
		Find_click();
	}else if(rtn==-100){
		alert("���ڸ�ʽ����");
	}else if(rtn==-101){
		alert("��ʼ���ڲ��ܴ��ڽ�������");
	}else if(rtn==-103){
		alert("��½�����ظ����޷��޸�");
	}else{
		alert("ʧ��");
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
	if(sysviewrowid=="") {alert("��ѡ��Ҫɾ������");return false;}
	var encobj=document.getElementById("del");
	var enc=encobj.value;
	var rtn = cspHttpServerMethod(enc,sysviewrowid);
	rtn = parseFloat(rtn);
	if (rtn>0){
		alert("ɾ���ɹ�");
		clear_click();
	}else{
		alert("ʧ��");
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
