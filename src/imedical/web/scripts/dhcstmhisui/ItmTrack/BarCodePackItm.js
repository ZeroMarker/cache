/**
 * 高值包下的每个明细的自带条码,批号,效期等信息处理
 * @param {} dhcit
 * @param {} InfoStr
 */
function BarCodePackItm(dhcit, InfoStr) {
	var Info = tkMakeServerCall('web.DHCSTMHUI.DHCItmTrack', 'GetPackInciStr', dhcit);
	// 获取不到关联信息的,不再显示该Window
	if (isEmpty(Info)) {
		return false;
	}
	
	// 显示已存在的信息
	function GetPackItmInfo() {
		if (isEmpty(dhcit)) {
			return;
		}
		var ParamsObj = { DHCIT: dhcit };
		var Params = JSON.stringify(ParamsObj);
		PackItmGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			MethodName: 'GetPackItm',
			wantreturnval: 0,
			Params: Params,
			rows: 999
		});
	}
	
	var ManfParams = JSON.stringify(addSessionParams({ StkType: 'M' }));
	var PackItmManf = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + ManfParams,
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = PackItmGrid.getRows();
				var row = rows[PackItmGrid.editIndex];
				row['ManfDesc'] = record['Description'];
			}
		}
	};
	
	var PackItmCm = [[
		{
			title: '明细ID',
			field: 'RowId',
			width: 60,
			hidden: true
		}, {
			title: '物资RowId',
			field: 'InciId',
			width: 60,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 100,
			sortable: true
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 120,
			sortable: true
		}, {
			title: '规格',
			field: 'Spec',
			width: 120
		}, {
			title: '自带条码',
			field: 'OriginalCode',
			width: 150,
			sortable: true,
			editor: {
				type: 'validatebox',
				options: {
					// required: true
				}
			}
		}, {
			title: '批号',
			field: 'BatchNo',
			width: 120,
			align: 'left',
			sortable: true,
			editor: {
				type: 'validatebox',
				options: {
					// required: true
				}
			}
		}, {
			title: '效期',
			field: 'ExpDate',
			width: 120,
			align: 'left',
			sortable: true,
			editor: {
				type: 'datebox',
				options: {
					// required: true
				}
			}
		}, {
			title: '生产厂家',
			field: 'ManfId',
			width: 120,
			align: 'left',
			sortable: true,
			formatter: CommonFormatter(PackItmManf, 'ManfId', 'ManfDesc'),
			editor: PackItmManf
		}
	]];

	var PackItmGrid = $UI.datagrid('#PackItmGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			MethodName: 'GetPackItm'
		},
		columns: PackItmCm,
		fitColumns: true
	});
	
	function PackItmSplitDetail(index, row) {
		row['RowId'] = '';
		PackItmGrid.insertRow({
			index: index + 1,
			row: row
		});
	}
	
	function PackItmDeleteDetail(index, row) {
		if (row['RowId'] != '') {
			$UI.msg('alert', '已保存明细不可删除!');
			return;
		}
		PackItmGrid.deleteRow(index);
		PackItmGrid.refreshRow();
	}

	$HUI.dialog('#BarCodePackItmWin', {
		title: InfoStr + ' 明细信息',
		width: gWinWidth,
		height: gWinHeight,
		onOpen: function() {
			GetPackItmInfo(dhcit);
		}
	}).open();
}