var init = function() {
	/* --按钮事件--*/
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		$UI.clear(PoMainGrid);
		$UI.clear(PoDetailGrid);
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
		ParamsObj.CompFlag = 'Y';
		var Params = JSON.stringify(ParamsObj);
		PoMainGrid.load({
			ClassName: 'web.DHCSTMHUI.INPO',
			QueryName: 'QueryMain',
			query2JsonStrict: 1,
			Params: Params
		});
	}

	// 设置可编辑组件的disabled属性
	function setApprove() {
		ChangeButtonEnable({ '#ApproveBT': false, '#DenyBT': false });
	}
	function setUnApprove() {
		ChangeButtonEnable({ '#ApproveBT': true, '#DenyBT': true });
	}
	function DefaultClear() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(PoMainGrid);
		$UI.clear(PoDetailGrid);
		$HUI.combobox('#PoLoc').enable();
		ChangeButtonEnable({ '#ApproveBT': true, '#DenyBT': true });
		Default();
	}
	$UI.linkbutton('#ApproveBT', {
		onClick: function() {
			var RowData = PoMainGrid.getSelections();
			if ((isEmpty(RowData)) || (RowData.length == 0)) {
				$UI.msg('alert', '请选择需要验收的单据!');
				return false;
			}
			$UI.confirm('您将要验收所选单据,是否继续?', '', '', Approve);
		}
	});
	function Approve() {
		var RowData = PoMainGrid.getSelections();
		var PoIdStr = '';
		for (var i = 0; i < RowData.length; i++) {
			var PoId = RowData[i].RowId;
			if (PoIdStr == '') {
				PoIdStr = PoId;
			} else {
				PoIdStr = PoIdStr + '^' + PoId;
			}
		}
		if (PoIdStr == '') {
			$UI.msg('alert', '没有需要验收的单据!');
			return false;
		}
		var Params = JSON.stringify(sessionObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPO',
			MethodName: 'jsApprove',
			Params: Params,
			PoIdStr: PoIdStr
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.clear(PoMainGrid);
				$UI.clear(PoDetailGrid);
				PoMainGrid.commonReload();
				var info = jsonData.msg;
				var infoArr = info.split('@');
				var Allcnt = infoArr[0];
				var Succnt = infoArr[1];
				var failcnt = Allcnt - Succnt;
				var ErrInfo = infoArr[2];
				$UI.msg('success', '共:' + Allcnt + '记录,成功:' + Succnt + '条');
				if (failcnt > 0) {
					$UI.msg('error', '失败:' + failcnt + '条;' + ErrInfo);
				}
			}
		});
	}
	$UI.linkbutton('#CalApproveBT', {
		onClick: function() {
			var Row = PoMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要取消验收的订单!');
				return;
			}
			if (Row.ApproveStatus != '已验收') {
				$UI.msg('alert', '单据未验收,不允许取消验收!');
				return;
			}
			if (Row.PoStatus != 0) {
				$UI.msg('alert', '单据已入库,不允许取消验收!');
				return;
			}
			var Params = JSON.stringify(addSessionParams({ RowId: Row.RowId }));
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.INPO',
				MethodName: 'jsCalApprove',
				Params: Params
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					$UI.clear(PoMainGrid);
					$UI.clear(PoDetailGrid);
					PoMainGrid.commonReload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#DenyBT', {
		onClick: function() {
			$UI.confirm('是否拒绝验收', 'warning', '', Deny, '', '', '警告', false);
		}
	});

	function Deny() {
		var Row = PoMainGrid.getSelected();
		if (isEmpty(Row)) {
			$UI.msg('alert', '请选择要拒绝的订单!');
			return;
		}
		var Params = JSON.stringify(addSessionParams({ RowId: Row.RowId }));
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPO',
			MethodName: 'jsDeny',
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				$UI.clear(PoMainGrid);
				$UI.clear(PoDetailGrid);
				PoMainGrid.commonReload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#CancelBT', {
		onClick: function() {
			$UI.confirm('是否取消订单', 'warning', '', Cancel, '', '', '警告', false);
		}
	});

	function Cancel() {
		var Row = PoMainGrid.getSelected();
		if (isEmpty(Row)) {
			$UI.msg('alert', '请选择要取消的订单!');
			return;
		}
		if (isEmpty($HUI.combobox('#CancelReason').getValue())) {
			$UI.msg('alert', '取消原因不能为空!');
			return false;
		}
		var CancelReason = $HUI.combobox('#CancelReason').getValue();
		var Params = JSON.stringify(addSessionParams({ RowId: Row.RowId, CancelReason: CancelReason }));
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPO',
			MethodName: 'jsCancel',
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				$UI.clear(PoMainGrid);
				$UI.clear(PoDetailGrid);
				PoMainGrid.commonReload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			DefaultClear();
		}
	});

	$UI.linkbutton('#EvaluateBT', {
		onClick: function() {
			var Row = PoMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要进行评价的订单!');
				return false;
			}
			VendorEvaluateWin(Row.RowId);
		}
	});
	/* --绑定控件--*/
	var PoLocBox = $HUI.combobox('#PoLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PoLocParams,
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
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var ReqLocBox = $HUI.combobox('#ReqLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PoLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var ApproveFlagBox = $HUI.combobox('#ApproveFlag', {
		data: [{ 'RowId': '', 'Description': '全部' }, { 'RowId': 'N', 'Description': '未验收' }, { 'RowId': 'Y', 'Description': '已验收' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var CancelReasonBox = $HUI.combobox('#CancelReason', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetForInPoReasonForCancel&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	$('#SxNo').bind('keydown', function(event) {
		if (event.keyCode == 13) {
			var SxNo = $(this).val();
			if (isEmpty(SxNo)) {
				return;
			}
			try {
				var SxNoObj = eval('(' + SxNo + ')');
				SxNo = SxNoObj['text'];
				$(this).val(SxNo);
			} catch (e) {}
			
			var SerUseObj = GetSerUseObj(gHospId);
			var ECSUseFlag = SerUseObj.ECS;
			if (ECSUseFlag == 'Y') {
				$.cm({
					ClassName: 'web.DHCSTMHUI.ServiceForECS',
					MethodName: 'getOrderDetail',
					SxNo: SxNo,
					HVFlag: '',
					HospId: gHospId
				}, function(jsonData) {
					if (!isEmpty(jsonData['Main'])) {
						$('#PoNo').val(jsonData['Main']['SCIPoNo']);
						Query();
					} else {
						$UI.msg('alert', '该随行单不存在或已入库!');
					}
				});
			} else {
				$.cm({
					ClassName: 'web.DHCSTMHUI.ServiceForSCI',
					MethodName: 'getOrderDetail',
					SxNo: SxNo,
					HVFlag: ''
				}, function(jsonData) {
					if (!isEmpty(jsonData['Main'])) {
						$('#PoNo').val(jsonData['Main']['SCIPoNo']);
						Query();
					} else {
						$UI.msg('alert', '该随行单不存在或已入库!');
					}
				});
			}
		}
	});
	
	var HandlerParams = function() {
		var PoLoc = $('#PoLoc').combo('getValue');
		var Obj = { StkGrpRowId: '', StkGrpType: 'M', Locdr: PoLoc };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));

	/* --Grid--*/
	var PoDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 60,
			hidden: true
		}, {
			title: '物资ID',
			field: 'InciId',
			width: 100,
			hidden: true
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
			width: 80
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
			title: '是否撤销',
			field: 'CancleFlag',
			width: 100,
			formatter: BoolFormatter
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
		fitColumns: true
	});

	var PoMainCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 60,
			hidden: true
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
			width: 100,
			formatter: BoolFormatter
		}, {
			title: '验收状态',
			field: 'ApproveStatus',
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
		singleSelect: false,
		fitColumns: true,
		onClickRow: function(index, row) {
			PoMainGrid.commonClickRow(index, row);
		},
		onSelect: function(index, row) {
			if (row['ApproveStatus'] != '未验收') {
				setApprove();
			} else {
				setUnApprove();
			}
			PoDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INPOItm',
				QueryName: 'Query',
				query2JsonStrict: 1,
				PoId: row.RowId,
				rows: 99999
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				PoMainGrid.selectRow(0);
			}
		}
	});

	/* --设置初始值--*/
	var Default = function() {
		// /设置初始值 考虑使用配置
		var DefaultValue = {
			StartDate: DateAdd(new Date(), 'd', parseInt(-7)),
			EndDate: new Date(),
			PoLoc: gLocObj,
			ApproveFlag: 'N',
			DefLocPP: 'Y'
		};
		$UI.fillBlock('#MainConditions', DefaultValue);
	};
	Default();
	Query();
};
$(init);