var init = function() {
	/* --按钮事件--*/
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
			var Params = JSON.stringify(ParamsObj);
			PoDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INPOItm',
				QueryName: 'QueryAll',
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
	function DefaultClear() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(PoDetailGrid);
		Default();
	}
	
	/* --绑定控件--*/
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
	var ReqLocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	var ReqLocBox = $HUI.combobox('#ReqLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var HandlerParams = function() {
		var StkScg = $('#StkScg').combotree('getValue');
		var PoLoc = $('#PoLoc').combo('getValue');
		var Obj = { StkGrpRowId: StkScg, StkGrpType: 'M', Locdr: PoLoc };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	
	/* --Grid--*/
	var PoDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 80
		}, {
			title: 'PoId',
			field: 'PoId',
			hidden: true,
			width: 80
		}, {
			title: '订单号',
			field: 'PoNo',
			width: 150
		}, {
			title: '订单科室',
			field: 'PoLocDesc',
			width: 150
		}, {
			title: '申请科室',
			field: 'ReqLocDesc',
			width: 150
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
			title: '供应商邮箱',
			field: 'Email',
			width: 150
		}, {
			title: '物资ID',
			field: 'InciId',
			hidden: true
		}, {
			title: '代码',
			field: 'InciCode',
			width: 150
		}, {
			title: '名称',
			field: 'InciDesc',
			width: 150
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
			title: '订购数量',
			field: 'PurQty',
			width: 80
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '到货数量',
			field: 'ImpQty',
			width: 80,
			align: 'right'
		}, {
			title: '未到货数量',
			field: 'AvaQty',
			width: 80,
			align: 'right'
		}, {
			title: '配送员手机号码',
			field: 'Mobile',
			width: 100
		}, {
			title: '请求备注',
			field: 'ReqRemark',
			width: 100
		}, {
			title: '采购单号',
			field: 'PurNo',
			width: 100
		}, {
			title: '生产厂家',
			field: 'PhManf',
			width: 100
		}
	]];
	
	var PoDetailGrid = $UI.datagrid('#PoDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPOItm',
			QueryName: 'QueryAll',
			query2JsonStrict: 1
		},
		columns: PoDetailCm,
		sortName: 'RowId',
		sortOrder: 'Desc',
		showBar: true,
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
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
			AllImp: 'Y',
			PartImp: 'Y',
			NoImp: 'Y'
		};
		$UI.fillBlock('#MainConditions', DefaultValue);
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