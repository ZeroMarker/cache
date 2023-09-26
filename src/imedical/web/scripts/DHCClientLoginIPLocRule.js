var idobj,ipobj,dateFromobj,dateToobj,activeobj;
var addobj,updateobj,deleteobj,clearobj;
document.body.onload=function(){
	idobj=document.getElementById("RowId");
	ipobj=document.getElementById("Ip");
	dateFromobj=document.getElementById("DateFrom");
	dateToobj=document.getElementById("DateTo");
	hospobj=document.getElementById("HospDesc");
	activeobj=document.getElementById("Active");
	activeobj.checked=true;
	
	addobj=document.getElementById("Add");
	updateobj=document.getElementById("Update");
	deleteobj=document.getElementById("Delete");
	clearobj=document.getElementById("Clear");
	
	if (addobj) addobj.onclick=add_click;
	if (updateobj) updateobj.onclick=update_click;
	if (deleteobj) deleteobj.onclick=delete_click;
	if (clearobj) clearobj.onclick=clear_click;
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
function hospSelect(str){
	var arr = str.split("^");
	hospobj.value = arr[2];
}
function add_click(){
	var id="";
	var ip=ipobj.value;
	var DateFrom=dateFromobj.value;
	var DateTo=dateToobj.value;
	var hospDesc = hospobj.value;
	var act="N";
	if(activeobj.checked){
		act="Y";
	}
	var encobj=document.getElementById("SaveEnc");
	var enc=encobj.value;
	var rtn = cspHttpServerMethod(enc,id,ip,DateFrom,DateTo,act,hospDesc);
	if (parseFloat(rtn)>0){
		alert("增加成功");
		Find_click();
	}else{
		alert("失败\n"+rtn.split("^")[1]);
	}
}
function update_click(){
	var id=idobj.value;
	if(id=="") {alert("请选择要修改的行");return false;}
	var ip=ipobj.value;
	var DateFrom=dateFromobj.value;
	var DateTo=dateToobj.value;
	var act="N";
	if(activeobj.checked){
		act="Y";
	}
	var hospDesc = hospobj.value;
	var encobj=document.getElementById("SaveEnc");
	var enc=encobj.value;
	var rtn = cspHttpServerMethod(enc,id,ip,DateFrom,DateTo,act,hospDesc);
	if (parseFloat(rtn)>0){
		alert("更新成功");
		Find_click();
	}else{
		alert("失败\n"+rtn.split("^")[1]);
	}
}
function clear_click(){
	ipobj.value="";
	dateFromobj.value="";
	dateToobj.value="";
	activeobj.checked=true;
	idobj.value="";
	Find_click();
}
function delete_click(){
	var id=idobj.value;
	if(id=="") {alert("请选择要删除的行");return false;}
	var encobj=document.getElementById("DelEnc");
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
		var tIp = document.getElementById("TIpz"+selectedRowObj.rowIndex).innerText;
		var tDateFrom = document.getElementById("TDateFromz"+selectedRowObj.rowIndex).innerText;
		var tDateTo = document.getElementById("TDateToz"+selectedRowObj.rowIndex).innerText;
		var act = document.getElementById("TActivez"+selectedRowObj.rowIndex).innerText;
		var hospDesc = document.getElementById("THospz"+selectedRowObj.rowIndex).innerText;
		var id = document.getElementById("TRowIdz"+selectedRowObj.rowIndex).value;
		if(tIp.charCodeAt()==160||tIp==" ") tIp="";
		ipobj.value= tIp;
		if(tDateFrom.charCodeAt()==160||tDateFrom==" ") tDateFrom="";
		dateFromobj.value=tDateFrom;
		if(tDateTo.charCodeAt()==160||tDateTo==" ") tDateTo="";
		dateToobj.value=tDateTo;
		activeobj.checked=act;
		idobj.value=id;
		if(act=="Y"){
			activeobj.checked=true;
		}else{
			activeobj.checked=false;
		}
		idobj.value=id;
		hospobj.value=hospDesc.trim();
	}else{
		ipobj.value="";
		dateFromobj.value="";
		dateToobj.value="";
		activeobj.checked=true;
		idobj.value="";
		hospobj.value="";
	}
	
}