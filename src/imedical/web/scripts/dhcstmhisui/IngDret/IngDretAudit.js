var init = function() {
	var Clear = function() {
		$UI.clearBlock('#Conditions');
		$UI.clear(RetMainGrid);
		$UI.clear(RetDetailGrid);
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			RetLoc: gLocObj,
			Completed: 'Y',
			AuditFlag: 'N'
		};
		$UI.fillBlock('#Conditions', DefaultData);
		if (ItmTrackParamObj.AutoVirFlag == 'Y') {
			$('#VirtualFlag').checkbox('setValue', true);
		} else {
			$('#VirtualFlag').checkbox('setValue', false);
		}
		if ((SerUseObj.ECS == 'Y') || (SerUseObj.SCI == 'Y')) {
			$('.SCIShow').show();
		} else {
			$('.SCIShow').hide();
		}
	};
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		$UI.clear(RetMainGrid);
		$UI.clear(RetDetailGrid);
		var ParamsObj = $UI.loopBlock('#Conditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (isEmpty(ParamsObj.RetLoc)) {
			$UI.msg('alert', '退货科室不能为空!');
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
		var Params = JSON.stringify(ParamsObj);
		RetMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINGdRet',
			QueryName: 'DHCINGdRet',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#AuditBT', {
		onClick: function() {
			if ((SerUseObj.ECS == 'Y') || (SerUseObj.SCI == 'Y')) {
				$UI.confirm('审核同时推送到云平台?', '', '', AuditAndSend, '', Audit);
			} else {
				Audit();
			}
		}
	});
	function AuditAndSend() {
		var AutoSendFlag = 'Y';
		Audit(AutoSendFlag);
	}
	function Audit(AutoSendFlag) {
		if (isEmpty(AutoSendFlag)) {
			AutoSendFlag = 'N';
		}
		var Row = RetMainGrid.getSelected();
		if (isEmpty(Row)) {
			$UI.msg('alert', '请选择要审核的退货单!');
			return;
		}
		var InStkTkParamObj = GetAppPropValue('DHCSTINSTKTKM');
		if (InStkTkParamObj.AllowBusiness != 'Y') {
			var RetLoc = Row.RetLoc;
			var IfExistInStkTk = tkMakeServerCall('web.DHCSTMHUI.INStkTk', 'CheckInStkTkByLoc', RetLoc);
			if (IfExistInStkTk == 'Y') {
				$UI.msg('alert', '存在未完成的盘点单不允许审核!');
				return false;
			}
		}
		var Params = JSON.stringify(addSessionParams({ RowId: Row.RowId }));
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRet',
			MethodName: 'jsAudit',
			Params: Params
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				$UI.clear(RetDetailGrid);
				RetMainGrid.commonReload();
				if (AutoSendFlag == 'Y') {
					Send(Row.RowId);
				}
				if (IngrtParamObj['AutoPrintAfterAuditDRET'] == 'Y') {
					PrintIngDret(Row.RowId);
				}
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#CancelAuditBT', {
		onClick: function() {
			CancelAudit();
		}
	});
	function CancelAudit() {
		var Row = RetMainGrid.getSelected();
		if (isEmpty(Row)) {
			$UI.msg('alert', '请选择要取消审核的退货单!');
			return;
		}
		var Params = JSON.stringify(addSessionParams({ RowId: Row.RowId }));
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRet',
			MethodName: 'jsCancelAudit',
			Params: Params
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				$UI.clear(RetDetailGrid);
				RetMainGrid.commonReload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#SendBT', {
		onClick: function() {
			var Row = RetMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要推送的退货单!');
				return;
			}
			if (Row['AuditFlag'] != 'Y') {
				$UI.msg('alert', '未审核单据不允许推送!');
				return;
			}
			Send(Row.RowId);
		}
	});
	function Send(RowId) {
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRet',
			MethodName: 'jsSendIngRetToSCM',
			RowId: RowId
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				$UI.clear(RetDetailGrid);
				RetMainGrid.commonReload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#CancelSendBT', {
		onClick: function() {
			var Row = RetMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要取消推送的退货单!');
				return;
			}
			if (Row['SendFlag'] != 'Y') {
				$UI.msg('alert', '未推送单据不允许取消推送!');
				return;
			}
			if (Row['HRPFlag'] == '1') {
				$UI.msg('alert', '平台已确认订单单据不允许取消推送!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINGdRet',
				MethodName: 'CancelSend',
				RowId: Row.RowId
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					$UI.clear(RetDetailGrid);
					RetMainGrid.commonReload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#GetPlatState', {
		onClick: function() {
			var Row = RetMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要处理的退货单!');
				return;
			}
			if (Row['SendFlag'] != 'Y') {
				$UI.msg('alert', '未推送单据不允许无需获取状态!');
				return;
			}
			if (Row['HRPFlag'] == '1') {
				$UI.msg('alert', '平台已确认订单单据!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINGdRet',
				MethodName: 'jsSetRetStatus',
				RowId: Row.RowId
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					$UI.clear(RetDetailGrid);
					RetMainGrid.commonReload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var Row = RetMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要打印的退货单!');
				return;
			}
			var AuditFlag = Row.AuditFlag;
			if ((IngrtParamObj.PrintNoAudit == 'N') && (AuditFlag != 'Y')) {
				$UI.msg('alert', '不允许打印未审核的退货单!');
				return false;
			}
			PrintIngDret(Row.RowId);
		}
	});
	
	$UI.linkbutton('#PrintHVBT', {
		onClick: function() {
			var Row = RetMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要打印的退货单!');
				return;
			}
			var AuditFlag = Row.AuditFlag;
			if ((IngrtParamObj.PrintNoAudit == 'N') && (AuditFlag != 'Y')) {
				$UI.msg('alert', '不允许打印未审核的退货单!');
				return false;
			}
			PrintIngDretHVCol(Row.RowId);
		}
	});
	
	var SunPurPlan=CommParObj.SunPurPlan;  //参数设置 公共
	///20221112 同步阳光采购平台
	$UI.linkbutton('#SendIngRetBT',{
		onClick:function(){
			if (isEmpty(SunPurPlan)){
				$UI.msg('alert', '请配置采购平台信息!');
				return;
			}
			if (SunPurPlan=="四川省"){
				SCSendIngRet();
			}
		}
	});
	function SCSendIngRet(){
		var RowData = RetMainGrid.getSelections();
		var IngrtIdStr = "";
		for (var i = 0; i < RowData.length; i++) {
			var RowIndex = RetMainGrid.getRowIndex(RowData[i]);
			var AuditFlag = RowData[i].AuditFlag;
			var RetNo = RowData[i].RetNo;
			if(AuditFlag != "Y"){
				$UI.msg('alert', '退货单:' + RetNo + '未审核!');
				RetMainGrid.unselectRow(RowIndex);
			}
			var RowId = RowData[i].RowId;
			if (IngrtIdStr == "") {
				IngrtIdStr = RowId;
			} else {
				IngrtIdStr = IngrtIdStr + "^" + RowId;
			}
		}
		if (isEmpty(IngrtIdStr)) {
			$UI.msg('alert', '请选择要同步的退货单!');
			return false;
		}
		showMask();	
		$.cm({
			ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
			MethodName: 'JsSendRetStr',
			RetStr:IngrtIdStr
		},function(jsonData){
			hideMask();
			if(jsonData.success==0){
				var retinfo=jsonData.msg;
				var retarr=retinfo.split("@");
				var Suc=Number(retarr[0]);
				var Fail=Number(retarr[1]);
				var Failinfo=retarr[3];
				$UI.msg('alert','共'+Suc+Fail+"条退货单；成功："+Suc+"条；失败："+Fail+"条"+Failinfo);
			}
		});
	}
	///20221112 阳光采购平台查询
	$UI.linkbutton('#ReturnQueryBT', {
		onClick: function () {
			var Row=RetMainGrid.getSelected();
			if(isEmpty(Row)){
				$UI.msg('alert','请选择要查询的退货单!');
				return;
			}
			var IngdRet=Row.RowId;
			
			if (isEmpty(SunPurPlan)){
				$UI.msg('alert', '请配置采购平台信息!');
				return;
			}
			if (SunPurPlan=="四川省"){
				SCUpIngrtStatusQuery(IngdRet);
			}
		}
	});

	var RetLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var RetLocBox = $HUI.combobox('#RetLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + RetLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			if (CommParObj.ApcScg == 'L') {
				VendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M', LocId: LocId }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
				VendorBox.reload(url);
			}
		}
	});
	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var VirtualFlag = $HUI.checkbox('#VirtualFlag', {
		onCheckChange: function(e, value) {
			if (value) {
				var LocId = $('#RetLoc').combobox('getValue');
				var Info = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon', 'GetMainLoc', LocId);
				var InfoArr = Info.split('^');
				var VituralLoc = InfoArr[0], VituralLocDesc = InfoArr[1];
				AddComboData($('#RetLoc'), VituralLoc, VituralLocDesc);
				$('#RetLoc').combobox('setValue', VituralLoc);
			} else {
				$('#RetLoc').combobox('setValue', gLocId);
			}
		}
	});
	var RetMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 60,
			hidden: true
		}, {
			title: '退货单号',
			field: 'RetNo',
			width: 150
		}, {
			title: '供应商',
			field: 'VendorName',
			width: 150
		}, {
			title: '退货科室',
			field: 'RetLocDesc',
			width: 150
		}, {
			title: '制单人',
			field: 'RetUserName',
			width: 80
		}, {
			title: '制单日期',
			field: 'RetDate',
			width: 100
		}, {
			title: '制单时间',
			field: 'RetTime',
			width: 80
		}, {
			title: '审核标志',
			field: 'AuditFlag',
			align: 'center',
			width: 80,
			formatter: BoolFormatter
		}, {
			title: '推送平台标志',
			field: 'SendFlag',
			align: 'center',
			width: 100,
			formatter: BoolFormatter
		}, {
			title: '平台确认标记',
			field: 'HRPFlag',
			width: 100,
			align: 'center',
			formatter: function(value, row, index) {
				if (value == 1) {
					HRPFlag = '是';
				} else {
					HRPFlag = '';
				}
				return HRPFlag;
			}
		}, {
			title: '备注',
			field: 'Remark',
			width: 200
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 200
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width: 200
		}, {
			title: 'RetLoc',
			field: 'RetLoc',
			width: 10,
			hidden: true
		}
	]];
	
	var RetMainGrid = $UI.datagrid('#RetMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRet',
			QueryName: 'DHCINGdRet',
			query2JsonStrict: 1
		},
		columns: RetMainCm,
		showBar: true,
		onSelect: function(index, row) {
			var ParamsObj = { RefuseFlag: 1 };
			var Params = JSON.stringify(ParamsObj);
			RetDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGrtItm',
				QueryName: 'DHCINGdRetItm',
				query2JsonStrict: 1,
				RetId: row.RowId,
				rows: 99999
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	
	var RetDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 60,
			hidden: true
		}, {
			title: 'Ingri',
			field: 'Ingri',
			width: 60,
			hidden: true
		}, {
			title: 'Inci',
			field: 'Inci',
			width: 60,
			hidden: true
		}, {
			title: 'Inclb',
			field: 'Inclb',
			width: 60,
			hidden: true
		}, {
			title: '物资代码',
			field: 'Code',
			width: 100
		}, {
			title: '物资名称',
			field: 'Description',
			width: 150
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 150
		}, {
			title: '批号',
			field: 'BatNo',
			width: 100
		}, {
			title: '效期',
			field: 'ExpDate',
			width: 100
		}, {
			title: '批次库存',
			field: 'StkQty',
			width: 80,
			align: 'right'
		}, {
			title: '退货数量',
			field: 'Qty',
			width: 80,
			align: 'right'
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 80
		}, {
			title: '退货原因',
			field: 'Reason',
			width: 100
		}, {
			title: '退货进价',
			field: 'Rp',
			width: 80,
			align: 'right'
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '国家医保编码',
			field: 'MatInsuCode',
			width: 160
		}, {
			title: '国家医保名称',
			field: 'MatInsuDesc',
			width: 160
		}, {
			title: '发票代码',
			field: 'InvCode',
			width: 100
		}, {
			title: '发票号',
			field: 'InvNo',
			width: 100
		}, {
			title: '发票日期',
			field: 'InvDate',
			width: 100
		}, {
			title: '发票金额',
			field: 'InvAmt',
			width: 80,
			align: 'right'
		}, {
			title: '零售单价',
			field: 'Sp',
			width: 80,
			align: 'right'
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			width: 100,
			align: 'left',
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: '高值标志',
			field: 'HvFlag',
			width: 80,
			align: 'center',
			formatter: BoolFormatter
		}, {
			title: '随行单号',
			field: 'SxNo',
			width: 200,
			align: 'left'
		}, {
			title: '平台id',
			field: 'OrderDetailSubId',
			width: 200,
			align: 'left',
			hidden: true
		}
	]];
	var RetDetailGrid = $UI.datagrid('#RetDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGrtItm',
			QueryName: 'DHCINGdRetItm',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		columns: RetDetailCm,
		showBar: true,
		onLoadSuccess: function(data) {
			$.each(data.rows, function(index, row) {
				var OrderDetailSubId = row['OrderDetailSubId'];
				if (!isEmpty(OrderDetailSubId)) {
					SetGridBgColor(RetDetailGrid, index, 'RowId', '#449BE3', '');
				}
			});
		}
	});
	
	Clear();
	Query();
};
$(init);