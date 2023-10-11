/*
Description: ȫ��Ԥ�����-������Ϣά��-������Ŀ���ÿ�Ŀ
CSPName: herp.budg.hisui.budgitemeconomic.csp
ClassName: herp.budg.hisui.udata.uBudgItemEconomic
 */

var hospid = session['LOGON.HOSPID'];
var userid = session['LOGON.USERID'];
var groupid = session['LOGON.GROUPID'];
var WinCopyObj = '';
var budgItemTree = '';
var addItemsObj = '';
var isAll = false; //�ܿ��Ƿ�չ����ѡ�ڵ������ӽڵ�

//ҽ�Ƶ�λ��ʼ��
function HospBefLoad(param) {
	param.userdr = userid;
	param.rowid = hospid;
	param.str = param.q;
}

//���Ƶ�����--��ʷ���ѡ���¼�
function PastYearSelect(param) {
	$('#BudgYear').combobox('clear');
	$('#BudgYear').combobox('reload', $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=EndYear&ResultSetType=array');
	$('#BudgYear').combobox('enable');
}

//���Ƶ�����--Ԥ����ȳ�ʼ��
function BudgYearBefLoad(param) {
	param.startYear = $('#PastYear').combobox('getValue');
	param.str = param.q;
}

//������������ǰ�¼�
function YearBefLoad(param) {
	param.flag = '';
}
//���������ѡ���¼���������ѡ��Ȳ�ѯ��ӦԤ��֧����Ŀ
function YearOnSelect(rec) {
	//combogrid���¼��ط���
	$('#itemcb').combogrid('clear');
	//$('#itemcb').combogrid('grid').datagrid('options').url = $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItem';
	$('#itemcb').combogrid('grid').datagrid('reload');

}
//��Ŀ���������ǰ�¼�
function ItemBefLoad(param) {
	param.hospid = hospid;
	param.userdr = userid;
	param.year = $('#yearcb').combobox('getValue');
	param.flag = '1';
	param.type = '';
	param.level = '';
	param.supercode = '';
	param.str = param.q;
}
//���Ƶ�����--����
function WinSave() {
	var data = '';
	var hospid = $('#CopyHosp').combobox('getValue');
	if (!hospid) {
		$.messager.popover({
			msg: '��ѡ��ҽ�Ƶ�λ!',
			type: 'info',
			timeout: 3000,
			showType: 'show',
			style: {
				"position": "absolute",
				"z-index": "9999",
				left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
				top: 10
			}
		});
		return;

	}
	var pastyear = $('#PastYear').combobox('getValue');
	if (!pastyear) {
		$.messager.popover({
			msg: '��ѡ����ʷ���!',
			type: 'info',
			timeout: 3000,
			showType: 'show',
			style: {
				"position": "absolute",
				"z-index": "9999",
				left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
				top: 10
			}
		});
		return;
	}
	var budgyear = $('#BudgYear').combobox('getValue');
	if (!budgyear) {
		$.messager.popover({
			msg: '��ѡ��Ԥ�����!',
			type: 'info',
			timeout: 3000,
			showType: 'show',
			style: {
				"position": "absolute",
				"z-index": "9999",
				left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
				top: 10
			}
		});
		return;
	}

	data = hospid + '^' + pastyear + '^' + budgyear;

	if (data) {
		$.m({
			ClassName: 'herp.budg.hisui.udata.uBudgItemEconpmic',
			MethodName: 'Copy',
			data: data
		}, function (rtn) {
			if (rtn == 0) {
				$('#itemsGrid').datagrid('reload');
				$.messager.popover({
					msg: '���Ƴɹ�!',
					type: 'success',
					timeout: 1000,
					showType: 'show',
					style: {
						"position": "absolute",
						"z-index": "9999",
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
						top: 10
					}
				});

			} else {
				$.messager.popover({
					msg: '����ʧ��!' + rtn,
					type: 'error',
					timeout: 3000,
					showType: 'show',
					style: {
						"position": "absolute",
						"z-index": "9999",
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
						top: 10
					}
				});
			};
		});
	}
}
		
	//���ĩ��Ԥ�����ˢ���Ҳ��Ӧ��Ԥ����Ŀ���
	function onClickRow(row) {
		if ($('#budgLocTree').treegrid('getSelected').isLast == 1) {
			SearchItems($('#budgLocTree').treegrid('getSelected').id);
		}
	}


//��ѯ���ҹ�ڵĿ�Ŀ
function SearchItems(deptId) {
	if (!deptId && (!$('#budgLocTree').treegrid('getSelected') || ($('#budgLocTree').treegrid('getSelected').isLast != 1))) {
		$.messager.popover({
			msg: '����ѡ��ĩ��Ԥ����Ŀ!',
			type: 'info',
			timeout: 3000,
			showType: 'show',
			style: {
				"position": "absolute",
				"z-index": "9999",
				left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
				top: 10
			}
		});
		return;

	}

	$('#itemsGrid').datagrid('load', {
		ClassName: "herp.budg.hisui.udata.uBudgItemEconpmic",
		MethodName: "EcoList",
		Hospid: hospid,
		Year: $('#budgLocTree').treegrid('getSelected').year,
		itemcode: $('#budgLocTree').treegrid('getSelected').code,
		ecocode: $('#itemcb').combogrid('grid').datagrid('getSelected') !== null ? $('#itemcb').combogrid('grid').datagrid('getSelected').ecoItemCo : ''
	});
}

//��ѯ���ÿ�Ŀ
function AddItems() {
	$("#addItemNa").val('');
	var yearCmb = $HUI.combobox('#addYearCmb', {
			placeholder: '��ѡ',
			required: true,
			valueField: 'year',
			textField: 'year',
			url: $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon&ResultSetType=array',
			mode: 'remote',
			onBeforeLoad: function (param) {
				param.flag = '';
				param.str = param.q;
			},
			onSelect: function (record) {
				$('#budgItemTree').treegrid('load', {
					ClassName: 'herp.budg.hisui.udata.ubudgitemdicteconomic',
					MethodName: 'List',
					hospid: hospid,
					Year: $("#addYearCmb").combobox('getValue'),
				});

			}
		});

	//��ѯ����
	$("#addfindBtn").click(function () {
		//��ȡ���
		var year = $("#addYearCmb").combobox('getValue');
		if (!year) {
			$.messager.popover({
				msg: '����ѡ�����!',
				type: 'info',
				timeout: 3000,
				showType: 'show',
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
					top: 10
				}
			});
			return;
		}
		//���˲�ѯ
		if (year != '') {
			$('#budgItemTree').treegrid('load', {
				ClassName: 'herp.budg.hisui.udata.ubudgitemdicteconomic',
				MethodName: 'List',
				hospid: hospid,
				Year: $("#addYearCmb").combobox('getValue'),
				Name: $("#addItemNa").val()
			});
		}
	});

	//��ȡѡ�е�ĩ��Ԥ�����ID
	var CheckedNodes = $('#budgLocTree').treegrid('getCheckedNodes');
	//console.log(JSON.stringify(CheckedNodes))
	var deptIds = '',
	deptYear = '';
	for (i = 0; i < CheckedNodes.length; i++) {
		//alert(CheckedNodes[i].isLast);
		if (CheckedNodes[i].isLast == 1) {
			if (deptIds == '') {
				deptIds = CheckedNodes[i].id;
				deptYear = CheckedNodes[i].year;
			} else {
				deptIds = deptIds + "^" + CheckedNodes[i].id;
								//alert(deptIds)

			}
		}
	}
	//console.log(deptIds)
	if (deptIds == '') {
		$.messager.popover({
			msg: '����ѡ��ĩ��Ԥ����Ŀ�ĸ�ѡ��!',
			type: 'info',
			timeout: 3000,
			showType: 'show',
			style: {
				"position": "absolute",
				"z-index": "9999",
				left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
				top: 10
			}
		});
		return;
	}

	//ȡ����ѡ�Ľڵ�
	$('#budgItemTree').treegrid('clearChecked');

	if (!addItemsObj) {
		$("#addItemsWin").show();
		addItemsObj = $HUI.dialog("#addItemsWin", {
				onClose: function () {
					//ȡ����ѡ�Ľڵ�
					$('#budgLocTree').treegrid('clearChecked');
				}
			});
	} else {
		addItemsObj.open();
	}
}

