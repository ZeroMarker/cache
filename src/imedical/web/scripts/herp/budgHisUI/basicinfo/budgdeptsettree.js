/*
Creator: Hou ShanChuan ��Liu XiaoMing
CreatDate: 2018-09-30
Description: ȫ��Ԥ�����-������Ϣά��-Ԥ�����ά��
CSPName: herp.budg.hisui.budgdeptsettree.csp
ClassName: herp.budg.hisui.udata.uBudgDeptSet
 */

var userid = session['LOGON.USERID'];
var hospid = session['LOGON.HOSPID'];
var addEditDlgDlgObj = ''; //�����ж����/�޸ĶԻ����Ƿ��Ѵ���
var copyDlgObj = '';
var isAll = false; //�ܿ��Ƿ�չ����ѡ�ڵ������ӽڵ�
var flag = "";

//�ĵ������¼�
$(function () {
	$("#CodeName").val('');
	Init();
});

function Init() {

	//�����չ���ýڵ����һ�ڵ�
	function onClickRow(row) {
		isAll = false;
		if ((row) && ($('#budgLocTree').treegrid('getSelected').state == 'closed')) {
			$('#budgLocTree').treegrid('expand', $('#budgLocTree').treegrid('getSelected').id)
		} else {
			$('#budgLocTree').treegrid('collapse', $('#budgLocTree').treegrid('getSelected').id)
		}
		return true;

	}

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

	function IsFormatter(value) {
		if (value == 1) {
			return '<input type="checkbox" checked="checked" value="' + value + '" onclick="return false"/>';
		} else {
			return '<input type="checkbox" value="" onclick="return false"/>';
		}
	}

	//�������α��
	var budgLocTreeObj = $HUI.treegrid('#budgLocTree', {
			lines: true,
			border: false,
			fit: true,
			idField: 'id',
			treeField: 'name',
			rownumbers: true,
			url: $URL,
			queryParams: {
				ClassName: 'herp.budg.hisui.udata.uBudgDeptSet',
				MethodName: 'ListTree',
				searchField: '',
				searchValue: '',
				sortField: '',
				sortDir: '',
				id: ''
			},
			onClickRow: onClickRow,
			onLoadSuccess: onLoadSuccessFN,
			frozenColumns: [[{
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
						title: 'Ԥ�����ID',
						field: 'id',
						halign: 'center',
						hidden: 'true'
					}, {
						title: 'Ԥ����ұ���',
						width: '120',
						field: 'code',
						halign: 'left',
						align: 'left'
					}, {
						title: 'Ԥ���������',
						width: '160',
						field: 'name',
						halign: 'left',
						align: 'left'
					}
				]],
			columns: [[{
						title: 'ƴ����',
						width: '130',
						field: 'Pym',
						halign: 'left',
						align: 'left'
					}, {
						title: '�������ID',
						width: '120',
						field: 'classType',
						hidden: 'true'
					}, {
						title: '�������',
						width: '120',
						field: 'classTypename',
						halign: 'center',
						align: 'center'
					}, {
						title: '������ID',
						width: '120',
						field: 'directdr',
						hidden: 'true'
					}, {
						title: '������',
						width: '120',
						field: 'directname',
						halign: 'left',
						align: 'left'
					}, {
						title: '���Ҳ㼶',
						width: '120',
						field: 'level',
						halign: 'center',
						align: 'center'
					}, {
						title: '����סԺ',
						width: '120',
						field: 'IOflag',
						halign: 'left',
						align: 'left'
					}, {
						title: '��ڿ���',
						width: '70',
						field: 'isbudg',
						halign: 'center',
						align: 'center',
						editor: {
							type: 'checkbox',
							options: {
								on: '1',
								off: '0'
							}
						},
						formatter: IsFormatter
					}, {
						title: '�Ƿ���Ч',
						width: '70',
						field: 'sstate',
						halign: 'center',
						align: 'center',
						editor: {
							type: 'checkbox',
							options: {
								on: '1',
								off: '0'
							}
						},
						formatter: IsFormatter
					}, {
						title: '����Ԥ����Ŀ',
						width: '130',
						field: 'isitem',
						halign: 'center',
						align: 'center',
						editor: {
							type: 'checkbox',
							options: {
								on: '1',
								off: '0'
							}
						},
						formatter: IsFormatter
					}, {
						title: '�Ƿ�ĩ��',
						width: '130',
						field: 'islast',
						halign: 'center',
						align: 'center',
						editor: {
							type: 'checkbox',
							options: {
								on: '1',
								off: '0'
							}
						},
						formatter: IsFormatter
					}, {
						title: '�ϼ�����ID',
						width: '120',
						field: '_parentId',
						hidden: false
					}

				]],
			toolbar: [{
					iconCls: 'icon-add',
					text: '����',
					handler: addFn
				}, {
					iconCls: 'icon-write-order',
					text: '�޸�',
					handler: editFn
				}, {
					iconCls: 'icon-cancel',
					text: 'ɾ��',
					handler: delFn
				}, {
					iconCls: 'icon-paper-arrow-down',
					text: 'ȫ��չ��',
					handler: expandAllFn
				}
			]

		});

	//��ѯ����
	$("#findBtn").click(function () {
		var codeNa = $("#CodeName").val();
		$('#budgLocTree').treegrid('load', {
			ClassName: 'herp.budg.hisui.udata.uBudgDeptSet',
			MethodName: 'ListTree',
			searchField: '',
			searchValue: codeNa,
			sortField: '',
			sortDir: '',
			id: ''
		});
	});

	function clear() {
		//$('#LHosp').clear();
		$("#Lcode").val('').validatebox("validate");
		$("#ldesc").val('').validatebox("validate");
		$("#spell").val('');
		$('#io').val('');
		$('#ibudg').checkbox('setValue', false);
		$('#istate').checkbox('setValue', false);
		$('#iitm').checkbox('setValue', false);
		$('#ilst').checkbox('setValue', false);
	}
	//���Ƶļ����¼�����ƴ����
	$('#ldesc').keyup(function (event) {
		$('#spell').val(makePy($('#ldesc').val().trim()));
	});

	//���水ť
	$('#Save').click(AddClickHandler);
	//������ť
	$('#Clear').click(clear);
	//�رհ�ť
	$("#Close").click(function () {
		$("#addEditDlg").window('close');
	});

	function addFn() {
		flag = 1; //��ʾ����
		//�ж��Ƿ���Ӷ�����Ŀ
		var tempIsLast = '';
		var SelectedNode = $('#budgLocTree').treegrid('getSelected');

		if (SelectedNode == null) {
			tempIsLast = 0;
		} else {
			tempIsLast = SelectedNode.islast;
		}

		if (tempIsLast == 1) {
			$.messager.alert('��ʾ', '�������ĩ���ڵ�����ӽڵ㣡');
		} else {
			clear();

			if (addEditDlgDlgObj == '') {
				addEditDlgDlgObj = $HUI.window("#addEditDlg", {
						width: 400,
						height: 550,
						left: ($(window).width() - 400) * 0.5,
						top: ($(window).height() - 550) * 0.5,
						resizable: true,
						collapsible: false,
						minimizable: false,
						maximizable: false,
						closed: true,
						draggable: true,
						modal: true,
						onClose: function () { //�رչرմ��ں󴥷�
							$("#winForm").form("clear");
						}
					});

			} else {
				addEditDlgDlgObj.open();
			}

			$('#addEditDlg').window({
				title: "����Ԥ�����",
				iconCls: 'icon-w-new'
			});
			$("#addEditDlg").css("display", "block");
			addEditDlgDlgObj.open();

			CreateInit();
		}

	}

	//����޸��¼�
	function editFn() {
		flag = 0;
		var SelectedNode = $('#budgLocTree').treegrid('getSelected');
		var rowid = SelectedNode.id;
		if ((rowid == "") || (rowid == undefined)) {
			$.messager.popover({
				msg: '��ѡ����Ҫ�༭���У�',
				timeout: 2000,
				type: 'alert',
				showType: 'show',
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
					top: 0
				}
			});
			return;
		}

		clear();

		SetDefault(rowid);

		if (addEditDlgDlgObj == '') {
			addEditDlgDlgObj = $HUI.window("#addEditDlg", {
					width: 400,
					height: 550,
					left: ($(window).width() - 400) * 0.5,
					top: ($(window).height() - 550) * 0.5,
					resizable: true,
					collapsible: false,
					minimizable: false,
					maximizable: false,
					closed: true,
					draggable: true,
					modal: true,
					onClose: function () { //�رչرմ��ں󴥷�
						$("#winForm").form("clear");
					}
				});

		}

		//��ȡwindow��title����
		//$('#addEditDlg').window('options')["title"];
		//alert($('#addEditDlg').window('options')["title"]);

		$('#addEditDlg').window({
			title: "�༭Ԥ�����",
			iconCls: 'icon-w-edit'
		});

		$("#addEditDlg").css("display", "block");
		addEditDlgDlgObj.open();
	}

	function SetDefault(rowid) {
		CreateInit();
		var mianinfo = tkMakeServerCall("herp.budg.hisui.udata.uBudgDeptSet", "Select", rowid);
		var info = mianinfo.split("^");
		$("#Lcode").val(info[0]).validatebox("validate");
		$("#ldesc").val(info[1]).validatebox("validate");
		$("#spell").val(info[10]);
		$('#io').val(info[6]);
		if (info[7] == "1") {
			$('#ibudg').checkbox('setValue', true);
		} else {
			$('#ibudg').checkbox('setValue', false);
		}
		if (info[8] == "1") {
			$('#istate').checkbox('setValue', true);
		} else {
			$('#istate').checkbox('setValue', false);
		}
		if (info[9] == "1") {
			$('#iitm').checkbox('setValue', true);
		} else {
			$('#iitm').checkbox('setValue', false);
		}
		if (info[11] == "1") {
			$('#ilst').checkbox('setValue', true);
		} else {
			$('#ilst').checkbox('setValue', false);
		}
		$("#LHosp").combobox('setValue', info[12]);
		$("#cdr").combobox('setValue', info[2]);
		$("#Lname").combobox('setValue', info[3]);

	}

	//���ɾ���¼�
	function delFn() {
		var SelectedNode = $('#budgLocTree').treegrid('getSelected');
		if (SelectedNode == null) {
			$.messager.popover({
				msg: '��ѡ����Ҫɾ�����У�',
				timeout: 2000,
				type: 'alert',
				showType: 'show',
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
					top: 0
				}
			});
			return;
		} else {
			$.messager.confirm('ȷ��', 'ȷ��ɾ����', function (t) {
				if (t) {
					$.m({
						ClassName: "herp.budg.hisui.udata.uBudgDeptSet",
						MethodName: "Delete",
						rowid: SelectedNode.id
					},
						function (rtn) {
						$.messager.progress({
							title: '��ʾ',
							msg: '����ɾ�������Ժ򡭡�'
						});
						if (rtn == 0) {
							$.messager.popover({
								msg: 'ɾ���ɹ���',
								type: 'success',
								style: {
									"position": "absolute",
									"z-index": "9999",
									left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
									top: 0
								}
							});
							$.messager.progress('close');
							var ParentNode = $('#budgLocTree').treegrid('getParent', SelectedNode.id);
							if (ParentNode) {
								$('#budgLocTree').treegrid('reload', ParentNode.id);
							} else {
								$('#budgLocTree').treegrid('reload', "");
							}
						} else {
							$.messager.popover({
								msg: 'ɾ��ʧ�ܣ�' + rtn,
								type: 'error',
								style: {
									"position": "absolute",
									"z-index": "9999",
									left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
									top: 0
								}
							});
							$.messager.progress('close');
						}
					})
				}
			})
		}
	}
	//���ȫ��չ���¼�
	function expandAllFn() {
		isAll = true;
		var SelectedNode = $('#budgLocTree').treegrid('getSelected');
		$('#budgLocTree').treegrid('expandAll', SelectedNode.id);
	}

	//����
	///n (rowId, CompName, code, name, class, directdr, Level, SupDeptID, IOFlag, IsBudg, State,
	///IsItem, Pym, IsLast)

	function AddClickHandler() {
		var SelectedNode = $('#budgLocTree').treegrid('getSelected');
		var data = "";
		var Level = 0;
		var SupDeptID = "";
		var rowId = "";
		var CompName = hospid;
		var classdr = $("#cdr").combobox('getValue');
		var directdr = $("#Lname").combobox('getValue');
		var code = $("#Lcode").val();
		if (code == '') {
			$.messager.popover({
				msg: '���ұ��벻��Ϊ��!',
				type: 'info',
				timeout: 2000,
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

		var name = $("#ldesc").val();
		if (name == '') {
			$.messager.popover({
				msg: '�������Ʋ���Ϊ��!',
				type: 'info',
				timeout: 2000,
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
		var Pym = $("#spell").val();
		var IOFlag = $("#io").val();
		var IsBudg = $("#ibudg").checkbox('getValue');
		var State = $("#istate").checkbox('getValue');
		var IsItem = $("#iitm").checkbox('getValue');
		var IsLast = $("#ilst").checkbox('getValue');
		if (IsBudg == true) {
			IsBudg = 1
		} else {
			IsBudg = 0
		}
		if (IsItem == true) {
			IsItem = 1
		} else {
			IsItem = 0
		}
		if (State == true) {
			State = 1
		} else {
			State = 0
		}
		if (IsLast == true) {
			IsLast = 1
		} else {
			IsLast = 0
		}
		if (flag == 1) {
			//����ģʽ

			if (SelectedNode == null) {
				Level = 1;
			} else {
				SupDeptID = SelectedNode.id;
				Level = parseInt(SelectedNode.level) + 1;

			}
		} else {
			//�޸�ģʽ
			rowId = SelectedNode.id;
			SupDeptID = SelectedNode._parentId;
			Level = SelectedNode.level;
		}
		$.m({
			ClassName: "herp.budg.hisui.udata.uBudgDeptSet",
			MethodName: "Save",
			rowId: rowId,
			code: code,
			name: name,
			CompName: CompName,
			classdr: classdr,
			Level: Level,
			directdr: directdr,
			SupDeptID: SupDeptID,
			IOFlag: IOFlag,
			IsBudg: IsBudg,
			State: State,
			IsItem: IsItem,
			Pym: Pym,
			IsLast: IsLast,
			hospid: hospid

		}, function (rtn) {
			if (rtn == 0) {
				$.messager.popover({
					msg: '����ɹ���',
					type: 'success',
					timeout: 1000
				});
				if (SelectedNode) {
					if (flag == 1) {
						$('#budgLocTree').treegrid('reload', SelectedNode.id);
					} else {
						var ParentNode = $('#budgLocTree').treegrid('getParent', SelectedNode.id);
						if (ParentNode) {
							$('#budgLocTree').treegrid('reload', ParentNode.id);
						} else {
							$('#budgLocTree').treegrid('reload', "");
						}
						addEditDlgDlgObj.close();
					}

				} else {
					$('#budgLocTree').treegrid('reload', "");
					addEditDlgDlgObj.close();
				}
				addEditDlgDlgObj = "";
				//DFindBtn();

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
	//����combox
	function CreateInit() {

		$('#LHosp').combobox({
			valueField: 'rowid',
			textField: 'name',
			url: $URL + '?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Hospital&ResultSetType=array',
			mode: 'remote',
			required: true,
			onBeforeLoad: function (param) {
				param.userdr = userid;
				param.rowid = hospid;
				param.str = param.q;
			}

		});

		$('#cdr').combobox({
			valueField: 'rowid',
			textField: 'name',
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=deptType",
			delay: 200,
			onBeforeLoad: function (param) {
				param.hospid = "";
				param.userdr = userid;
				param.str = param.q;
			}
		});
		$('#Lname').combobox({
			valueField: 'rowid',
			textField: 'name',
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=UserName",
			delay: 200,
			onBeforeLoad: function (param) {
				param.str = param.q;
				param.hospid = hospid;
				param.userdr = '';
				param.flag = '1';
				param.checkflag = '';
			}
		});

	}
}
