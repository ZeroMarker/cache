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
		text: '����',
		iconCls: 'icon-add',
		handler: function () {
			Add();
		}
	}, {
		text: '����',
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
		title: "����",
		field: 'GrpCode',
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		},
		width: 150
	}, {
		title: "����",
		field: 'GrpDesc',
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		},
		width: 180
	}, {
		title: "��Ч��ʼ����",
		field: 'DateFrom',
		editor: {
			type: 'datebox'
		},
		width: 100
	}, {
		title: "��Ч��ֹ����",
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
						$UI.msg('alert', "��ʼ���ڲ��ܴ��ڽ�ֹ����!");
						MasterGrid.checked = false;
						return false;
					}
				}
		}
	});

	var DetailToolBar = [{
		text: '����',
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
		title: "��Ա",
		field: 'User',
		width: 150,
		formatter: CommonFormatter(UserBox, 'User', 'UserDesc'),
		editor: UserBox
	}, {
		title: "��Ч��ʼ����",
		field: 'DateFrom',
		editor: {
			type: 'datebox'
		},
		width: 120
	}, {
		title: "��Ч��ֹ����",
		field: 'DateTo',
		editor: {
			type: 'datebox'
		},
		width: 120
	}, {
		title: "����Ȩ��",
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
				return "��"
			} else {
				return "��"
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
					$UI.msg('alert', "��ʼ���ڲ��ܴ��ڽ�ֹ����!");
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
			$UI.msg('alert', '��ѡ�����!');
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
			$UI.msg('alert', '��ѡ�����!');
			return;
		}
		MasterGrid.commonAddRow();
	}

	function Save() {
		var MainObj = $UI.loopBlock('#MainConditions');
		if (isEmpty(MainObj.Loc)) {
			$UI.msg('alert', '��ѡ�����!');
			return;
		}
		var Main = JSON.stringify(MainObj);
		var Detail = MasterGrid.getChangesData();
		if (Detail === false){	//δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Detail)){	//��ϸ����
			$UI.msg("alert", "û����Ҫ�������ϸ!");
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
			$UI.msg('alert', '���»�����ϸ��ֹ���ڴ�����ʼ����!');
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
			$UI.msg('alert', '��ѡ��רҵ����Ϣ!');
			return;
		}
		var MRowId = RowData.RowId;
		if (MRowId == null || MRowId == "") {
			$UI.msg('alert', '���ȱ����רҵ����Ϣ!');
			return;
		}
		var Detail = DetailGrid.getChangesData();
		if (Detail === false){	//δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Detail)){	//��ϸ����
			$UI.msg("alert", "û����Ҫ�������ϸ!");
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
			$UI.msg('alert', '���»�����ϸ��ֹ���ڴ�����ʼ����!');
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
