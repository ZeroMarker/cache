
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
			$UI.msg('alert', '截止日期不能小于开始日期!');
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
				$UI.msg('alert', '入库科室不可为空!');
				return;
			}
			var InitToLoc = $('#RequestedLoc').combobox('getValue');
			if (isEmpty(InitToLoc)) {
				$UI.msg('alert', '接收科室不可为空!');
				return;
			}
			if (RecLoc == InitToLoc) {
				$UI.msg('alert', '出库科室不允许与接收科室相同!');
				return;
			}
			var RecRowData = IngrMasterGrid.getSelections();
			if (isEmpty(RecRowData)) {
				$UI.msg('alert', '请选择需要处理的入库单!');
				return;
			}
			var InitScg = RecRowData[0]['StkGrpId'];
			var HvFlag = RecRowData[0]['HvFlag'];
			var count = RecRowData.length;
			for (var i = 0; i < count; i++) {
				var Scg = RecRowData[i]['StkGrpId'];
				var Hv = RecRowData[i]['HvFlag'];
				if (InitScg != Scg) {
					$UI.msg('alert', '不同类组不能同时制单!');
					return;
				}
				if (HvFlag != Hv) {
					$UI.msg('alert', '高值和非高值不能同时制单!');
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
				$UI.msg('alert', '没有对应的明细数据!');
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
					Common_AddTab('出库', UrlStr);
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
			title: '入库单号',
			field: 'IngrNo',
			width: 180,
			align: 'left',
			sortable: false
		}, {
			title: '请求部门',
			field: 'ReqLoc',
			width: 180,
			align: 'left',
			sortable: true
		}, {
			title: '供给部门',
			field: 'RecLoc',
			width: 180,
			align: 'left',
			sortable: true
		}, {
			title: '入库日期',
			field: 'CreateDate',
			width: 100,
			align: 'center',
			sortable: true
		}, {
			title: '供应商',
			field: 'Vendor',
			width: 180,
			align: 'left',
			sortable: true
		}, {
			title: '入库人',
			field: 'CreateUser',
			width: 120,
			align: 'left',
			sortable: true
		}, {
			title: '转移状态',
			field: 'Status',
			width: 100,
			align: 'left',
			sortable: true
		}, {
			title: '类组',
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
			title: '入库明细id',
			field: 'Ingri',
			width: 100,
			align: 'left',
			sortable: true,
			saveCol: true,
			hidden: true
		}, {
			title: '物资RowId',
			field: 'IncId',
			width: 80,
			align: 'left',
			sortable: true,
			hidden: true
		}, {
			title: '物资代码',
			field: 'IncCode',
			width: 80,
			align: 'left',
			sortable: true
		}, {
			title: '物资名称',
			field: 'IncDesc',
			width: 230,
			align: 'left',
			sortable: true
		}, {
			title: '规格',
			field: 'Spec',
			width: 80,
			align: 'left'
		}, {
			title: '批次RowId',
			field: 'Inclb',
			width: 180,
			align: 'left',
			saveCol: true,
			sortable: true,
			hidden: true
		}, {
			title: '批号~效期',
			field: 'BatExp',
			width: 150,
			align: 'left',
			sortable: true
		}, {
			title: '高值标志',
			field: 'HVFlag',
			width: 80,
			align: 'center',
			sortable: true,
			hidden: true
		}, {
			title: '高值条码',
			field: 'HVBarCode',
			width: 100,
			align: 'left',
			saveCol: true,
			sortable: true
		}, {
			title: '批次库存',
			field: 'StkQty',
			width: 90,
			align: 'right',
			sortable: true
		}, {
			title: '转移数量',
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
			title: '转移单位',
			field: 'UomDesc',
			width: 100,
			align: 'left',
			sortable: true
		}, {
			title: '进价',
			field: 'Rp',
			width: 80,
			align: 'right',
			sortable: true
		}, {
			title: '售价',
			field: 'Sp',
			width: 80,
			saveCol: true,
			align: 'right',
			sortable: true
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 100,
			align: 'right',
			summaryType: 'sum',
			sortable: true
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width: 100,
			align: 'right',
			summaryType: 'sum',
			sortable: true
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 180,
			align: 'left',
			sortable: true
		}, {
			title: '占用数量',
			field: 'DirtyQty',
			width: 80,
			align: 'right',
			sortable: true
		}, {
			title: '可用数量',
			field: 'AvaQty',
			width: 80,
			align: 'right',
			sortable: true
		}, {
			title: '转换率',
			field: 'ConFacPur',
			width: 80,
			align: 'left',
			sortable: true,
			hidden: true
		}, {
			title: '基本单位',
			field: 'BUomId',
			width: 80,
			align: 'left',
			sortable: true,
			hidden: true
		}, {
			title: '库存转移单位',
			field: 'UomId',
			width: 80,
			align: 'left',
			sortable: true,
			saveCol: true,
			hidden: true
		}, {
			title: '已转移数量',
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