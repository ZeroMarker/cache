var CONST_HOSPID=""; 

function getHospID(){	
    var HospitalRowId="";
	var objHospitalRowId=document.getElementById("HospitalRowId");
    if (objHospitalRowId) HospitalRowId=objHospitalRowId.value;
	return HospitalRowId;
}
function GetHospital(str)
{
	var obj=document.getElementById('HospitalRowId');
	var tem=str.split("^");
	obj.value=tem[1];
	var obj=document.getElementById('HospitalName');
	obj.value=tem[0];
	location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCQTRECTYPW&HospitalRowId="+tem[1]+"&HospitalName="+tem[0];
	//listSet();
}  
var SelectedRow = 0;

function BodyLoadHandler() {
	var obj = document.getElementById('BADD')
	if (obj) obj.onclick = BADD_click;
	var obj = document.getElementById('BUpdate')
	if (obj) obj.onclick = BUpdate_click;
	var obj = document.getElementById('BDelete')
	if (obj) obj.onclick = BDelete_click;
}

function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	var objtbl = document.getElementById('tDHCQTRECTYPW');
	var rows = objtbl.rows.length;
	var lastrowindex = rows - 1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if (!selectrow) return;
	var obj1 = document.getElementById('TYPROWIDT');
	var obj2 = document.getElementById('TYPCODET');
	var obj3 = document.getElementById('TYPDESCT');	
	var obj4 = document.getElementById('TYPTYPET');
	var obj5 = document.getElementById('TYPTYPECODET');
	
	
	var SelRowObj1 = document.getElementById('TYP_ROWIDz' + selectrow);
	var SelRowObj2 = document.getElementById('TYP_CODEz' + selectrow);
	var SelRowObj3 = document.getElementById('TYP_DESCz' + selectrow);
	var SelRowObj4 = document.getElementById('TYP_TYPEz' + selectrow);
	var SelRowObj5 = document.getElementById('TYP_TYPE_CODEz' + selectrow);
	
	if (obj1) obj1.value = SelRowObj1.innerText;
	if (obj2) obj2.value = SelRowObj2.innerText;
	if (obj3) obj3.value = SelRowObj3.innerText;
	if (obj4) obj4.value = SelRowObj4.innerText;
	if (obj5) obj5.value = SelRowObj5.innerText;
	
	var tmpSelectRow=selectrow;
	if (SelectedRow == selectrow) {
		if (obj1) obj1.value = "";
		if (obj2) obj2.value = "";
		if (obj3) obj3.value = "";
		if (obj4) obj4.value = "";
		if (obj5) obj5.value = "";
		tmpSelectRow="";
	}
	SelectedRow = tmpSelectRow;
}

function BADD_click() {
	var obj = document.getElementById('TYPCODET')
	if (obj) var TYPCODE = obj.value;
	if (TYPCODE == "") {
		alert(t['01'])
		return;
	}
	var obj = document.getElementById('TYPDESCT')
	if (obj) var TYPDESC = obj.value;
	if (TYPDESC == "") {
		alert(t['02'])
		return;
	}
	////扩张表字段SC20161201 
	var obj = document.getElementById('TYPTYPET')
	if (obj) var TYPTYPET = obj.value;
	//if (TYPTYPET == "") {
	//	alert('事件类型不能为空')
	//	return;
	//}
	var obj = document.getElementById('TYPTYPECODET')
	if (obj) var TYPTYPECODET = obj.value;
	//if (TYPTYPECODET == "") {
	//	alert('事件类型编号不能为空')
	//	return;
	//}
	
	CONST_HOSPID=getHospID();
	var obj = document.getElementById('InsertTyp')
	if (obj) var encmeth = obj.value;
	if (cspRunServerMethod(encmeth, TYPCODE, TYPDESC,TYPTYPET,TYPTYPECODET,CONST_HOSPID) != '0') {
		alert(t['04']);
		return;
	}
	try {
		alert(t['03']);
		window.location.reload();
	} catch (e) {};
}

function BUpdate_click() {
	var obj = document.getElementById('TYPROWIDT')
	if (obj) var TYPROWID = obj.value;
	if (TYPROWID == "") {
		alert("请选择要更新的项")
		return;
	}
	var obj = document.getElementById('TYPCODET')
	if (obj) var TYPCODE = obj.value;
	if (TYPCODE == "") {
		alert(t['01'])
		return;
	}
	var obj = document.getElementById('TYPDESCT')
	if (obj) var TYPDESC = obj.value;
	if (TYPDESC == "") {
		alert(t['02'])
		return;
	}
	////扩张表字段SC20161201 
	var obj = document.getElementById('TYPTYPET')
	if (obj) var TYPTYPET = obj.value;
	//if (TYPTYPET == "") {
	//	alert('事件类型不能为空')
	//	return;
	//}
	var obj = document.getElementById('TYPTYPECODET')
	if (obj) var TYPTYPECODET = obj.value;
	//if (TYPTYPECODET == "") {
	//	alert('事件类型编号不能为空')
	//	return;
	//}
	CONST_HOSPID=getHospID();
	var obj = document.getElementById('UpdateTyp')
	if (obj) var encmeth = obj.value;
	if (cspRunServerMethod(encmeth, TYPROWID, TYPCODE, TYPDESC,TYPTYPET,TYPTYPECODET,CONST_HOSPID) != '0') {
		alert(t['04']);
		return;
	}
	try {
		alert(t['03']);
		window.location.reload();
	} catch (e) {};
}

function BDelete_click() {
	var obj = document.getElementById('TYPROWIDT')
	if (obj) var TYPROWID = obj.value;
	
	var del=confirm("您确定要删除此条记录？");
        if(del==true){
             
        }else{
            return;
        }
	
	
	if (TYPROWID == "") {
		alert(t['05'])
		return;
	}
	var obj = document.getElementById('DeleteTyp')
	if (obj) var encmeth = obj.value;
	if (cspRunServerMethod(encmeth, TYPROWID) != '0') {
		alert(t['04']);
		return;
	}
	try {
		alert(t['03']);
		window.location.reload();
	} catch (e) {};
}

document.body.onload = BodyLoadHandler;