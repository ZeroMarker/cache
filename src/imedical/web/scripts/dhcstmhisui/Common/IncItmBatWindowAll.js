// ����:	���ε��۵��õ����ε���
var IncItmBatWindowAll = function(Input, Params, Fn) {
	var ProLocId = Params.Locdr, ReqLocId = Params.ToLoc,FilterZeroQty=Params.FilterZeroQty;
	var IncItmBatMasterCm = [[
		{ title: 'InciDr', field: 'InciDr', width: 80, hidden: true, editor: 'text' },
		{ title: '����', field: 'InciCode', width: 140 },
		{ title: '����', field: 'InciDesc', width: 200 },
		{ title: '���', field: 'Spec', width: 100 },
		{ title: '��������', field: 'ManfName', width: 160 },
		{ title: '��ⵥλ', field: 'PUomDesc', width: 70 },
		{ title: '����(��ⵥλ)', field: 'PRp', width: 100, align: 'right' },
		{ title: '�ۼ�(��ⵥλ)', field: 'PSp', width: 100, align: 'right' },
		{ title: '����(��ⵥλ)', field: 'PUomQty', width: 100, align: 'right' },
		{ title: '������λ', field: 'BUomDesc', width: 80 },
		{ title: '����(������λ)', field: 'BRp', width: 100, align: 'right' },
		{ title: '�ۼ�(������λ)', field: 'BSp', width: 100, align: 'right' },
		{ title: '����(������λ)', field: 'BUomQty', width: 100, align: 'right' },
		{ title: '�˵���λ', field: 'BillUomDesc', width: 80 },
		{ title: '����(�˵���λ)', field: 'BillRp', width: 100, align: 'right' },
		{ title: '�ۼ�(�˵���λ)', field: 'BillSp', width: 100, align: 'right' },
		{ title: '����(�˵���λ)', field: 'BillUomQty', width: 100, align: 'right' },
		{ title: '������', field: 'NotUseFlag', width: 45, hidden: true }
	]];
	var Return = function() {
		if (!IncItmBatDetailGrid.endEditing()) {
			return;
		}
		var Rows = IncItmBatDetailGrid.getSelectedData();
		if (Rows == '') {
			$UI.msg('alert', '��ѡ����Ҫ���۵�������Ϣ!');
			return false;
		}
		Fn(Rows);
		Close();
	};
	var Close = function() {
		$HUI.dialog('#IncItmBatWindowAll').close();
	};
	var AdjReasonComData = $.cm({
		ClassName: 'web.DHCSTMHUI.Common.Dicts',
		QueryName: 'GetAdjPriceReason',
		ResultSetType: 'array'
	}, false);
	var AdjReasonCombox = {
		type: 'combobox',
		options: {
			data: AdjReasonComData,
			valueField: 'RowId',
			textField: 'Description',
			required: 'Y'
		}
	};
	
	var IncItmBatMasterGrid = $UI.datagrid('#IncItmBatMasterGrid', {
		lazy: false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
			MethodName: 'GetPhaOrderItemInfo',
			StrParam: JSON.stringify(addSessionParams(Params)),
			q: Input
		},
		navigatingWithKey: true,
		columns: IncItmBatMasterCm,
		onSelect: function(index, row) {
			var InciDr = row['InciDr'];
			var ParamsObj = { InciDr: InciDr, ProLocId: ProLocId,FilterZeroQty:FilterZeroQty };
			IncItmBatDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
				MethodName: 'GetDrugBatInfoAll',
				Params: JSON.stringify(ParamsObj)
			});
		}
	});
	function SaveRpSps(Params) {
		if (!IncItmBatDetailGrid.endEditing()) {
			return;
		}
		var FillFlag = $("input[name='Fill']:checked").val();	// 1:������, 2:��������
		var ResultRp = Params.Rp;
		var ResultBatSp = Params.Sp;
		var AdjReasonId = Params.AdjReason;
		var Rows = IncItmBatDetailGrid.getRows();
		var len = Rows.length;
		var FillCount = 0;
		for (var index = 0; index < len; index++) {
			var RowData = Rows[index];
			if ((FillFlag == '1') && !(isEmpty(RowData.ResultRp) && isEmpty(RowData.ResultBatSp))) {
				continue;
			}
			$('#IncItmBatDetailGrid').datagrid('endEdit', index);
			$('#IncItmBatDetailGrid').datagrid('selectRow', index);
			// $('#BarCodeGrid').datagrid('endEdit', index).datagrid('beginEdit', index);
			$('#IncItmBatDetailGrid').datagrid('editCell', { index: index, field: 'ResultRp' });
			var ed = $('#IncItmBatDetailGrid').datagrid('getEditor', { index: index, field: 'ResultRp' });
			ed.target.val(ResultRp);
			$('#IncItmBatDetailGrid').datagrid('editCell', { index: index, field: 'ResultBatSp' });
			ed = $('#IncItmBatDetailGrid').datagrid('getEditor', { index: index, field: 'ResultBatSp' });
			ed.target.val(ResultBatSp);
			$('#IncItmBatDetailGrid').datagrid('editCell', { index: index, field: 'AdjReasonId' });
			ed = $('#IncItmBatDetailGrid').datagrid('getEditor', { index: index, field: 'AdjReasonId' });
			ed.target.combobox('setValue', AdjReasonId);
			$('#IncItmBatDetailGrid').datagrid('endEdit', index);
			FillCount++;
		}
		if (FillCount > 0) {
			$UI.msg('alert', '�����' + FillCount + '��, ��ע�Ᵽ��!');
		} else {
			$UI.msg('error', 'δ������Ч���!');
		}
	}
	var IncItmBatDetailCm = [[
		{ field: 'ck', checkbox: true },
		{ title: '����RowID', field: 'Incib', width: 100, hidden: true, editor: 'text' },
		{ title: 'InciDr', field: 'InciDr', width: 100, hidden: true },
		{ title: '����', field: 'InciCode', width: 100, hidden: true },
		{ title: '����', field: 'InciDesc', width: 100, hidden: true },
		{ title: '����~Ч��', field: 'BatExp', width: 150, align: 'left' },
		{ title: '�������', field: 'IngrDate', width: 100, align: 'left' },
		{ title: '��λRowId', field: 'PurUomId', width: 100, hidden: true },
		{ title: '��λ', field: 'PurUomDesc', width: 80 },
		{ title: '����', field: 'Rp', width: 60, align: 'right' },
		{ title: '�����ۼ�', field: 'Sp', width: 70, align: 'right', sortable: true },
		{ title: '�������', field: 'ResultRp', width: 70, align: 'right',
			editor: { type: 'numberbox', options: { required: true, tipPosition: 'bottom', min: 0, precision: GetFmtNum('FmtPA') }}
		},
		{ title: '�����ۼ�', field: 'ResultBatSp', width: 70, align: 'right',
			editor: { type: 'numberbox', options: { required: true, tipPosition: 'bottom', min: 0, precision: GetFmtNum('FmtPA') }}
		},
		{ title: '������λRowId', field: 'BUomId', width: 80, hidden: true },
		{ title: '������λ', field: 'BUomDesc', width: 80, hidden: true },
		{ title: '����ԭ��', field: 'AdjReasonId', width: 100, align: 'left',
			formatter: CommonFormatter(AdjReasonCombox, 'AdjReasonId', 'AdjReason'),
			editor: AdjReasonCombox
		}
	]];
	var IncItmBatDetailGrid = $UI.datagrid('#IncItmBatDetailGrid', {
		lazy: true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
			MethodName: 'GetDrugBatInfoAll'
		},
		idField: 'Incib',
		singleSelect: false,
		columns: IncItmBatDetailCm,
		fitColumns: true,
		navigatingWithKey: true,
		onClickCell: function(index, field, value) {
			IncItmBatDetailGrid.commonClickCell(index, field);
		},
		onBeginEdit: function(index, row) {
			$('#IncItmBatDetailGrid').datagrid('beginEdit', index);
			var ed = $('#IncItmBatDetailGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var e = ed[i];
				if (e.field == 'ResultRp') {
					$(e.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var Input = $(this).val();
							if (AdjSpBatchParamObj.CalSpByMarkType == 1) {
								var Inci = row.InciDr;
								var AspUomId = row.PurUomId;
								var Sp = tkMakeServerCall('web.DHCSTMHUI.Common.PriceCommon', 'GetMtSp', Inci, AspUomId, Input);
								if (Sp == 0) {
									$UI.msg('alert', '�����ۼ�Ϊ0����������ʶ��������Ƿ���ȷ!');
									IncItmBatDetailGrid.checked = false;
									return false;
								}
								row.ResultBatSp = Sp;
							}
						}
					});
				}
			}
		},
		onDblClickRow: function(index, row) {
			var InciRow = IncItmBatMasterGrid.getSelected();
			$.extend(row, InciRow);
			Fn(row);
			Close();
		}
	});
	
	$HUI.dialog('#IncItmBatWindowAll', {
		width: gWinWidth,
		height: gWinHeight,
		modal: true,
		buttons: [
			{
				text: '������������',
				iconCls: '',
				handler: function() {
					Return();
				}
			}, {
				text: '�ر�',
				iconCls: '',
				handler: function() {
					Close();
				}
			}, {
				text: '���۸�',
				iconCls: '',
				handler: function() {
					SaveRpSp(SaveRpSps);
				}
			}
		]
	}).open();
};

// ������д����,�ۼ���Ϣ�ĵ���
var SaveRpSp = function(Fn) {
	$HUI.dialog('#SaveRpSp').open();
	
	$HUI.combobox('#AdjReason', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetAdjPriceReason&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#RpSpSureBT', {
		onClick: function() {
			var ParamsObj = $CommonUI.loopBlock('#SaveRpSp');
			var Rp = ParamsObj.Rp;
			if (isEmpty(Rp)) {
				$UI.msg('alert', '���������!');
				return false;
			}
			var Sp = ParamsObj.Sp;
			if (isEmpty(Sp)) {
				$UI.msg('alert', '�������ۼ�!');
				return false;
			}
			var AdjReason = ParamsObj.AdjReason;
			if (isEmpty(AdjReason)) {
				$UI.msg('alert', '��ѡ�����ԭ��!');
				return false;
			}
			Fn(ParamsObj);
			$HUI.dialog('#SaveRpSp').close();
		}
	});
};