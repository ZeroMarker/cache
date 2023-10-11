// /����: ʵ�̣�¼�뷽ʽ���������������ݰ�Ʒ�����ʵ������
// /����: ʵ�̣�¼�뷽ʽ���������������ݰ�Ʒ�����ʵ������
var init = function() {
	// �̵�¼�뷽ʽ��
	// =======================������ʼ��start==================
	// ������
	var StkCatBox = $HUI.combobox('#StkCat', {
		valueField: 'RowId',
		textField: 'Description'
	});
	
	// ����
	$('#StkScg').stkscgcombotree({
		onSelect: function(node) {
			StkCatBox.clear();
			$.cm({
				ClassName: 'web.DHCSTMHUI.Common.Dicts',
				QueryName: 'GetStkCat',
				ResultSetType: 'array',
				StkGrpId: node.id
			}, function(data) {
				StkCatBox.loadData(data);
			});
		}
	});
	var StktkReasonParams = JSON.stringify(addSessionParams({
		Type: 'M'
	}));
	var StktkReasonCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStktkReason&ResultSetType=array&Params=' + StktkReasonParams,
			valueField: 'RowId',
			textField: 'Description',
			mode: 'remote',
			onSelect: function(record) {
				var rows = DetailGrid.getRows();
				var row = rows[DetailGrid.editIndex];
				row.StktkReason = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	var HandlerParams = function() {
		var Scg = $('#StkScg').combotree('getValue');
		var Obj = { StkGrpRowId: Scg, StkGrpType: 'M' };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#InciId'));
	// ===========================������ʼend===========================
	// ======================tbar�����¼�start=========================
	// ����
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	function Clear() {
		$UI.clearBlock('#ConditionsInput');
		$UI.clear(DetailGrid);
		var DefaultData = {
			StkScg: '',
			LocManGrp: '',
			InstNo: '',
			StkCat: '',
			LocStkBin: '',
			InStkTkWin: ''
		};
		$UI.fillBlock('#ConditionsInput', DefaultData);
		Select(gRowId);
	}
	// ��ѯ
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			QueryDetail();
		}
	});
	// ����
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			if (!DetailGrid.endEditing()) {
				return;
			}
			var ParamsObj = $UI.loopBlock('#ConditionsInput');
			var Main = JSON.stringify(ParamsObj);
			var ListData = DetailGrid.getChangesData('RowId');
			if (ListData === false) {	// δ��ɱ༭����ϸΪ��
				return;
			}
			if (isEmpty(ListData)) {	// ��ϸ����
				$UI.msg('alert', 'û����Ҫ�������ϸ!');
				return;
			}
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.InStkTkInput',
				MethodName: 'jsSave',
				Main: Main,
				ListData: JSON.stringify(ListData)
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					QueryDetail();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	// ����δ���� flag=1 ����0  flag=2 ����������
	function SetDefault(Flag) {
		var ParamsObj = $UI.loopBlock('#ConditionsInput');
		var Params = JSON.stringify(ParamsObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.InStkTkInput',
			MethodName: 'jsSetDefaultQty',
			Params: Params,
			Flag: Flag
		}, function(jsonData) {
			hideMask();
			if (jsonData.success >= 0) {
				$UI.msg('success', jsonData.msg);
				QueryDetail();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	// �����������ݲ���ʵ���б�
	function CreatStk(Inst, InstwWin) {
		if (isEmpty(Inst)) {
			$UI.msg('alert', '��ѡ���̵㵥!');
			return false;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.InStkTkInput',
			MethodName: 'jsCreateStkTkInput',
			Inst: Inst,
			UserId: gUserId,
			WinId: InstwWin
		}, function(jsonData) {
			if (jsonData.success >= 0) {
				Select(Inst);
			}
		});
	}
	
	var Select = function(Inst) {
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			MethodName: 'jsSelect',
			Inst: Inst
		},
		function(jsonData) {
			var SupLocId = jsonData.SupLocId;
			LoadData(SupLocId);
			$UI.fillBlock('#ConditionsInput', jsonData);
			QueryDetail();
		});
	};
	function LoadData(LocId) {
		// ��λ
		var LocStkBinParams = JSON.stringify(addSessionParams({ LocDr: LocId }));
		$HUI.combobox('#LocStkBin', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocStkBin&ResultSetType=array&Params=' + LocStkBinParams,
			valueField: 'RowId',
			textField: 'Description'
		});
		// ������
		$HUI.combobox('#LocManGrp', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocManGrp&ResultSetType=array&LocId=' + LocId,
			valueField: 'RowId',
			textField: 'Description'
		});
		// ʵ�̴���
		$HUI.combobox('#InStkTkWin', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInStkTkWindow&ResultSetType=array&LocId=' + LocId,
			valueField: 'RowId',
			textField: 'Description',
			editable: false
		});
		$('#InStkTkWin').combobox('setValue', gInstwWin);
	}
	
	function QueryDetail() {
		var ParamsObj = $UI.loopBlock('#ConditionsInput');
		var Params = JSON.stringify(ParamsObj);
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.InStkTkInput',
			QueryName: 'jsINStkTkInPut',
			query2JsonStrict: 1,
			Params: Params,
			rows: 99999
		});
	}
	// ======================tbar�����¼�end============================
	
	var DetailGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: 'Inst',
			field: 'Inst',
			width: 50,
			hidden: true
		}, {
			title: 'InciId',
			field: 'InciId',
			width: 50,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 120
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 150
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: 'UomId',
			field: 'UomId',
			width: 50,
			hidden: true
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 60
		}, {
			title: '��������',
			field: 'FreezeQty',
			width: 80,
			align: 'right'
		}, {
			title: 'ʵ������',
			field: 'CountQty',
			width: 80,
			align: 'right',
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: GetFmtNum('FmtQTY')
				}
			}
		}, {
			title: '��������',
			field: 'VarianceQty',
			width: 80,
			align: 'right'
		}, {
			title: '����ԭ��',
			field: 'StktkReasonId',
			width: 120,
			align: 'left',
			formatter: CommonFormatter(StktkReasonCombox, 'StktkReasonId', 'StktkReason'),
			editor: StktkReasonCombox
		}, {
			title: '����',
			field: 'Rp',
			width: 60,
			align: 'right'
		}, {
			title: '���̽��',
			field: 'FreezeRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: 'ʵ�̽��',
			field: 'CountRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '������',
			field: 'VarianceRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '��λ',
			field: 'StkBinDesc',
			width: 100
		}, {
			title: 'ʵ����',
			field: 'CountUserName',
			width: 100
		}, {
			title: 'ʵ������',
			field: 'CountDate',
			width: 100
		}, {
			title: 'ʵ��ʱ��',
			field: 'CountTime',
			width: 100
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.InStkTkInput',
			QueryName: 'jsINStkTkInPut',
			query2JsonStrict: 1,
			rows: 99999
		},
		columns: DetailGridCm,
		showBar: true,
		sortName: 'InciCode',
		sortOrder: 'asc',
		pagination: false,
		onClickRow: function(index, row) {
			DetailGrid.commonClickRow(index, row);
		},
		onBeginEdit: function(index, row) {
			$('#DetailGrid').datagrid('beginEdit', index);
			var ed = $('#DetailGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var e = ed[i];
				if (e.field == 'CountQty') {
					$(e.target).bind('keydown', function(event) {
						if (event.keyCode == 38) { // up
							var newed;
							// �����ƶ�����һ��Ϊֹ
							if (index > 0) {
								newindex = index - 1;
								$('#DetailGrid').datagrid('selectRow', newindex);
								$('#DetailGrid').datagrid('endEdit', index).datagrid('beginEdit', newindex);
								newed = DetailGrid.getEditor({ index: newindex, field: 'CountQty' });
								if (newed != null) {
									$(newed.target).focus();
									$(newed.target).next().children().focus();
								}
							}
						}
						if (event.keyCode == 40) { // down
							if (index < $('#DetailGrid').datagrid('getData').rows.length - 1) {
								newindex = index + 1;
								$('#DetailGrid').datagrid('selectRow', newindex);
								$('#DetailGrid').datagrid('endEdit', index).datagrid('beginEdit', newindex);
								newed = DetailGrid.getEditor({ index: newindex, field: 'CountQty' });
								if (newed != null) {
									$(newed.target).focus();
									$(newed.target).next().children().focus();
								}
							}
						}
					});
				}
			}
		},
		onEndEdit: function(index, row, changes) {
			if (changes.hasOwnProperty('CountQty')) {
				var CountQty = Number(row.CountQty);
				var FreezeQty = Number(row.FreezeQty);
				var Rp = Number(row.Rp);
				var FreezeRpAmt = Number(row.FreezeRpAmt);
				var VarianceQty, VarianceRpAmt;
				if (CountQty < 0) {
					$UI.msg('alert', 'ʵ����������С��0!');
					VarianceQty = 0 - FreezeQty;
					VarianceRpAmt = 0 - FreezeRpAmt;
					$(this).datagrid('updateRow', {
						index: index,
						row: {
							CountQty: 0,
							CountRpAmt: 0,
							VarianceQty: VarianceQty,
							VarianceRpAmt: VarianceRpAmt
						}
					});
					return false;
				} else {
					VarianceQty = CountQty - FreezeQty;
					VarianceRpAmt = VarianceQty * Rp;
					var CountRpAmt = CountQty * Rp;
					$(this).datagrid('updateRow', {
						index: index,
						row: {
							CountRpAmt: CountRpAmt,
							VarianceQty: VarianceQty,
							VarianceRpAmt: VarianceRpAmt
						}
					});
				}
			}
		},
		toolbar: [
			{
				text: '����δ��������0',
				iconCls: 'icon-set-zero',
				handler: function() {
					SetDefault(1);
				}
			}, {
				text: '����δ��������������',
				iconCls: 'icon-set-paper',
				handler: function() {
					SetDefault(2);
				}
			}]
	});
	CreatStk(gRowId, gInstwWin);
};
$(init);