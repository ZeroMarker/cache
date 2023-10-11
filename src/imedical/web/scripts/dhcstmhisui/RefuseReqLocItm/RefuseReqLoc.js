var init = function() {
	var HospId = gHospId;
	function InitHosp() {
		var hospComp = InitHospCombo('CT_Loc', gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				$UI.clearBlock('RefuseTB');
				$HUI.combotree('#StkGrpId').load(HospId);
				Query();
			};
		}
		Query();
	}
	var ToLocBox = $HUI.combobox('#ToLoc', {
		// url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ToLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			ToLocBox.clear();
			var ToLocParams = JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: HospId, Element: 'ToLoc' }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ToLocParams;
			ToLocBox.reload(url);
		}
	});
	
	var FrLocBox = $HUI.combobox('#FrLoc', {
		// url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FrLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			FrLocBox.clear();
			var FrLocParams = JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: HospId, Element: 'FrLoc' }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FrLocParams;
			FrLocBox.reload(url);
		}
	});
	var HandlerParams = function() {
		var StkGrpId = $('#StkGrpId').combotree('getValue');
		var Obj = { StkGrpRowId: StkGrpId, StkGrpType: 'M', BDPHospital: HospId };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	
	var ReqLocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			// mode: 'remote',
			tipPosition: 'bottom',
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: HospId }));
			},
			onSelect: function(record) {
				var rows = RefuseReqLocGrid.getRows();
				var row = rows[RefuseReqLocGrid.editIndex];
				row.ReqLocDesc = record.Description;
			}
		}
	};
	var FroLocCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			// mode: 'remote',
			tipPosition: 'bottom',
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: HospId }));
			},
			onSelect: function(record) {
				var rows = RefuseReqLocGrid.getRows();
				var row = rows[RefuseReqLocGrid.editIndex];
				row.FroLocDesc = record.Description;
			}
		}
	};
	var SelectRow = function(row) {
		var InciDr = row.InciDr;
		var InciDesc = row.InciDesc;
		var InciCode = row.InciCode;
		RefuseReqLocGrid.updateRow({
			index: RefuseReqLocGrid.editIndex,
			row: {
				IncRowid: InciDr,
				InciCode: InciCode,
				InciDesc: InciDesc
			}
		});
		setTimeout(function() {
			RefuseReqLocGrid.refreshRow();
			RefuseReqLocGrid.startEditingNext('InciDesc');
		}, 0);
	};
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			Query();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	$UI.linkbutton('#AddBT', {
		onClick: function() {
			RefuseReqLocGrid.commonAddRow();
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var Rows = RefuseReqLocGrid.getChangesData();
			if (Rows === false) {	// δ��ɱ༭����ϸΪ��
				return;
			}
			if (isEmpty(Rows)) {	// ��ϸ����
				$UI.msg('alert', 'û����Ҫ�������ϸ!');
				return;
			}
			
			for (var i = 0; i < Rows.length; i++) {
				var InciDesc = Rows[i].InciDesc;
				if (Rows[i].FroLocId == Rows[i].ReqLocId) {
					$UI.msg('alert', InciDesc + '������Һ͹�Ӧ������ͬ,�޷�����!');
					return;
				}
				if ((Rows[i].EndDate != '') && (Rows[i].StartDate > Rows[i].EndDate)) {
					$UI.msg('alert', InciDesc + '��ʼ���ڴ��ڽ�ֹ����!');
					return;
				}
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.RefuseReqLoc',
				MethodName: 'Save',
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					RefuseReqLocGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#AddBT', {
		onClick: function() {
			RefuseReqLocGrid.commonAddRow();
		}
	});
	$UI.linkbutton('#DeleteBT', {
		onClick: function() {
			Delete();
		}
	});

	var RefuseReqLocGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 20,
			hidden: true
		}, {
			title: 'IncRowid',
			field: 'IncRowid',
			width: 20,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 150
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 150,
			editor: InciEditor(HandlerParams, SelectRow)
		}, {
			title: '��Ӧ����',
			field: 'FroLocId',
			width: 150,
			formatter: CommonFormatter(FroLocCombox, 'FroLocId', 'FroLocDesc'),
			editor: FroLocCombox
		}, {
			title: '�������',
			field: 'ReqLocId',
			width: 150,
			formatter: CommonFormatter(ReqLocCombox, 'ReqLocId', 'ReqLocDesc'),
			editor: ReqLocCombox
		}, {
			title: '��ʼ����',
			field: 'StartDate',
			width: 150,
			editor: { type: 'datebox' }
		}, {
			title: '��ֹ����',
			field: 'EndDate',
			width: 150,
			editor: { type: 'datebox' }
		}, {
			title: '��ע',
			field: 'Remark',
			width: 150,
			editor: { type: 'text' }
		}, {
			title: '�Ƿ����',
			field: 'ChkUesFlag',
			width: 100,
			formatter: BoolFormatter,
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }},
			align: 'center'
		}
	]];

	var RefuseReqLocGrid = $UI.datagrid('#RefuseReqLocGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.RefuseReqLoc',
			QueryName: 'Query',
			query2JsonStrict: 1
		},
		columns: RefuseReqLocGridCm,
		fitColumns: true,
		toolbar: '#RefuseTB',
		checkField: 'IncRowid',
		onClickCell: function(index, field, value) {
			RefuseReqLocGrid.commonClickCell(index, field, value);
		}
	});
	function Query() {
		var SessionParmas = addSessionParams({ Hospital: HospId });
		var Paramsobj = $UI.loopBlock('RefuseTB');
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		$UI.clear(RefuseReqLocGrid);
		RefuseReqLocGrid.load({
			ClassName: 'web.DHCSTMHUI.RefuseReqLoc',
			QueryName: 'Query',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	function Delete() {
		var Rows = RefuseReqLocGrid.getSelectedData();
		if (Rows == false) {
			RefuseReqLocGrid.commonDeleteRow();
			return false;
		}
		if (isEmpty(Rows)) {
			$UI.msg('alert', 'û��ѡ�е���Ϣ!');
			return;
		}
		$UI.confirm('ȷ��Ҫɾ����?', '', '', function() {
			$.cm({
				ClassName: 'web.DHCSTMHUI.RefuseReqLoc',
				MethodName: 'Delete',
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					RefuseReqLocGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		});
	}
	function Defaut() {
		var DefaultData = {
			FrLoc: gLocObj
		};
		$UI.fillBlock('#Conditions', DefaultData);
	}
	function Clear() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(RefuseReqLocGrid);
	}
	Clear();
	Defaut();
	InitHosp();
};
$(init);