var init = function() {
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#MainConditions');
			var StartDate = ParamsObj.StartDate;
			var EndDate = ParamsObj.EndDate;
			if (isEmpty(ParamsObj.PoLoc)) {
				$UI.msg('alert', '订单科室不能为空!');
				return;
			}
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
			var Status = '';
			if ($HUI.checkbox('#AllImp').getValue() == true) { Status = Status + '2' + ','; }
			if ($HUI.checkbox('#PartImp').getValue() == true) { Status = Status + '1' + ','; }
			if ($HUI.checkbox('#NoImp').getValue() == true) { Status = Status + '0' + ','; }
			ParamsObj.Status = Status;
			ParamsObj.CompFlag = 'Y';
			ParamsObj.ApproveFlag = '';
			$UI.clear(PoDetailGrid);
			var Params = JSON.stringify(ParamsObj);
			PoMainGrid.load({
				ClassName: 'web.DHCSTMHUI.INPO',
				QueryName: 'QueryMain',
				query2JsonStrict: 1,
				Params: Params
			});
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			DefaultClear();
		}
	});
	$UI.linkbutton('#SendInPoBT', {
		onClick: function() {
			SendInPo();
		}
	});
	function DefaultClear() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(PoMainGrid);
		$UI.clear(PoDetailGrid);
		Default();
	}
	function UnSelect(RowIndex) {
		PoMainGrid.unselectRow(RowIndex);
	}
	function SendInPo() {
		var emflag = $HUI.combobox('#EmFlag').getValue();
		var Rows = PoMainGrid.getSelections();
		if (Rows.length <= 0) {
			$UI.msg('alert', '请选择要推送的订单!');
			return;
		}
		for (var i = 0, Len = Rows.length; i < Len; i++) {
			var RowData = Rows[i];
			var RowIndex = PoMainGrid.getRowIndex(RowData);
			var PoNo = RowData['PoNo'];
			var SendFlag = RowData['SendFlag'];			// Y:已发送, 其他:未发放
			var CancelFlag = RowData['CancelFlag'];		// Y:已拒绝, N:已确认
			if (CancelFlag == 'N') {
				$UI.msg('alert', '供应商已确认第' + (RowIndex + 1) + '行:' + PoNo + ', 请勿重复发送!');
				PoMainGrid.unselectRow(RowIndex);
			} else if (CancelFlag == 'Y') {
				$UI.msg('alert', '供应商已确认第' + (RowIndex + 1) + '行:' + PoNo + ', 请勿重复发送!');
				$UI.confirm('供应商已确认第' + (RowIndex + 1) + '行:' + PoNo + ', 请勿重复发送!', '', '', '', '', UnSelect);
			}
		}
		
		var Detail = PoMainGrid.getSelectedData();
		if (isEmpty(Detail)) {
			$UI.msg('alert', '没有需要发送的订单!');
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPO',
			MethodName: 'SendInPo',
			Detail: JSON.stringify(Detail),
			emflag: emflag
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', '推送成功!');
				PoMainGrid.commonReload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#ReminderBT', {
		onClick: function() {
			ReminderInPo();
		}
	});
	function ReminderInPo() {
		var Rows = PoMainGrid.getSelections();
		if (Rows.length <= 0) {
			$UI.msg('alert', '请选择要催促的订单!');
			return;
		}
		var Detail = PoMainGrid.getSelectedData();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPO',
			MethodName: 'ReminderInPo',
			Detail: JSON.stringify(Detail)
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', '催单成功!');
				PoMainGrid.commonReload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	$UI.linkbutton('#CancelInPoBT', {
		onClick: function() {
			CancelInPo();
		}
	});
	function CancelInPo() {
		var Rows = PoMainGrid.getSelections();
		if (Rows.length <= 0) {
			$UI.msg('alert', '请选择要撤销的订单!');
			return;
		}
		var Detail = PoMainGrid.getSelectedData();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPO',
			MethodName: 'CancelInPo',
			Detail: JSON.stringify(Detail)
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', '撤单成功!');
				PoMainGrid.commonReload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	$UI.linkbutton('#GetECSStateBT', {
		onClick: function() {
			GetOrdersState();
		}
	});
	function GetOrdersState() {
		var Rows = PoMainGrid.getSelections();
		if (Rows.length <= 0) {
			$UI.msg('alert', '请选择订单!');
			return;
		}
		var InpoIdStr = '';
		for (var i = 0, Len = Rows.length; i < Len; i++) {
			var RowId = Rows[i]['RowId'];
			if (InpoIdStr == '') {
				InpoIdStr = RowId;
			} else {
				InpoIdStr = InpoIdStr + '^' + RowId;
			}
		}
		var ParamsObj = {
			InpoIdStr: InpoIdStr,
			StartDate: '',
			EndDate: '',
			HospId: gHospId
		};
		var Params = JSON.stringify(ParamsObj);
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPO',
			MethodName: 'getOrdersState',
			Params: Params
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', '同步成功!');
				PoMainGrid.commonReload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	var SunPurPlan = CommParObj.SunPurPlan; // 参数设置 公共
	// /20221112 同步至阳光采购平台
	$UI.linkbutton('#SendOrderBT', {
		onClick: function() {
			if (isEmpty(SunPurPlan)) {
				$UI.msg('alert', '请配置采购平台信息!');
				return;
			}
			if (SunPurPlan == '四川省') {
				SCSendOrder();
			}
		}
	});
	function SCSendOrder() {
		var Rows = PoMainGrid.getSelections();
		if (Rows.length <= 0) {
			$UI.msg('alert', '请选择要同步的订单!');
			return;
		}
		var PoIdStr = '';
		for (var i = 0, Len = Rows.length; i < Len; i++) {
			var RowData = Rows[i];
			var RowIndex = PoMainGrid.getRowIndex(RowData);
			var PoNo = RowData['PoNo'];
			var PurPlanCodeId = RowData['PurPlanCodeId'];// 采购平台订单上传状态
			if (PurPlanCodeId !== '') {
				$UI.msg('alert', '上传的订单第' + (RowIndex + 1) + '行:' + PoNo + ', 请勿重复上传!');
				PoMainGrid.unselectRow(RowIndex);
			}
			var RowId = RowData['RowId'];
			if (PoIdStr == '') { PoIdStr = RowId; } else { PoIdStr = PoIdStr + '^' + RowId; }
		}
		if (isEmpty(PoIdStr)) {
			$UI.msg('alert', '请选择要同步的订单!');
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
			MethodName: 'JsSendInpoStr',
			PoIdStr: PoIdStr
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				var retinfo = jsonData.msg;
				var retarr = retinfo.split('@');
				var all = Number(retarr[0]) + Number(retarr[1]);
				var sucret = retarr[2];
				var failret = retarr[3];
				$UI.msg('alert', '共' + all + '条订单；成功：' + retarr[0] + '条；失败：' + retarr[1] + '条' + failret);
				PoMainGrid.commonReload();
			}
		});
	}
	$UI.linkbutton('#OrderQueryBT', {
		onClick: function() {
			var Row = PoMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要查询的订单!');
				return;
			}
			var PurPlanCodeId = Row.PurPlanCodeId;// 采购平台订单上传状态
			if (PurPlanCodeId == '') {
				$UI.msg('alert', '该订单未上传采购平台,没有需要查询的信息!');
				// return;   
			}
			var PoId = Row.RowId;
			if (isEmpty(SunPurPlan)) {
				$UI.msg('alert', '请配置采购平台信息!');
				return;
			}
			if (SunPurPlan == '四川省') {
				SCQueryPoDetailStatus(PoId);
			}
		}
	});
	$UI.linkbutton('#DistriQueryBT', {
		onClick: function() {
			var Row = PoMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要查询的订单!');
				return;
			}
			var PurPlanCodeId = Row.PurPlanCodeId;// 采购平台订单上传状态
			if (PurPlanCodeId == '') {
				$UI.msg('alert', '该订单未上传采购平台,没有需要查询的信息!');
				// return;   
			}
			var PoId = Row.RowId;
			if (isEmpty(SunPurPlan)) {
				$UI.msg('alert', '请配置采购平台信息!');
				return;
			}
			if (SunPurPlan == '四川省') {
				SCQueryPoDistrStatus(PoId);
			}
		}
	});
	// / 合同
	$UI.linkbutton('#ProConQueryBT', {
		onClick: function() {
			if (isEmpty(SunPurPlan)) {
				$UI.msg('alert', '请配置采购平台信息!');
				return;
			}
			if (SunPurPlan == '四川省') {
				SCQueryProContract();
			}
		}
	});
	// / 20221129 同步阳光采购平台 支付单
	$UI.linkbutton('#SendPayBT', {
		onClick: function() {
			if (isEmpty(SunPurPlan)) {
				$UI.msg('alert', '请配置采购平台信息!');
				return;
			}
			if (SunPurPlan == '四川省') {
				SCSendPay();
			}
		}
	});
	function SCSendPay() {
		var RowData = PoMainGrid.getSelections();
		var PayIdStr = '';
		for (var i = 0; i < RowData.length; i++) {
			var RowIndex = PoMainGrid.getRowIndex(RowData[i]);
			var PoStatus = RowData[i].PoStatus;
			var PoNo = RowData[i].PoNo;
			if (PoStatus == 0) {
				$UI.msg('alert', '订单单号:' + PoNo + '未入库!');
				PoMainGrid.unselectRow(RowIndex);
			}
			var RowId = RowData[i].RowId;
			if (PayIdStr == '') {
				PayIdStr = RowId;
			} else {
				PayIdStr = PayIdStr + '^' + RowId;
			}
		}
		if (isEmpty(PayIdStr)) {
			$UI.msg('alert', '请选择要同步的订单!');
			return false;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
			MethodName: 'JsSendInpoPayStr',
			PayIdStr: PayIdStr
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				var retinfo = jsonData.msg;
				var retarr = retinfo.split('@');
				var all = Number(retarr[0]) + Number(retarr[1]);
				var sucret = retarr[2];
				var failret = retarr[3];
				$UI.msg('alert', '共' + all + '条付款单；成功：' + retarr[0] + '条；失败：' + retarr[1] + '条' + failret);
			}
		});
	}
	// / 20221129 阳光采购平台支付单信息查询
	$UI.linkbutton('#QueryPayStatusBT', {
		onClick: function() {
			var Row = PoMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要查询的订单!');
				return;
			}
			var PoStatus = Row.PoStatus;
			var PoNo = Row.PoNo;
			if (PoStatus == 0) {
				$UI.msg('alert', '订单单号:' + PoNo + '未入库!');
				return;
			}
			var PayId = Row.RowId;
			
			if (isEmpty(SunPurPlan)) {
				$UI.msg('alert', '请配置采购平台信息!');
				return;
			}
			if (SunPurPlan == '四川省') {
				SCPayStatusQuery(PayId);
			}
		}
	});
	
	// / 阳光结束
	
	var PoLocBox = $HUI.combobox('#PoLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PoLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$HUI.combotree('#StkScg').setFilterByLoc(LocId);
			if (CommParObj.ApcScg == 'L') {
				VendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M', LocId: LocId }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
				VendorBox.reload(url);
			}
		}
	});
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var StkCatBox = $HUI.combobox('#StkCat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	$('#StkScg').combotree({
		onChange: function(newValue, oldValue) {
			StkCatBox.clear();
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId=' + newValue;
			StkCatBox.reload(url);
			if (CommParObj.ApcScg == 'S') {
				VendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M' }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params + '&ScgId=' + newValue ;
				VendorBox.reload(url);
			}
		}
	});
	$('#SendFlag').simplecombobox({
		data: [
			{ RowId: '', Description: '全部' },
			{ RowId: 'Y', Description: '已推送' },
			{ RowId: 'N', Description: '未推送' }
		]
	});
	$('#EmFlag').simplecombobox({
		data: [
			{ RowId: '0', Description: '普通' },
			{ RowId: '1', Description: '加急' },
			{ RowId: '2', Description: '特急' }
		]
	});
	
	$HUI.tabs('#DetailTabs', {
		onSelect: function(title, index) {
			var Row = PoMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择订单!');
				return;
			}
			var PoId = Row.RowId;
			if (title == '物资明细') {
				loadIncDetailIFrame(PoId);
			} else if (title == '科室请领明细') {
				loadReqDetailIFrame(PoId);
			}
		}
	});

	function loadPoDetailGrid(PoId) {
		PoDetailGrid.load({
			ClassName: 'web.DHCSTMHUI.INPOItm',
			QueryName: 'Query',
			query2JsonStrict: 1,
			PoId: PoId,
			rows: 99999
		});
	}
	function loadIncDetailIFrame(PoId) {
		var p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_INPO_ReqInfo.raq' + '&Parref=' + PoId;
		$('#IncDetailIFrame').attr('src', CommonFillUrl(p_URL));
	}
	function loadReqDetailIFrame(PoId) {
		var p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_INPO_ReqLocInfo.raq' + '&Parref=' + PoId;
		$('#ReqDetailIFrame').attr('src', CommonFillUrl(p_URL));
	}
	
	var PoDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 70,
			hidden: true
		}, {
			title: '物资ID',
			field: 'InciId',
			width: 100,
			hidden: true
		}, {
			title: '阳光平台编码',
			field: 'GoodId',
			width: 100
		}, {
			title: '代码',
			field: 'InciCode',
			width: 100
		}, {
			title: '名称',
			field: 'InciDesc',
			width: 100
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			width: 100,
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 40
		}, {
			title: '进价',
			field: 'Rp',
			width: 80,
			align: 'right'
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '到货数量',
			field: 'ImpQty',
			width: 100,
			align: 'right'
		}, {
			title: '未到货数量',
			field: 'AvaQty',
			width: 100,
			align: 'right'
		}, {
			title: '供应商',
			field: 'ApcVendor',
			width: 150
		}, {
			title: '生产厂家',
			field: 'PhManf',
			width: 150
		}, {
			title: '阳光平台订单明细ID',
			field: 'ThirdOrderDetailId',
			width: 150
		}
	]];

	var PoDetailGrid = $UI.datagrid('#PoDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPOItm',
			QueryName: 'Query',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		columns: PoDetailCm,
		showBar: true
	});

	var PoMainCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '订单号',
			field: 'PoNo',
			width: 100
		}, {
			title: '订单科室',
			field: 'PoLocDesc',
			width: 100
		}, {
			title: '供应商',
			field: 'VendorDesc',
			width: 150
		}, {
			title: '订单状态',
			field: 'PoStatus',
			width: 100,
			formatter: function(value) {
				var PoStatus = '';
				if (value == 0) {
					PoStatus = '未入库';
				} else if (value == 1) {
					PoStatus = '部分入库';
				} else if (value == 2) {
					PoStatus = '全部入库';
				}
				return PoStatus;
			}
		}, {
			title: '订单日期',
			field: 'CreateDate',
			width: 100
		}, {
			title: '完成',
			field: 'CompFlag',
			align: 'center',
			width: 60
		}, {
			title: '平台发送',
			field: 'SendFlag',
			align: 'center',
			width: 70,
			hidden: ((SerUseObj.ECS != 'Y') && (SerUseObj.SCI != 'Y'))
		}, {
			title: '平台状态',
			field: 'PlatStat',			// ECS供应链订单状态
			align: 'center',
			width: 70,
			hidden: ((SerUseObj.ECS != 'Y') && (SerUseObj.SCI != 'Y')),
			formatter: function(value) {
				var PlatStatus = value;
				// 1-待配送,11-配货中, 12-配送中,2-已入库,3-已完成,4-已关闭
				if (value == '1') {
					PlatStatus = '待配送';
				} else if (value == '11') {
					PlatStatus = '配货中';
				} else if (value == '12') {
					PlatStatus = '配送中';
				} else if (value == '2') {
					PlatStatus = '已入库';
				} else if (value == '3') {
					PlatStatus = '已完成';
				} else if (value == '4') {
					PlatStatus = '已关闭';
				}
				return PlatStatus;
			}
		},
		/*
		{
			title: "平台状态",
			field: 'CancelFlag',		//验收界面的"取消"
			align: 'center',
			width: 70,
			hidden:((SerUseObj.ECS!="Y")&&(SerUseObj.SCI!="Y")),
			formatter: function(value){
				var PlatStatus = '';
				if (value == 'Y') {
					PlatStatus = '已拒绝';
				} else if (value == 'N') {
					PlatStatus = '已确认';
				}
				return PlatStatus;
			}
		},
		*/
		{
			title: '采购单号',
			field: 'PurNo',
			width: 100
		}, {
			title: '阳光平台订单ID',
			field: 'PurPlanCodeId',
			width: 100
		}
	]];

	var PoMainGrid = $UI.datagrid('#PoMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPO',
			QueryName: 'QueryMain',
			query2JsonStrict: 1
		},
		columns: PoMainCm,
		showBar: true,
		singleSelect: false,
		onSelect: function(index, row) {
			var DTTabed = $('#DetailTabs').tabs('getSelected');
			var DTTabed = $('#DetailTabs').tabs('getTabIndex', DTTabed);
			if (DTTabed == 0) {
				loadPoDetailGrid(row.RowId);
			} else if (DTTabed == 1) {
				loadIncDetailIFrame(row.RowId);
			} else if (DTTabed == 2) {
				loadReqDetailIFrame(row.RowId);
			}
		},
		onLoadSuccess: function(data) {
			if ((data.rows.length > 0) && (CommParObj.IfSelFirstRow == 'Y')) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});

	/* --设置初始值--*/
	var Default = function() {
		// /设置初始值 考虑使用配置
		var DefaultValue = {
			StartDate: DateFormatter(DateAdd(new Date(), 'd', parseInt(-7))),
			EndDate: DateFormatter(new Date()),
			PoLoc: gLocObj,
			AllImp: 'Y',
			PartImp: 'Y',
			NoImp: 'Y',
			SendFlag: '',
			EmFlag: '0'
		};
		$UI.fillBlock('#MainConditions', DefaultValue);
		$('#IncDetailIFrame').attr('src', '');
		$('#ReqDetailIFrame').attr('src', '');
		if ((SerUseObj.ECS == 'Y') || (SerUseObj.SCI == 'Y')) {
			$('.SCIShow').show();
		} else {
			$('.SCIShow').hide();
		}
	};
	Default();
	$('#QueryBT').click();
};
$(init);