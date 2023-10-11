// /界面科室授权维护
var init = function() {
	var LocTypeCombo = {
		type: 'combobox',
		options: {
			data: [
				{ RowId: 'All', Description: '全部科室' },
				{ RowId: 'Login', Description: '当前登录科室' },
				{ RowId: 'LinkLoc', Description: '关联科室' },
				{ RowId: 'Trans', Description: '补货科室' }
			],
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			tipPosition: 'bottom',
			onSelect: function(record) {
				var rows = MenuGrid.getRows();
				var row = rows[MenuGrid.editIndex];
				row.Desc = record.Description;
			}
		}
	};
	function LoadMenuData(q, obj) {
		var queryParams = new Object();
		queryParams.ClassName = 'web.DHCSTMHUI.LocControl';
		queryParams.QueryName = 'GetMenu';
		queryParams.q = q;
		var opts = obj.combogrid('grid').datagrid('options');
		opts.url = $URL;
		obj.combogrid('grid').datagrid('load', queryParams);
		obj.combogrid('setValue', q);
	}
	var MenuCombo = {
		type: 'combogrid',
		options: {
			url: $URL,
			queryParams: {
				ClassName: 'web.DHCSTMHUI.LocControl',
				QueryName: 'GetMenu'
			},
			EnterFun: LoadMenuData,
			required: true,
			tipPosition: 'bottom',
			panelHeight: Math.max(200, $(window).height() * 0.5),
			panelWidth: 500,
			mode: 'remote',
			pagination: true,
			rownumbers: true,
			collapsible: false,
			fit: true,
			pageSize: 20,
			pageList: [10, 15, 20],
			columns: [[
				{ field: 'MenuCode', title: '菜单代码', width: 300 },
				{ field: 'MenuDesc', title: '菜单名称', width: 150 },
				{ field: 'LinkUrl', title: 'CSP链接', width: 300 }
			]],
			onClickRow: function(index, row) {
				var MenuCode = row.MenuCode;
				var MenuDesc = row.MenuDesc;
				var LinkUrl = row.LinkUrl;
				MenuGrid.updateRow({
					index: MenuGrid.editIndex,
					row: {
						MenuCode: MenuCode,
						MenuDesc: MenuDesc,
						LinkUrl: LinkUrl
					}
				});
				setTimeout(function() {
					MenuGrid.refreshRow();
					MenuGrid.startEditingNext('MenuCode');
				}, 50);
			},
			keyHandler: {
				up: function() {
					// 取得选中行
					var selected = $(this).combogrid('grid').datagrid('getSelected');
					if (selected) {
						// 取得选中行的rowIndex
						var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
						// 向上移动到第一行为止
						if (index > 0) {
							$(this).combogrid('grid').datagrid('selectRow', index - 1);
						} else {
							var rows = $(this).combogrid('grid').datagrid('getRows');
							$(this).combogrid('grid').datagrid('selectRow', rows.length - 1);
						}
					} else {
						var rows = $(this).combogrid('grid').datagrid('getRows');
						if (rows.length > 0) {
							$(this).combogrid('grid').datagrid('selectRow', rows.length - 1);
						}
					}
				},
				down: function() {
					// 取得选中行
					var selected = $(this).combogrid('grid').datagrid('getSelected');
					if (selected) {
						// 取得选中行的rowIndex
						var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
						// 向下移动到当页最后一行为止
						if (index < $(this).combogrid('grid').datagrid('getData').rows.length - 1) {
							$(this).combogrid('grid').datagrid('selectRow', index + 1);
						} else {
							$(this).combogrid('grid').datagrid('selectRow', 0);
						}
					} else {
						var rows = $(this).combogrid('grid').datagrid('getRows');
						if (rows.length > 0) {
							$(this).combogrid('grid').datagrid('selectRow', 0);
						}
					}
				},
				left: function() {
					return false;
				},
				right: function() {
					return false;
				},
				enter: function() {
					// 文本框的内容为选中行的的字段内容
					var selected = $(this).combogrid('grid').datagrid('getSelected');
					if (selected) {
						$(this).combogrid('setValue', selected.MenuCode);
						$(this).combogrid('destroy');
						var MenuCode = selected.MenuCode;
						var MenuDesc = selected.MenuDesc;
						MenuGrid.updateRow({
							index: MenuGrid.editIndex,
							row: {
								MenuCode: MenuCode,
								MenuDesc: MenuDesc
							}
						});
						setTimeout(function() {
							MenuGrid.refreshRow();
							MenuGrid.startEditingNext('MenuCode');
						}, 50);
					}
				},
				query: function(q) {
					$(this).combogrid('grid').datagrid('clearSelections');
					if (!isEmpty($(this).combogrid('options')['EnterFun'])) {
						// 配置了EnterFun函数的,不进行自动加载
						return false;
					}
					
					var object = new Object();
					object = $(this);
					if (this.AutoSearchTimeOut) {
						window.clearTimeout(this.AutoSearchTimeOut);
						this.AutoSearchTimeOut = window.setTimeout(function() { LoadMenuData(q, object); }, 400);
					} else {
						this.AutoSearchTimeOut = window.setTimeout(function() { LoadMenuData(q, object); }, 400);
					}
					$(this).combogrid('setValue', q);
				}
			}
		}
	};
	function QueryGroup() {
		var Paramsobj = $UI.loopBlock('GroupCondition');
		var Params = JSON.stringify(addSessionParams(Paramsobj));
		$UI.clear(MenuGrid);
		$UI.clear(GroupGrid);
		GroupGrid.load({
			ClassName: 'web.DHCSTMHUI.LocControl',
			QueryName: 'GetGroup',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$('#SearchBT').on('click', function() {
		QueryGroup();
	});
	InitQueryElementAuthor();
	function InitQueryElementAuthor() {
		$('#csp' + ' :input').each(function() {
			var Id = $(this).attr('id');
			var Label = $(this).parent().prev().text() || $(this).text();
		});
	}
	function clear() {
		$UI.clearBlock('GroupCondition');
		$UI.clear(GroupGrid);
		$UI.clear(MenuGrid);
		QueryGroup();
	}
	$('#ClearBT').on('click', function() {
		clear();
	});
	var GroupCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '名称',
			field: 'Description',
			width: 200
		}
	]];
	var GroupGrid = $UI.datagrid('#GroupGrid', {
		lazy: false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocControl',
			QueryName: 'GetGroup',
			query2JsonStrict: 1
		},
		columns: GroupCm,
		fitColumns: true,
		displayMsg: '',
		onClickRow: function(index, row) {
			var GroupId = row.RowId;
			if (!isEmpty(GroupId)) {
				GetMenuInfo(GroupId);
			}
			GroupGrid.commonClickRow(index, row);
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	var MenuBar = [
		{
			text: '新增',
			iconCls: 'icon-add',
			handler: function() {
				var Selected = GroupGrid.getSelected();
				if (isEmpty(Selected)) {
					$UI.msg('alert', '请选中要维护的安全组!');
					return;
				}
				var PRowId = Selected.RowId;
				if (isEmpty(PRowId)) {
					$UI.msg('alert', '请选中要维护的安全组!');
					return;
				}
				MenuGrid.commonAddRow();
			}
		}, {
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				var Rows = MenuGrid.getChangesData();
				if (Rows === false) {	// 未完成编辑或明细为空
					return;
				}
				if (isEmpty(Rows)) {	// 明细不变
					$UI.msg('alert', '没有需要保存的明细!');
					return;
				}
				var Selected = GroupGrid.getSelected();
				var PRowId = Selected.RowId;
				if (isEmpty(PRowId)) {
					$UI.msg('alert', '请选中要维护的安全组!');
					return;
				}
				$.cm({
					ClassName: 'web.DHCSTMHUI.LocControl',
					MethodName: 'Save',
					GroupId: PRowId,
					Params: JSON.stringify(Rows)
				}, function(jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						MenuGrid.reload();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}, {
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function() {
				var Rows = MenuGrid.getSelectedData();
				if (Rows == false) {
					MenuGrid.commonDeleteRow();
					return false;
				}
				if (isEmpty(Rows)) {
					$UI.msg('alert', '请选择需要删除的信息!');
					return;
				}
				$UI.confirm('确定要删除吗?', '', '', function() {
					$.cm({
						ClassName: 'web.DHCSTMHUI.LocControl',
						MethodName: 'Delete',
						Params: JSON.stringify(Rows)
					}, function(jsonData) {
						if (jsonData.success == 0) {
							$UI.msg('success', jsonData.msg);
							MenuGrid.reload();
						} else {
							$UI.msg('error', jsonData.msg);
						}
					});
				});
			}
		}, {
			text: '页面说明',
			iconCls: 'icon-help',
			handler: function() {
				var href = '../scripts/dhcstmhisui/help/界面科室授权说明.htm';
				$('#myWindow').window({
					title: '界面科室授权说明文档',
					width: gWinWidth,
					height: gWinHeight,
					content: '<iframe scrolling="yes" frameborder="0"  src="' + href + '" style="width:100%;height:98%;"></iframe>'
				});
			}
		}
	];
	var MenuGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '菜单代码',
			field: 'MenuCode',
			width: 250,
			editor: MenuCombo
		}, {
			title: '菜单描述',
			field: 'MenuDesc',
			width: 150
		}, {
			title: 'Csp链接',
			field: 'LinkUrl',
			width: 300
		}, {
			title: '控件名称',
			field: 'Components',
			width: 100,
			editor: { type: 'validatebox', options: {}}
		}, {
			title: '科室类型',
			field: 'LocType',
			width: 100,
			formatter: CommonFormatter(LocTypeCombo, 'Code', 'Desc'),
			editor: LocTypeCombo
		}, {
			title: '是否激活',
			field: 'Active',
			width: 100,
			align: 'center',
			formatter: BoolFormatter,
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }}
		}
	]];
	var MenuGrid = $UI.datagrid('#MenuGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocControl',
			QueryName: 'QueryMenuInfo',
			query2JsonStrict: 1
		},
		columns: MenuGridCm,
		toolbar: MenuBar,
		onClickRow: function(index, row) {
			MenuGrid.commonClickRow(index, row);
		}
	});
	function GetMenuInfo(GroupId) {
		MenuGrid.load({
			ClassName: 'web.DHCSTMHUI.LocControl',
			QueryName: 'QueryMenuInfo',
			query2JsonStrict: 1,
			GroupId: GroupId
		});
	}
	clear();
};
$(init);