//��ѯ���ҹ�ڵĿ�Ŀ
function DelItems() {
	var itemIds = '';
	var Rows = $('#itemsGrid').datagrid('getSelections');
	if (Rows == "") {
		$.messager.alert('��ʾ', '��ѡ��ɾ����!');
		return;
	} else {
		for (i = 0; i < Rows.length; i++) {
			if (itemIds == '')
				itemIds = Rows[i].rowid;
			else
				itemIds = itemIds + "^" + Rows[i].rowid;
		}
	}

	if (itemIds) {
		$.m({
			ClassName: "herp.budg.hisui.udata.uBudgItemEconpmic",
			MethodName: "DelEco",
			rowids: itemIds
		}, function (rtn) {
			if (rtn == 0) {
				$('#itemsGrid').datagrid('reload');
				$.messager.popover({
					msg: 'ɾ���ɹ���',
					type: 'success',
					timeout: 1000,
					showType: 'show',
					style: {
						"position": "absolute",
						"z-index": "9999",
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
						top: 10
					}
				});
			} else {
				$.messager.popover({
					msg: 'ɾ��ʧ�ܣ�' + rtn,
					type: 'error',
					timeout: 3000,
					showType: 'show',
					style: {
						"position": "absolute",
						"z-index": "9999",
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
						top: 10
					}
				});
			};
		});
	}
}

