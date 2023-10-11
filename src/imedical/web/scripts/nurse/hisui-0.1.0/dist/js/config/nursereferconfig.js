/**
 * �Ҽ���������
 * @Author   yaojining
 * @DateTime 2021-09-22
 */
$(function () {
	initUI();
});
var GLOBAL = {
	HospEnvironment: true,
	HospitalID: session['LOGON.HOSPID'],
	TargetElement: null,
	ConfigTableName: 'Nur_IP_ReferTab'
};
function initUI() {
	initHosp(function(){
		initConfig();
		initGrid();
	});
	listenEvents();
}

/**
 * ��ʼ��ȫ������
 */
 function initConfig() {
	$('#view-form').form("clear");
	$cm({
		ClassName: 'NurMp.Common.Logic.Handler',
            MethodName: 'Find',
            ClsName:'CF.NUR.EMR.ReferView', 
            TableName:'Nur_IP_ReferTab', 
            HospId:GLOBAL.HospitalID
	}, function (info) {
		if ((!$.isEmptyObject(info)) && (info.status > -1) && (!!info.data)) {
			$('#view-form').form("load", info.data);
		}
	});
 }
/**
 * @description ��ʼ�����
 */
function initGrid() {
	$('#tabgrid').datagrid({
		url: $URL,
		queryParams: {
			ClassName: 'NurMp.Service.Refer.Setting',
			QueryName: 'FindReferTabs',
			HospitalID: GLOBAL.HospitalID,
		},
		fit: true,
		nowrap: false,
		frozenColumns: [[
			{ field: 'Name', title: '����', width: 130 }
		]],
		columns: [[
			{ field: 'Code', title: '����', width: 80 },
			{ field: 'Url', title: 'CSP', width: 220 },
			{ field: 'MainFun', title: '���ӿڷ���', width: 350 },
			{ field: 'MainParemeter', title: '����������', width: 400 },
			{ field: 'SubFun', title: '�νӿڷ���', width: 150 },
			{ field: 'SubParemeter', title: '�η�������', width: 120 },
			{
				field: 'IsNowrap', title: '�Զ�����', width: 80, formatter: function (value, row, index) {
					return value == "Y" ? "��" : "��"
				}
			},
			{
				field: 'IsRever', title: '�����ѯ', width: 80, formatter: function (value, row, index) {
					return value == "Y" ? "��" : "��"
				}
			},
			{ field: 'FormatPrefix', title: 'ǰ׺', width: 80 },
			{ field: 'ReferFormat', title: '���ø�ʽ', width: 200 },
			{ field: 'FormatSuffix', title: '��׺', width: 80 },
			{
				field: 'IsStop', title: '�Ƿ�ͣ��', width: 80, formatter: function (value, row, index) {
					return value == "Y" ? "��" : "��"
				}
			}
		]],
		toolbar: "#toolbar_Tab",
		pagination: true,  //�Ƿ��ҳ
		rownumbers: true,
		pageSize: 12,
		pageList: [12, 30, 50],
		singleSelect: true,
		loadMsg: '������..',
		rowStyler: function (rowIndex, rowData) {
			if (rowData.IsStop == 'Y') {
				return 'font-style:italic;color:gray;';
			}
		},
		onClickRow: function (rowIndex, rowData) {
			$('#propertygrid').datagrid("reload", {
				ClassName: "NurMp.Service.Refer.Setting",
				QueryName: "FindReferProperty",
				ParRef: rowData.RowID
			});
		},
		onDblClickRow: function (rowIndex, rowData) {
			updateTab();
		}
	});

	$('#propertygrid').datagrid({
		url: $URL,
		queryParams: {
			ClassName: "NurMp.Service.Refer.Setting",
			QueryName: "FindReferProperty",
			ParRef: "",
		},
		fit: true,
		nowrap: false,
		columns: [[
			{ field: 'Name', title: '����', width: 130 },
			{ field: 'Code', title: '����', width: 120 },
			{ field: 'Width', title: '���', width: 100 },
			{
				field: 'Align', title: '���뷽ʽ', width: 80, formatter: function (value, row, index) {
					if (value == "L") {
						return "Left";
					} else if (value == "R") {
						return "Right";
					} else {
						return "Center";
					}
				}
			},
			{
				field: 'IsFrozen', title: '�̶���', width: 80, formatter: function (value, row, index) {
					return value == "Y" ? "��" : "��"
				}
			},
			{
				field: 'IsHidden', title: '�Ƿ�����', width: 80, formatter: function (value, row, index) {
					return value == "Y" ? "��" : "��"
				}
			},
			{
				field: 'IsOrderId', title: 'ҽ��ID', width: 80, formatter: function (value, row, index) {
					return value == "Y" ? "��" : "��"
				}
			},
			{
				field: 'IsItemNo', title: '��Ŀ���', width: 80, formatter: function (value, row, index) {
					return value == "Y" ? "��" : "��"
				}
			},
			{
				field: 'IsResult', title: '������', width: 80, formatter: function (value, row, index) {
					return value == "Y" ? "��" : "��"
				}
			},
			{
				field: 'IsAbnormal', title: '�쳣��ʾ', width: 80, formatter: function (value, row, index) {
					return value == "Y" ? "��" : "��"
				}
			}
		]],
		toolbar: "#toolbar_TabSub",
		pagination: true,  //�Ƿ��ҳ
		rownumbers: true,
		pageSize: 14,
		pageList: [14, 30, 50],
		singleSelect: true,
		loadMsg: '������..',
		rowStyler: function (rowIndex, rowData) {
			if (rowData.IsHidden == 'Y') {
				return 'font-style:italic;color:gray;';
			}
		},
		onDblClickRow: function (rowIndex, rowData) {
			updateProperty();
		}
	});
}
/**
 * @description ���ҳǩ
 */
