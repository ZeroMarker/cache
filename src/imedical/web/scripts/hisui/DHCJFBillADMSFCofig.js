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
		DHCWeb_HISUIalert("���������");
		return;
	}
	if ($.trim(admcondesc) == "") {
		DHCWeb_HISUIalert("����������");
		return;
	}
	if ($.trim(admconval) == "") {
		DHCWeb_HISUIalert("����������(��д)");
		return;
	}
	var encmeth = getValueById('ins');
	var ReturnValue = cspRunServerMethod(encmeth, admconcode, admcondesc, admconval);
	switch(ReturnValue) {
	case '0':
		$.messager.alert('��ʾ', '��ӳɹ�', 'info', function () {
			clear_click();
		});
		break;
	case '-1':
		DHCWeb_HISUIalert("�˷�Ʊ�����Ѿ�����");
		break;
	default:
		DHCWeb_HISUIalert("����ʧ��." + ReturnValue);
	}
}

function Del_click() {
	var row = $("#tDHCJFBillADMSFCofig").datagrid("getSelected");
	if (!row || !row.TconRowid) {
		DHCWeb_HISUIalert("��ѡ����Ҫɾ������");
		return;
	}
	var conRowId = row.TconRowid;
	$.messager.confirm('��ʾ', "ȷ��ɾ���ü�¼��", function(r){
		if(r){
			var encmeth = getValueById('delect');
			var ReturnValue = cspRunServerMethod(encmeth, conRowId);
			switch(ReturnValue) {
			case '0':
				$.messager.alert('��ʾ', 'ɾ���ɹ�', 'info', function () {
					clear_click();
				});
				break;
			case 'OPINV':
				DHCWeb_HISUIalert("Ĭ�����﷢Ʊ���Ͳ�����ɾ��");
				break;
			case 'IPINV':
				DHCWeb_HISUIalert("Ĭ��סԺ��Ʊ���Ͳ�����ɾ��");
				break;
			case 'RINV':
				DHCWeb_HISUIalert("Ĭ�ϹҺŷ�Ʊ���Ͳ�����ɾ��");
				break;
			default:
				DHCWeb_HISUIalert("��¼���ܲ����ڻ��ѱ�ɾ��, ɾ��ʧ�ܣ�");
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
		DHCWeb_HISUIalert("��ѡ����Ҫ�޸ĵļ�¼");
		return;
	}
	var conRowId = row.TconRowid;
	var admconcode = getValueById('admconcode');
	var admcondesc = getValueById("admcondesc");
	var admconval = getValueById("admconval");
	if ($.trim(admconcode) == "") {
		DHCWeb_HISUIalert("���������");
		return;
	}
	if ($.trim(admcondesc) == "") {
		DHCWeb_HISUIalert("����������");
		return;
	}
	if ($.trim(admconval) == "") {
		DHCWeb_HISUIalert("����������(��д)");
		return;
	}
	var encmeth = getValueById('update');
	var ReturnValue = cspRunServerMethod(encmeth, admconcode, admcondesc, admconval, conRowId);
	if (ReturnValue == 0) {
		DHCWeb_HISUIalert("���³ɹ�");
		clear_click();
	}
}

function init_Layout(){
	DHCWeb_ComponentLayout();
}