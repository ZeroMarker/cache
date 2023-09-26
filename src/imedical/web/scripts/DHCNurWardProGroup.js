var doc = parent.frames[1].document;
var comb_ward;
var SelectedRow="";
function setVal(ind) {

	doc.getElementById("wardrowid").value = $V("twardidz" + ind);
	doc.getElementById("ward").value = $V("twarddescz" + ind);
	doc.getElementById("grouprowid").value = $V("trowidz" + ind);
	doc.getElementById("group").value = $V("TGroupDescz" + ind);
}

function LookUpWard(str)
{
	var loc=str.split("^");
	var obj=document.getElementById("wardid");
	obj.value=loc[2];
}
document.body.onload = function () {

	//comb_ward = dhtmlXComboFromSelect("ward");
	// comb_ward.enableFilteringMode(true);
	//comb_ward.attachEvent("onChange", function (event) {
	//	$("wardid").value = comb_ward.getSelectedValue();

	//});
	//comb_ward.setComboValue($("wardid").value);

	this.dbclick = function () {
		var objtbl = document.getElementById('tDHCNurWardProGroup');
		if (!objtbl) {
			objtbl = document.getElementById('tDHCNurWardProGroup0');
		}

		var trs = objtbl.getElementsByTagName("tr");

		for (var i = 0; i < trs.length; i++) {

			trs[i].ondblclick = function () {
				var eSrc = window.event.srcElement;
				var rowObj = getRow(eSrc);
				var selectrow = rowObj.rowIndex;
				setVal(selectrow);
				parent.frames[1].getBed(1);
			}

		}
	}

	this.dbclick();
	$("btnAdd").onclick = function () {
		var wardid = $("wardid").value ;
		if (wardid == '') {
			alert("病区不能为空!!");
			return;
		}
		var groupCode = document.getElementById('GroupCode').value;
		var groupDesc = document.getElementById('GroupDesc').value;
		if ((groupCode == '') || (groupDesc == '')) {
			alert("专业组代码、专业组不能为空!!");
			return;
		}
		var returnvalue = cspRunServerMethod($V('addeidtMethd'), $V("GroupCode") + "^" + $V("GroupDesc") + "^" + $("ActivFlag").checked + "^" + $V("wardid") + "^" + "" + "^" + session['LOGON.USERID']);
		if (returnvalue == "1") {
			alert("成功");
			$("btnFind").onclick();
		} else {
			if (returnvalue == "-200"){
				alert("有重复的专业组代码，不可添加")
			}else{
				alert("失败");
			}
		}
	}
	$("btnEdit").onclick = function () {
		if (SelectedRow=="") {
			alert("请选择记录!!");
			return;
		}
		if ($V("GroupCode") == "" || $V("GroupDesc") == "") {
			alert("专业组代码、专业组不能为空!!");
			return;
		}
		var returnvalue = cspRunServerMethod($V('addeidtMethd'), $V("GroupCode") + "^" + $V("GroupDesc") + "^" + $("ActivFlag").checked + "^" + $V("wardid") + "^" + $V("hrowid") + "^" + session['LOGON.USERID']);
		if (returnvalue == "1") {
			alert("成功");
			$("btnFind").onclick();
		} else {
			alert("失败");
		}
	}
	$("ward").onblur=function(){
		if($V("ward")==""){
			$("wardid").value =""
		}
	}
}

function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl = document.getElementById('tDHCNurWardProGroup');
	if (!objtbl) {
		objtbl = document.getElementById('tDHCNurWardProGroup0');
	}

	var rows = objtbl.rows.length;

	var lastrowindex = rows - 1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;

	if (!selectrow)
		return;
	if (rowObj.className == 'clsRowSelected') {
		$("GroupDesc").value = $V("TGroupDescz" + selectrow);
		$("GroupCode").value = $V("TGroupCodez" + selectrow);
		$("hrowid").value = $V("trowidz" + selectrow);
		$("wardid").value = $V("twardidz" + selectrow);
		$("ward").value = $V("twarddescz" + selectrow);
		$("ActivFlag").checked = $("TActivFlagz" + selectrow).checked;

	} else {
		$("GroupDesc").value = "";
		$("GroupCode").value = "";
		$("hrowid").value = "";
		$("wardid").value = "";
		$("ward").value = "";
	}

	SelectedRow = selectrow;
}
function setWard(val) {
	var item = val.split("^");
	$("ward").value = item[2];
	$("wardid").value = item[0];
}