function addTab() {
	// $("#add-dialog").dialog("open");
	$("#add-dialog").dialog({
		title: "����ҳǩ",
		iconCls: "icon-w-add",
		closed: false
	});
	$('#add-form').form("clear");
}
/**
 * @description ����ҳǩ
 */
function updateTab() {
	var rows = $('#tabgrid').datagrid("getSelections");
	if (rows.length == 1) {
		// $("#add-dialog").dialog("open");
		$("#add-dialog").dialog({
			title: "�޸�ҳǩ",
			iconCls: "icon-w-edit",
			closed: false
		});
		//��ձ�����
		$('#add-form').form("clear");
		$('#add-form').form("load", {
			RowID: rows[0].RowID,
			Name: rows[0].Name,
			Code: rows[0].Code,
			Url: rows[0].Url,
			MainFun: rows[0].MainFun,
			MainParemeter: rows[0].MainParemeter,
			SubFun: rows[0].SubFun,
			SubParemeter: rows[0].SubParemeter,
			ReferFormat: rows[0].ReferFormat,
			IsNowrap: rows[0].IsNowrap,
			IsStop: rows[0].IsStop,
			IsRever: rows[0].IsRever,
			FormatPrefix: rows[0].FormatPrefix,
			FormatSuffix: rows[0].FormatSuffix
		});
		if (rows[0].IsNowrap == "Y") {
			$("#IsNowrap").checkbox('setValue', true);
		} else {
			$("#IsNowrap").checkbox("setValue", false);
		}
		if (rows[0].IsStop == "Y") {
			$("#IsStop").checkbox('setValue', true);
		} else {
			$("#IsStop").checkbox("setValue", false);
		}
		if (rows[0].IsRever == "Y") {
			$("#IsRever").checkbox('setValue', true);
		} else {
			$("#IsRever").checkbox("setValue", false);
		}
	} else {
		$.messager.popover({ msg: "��ѡ��Ҫ�޸ĵ��������ݣ�", type: "alert" });
	}
}
/**
 * �ƶ�ҳǩ
 * @param    {[String]} direction
 */
function moveTab(direction) {
	var rows = $('#tabgrid').datagrid("getSelections");
	if (rows.length == 1) {
		var step = direction == "UP" ? -1 : 1;
		var objParam = { "HospDr": GLOBAL.HospitalID, "RowID": rows[0].RowID, "Step": step };
		$m({
			ClassName: 'NurMp.Service.Refer.Setting',
			MethodName: 'moveTab',
			Param: JSON.stringify(objParam)
		}, function (result) {
			if (result == '0') {
				$('#tabgrid').datagrid('reload');
				// $("#tabgrid").datagrid("selectRecord", rows[0].RowID);					
			} else {
				$.messager.popover({ msg: result, type: "error" });
			}
		});
	} else {
		$.messager.popover({ msg: "��ѡ��Ҫ�޸ĵ��������ݣ�", type: "alert" });
	}
}
/**
 * @description ����ҳǩ
 */
