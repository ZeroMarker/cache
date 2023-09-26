var bedcode, roomdr, doctorname
var SelectedRow = 0;
var preRowInd = 0;
var Warddesc = tkMakeServerCall("web.DHCArrbeddoc", "GetWardDesc", session['LOGON.WARDID'])
var num = 1
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
	//location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCArrageBedDoc&HospitalRowId="+tem[1]+"&HospitalName="+tem[0];	
	CONST_HOSPID=getHospID();	
	var obj = document.getElementById('warddesc')
	if (obj) obj.value = "";
	var obj = document.getElementById('wardid')
	if (obj) obj.value = "";
	//listSet();
}

function BodyLoadHandler() {


	var obj = document.getElementById('Update');
	if (obj) obj.onclick = Update;
	var obj = document.getElementById('UpdateN');
	if (obj) obj.onclick = UpdateNur;
	var obj = document.getElementById("SelectAll");
	if (obj) {
		obj.onclick = SelectAll;
	}
	var wardobj = document.getElementById('warddesc')
		//if(obj) var warddesc=obj.value
	var obj = document.getElementById('wardid')
	if (obj.value == "") {
		obj.value = session['LOGON.WARDID']
		wardobj.value = Warddesc
	}
	wardobj.onblur=function(){
		if(wardobj.value==""){
			obj.value ="";
		}
	}
	//alert(num)
	if (parseInt(num) == 1) find_click();
	var num = parseInt(num) + 1;
}

function SelectAll() {
	var obj = document.getElementById("SelectAll");
	var Objtbl = document.getElementById('tDHCArrangeBedDoc');
	var Rows = Objtbl.rows.length;
	for (var i = 1; i < Rows; i++) {
		var selobj = document.getElementById('seleitemz' + i);
		selobj.checked = obj.checked;
	}
}

function SelectRowHandler() {
	var i, tmpList;
	var selectrow = DHCWeb_GetRowIdx(window);
	if (selectrow < 1) return; //ypz 080926
	var item = document.getElementById("seleitemz" + selectrow);
	var bedcsub = document.getElementById("bedcsubz" + selectrow).innerText;

	var doctorname = document.getElementById("doctorname").value;


	tmpList = doctorname.split("^");
	var rowid = tmpList[1];

	var eSrc = window.event.srcElement;
	var objtbl = document.getElementById('tDHCArrangeBedDoc');
	Rows = objtbl.rows.length;
	var rowObj = getRow(eSrc); //

	var obj = document.getElementById("SelectAll");
	if (!obj.checked) {
		SelRowObj = document.getElementById('seleitemz' + selectrow);
		if (eSrc.id != 'seleitemz' + selectrow) { //avoid selected col 'seleitemz'+selectrow
			if (SelRowObj.checked == 1) {
				SelRowObj.checked = 0;
			} else {
				SelRowObj.checked = 1;
			}
		}
	}
	//070305 

}

function Update() {
	var objtbl = document.getElementById('tDHCArrangeBedDoc');
	var rowid = document.getElementById('rowid').value;
	var nurseid = document.getElementById('nurseid').value;
	var doctorName=document.getElementById("doctorname").value;
	if(doctorName==""){
		rowid="";
	}
	var nurseName=document.getElementById("nursename");
	if(nurseName==""){
		nurseid="";
	}
	for (i = 1; i < objtbl.rows.length; i++) {
		var item = document.getElementById("seleitemz" + i);
		if (item.checked == true) {
			var obj = document.getElementById('bedcsubz' + i);
			if (obj) var bedcode = obj.innerText;

			

			var obj = document.getElementById('warddesc')
			if (obj) var warddesc = obj.value;

			var obj = document.getElementById('wardid')
			if (obj) var wardid = obj.value;

			var obj = document.getElementById('updatevis');
			encmeth = obj.value;

			if (cspRunServerMethod(encmeth, bedcode, rowid, wardid) != '0') {
				alert("更新医生失败");
				return;
			}
			var obj = document.getElementById('updatenur');
			encmeth = obj.value;
			if (cspRunServerMethod(encmeth, bedcode, nurseid, wardid) != '0') {
				alert("更新护士失败");
				return;
			}

		}
	}
	find_click();

}

function UpdateNur() {
	var objtbl = document.getElementById('tDHCArrangeBedDoc');
	var rowid;
	rowid = "";
	var checkedCount=0
	for (i = 1; i < objtbl.rows.length; i++) {
		var item = document.getElementById("seleitemz" + i);
		if (item.checked == true) {
			checkedCount=checkedCount+1;
			var obj = document.getElementById('bedcsubz' + i);
			if (obj) var bedcode = obj.innerText;

			var obj = document.getElementById('nurseid')
			if (obj) var nurseid = obj.value;

			var obj = document.getElementById('warddesc')
			if (obj) var warddesc = obj.value;

			var obj = document.getElementById('wardid')
			if (obj) var wardid = obj.value;

			var obj = document.getElementById('updatenur');
			if (obj) var encmeth = obj.value;


			if (cspRunServerMethod(encmeth, bedcode, nurseid, wardid) != '0') {
				alert("更新失败");
				return;
			}
		}
	}
	if(checkedCount==0){
		alert("请选择需要更新的信息!!");
	}else{		
		alert("更新成功");
		find_click();
	}

}

function getloc(str) {
	var loc = str.split("^");
	var obj = document.getElementById("rowid")
	obj.value = loc[1];

}

function getnurseid(str) {
	var loc = str.split("^");
	var obj = document.getElementById("nurseid")
	obj.value = loc[1];
}

function getwardid(str) {
	var loc = str.split("^");
	var obj = document.getElementById("wardid")
	obj.value = loc[2];

	find_click();

}
document.body.onload = BodyLoadHandler;