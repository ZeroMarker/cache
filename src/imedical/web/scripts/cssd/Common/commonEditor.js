// 名称: 公共editor

// 名称: 消毒combogrid Editor
// 描述: 消毒包明细下拉表格
PackageItemEditor = function(HandlerParams, SelectRow, gLocId) {
	var Others = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	var cbg = null;
	function LoadData(q, obj) {
		var queryParams = new Object();
		queryParams.ClassName = 'web.CSSDHUI.Common.Dicts';
		queryParams.QueryName = 'GetPackageItem';
		queryParams.ItemName = q;
		queryParams.CreateLocDr = gLocId;
		queryParams.Others = Others;
		var opts = obj.combogrid('grid').datagrid('options');
		opts.url = $URL;
		obj.combogrid('grid').datagrid('load', queryParams);
	}
	return {
		type: 'combogrid',
		options: {
			url: $URL,
			queryParams: {
				ClassName: 'web.CSSDHUI.Common.Dicts',
				QueryName: 'GetPackageItem',
				CreateLocDr: gLocId,
				Others: Others
			},
			required: true,
			// delay: 335,
			panelHeight: Math.max(440, $(window).height() * 0.5),
			panelWidth: 305,
			mode: 'remote',
			idField: 'RowId',
			textField: 'ItemDescription',
			pagination: true, // 是否分页
			rownumbers: true, // 序号
			collapsible: false, // 是否可折叠的
			fit: true, // 自动大小
			pageSize: 10, // 每页显示的记录条数，默认为10
			pageList: [10, 15], // 可以设置每页记录条数的列表
			columns: [[
				{ field: 'RowId', title: 'RowId', width: 60, hidden: true },
				{ field: 'ItemDescription', title: '器械', width: 120 },
				{ field: 'ItemSpec', title: '器械规格', width: 150 }
			]],
			onClickRow: function(index, row) {
				cbg.combogrid('setValue', row.ItemDescription);
				SelectRow(row);
			},
			onShowPanel: function() {
				cbg = $(this);
			},
			onBeforeLoad: function(param) {
				param.Others = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
			},
			keyHandler: {
				up: function() {
					// 取得选中行
					var rows = '';
					var selected = $(this).combogrid('grid').datagrid('getSelected');
					if (selected) {
						// 取得选中行的rowIndex
						var index = $(this).combogrid('grid').datagrid('getRowIndex', selected);
						// 向上移动到第一行为止
						if (index > 0) {
							$(this).combogrid('grid').datagrid('selectRow', index - 1);
						} else {
							rows = $(this).combogrid('grid').datagrid('getRows');
							$(this).combogrid('grid').datagrid('selectRow', rows.length - 1);
						}
					} else {
						rows = $(this).combogrid('grid').datagrid('getRows');
						$(this).combogrid('grid').datagrid('selectRow', rows.length - 1);
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
						$(this).combogrid('grid').datagrid('selectRow', 0);
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
						$(this).combogrid('setValue', selected.ItemDescription);
						SelectRow(selected);
					}
					// 选中后让下拉表格消失
					$(this).combogrid('hidePanel');
					$(this).focus();
				},
				query: function(q) {
					var object = new Object();
					object = $(this);
					if (this.AutoSearchTimeOut) {
						window.clearTimeout(this.AutoSearchTimeOut);
						this.AutoSearchTimeOut = window.setTimeout(function() { LoadData(q, object); }, 400);
					} else {
						this.AutoSearchTimeOut = window.setTimeout(function() { LoadData(q, object); }, 400);
					}
					$(this).combogrid('setValue', q);
				}
			}
		}
	};
};