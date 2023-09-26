var init = function () {
	/*--按钮事件--*/
	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			FindWin(Select);
		}
	});
	var Select = function (PoId) {
		$UI.clearBlock('#MainConditions');
		$UI.clear(PoGrid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPO',
			MethodName: 'Select',
			PoId: PoId
		}, function (jsonData) {
			$UI.fillBlock('#MainConditions', jsonData);
			if ($HUI.checkbox("#CompFlag").getValue() == false) {
				setUnComp();
			} else {
				setComp();
			}
		});
		PoGrid.load({
			ClassName: 'web.DHCSTMHUI.INPOItm',
			QueryName: 'Query',
			PoId: PoId
		});
	}
	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			DefaultClear();
		}
	});
	function DefaultClear() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(PoGrid);
		$HUI.combobox("#PoLoc").enable()
		$HUI.combobox("#StkScg").enable()
		$HUI.combobox("#Vendor").enable()
		ChangeButtonEnable({
			'#AddBT': true,
			'#DelBT': true,
			'#ComBT': true,
			'#CanComBT': false
		});
		Default();
	}
	$UI.linkbutton('#DelBT', {
		onClick: function () {
			if ($HUI.checkbox("#CompFlag").getValue() == true) {
				$UI.msg("alert", "已经完成，不能删除!");
				return false;
			}
			var PoId = $('#RowId').val();
			if (isEmpty(PoId)) {
				$UI.msg("alert", "请选择要删除的订单");
				return;
			}
			$UI.confirm("确定要删除吗", "warning", "", Delete, "", "", "警告", false);
		}
	});
	function Delete() {
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPO',
			MethodName: 'jsDelete',
			PoId: $('#RowId').val()
		}, function (jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg("success", jsonData.msg);
				DefaultClear()
			} else {
				$UI.msg("error", jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#SaveBT', {
		onClick: function () {
			Save();
		}
	});
	var Save = function () {
		var MainObj = $UI.loopBlock('#MainConditions');
		var Main = JSON.stringify(addSessionParams(MainObj));
		var DetailObj = PoGrid.getChangesData('InciId');
		//判断
		var ifChangeMain=$UI.isChangeBlock('#MainConditions');
		if (DetailObj === false){	//未完成编辑或明细为空
			return;
		}
		if (!ifChangeMain && (isEmpty(DetailObj))){	//主单和明细不变
			$UI.msg("alert", "没有需要保存的信息!");
			return;
		}
		
		if ($HUI.checkbox("#CompFlag").getValue() == true) {
			$UI.msg("alert", "已经完成，不能保存!");
			return false;
		}
		showMask();
		var Detail = JSON.stringify(DetailObj);
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPO',
			MethodName: 'Save',
			Main: Main,
			Detail: Detail
		}, function (jsonData) {
			hideMask();
			$UI.msg("success", jsonData.msg);
			if (jsonData.success == 0) {
				Select(jsonData.rowid);
			} else {
				$UI.msg("error", jsonData.msg);
			}
		});
	}

	$UI.linkbutton('#ComBT', {
		onClick: function () {
			var PoId = $('#RowId').val()
			if (isEmpty(PoId)) {
				$UI.msg("alert", "请选择要完成的订单");
				return;
			}
			var Detail = PoGrid.getChangesData();
			if (Detail!="") {
				$UI.confirm("数据已修改是否放弃保存！", "warning", "", SetComplete, "", "", "警告", false);
			} else {
				SetComplete();
			}
		}
	});
	
	function SetComplete() {
		var MainObj = $UI.loopBlock('#MainConditions');
		var Main = JSON.stringify(MainObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPO',
			MethodName: 'jsSetComplete',
			Params: Main
		}, function (jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg("success", jsonData.msg);
				Select(jsonData.rowid);
			} else {
				$UI.msg("error", jsonData.msg);
			}
		});
	}

	$UI.linkbutton('#CanComBT', {
		onClick: function () {
			var PoId = $('#RowId').val();
			if (isEmpty(PoId)) {
				$UI.msg("alert", "请选择要取消完成的订单");
				return;
			}
			var MainObj = $UI.loopBlock('#MainConditions');
			var Main = JSON.stringify(MainObj);
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.INPO',
				MethodName: 'jsCancelComplete',
				Params: Main
			}, function (jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg("success", jsonData.msg);
					Select(jsonData.rowid)
				} else {
					$UI.msg("error", jsonData.msg);
				}
			});
		}
	});

	$UI.linkbutton('#PrintBT', {
		onClick: function () {
			var PoId = $('#RowId').val()
			if (isEmpty(PoId)) {
				$UI.msg("alert", "请选择要打印的订单");
				return;
			}
			PrintInPo(PoId);
		}
	});

	/*--绑定控件--*/
	var PoLocBox = $HUI.combobox('#PoLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PoLocParams,
			valueField: 'RowId',
			textField: 'Description',
			hiddenField:'Contact',
			filter: function(q, row){
				var opts = $(this).combobox('options');
				return row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) == 0 || row[opts.hiddenField].toUpperCase().indexOf(q.toUpperCase()) == 0
			}
		});
	var VendorBox = $HUI.combobox('#Vendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
			valueField: 'RowId',
			textField: 'Description',
			onBeforeLoad: function (param) {
				var ParamsObj = $UI.loopBlock('#MainConditions');
				var ScgId = ParamsObj.StkScg;
				param.ScgId = ScgId;
			},
			onShowPanel: function () {
				$(this).combobox('reload')
			}
		});

	/*--Grid列绑定--*/
	var HandlerParams = function () {
		var StkScg = $("#StkScg").combotree('getValue');
		var PoLoc = $("#PoLoc").combo('getValue');
		var Obj = {
			StkGrpRowId: StkScg,
			StkGrpType: "M",
			Locdr: PoLoc,
			NotUseFlag: "N",
			QtyFlag: "Y",
			ToLoc: "",
			ReqModeLimited: "",
			NoLocReq: "N",
			HV: "",
			RequestNoStock: "Y"
		};
		return Obj;
	}
	var SelectRow = function (row) {
		var PoLoc = $HUI.combobox("#PoLoc").getValue();
		var InciParams = JSON.stringify(addSessionParams({
					LocId: PoLoc
				}));
		$.cm({
			ClassName: 'web.DHCSTMHUI.INPO',
			MethodName: 'GetItmInfo',
			IncId: row.InciDr,
			Params: InciParams
		}, function (jsonData) {
			var Rows = PoGrid.getRows();
			var Row = Rows[PoGrid.editIndex];
			Row.InciId = row.InciDr;
			Row.InciCode = row.InciCode;
			Row.InciDesc = row.InciDesc;
			Row.Spec = row.Spec;
			Row.UomId = row.PUomDr;
			Row.UomDesc = row.PUomDesc;
			Row.Rp = jsonData.Rp;
			Row.BUomId = row.BUomDr;
			Row.ConFac = row.ConFac;
			Row.ManfId = jsonData.ManfId;
			Row.ManfDesc = jsonData.ManfDesc;
			setTimeout(function () {
				PoGrid.refreshRow();
				PoGrid.startEditingNext('InciDesc');
			}, 0);
		});
	};

	var UomCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote',
			onBeforeLoad: function (param) {
				var rows = PoGrid.getRows();
				var row = rows[PoGrid.editIndex];
				if (!isEmpty(row)) {
					param.Inci = row.InciId;
				}
			},
			onSelect: function (record) {
				var rows = PoGrid.getRows();
				var row = rows[PoGrid.editIndex];
				var seluom = record.RowId;
				var rp = row.Rp;
				var buom = row.BUomId;
				var confac = row.ConFac;
				var uom = row.UomId; //旧单位
				if (seluom != uom) {
					if (seluom != buom) { //原单位是基本单位，目前选择的是入库单位
						Rp = Number(rp).mul(confac);
					} else { //目前选择的是基本单位，原单位是入库单位
						Rp = Number(rp).div(confac);
					}
				}
				row.UomDesc = record.Description;
				row.UomId = record.RowId;
				row.Rp = Rp;
				$('#PoGrid').datagrid('refreshRow', PoGrid.editIndex);
			},
			onShowPanel: function () {
				$(this).combobox('reload')
			}
		}
	};
	var SpecDescParams = JSON.stringify(sessionObj)
		var SpecDescbox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSpecDesc&ResultSetType=array&Params=' + SpecDescParams,
			valueField: 'Description',
			textField: 'Description',
			required: false,
			mode: 'remote',
			onBeforeLoad: function (param) {
				var rows = PoGrid.getRows();
				var row = rows[PoGrid.editIndex];
				if (!isEmpty(row)) {
					param.Inci = row.InciId;
				}
			}
		}
	};

	/*--Grid--*/
	var PoCm = [[{
				field: 'ck',
				checkbox: true
			}, {
				title: "RowId",
				field: 'RowId',
				hidden: true
			}, {
				title: "物资RowId",
				field: 'InciId',
				hidden: true
			}, {
				title: "物资代码",
				field: 'InciCode',
				width: 100
			}, {
				title: "物资名称",
				field: 'InciDesc',
				width: 200,
				editor: InciEditor(HandlerParams, SelectRow)
			}, {
				title: "规格",
				field: 'Spec',
				width: 100
			}, {
				title: "厂商",
				field: 'ManfId',
				width: 100,
				hidden: true
			}, {
				title: "厂商",
				field: 'ManfDesc',
				width: 100
			}, {
				title: "数量",
				field: 'PurQty',
				width: 100,
				align: 'right',
				necessary: true,
				editor: {
					type: 'numberbox',
					options: {
						required: true
					}
				}
			}, {
				title: "单位",
				field: 'UomId',
				width: 80,
				necessary: true,
				formatter: CommonFormatter(UomCombox, 'UomId', 'UomDesc'),
				editor: UomCombox
			}, {
				title: "进价",
				field: 'Rp',
				width: 80,
				align: 'right',
				necessary: true,
				editor: {
					type: 'numberbox',
					options: {
						required: true
					}
				}
			}, {
				title: "进价金额",
				field: 'RpAmt',
				width: 100,
				align: 'right'
			}, {
				title: "具体规格",
				field: 'SpecDesc',
				width: 100,
				formatter: CommonFormatter(SpecDescbox, 'SpecDesc', 'SpecDesc'),
				editor: SpecDescbox
			}, {
				title: "基本单位Id",
				field: 'BUomId',
				width: 80,
				hidden: true
			}, {
				title: "单位转换系数",
				field: 'ConFac',
				width: 80,
				hidden: true
			}
		]];

	var PoGrid = $UI.datagrid('#PoGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.INPOItm',
				QueryName: 'Query'
			},
			deleteRowParams: {
				ClassName: 'web.DHCSTMHUI.INPOItm',
				MethodName: 'jsDelete'
			},
			columns: PoCm,
			sortName: 'RowId',
			sortOrder: 'Asc',
			singleSelect: false,
			showAddDelItems: true,
			showBar: true,
			/*toolbar:[{
			text: '保存',
			iconCls: 'icon-save',
			handler: function () {
			Save();
			}
			}],*/
			onClickCell: function (index, filed, value) {
				if ($HUI.checkbox("#CompFlag").getValue()) {
					return false;
				}
				PoGrid.commonClickCell(index, filed, value);
			},
			beforeAddFn: function () {
				if ($HUI.checkbox("#CompFlag").getValue() == true) {
					$UI.msg("alert", "已经完成，不能增加一行");
					return false;
				}
				if (isEmpty($HUI.combobox("#PoLoc").getValue())) {
					$UI.msg("alert", "订单科室不能为空");
					return false;
				}
				if (isEmpty($HUI.combobox("#StkScg").getValue())) {
					$UI.msg("alert", "类组不能为空");
					return false;
				}
				if (isEmpty($HUI.combobox("#Vendor").getValue())) {
					$UI.msg("alert", "供应商不能为空");
					return false;
				}
				setUnComp();
			},
			onBeforeEdit: function (index, row) {
				if ($HUI.checkbox("#CompFlag").getValue()) {
					return false;
				}
			}
		})

		//设置可编辑组件的disabled属性
	function setUnComp() {
		$HUI.combobox("#PoLoc").disable()
		$HUI.combobox("#StkScg").disable()
		$HUI.combobox("#Vendor").disable()
		ChangeButtonEnable({
			'#ClearBT': true,
			'#SaveBT': true,
			'#DelBT': true,
			'#ComBT': true,
			'#CanComBT': false
		});
	}
	function setComp() {
		$HUI.combobox("#PoLoc").disable()
		$HUI.combobox("#StkScg").disable()
		$HUI.combobox("#Vendor").disable()
		ChangeButtonEnable({
			'#ClearBT': true,
			'#SaveBT': false,
			'#DelBT': false,
			'#ComBT': false,
			'#CanComBT': true
		});
	}

	/*--设置初始值--*/
	var Default = function () {
		///设置初始值 考虑使用配置
		var DefaultValue = {
			RowId: "",
			PoLoc: gLocObj,
			NeedDate: NeedDate()
		};
		$UI.fillBlock('#MainConditions', DefaultValue);
	}
	Default();
}
$(init);
