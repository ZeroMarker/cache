/**
 * ��ֵ���µ�ÿ����ϸ���Դ�����,����,Ч�ڵ���Ϣ����
 * @param {} dhcit
 * @param {} InfoStr
 */
function BarCodePackItm(dhcit, InfoStr) {
	var Info = tkMakeServerCall('web.DHCSTMHUI.DHCItmTrack', 'GetPackInciStr', dhcit);
	// ��ȡ����������Ϣ��,������ʾ��Window
	if (isEmpty(Info)) {
		return false;
	}
	
	// ��ʾ�Ѵ��ڵ���Ϣ
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
			title: '��ϸID',
			field: 'RowId',
			width: 60,
			hidden: true
		}, {
			title: '����RowId',
			field: 'InciId',
			width: 60,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 100,
			sortable: true
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 120,
			sortable: true
		}, {
			title: '���',
			field: 'Spec',
			width: 120
		}, {
			title: '�Դ�����',
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
			title: '����',
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
			title: 'Ч��',
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
			title: '��������',
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
			$UI.msg('alert', '�ѱ�����ϸ����ɾ��!');
			return;
		}
		PackItmGrid.deleteRow(index);
		PackItmGrid.refreshRow();
	}

	$HUI.dialog('#BarCodePackItmWin', {
		title: InfoStr + ' ��ϸ��Ϣ',
		width: gWinWidth,
		height: gWinHeight,
		onOpen: function() {
			GetPackItmInfo(dhcit);
		}
	}).open();
}