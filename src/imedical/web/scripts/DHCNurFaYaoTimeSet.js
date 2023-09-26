var SelectedRow = 0;
var CONST_HOSPID="";
function BodyLoadHandler() {
	var obj = document.getElementById('butAdd')
	if (obj) obj.onclick = ADD_click;
	var obj = document.getElementById('butUpdate')
	if (obj) obj.onclick = UPDATE_click;
	var obj = document.getElementById('butDel')
	if (obj) obj.onclick = DELETE_click;
}

function SelectRowHandler() {
	//alert(1);
	var eSrc = window.event.srcElement;
	var objtbl = document.getElementById('tDHCNurFaYaoTimeSet');
	var rows = objtbl.rows.length;
	var lastrowindex = rows - 1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if (!selectrow) return;
	var RecId = document.getElementById('RecId');
	var Ward = document.getElementById('Ward');
	var WardId = document.getElementById('WardId');
	//var MedTyp=document.getElementById('MedTyp');
	//var MedTypId=document.getElementById('MedTypId');
	//var EDate=document.getElementById('EDate');
	var ETime = document.getElementById('ETime');

	var SelRowRecId = document.getElementById('tRecIdz' + selectrow);
	var SelRowWardId = document.getElementById('tWardIdz' + selectrow);
	var SelRowWard = document.getElementById('tWardz' + selectrow);
	//var SelRowMedTypId=document.getElementById('tMedTypIdz'+selectrow);
	//var SelRowMedTyp=document.getElementById('tMedTypz'+selectrow);
	//var SelRowEDate=document.getElementById('tEDatez'+selectrow);
	var SelRowETime = document.getElementById('tETimez' + selectrow);


	

	//MedTyp.value=SelRowMedTyp.innerText;
	//MedTypId.value=SelRowMedTypId.innerText;
	//EDate.value=SelRowEDate.innerText;

	
	if((SelectedRow==selectrow)&&(Ward.value!='')){
		console.log(Ward.value);
		RecId.value = '';
		Ward.value = '';
		WardId.value = '';
		ETime.value = '';
		console.log(Ward.value);
	}else{
		RecId.value = SelRowRecId.innerText;
		Ward.value = SelRowWard.innerText;
		WardId.value = SelRowWardId.innerText;
		ETime.value = SelRowETime.innerText;	
	}
	SelectedRow = selectrow;
	return;
}

function ADD_click() {
	CONST_HOSPID=getHospID();
	if (CONST_HOSPID=="") {
		alert("请选择院区！")
		return;
	}
	var WardId, MedTypId, EDate, ETime;
	var obj = document.getElementById('WardId')
	if (obj) WardId = obj.value;
	if (WardId == "") {
		alert("科室不能为空!")
		return;
	}
	/*
    var obj=document.getElementById('MedTypId')
	if(obj) MedTypId=obj.value;
	if(MedTypId==""){
		alert("发药类别不能为空!") 
		return;
		}
	EDate="";
	//var obj=document.getElementById('EDate')
	//if(obj) EDate=obj.value;
	*/
	var obj = document.getElementById('ETime')
	if (!IsValidTime(obj)) {
		alert("请输入正确的时间")
		return;
	}
	if (obj) ETime = obj.value;
	if (ETime == "") {
		alert("截止时间不能为空!")
		return;
	}
	var obj = document.getElementById('SaveFYTimeSet')
	if (obj) {
		var Parr = "^" + WardId + "^^^" + ETime; //"^"+MedTypId+"^"+EDate+
		//alert(Parr);
		var encmeth = obj.value;
		var resStr = cspRunServerMethod(encmeth, Parr,CONST_HOSPID);
		if (resStr != '0') {
			alert("添加失败:"+resStr);
			return;
		} else {
			alert("添加成功!");
			location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurFaYaoTimeSet&HospitalRowId="+CONST_HOSPID+"&HospitalName="+document.getElementById('HospitalName').value;

		}
	}

}

function UPDATE_click() {
	CONST_HOSPID=getHospID();
	var RecId, WardId, MedTypId, EDate, ETime;
	var obj = document.getElementById('RecId')
	if (obj) RecId = obj.value;
	if (RecId == "") {
		alert("请选择一条记录进行操作!")
		return;
	}
	var obj = document.getElementById('WardId')
	if (obj) WardId = obj.value;
	if (WardId == "") {
		alert("科室不能为空!")
		return;
	}
	/*
    var obj=document.getElementById('MedTypId')
	if(obj) MedTypId=obj.value;
	if(MedTypId==""){
		alert("发药类别不能为空!") 
		return;
		}
	EDate="";
	//var obj=document.getElementById('EDate')
	//if(obj) EDate=obj.value;
	*/
	var obj = document.getElementById('ETime')
	if (!IsValidTime(obj)) {
		alert("请输入正确的时间")
		return;
	}
	if (obj) ETime = obj.value;
	if (ETime == "") {
		alert("截止时间不能为空!")
		return;
	}

	var obj = document.getElementById('SaveFYTimeSet')
	if (obj) {
		var Parr = RecId + "^" + WardId + "^^^" + ETime; //"^"+MedTypId+"^"+EDate+
		//alert(Parr);
		var encmeth = obj.value;
		var resStr = cspRunServerMethod(encmeth, Parr,CONST_HOSPID);
		if (resStr != '0') {
			alert("更新失败!");
			return;
		} else {
			alert("更新成功!");
			location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurFaYaoTimeSet&HospitalRowId="+CONST_HOSPID+"&HospitalName="+document.getElementById('HospitalName').value;

		}
	}

}

function DELETE_click() {
	CONST_HOSPID=getHospID();
	var RecId, WardId, MedTypId, EDate, ETime;
	var obj = document.getElementById('RecId')
	if (obj) RecId = obj.value;
	if (RecId == "") {
		alert("请选择一条记录进行操作!")
		return;
	}
	var result = confirm("确认删除?");
	if (result !== true) {
		return;
	}
	var obj = document.getElementById('DelFYTimeSet')
	if (obj) var encmeth = obj.value;
	var resStr = cspRunServerMethod(encmeth, RecId)
	if (resStr != '0') {
		alert("删除失败!");
		return;
	} else {
		alert("删除成功!");
		location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurFaYaoTimeSet&HospitalRowId="+CONST_HOSPID+"&HospitalName="+document.getElementById('HospitalName').value;
	}
}

function GetWardId(value) {
	var strWard;
	strWard = value.split("^");
	strWardId = strWard[1];
	//alert(strWardId);
	document.getElementById('WardId').value = strWardId;
}

function GetMedTypId(value) {
	var strMedTyp;
	strMedTyp = value.split("^");
	strMedTypId = strMedTyp[1];
	//alert(strMedTypId);
	document.getElementById('MedTypId').value = strMedTypId;
}
function getHospID(){	
    var HospitalRowId="";
	var objHospitalRowId=document.getElementById("HospitalRowId");
    if (objHospitalRowId) HospitalRowId=objHospitalRowId.value;
	return HospitalRowId;
}
function GetHospital(row){
	var tem=row.split("^");
	var obj=document.getElementById('HospitalRowId');	
	obj.value=tem[1];
	var obj=document.getElementById('HospitalName');
	obj.value=tem[0];
	location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurFaYaoTimeSet&HospitalRowId="+tem[1]+"&HospitalName="+tem[0];
	CONST_HOSPID=getHospID();
}
document.body.onload = BodyLoadHandler;