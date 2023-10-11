var GRMainGrid, GRDetailGrid;
var GRMainCm, GRDetailCm, ToolBar;
var init = function() {
	var InciHandlerParams = function() {
		var Locdr = $('#IngrLoc').combotree('getValue');
		var Obj = {
			Locdr: Locdr,
			StkGrpType: 'M'
		};
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(InciHandlerParams, '#InciDesc', '#Inci'));
	var IngrLocParams = JSON.stringify(addSessionParams({
		Type: 'Login',
		Element: 'IngrLoc'
	}));
	var IngrLocBox = $HUI.combobox('#IngrLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + IngrLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var ReqLocParams = JSON.stringify(addSessionParams({
		Type: 'All',
		Element: 'ReqLoc'
	}));
	var ReqLocBox = $HUI.combobox('#ReqLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var InvFlag = $HUI.combobox('#InvFlag', {
		data: [{
			'RowId': '""',
			'Description': 'ȫ��'
		}, {
			'RowId': 'Y',
			'Description': 'ȫ��¼��'
		}, {
			'RowId': 'N',
			'Description': 'δȫ��¼��'
		}],
		valueField: 'RowId',
		textField: 'Description'
	});

	GRMainCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '����',
			field: 'Type',
			saveCol: true,
			width: 60,
			formatter: function(value, row, index) {
				if (value == 'G') {
					return '���';
				} else if (value == 'R') {
					return '�˻�';
				}
			}
		}, {
			title: 'Vendor',
			field: 'Vendor',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '��Ӧ��',
			field: 'VendorDesc',
			width: 200
		}, {
			title: '���տ���',
			field: 'ReqLocDesc',
			width: 200
		}, {
			title: '����',
			field: 'GRNo',
			saveCol: true,
			width: 200
		}, {
			title: '�Ƶ���',
			field: 'CreateUser',
			width: 80
		}, {
			title: '�Ƶ�����',
			field: 'CreateDate',
			width: 100
		}, {
			title: '�����',
			field: 'AuditUser',
			width: 80
		}, {
			title: '�������',
			field: 'AuditDate',
			width: 100
		}, {
			title: 'ȷ����',
			field: 'ComUser',
			width: 80
		}, {
			title: 'ȷ������',
			field: 'ComDate',
			width: 100
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '�Ѹ����',
			field: 'PayedAmt',
			width: 100,
			align: 'right'
		}, {
			title: '�����־',
			field: 'PayOverFlag',
			width: 80
		}, {
			title: 'ConfirmStatus',
			field: 'ConfirmStatus',
			width: 50,
			hidden: true
		}
	]];

	GRMainGrid = $UI.datagrid('#GRMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecInv',
			QueryName: 'DHCINGdRecList',
			query2JsonStrict: 1,
			totalFooter: '"VendorDesc":"�ϼ�"',
			totalFields: 'RpAmt,PayedAmt'
		},
		singleSelect: false,
		checkOnSelect: true,
		columns: GRMainCm,
		showBar: true,
		showFooter: true,
		onCheck: function(index, row) {
			SelectDetail();
		},
		onUncheck: function(index, Row) {
			SelectDetail();
		},
		onCheckAll: function(rows) {
			SelectDetail();
		},
		onUncheckAll: function(rows) {
			$UI.clear(GRDetailGrid);
		},
		onLoadSuccess: function(data) {
			if ((data.rows.length > 0) && (CommParObj.IfSelFirstRow == 'Y')) {
				GRMainGrid.checkRow(0);
				SelectDetail();
			}
		}
	});

	DetailToolBar = [{
		text: '<div id="CopyBox"><select id="SelectCopy" name="SelectCopy" class="hisui-combobox" style="width:200px;">'
				+ '<option value="" selected disabled>��ѡ���ƻ������Ϣ����...</option>'
				+ '<option value="1">��Ʊ��Ϣ</option>'
				+ '<option value="2">���е���</option></select></div>'
	}, {
		text: '����',
		iconCls: 'icon-copy',
		handler: function() {
			if (!GRDetailGrid.endEditing()) {
				return;
			}
			var SelectCopy = $('#SelectCopy').combo('getValue');
			if (SelectCopy == '' || SelectCopy == null) {
				$UI.msg('alert', '��ѡ������Ϣ����!');
				return;
			}
			var Rows = GRDetailGrid.getRows();
			if (SelectCopy == 1) {
				var InvCode = Rows[0].InvCode;
				var InvNo = Rows[0].InvNo;
				var InvDate = Rows[0].InvDate;
				if (isEmpty(InvCode) || isEmpty(InvNo)) {
					$UI.msg('alert', '���ڵ�һ�����뷢Ʊ���롢��Ʊ�ŵ���Ϣ!');
					return;
				}
				for (var i = 1; i < Rows.length; i++) {
					Rows[i].InvCode = InvCode;
					Rows[i].InvNo = InvNo;
					Rows[i].InvDate = InvDate;
					var RowIndex = $('#GRDetailGrid').datagrid('getRowIndex', Rows[i]);
					$('#GRDetailGrid').datagrid('refreshRow', RowIndex);
				}
			}
			if (SelectCopy == 2) {
				var SxNo = Rows[0].SxNo;
				if (SxNo == null || SxNo == '') {
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
		handler: function() {
			var SelectCopy = $('#SelectCopy').combo('getValue');
			if (SelectCopy == '' || SelectCopy == null) {
				$UI.msg('alert', '��ѡ�������Ϣ����!');
				return;
			}
			var Rows = GRDetailGrid.getRows();
			if (SelectCopy == 1) {
				for (var i = 0; i < Rows.length; i++) {
					Rows[i].InvCode = '';
					Rows[i].InvNo = '';
					Rows[i].InvDate = '';
					// Rows[i].InvAmt = 0;
					var RowIndex = $('#GRDetailGrid').datagrid('getRowIndex', Rows[i]);
					$('#GRDetailGrid').datagrid('refreshRow', RowIndex);
				}
			}
			if (SelectCopy == 2) {
				for (var i = 0; i < Rows.length; i++) {
					Rows[i].SxNo = '';
					var RowIndex = $('#GRDetailGrid').datagrid('getRowIndex', Rows[i]);
					$('#GRDetailGrid').datagrid('refreshRow', RowIndex);
				}
			}
		}
	}, '-', {
		text: '����',
		iconCls: 'icon-save',
		handler: function() {
			if (!GRDetailGrid.endEditing()) {
				return;
			}
			var Rows = GRDetailGrid.getRows();
			if (Rows.length <= 0) {
				$UI.msg('alert', 'û����Ҫ����ĵ���!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINGdRecInv',
				MethodName: 'Save',
				Params: JSON.stringify(Rows)
			}, function(jsonData) {
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

	GRDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true,
			saveCol: true
		}, {
			title: 'IncId',
			field: 'IncId',
			width: 50,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'Code',
			width: 150
		}, {
			title: '��������',
			field: 'Description',
			width: 200
		}, {
			title: '��Ʊ����',
			field: 'InvCode',
			width: 100,
			saveCol: true,
			editor: {
				type: 'text'
			}
		}, {
			title: '��Ʊ��',
			field: 'InvNo',
			width: 100,
			saveCol: true,
			editor: {
				type: 'text'
			}
		}, {
			title: '��Ʊ����',
			field: 'InvDate',
			width: 100,
			saveCol: true,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '��Ʊ���',
			field: 'InvAmt',
			width: 100,
			align: 'right',
			saveCol: true,
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: GetFmtNum('FmtRP')
				}
			}
		}, {
			title: '���е���',
			field: 'SxNo',
			width: 100,
			saveCol: true,
			editor: {
				type: 'text'
			}
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 80
		}, {
			title: '����',
			field: 'Qty',
			width: 80,
			align: 'right'
		}, {
			title: '����',
			field: 'Rp',
			width: 80,
			align: 'right'
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '�ۼ�',
			field: 'Sp',
			width: 80,
			align: 'right'
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '��������',
			field: 'Manf',
			width: 200
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '����',
			field: 'BatchNo',
			width: 100
		}, {
			title: '��Ч��',
			field: 'ExpDate',
			width: 100
		}, {
			title: '����',
			field: 'Type',
			saveCol: true,
			hidden: true,
			width: 60,
			formatter: function(value, row, index) {
				if (value == 'G') {
					return '���';
				} else if (value == 'R') {
					return '�˻�';
				}
			}
		}
	]];

	GRDetailGrid = $UI.datagrid('#GRDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecInv',
			QueryName: 'GetIngdRecItm',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		toolbar: DetailToolBar,
		columns: GRDetailCm,
		showBar: true,
		onClickRow: function(index, row) {
			GRDetailGrid.commonClickRow(index, row);
		},
		onAfterEdit: function(index, row, changes) {
			if (changes.hasOwnProperty('InvNo')) {
				var Ingri = row.RowId;
				var IngrId = Ingri.split('||')[0];
				var flag = InvNoValidator(row.InvNo, IngrId, row.InvCode);
				if (flag == false) {
					$UI.msg('alert', '��Ʊ��' + row.InvNo + '�Ѵ����ڱ����ⵥ!');
					/* $(this).datagrid('updateRow', {
							index: index,
							row: {
								InvNo: '',
								InvCode: '',
								InvDate: ''
							}
						});
						return;
						*/
				}
			}
		},
		onBeforeEdit: function(index, row) {
			if (row.ConfirmStatus === 'Y') {
				$UI.msg('alert', '��Ʊ��ȷ���޷��޸�!');
				return false;
			}
		},
		onBeginEdit: function(index, row) {
			$(this).datagrid('beginEdit', index);
			var ed = $(this).datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var e = ed[i];
				if ((e.field == 'InvCode') || (e.field == 'InvNo')) {
					$(e.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var InvInfo = $(this).val();
							SetInvInfo(InvInfo);
						}
					});
				}
			}
		}
	});
		
	function SetInvInfo(InvInfo) {
		var InvObj = GetInvInfo(InvInfo);
		if (InvObj === false) {
			$UI.msg('alert', '��¼����ȷ�ķ�Ʊ��Ϣ!');
			return;
		} else if (!isEmpty(InvObj)) {
			var InvCode = InvObj.InvCode;
			var InvNo = InvObj.InvNo;
			var InvAmt = InvObj.InvAmt;
			var InvDate = InvObj.InvDate;
			GRDetailGrid.updateRow({
				index: GRDetailGrid.editIndex,
				row: {
					InvCode: InvCode,
					InvNo: InvNo,
					// InvAmt:InvAmt,
					InvDate: InvDate
				}
			});
			$('#GRDetailGrid').datagrid('refreshRow', GRDetailGrid.editIndex);
		}
	}
	
	$UI.linkbutton('#ConfirmBT', {
		onClick: function() {
			Confirm();
		}
	});
	
	function Confirm() {
		var Rows = GRMainGrid.getSelections();
		if (Rows.length <= 0) {
			$UI.msg('alert', '��ѡ��Ҫȷ�ϵĵ���!');
			return;
		}
		var ParamsObj = $UI.loopBlock('#MainConditions');
		var Main = JSON.stringify(ParamsObj);
		var Detail = GRMainGrid.getSelectedData();
		var DetailRows = GRDetailGrid.getRows();
		for (var i = 0; i < DetailRows.length; i++) {
			var InvCode = DetailRows[i].InvCode;
			var InvNo = DetailRows[i].InvNo;
			if (isEmpty(InvNo)) {
				$UI.msg('alert', '������ϸ��Ʊ��Ϣ������������ȷ��!');
				return;
			}
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRecInv',
			MethodName: 'Confirm',
			Main: Main,
			Detail: JSON.stringify(Detail)
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Select();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#CancelConfirmBT', {
		onClick: function() {
			CancelConfirm();
		}
	});
	function CancelConfirm() {
		var Rows = GRMainGrid.getSelections();
		if (Rows.length <= 0) {
			$UI.msg('alert', '��ѡ��Ҫȡ��ȷ�ϵĵ���!');
			return;
		}
		var Detail = GRMainGrid.getSelectedData();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRecInv',
			MethodName: 'CanConfirm',
			Main: JSON.stringify(addSessionParams({})),
			Params: JSON.stringify(Detail)
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Select();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	
	function Query() {
		$UI.clear(GRMainGrid);
		$UI.clear(GRDetailGrid);
		var ParamsObj = $UI.loopBlock('#MainConditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (isEmpty(ParamsObj.IngrLoc)) {
			$UI.msg('alert', '�����Ҳ���Ϊ��!');
			return;
		}
		if (isEmpty(StartDate)) {
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return;
		}
		if (compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���С�ڿ�ʼ����!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		GRMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINGdRecInv',
			QueryName: 'DHCINGdRecList',
			query2JsonStrict: 1,
			Params: Params,
			totalFooter: '"VendorDesc":"�ϼ�"',
			totalFields: 'RpAmt,PayedAmt'
		});
	}

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$('#SelectCopy').combobox('clear');
			$UI.clearBlock('#MainConditions');
			$UI.clear(GRMainGrid);
			$UI.clear(GRDetailGrid);
			SetDefaValues();
		}
	});
	function SetDefaValues() {
		var DefaultValue = {
			IngrLoc: gLocObj,
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate()
		};
		$UI.fillBlock('#MainConditions', DefaultValue);
	}
	SetDefaValues();
	Query();
	$.parser.parse('#CopyBox');
};
$(init);
function Select() {
	$UI.clear(GRMainGrid);
	$UI.clear(GRDetailGrid);
	GRMainGrid.commonReload();
}
function SelectDetail() {
	var Rows = GRMainGrid.getChecked();
	if (Rows.length <= 0) {
		$UI.clear(GRDetailGrid);
		return;
	}
	var Params = GRMainGrid.getSelectedData();
	GRDetailGrid.load({
		ClassName: 'web.DHCSTMHUI.DHCINGdRecInv',
		QueryName: 'GetIngdRecItm',
		query2JsonStrict: 1,
		Params: JSON.stringify(Params),
		rows: 99999
	});
}