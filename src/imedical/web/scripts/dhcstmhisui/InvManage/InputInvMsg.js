var ToolBar, InvMainCm, InvDetailCm, InvMainGrid, InvDetailGrid;
var init = function() {
	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var LocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	$HUI.combobox('#IngrLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var MainToolBar = [{
		text: '上传',
		iconCls: 'icon-upload-cloud',
		handler: function() {
			var Row = InvMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要上传图片的发票信息!');
				return;
			}
			var RowId = Row.RowId;
			var VendorId = Row.VendorId;
			if (RowId == '') {
				$UI.msg('alert', '请选择要上传图片的发票信息!');
				return;
			}
			UpLoadFileWin('Vendor', VendorId, 'Inv', 'Inv', RowId, '');
		}
	},
	{
		text: '拍照',
		iconCls: 'icon-camera',
		handler: function() {
			var Row = InvMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要上传图片的发票信息!');
				return;
			}
			var RowId = Row.RowId;
			var VendorId = Row.VendorId;
			if (RowId == '') {
				$UI.msg('alert', '请选择要上传图片的发票信息!');
				return;
			}
			TakePhotoWin('Vendor', VendorId, 'Inv', 'Inv', RowId, '');
		}
	}];
	InvMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '预览',
			field: 'Icon',
			width: 50,
			align: 'center',
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '<div class="icon-img col-icon" title="查看图片" href="#" onclick="ViewFile(' + index + ')"></div>';
				return str;
			}
		}, {
			title: 'VendorId',
			field: 'VendorId',
			width: 50,
			hidden: true,
			saveCol: true
		}, {
			title: '供应商',
			field: 'VendorDesc',
			width: 180
		}, {
			title: 'LocId',
			field: 'LocId',
			width: 180,
			saveCol: true,
			hidden: true
		}, {
			title: '科室',
			field: 'LocDesc',
			width: 180
		}, {
			title: '组合进价',
			field: 'RpAmt',
			width: 100,
			align: 'right',
			saveCol: true
		}, {
			title: '发票代码',
			field: 'InvCode',
			width: 180,
			editor: {
				type: 'text'
			},
			saveCol: true
		}, {
			title: '发票号',
			field: 'InvNo',
			width: 180,
			saveCol: true,
			editor: {
				type: 'text'
			}
		}, {
			title: '发票金额',
			field: 'InvAmt',
			width: 100,
			align: 'right',
			saveCol: true,
			editor: {
				type: 'numberbox',
				options: {
					precision: GetFmtNum('FmtRP')
				}
			}
		}, {
			title: '发票日期',
			field: 'InvDate',
			width: 120,
			saveCol: true,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '录入人',
			field: 'CreateUserName',
			width: 120
		}, {
			title: '录入日期',
			field: 'CreateDate',
			width: 120
		}, {
			title: '录入时间',
			field: 'CreateTime',
			width: 80
		}, {
			title: '完成标志',
			field: 'CompFlag',
			align: 'center',
			width: 100
		}, {
			title: '审核标志',
			field: 'FilledFlag',
			align: 'center',
			width: 100
		}
	]];

	InvMainGrid = $UI.datagrid('#InvMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			QueryName: 'GetInvInfo',
			query2JsonStrict: 1
		},
		columns: InvMainCm,
		showBar: true,
		toolbar: MainToolBar,
		onSelect: function(index, row) {
			QueryDetail(row.RowId);
		},
		onClickRow: function(index, row) {
			InvMainGrid.commonClickRow(index, row);
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				InvMainGrid.selectRow(0);
			}
		},
		onBeginEdit: function(index, row) {
			$(this).datagrid('beginEdit', index);
			var ed = $(this).datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var e = ed[i];
				if (e.field == 'InvCode') {
					$(e.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var RowIndex = InvMainGrid.editIndex;
							var InvInfo = $(this).val();
							if (!isEmpty(InvInfo)) {
								var InvObj = GetInvInfo(InvInfo);
								if (InvObj === false) {
									$UI.msg('alert', '请录入正确的发票信息!');
									$(this).val('');
									$(this).focus();
									InvMainGrid.stopJump();
									return false;
								}
								if (!isEmpty(InvObj)) {
									var InvCode = InvObj.InvCode;
									var InvNo = InvObj.InvNo;
									var InvAmt = InvObj.InvAmt;
									var InvDate = InvObj.InvDate;
									InvMainGrid.updateRow({
										index: RowIndex,
										row: {
											InvCode: InvCode,
											InvNo: InvNo,
											InvAmt: InvAmt,
											InvDate: InvDate
										}
									});
								}
							}
						}
					});
				}
			}
		}
	});

	InvDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true,
			saveCol: true
		}, {
			title: 'Ingri',
			field: 'Ingri',
			width: 50,
			hidden: true
		}, {
			title: 'IncId',
			field: 'IncId',
			width: 50,
			hidden: true
		}, {
			title: '物资代码',
			field: 'Code',
			width: 150
		}, {
			title: '物资名称',
			field: 'Description',
			width: 150
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 40
		}, {
			title: '数量',
			field: 'Qty',
			width: 80,
			align: 'right'
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
			title: '售价',
			field: 'Sp',
			width: 80,
			align: 'right',
			hidden: true
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width: 80,
			align: 'right',
			hidden: true
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 120
		}, {
			title: '类型',
			field: 'Type',
			width: 50,
			formatter: function(value, row, index) {
				if (value == 'G') {
					return '入库';
				} else {
					return '退货';
				}
			}
		}, {
			title: '单号',
			field: 'IngrNo',
			width: 120
		}
	]];

	InvDetailGrid = $UI.datagrid('#InvDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			QueryName: 'DHCVendorInvItm',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		columns: InvDetailCm,
		showBar: true,
		fitColumns: true
	});
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	
	function Query() {
		var ParamsObj = $UI.loopBlock('#MainConditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (!isEmpty(StartDate) && !isEmpty(EndDate) && compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '截至日期不能小于开始日期!');
			return;
		}
		ParamsObj.CompFlag = 'Y';
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(InvDetailGrid);
		InvMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			QueryName: 'GetInvInfo',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	function QueryDetail(InvRowId) {
		InvDetailGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			QueryName: 'DHCVendorInvItm',
			query2JsonStrict: 1,
			Inv: InvRowId,
			rows: 99999
		});
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clearBlock('#MainConditions');
			$UI.clear(InvMainGrid);
			$UI.clear(InvDetailGrid);
			SetDefaValues();
		}
	});
	
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var Row = InvMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要打印的发票信息!');
				return;
			}
			PrintInv(Row.RowId);
		}
	});
	
	$UI.linkbutton('#AuditBT', {
		onClick: function() {
			var Row = InvMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要审核的发票信息!');
				return;
			}
			var InvRowId = Row.RowId;
			var CompFlag = Row.CompFlag;
			var FilledFlag = Row.FilledFlag;
			var InvNo = Row.InvNo;
			var InvAmt = Row.InvAmt;
			var RpAmt = Row.RpAmt;
			if (CompFlag != 'Y') {
				$UI.msg('alert', '发票未完成，不能审核!');
				return;
			}
			if (FilledFlag == 'Y') {
				$UI.msg('alert', '发票已审核，不能重复审核!');
				return;
			}
			if (isEmpty(InvNo)) {
				$UI.msg('alert', '发票号为空,不能审核!');
				return;
			}
			if (!isEmpty(InvAmt) && RpAmt != InvAmt) {
				$UI.msg('alert', '发票金额与组合进价不一致,不能审核!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				MethodName: 'jsAuditInvInfo',
				Inv: InvRowId
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					Query();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var DetailObj = InvMainGrid.getChangesData('RowId');
			if (DetailObj === false) {
				return false;
			}
			if (isEmpty(DetailObj) || DetailObj.length == 0) {
				$UI.msg('alert', '没有需要保存的明细!');
				return false;
			}
			for (var i = 0; i < DetailObj.length; i++) {
				var RpAmt = DetailObj[i].RpAmt;
				var InvAmt = DetailObj[i].InvAmt;
				var LeftAmt = accSub(Number(InvAmt), Number(RpAmt));
				if (!isEmpty(InvAmt) && Number(InvAmt) == 0) {
					// 未维护发票金额的,暂不做控制
					$UI.msg('alert', '第' + (i + 1) + '行当前发票金额等于0,请注意核实!');
					return;
				}
				if (!isEmpty(InvAmt) && Number(RpAmt) > Number(InvAmt)) {
					// 未维护发票金额的,暂不做控制
					$UI.msg('alert', '第' + (i + 1) + '行当前发票金额小于单据组合进价,请注意核实!');
					return;
				}
			}
			var Detail = JSON.stringify(DetailObj);
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				MethodName: 'jsSave',
				ListData: Detail
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					Query();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#CancelAuditBT', {
		onClick: function() {
			var Row = InvMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要取消审核的发票记录!');
				return;
			}
			var InvRowId = Row.RowId;
			var CompFlag = Row.CompFlag;
			var FilledFlag = Row.FilledFlag;
			if (CompFlag != 'Y') {
				$UI.msg('alert', '发票未完成，不能取消审核!');
				return;
			}
			if (FilledFlag != 'Y') {
				$UI.msg('alert', '发票未审核，不能取消审核!');
				return;
			}
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				MethodName: 'jsCancelAudit',
				InvId: InvRowId
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					Query();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#SendBT', {
		onClick: function() {
			var Row = InvMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要发送的发票信息!');
				return;
			}
			if (Row.FilledFlag != 'Y') {
				$UI.msg('alert', '请选择已审核的发票信息!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.ServiceForECS',
				MethodName: 'updateInvState',
				InvId: Row.RowId
			}, function(jsonData) {
				$UI.msg('success', '发送成功');
			});
		}
	});
	function SetDefaValues() {
		var DefaultValue = {
			FilledFlag: 'N',
			IngrLoc: gLocObj,
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate()
		};
		$UI.fillBlock('#MainConditions', DefaultValue);
		if (SerUseObj.ECS == 'Y') {
			$('.SCIShow').show();
		} else {
			$('.SCIShow').hide();
		}
	}

	SetDefaValues();
	Query();
};
$(init);
function ViewFile(index) {
	var RowData = InvMainGrid.getRows()[index];
	var OrgType = 'Vendor';
	var OrgId = RowData.VendorId;
	var RowId = RowData.RowId;
	ViewFileWin(OrgType, OrgId, 'Inv', 'Inv', RowId, '', '');
}