function saveTab() {
	var objElement = serializeForm('add-form');
	objElement["HospDr"] = GLOBAL.HospitalID;
	if (!objElement["Code"]) {
		$.messager.popover({ msg: "��������룡", type: "alert" });
		return;
	}
	$m({
		ClassName: 'NurMp.Service.Refer.Setting',
		MethodName: 'saveTab',
		Param: JSON.stringify(objElement)
	}, function (result) {
		if (result == '0') {
			$.messager.popover({ msg: "����ɹ���", type: "success" });
			$("#add-dialog").dialog("close");
			$('#tabgrid').datagrid('reload');
		} else {
			$.messager.popover({ msg: result, type: "error" });
		}
	});
}
/**
 * @description ɾ��ҳǩ
 */
function removeTab() {
	var rows = $('#tabgrid').datagrid("getSelections");
	if (rows.length == 1) {
		$.messager.confirm("����", "ȷ��Ҫɾ����������������", function (r) {
			if (r) {
				$m({
					ClassName: 'NurMp.Service.Refer.Setting',
					MethodName: 'deleteTab',
					Id: rows[0].RowID
				}, function (result) {
					if (result == '0') {
						$('#tabgrid').datagrid('reload');
						$('#propertygrid').datagrid('reload');
					} else {
						$.messager.popover({ msg: "ɾ��ʧ�ܣ�", type: "error" });
					}
				});
			} else {
				return;
			}
		});
	} else {
		$.messager.alert("����ʾ", "��ѡ��Ҫɾ�����������ݣ�", "info");
	}
}
/**
 * @description �������
 */
function addProperty() {
	var rows = $('#tabgrid').datagrid("getSelections");
	if (rows.length == 0) {
		$.messager.popover({ msg: "��ѡ��Ҫά����ҳǩ��", type: "alert" });
		return;
	}
	$("#property-dialog").dialog("open");
	$('#property-dialog').panel({
		title: "��������",
		iconCls: "icon-w-add",
		closed: false
	});
	$('#property-form').form("clear");
	$('#property-form').form("load", {
		Align: "L"
	});
}
/**
 * ��������
 */
function updateProperty() {
	var rows = $('#tabgrid').datagrid("getSelections");
	if (rows.length == 0) {
		$.messager.popover({ msg: "��ѡ��Ҫά����ҳǩ��", type: "alert" });
		return;
	}
	var rows = $('#propertygrid').datagrid("getSelections");
	if (rows.length == 1) {
		$("#property-dialog").dialog("open");
		$('#property-dialog').panel({
			title: "�޸�����",
			iconCls: "icon-w-edit",
			closed: false
		});
		//��ձ�����
		$('#property-form').form("clear");
		$('#property-form').form("load", {
			RowID: rows[0].RowID,
			Name: rows[0].Name,
			Code: rows[0].Code,
			Width: rows[0].Width,
			Align: rows[0].Align,
			IsFrozen: rows[0].IsFrozen,
			IsHidden: rows[0].IsHidden,
			IsOrderId: rows[0].IsOrderId,
			IsItemNo: rows[0].IsItemNo,
			IsResult: rows[0].IsResult,
			IsAbnormal: rows[0].IsAbnormal
		});
		if (rows[0].IsFrozen == "Y") {
			$("#IsFrozen").checkbox('setValue', true);
		} else {
			$("#IsFrozen").checkbox("setValue", false);
		}
		if (rows[0].IsHidden == "Y") {
			$("#IsHidden").checkbox('setValue', true);
		} else {
			$("#IsHidden").checkbox("setValue", false);
		}
		if (rows[0].IsOrderId == "Y") {
			$("#IsOrderId").checkbox('setValue', true);
		} else {
			$("#IsOrderId").checkbox("setValue", false);
		}
		if (rows[0].IsItemNo == "Y") {
			$("#IsItemNo").checkbox('setValue', true);
		} else {
			$("#IsItemNo").checkbox("setValue", false);
		}
		if (rows[0].IsResult == "Y") {
			$("#IsResult").checkbox('setValue', true);
		} else {
			$("#IsResult").checkbox("setValue", false);
		}
		if (rows[0].IsAbnormal == "Y") {
			$("#IsAbnormal").checkbox('setValue', true);
		} else {
			$("#IsAbnormal").checkbox("setValue", false);
		}
	} else {
		$.messager.popover({ msg: "��ѡ��Ҫ�޸ĵ��������ݣ�", type: "alert" });
	}
}
/**
 * �ƶ�����
 * @param    {[String]} direction
 */