//����
function SaveItemsFn() {
	//��ȡѡ�е�ĩ��Ԥ����Ŀcode
	var CheckedItemNodes = $('#budgLocTree').treegrid('getCheckedNodes');
	var deptIds = '';
	for (i = 0; i < CheckedItemNodes.length; i++) {
		if (CheckedItemNodes[i].isLast == 1) {
			if (deptIds == '') {
				deptIds = CheckedItemNodes[i].code;
			} else {
				deptIds = deptIds + "^" + CheckedItemNodes[i].code;
			}
		}
	}

	//��ȡѡ�е�ĩ�����ÿ�Ŀcode
	var CheckedEcoNodes = $('#budgItemTree').treegrid('getCheckedNodes');
	var itemIds = '';
	for (i = 0; i < CheckedEcoNodes.length; i++) {
		if (CheckedEcoNodes[i].IsLast == 1) {
			if (itemIds == '') {
				itemIds = CheckedEcoNodes[i].Code;
			} else {
				itemIds = itemIds + "^" + CheckedEcoNodes[i].Code;
			}
		}
	}

	if (deptIds && itemIds) {

		$.m({
			ClassName: "herp.budg.hisui.udata.uBudgItemEconpmic",
			MethodName: "Save",
			Hospid: hospid,
			Year: $("#YearBox").combobox('getValue'),
			ItemCodes: deptIds,
			EcoCodes: itemIds
		}, function (rtn) {
			if (rtn == 0) {
				$('#itemsGrid').datagrid('reload');
				$.messager.popover({
					msg: '����ɹ���',
					type: 'success',
					timeout: 1000,
					showType: 'show',
					style: {
						"position": "absolute",
						"z-index": "9999",
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
						top: 10
					}
				});
			} else {
				$.messager.popover({
					msg: '����ʧ�ܣ�' + rtn,
					type: 'error',
					timeout: 3000,
					showType: 'show',
					style: {
						"position": "absolute",
						"z-index": "9999",
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2, //�����м���ʾ
						top: 10
					}
				});
			};
		});
	}
}

//�رմ���
function CloseWinFn() {
	addItemsObj.close();
}

//�ĵ������¼�
$(function () {
	$("#addItemNa").val('');
	Init();
});

