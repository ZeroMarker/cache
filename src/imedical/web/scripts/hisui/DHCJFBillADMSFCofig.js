/// DHCJFBillADMSFCofig.js

$(function() {
	init_Layout();
	
	$HUI.linkbutton("#Add", {
		onClick: function () {
			Add_click();
		}
	});
	$HUI.linkbutton("#Del", {
		onClick: function () {
			Del_click();
		}
	});
	$HUI.linkbutton("#clear", {
		onClick: function () {
			clear_click();
		}
	});
	$HUI.linkbutton("#UP", {
		onClick: function () {
			UP_click();
		}
	});
});

function Add_click() {
	var admconcode = getValueById("admconcode");
	var admcondesc = getValueById("admcondesc");
	var admconval = getValueById("admconval");
	if ($.trim(admconcode) == "") {
		DHCWeb_HISUIalert("请输入代码");
		return;
	}
	if ($.trim(admcondesc) == "") {
		DHCWeb_HISUIalert("请输入描述");
		return;
	}
	if ($.trim(admconval) == "") {
		DHCWeb_HISUIalert("请输入类型(缩写)");
		return;
	}
	var encmeth = getValueById('ins');
	var ReturnValue = cspRunServerMethod(encmeth, admconcode, admcondesc, admconval);
	switch(ReturnValue) {
	case '0':
		$.messager.alert('提示', '添加成功', 'info', function () {
			clear_click();
		});
		break;
	case '-1':
		DHCWeb_HISUIalert("此发票类型已经存在");
		break;
	default:
		DHCWeb_HISUIalert("保存失败." + ReturnValue);
	}
}

function Del_click() {
	var row = $("#tDHCJFBillADMSFCofig").datagrid("getSelected");
	if (!row || !row.TconRowid) {
		DHCWeb_HISUIalert("请选择需要删除的行");
		return;
	}
	var conRowId = row.TconRowid;
	$.messager.confirm('提示', "确认删除该记录？", function(r){
		if(r){
			var encmeth = getValueById('delect');
			var ReturnValue = cspRunServerMethod(encmeth, conRowId);
			switch(ReturnValue) {
			case '0':
				$.messager.alert('提示', '删除成功', 'info', function () {
					clear_click();
				});
				break;
			case 'OPINV':
				DHCWeb_HISUIalert("默认门诊发票类型不允许删除");
				break;
			case 'IPINV':
				DHCWeb_HISUIalert("默认住院发票类型不允许删除");
				break;
			case 'RINV':
				DHCWeb_HISUIalert("默认挂号发票类型不允许删除");
				break;
			default:
				DHCWeb_HISUIalert("记录可能不存在或已被删除, 删除失败！");
			}
		}
	});
}

function SelectRowHandler(idnex,rowData) {
	var admconcode = rowData.Tadmcode;
	var admcondesc = rowData.Tadmcondesc;
	var admconval = rowData.Tadmconval;
	setValueById('admconcode', admconcode);
	setValueById('admcondesc', admcondesc);
	setValueById('admconval', admconval);
}

function clear_click() {
	$(":text:not(.pagination-num)").val("");
	$('#Find').click();
}

function UP_click() {
	var row = $("#tDHCJFBillADMSFCofig").datagrid("getSelected");
	if (!row || !row.TconRowid) {
		DHCWeb_HISUIalert("请选择需要修改的记录");
		return;
	}
	var conRowId = row.TconRowid;
	var admconcode = getValueById('admconcode');
	var admcondesc = getValueById("admcondesc");
	var admconval = getValueById("admconval");
	if ($.trim(admconcode) == "") {
		DHCWeb_HISUIalert("请输入代码");
		return;
	}
	if ($.trim(admcondesc) == "") {
		DHCWeb_HISUIalert("请输入描述");
		return;
	}
	if ($.trim(admconval) == "") {
		DHCWeb_HISUIalert("请输入类型(缩写)");
		return;
	}
	var encmeth = getValueById('update');
	var ReturnValue = cspRunServerMethod(encmeth, admconcode, admcondesc, admconval, conRowId);
	if (ReturnValue == 0) {
		DHCWeb_HISUIalert("更新成功");
		clear_click();
	}
}

function init_Layout(){
	DHCWeb_ComponentLayout();
}