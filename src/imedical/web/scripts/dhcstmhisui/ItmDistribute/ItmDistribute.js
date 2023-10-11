var NeedDispGrid = '';
var init = function() {
	var LocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	$HUI.combobox('#AdmLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.combobox('#CardType', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCardType&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function() { // 数据加载完毕事件
			var data = $('#CardType').combobox('getData');
			var Default = '';
			if (data.length > 0) {
				for (i = 0; i <= data.length; i++) {
					Default = data[i].Default;
					if (Default == 'Y') {
						$('#CardType').combobox('select', data[i].RowId);
						return;
					}
				}
			}
		},
		onSelect: function(record) {
			
		}
	});
	
	var HandlerParams = function() {
		var Obj = { StkGrpRowId: '', StkGrpType: 'M', Locdr: gLocId };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	
	$('#PatNo').bind('keydown', function(event) {
		if (event.keyCode == 13) {
			var PatNo = $(this).val();
			if (isEmpty(PatNo)) {
				$UI.msg('alert', '请输入登记号!');
				return false;
			}
			try {
				var patinfostr = tkMakeServerCall('web.DHCSTMHUI.HVMatOrdItm', 'Pa', PatNo);
				var patinfoarr = patinfostr.split('^');
				var newPaAdmNo = patinfoarr[0];
				$('#PatNo').val(newPaAdmNo);
			} catch (e) {}
		}
	});
	
	$('#CardNo').bind('keydown', function(event) {
		if (event.keyCode == 13) {
			var CardType = $('#CardType').combobox('getValue');
			BtnReadCardHandler(CardType, 'CardNo', 'PatNo');
		}
	});
	
	$UI.linkbutton('#ReadCardBT', {
		onClick: function() {
			var CardType = $('#CardType').combobox('getValue');
			BtnReadCardHandler(CardType, 'CardNo', 'PatNo');
		}
	});
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		$UI.clear(NeedDispGrid);
		$UI.clear(DispMainGrid);
		$UI.clear(DispDetailGrid);
		var ParamsObj = $UI.loopBlock('#MainConditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (isEmpty(StartDate)) {
			$UI.msg('alert', '开始日期不能为空!');
			return;
		}
		if (isEmpty(EndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		if (compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '截止日期不能小于开始日期!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		NeedDispGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCMatDisp',
			QueryName: 'QueryNeedDisp',
			query2JsonStrict: 1,
			Params: Params
		});
		DispMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCMatDisp',
			QueryName: 'QueryMatDisp',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	function DefaultClear() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(DispDetailGrid);
		$UI.clear(DispMainGrid);
		Default();
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			DefaultClear();
		}
	});
	
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var DispFlag = $HUI.checkbox('#DispFlag').getValue();
			var RowsData = DispMainGrid.getSelections();
			if (RowsData.length == 0) {
				$UI.msg('alert', '请选择待发放就诊信息！');
				return false;
			}
			for (var i = 0; i < RowsData.length; i++) {
				var Adm = RowsData[i].Adm;
				var PrtId = RowsData[i].PrtId;
				var DispId = RowsData[i].DispId;
				var AdmStr = Adm + '^' + PrtId + '^' + DispFlag;
				if (!isEmpty(DispId)) {
					AdmStr = '';
				}
				PrintDisp(gLocId, gUserId, DispId, AdmStr);
			}
		}
	});
	
	$UI.linkbutton('#DispBT', {
		onClick: function() {
			if (CheckBeforeDisp()) {
				Distribute();
			}
		}
	});
	
	function CheckBeforeDisp() {
		if (!DispDetailGrid.endEditing()) {
			return false;
		}
		var DispFlag = $HUI.checkbox('#DispFlag').getValue();
		if (DispFlag == true) {
			$UI.msg('alert', '已发放！');
			return false;
		}
		var RowsData = DispMainGrid.getSelections();
		if (RowsData.length == 0) {
			$UI.msg('alert', '请选择待发放就诊信息！');
			return false;
		}
		var DetailRowsData = DispDetailGrid.getSelections();
		if (DetailRowsData.length == 0) {
			$UI.msg('alert', '请选择待发放材料信息！');
			return false;
		}
		for (var i = 0; i < DetailRowsData.length; i++) {
			var DispFlag = DetailRowsData[i].DispFlag;
			var InciDesc = DetailRowsData[i].InciDesc;
			if (DispFlag == 1) {
				$UI.msg('alert', InciDesc + '已经发放!');
				return false;
			}
			var HvFlag = DetailRowsData[i].HvFlag;
			if (HvFlag == 'Y') {
				var Barcode = DetailRowsData[i].Barcode;
				var CheckBarcode = DetailRowsData[i].CheckBarcode;
				if (isEmpty(CheckBarcode)) {
					$UI.msg('alert', Barcode + '请扫描对应高值条码!');
					return false;
				} else if (CheckBarcode != Barcode) {
					$UI.msg('alert', Barcode + '高值条码不匹配!');
					return false;
				}
			}
		}
		return true;
	}
	
	function Distribute() {
		var DetailRowsData = DispDetailGrid.getSelections();
		var Main = JSON.stringify(sessionObj);
		var Detail = JSON.stringify(DetailRowsData);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCMatDisp',
			MethodName: 'jsMatDisp',
			Main: Main,
			Detail: Detail
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				var rowidStr = jsonData.rowid.toString();
				var DispIdStr = rowidStr.split(',');
				for (var i = 0; i < DispIdStr.length; i++) {
					var DispId = DispIdStr[i];
					PrintDisp(gLocId, gUserId, DispId, '');
				}
				$('#PatNo').val('');
				$('#CardNo').val('');
				$('#PatNo').focus();
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	/* --Grid--*/
	// /发放列表
	var DispMainGridCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'Adm',
			field: 'Adm',
			width: 60,
			hidden: true
		}, {
			title: 'DispId',
			field: 'DispId',
			width: 60,
			hidden: true
		}, {
			title: '发放状态',
			field: 'DispFlag',
			width: 80,
			formatter: DispFlagFormatter
		}, {
			title: '病人id',
			field: 'PatId',
			width: 80,
			hidden: true
		}, {
			title: '姓名',
			field: 'PatName',
			width: 80
		}, {
			title: '登记号',
			field: 'PatNo',
			width: 100
		}, {
			title: '收据Id',
			field: 'PrtId',
			width: 100,
			hidden: true
		}, {
			title: '收据号',
			field: 'PrtCode',
			width: 100
		}, {
			title: '收费日期',
			field: 'PrtDate',
			width: 80
		}, {
			title: '收费时间',
			field: 'PrtTime',
			width: 80
		}, {
			title: '收费金额',
			field: 'PrtAmt',
			width: 80,
			align: 'right',
			hidden: true
		}, {
			title: '性别',
			field: 'PatSex',
			width: 50
		}, {
			title: '年龄',
			field: 'PatOld',
			width: 50
		}, {
			title: '电话',
			field: 'PatTel',
			width: 100
		}, {
			title: '科室',
			field: 'PatLoc',
			width: 100
		}, {
			title: '发放日期',
			field: 'DspDate',
			width: 100
		}
	]];

	var DispMainGrid = $UI.datagrid('#DispMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCMatDisp',
			QueryName: 'QueryMatDisp',
			query2JsonStrict: 1
		},
		showBar: true,
		selectOnCheck: true,
		checkOnSelect: true,
		singleSelect: false,
		columns: DispMainGridCm,
		onCheck: function(index, row) {
			$UI.clear(DispDetailGrid);
			var Rows = DispMainGrid.getSelectedData();
			if (!isEmpty(Rows)) {
				var tmpPatId = '';
				for (var i = 0; i < Rows.length; i++) {
					var PatId = Rows[i].PatId;
					if ((tmpPatId != '') && (tmpPatId != PatId)) {
						$UI.msg('alert', '请选择同一个病人进行发放!');
						return;
					}
					if (tmpPatId == '') { tmpPatId = PatId; }
				}
				var Params = JSON.stringify(Rows);
				var MainObj = $UI.loopBlock('MainConditions');
				var Others = JSON.stringify(jQuery.extend(true, MainObj, sessionObj));
				DispDetailGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCMatDisp',
					QueryName: 'QueryMatDispDetail',
					query2JsonStrict: 1,
					Params: Params,
					Others: Others,
					rows: 99999
				});
			}
		},
		onUncheck: function(index, Row) {
			$UI.clear(DispDetailGrid);
			var Rows = DispMainGrid.getSelectedData();
			if (!isEmpty(Rows)) {
				var Params = JSON.stringify(Rows);
				var MainObj = $UI.loopBlock('MainConditions');
				var Others = JSON.stringify(jQuery.extend(true, MainObj, sessionObj));
				DispDetailGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCMatDisp',
					QueryName: 'QueryMatDispDetail',
					query2JsonStrict: 1,
					Params: Params,
					Others: Others,
					rows: 99999
				});
			}
		},
		onCheckAll: function(rows) {
			$UI.clear(DispDetailGrid);
			var Rows = DispMainGrid.getSelectedData();
			if (!isEmpty(Rows)) {
				var tmpPatId = '';
				for (var i = 0; i < Rows.length; i++) {
					var PatId = Rows[i].PatId;
					if ((tmpPatId != '') && (tmpPatId != PatId)) {
						$UI.msg('alert', '请选择同一个病人进行发放!');
						return;
					}
					if (tmpPatId == '') { tmpPatId = PatId; }
				}
				var Params = JSON.stringify(Rows);
				var MainObj = $UI.loopBlock('MainConditions');
				var Others = JSON.stringify(jQuery.extend(true, MainObj, sessionObj));
				DispDetailGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCMatDisp',
					QueryName: 'QueryMatDispDetail',
					query2JsonStrict: 1,
					Params: Params,
					Others: Others,
					rows: 99999
				});
			}
		},
		onUncheckAll: function(rows) {
			$UI.clear(DispDetailGrid);
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				DispMainGrid.selectRow(0);
			}
		}
	});
	
	// /发放列表明细
	var DispDetailGridCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'Adm',
			field: 'Adm',
			width: 60,
			hidden: true
		}, {
			title: 'DispItmId',
			field: 'DispItmId',
			width: 60,
			hidden: true
		}, {
			title: '医嘱明细id',
			field: 'Oeori',
			width: 80,
			hidden: true
		}, {
			title: '库存项id',
			field: 'InciId',
			width: 100,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 100
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 150
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '数量',
			field: 'Qty',
			width: 80,
			align: 'right'
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 80
		}, {
			title: '单价',
			field: 'Sp',
			width: 80,
			align: 'right'
		}, {
			title: '金额',
			field: 'SpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '医嘱状态',
			field: 'OeoriFlag',
			width: 80,
			hidden: true
		}, {
			title: '医师',
			field: 'OrdUserName',
			width: 80,
			hidden: true
		}, {
			title: '货位',
			field: 'StkBin',
			width: 100
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 100
		}, {
			title: '可用库存',
			field: 'AvaQty',
			width: 80,
			align: 'right'
		}, {
			title: '发放状态',
			field: 'DispFlag',
			width: 80,
			hidden: true
		}, {
			title: '高值标志',
			field: 'HvFlag',
			width: 80
		}, {
			title: '高值条码',
			field: 'Barcode',
			width: 200
		}, {
			title: '扫描条码',
			field: 'CheckBarcode',
			width: 200,
			editor: {
				type: 'validatebox',
				options: {
					
				}
			}
		}, {
			title: '医嘱状态',
			field: 'OeoriFlag',
			width: 80,
			hidden: true
		}, {
			title: '单位',
			field: 'UomId',
			width: 80,
			hidden: true
		}
	]];

	var DispDetailGrid = $UI.datagrid('#DispDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCMatDisp',
			QueryName: 'QueryMatDispDetail',
			query2JsonStrict: 1,
			rows: 99999
		},
		selectOnCheck: true,
		checkOnSelect: true,
		singleSelect: false,
		showBar: true,
		columns: DispDetailGridCm,
		pagination: false,
		onClickRow: function(index, row) {
			DispDetailGrid.commonClickRow(index, row);
		},
		onBeforeCellEdit: function(index, field) {
			var row = $(this).datagrid('getRows')[index];
			var HvFlag = row.HvFlag;
			var Barcode = row.Barcode;
			if (field == 'CheckBarcode') {
				if ((HvFlag != 'Y') || (isEmpty(Barcode))) {
					return false;
				}
			}
		},
		onBeginEdit: function(index, row) {
			var ed = $('#DispDetailGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var Editor = ed[i];
				if (Editor.field == 'CheckBarcode') {
					$(Editor.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var Barcode = row.Barcode;
							var CheckBarcode = $(this).val();
							if (isEmpty(CheckBarcode)) {
								$UI.msg('alert', '请扫描高值条码!');
								return false;
							} else if (Barcode != CheckBarcode) {
								$UI.msg('alert', '条码不匹配!');
								$(this).val('');
								$(this).focus();
								return false;
							} else {
								$UI.msg('alert', '条码匹配成功!');
							}
						}
					});
				}
			}
		}, onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				// 默认全选
				$('#DispDetailGrid').datagrid('selectAll');
			}
		}
	});

	// /待发放列表
	var NeedDispGridCm = [[
		{
			title: '病人id',
			field: 'PatId',
			width: 60,
			hidden: true
		}, {
			title: '叫号',
			field: 'tSendVoice',
			width: 60,
			align: 'center',
			allowExport: false,
			formatter: function(value, row, index) {
				return "<a href='#' onclick='SendMessToVoice(\"" + index + "\")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/big/ring.png' title='叫号' border='0'></a>";
			}
		}, {
			title: '姓名',
			field: 'PatName',
			width: 80
		}, {
			title: '登记号',
			field: 'PatNo',
			width: 105
		}
	]];
	NeedDispGrid = $UI.datagrid('#NeedDispGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCMatDisp',
			QueryName: 'QueryNeedDisp',
			query2JsonStrict: 1,
			Params: JSON.stringify(addSessionParams({ StartDate: DateFormatter(new Date()) })),
			rows: 99999
		},
		columns: NeedDispGridCm,
		pagination: false,
		onClickRow: function(index, row) {
			NeedDispGrid.commonClickRow(index, row);
		},
		onSelect: function(index, row) {
			
		},
		onLoadSuccess: function(data) {
			
		}
	});
	
	/* --设置初始值--*/
	var Default = function() {
		// /设置初始值 考虑使用配置
		var DefaultValue = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date())
		};
		$UI.fillBlock('#MainConditions', DefaultValue);
		$('#PatNo').focus();
	};
	Default();
	Query();
};
$(init);

// 叫号消息发送
function SendMessToVoice(index) {
	if (isEmpty(index)) {
		dhcphaMsgBox.alert('没有选中数据,不能叫号!');
		return;
	}
	var RowData = NeedDispGrid.getRows()[index];
	var PatNo = RowData.PatNo;
	var PatName = RowData.PatName;
	var ServerIp = ClientIPAddress;
	var DispUserId = gUserId;
	var Ret = tkMakeServerCall('web.DHCSTMHUI.Common.ServiceCommon', 'SendMessToVoice', PatNo, PatName, ServerIp, DispUserId);
}