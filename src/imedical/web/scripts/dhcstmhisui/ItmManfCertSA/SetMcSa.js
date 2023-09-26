var ToolBar, MCCm, MCGrid, SAToolBar, SACm, SAGrid;
var HospId=gHospId;
var TableName="PH_Manufacturer";
var init = function () {
	function InitHosp() {
		var hospComp=InitHospCombo(TableName,gSessionStr);
		if (typeof hospComp ==='object'){
			HospId=$HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid("options").onSelect=function(index,record){
				HospId=record.HOSPRowId;
				setStkGrpHospid(HospId);
				$HUI.combotree('#Scg').load(HospId);
				Clear();
			};
		}
		setStkGrpHospid(HospId);
	}
	function Clear(){
		$UI.clearBlock('#MainConditions');
		$UI.clear(MCGrid);
		$UI.clear(SAGrid);
	}
	function Query(){
		$UI.clear(MCGrid);
		$UI.clear(SAGrid);
		var ParamsObj = $UI.loopBlock('#MainConditions');
			if (isEmpty(ParamsObj.Manf)) {
				$UI.msg('alert', '请选择厂商!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			MCGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCItmManfCertSA',
				QueryName: 'IMCByManf',
				Params: Params
			});
	}
	var Manf = $HUI.combobox('#Manf', {
			valueField: 'RowId',
			textField: 'Description',
			onShowPanel: function(){
				var Params = JSON.stringify(addSessionParams({BDPHospital:HospId}));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params='+Params;
				Manf.reload(url);
			}
		});
	
	var VendorBox1 = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote',
			onBeforeLoad: function (param) {
				param.Params = JSON.stringify(addSessionParams({APCType: "M",RcFlag: "Y",BDPHospital:HospId}));
			},
			onSelect: function (record) {
				var rows = SAGrid.getRows();
				var row = rows[SAGrid.editIndex];
				if ((record.RowId == row.Vendor2) || (record.RowId == row.Vendor3) || (record.RowId == row.Vendor4) || (record.RowId == row.Vendor5)) {
					$UI.msg('alert', '该供应商与后面级别供应商重复,请重新选择!')
					$(this).combobox('clear');
					return;
				}
				row.VendorDesc1 = record.Description;
			},
			onShowPanel: function () {
				$(this).combobox('reload');
			}
		}
	};

	var VendorBox2 = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote',
			onBeforeLoad: function (param) {
				param.Params = JSON.stringify(addSessionParams({APCType: "M",RcFlag: "Y",BDPHospital:HospId}));
			},
			onSelect: function (record) {
				var rows = SAGrid.getRows();
				var row = rows[SAGrid.editIndex];
				if ((record.RowId == row.Vendor1) || (record.RowId == row.Vendor3) || (record.RowId == row.Vendor4) || (record.RowId == row.Vendor5)) {
					$UI.msg('alert', '该供应商与其他级别供应商重复,请重新选择!')
					$(this).combobox('clear');
					return;
				}
				row.VendorDesc2 = record.Description;
			},
			onShowPanel: function () {
				$(this).combobox('reload');
			}
		}
	};

	var VendorBox3 = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote',
			onBeforeLoad: function (param) {
				param.Params = JSON.stringify(addSessionParams({APCType: "M",RcFlag: "Y",BDPHospital:HospId}));
			},
			onSelect: function (record) {
				var rows = SAGrid.getRows();
				var row = rows[SAGrid.editIndex];
				if ((record.RowId == row.Vendor1) || (record.RowId == row.Vendor2) || (record.RowId == row.Vendor4) || (record.RowId == row.Vendor5)) {
					$UI.msg('alert', '该供应商与其他级别供应商重复,请重新选择!')
					$(this).combobox('clear');
					return;
				}
				row.VendorDesc3 = record.Description;
			},
			onShowPanel: function () {
				$(this).combobox('reload');
			}
		}
	};
	
	var VendorBox4 = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote',
			onBeforeLoad: function (param) {
				param.Params = JSON.stringify(addSessionParams({APCType: "M",RcFlag: "Y",BDPHospital:HospId}));
			},
			onSelect: function (record) {
				var rows = SAGrid.getRows();
				var row = rows[SAGrid.editIndex];
				if ((record.RowId == row.Vendor1) || (record.RowId == row.Vendor2) || (record.RowId == row.Vendor3) || (record.RowId == row.Vendor5)) {
					$UI.msg('alert', '该供应商与其他级别供应商重复,请重新选择!')
					$(this).combobox('clear');
					return;
				}
				row.VendorDesc4 = record.Description;
			},
			onShowPanel: function () {
				$(this).combobox('reload');
			}
		}
	};
	
	var VendorBox5 = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required: true,
			mode: 'remote',
			onBeforeLoad: function (param) {
				param.Params = JSON.stringify(addSessionParams({APCType: "M",RcFlag: "Y",BDPHospital:HospId}));
			},
			onSelect: function (record) {
				var rows = SAGrid.getRows();
				var row = rows[SAGrid.editIndex];
				if ((record.RowId == row.Vendor1) || (record.RowId == row.Vendor2) || (record.RowId == row.Vendor3) || (record.RowId == row.Vendor4)) {
					$UI.msg('alert', '该供应商与其他级别供应商重复,请重新选择!')
					$(this).combobox('clear');
					return;
				}
				row.VendorDesc5 = record.Description;
			},
			onShowPanel: function () {
				$(this).combobox('reload');
			}
		}
	};

	ToolBar = [{
			text: '保存',
			iconCls: 'icon-save',
			handler: function () {
				SaveMC();
			}
		}
	];

	MCCm = [[{
				title: "操作",
				field: 'Icon',
				width: 50,
				align: 'center',
				formatter: function (value, row, index) {
					var str = "<a href='#' onclick='McPicWin(" + row.RowId + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/img.png' title='编辑图片' border='0'></a>";
					return str;
				}
			}, {
				title: "RowId",
				field: 'RowId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: "厂商",
				field: 'ManfDesc',
				width: 150,
				hidden: true
			}, {
				title: "注册证号",
				field: 'CertNo',
				saveCol: true,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				},
				width: 180
			}, {
				title: "注册证效期",
				field: 'CertExpDate',
				saveCol: true,
				editor: {
					type: 'datebox'
				},
				width: 115
			}
		]];

	MCGrid = $UI.datagrid('#MCGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCItmManfCertSA',
				QueryName: 'IMCByManf'
			},
			deleteRowParams: {
				ClassName: 'web.DHCSTMHUI.DHCItmManfCertSA',
				MethodName: 'DeleteMC'
			},
			pagination: false,
			showAddDelItems: true,
			beforeAddFn: function () {
				if (isEmpty($HUI.combobox('#Manf').getValue())) {
					$UI.msg('alert', '请选择厂商!');
					return;
				}
			},
			toolbar: ToolBar,
			columns: MCCm,
			onSelect: function (index, row) {
				$UI.clear(SAGrid);
				SAGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCItmManfCertSA',
					QueryName: 'SAByMC',
					Parref: row.RowId
				});
			},
			onLoadSuccess: function (data) {
				if (data.rows.length > 0) {
					MCGrid.selectRow(0);
				}
			},
			onClickCell: function (index, field, value) {
				MCGrid.commonClickCell(index, field);
			}
		});

	SAToolBar = [{
			text: '保存',
			iconCls: 'icon-save',
			handler: function () {
				SaveSA();
			}
		}, "-", {
			text: '供货品种维护',
			iconCls: 'icon-save-tmpl',
			handler: function () {
				var RowData = SAGrid.getSelected();
				if (RowData == null || RowData == "") {
					$UI.msg('alert', '请选择供应商授权链信息!');
					return;
				}
				var SA = RowData.RowId;
				if (SA == null || SA == "") {
					$UI.msg('alert', '请先保存此供应商授权链信息!');
					return;
				}
				ItmListWin(SA,HospId);
			}
		}
	];

	SACm = [[{
				title: "RowId",
				field: 'RowId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: "一级供应商",
				field: 'Vendor1',
				width: 150,
				saveCol: true,
				formatter: CommonFormatter(VendorBox1, 'Vendor1', 'VendorDesc1'),
				editor: VendorBox1
			}, {
				title: "一级授权书",
				field: 'Lic1',
				width: 100,
				saveCol: true,
				editor: {
					type: 'validatebox'
				}
			}, {
				title: "一级授权效期",
				field: 'LicExp1',
				width: 105,
				saveCol: true,
				editor: {
					type: 'datebox'
				}
			}, {
				title: "二级供应商",
				field: 'Vendor2',
				width: 150,
				saveCol: true,
				formatter: CommonFormatter(VendorBox2, 'Vendor2', 'VendorDesc2'),
				editor: VendorBox2
			}, {
				title: "二级授权书",
				field: 'Lic2',
				width: 100,
				saveCol: true,
				editor: {
					type: 'validatebox'
				}
			}, {
				title: "二级授权效期",
				field: 'LicExp2',
				width: 105,
				saveCol: true,
				editor: {
					type: 'datebox'
				}
			}, {
				title: "三级供应商",
				field: 'Vendor3',
				width: 150,
				saveCol: true,
				formatter: CommonFormatter(VendorBox3, 'Vendor3', 'VendorDesc3'),
				editor: VendorBox3
			}, {
				title: "三级授权书",
				field: 'Lic3',
				width: 100,
				saveCol: true,
				editor: {
					type: 'validatebox'
				}
			}, {
				title: "三级授权效期",
				field: 'LicExp3',
				width: 105,
				saveCol: true,
				editor: {
					type: 'datebox'
				}
			}, {
				title: "四级供应商",
				field: 'Vendor4',
				width: 150,
				saveCol: true,
				formatter: CommonFormatter(VendorBox4, 'Vendor4', 'VendorDesc4'),
				editor: VendorBox4
			}, {
				title: "四级授权书",
				field: 'Lic4',
				width: 100,
				saveCol: true,
				editor: {
					type: 'validatebox'
				}
			}, {
				title: "四级授权效期",
				field: 'LicExp4',
				width: 105,
				saveCol: true,
				editor: {
					type: 'datebox'
				}
			}, {
				title: "五级供应商",
				field: 'Vendor5',
				width: 150,
				saveCol: true,
				formatter: CommonFormatter(VendorBox5, 'Vendor5', 'VendorDesc5'),
				editor: VendorBox5
			}, {
				title: "五级授权书",
				field: 'Lic5',
				width: 100,
				saveCol: true,
				editor: {
					type: 'validatebox'
				}
			}, {
				title: "五级授权效期",
				field: 'LicExp5',
				width: 105,
				saveCol: true,
				editor: {
					type: 'datebox'
				}
			}
		]];

	SAGrid = $UI.datagrid('#SAGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCItmManfCertSA',
				QueryName: 'SAByMC'
			},
			deleteRowParams: {
				ClassName: 'web.DHCSTMHUI.DHCItmManfCertSA',
				MethodName: 'DeleteSA'
			},
			toolbar: SAToolBar,
			columns: SACm,
			showAddDelItems: true,
			onClickCell: function (index, field, value) {
				SAGrid.commonClickCell(index, field);
			}
		});

	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			Query();
		}
	});
	InitHosp();
};
$(init);
function SaveMC() {
	var MainObj = $UI.loopBlock('#MainConditions');
	if (isEmpty(MainObj.Manf)) {
		$UI.msg('alert', '请选择厂商!')
		return;
	}
	var Main = JSON.stringify(MainObj);
	var Detail = MCGrid.getChangesData();
	if (Detail === false){	//未完成编辑或明细为空
		return;
	}
	if (isEmpty(Detail)){	//明细不变
		$UI.msg("alert", "没有需要保存的明细!");
		return;
	}
	$.cm({
		ClassName: 'web.DHCSTMHUI.DHCItmManfCertSA',
		MethodName: 'SaveMC',
		Main: Main,
		Detail: JSON.stringify(Detail)
	}, function (jsonData) {
		if (jsonData.success == 0) {
			$UI.msg('success', jsonData.msg);
			$UI.clear(MCGrid);
			$UI.clear(SAGrid);
			MCGrid.commonReload();
		} else {
			$UI.msg('error', jsonData.msg);
		}
	});
}

function SaveSA() {
	var RowData = MCGrid.getSelected();
	if (RowData == null || RowData == "") {
		$UI.msg('alert', '请选择厂商注册证信息!');
		return;
	}
	var MC = RowData.RowId;
	if (MC == null || MC == "") {
		$UI.msg('alert', '请先保存此厂商注册证信息!');
		return;
	}
	var Detail = SAGrid.getChangesData();
	if (Detail === false){	//未完成编辑或明细为空
		return;
	}
	if (isEmpty(Detail)){	//明细不变
		$UI.msg("alert", "没有需要保存的明细!");
		return;
	}
	$.cm({
		ClassName: 'web.DHCSTMHUI.DHCItmManfCertSA',
		MethodName: 'SaveSA',
		MC: MC,
		Detail: JSON.stringify(Detail)
	}, function (jsonData) {
		if (jsonData.success == 0) {
			$UI.msg('success', jsonData.msg);
			$UI.clear(SAGrid);
			SAGrid.commonReload();
		} else {
			$UI.msg('error', jsonData.msg);
		}
	});
}