function moveProperty(direction) {
	var rows = $('#propertygrid').datagrid("getSelections");
	if (rows.length == 1) {
		var step = direction == "UP" ? -1 : 1;
		var objParam = { "RowID": rows[0].RowID, "Step": step };
		$m({
			ClassName: 'NurMp.Service.Refer.Setting',
			MethodName: 'moveProperty',
			Param: JSON.stringify(objParam)
		}, function (result) {
			if (result == '0') {
				$('#propertygrid').datagrid('reload');
			} else {
				$.messager.popover({ msg: "�ƶ�ʧ�ܣ�", type: "error" });
			}
		});
	} else {
		$.messager.popover({ msg: "��ѡ��Ҫ�޸ĵ��������ݣ�", type: "alert" });
	}
}
/**
 * ��������
 */
function saveProperty() {
	var rowsTab = $('#tabgrid').datagrid("getSelections");
	var rowsProperty = $('#propertygrid').datagrid("getSelections");
	var objElement = serializeForm('property-form');
	objElement["ParRef"] = rowsTab[0].RowID;
	if (!objElement["Name"]) {
		$.messager.popover({ msg: "���������ƣ�", type: "alert" });
		return;
	}
	if (!objElement["Code"]) {
		$.messager.popover({ msg: "��������룡", type: "alert" });
		return;
	}
	$m({
		ClassName: 'NurMp.Service.Refer.Setting',
		MethodName: 'saveProperty',
		Param: JSON.stringify(objElement)
	}, function (result) {
		if (result == '0') {
			$.messager.popover({ msg: "����ɹ���", type: "success" });
			$("#property-dialog").dialog("close");
			$('#propertygrid').datagrid('reload');
		} else {
			$.messager.popover({ msg: result, type: "error" });
		}
	});
}
/**
 * ɾ������
 */
function removeProperty() {
	var rows = $('#propertygrid').datagrid("getSelections");
	if (rows.length == 1) {
		$.messager.confirm("����", "ȷ��Ҫɾ����������������", function (r) {
			if (r) {
				$m({
					ClassName: 'NurMp.Service.Refer.Setting',
					MethodName: 'deletePreperty',
					Id: rows[0].RowID
				}, function (result) {
					if (result == '0') {
						$('#propertygrid').datagrid('reload');
					} else {
						$.messager.popover({ msg: "ɾ��ʧ�ܣ�", type: "error" });
					}
				});
			} else {
				return;
			}
		});
	} else {
		$.messager.popover({ msg: "��ѡ��Ҫɾ�����������ݣ�", type: "alert" });
	}
}
/**
 * @description ��ȡָ��form�е����е�<input>����   
 */
function getElements(formId) {
	var form = document.getElementById(formId);
	var elements = new Array();
	var tagElements = form.getElementsByTagName('input');
	for (var j = 0; j < tagElements.length; j++) {
		elements.push(tagElements[j]);
	}
	return elements;
}
/**
 * @description ���л�formԪ�� 
 */
function serializeForm(formId) {
	var obj = {};
	var elements = getElements(formId);
	for (var i = 0; i < elements.length; i++) {
		if ((!elements[i].name)||(elements[i].name=='CSPCHD')) continue;
		if (elements[i].type == "checkbox") {
			var ckVal = elements[i].checked ? "Y" : "N";
			obj[elements[i].name] = ckVal;
		} else {
			obj[elements[i].name] = elements[i].value;
		}
	}
	return obj;
}
/**
 * @description ����ȫ������ 
 */
function saveView() {
	var arrItems = new Array();
	var viewelements=serializeForm('view-form');
	viewelements["RVHospDr"] = GLOBAL.HospitalID;
	arrItems.push(viewelements);
	$cm({
		ClassName: 'NurMp.Common.Logic.Handler',
		MethodName: 'Save',
		ClsName: 'CF.NUR.EMR.ReferView',
		Param: JSON.stringify(arrItems)
	}, function (result) {
		if (result.status >= 0) {
            $.messager.popover({ msg: "����ɹ���", type: "success" });
        } else {
            $.messager.popover({ msg: result, type: "error" });
        }
	});
}
/**
 * @description ���ø�ʽ
 */
function menuHandler(item) {
	var oriContent = $(GLOBAL.TargetElement).val();
	$(GLOBAL.TargetElement).val(oriContent + item.text);
}
/**
 * @description �¼� 
 */
function listenEvents() {
	$('.textFormat').mouseup(function (e) {
		GLOBAL.TargetElement = e.target;
	});
	$('.textFormat').bind('contextmenu', function (e) {
        e.preventDefault();
        $('#menu-format').menu('show', {
            left: e.pageX,
            top: e.pageY
        });
    });
	$('#btnsave').bind('click', saveView);
}
