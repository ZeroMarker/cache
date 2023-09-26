var GRMainGrid, GRDetailGrid;
var GRMainCm, GRDetailCm, ToolBar;
var init = function () {
	var InciHandlerParams = function () {
		var Locdr = $("#IngrLoc").combotree('getValue');
		var Obj = {
			Locdr:Locdr,
			StkGrpType: "M"
		};
		return Obj;
	};
	$("#InciDesc").lookup(InciLookUpOp(InciHandlerParams, '#InciDesc', '#Inci'));
	var LocParams=JSON.stringify(addSessionParams({Type:"Login"}));
	var LocBox = $HUI.combobox('#Loc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+LocParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var IngrLocParams = JSON.stringify(addSessionParams({
				Type: 'Login'
			}));
	var IngrLocBox = $HUI.combobox('#IngrLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + IngrLocParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	var VendorParams = JSON.stringify(addSessionParams({
				APCType: "M",
				RcFlag: "Y"
			}));
	var VendorBox = $HUI.combobox('#Vendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	var ReqLocParams = JSON.stringify(addSessionParams({
				Type: 'All'
			}));
	var ReqLocBox = $HUI.combobox('#ReqLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
			valueField: 'RowId',
			textField: 'Description'
		});

	ToolBar = [{
			text: '确认',
			iconCls: 'icon-accept',
			handler: function () {
				var Rows = GRMainGrid.getSelections();
				if (Rows.length <= 0) {
					$UI.msg('alert', '请选择要确认的单据!');
					return;
				}
				var ParamsObj = $UI.loopBlock('#MainConditions');
				var Main = JSON.stringify(ParamsObj);
				var Detail = GRMainGrid.getSelectedData();
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCIngRcRtInv',
					MethodName: 'Confirm',
					Main: Main,
					Detail: JSON.stringify(Detail)
				}, function (jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						Select();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}, {
			text: '取消确认',
			iconCls: 'icon-no',
			handler: function () {
				var Rows = GRMainGrid.getSelections();
				if (Rows.length <= 0) {
					$UI.msg('alert', '请选择要取消确认的单据!');
					return;
				}
				var Detail = GRMainGrid.getSelectedData();
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCIngRcRtInv',
					MethodName: 'CanConfirm',
					Params: JSON.stringify(Detail)
				}, function (jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						Select();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}
	];

	GRMainCm = [[{
				field: 'ck',
				checkbox: true
			}, {
				title: "RowId",
				field: 'RowId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: "类型",
				field: 'Type',
				saveCol: true,
				width: 60,
				formatter: function (value, row, index) {
					if (value == "G") {
						return "入库";
					} else {
						return "退货";
					}
				}
			}, {
				title: "Vendor",
				field: 'Vendor',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: "供应商",
				field: 'VendorDesc',
				width: 200
			}, {
				title: "接收科室",
				field: 'ReqLocDesc',
				width: 200
			}, {
				title: "单号",
				field: 'GRNo',
				saveCol: true,
				width: 200
			}, {
				title: "制单人",
				field: 'CreateUser',
				width: 80
			}, {
				title: "制单日期",
				field: 'CreateDate',
				width: 100
			}, {
				title: "审核人",
				field: 'AuditUser',
				width: 80
			}, {
				title: "审核日期",
				field: 'AuditDate',
				width: 100
			}, {
				title: "确认人",
				field: 'ComUser',
				width: 80
			}, {
				title: "确认日期",
				field: 'ComDate',
				width: 100
			}, {
				title: "进价金额",
				field: 'RpAmt',
				width: 100,
				align: 'right'
			}, {
				title: "已付金额",
				field: 'PayedAmt',
				width: 100,
				align: 'right'
			}, {
				title: "付清标志",
				field: 'PayOverFlag',
				width: 80
			}
		]];

	GRMainGrid = $UI.datagrid('#GRMainGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCINGdRecInv',
				QueryName: 'DHCINGdRecList'
			},
			toolbar: ToolBar,
			singleSelect: false,
			checkOnSelect: false,
			columns: GRMainCm,
			onCheck: function (index, row) {
				SelectDetail();
			},
			onUncheck: function (index, Row){
				SelectDetail();
			},
			onCheckAll: function(rows){
				SelectDetail();
			},
			onUncheckAll: function(rows){
				$UI.clear(GRDetailGrid);
			},
			onLoadSuccess: function (data) {
				if (data.rows.length > 0) {
					GRMainGrid.checkRow(0);
					SelectDetail();
				}
			}
		});

	DetailToolBar = [{
			text: '<div id="CopyBox"><select id="SelectCopy" name="SelectCopy" class="hisui-combobox" style="width:200px;">'
			 + '<option value="" selected disabled>请选择复制或清除信息...</option>'
			 + '<option value="1">发票信息</option>'
			 + '<option value="2">随行单号</option></select></div>'
		}, {
			text: '复制',
			iconCls: 'icon-copy',
			handler: function () {
				GRDetailGrid.endEditing();
				var SelectCopy = $("#SelectCopy").combo('getValue');
				if (SelectCopy == "" || SelectCopy == null) {
					$UI.msg('alert', '请选择复制信息!');
					return;
				}
				var Rows = GRDetailGrid.getRows();
				if (SelectCopy == 1) {
					var InvNo = Rows[0].InvNo;
					if (InvNo == null || InvNo == "") {
						$UI.msg('alert', '请在第一行输入发票号等信息!');
						return;
					}
					var InvDate = Rows[0].InvDate;
					for (var i = 1; i < Rows.length; i++) {
						Rows[i].InvNo = InvNo;
						Rows[i].InvDate = InvDate;
						var RowIndex = $('#GRDetailGrid').datagrid('getRowIndex', Rows[i]);
						$('#GRDetailGrid').datagrid('refreshRow', RowIndex);
					}
				}
				if (SelectCopy == 2) {
					var SxNo = Rows[0].SxNo;
					if (SxNo == null || SxNo == "") {
						$UI.msg('alert', '请在第一行输入随行单号!');
						return;
					}
					for (var i = 1; i < Rows.length; i++) {
						Rows[i].SxNo = SxNo;
						var RowIndex = $('#GRDetailGrid').datagrid('getRowIndex', Rows[i]);
						$('#GRDetailGrid').datagrid('refreshRow', RowIndex);
					}
				}
			}
		}, {
			text: '清除',
			iconCls: 'icon-clear-screen',
			handler: function () {
				var SelectCopy = $("#SelectCopy").combo('getValue');
				if (SelectCopy == "" || SelectCopy == null) {
					$UI.msg('alert', '请选择清除信息!');
					return;
				}
				var Rows = GRDetailGrid.getRows();
				if (SelectCopy == 1) {
					for (var i = 0; i < Rows.length; i++) {
						Rows[i].InvNo = "";
						Rows[i].InvDate = "";
						Rows[i].InvAmt = 0;
						var RowIndex = $('#GRDetailGrid').datagrid('getRowIndex', Rows[i]);
						$('#GRDetailGrid').datagrid('refreshRow', RowIndex);
					}
				}
				if (SelectCopy == 2) {
					for (var i = 0; i < Rows.length; i++) {
						Rows[i].SxNo = "";
						var RowIndex = $('#GRDetailGrid').datagrid('getRowIndex', Rows[i]);
						$('#GRDetailGrid').datagrid('refreshRow', RowIndex);
					}
				}

			}
		}, '-', {
			text: '保存',
			iconCls: 'icon-save',
			handler: function () {
				GRDetailGrid.endEditing();
				var Rows = GRDetailGrid.getRows();
				if (Rows.length <= 0) {
					$UI.msg('alert', '没有需要保存的单据!');
					return;
				}
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCINGdRecInv',
					MethodName: 'Save',
					Params: JSON.stringify(Rows)
				}, function (jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						GRDetailGrid.commonReload();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}
	];

	GRDetailCm = [[{
				title: "RowId",
				field: 'RowId',
				width: 50,
				hidden: true,
				saveCol: true
			}, {
				title: "IncId",
				field: 'IncId',
				width: 50,
				hidden: true
			}, {
				title: "物资代码",
				field: 'Code',
				width: 150
			}, {
				title: "物资名称",
				field: 'Description',
				width: 200
			}, {
				title: "规格",
				field: 'Spec',
				width: 100
			}, {
				title: "批号",
				field: 'BatchNo',
				width: 100
			}, {
				title: "有效期",
				field: 'ExpDate',
				width: 100
			}, {
				title: "单位",
				field: 'UomDesc',
				width: 80
			}, {
				title: "数量",
				field: 'Qty',
				width: 80,
				align: 'right'
			}, {
				title: "进价",
				field: 'Rp',
				width: 80,
				align: 'right'
			}, {
				title: "进价金额",
				field: 'RpAmt',
				width: 80,
				align: 'right'
			}, {
				title: "售价",
				field: 'Sp',
				width: 80,
				align: 'right'
			}, {
				title: "售价金额",
				field: 'SpAmt',
				width: 80,
				align: 'right'
			}, {
				title: "厂商",
				field: 'Manf',
				width: 200
			}, {
				title: "发票号",
				field: 'InvNo',
				width: 100,
				saveCol: true,
				editor: {
					type: 'text'
				}
			}, {
				title: "发票日期",
				field: 'InvDate',
				width: 100,
				saveCol: true,
				editor: {
					type: 'datebox'
				}
			}, {
				title: "发票金额",
				field: 'InvAmt',
				width: 100,
				align: 'right',
				saveCol: true,
				editor: {
					type: 'numberbox'
				}
			}, {
				title: "随行单号",
				field: 'SxNo',
				width: 100,
				saveCol: true,
				editor: {
					type: 'text'
				}
			}, {
				title: "类型",
				field: 'Type',
				saveCol: true,
				hidden: true,
				width: 60,
				formatter: function (value, row, index) {
					if (value == "G") {
						return "入库";
					} else {
						return "退货";
					}
				}
			}
		]];

	GRDetailGrid = $UI.datagrid('#GRDetailGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				QueryName: 'GetIngdRecItm',
				rows: 99999
			},
			pagination:false,
			toolbar: DetailToolBar,
			columns: GRDetailCm,
			onClickCell: function (index, filed, value) {
				GRDetailGrid.commonClickCell(index, filed)
			},
			onAfterEdit: function (index, row, changes) {
				if (changes.hasOwnProperty('InvNo')) {
					var Ingri=row.RowId;
					var IngrId = Ingri.split("||")[0];
					var flag = InvNoValidator(row.InvNo, IngrId);
					if (flag == false) {
						$UI.msg('alert', "发票号" + row.InvNo + "已存在于别的入库单!");
						$(this).datagrid('updateRow', {
							index: index,
							row: {
								InvNo: ''
							}
						});
						return;
					}
				}
			}
		});

	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			$UI.clear(GRMainGrid);
			$UI.clear(GRDetailGrid);
			var ParamsObj = $UI.loopBlock('#MainConditions');
			if (isEmpty(ParamsObj.IngrLoc)) {
				$UI.msg('alert', '入库科室不能为空!');
				return;
			}
			if (isEmpty(ParamsObj.StartDate)) {
				$UI.msg('alert', '起始日期不能为空!');
				return;
			}
			if (isEmpty(ParamsObj.EndDate)) {
				$UI.msg('alert', '截止日期不能为空!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			GRMainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRecInv',
				QueryName: 'DHCINGdRecList',
				Params: Params
			});
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			$('#SelectCopy').combobox('clear');
			$UI.clearBlock('#MainConditions');
			$UI.clear(GRMainGrid);
			$UI.clear(GRDetailGrid);
			SetDefaValues();
		}
	});

	SetDefaValues();
	$.parser.parse('#CopyBox');
}
$(init);
function Select() {
	$UI.clear(GRMainGrid);
	$UI.clear(GRDetailGrid);
	GRMainGrid.commonReload();
}
function SelectDetail(){
	var Rows = GRMainGrid.getSelections();
	if (Rows.length <= 0) {
		$UI.clear(GRDetailGrid);
		return;
	}
	var Params = GRMainGrid.getSelectedData();
	GRDetailGrid.load({
		ClassName: 'web.DHCSTMHUI.DHCVendorInv',
		QueryName: 'GetIngdRecItm',
		Params: JSON.stringify(Params),
		rows: 99999
	});
}