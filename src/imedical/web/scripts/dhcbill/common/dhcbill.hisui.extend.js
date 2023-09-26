$.extend($.fn.datagrid.methods, {
	editCell: function (jq, param) {
		return jq.each(function () {
			var opts = $(this).datagrid('options');
			var fields = $(this).datagrid('getColumnFields', true).concat($(this).datagrid('getColumnFields'));
			for (var i = 0; i < fields.length; i++) {
				var col = $(this).datagrid('getColumnOption', fields[i]);
				col.editor1 = col.editor;
				if (fields[i] != param.field) {
					col.editor = null;
				}
			}
			$(this).datagrid('beginEdit', param.index);
			for (var i = 0; i < fields.length; i++) {
				var col = $(this).datagrid('getColumnOption', fields[i]);
				col.editor = col.editor1;
			}
		});
	},
	endEditCell: function (jq, param) {
		return jq.each(function () {
			var thisCellEditor = null;
			var opts = $(this).datagrid('options');
			var fields = $(this).datagrid('getColumnFields', true).concat($(this).datagrid('getColumnFields'));
			for (var i = 0; i < fields.length; i++) {
				var col = $(this).datagrid('getColumnOption', fields[i]);
				if (fields[i] == param.field) {
					thisCellEditor = col.editor;
					col.editor = null;
					break;
				}
			}
			$(this).datagrid('endEdit', param.index);
			for (var i = 0; i < fields.length; i++) {
				var col = $(this).datagrid('getColumnOption', fields[i]);
				if (fields[i] == param.field) {
					col.editor = thisCellEditor;
					break;
				}
			}
		});
	},
	keyCtr: function (jq) {
		return jq.each(function () {
			var grid = $(this);
			grid.datagrid('getPanel').panel('panel').attr('tabindex', 1).bind('keydown', function (e) {
				switch (e.keyCode) {
				case 38: // up
					var selected = grid.datagrid('getSelected');
					if (selected) {
						var index = grid.datagrid('getRowIndex', selected);
						grid.datagrid('selectRow', index - 1);
					} else {
						var rows = grid.datagrid('getRows');
						grid.datagrid('selectRow', rows.length - 1);
					}
					break;
				case 40: // down
					var selected = grid.datagrid('getSelected');
					if (selected) {
						var index = grid.datagrid('getRowIndex', selected);
						grid.datagrid('selectRow', index + 1);
					} else {
						grid.datagrid('selectRow', 0);
					}
					break;
				}
			});
		});
	},
	autoMergeCells: function (jq, fields) {    //自动合并datagrid相同列
		return jq.each(function () {
			var target = $(this);
			if (!fields) {
				fields = target.datagrid("getColumnFields");
			}
			var rows = target.datagrid("getRows");
			var i = 0;
			var j = 0;
			var temp = {};
			for (i; i < rows.length; i++) {
				var row = rows[i];
				j = 0;
				for (j; j < fields.length; j++) {
					var field = fields[j];
					var tf = temp[field];
					if (!tf) {
						tf = temp[field] = {};
						tf[row[field]] = [i];
					} else {
						var tfv = tf[row[field]];
						if (tfv) {
							tfv.push(i);
						} else {
							tfv = tf[row[field]] = [i];
						}
					}
				}
			}
			$.each(temp, function (field, colunm) {
				$.each(colunm, function () {
					var group = this;
					if (group.length > 1) {
						var before;
						var after;
						var megerIndex = group[0];
						for (var i = 0; i < group.length; i++) {
							before = group[i];
							after = group[i + 1];
							if (after && (after - before) == 1) {
								continue;
							}
							var rowspan = before - megerIndex + 1;
							if (rowspan > 1) {
								target.datagrid('mergeCells', {
									index: megerIndex,
									field: field,
									rowspan: rowspan
								});
							}
							if (after && (after - before) != 1) {
								megerIndex = after;
							}
						}
					}
				});
			});
		});
	}
});
