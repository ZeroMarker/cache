var init = function () {
	var whiteColor = '#FFFFFF';
	var yellowColor = '#FFFF00';
	var LocParams = JSON.stringify(addSessionParams({
		Type: 'Login'
	}));
	var LocBox = $HUI.combobox('#Loc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$('#Loc').combobox('setValue', gLocId);

	var UserBox = {
		type: 'combobox',
		options: {
			//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetUser&ResultSetType=array&Params='+JSON.stringify(addSessionParams()),
			valueField: 'RowId',
			textField: 'Description',
			defaultFilter:4,
			onSelect: function (record) {
				var rows = DetailGrid.getRows();
				var row = rows[DetailGrid.editIndex];
				row.UserDesc = record.Description;
			},
			onShowPanel: function () {
				$(this).combobox('clear');
				var Locid=$('#Loc').combobox('getValue');
				var url= $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=array&Params='+JSON.stringify(addSessionParams({LocDr:Locid}));
				$(this).combobox('reload',url);
			}
		}
	};

	var ToolBar = [{
		text: '新增',
		iconCls: 'icon-add',
		handler: function () {
			Add();
		}
	}, {
		text: '保存',
		iconCls: 'icon-save',
		handler: function () {
			Save();
		}
	}
	];

	var MasterCm = [[{
		title: "RowId",
		field: 'RowId',
		width: 50,
		hidden: true
	}, {
		title: "代码",
		field: 'GrpCode',
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		},
		width: 150
	}, {
		title: "名称",
		field: 'GrpDesc',
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		},
		width: 180
	}, {
		title: "生效起始日期",
		field: 'DateFrom',
		editor: {
			type: 'datebox'
		},
		width: 100
	}, {
		title: "生效截止日期",
		field: 'DateTo',
		editor: {
			type: 'datebox'
		},
		width: 100
	}
	]];

	var MasterGrid = $UI.datagrid('#MasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCSubLocUserGroup',
			QueryName: 'LocGroupList'
		},
		pagination: false,
		toolbar: ToolBar,
		columns: MasterCm,
		onSelect: function (index, row) {
			$UI.clear(DetailGrid);
			DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCSubLocUserGroup',
				QueryName: 'GroupUserList',
				Parref: row.RowId
			});
		},
		onLoadSuccess: function (data) {
			if (data.rows.length > 0) {
				MasterGrid.selectRow(0);
			}
		},
		onDblClickCell: function (index, field, value) {
			MasterGrid.commonClickCell(index, field);
		},
		onEndEdit: function (index, row, changes) {
				if ((changes.hasOwnProperty('DateFrom'))||(changes.hasOwnProperty('DateTo'))) {
					var DateFrom = row.DateFrom;
					var DateTo = row.DateTo;
					if ((!isEmpty(DateFrom)) &&(!isEmpty(DateTo)) && (FormatDate(DateFrom) > FormatDate(DateTo))) {
						$UI.msg('alert', "起始日期不能大于截止日期!");
						MasterGrid.checked = false;
						return false;
					}
				}
		}
	});

	var DetailToolBar = [{
		text: '保存',
		iconCls: 'icon-save',
		handler: function () {
			SaveDetail();
		}
	}
	];

	var DetailCm = [[{
		title: "RowId",
		field: 'RowId',
		width: 50,
		hidden: true
	}, {
		title: "人员",
		field: 'User',
		width: 150,
		formatter: CommonFormatter(UserBox, 'User', 'UserDesc'),
		editor: UserBox
	}, {
		title: "生效起始日期",
		field: 'DateFrom',
		editor: {
			type: 'datebox'
		},
		width: 120
	}, {
		title: "生效截止日期",
		field: 'DateTo',
		editor: {
			type: 'datebox'
		},
		width: 120
	}, {
		title: "请领权限",
		field: 'ReqFlag',
		align: 'center',
		editor: {
			type: 'icheckbox',
			options: {
				on: 'Y',
				off: 'N'
			}
		},
		formatter: function (v) {
			if (v == "Y") {
				return "是"
			} else {
				return "否"
			}
		},
		width: 80
	}
	]];

	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCSubLocUserGroup',
			QueryName: 'GroupUserList'
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCSubLocUserGroup',
			MethodName: 'DeleteDetail'
		},
		toolbar: DetailToolBar,
		columns: DetailCm,
		showAddDelItems: true,
		onDblClickCell: function (index, field, value) {
			DetailGrid.commonClickCell(index, field);
		},
		onEndEdit: function (index, row, changes) {
			if ((changes.hasOwnProperty('DateFrom'))||(changes.hasOwnProperty('DateTo'))) {
				var DateFrom = row.DateFrom;
				var DateTo = row.DateTo;
				if ((!isEmpty(DateFrom)) &&(!isEmpty(DateTo)) && (FormatDate(DateFrom) > FormatDate(DateTo))) {
					$UI.msg('alert', "起始日期不能大于截止日期!");
					DetailGrid.checked = false;
					return false;
				}
			}
		}
	});

	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			Query();
		}
	});

	function Query() {
		var ParamsObj = $UI.loopBlock('#MainConditions');
		if (isEmpty(ParamsObj.Loc)) {
			$UI.msg('alert', '请选择科室!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		MasterGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCSubLocUserGroup',
			QueryName: 'LocGroupList',
			Params: Params
		});
	}

	function Add() {
		if (isEmpty($HUI.combobox('#Loc').getValue())) {
			$UI.msg('alert', '请选择科室!');
			return;
		}
		MasterGrid.commonAddRow();
	}

	function Save() {
		var MainObj = $UI.loopBlock('#MainConditions');
		if (isEmpty(MainObj.Loc)) {
			$UI.msg('alert', '请选择科室!');
			return;
		}
		var Main = JSON.stringify(MainObj);
		var Detail = MasterGrid.getChangesData();
		if (Detail === false){	//未完成编辑或明细为空
			return;
		}
		if (isEmpty(Detail)){	//明细不变
			$UI.msg("alert", "没有需要保存的明细!");
			return;
		}
		var rowData = MasterGrid.getRows();
		var rowCount = rowData.length;
		for (var i = 0; i < rowCount; i++) {
			SetGridBgColor(MasterGrid,i,'RowId',whiteColor);
		}
		var count=0;
		for (var i = 0; i < rowCount; i++) {
			var DateFrom = rowData[i].DateFrom;
			var DateTo = rowData[i].DateTo;
			if ((!isEmpty(DateFrom)) &&(!isEmpty(DateTo)) && (FormatDate(DateFrom) > FormatDate(DateTo))) {
				SetGridBgColor(MasterGrid,i,'RowId',yellowColor);
				count=count+1;
				continue;
			}
		}
		if (count>0){
			$UI.msg('alert', '以下汇总明细截止日期大于起始日期!');
			return false;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCSubLocUserGroup',
			MethodName: 'Save',
			Main: Main,
			Detail: JSON.stringify(Detail)
		}, function (jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				$UI.clear(MasterGrid);
				$UI.clear(DetailGrid);
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	function SaveDetail() {
		var RowData = MasterGrid.getSelected();
		if (RowData == null || RowData == "") {
			$UI.msg('alert', '请选择专业组信息!');
			return;
		}
		var MRowId = RowData.RowId;
		if (MRowId == null || MRowId == "") {
			$UI.msg('alert', '请先保存此专业组信息!');
			return;
		}
		var Detail = DetailGrid.getChangesData();
		if (Detail === false){	//未完成编辑或明细为空
			return;
		}
		if (isEmpty(Detail)){	//明细不变
			$UI.msg("alert", "没有需要保存的明细!");
			return;
		}
		var rowData = DetailGrid.getRows();
		var rowCount = rowData.length;
		for (var i = 0; i < rowCount; i++) {
			SetGridBgColor(DetailGrid,i,'RowId',whiteColor);
		}
		var count=0;
		for (var i = 0; i < rowCount; i++) {
			var DateFrom = rowData[i].DateFrom;
			var DateTo = rowData[i].DateTo;
			if ((!isEmpty(DateFrom)) &&(!isEmpty(DateTo)) && (FormatDate(DateFrom) > FormatDate(DateTo))) {
				SetGridBgColor(DetailGrid,i,'RowId',yellowColor);
				count=count+1;
				continue;
			}
		}
		if (count>0){
			$UI.msg('alert', '以下汇总明细截止日期大于起始日期!');
			return false;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCSubLocUserGroup',
			MethodName: 'SaveDetail',
			Parref: MRowId,
			Detail: JSON.stringify(Detail)
		}, function (jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				$UI.clear(DetailGrid);
				DetailGrid.commonReload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
}
$(init);