function Init() {

	var yearCmb = $HUI.combobox('#YearBox', {
			placeholder: '��ѡ',
			required: true,
			valueField: 'year',
			textField: 'year',
			url: $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon&ResultSetType=array',
			mode: 'remote',
			onBeforeLoad: function (param) {
				param.flag = '';
				param.str = param.q;
			},
			onSelect: function (record) {

				$('#budgLocTree').treegrid('load', {
				ClassName: 'herp.budg.hisui.udata.uBudgItemDict',
				MethodName: 'List',
				userid: userid,
				hospid: hospid,
				groupid: groupid,
				id:'',
				year: $("#YearBox").combobox('getValue'),
				name: $("#CodeName").val()
				});

			}
		});
		
	//���ݼ������֮�󴥷�
	function onLoadSuccessFN(row, data) {
		if (row && isAll) {
			var data = $('#budgLocTree').treegrid('getChildren', row.id);
			for (i = 0; i < data.length; i++) {
				if (data[i].state == 'closed') {
					$('#budgLocTree').treegrid('expandAll', data[i].id);
				}
			}
		} else {
			return;
		}
	}

	//�������α��
	var budgLocTreeObj = $HUI.treegrid('#budgLocTree', {
			checkbox: true,
			lines: true,
			fit: true,
			idField: 'id',
			treeField: 'name',
			rownumbers: true,
			url: $URL,
			queryParams: {
				ClassName: 'herp.budg.hisui.udata.uBudgItemDict',
				MethodName: 'List',
				userid: userid,
				hospid: hospid,
				groupid: groupid,
				id:'',
				year: $("#YearBox").combobox('getValue'),
				name: $("#CodeName").val()
			},
			onClickRow: onClickRow,
			onLoadSuccess: onLoadSuccessFN,
			toolbar: '#deptToolbar',
			columns: [[{
						title: 'ҽ�Ƶ�λID',
						field: 'hospId',
						halign: 'center',
						hidden: 'true'
					}, {
						title: 'ҽ�Ƶ�λ����',
						width: '140',
						field: 'hospNa',
						halign: 'center',
						hidden: 'true'
					}, {
						title: '���',
						width: '140',
						field: 'year',
						halign: 'center',
						hidden: 'true'
					}, {
						title: '�Ƿ�ĩ��',
						width: '140',
						field: 'isLast',
						halign: 'center',
						hidden: 'true'
					}, {
						title: 'Ԥ����ĿID',
						field: 'id',
						halign: 'center',
						hidden: 'true'
					}, {
						title: 'Ԥ����Ŀ����',
						width: '150',
						field: 'code',
						halign: 'left',
						align: 'left'
					}, {
						title: 'Ԥ����Ŀ����',
						width: '320',
						field: 'name',
						halign: 'left',
						align: 'left'
					}

				]]

		});

	//��ѯ����
	$("#findBtn").click(function () {
		var codeNa = $("#CodeName").val();
		$('#budgLocTree').treegrid('load', {
				ClassName: 'herp.budg.hisui.udata.uBudgItemDict',
				MethodName: 'List',
				userid: userid,
				hospid: hospid,
				groupid: groupid,
				id:'',
				year: $("#YearBox").combobox('getValue'),
				name: $("#CodeName").val()
		});
	});

	//ȫ��չ��
	$('#expandAllBtn').click(function () {
		isAll = true;
		var SelectedNode = $('#budgLocTree').treegrid('getSelected');
		$('#budgLocTree').treegrid('expandAll', SelectedNode.id);
	});

	//ȫ���۵�
	$('#collapAllBtn').click(function () {
		var SelectedNode = $('#budgLocTree').treegrid('getSelected');
		$('#budgLocTree').treegrid('collapseAll', SelectedNode.id);
	});

	//���ƿ��ҵ������ڿ�Ŀ��Ŀ�����
	$('#copyBtn').click(function () {
		$('#CopyHosp').combobox('setValue', '');
		$('#PastYear').combobox('setValue', '');
		$('#BudgYear').combobox('setValue', '');

		//���Ƶ�����--ȡ��
		function WinCancel() {
			WinCopyObj.close();
		}

		$('#copyDlg').show();
		WinCopyObj = $HUI.dialog('#copyDlg', {});
	});

	//������������ǰ�¼�
	function deptTyBefLoad(param) {
		param.str = param.q;
		param.hospid = hospid;
		param.userdr = userid;
	}

	//���������ѡ���¼�����ղ����¼��ؿ���������
	function deptTyOnSelect(rec) {
		$("#deptcb").combobox('clear');
		$('#deptcb').combobox('reload');

	}

	//�������������ǰ�¼���������
	function DeptBefLoad(param) {
		param.hospid = hospid;
		param.userdr = userid;
		param.flag = '1^' + $("#deptTycb").combobox('getValue');
		param.str = '';
	}

	//�������ұ�񷽷�
	function DeptsGridClickRow(rowIndex, rowData) {
		//alert(rowData.rowid);
		SearchItems(rowData.rowid);
	}

}
