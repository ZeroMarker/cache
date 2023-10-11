/// Creator：      EH
/// CreatDate：    2021-08-12
/// Description:   科室列表

function _locpanel() {
	var _grid = this;
	_grid.onSelect = function() {
	};
	_grid.find = function() {
		return gridOnFindClick('locGrid', null, function() {
			return getParams(['hospID', 'userType'], 'FindLoc', null, {
				type: GV._LOCTYPE
			});
		}, _grid.onSelect)();
	};
	_grid.onHospChange = _grid.find;
	_grid.save = function() {
		return gridOnSaveClick('locGrid', null, function(row) {
			return getParams(['dataType', 'locID', 'commonFlag'], null, 'SaveCommonFlag', null, row);
		}, _grid.onSelect)();
	};
	/// 初始化
	_grid.initEvent = function() {
		$HUI.datagrid('#locGrid', {
			url: '',
			columns: [[
				{ field: 'name', title: '科室名称', width: 198 },
				{ field: 'commonFlag', title: '按本院区设置', width: 100, formatter: getBoxFormatter('flag'), styler: getBoxStyler('flag'),
			        editor: getBoxEditor('flag')
			    },
				{ field: 'ID', title: 'ID', width: 50, hidden: true }
			]],
			fitColumns: false,
			idField: 'ID',
			singleSelect: true,
			onDblClickRow: gridOnDblClickRow('locGrid', function(index, row) {
				if (index == 0) { return false; }
			}),
			onClickCell: function(index, field, value) {
				return gridOnClickRow('locGrid', _grid.onSelect)(index, field, value);
			}
		});
		if (typeof(SelectLocID) != 'undefined') {
			$('#locGrid').datagrid('options').onLoadSuccess = function(data) {
				var rows = data.rows || [];
				rows.forEach(function(row, index, data) {
					if (row.ID == SelectLocID) {
						$('#locGrid').datagrid('selectRow',index);
						var field = $('#locGrid').datagrid('options').columns[0][0].field;
						var value = row[field];
						setTimeout(function() {
							$('#locGrid').datagrid('options').onClickCell(index, field, value);
						}, 0);
					}
				});
			};
		}
		$('#locGridSaveBtn').bind('click', _grid.save);
		$HUI.hospbar();
	};
	/// 等待参数传递
	setTimeout(function() {
		_grid.initEvent();
	}, 0);
}
$HUI.locpanel = function() {
	if (!$HUI._locpanel) {
		$HUI._locpanel = new _locpanel();
	}
	return $HUI._locpanel;
};
$(function() {
	$HUI.locpanel();
});
