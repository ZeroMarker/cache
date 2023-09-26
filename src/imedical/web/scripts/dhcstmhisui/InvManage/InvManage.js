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
			text: 'ȷ��',
			iconCls: 'icon-accept',
			handler: function () {
				var Rows = GRMainGrid.getSelections();
				if (Rows.length <= 0) {
					$UI.msg('alert', '��ѡ��Ҫȷ�ϵĵ���!');
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
			text: 'ȡ��ȷ��',
			iconCls: 'icon-no',
			handler: function () {
				var Rows = GRMainGrid.getSelections();
				if (Rows.length <= 0) {
					$UI.msg('alert', '��ѡ��Ҫȡ��ȷ�ϵĵ���!');
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
				title: "����",
				field: 'Type',
				saveCol: true,
				width: 60,
				formatter: function (value, row, index) {
					if (value == "G") {
						return "���";
					} else {
						return "�˻�";
					}
				}
			}, {
				title: "Vendor",
				field: 'Vendor',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: "��Ӧ��",
				field: 'VendorDesc',
				width: 200
			}, {
				title: "���տ���",
				field: 'ReqLocDesc',
				width: 200
			}, {
				title: "����",
				field: 'GRNo',
				saveCol: true,
				width: 200
			}, {
				title: "�Ƶ���",
				field: 'CreateUser',
				width: 80
			}, {
				title: "�Ƶ�����",
				field: 'CreateDate',
				width: 100
			}, {
				title: "�����",
				field: 'AuditUser',
				width: 80
			}, {
				title: "�������",
				field: 'AuditDate',
				width: 100
			}, {
				title: "ȷ����",
				field: 'ComUser',
				width: 80
			}, {
				title: "ȷ������",
				field: 'ComDate',
				width: 100
			}, {
				title: "���۽��",
				field: 'RpAmt',
				width: 100,
				align: 'right'
			}, {
				title: "�Ѹ����",
				field: 'PayedAmt',
				width: 100,
				align: 'right'
			}, {
				title: "�����־",
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
			 + '<option value="" selected disabled>��ѡ���ƻ������Ϣ...</option>'
			 + '<option value="1">��Ʊ��Ϣ</option>'
			 + '<option value="2">���е���</option></select></div>'
		}, {
			text: '����',
			iconCls: 'icon-copy',
			handler: function () {
				GRDetailGrid.endEditing();
				var SelectCopy = $("#SelectCopy").combo('getValue');
				if (SelectCopy == "" || SelectCopy == null) {
					$UI.msg('alert', '��ѡ������Ϣ!');
					return;
				}
				var Rows = GRDetailGrid.getRows();
				if (SelectCopy == 1) {
					var InvNo = Rows[0].InvNo;
					if (InvNo == null || InvNo == "") {
						$UI.msg('alert', '���ڵ�һ�����뷢Ʊ�ŵ���Ϣ!');
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
						$UI.msg('alert', '���ڵ�һ���������е���!');
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
			text: '���',
			iconCls: 'icon-clear-screen',
			handler: function () {
				var SelectCopy = $("#SelectCopy").combo('getValue');
				if (SelectCopy == "" || SelectCopy == null) {
					$UI.msg('alert', '��ѡ�������Ϣ!');
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
			text: '����',
			iconCls: 'icon-save',
			handler: function () {
				GRDetailGrid.endEditing();
				var Rows = GRDetailGrid.getRows();
				if (Rows.length <= 0) {
					$UI.msg('alert', 'û����Ҫ����ĵ���!');
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
				title: "���ʴ���",
				field: 'Code',
				width: 150
			}, {
				title: "��������",
				field: 'Description',
				width: 200
			}, {
				title: "���",
				field: 'Spec',
				width: 100
			}, {
				title: "����",
				field: 'BatchNo',
				width: 100
			}, {
				title: "��Ч��",
				field: 'ExpDate',
				width: 100
			}, {
				title: "��λ",
				field: 'UomDesc',
				width: 80
			}, {
				title: "����",
				field: 'Qty',
				width: 80,
				align: 'right'
			}, {
				title: "����",
				field: 'Rp',
				width: 80,
				align: 'right'
			}, {
				title: "���۽��",
				field: 'RpAmt',
				width: 80,
				align: 'right'
			}, {
				title: "�ۼ�",
				field: 'Sp',
				width: 80,
				align: 'right'
			}, {
				title: "�ۼ۽��",
				field: 'SpAmt',
				width: 80,
				align: 'right'
			}, {
				title: "����",
				field: 'Manf',
				width: 200
			}, {
				title: "��Ʊ��",
				field: 'InvNo',
				width: 100,
				saveCol: true,
				editor: {
					type: 'text'
				}
			}, {
				title: "��Ʊ����",
				field: 'InvDate',
				width: 100,
				saveCol: true,
				editor: {
					type: 'datebox'
				}
			}, {
				title: "��Ʊ���",
				field: 'InvAmt',
				width: 100,
				align: 'right',
				saveCol: true,
				editor: {
					type: 'numberbox'
				}
			}, {
				title: "���е���",
				field: 'SxNo',
				width: 100,
				saveCol: true,
				editor: {
					type: 'text'
				}
			}, {
				title: "����",
				field: 'Type',
				saveCol: true,
				hidden: true,
				width: 60,
				formatter: function (value, row, index) {
					if (value == "G") {
						return "���";
					} else {
						return "�˻�";
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
						$UI.msg('alert', "��Ʊ��" + row.InvNo + "�Ѵ����ڱ����ⵥ!");
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
				$UI.msg('alert', '�����Ҳ���Ϊ��!');
				return;
			}
			if (isEmpty(ParamsObj.StartDate)) {
				$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
				return;
			}
			if (isEmpty(ParamsObj.EndDate)) {
				$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
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