/*
Creator: Zhou WenJie ��Hao ShanShan��Liu XiaoMing
CreatDate:
Description: ȫ��Ԥ�����-������Ϣά��-���ÿ�Ŀά��
CSPName: herp.budg.hisui.budgitemdicteconomic.csp
ClassName: herp.budg.hisui.udata.ubudgitemdicteconomic
 */

var hospid = session['LOGON.HOSPID'];
$(function () { //��ʼ��
	$("#NameM").val('');
	Init();
});
function Init() {
	//������
	var hospid = session['LOGON.HOSPID'];
	var budgpurchasingTreeObj = $HUI.treegrid("#EconomicTree", {
			url: $URL,
			queryParams: {
				ClassName: "herp.budg.hisui.udata.ubudgitemdicteconomic",
				MethodName: "List",
				hospid: hospid,
			},
			fit: true,
			rownumbers: true,
			animate: true,
			collapsible: true,
			fitColumns: true,
			lines: true,
			/*onLoadSuccess: function (node, data) {
				if (data) {
					$(data).each(function (index, d) {
						if (this.state == 'closed') {
							$('#EconomicTree').treegrid('expandAll');
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
						hidden: true,
					}, {
						field: 'Year',
						title: '���',
						widt: 160,
						align: 'left',
						halign: 'left'
					}, {
						field: 'Code',
						title: '����',
						width: 100,
						align: 'left',
						halign: 'left'
					}, {
						field: 'SuperCode',
						title: '�ϼ�����',
						width: 80,
						align: 'left',
						halign: 'left'
					}, {
						field: 'Name',
						title: '����',
						width: 180,
						align: 'left',
						halign: 'left'
					}, {
						field: 'NameAll',
						title: '����ȫƴ',
						width: 120,
						align: 'left',
						halign: 'left'
					}, {
						field: 'Level',
						title: '�㼶',
						width: 80,
						align: 'center',
						halign: 'center'
					}, {
						field: 'TypeCode',
						title: '���',
						width: 90,
						align: 'center',
						halign: 'center'
					}, {
						field: 'Spell',
						title: 'ƴ����',
						width: 120,
						align: 'left',
						halign: 'left'
					}, {
						field: 'Direction',
						title: '�������',
						width: 80,
						align: 'center',
						halign: 'center',
					}, {
						field: 'IsLast',
						title: '�Ƿ�ĩ��',
						width: 80,
						align: 'center',
						halign: 'center',
						formatter: function (value) {
							if (value == 1) {
								return '<input  type="checkbox" checked="checked"  value="' + value + '" onclick="return false"/>'
							} else {
								return '<input  type="checkbox"  value="" onclick="return false"/>'
							}
						}
					}, {
						field: 'IsCash',
						title: '�Ƿ��ֽ�',
						width: 80,
						align: 'center',
						halign: 'center',
						formatter: function (value) {
							if (value == 1) {
								return '<input  type="checkbox" checked="checked" value="' + value + '" onclick="return false"/>'
							} else {
								return '<input type="checkbox" value="" onclick="return false"/>'
							}
						}
					}, {
						field: 'CalUnitDR',
						title: '��λ',
						width: 80,
						align: 'center',
						halign: 'center',
					}, {
						field: 'State',
						title: '�Ƿ���Ч',
						width: 85,
						align: 'center',
						halign: 'center',
						formatter: function (value) {
							if (value == 1) {
								return '<input type="checkbox" checked="checked" value="' + value + '" onclick="return false"/>'
							} else {
								return '<input type="checkbox" value="" onclick="return false"/>'
							}
						}
					}
				]],

			toolbar: [{
					id: 'Add',
					iconCls: 'icon-add',
					text: '����',
					handler: function () {
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
			var Supercode = $('#SupercodeM').val()
			var Name = $('#NameM').val()
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
			ClassName: 'herp.budg.hisui.udata.ubudgitemdicteconomic',
			MethodName: 'ItemList',
			hospid: hospid,
			Name: Name,
			Year: Year,
			Level: Level,
			Supercode: Supercode
		},
			function (rtn) {
			if (rtn !== "") {
				$('#EconomicTree').treegrid('collapseAll');
				$("#EconomicTree").treegrid('selectAll');
				$('#EconomicTree').treegrid('expandTo', rtn).treegrid('select', rtn)
			} else {
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
			}
		})
	})

	//ȫ��չ��
	function expandAll() {
		$('#EconomicTree').treegrid('expandAll');
	}

	//ȫ���۵�
	function collapseAll() {
		$('#EconomicTree').treegrid('collapseAll');
	}

	//ɾ������
	function delect() {
		var row = $('#EconomicTree').treegrid('getSelected');

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
		var rows = $('#EconomicTree').treegrid('getChildren', row.rowid);
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
							ClassName: 'herp.budg.hisui.udata.ubudgitemdicteconomic',
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
								$("#EconomicTree").treegrid("reload", parentid);
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
							ClassName: 'herp.budg.hisui.udata.ubudgitemdicteconomic',
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
								$('#EconomicTree').treegrid("reload");
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
			$("#EconomicTree").treegrid("unselectAll");
	};

}
