var idobj,ipobj,dateFromobj,dateToobj,activeobj,ipDescObj;
var addobj,updateobj,deleteobj,clearobj;
var admTypeoObj,admTypeeObj,admTypeiObj;
document.body.onload=function(){
	idobj=document.getElementById("RowId");
	ipobj=document.getElementById("Ip");
	dateFromobj=document.getElementById("DateFrom");
	dateToobj=document.getElementById("DateTo");
	hospobj=document.getElementById("HospDesc");
	activeobj=document.getElementById("Active");
	activeobj.checked=true;
	ipDescObj=document.getElementById("IpDesc");
	addobj=document.getElementById("Add");
	updateobj=document.getElementById("Update");
	deleteobj=document.getElementById("Delete");
	clearobj=document.getElementById("Clear");
	
	admTypeoObj=document.getElementById("AdmTypeO");
	admTypeeObj=document.getElementById("AdmTypeE");
	admTypeiObj=document.getElementById("AdmTypeI");
	
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
			clear_click();
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
	var admType="";
	if(admTypeoObj.checked) admType +="O";
	if(admTypeeObj.checked) admType +="E";
	if(admTypeiObj.checked) admType +="I";
	var ipDesc = ipDescObj.value;
	var encobj=document.getElementById("SaveEnc");
	var enc=encobj.value;
	var rtn = cspHttpServerMethod(enc,id,ip,DateFrom,DateTo,act,hospDesc,ipDesc,admType);
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
	var admType="";
	if(admTypeoObj.checked) admType +="O";
	if(admTypeeObj.checked) admType +="E";
	if(admTypeiObj.checked) admType +="I";

	var hospDesc = hospobj.value;
	var ipDesc = ipDescObj.value;
	var encobj=document.getElementById("SaveEnc");
	var enc=encobj.value;
	var rtn = cspHttpServerMethod(enc,id,ip,DateFrom,DateTo,act,hospDesc,ipDesc,admType);
	if (parseFloat(rtn)>0){
		alert("更新成功");
		Find_click();
	}else{
		alert("失败\n"+rtn.split("^")[1]);
	}
}
function reset(){
	ipobj.value="";
	dateFromobj.value="";
	dateToobj.value="";
	activeobj.checked=true;
	idobj.value="";
	ipDescObj.value="";
	admTypeoObj.checked=false;
	admTypeeObj.checked=false;
	admTypeiObj.checked=false;
}
function clear_click(){
	reset();	
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
		var ipDesc = document.getElementById("TIpDescz"+selectedRowObj.rowIndex).innerText;
		var admType = document.getElementById("TAdmTypez"+selectedRowObj.rowIndex).innerText;
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
		if (admType.indexOf("O")>-1){admTypeoObj.checked=true;}else{admTypeoObj.checked=false;}
		if (admType.indexOf("E")>-1){admTypeeObj.checked=true;}else{admTypeeObj.checked=false;}
		if (admType.indexOf("I")>-1){admTypeiObj.checked=true;}else{admTypeiObj.checked=false;}
		idobj.value=id;
		hospobj.value=hospDesc.trim();
		if(ipDesc.charCodeAt()==160||ipDesc==" ") ipDesc="";
		ipDescObj.value = ipDesc;
	}else{
		reset();
	}
	
}