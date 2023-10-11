
var init = function() {
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		$UI.clear(IngrDetailGrid);
		$UI.clear(IngrMasterGrid);
		var ParamsObj = $UI.loopBlock('Conditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if ((!isEmpty(StartDate)) && (!isEmpty(EndDate)) && compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���С�ڿ�ʼ����!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		IngrMasterGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfAuxByRec',
			QueryName: 'QueryImportForTrans',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clear(IngrDetailGrid);
			$UI.clear(IngrMasterGrid);
			$UI.clearBlock('#Conditions');
			SetDefaValues();
		}
	});
	
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var RecLoc = $('#RecLoc').combobox('getValue');
			if (isEmpty(RecLoc)) {
				$UI.msg('alert', '�����Ҳ���Ϊ��!');
				return;
			}
			var InitToLoc = $('#RequestedLoc').combobox('getValue');
			if (isEmpty(InitToLoc)) {
				$UI.msg('alert', '���տ��Ҳ���Ϊ��!');
				return;
			}
			if (RecLoc == InitToLoc) {
				$UI.msg('alert', '������Ҳ���������տ�����ͬ!');
				return;
			}
			var RecRowData = IngrMasterGrid.getSelections();
			if (isEmpty(RecRowData)) {
				$UI.msg('alert', '��ѡ����Ҫ�������ⵥ!');
				return;
			}
			var InitScg = RecRowData[0]['StkGrpId'];
			var HvFlag = RecRowData[0]['HvFlag'];
			var count = RecRowData.length;
			for (var i = 0; i < count; i++) {
				var Scg = RecRowData[i]['StkGrpId'];
				var Hv = RecRowData[i]['HvFlag'];
				if (InitScg != Scg) {
					$UI.msg('alert', '��ͬ���鲻��ͬʱ�Ƶ�!');
					return;
				}
				if (HvFlag != Hv) {
					$UI.msg('alert', '��ֵ�ͷǸ�ֵ����ͬʱ�Ƶ�!');
					return;
				}
			}
			var InitIngr = RecRowData[0]['RowId'];
			var OperateTypeInfo = GetInitTypeDefa();
			var OperateTypeId = OperateTypeInfo.split('^')[0];
			var MainObj = { InitFrLoc: RecLoc, InitToLoc: InitToLoc, InitComp: 'N', InitState: '10', InitUser: gUserId,
				InitScg: InitScg, InitIngr: InitIngr, OperateType: OperateTypeId };
			var Main = JSON.stringify(addSessionParams(MainObj));
			var Detail = IngrDetailGrid.getRowsData();
			if (Detail.length <= 0) {
				$UI.msg('alert', 'û�ж�Ӧ����ϸ����!');
				return;
			}
			if (Detail === false) {
				return;
			}
			Detail = JSON.stringify(Detail);
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
				MethodName: 'jsSave',
				Main: Main,
				Detail: Detail
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.clear(IngrDetailGrid);
					$UI.msg('success', jsonData.msg);
					var InitId = jsonData.rowid;
					var UrlStr;
					if (HvFlag == 'N') {
						UrlStr = 'dhcstmhui.dhcinistrf.csp?RowId=' + InitId;
					} else {
						UrlStr = 'dhcstmhui.dhcinistrfhv.csp?RowId=' + InitId;
					}
					Common_AddTab('����', UrlStr);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	var RecLoc = $HUI.combobox('#RecLoc', {
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({ Type: 'Login', Element: 'RecLoc' })),
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			if (CommParObj.ApcScg == 'L') {
				$('#Vendor').combobox('clear');
				var Params = JSON.stringify(addSessionParams({ APCType: 'M', LocId: LocId }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
				$('#Vendor').combobox('reload',url);
			}
			Query();
		}
	});
	$('#RecLoc').combobox('setValue', session['LOGON.CTLOCID']);
	
	$HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='
			+ JSON.stringify(addSessionParams({ APCType: 'M' })),
		valueField: 'RowId',
		textField: 'Description'
	});
	
	$HUI.checkbox('#VirtualFlag', {
		onCheckChange: function(e, value) {
			if (value) {
				var RecLoc = $('#RecLoc').combobox('getValue');
				var Info = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon', 'GetMainLoc', RecLoc);
				var InfoArr = Info.split('^');
				var VituralLoc = InfoArr[0], VituralLocDesc = InfoArr[1];
				AddComboData($('#RecLoc'), VituralLoc, VituralLocDesc);
				$('#RecLoc').combobox('setValue', VituralLoc);
				Query();
			} else {
				$('#RecLoc').combobox('setValue', gLocId);
				Query();
			}
		}
	});
	
	$HUI.combobox('#RequestedLoc', {
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({ Type: 'All', Element: 'RequestedLoc' })),
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var IngrMasterCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'IngrId',
			field: 'RowId',
			width: 100,
			align: 'left',
			sortable: true,
			saveCol: true,
			hidden: true
		}, {
			title: '��ⵥ��',
			field: 'IngrNo',
			width: 180,
			align: 'left',
			sortable: false
		}, {
			title: '������',
			field: 'ReqLoc',
			width: 180,
			align: 'left',
			sortable: true
		}, {
			title: '��������',
			field: 'RecLoc',
			width: 180,
			align: 'left',
			sortable: true
		}, {
			title: '�������',
			field: 'CreateDate',
			width: 100,
			align: 'center',
			sortable: true
		}, {
			title: '��Ӧ��',
			field: 'Vendor',
			width: 180,
			align: 'left',
			sortable: true
		}, {
			title: '�����',
			field: 'CreateUser',
			width: 120,
			align: 'left',
			sortable: true
		}, {
			title: 'ת��״̬',
			field: 'Status',
			width: 100,
			align: 'left',
			sortable: true
		}, {
			title: '����',
			field: 'StkGrpDesc',
			width: 150,
			align: 'left',
			sortable: true
		}
	]];
	
	var IngrMasterGrid = $UI.datagrid('#IngrMasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfAuxByRec',
			QueryName: 'QueryImportForTrans',
			query2JsonStrict: 1
		},
		columns: IngrMasterCm,
		showBar: true,
		remoteSort: false,
		singleSelect: false,
		onSelectChangeFn: function(index, row) {
			var RecRowData = IngrMasterGrid.getSelections();
			var count = RecRowData.length;
			var IngrIdStr = '';
			for (var i = 0; i < count; i++) {
				var InitIngr = RecRowData[i]['RowId'];
				if (IngrIdStr == '') {
					IngrIdStr = InitIngr;
				} else {
					IngrIdStr = IngrIdStr + ',' + InitIngr;
				}
			}
			if (isEmpty(IngrIdStr)) {
				return;
			}
			IngrDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrfAuxByRec',
				MethodName: 'QueryImportDetailForTrans',
				Parref: IngrIdStr,
				rows: 99999
			});
		},
		onLoadSuccess: function(data) {
			if ((data.rows.length > 0) && (CommParObj.IfSelFirstRow == 'Y')) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	
	var IngrDetailCm = [[
		{
			title: '�����ϸid',
			field: 'Ingri',
			width: 100,
			align: 'left',
			sortable: true,
			saveCol: true,
			hidden: true
		}, {
			title: '����RowId',
			field: 'IncId',
			width: 80,
			align: 'left',
			sortable: true,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'IncCode',
			width: 80,
			align: 'left',
			sortable: true
		}, {
			title: '��������',
			field: 'IncDesc',
			width: 230,
			align: 'left',
			sortable: true
		}, {
			title: '���',
			field: 'Spec',
			width: 80,
			align: 'left'
		}, {
			title: '����RowId',
			field: 'Inclb',
			width: 180,
			align: 'left',
			saveCol: true,
			sortable: true,
			hidden: true
		}, {
			title: '����~Ч��',
			field: 'BatExp',
			width: 150,
			align: 'left',
			sortable: true
		}, {
			title: '��ֵ��־',
			field: 'HVFlag',
			width: 80,
			align: 'center',
			sortable: true,
			hidden: true
		}, {
			title: '��ֵ����',
			field: 'HVBarCode',
			width: 100,
			align: 'left',
			saveCol: true,
			sortable: true
		}, {
			title: '���ο��',
			field: 'StkQty',
			width: 90,
			align: 'right',
			sortable: true
		}, {
			title: 'ת������',
			field: 'Qty',
			width: 80,
			align: 'right',
			saveCol: true,
			sortable: true,
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: GetFmtNum('FmtQTY')
				}
			}
		}, {
			title: 'ת�Ƶ�λ',
			field: 'UomDesc',
			width: 100,
			align: 'left',
			sortable: true
		}, {
			title: '����',
			field: 'Rp',
			width: 80,
			align: 'right',
			sortable: true
		}, {
			title: '�ۼ�',
			field: 'Sp',
			width: 80,
			saveCol: true,
			align: 'right',
			sortable: true
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 100,
			align: 'right',
			summaryType: 'sum',
			sortable: true
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 100,
			align: 'right',
			summaryType: 'sum',
			sortable: true
		}, {
			title: '��������',
			field: 'Manf',
			width: 180,
			align: 'left',
			sortable: true
		}, {
			title: 'ռ������',
			field: 'DirtyQty',
			width: 80,
			align: 'right',
			sortable: true
		}, {
			title: '��������',
			field: 'AvaQty',
			width: 80,
			align: 'right',
			sortable: true
		}, {
			title: 'ת����',
			field: 'ConFacPur',
			width: 80,
			align: 'left',
			sortable: true,
			hidden: true
		}, {
			title: '������λ',
			field: 'BUomId',
			width: 80,
			align: 'left',
			sortable: true,
			hidden: true
		}, {
			title: '���ת�Ƶ�λ',
			field: 'UomId',
			width: 80,
			align: 'left',
			sortable: true,
			saveCol: true,
			hidden: true
		}, {
			title: '��ת������',
			field: 'InitQty',
			width: 80,
			align: 'right',
			sortable: true
		}
	]];
	
	var IngrDetailGrid = $UI.datagrid('#IngrDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfAuxByRec',
			MethodName: 'QueryImportDetailForTrans',
			rows: 99999
		},
		pagination: false,
		columns: IngrDetailCm,
		showBar: true,
		remoteSort: false
	});
	
	function SetDefaValues() {
		$('#StartDate').datebox('setValue', DefaultStDate());
		$('#EndDate').datebox('setValue', DefaultEdDate());
		$('#RecLoc').combobox('setValue', session['LOGON.CTLOCID']);
		if (ItmTrackParamObj.AutoVirFlag == 'Y') {
			$('#VirtualFlag').checkbox('setValue', true);
		} else {
			$('#VirtualFlag').checkbox('setValue', false);
		}
	}
	SetDefaValues();
	Query();
};
$(init);