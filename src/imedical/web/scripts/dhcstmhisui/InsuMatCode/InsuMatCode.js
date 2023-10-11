var init = function() {
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var DetailObj = MatInsuCodeGrid.getRowsData();
			if (DetailObj === false) {
				return false;
			} else if (DetailObj.length == 0) {
				$UI.msg('alert', '无需要保存的明细!');
				return false;
			}
			var Detail = JSON.stringify(DetailObj);
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.InsuMatCode',
				MethodName: 'jsSave',
				ListData: Detail
			}, function(jsonData) {
				hideMask();
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					Query();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#AddItemBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('AddConditions');
			if (isEmpty(ParamsObj.InsuCode)) {
				$UI.msg('alert', '医保代码不能为空!');
				return;
			}
			var mtname = 'jsSave';
			var Detail = '';
			if (ParamsObj.Rowid == '' || ParamsObj.Rowid == null) {
				mtname = 'jsSave';
				var Params = JSON.stringify(ParamsObj);
				Detail = '[' + Params + ']';
			} else {
				mtname = 'upDataInsuCode';
				Detail = JSON.stringify(ParamsObj);
			}
			
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.InsuMatCode',
				MethodName: mtname,
				ListData: Detail
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					$HUI.dialog('#AddWin').close();
					Query();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	$UI.linkbutton('#ReadBT', {
		onClick: function() {
			$UI.clear(MatInsuCodeGrid);
			ImportExcelFN();
		}
	});
	
	function ImportExcelFN() {
		var wb;
		var filelist = $('#File').filebox('files');
		if (filelist.length === 0) {
			$UI.msg('alert', '请选择要导入的Excel!');
			return;
		}
		showMask();
		var file = filelist[0];
		var reader = new FileReader();
		reader.onload = function(e) {
			if (reader.result) {
				reader.content = reader.result;
			}
			var data = e ? e.target.result : reader.content;
			wb = XLSX.read(data, {
				type: 'binary'
			});
			var json = to_json(wb);
			
			$('#MatInsuCodeGrid').datagrid('loadData', json);
			hideMask();
		};
		reader.readAsBinaryString(file);
	}
	function to_json(workbook) {
		var jsonData = {};
		var result = XLSX.utils.sheet_to_json(workbook.Sheets[workbook.SheetNames[0]]);
		result = result.slice(1);
		for (var i = 0; i < result.length; i++) {
			var MatInsuCode = result[i].MatInsuCode;
			var class1 = result[i].class1;
			var class2 = result[i].class2;
			var class3 = result[i].class3;
			var GenericName = result[i].GenericName;
			var quality = result[i].quality;
			var spec = result[i].spec;
			var manf = result[i].manf;
			result[i].InsuCode = MatInsuCode;
			result[i].scg1 = class1;
			result[i].scg2 = class2;
			result[i].scg3 = class3;
			result[i].GenericName = GenericName;
			result[i].Quality = quality;
			result[i].mSpec = spec;
			result[i].ManfName = manf;
			if (isEmpty(MatInsuCode)) {
				$UI.msg('alert', '第' + (i + 1) + '行医用耗材代码不允许为空!');
				hideMask();
				return;
			}
		}
		jsonData.rows = result;
		jsonData.total = result.length;
		return jsonData;
	}
	$UI.linkbutton('#DownExcelTemplet', {
		onClick: function() {
			ExportExcel();
		}
	});
	
	function ExportExcel() {
		window.open('../scripts/dhcstmhisui/InsuMatCode/MatInsuCode.xls', '_blank');
	}
	var addOneRow = {
		text: '新增',
		iconCls: 'icon-add',
		handler: function() {
			$UI.clearBlock('#AddConditions');
			$HUI.dialog('#AddWin').open();
		}
	};
	var FixOneRow = {
		text: '修改',
		iconCls: 'icon-write-order',
		handler: function() {
			var Row = MatInsuCodeGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要修改明细!');
				return;
			}
			var rowid = Row.rowid;
			$UI.clearBlock('#AddConditions');
			$.cm({
				ClassName: 'web.DHCSTMHUI.InsuMatCode',
				MethodName: 'selectInsuCode',
				rowid: rowid
			}, function(jsonData) {
				$UI.fillBlock('#AddConditions', jsonData);
				$HUI.dialog('#AddWin').open();
			});
		}
	};
	
	var MatInsuCm = [[
		{
			title: 'rowid',
			field: 'rowid',
			width: 20,
			hidden: true
		}, {
			title: '详情',
			field: 'operate',
			width: 60,
			align: 'center',
			formatter: function(value, row, index) {
				var str = '<div class="icon-read-details col-icon" title="详情" onclick="RegDetail(' + row.rowid + ')"></div>';
				return str;
			}
		}, {
			title: '医用耗材代码',
			field: 'InsuCode',
			width: 200
		}, {
			title: '一级分类(学科品类)',
			field: 'scg1',
			width: 180
		}, {
			title: '二级分类(用途品目)',
			field: 'scg2',
			width: 180
		}, {
			title: '三级分类(部位功能品种)',
			field: 'scg3',
			width: 180
		}, {
			title: '医保通用名',
			field: 'GenericName',
			width: 120
		}, {
			title: '耗材材质',
			field: 'Quality',
			width: 120
		}, {
			title: '规格(特征参数)',
			field: 'mSpec',
			width: 120
		}, {
			title: '耗材生产企业',
			field: 'ManfName',
			width: 160
		}
	]];
	
	var MatInsuCodeGrid = $UI.datagrid('#MatInsuCodeGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.InsuMatCode',
			QueryName: 'MatRegCert',
			query2JsonStrict: 1
		},
		columns: MatInsuCm,
		fitColumns: true,
		singleSelect: true,
		showBar: true,
		toolbar: [addOneRow, FixOneRow]
	});
	
	function Query() {
		var ParamsObj = $UI.loopBlock('#FindConditions');
		var Params = JSON.stringify(ParamsObj);
		MatInsuCodeGrid.load({
			ClassName: 'web.DHCSTMHUI.InsuMatCode',
			QueryName: 'MatRegCert',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	function Clear() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(MatInsuCodeGrid);
		$('#File').filebox('clear');
	}
	Clear();
	Query();
};
$(init);

var DetailCm = [[
	{
		title: 'rowid',
		field: 'rowid',
		width: 20,
		hidden: true
	}, {
		title: '注册证号',
		field: 'RegNo',
		width: 200
	}, {
		title: '注册备案人',
		field: 'agent',
		width: 200
	}, {
		title: '单件产品名',
		field: 'oneIncDesc',
		width: 200
	}, {
		title: '规格型号数',
		field: 'mSpec',
		width: 200
	}
]];
var DetailGrid = $UI.datagrid('#DetailGrid', {
	lazy: true,
	queryParams: {
		ClassName: 'web.DHCSTMHUI.InsuMatCode',
		QueryName: 'QueryDetail',
		query2JsonStrict: 1
	},
	columns: DetailCm,
	singleSelect: false,
	showBar: false
});

function RegDetail(rowid) {
	$HUI.dialog('#FindWin', {
		height: 500,
		width: 780
	}).open();
	// $UI.clear(DetailGrid);
	DetailGrid.load({
		ClassName: 'web.DHCSTMHUI.InsuMatCode',
		QueryName: 'QueryDetail',
		query2JsonStrict: 1,
		rowid: rowid
	});
}
if (!FileReader.prototype.readAsBinaryString) {
	console.log('readAsBinaryString definition not found');
	FileReader.prototype.readAsBinaryString = function(fileData) {
		var binary = '';
		var pk = this;
		var reader = new FileReader();
		reader.onload = function(e) {
			var bytes = new Uint8Array(reader.result);
			var length = bytes.byteLength;
			for (var i = 0; i < length; i++) {
				var a = bytes[i];
				var b = String.fromCharCode(a);
				binary += b;
			}
			pk.content = binary;
			$(pk).trigger('onload');
		};
		reader.readAsArrayBuffer(fileData);
	};
}