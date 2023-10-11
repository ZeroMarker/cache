var userid = session['LOGON.USERID'];
var hospid = session['LOGON.HOSPID'];
$(function () { //��ʼ��
	Init();
});
function Init() {
	var grid = $('#MainGrid');
	var BillTypeObj = $HUI.combobox("#BillTypebox", {
			mode: 'local',
			valueField: 'rowid',
			textField: 'name',
			onSelect: function () {
				MainGridObj.load({
					ClassName: "herp.budg.hisui.udata.uBudgBillReqCtrl",
					MethodName: "List",
					hospid: hospid,
					billtype: $('#BillTypebox').combobox('getValue'),
					method: $('#Methodbox').combobox('getValue'),
					reqdeptdr: $('#ReqDeptdrbox').combobox('getValue'),
					user: $('#Userbox').combobox('getValue'),
					reqaudeptdr: $('#ReqAuDeptdrbox').combobox('getValue')
				})
			},
			data: [{
					'rowid': "1",
					'name': "��Ŀ������"
				}, {
					'rowid': "2",
					'name': "��Ŀ�ʽ����뵥"
				}, {
					'rowid': "3",
					'name': "һ��֧��������"
				}, {
					'rowid': "4",
					'name': "һ��֧���ʽ����뵥"
				}, {
					'rowid': "5",
					'name': "һ��֧��Ԥ����"
				}
			]
		});
	//���Ʒ�ʽ������
	var MethodObj = $HUI.combobox("#Methodbox", {
			mode: 'local',
			valueField: 'rowid',
			textField: 'name',
			onSelect: function () {
				MainGridObj.load({
					ClassName: "herp.budg.hisui.udata.uBudgBillReqCtrl",
					MethodName: "List",
					hospid: hospid,
					billtype: $('#BillTypebox').combobox('getValue'),
					method: $('#Methodbox').combobox('getValue'),
					reqdeptdr: $('#ReqDeptdrbox').combobox('getValue'),
					user: $('#Userbox').combobox('getValue'),
					reqaudeptdr: $('#ReqAuDeptdrbox').combobox('getValue')
				})
			},
			data: [{
					'rowid': "1",
					'name': "����"
				}, {
					'rowid': "2",
					'name': "����"
				}
			]
		});

	//ҵ�����������
	var ReqDeptdrObj = $HUI.combobox("#ReqDeptdrbox", {
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
			mode: 'remote',
			delay: 200,
			valueField: 'rowid',
			textField: 'name',
			onBeforeLoad: function (param) {
				param.hospid = hospid;
				param.userdr = userid;
				param.flag = 1;
				param.str = param.q;
			},
			onSelect: function () {
				MainGridObj.load({
					ClassName: "herp.budg.hisui.udata.uBudgBillReqCtrl",
					MethodName: "List",
					hospid: hospid,
					billtype: $('#BillTypebox').combobox('getValue'),
					method: $('#Methodbox').combobox('getValue'),
					reqdeptdr: $('#ReqDeptdrbox').combobox('getValue'),
					user: $('#Userbox').combobox('getValue'),
					reqaudeptdr: $('#ReqAuDeptdrbox').combobox('getValue')
				})
			},
		})

		//������������
		var UsersObj = $HUI.combobox("#Userbox", {
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=UserName",
			mode: 'remote',
			delay: 200,
			valueField: 'rowid',
			textField: 'name',
			onBeforeLoad: function (param) {
				param.hospid = hospid;
				param.userdr = userid;
				param.flag = 1;
				param.str = param.q;
			},
			onSelect: function () {
				MainGridObj.load({
					ClassName: "herp.budg.hisui.udata.uBudgBillReqCtrl",
					MethodName: "List",
					hospid: hospid,
					billtype: $('#BillTypebox').combobox('getValue'),
					method: $('#Methodbox').combobox('getValue'),
					reqdeptdr: $('#ReqDeptdrbox').combobox('getValue'),
					user: $('#Userbox').combobox('getValue'),
					reqaudeptdr: $('#ReqAuDeptdrbox').combobox('getValue')
				})
			},
		})

		//��ڿ���������
		var ReqAuDeptdrObj = $HUI.combobox("#ReqAuDeptdrbox", {
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
			mode: 'remote',
			delay: 200,
			valueField: 'rowid',
			textField: 'name',
			onBeforeLoad: function (param) {
				param.hospid = hospid;
				param.userdr = userid;
				param.flag = 8;
				param.str = param.q;
			},
			onSelect: function () {
				MainGridObj.load({
					ClassName: "herp.budg.hisui.udata.uBudgBillReqCtrl",
					MethodName: "List",
					hospid: hospid,
					billtype: $('#BillTypebox').combobox('getValue'),
					method: $('#Methodbox').combobox('getValue'),
					reqdeptdr: $('#ReqDeptdrbox').combobox('getValue'),
					user: $('#Userbox').combobox('getValue'),
					reqaudeptdr: $('#ReqAuDeptdrbox').combobox('getValue')
				})
			},
		})

		MainColumns = [[{
					field: 'ck',
					checkbox: true
				}, //��ѡ��
				{
					field: 'rowid',
					title: '������ϢID',
					width: 80,
					hidden: true
				}, {
					field: 'method',
					title: '���Ʒ�ʽ',
					width: 80,
					align: 'left',
					halign: 'left',
					formatter: comboboxFormatter,
					editor: {
						type: 'combobox',
						options: {
							valueField: 'rowid',
							textField: 'name',
							required: true,
							onSelect: function (data) {
								if (data.rowid == 1) {
									var ed1 = $('#MainGrid').datagrid('getEditor', {
											'index': editIndex,
											field: 'reqaudeptdr'
										});
									$(ed1.target).combobox({
										required: false,
										width: 150,
									});
									$(ed1.target).combobox("disable");
									$(ed1.target).combobox('clear');

								} else {
									var ed1 = $('#MainGrid').datagrid('getEditor', {
											index: editIndex,
											field: 'reqaudeptdr'
										});
									$(ed1.target).combobox("enable");
								}
							},
							delay: 200,
							data: [{
									rowid: "1",
									name: "����"
								}, {
									rowid: "2",
									name: "����"
								}
							]
						}
					}
				}, {
					field: 'billtype',
					title: '��������',
					width: 150,
					align: 'left',
					halign: 'left',
					allowBlank: false,
					formatter: comboboxFormatter,
					editor: {
						type: 'combobox',
						options: {
							valueField: 'rowid',
							textField: 'name',
							delay: 200,
							required: true,
							data: [{
									rowid: "1",
									name: "��Ŀ������"
								}, {
									rowid: "2",
									name: "��Ŀ�ʽ����뵥"
								}, {
									rowid: "3",
									name: "һ��֧��������"
								}, {
									rowid: "4",
									name: "һ��֧���ʽ����뵥"
								}, {
									rowid: "5",
									name: "һ��֧��Ԥ����"
								}
							]
						}
					}
				}, {
					field: 'reqdeptdr',
					title: 'ҵ�����',
					width: 150,
					align: 'left',
					halign: 'left',
					formatter: function (value, row, index) {
						return row.deptname;
					},
					editor: {
						type: 'combobox',
						options: {
							valueField: 'rowid',
							textField: 'name',
							url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
							delay: 200,
							mode: 'remote',
							required: true,
							onBeforeLoad: function (param) {
								param.hospid = hospid;
								param.userdr = userid;
								param.flag = 1;
								param.str = param.q;
							},
						}
					}
				}, {
					field: 'userid',
					title: '������',
					width: 120,
					align: 'left',
					halign: 'left',
					formatter: function (value, row, index) {
						return row.user;
					},
					editor: {
						type: 'combobox',
						options: {
							valueField: 'rowid',
							textField: 'name',
							mode: 'remote',
							url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=UserName",
							delay: 200,
							required: true,
							onBeforeLoad: function (param) {
								param.hospid = hospid;
								param.userdr = userid;
								param.flag = 1;
								param.str = param.q;
							},
						}
					}
				}, {
					field: 'reqaudeptdr',
					title: '��ڿ���',
					width: 150,
					align: 'left',
					halign: 'left',
					formatter: function (value, row, index) {
						return row.audeptname;
					},
					editor: {
						type: 'combobox',
						options: {
							valueField: 'rowid',
							textField: 'name',
							mode: 'remote',
							url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
							delay: 200,
							required: true,
							onBeforeLoad: function (param) {
								param.hospid = hospid;
								param.userdr = userid;
								param.flag = 8;
								param.str = param.q;
							}
						}
					}
				}
			]];
	var MainGridObj = $HUI.datagrid("#MainGrid", {
			url: $URL,
			queryParams: {
				ClassName: "herp.budg.hisui.udata.uBudgBillReqCtrl",
				MethodName: "List",
				hospid: hospid,
				billtype: "",
				method: "",
				reqdeptdr: "",
				user: "",
				reqaudeptd: ""
			},
			fitColumns: false, //�й̶�
			loadMsg: "���ڼ��أ����Եȡ�",
			autoRowHeight: true,
			rownumbers: true, //�к�
			ctrlSelec: true, //�����ö���ѡ���ʱ������ʹ��Ctrl��+������ķ�ʽ���ж�ѡ����
			//singleSelect: true, //ֻ����ѡ��һ��
			pageSize: 20,
			pageList: [10, 20, 30, 50, 100], //ҳ���Сѡ���б�
			pagination: true, //��ҳ
			fit: true,
			columns: MainColumns,
			rowStyler: function (index, row) {
				if (index % 2 == 1) {
					return 'background-color:#FAFAFA;';
				}
			},
			onDblClickRow: onDblClickRow, //���û�˫��һ�е�ʱ�򴥷�
			onClickRow:onDblClickRow,
			toolbar: '#tb'
		});

	function endEditing() {
		if (editIndex == undefined) {
			return true
		}
		if ($('#MainGrid').datagrid('validateRow', editIndex)) {
			var row = $('#MainGrid').datagrid('getRows')[editIndex];
			$('#MainGrid').datagrid('endEdit', editIndex);
			editIndex = undefined;
			return true;

		} else {
			return false;
		}
	}

	function onDblClickRow(index) {
		if (endEditing()) {
			$('#MainGrid').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
		} else {
			$('#MainGrid').datagrid('selectRow', editIndex);
		};
		var row = $('#MainGrid').datagrid('getRows')[index];
		if (row.method == "1") {
			var ed1 = $('#MainGrid').datagrid('getEditor', {
					index: editIndex,
					field: 'reqaudeptdr'
				});
			$(ed1.target).combobox({
				required: false,
				width: 150,
			});
			$(ed1.target).combobox("disable");

		} else {
			var ed1 = $('#MainGrid').datagrid('getEditor', {
					index: editIndex,
					field: 'reqaudeptdr'
				});
			$(ed1.target).combobox("enable");

		}
	};
	
	var EndEditFun = function () {
		var indexs = grid.datagrid('getEditingRowIndexs');
		if (indexs.length > 0) {
			for (i = 0; i < indexs.length; i++) {
				var ed = $('#MainGrid').datagrid('getEditor', {
						index: indexs[i],
						field: 'reqdeptdr'
					});
				var ed1 = $('#MainGrid').datagrid('getEditor', {
						index: indexs[i],
						field: 'userid'
					});
				var ed2 = $('#MainGrid').datagrid('getEditor', {
						index: indexs[i],
						field: 'reqaudeptdr'
					});
				if (ed) {
					var DeptName = $(ed.target).combobox('getText');
					$('#MainGrid').datagrid('getRows')[indexs[i]]['deptname'] = DeptName;
				}
				if (ed1) {
					var UserName = $(ed1.target).combobox('getText');
					$('#MainGrid').datagrid('getRows')[indexs[i]]['user'] = UserName;
				}
				if (ed2) {
					var AudeptName = $(ed2.target).combobox('getText');
					$('#MainGrid').datagrid('getRows')[indexs[i]]['audeptname'] = AudeptName;
				}
				grid.datagrid("endEdit", indexs[i]);
			}
		}
	}

	//��ѯ����
	var FindBtn = function () {
		var BillType = $('#BillTypebox').combobox('getValue'); // ��������
		var Method = $('#Methodbox').combobox('getValue'); // ���Ʒ�ʽ
		var ReqDeptdr = $('#ReqDeptdrbox').combobox('getValue'); // ҵ�����
		var User = $('#Userbox').combobox('getValue'); // ������
		var ReqAuDeptdr = $('#ReqAuDeptdrbox').combobox('getValue'); // ��ڿ���
		MainGridObj.load({
			ClassName: "herp.budg.hisui.udata.uBudgBillReqCtrl",
			MethodName: "List",
			hospid: hospid,
			billtype: BillType,
			method: Method,
			reqdeptdr: ReqDeptdr,
			user: User,
			reqaudeptd: ReqAuDeptdr
		})
	}

	//�����ѯ��ť
	$("#FindBn").click(FindBtn);

	//����һ��
	var AddRow = function (row) {
		$('#MainGrid').datagrid('endEdit', editIndex);
		$('#MainGrid').datagrid('appendRow', {
			method: ''
		});
		editIndex = $('#MainGrid').datagrid('getRows').length - 1;
		$('#MainGrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
	}

	//��Ӱ�ť
	$("#AddBn").click(AddRow);

	//���水ť
	$("#SaveBn").click(function () {
		EndEditFun();
		//ȡ�������仯�ļ�¼����
		var rows = grid.datagrid("getChanges");
		var row = "",
		data = "";
		if (!rows.length) {
			$.messager.popover({
				msg: 'û��Ҫ��������ݣ�',
				type: 'info',
				style: {
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
					top: 10
				}
			});
			return false;
		} else {
			$.messager.confirm('ȷ��', 'ȷ��Ҫ����������',
				function (t) {
				if (t) {
					for (var i = 0; i < rows.length; i++) {
						row = rows[i];
						var rowid = ((row.rowid == undefined) ? '' : row.rowid);
						var hospId = hospid;
						var billtype = ((row.billtype == undefined) ? '' : row.billtype);
						var method = ((row.method == undefined) ? '' : row.method);
						var reqdeptdr = ((row.reqdeptdr == undefined) ? '' : row.reqdeptdr);
						var userid = ((row.userid == undefined) ? '' : row.userid);
						var reqaudeptdr = ((row.reqaudeptdr == undefined) ? '' : row.reqaudeptdr);

						if (saveAllowBlankVaild(grid, row) == true) {

							var datad = hospId + '|' + billtype + '|' + method + '|' + reqdeptdr + '|' + userid + '|' + reqaudeptdr

								if (rowid == "") {
									$.m({
										ClassName: 'herp.budg.hisui.udata.uBudgBillReqCtrl',
										MethodName: 'Insert',
										data: datad,
									},
										function (Data) {
										if (Data == 0) {
											$.messager.popover({
												msg: '����ɹ���',
												type: 'success',
												style: {
													left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
													top: 10
												}
											});
										} else if (Data == "RepCode") {
											$.messager.popover({
												msg: "�����ظ����Ѵ�����Ӧ����Ķ�Ӧ��ϵ",
												type: 'error',
												style: {
													left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
													top: 10
												}
											});
										} else {
											$.messager.popover({
												msg: "������Ϣ:" + Data,
												type: 'error',
												style: {
													left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
													top: 10
												}
											});
										}
									});
									grid.datagrid("reload");
								} else {
									$.m({
										ClassName: 'herp.budg.hisui.udata.uBudgBillReqCtrl',
										MethodName: 'Update',
										rowid: rowid,
										data: datad,
									},
										function (Data) {
										if (Data == 0) {
											$.messager.popover({
												msg: '����ɹ���',
												type: 'success',
												style: {
													left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
													top: 10
												}
											});
										} else if (Data == "RepCode") {
											$.messager.popover({
												msg: "�����ظ����Ѵ�����Ӧ����Ķ�Ӧ��ϵ",
												type: 'error',
												style: {
													left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
													top: 10
												}
											});
										} else {
											$.messager.popover({
												msg: "������Ϣ:" + Data,
												type: 'error',
												style: {
													left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
													top: 10
												}
											});
										}
									});
								}
								grid.datagrid("reload");
						}
					}
				}
			})
		}
	});

	//ɾ��
	$("#DelBn").click(function () {
		$.messager.confirm('ȷ��', 'ȷ��Ҫɾ��ѡ����������', function (t) {
			if (t) {
				var rows = $('#MainGrid').datagrid('getSelections');
				var len = rows.length;
				var data = "";
				for (var i = 0; i < len; i++) {
					if (data == "") {
						data = rows[i].rowid;
					} else {
						data = data + "^" + rows[i].rowid;

					}
				}
				$.m({
					ClassName: 'herp.budg.hisui.udata.uBudgBillReqCtrl',
					MethodName: 'Delete',
					rowids: data
				},
					function (Data) {
					if (Data == 0) {
						$.messager.popover({
							msg: 'ɾ���ɹ���',
							type: 'success',
							style: {
								left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
								top: 10
							}

						});
						$('#MainGrid').datagrid("reload")
					} else {
						$.messager.popover({
							msg: 'ɾ��ʧ��! ������Ϣ:' + Data,
							type: 'error',
							style: {
								left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
								top: 10
							}
						});
						$('#MainGrid').datagrid("reload")

					}
				});
			}
		})
	})
}