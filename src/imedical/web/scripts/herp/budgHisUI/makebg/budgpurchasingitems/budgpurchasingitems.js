/*
Creator: Zhou WenJie ��Hao ShanShan��Liu XiaoMing
CreatDate:
Description: ȫ��Ԥ�����-������Ϣά��-�����ɹ�ƷĿά��
CSPName: herp.budg.hisui.budgpurchasingitems.csp
ClassName: herp.budg.hisui.udata.ubudgpurchasingitems
 */
var groupid = session['LOGON.GROUPID'];
var hospid = session['LOGON.HOSPID'];
var userid = session['LOGON.USERID'];
$(function () { //��ʼ��
	$("#nameM").val('');
	Init();
});
function Init() {
	//������
	var hospid = session['LOGON.HOSPID'];
	var budgpurchasingTreeObj = $HUI.treegrid("#budgpurchasingTree", {
			url: $URL,
			queryParams: {
				ClassName: "herp.budg.hisui.udata.ubudgpurchasingitems",
				MethodName: "itemList",
				hospid: hospid
			},
			rownumbers: true,
			animate: true,
			collapsible: true,
			lines: true,
			fit: true,
			/*onLoadSuccess: function (node, data) {
				if (data) {
					$(data).each(function (index, d) {
						if (this.state == 'closed') {
							$('#budgpurchasingTree').treegrid('expandAll');
						}
					})
				}
			},*/
			idField: 'rowid',
			treeField: 'Year',
			columns: [[{
						field: 'rowid',
						title: 'ID',
						hidden: true
					}, {
						field: 'CompDR',
						hidden: true
					}, {
						field: 'Year',
						title: '���',
						width: 180,
						align: 'left',
						halign: 'left'
					}, {
						field: 'Code',
						title: 'ƷĿ����',
						width: 120,
						align: 'left',
						halign: 'left'
					}, {
						field: 'Name',
						title: 'ƷĿ����',
						width: 180,
						align: 'left',
						halign: 'left'
					}, {
						field: 'SupCode',
						title: '�ϼ�����',
						width: 120,
						align: 'left',
						halign: 'left'
					}, {
						field: 'IsLast',
						title: '�Ƿ�ĩ��',
						width: 80,
						align: 'center',
						halign: 'center',
						formatter: function (value) {
							if (value == 1) {
								return '<input type="checkbox" checked="checked" value="' + value + '" onclick="return false"/>'
							} else {
								return '<input type="checkbox" value="" onclick="return false"/>'
							}
						}
					}, {
						field: 'ReMark',
						title: 'ƴ����',
						width: 150,
						align: 'left',
						halign: 'left'
					}, {
						field: 'Level',
						title: '�㼶',
						width: 80,
						align: 'center',
						halign: 'center'
					}, {
						field: 'Desc',
						title: '˵��',
						width: 800,
						align: 'left',
						halign: 'left'
					}
				]],

			toolbar: [{
					id: 'Add',
					iconCls: 'icon-add',
					text: '����',
					handler: function (hospid) {
						add()
					}
				}, {
					id: 'Edit',
					iconCls: 'icon-write-order',
					text: '�༭',
					handler: function () {
						edit()
					}
				}, {
					id: 'Del',
					iconCls: 'icon-cancel',
					text: 'ɾ��',
					handler: function () {
						delect()
					}
				}, {
					id: 'expAll',
					iconCls: 'icon-paper-arrow-down',
					text: 'ȫ��չ��',
					handler: function () {
						expandAll()
					}
				}, {
					id: 'colAll',
					iconCls: 'icon-arrow-up',
					text: 'ȫ���۵�',
					handler: function () {
						collapseAll()
					}
				}, {
					id: 'Copy',
					iconCls: 'icon-copy',
					text: '����',
					handler: function () {
						copy()
					}
				}
			],

		});

	//��ȵ�������
	var yearM = $HUI.combobox("#YearM", {
			url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
			mode: 'remote',
			delay: 200,
			valueField: 'year',
			textField: 'year',
			onBeforeLoad: function (param) {
				param.str = param.q,
				param.flag = ""
			}
		});

	//��ѯ����
	$("#FindBtn").click(function () {
		var Year = $('#YearM').combobox('getValue')
			var SupCode1 = $('#SupercodeM').val()
			var name = $('#nameM').val()
			var Level = $('#LevelM').val()
			//console.log("dataa:"+JSON.stringify(dataa))
			if (Year == "") {
				$.messager.popover({
					msg: '��ѡ����ȣ�',
					timeout: 2000,
					type: 'alert',
					showType: 'show',
					style: {
						"position": "absolute",
						"z-index": "9999",
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 1
					}
				})
				return;
			};
		$.m({
			ClassName: 'herp.budg.hisui.udata.ubudgpurchasingitems',
			MethodName: 'List',
			hospid: hospid,
			name: name,
			Year: Year,
			Level: Level,
			SupCode1: SupCode1
		},
			function (rtn) {
			if (rtn == "") {
				$.messager.popover({
					msg: '�������ݲ�����',
					type: 'error',
					style: {
						"position": "absolute",
						"z-index": "9999",
						left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
						top: 1
					}
				})
			} else {
				$('#budgpurchasingTree').treegrid('collapseAll');
				$("#budgpurchasingTree").treegrid('selectAll');
				$('#budgpurchasingTree').treegrid('expandTo', rtn).treegrid('select', rtn)
			}
		})
	})

	//ɾ������
	function delect() {
		var row = $('#budgpurchasingTree').treegrid('getSelected');
		//console.log(JSON.stringify(row));
		if (row == null) {
			$.messager.popover({
				msg: '��ѡ����Ҫɾ�����У�',
				timeout: 2000,
				type: 'alert',
				showType: 'show',
				style: {
					"position": "absolute",
					"z-index": "9999",
					left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
					top: 1
				}
			});
			return;
		};
		var rows = $('#budgpurchasingTree').treegrid('getChildren', row.rowid);
		var obj = JSON.stringify(rows);
		var rowid = row.rowid;
		var IsLast = row.IsLast;
		var Code = row.Code;
		var Year = row.Year;
		var parentid = row._parentId
			if ((IsLast == 1) || ((obj == '[]') && (IsLast == 0))) {
				$.messager.confirm('ȷ��', 'ȷ��ɾ����', function (t) {
					if (t) {
						$.m({
							ClassName: 'herp.budg.hisui.udata.ubudgpurchasingitems',
							MethodName: 'Delete',
							rowid: rowid,
							hospid: hospid,
							Code: Code,
							Year: Year
						},
							function (SQLCODE) {
							$.messager.progress({
								title: '��ʾ',
								msg: '����ɾ�������Ժ򡭡�'
							});
							if (SQLCODE == 0) {
								$.messager.popover({
									msg: 'ɾ���ɹ���',
									type: 'success',
									style: {
										"position": "absolute",
										"z-index": "9999",
										left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
										top: 1
									}
								});
								$.messager.progress('close');
								$("#budgpurchasingTree").treegrid("reload", parentid);
							} else {
								$.messager.popover({
									msg: 'ɾ��ʧ�ܣ�' + SQLCODE,
									type: 'error',
									style: {
										"position": "absolute",
										"z-index": "9999",
										left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
										top: 1
									}
								});
								$.messager.progress('close');
							}
						})
					}
				})
			} else {
				$.messager.confirm('ȷ��', '�˼�¼�����Ӽ���ȷ��ɾ����', function (t) {
					if (t) {
						var rowid = row.rowid;
						$.m({
							ClassName: 'herp.budg.hisui.udata.ubudgpurchasingitems',
							MethodName: 'Delete',
							rowid: rowid,
							hospid: hospid,
							Code: Code,
							Year: Year
						},

							function (SQLCODE) {
							$.messager.progress({
								title: '��ʾ',
								msg: '����ɾ�������Ժ򡭡�'
							});
							if (SQLCODE == 0) {
								$.messager.popover({
									msg: 'ɾ���ɹ���',
									type: 'success',
									style: {
										"position": "absolute",
										"z-index": "9999",
										left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
										top: 1
									}
								});
								$.messager.progress('close');
								$('#budgpurchasingTree').treegrid("reload");
							} else {
								$.messager.popover({
									msg: 'ɾ��ʧ�ܣ�' + SQLCODE,
									type: 'error',
									style: {
										"position": "absolute",
										"z-index": "9999",
										left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
										top: 1
									}
								});
								$.messager.progress('close');
							}
						})
					}
				})
			}
			$("#budgpurchasingTree").treegrid("unselectAll");
	};

	//ȫ��չ��
	function expandAll() {
		$('#budgpurchasingTree').treegrid('expandAll');
	};
	//ȫ���۵�
	function collapseAll() {
		$('#budgpurchasingTree').treegrid('collapseAll');
	}
};
//
