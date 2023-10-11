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
			saveCol: true,
			hidden: true
		}, {
			title: '供应商',
			field: 'VendorDesc',
			width: 180
		}, {
			title: 'LocId',
			field: 'LocId',
			width: 50,
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
			width: 150,
			editor: {
				type: 'text'
			},
			saveCol: true
		}, {
			title: '发票号',
			field: 'InvNo',
			width: 150,
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
			width: 100
		}, {
			title: '录入日期',
			field: 'CreateDate',
			width: 120
		}, {
			title: '录入时间',
			field: 'CreateTime',
			width: 100
		}, {
			title: '完成标志',
			field: 'CompFlag',
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
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				InvMainGrid.selectRow(0);
			}
		},
		onClickRow: function(index, row) {
			InvMainGrid.commonClickRow(index, row);
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
	
	ToolBar = [{
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			var Row = InvMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要删除明细的发票信息!');
				return;
			}
			var InvRowId = Row.RowId;
			var CompFlag = Row.CompFlag;
			if (CompFlag == 'Y') {
				$UI.msg('alert', '发票信息已完成不能删除!');
				return;
			}
			var detailRow = InvDetailGrid.getSelected();
			if (isEmpty(detailRow)) {
				$UI.msg('alert', '请选择要删除的行!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				MethodName: 'jsDeleteItm',
				RowId: detailRow.RowId
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					QueryDetail(InvRowId);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	}];

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
		fitColumns: true,
		toolbar: ToolBar
	});

	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	
	function Query() {
		var ParamsObj = $UI.loopBlock('#MainConditions');
		ParamsObj.FilledFlag = 'N';
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
	
	$UI.linkbutton('#SelIngrBT', {
		onClick: function() {
			var Row = InvMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择发票信息进行绑定!');
				return;
			}
			var InvRowId = Row.RowId;
			var CompFlag = Row.CompFlag;
			if (CompFlag == 'Y') {
				$UI.msg('alert', '发票已绑定完成，不允许修改!');
				return;
			}
			var IngrLocId = Row.LocId;
			var VendorId = Row.VendorId;
			if (isEmpty(IngrLocId)) {
				IngrLocId = $HUI.combobox('#IngrLoc').getValue();
			}
			if (isEmpty(IngrLocId)) {
				$UI.msg('alert', '科室不能为空!');
				return;
			}
			InvDetailWin(InvRowId, IngrLocId, VendorId, Select);
		}
	});
	
	$UI.linkbutton('#ComBT', {
		onClick: function() {
			var Row = InvMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择发票信息!');
				return;
			}
			var InvRowId = Row.RowId;
			var CompFlag = Row.CompFlag;
			if (CompFlag == 'Y') {
				$UI.msg('alert', '发票已完成，不能重复完成!');
				return;
			}
			
			DetailRows = InvDetailGrid.getRows();
			if (DetailRows.length <= 0) {
				$UI.msg('alert', '发票未绑定明细，不允许完成!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				MethodName: 'SetComp',
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

	$UI.linkbutton('#CanComBT', {
		onClick: function() {
			var Row = InvMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择发票信息!');
				return;
			}
			var InvRowId = Row.RowId;
			var CompFlag = Row.CompFlag;
			if (CompFlag != 'Y') {
				$UI.msg('alert', '发票未完成，不允许取消!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				MethodName: 'CancelComp',
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
	$UI.linkbutton('#CreateBT', {
		onClick: function() {
			CreateWin(Select);
		}
	});
	var Select = function(InvId) {
		$UI.clear(InvMainGrid);
		$UI.clear(InvDetailGrid);
		InvMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			QueryName: 'GetInvInfo',
			query2JsonStrict: 1,
			Params: '',
			PInvId: InvId
		});
	};
	
	$UI.linkbutton('#DeleteBT', {
		onClick: function() {
			var Row = InvMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择发票信息!');
				return;
			}
			var InvRowId = Row.RowId;
			var CompFlag = Row.CompFlag;
			if (CompFlag == 'Y') {
				$UI.msg('alert', '发票已完成，不允许删除!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				MethodName: 'jsDelete',
				InvId: InvRowId
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
	function SetDefaValues() {
		var DefaultValue = {
			CompFlag: 'N',
			IngrLoc: gLocObj,
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate()
		};
		$UI.fillBlock('#MainConditions', DefaultValue);
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