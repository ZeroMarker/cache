/* 高值跟踪*/
var init = function() {
	var Clear = function() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(BarMainGrid);
		$UI.clear(BarDetailGrid);
		// /设置初始值 考虑使用配置
		var DefaultData = {
			StartDate: TrackDefaultStDate(),
			EndDate: TrackDefaultEdDate(),
			FRecLoc: gLocObj,
			AuditFlag: 'N',
			FStatusBox: 'Y'
		};
		$UI.fillBlock('#FindConditions', DefaultData);
	};
	var FRecLocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	var FRecLocBox = $HUI.combobox('#LocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FRecLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var VendorBoxParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	$HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorBoxParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	$('#Status').simplecombobox({
		data: [
			{ RowId: 'Reg', Description: '注册' },
			{ RowId: 'Enable', Description: '可用' },
			{ RowId: 'Used', Description: '已用' },
			{ RowId: 'Else', Description: '其他' }
		]
	});
	$('#wardno').bind('keydown', function(event) {
		if (event.keyCode == 13) {
			var PapmiNo = $(this).val();
			if (isEmpty(PapmiNo)) {
				$UI.msg('alert', '请输入登记号!');
				return false;
			}
			try {
				var patinfostr = tkMakeServerCall('web.DHCSTMHUI.HVMatOrdItm', 'Pa', PapmiNo);
				var patinfoarr = patinfostr.split('^');
				var newPaAdmNo = patinfoarr[0];
				var patinfo = patinfoarr[1] + ',' + patinfoarr[2];
				$('#wardno').val(newPaAdmNo);
			} catch (e) {}
		}
	});
	$('#BarCode').bind('keydown', function(event) {
		if (event.keyCode == 13) {
			var BarCode = $(this).val();
			if (isEmpty(BarCode)) {
				$UI.msg('alert', '请输入条码信息!');
				return false;
			}
			Query();
		}
	});
	$('#OrgianlBarCode').bind('keydown', function(event) {
		if (event.keyCode == 13) {
			var OrgianlBarCode = $(this).val();
			if (isEmpty(OrgianlBarCode)) {
				$UI.msg('alert', '请输入条码信息!');
				return false;
			}
			Query();
		}
	});
	var HandlerParams = function() {
		var Obj = { Hv: 'Y', StkGrpType: 'M' };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#InciId'));
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('#FindConditions');
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
		$UI.clear(BarDetailGrid);
		$UI.clear(BarMainGrid);
		BarMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'Query',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	// 打印按钮对应方法
	var PrintBtn = $('#Print').menubutton({ menu: '#mm-Print' });
	$(PrintBtn.menubutton('options').menu).menu({
		onClick: function(item) {
			var BtnName = item.name;		// div定义了name属性
			if (BtnName == 'PrintBarCode') {
				var rowsData = BarMainGrid.getSelections();
				if (rowsData.length <= 0) {
					$UI.msg('alert', '没有要打印的高值条码!');
					return;
				}
				var count = rowsData.length;
				for (var rowIndex = 0; rowIndex < count; rowIndex++) {
					var row = rowsData[rowIndex];
					var BarCode = row.BarCode;
					PrintBarcode(BarCode, 1);
				}
			} else if (BtnName == 'PrintBarCode2') {
				var rowsData = BarMainGrid.getSelections();
				if (rowsData.length <= 0) {
					$UI.msg('alert', '没有要打印的高值条码!');
					return;
				}
				var count = rowsData.length;
				for (var rowIndex = 0; rowIndex < count; rowIndex++) {
					var row = rowsData[rowIndex];
					var BarCode = row.BarCode;
					PrintBarcode(BarCode, 2);
				}
			} else if (BtnName == 'PrintPage') {
				var rowsData = BarMainGrid.getRows();
				if (rowsData.length <= 0) {
					$UI.msg('alert', '没有要打印的高值条码!');
					return;
				}
				var count = rowsData.length;
				for (var rowIndex = 0; rowIndex < count; rowIndex++) {
					var row = rowsData[rowIndex];
					var BarCode = row.BarCode;
					PrintBarcode(BarCode, 1);
				}
			} else if (BtnName == 'PrintPage2') {
				var rowsData = BarMainGrid.getRows();
				if (rowsData.length <= 0) {
					$UI.msg('alert', '没有要打印的高值条码!');
					return;
				}
				var count = rowsData.length;
				for (var rowIndex = 0; rowIndex < count; rowIndex++) {
					var row = rowsData[rowIndex];
					var BarCode = row.BarCode;
					PrintBarcode(BarCode, 2);
				}
			}
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var rowsData = BarMainGrid.getSelections();
			if (isEmpty(rowsData)) {
				$UI.msg('alert', '请选择需要打印的高值信息!');
				return;
			}
			for (var i = 0, Len = rowsData.length; i < Len; i++) {
				var row = rowsData[i];
				var TrackId = row['RowId'];
				var RaqName = 'DHCSTM_HUI_ItmTrack_Common.raq';
				var HospDesc = session['LOGON.HOSPDESC'];
				var fileName = '{' + RaqName + '(TrackId=' + TrackId + ';HospDesc=' + HospDesc + ')}';
				if (ItmTrackParamObj.IndirPrint != 'N') {
					var transfileName = TranslateRQStr(fileName);
					DHCCPM_RQPrint(transfileName);
				} else {
					DHCCPM_RQDirectPrint(fileName);
				}
			}
		}
	});
	
	var BarMainCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: 'InciId',
			field: 'InciId',
			width: 120,
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
			width: 90
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			width: 120,
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: '条码',
			field: 'BarCode',
			width: 200
		}, {
			title: '自带条码',
			field: 'OriginalCode',
			width: 200,
			hidden: hiddenOrigiBarCode
		}, {
			title: '批号~效期',
			field: 'BatExp',
			width: 150,
			hidden: true
		}, {
			title: '批号',
			field: 'BatNo',
			width: 100
		}, {
			title: '效期',
			field: 'ExpDate',
			width: 100
		}, {
			title: '进价',
			field: 'Rp',
			width: 60
		}, {
			title: '状态',
			field: 'Status',
			formatter: StatusFormatter,
			width: 70
		}, {
			title: '当前位置',
			field: 'CurrentLoc',
			width: 150
		}, {
			title: '打印标记',
			field: 'PrintFlag',
			formatter: BoolFormatter,
			align: 'center',
			width: 80
		}, {
			title: 'Incib',
			field: 'Incib',
			width: 90,
			hidden: true
		}, {
			title: 'Inclb',
			field: 'Inclb',
			width: 100,
			hidden: true
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 80
		}, {
			title: '供应商',
			field: 'VendorDesc',
			width: 160
		}, {
			title: '生产厂家',
			field: 'ManfDesc',
			width: 160
		}, {
			title: '条码生成(注册)时间',
			field: 'DateTime',
			width: 160
		}, {
			title: '操作人',
			field: 'DhcitUser',
			width: 100
		}, {
			title: '自带批次码',
			field: 'BatchCode',
			width: 200
		}, {
			title: '病人信息',
			field: 'UsedPatInfo',
			width: 160
		}, {
			title: '使用时间',
			field: 'UsedDateTime',
			width: 160
		}
	]];
	var BarMainGrid = $UI.datagrid('#BarMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'Query',
			query2JsonStrict: 1
		},
		columns: BarMainCm,
		showBar: true,
		checkOnSelect: false,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				BarMainGrid.selectRow(0);
			}
		},
		onSelect: function(index, row) {
			BarDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCItmTrack',
				QueryName: 'QueryItmTrackItem',
				query2JsonStrict: 1,
				Parref: row['RowId'],
				rows: 99999
			});
		},
		onDblClickRow: function(index, row) {
			var RowId = row['RowId'];
			if (isEmpty(RowId)) {
				return;
			}
			var BarCode = row['BarCode'];
			var InciDesc = row['InciDesc'];
			var InfoStr = BarCode + ' : ' + InciDesc;
			BarCodePackItm(RowId, InfoStr);
		}
	});
	
	var BarDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '类型',
			field: 'Type',
			formatter: TypeRenderer,
			width: 120
		}, {
			title: 'Pointer',
			field: 'Pointer',
			width: 80,
			hidden: true
		}, {
			title: '台账标记',
			field: 'IntrFlag',
			formatter: BoolFormatter,
			align: 'center',
			width: 80
		}, {
			title: '台账数量',
			field: 'IntrQty',
			align: 'right',
			width: 80
		}, {
			title: '处理号',
			field: 'OperNo',
			width: 150
		}, {
			title: '业务发生日期',
			field: 'Date',
			hidden: true,
			width: 120
		}, {
			title: '业务发生时间',
			field: 'Time',
			formatter: function(value, row, index) {
				return row['Date'] + ' ' + value;
			},
			width: 160
		}, {
			title: '业务操作人',
			field: 'User',
			width: 80
		}, {
			title: '位置信息',
			field: 'OperOrg',
			width: 300
		}
	]];
	
	var BarDetailGrid = $UI.datagrid('#BarDetailGrid', {
		height: gGridHeight,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'QueryItmTrackItem',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		columns: BarDetailCm,
		showBar: true,
		fitColumns: true
	});
	
	Clear();
};
$(init);