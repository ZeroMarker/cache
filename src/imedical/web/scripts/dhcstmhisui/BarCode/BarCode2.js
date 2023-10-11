/* 高值条码重新生成*/
var init = function() {
	var Clear = function() {
		$UI.clearBlock('#Conditions');
		$UI.clearBlock('#TB');
		$UI.clear(BarCodeGrid);
		var DefaultData = {
			StartDate: TrackDefaultStDate(),
			EndDate: TrackDefaultEdDate()
		};
		$UI.fillBlock('#Conditions', DefaultData);
	};
	var HandlerParams = function() {
		var Obj = { Hv: 'Y', StkGrpType: 'M' };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#inci'));
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var rowsData = BarCodeGrid.getSelections();
			if (isEmpty(rowsData)) {
				$UI.msg('alert', '请选择需要打印的条码!');
				return;
			}
			for (var i = 0, Len = rowsData.length; i < Len; i++) {
				var BarCode = rowsData[i]['BarCode'];
				PrintBarcode(BarCode, 1);
			}
		}
	});
	$UI.linkbutton('#PrintAllBT', {
		onClick: function() {
			var rowsData = BarCodeGrid.getRows();
			if (rowsData.length <= 0) {
				return;
			}
			var count = rowsData.length;
			for (var rowIndex = 0; rowIndex < count; rowIndex++) {
				var row = rowsData[rowIndex];
				var BarCode = row.BarCode;
				PrintBarcode(BarCode, 1);
			}
		}
	});
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	
	function Query() {
		var ParamsObj = $UI.loopBlock('#Conditions');
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
		ParamsObj.BatchCodeFlag = 'N';
		var Params = JSON.stringify(ParamsObj);
		BarCodeGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'queryRegHVs',
			query2JsonStrict: 1,
			Params: Params,
			rows: 99999
		});
	}
	$('#OldBarCode').bind('keydown', function(event) {
		if (event.keyCode == '13') {
			if (isEmpty(OldBarCode)) {
				return;
			}
			try {
				SaveBarCode();
			} catch (e) {}
		}
	});
	$UI.linkbutton('#AddBT', {
		onClick: function() {
			SaveBarCode();
		}
	});
	function GetParamsObj() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		return ParamsObj;
	}
	function SaveBarCode() {
		var ParamsObj = $UI.loopBlock('#TB');
		if (isEmpty(ParamsObj.OldBarCode)) {
			$UI.msg('alert', '原始条码不能为空!');
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			MethodName: 'NewBarcode',
			Params: JSON.stringify(ParamsObj)
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				$('#BarCodeText').val(jsonData.keyValue.BarCode);
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	$UI.linkbutton('#DelBT', {
		onClick: function() {
			DeleteBarCode();
		}
	});
	
	function DeleteBarCode() {
		var RowsData = BarCodeGrid.getChecked();
		// 有效行数
		var count = 0;
		for (var i = 0; i < RowsData.length; i++) {
			var item = RowsData[i].RowId;
			if (!isEmpty(item)) {
				count++;
			}
		}
		if (RowsData.length <= 0 || count <= 0) {
			$UI.msg('alert', '请选择删除明细!');
			return false;
		}
		
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			MethodName: 'DeleteLabel',
			Params: JSON.stringify(RowsData)
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	var BarCodeCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '物资RowId',
			field: 'InciId',
			hidden: true,
			width: 60
		}, {
			title: '代码',
			field: 'InciCode',
			width: 100
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 100
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '数量',
			field: 'Qty',
			width: 50,
			align: 'right'
		}, {
			title: '条码',
			field: 'BarCode',
			width: 200
		}, {
			title: '自带码',
			field: 'OriginalCode',
			width: 200,
			hidden: hiddenOrigiBarCode
		}, {
			title: '进价',
			field: 'Rp',
			align: 'right',
			width: 100
		}, {
			title: 'Inpoi',
			field: 'Inpoi',
			hidden: 'true',
			width: 100
		}, {
			title: '批号',
			field: 'BatchNo',
			width: 100
		}, {
			title: '效期',
			field: 'ExpDate',
			width: 100
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			width: 100,
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: '生产日期',
			field: 'ProduceDate',
			width: 100
		}, {
			title: '单位dr',
			field: 'BUomId',
			width: 100,
			hidden: true
		}, {
			title: '单位',
			field: 'BUom',
			width: 100
		}, {
			title: '注册证号',
			field: 'CertNo',
			width: 100
		}, {
			title: '注册证效期',
			field: 'CertExpDate',
			width: 100
		}, {
			title: '供应商',
			field: 'VendorDesc',
			width: 120
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 100
		}
	]];
	
	var BarCodeGrid = $UI.datagrid('#BarCodeGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'queryRegHVs',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		toolbar: '#TB',
		columns: BarCodeCm,
		singleSelect: false,
		remoteSort: false
	});
	Clear();
};
$(init);