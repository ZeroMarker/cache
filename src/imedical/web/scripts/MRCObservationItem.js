function BodyLoadHandler() {
	var obj = document.getElementById("Formula1");
	if (obj) {
		obj.options[0] = new Option("", "");
		obj.options[1] = new Option("1", "1");
		obj.options[2] = new Option("2", "2");
		obj.options[3] = new Option("6", "6");
		obj.size = 1;
		obj.multiple = false;
	}
	var objFlag = document.getElementById("Flag");
	if (objFlag) {
		objFlag.options[0] = new Option("", "");		
		objFlag.options[1] = new Option("成人", "0");
		objFlag.options[2] = new Option("婴儿", "1");
		objFlag.size = 1;
		objFlag.multiple = false;
	}
	var update = document.getElementById("update");
	if (update) {
		update.onclick = function () { IUClick(true); }//用function包裹起来，不然会在加载时执行一次方法
	}
	var odelete = document.getElementById("delete");
	if (odelete) {
		odelete.onclick = DeleteClick;
	}
	var insert = document.getElementById("insert");
	if (insert) {
		insert.onclick = function () { IUClick(false); }
	}
	//观察项值操作
	var obj = document.getElementById("AllValues");
	var insertvalue = document.getElementById("valueinsert");
	var newvalue = document.getElementById("newValues");
	//新增列表
	if (insertvalue) {
		insertvalue.onclick = function () {
			if (newvalue) {
				if (newvalue.value.length != 0) {
					var options = obj.getElementsByTagName("option");
					//值重复返回。
					for (var i = 0; i < options.length; i++) {
						if (options[i].value == newvalue.value) {

							return false;
						}
					}
					obj.options.add(new Option(newvalue.value, newvalue.value));
					changeValues();
				}
			}
			return false;
		}
	}
	if (obj) {
		obj.ondblclick = function () {
			obj.options.remove(this.selectedIndex);
			changeValues();
		}
	}
	//观察项值操作
	var obj2 = document.getElementById("AllSpecialSign");
	var insertvalue2 = document.getElementById("SpecialSignInsert");
	var newvalue2 = document.getElementById("newSpecialSign");
	//新增列表
	if (insertvalue2) {
		insertvalue2.onclick = function () {
			if (newvalue2) {
				if (newvalue2.value.length != 0) {
					var options = obj2.getElementsByTagName("option");
					//值重复返回。
					for (var i = 0; i < options.length; i++) {
						if (options[i].value == newvalue2.value) {

							return false;
						}
					}
					obj2.options.add(new Option(newvalue2.value, newvalue2.value));
					changeSpecialSign();
				}
			}
			return false;
		}
	}
	if (obj2) {
		obj2.ondblclick = function () {
			obj2.options.remove(this.selectedIndex);
			changeSpecialSign();
		}
	}
}
function changeSpecialSign() {
	var obj = document.getElementById("AllSpecialSign");
	var options = obj.getElementsByTagName("option");
	var value = document.getElementById("SpecialSign");
	var str = [];
	for (var i = 0; i < options.length; i++) {
		str.push(options[i].value);
	}
	value.value = str.join(String.fromCharCode(129));
}
function changeValues() {
	var obj = document.getElementById("AllValues");
	var options = obj.getElementsByTagName("option");
	var value = document.getElementById("Values");
	var str = [];
	for (var i = 0; i < options.length; i++) {
		str.push(options[i].value);
	}
	value.value = str.join("@");
}
function rowdblclickFn(grid, rowindex, e) {
	grid.getSelectionModel().each(function (rec) {
		alert(rec.get(fieldName)); //fieldName，记录中的字段名     
	});
}
function deleteSpace(str) {
	return str.trim().length === 0 ? "" : str;
}
var MRCOrowIndex = -1;
//点击表格列行赋值
function SelectRowHandler(e) {
	var obj = document.getElementById("rowid");
	if (selectedRowObj.rowIndex == "") {
		obj.value = ""
		clearSelectRow();
		return false;
	}
	var ObservStatusDR = deleteSpace(document.getElementById("tObservStatusDRz" + selectedRowObj.rowIndex).innerText);
	var obj = document.getElementById("ObservStatusDR");
	if (obj) {
		obj.value = ObservStatusDR;
	}
	var rowid = deleteSpace(document.getElementById("trowidz" + selectedRowObj.rowIndex).innerText);
	var obj = document.getElementById("rowid");
	if (obj) {
		obj.value = rowid;
	}
	var code = deleteSpace(document.getElementById("tCodez" + selectedRowObj.rowIndex).innerText);
	var obj = document.getElementById("code");
	if (obj) {
		obj.value = code;
		obj.disabled=true;
	}
	var desc = deleteSpace(document.getElementById("tDescz" + selectedRowObj.rowIndex).innerText);
	var obj = document.getElementById("desc");
	if (obj) {
		obj.value = desc;
	}
	var rangefrom = deleteSpace(document.getElementById("tRangeFromz" + selectedRowObj.rowIndex).innerText);
	var obj = document.getElementById("RangeFrom");
	if (obj) {
		obj.value = rangefrom;
	}
	var rangeto = deleteSpace(document.getElementById("tRangeToz" + selectedRowObj.rowIndex).innerText);
	var obj = document.getElementById("RangeTo");
	if (obj) {
		obj.value = rangeto;
	}
	var alertrangefrom = deleteSpace(document.getElementById("tAlertRangeFromz" + selectedRowObj.rowIndex).innerText);
	var obj = document.getElementById("AlertRangeFrom");
	if (obj) {
		obj.value = alertrangefrom;
	}
	var alertrangeto = deleteSpace(document.getElementById("tAlertRangeToz" + selectedRowObj.rowIndex).innerText);
	var obj = document.getElementById("AlertRangeTo");
	if (obj) {
		obj.value = alertrangeto;
	}
	var value = deleteSpace(document.getElementById("tValuesz" + selectedRowObj.rowIndex).innerText);
	var obj = document.getElementById("Values");
	var AllValues = document.getElementById("AllValues");
	if (obj) {
		obj.value = value;
		if (AllValues) {
			AllValues.options.length = 0;
			if (value != "") {
				var v = value.split("@");
				for (var i = 0; i < v.length; i++) {
					AllValues.options.add(new Option(v[i], v[i]));
				}
			}
		}
	}
	var confirmation = deleteSpace(document.getElementById("tConfirmationz" + selectedRowObj.rowIndex).innerText);
	var obj = document.getElementById("Confirmation");
	if (obj) {
		if ("N" == confirmation) {
			obj.checked = false;
		} else {
			obj.checked = true;
		}
	}

	var tformula = deleteSpace(document.getElementById("tFormulaz" + selectedRowObj.rowIndex).innerText);
	var obj = document.getElementById("Formula1");
	if (obj) {
		obj.value = tformula;
	}
	var value = deleteSpace(document.getElementById("tSpecialSignz" + selectedRowObj.rowIndex).innerText);
	var obj = document.getElementById("SpecialSign");
	var AllSpecialSign = document.getElementById("AllSpecialSign");
	if (obj) {
		obj.value = value;
		if (AllSpecialSign) {
			AllSpecialSign.options.length = 0;
			if (value != "") {
				var v = value.split(String.fromCharCode(129));
				for (var i = 0; i < v.length; i++) {
					AllSpecialSign.options.add(new Option(v[i], v[i]));
				}
			}
		}
	}
	var tflag = deleteSpace(document.getElementById("tFlagz" + selectedRowObj.rowIndex).innerText);
	if (tflag=="成人") tflag=0;
	if (tflag=="婴儿") tflag=1;
	var obj = document.getElementById("Flag");
	if (obj) {
		obj.value = tflag;
	}
}
function IUClick(isUpdate) {
	var ObservStatusDR = "";
	var rowid = "", code = "", desc = "", rangefrom = "", rangeto = "", alertrangefrom = "", alertrangeto = "", value = "", confirmation = "", formula = "", SpecialSign = "" , babyFlag = "";
	var isUpdate = isUpdate || false;
	var alertstr = "新增";
	if (isUpdate) {
		var obj = document.getElementById("rowid");
		alertstr = "更新";
		if (obj) {
			rowid = obj.value;
		}
		if (rowid == "") {
			alert("请选中需要修改的行");
			return false;
		}
	}
	var obj = document.getElementById("ObservStatusDR");
	if (obj) {
		ObservStatusDR = obj.value;
	}
	if (ObservStatusDR == "") { alert("顺序值不能为空"); return false; }
	var r = /^\+?[0-9][0-9]*$/;　　//正整数包含0
	if (!r.test(ObservStatusDR)) { alert("顺序值必须为正整数(包含0)"); return false; }
	var obj = document.getElementById("code");
	if (obj) {
		code = obj.value;
	}	
	if (code == "") { alert("观察项代码不能为空"); return false; }	
	var obj = document.getElementById("desc");
	if (obj) {
		desc = obj.value;
	}
	if (desc == "") { alert("观察项描述不能为空");; return false; }
	var obj = document.getElementById("RangeFrom");
	if (obj) {
		rangefrom = obj.value;
	}
	var obj = document.getElementById("RangeTo");
	if (obj) {
		rangeto = obj.value;
	}
	var obj = document.getElementById("AlertRangeFrom");
	if (obj) {
		alertrangefrom = obj.value;
	}
	var obj = document.getElementById("AlertRangeTo");
	if (obj) {
		alertrangeto = obj.value;
	}
	var obj = document.getElementById("Values");
	if (obj) {
		value = obj.value;
	}
	var obj = document.getElementById("SpecialSign");
	//alert(obj.value.split(String.fromCharCode(129)).length);
	if (obj) {
		SpecialSign = obj.value;
	}
	var obj = document.getElementById("Confirmation");
	if (obj) {
		if (obj.checked) {
			confirmation = "Y";
		} else {
			confirmation = "N";
		}
	}
	var obj = document.getElementById("Flag");
	if (obj) {
		babyFlag = obj.value;
	}
	var obj = document.getElementById("Formula1");
	if (obj) {
		formula = obj.value;
	}
	//	alert(code+","+desc+","+rangefrom+","+rangeto+","+alertrangefrom+","+value+","+alertrangeto+","+confirmation+","+formula+","+rowid);
	var Omethod = document.getElementById("IUmethod");
	var encmeth = "";
	if (obj) {
		encmeth = Omethod.value;
	}
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, ObservStatusDR, code, desc, rangefrom, rangeto, alertrangefrom, alertrangeto, value, confirmation, formula, SpecialSign, rowid, babyFlag);
		if (rtn == "0") {
			alert(alertstr + "成功");
		} else {
			alert(rtn);
			return false;
		}
	}
	document.location.reload();
}
function DeleteClick() {
	var id = "";
	var Orowid = document.getElementById("rowid");
	if (Orowid) {
		id = Orowid.value;
	}
	if (id == "") {
		alert("请选中需要删除的行");
		return false;
	}
	var r = confirm("确认要删除数据?");
	if (r == true) {
		var Omethod = document.getElementById("DMethod");
		var encmeth = "";
		if (obj) {
			encmeth = Omethod.value;
		}
		if (encmeth != "") {
			var rtn = cspRunServerMethod(encmeth, id);
			if (rtn == "0") {
				alert("删除成功");
			} else {
				alert("删除失败");
			}
		}
		document.location.reload();
	} else {
		document.location.reload();
		return;
	}

}
function clearSelectRow() {
	document.getElementById("ObservStatusDR").value = "";
	document.getElementById("rowid").value = "";
	document.getElementById("code").value = "";
	document.getElementById("code").disabled=false;
	document.getElementById("desc").value = "";
	document.getElementById("RangeFrom").value = "";
	document.getElementById("RangeTo").value = "";
	document.getElementById("AlertRangeFrom").value = "";
	document.getElementById("AlertRangeTo").value = "";
	document.getElementById("Values").value = "";
	document.getElementById("Confirmation").value = "";
	document.getElementById("Formula1").value = "";
	document.getElementById("SpecialSign").value = "";
	document.getElementById("AllSpecialSign").value = "";
	document.getElementById("Flag").value = "";
}
document.body.onload = BodyLoadHandler;