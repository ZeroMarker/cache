var DealerCm, DealerGrid, CertCm, CertGrid, PersonCm, PersonGrid, PicPersonType;
var HospId = gHospId;
var TableName = 'DHC_Dealer';
var DefOrgType = 'Dealer';
var init = function() {
	function InitHosp() {
		var hospComp = InitHospCombo(TableName, gSessionStr, DealerGrid);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				$UI.clearBlock('#MainConditions');
				Query();
			};
		}
		Query();
	}

	function Query(RowId) {
		var SessionParmas = addSessionParams({ BDPHospital: HospId });
		var Paramsobj = $UI.loopBlock('MainConditions');
		Paramsobj.RowId = RowId;
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		$UI.clearBlock('#BasicConditions');
		$UI.clear(DealerGrid);
		DealerGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCDealer',
			QueryName: 'Query',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	var SDealerCat = $HUI.combobox('#SDealerCat', {
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			SDealerCat.clear();
			var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.APCVendCat&QueryName=GetVendorCat&ResultSetType=array&Params=' + Params;
			SDealerCat.reload(url);
		}
	});
	
	var DealerCat = $HUI.combobox('#DealerCat', {
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			DealerCat.clear();
			var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.APCVendCat&QueryName=GetVendorCat&ResultSetType=array&Params=' + Params;
			DealerCat.reload(url);
		}
	});
	
	var SStatus = $HUI.combobox('#SStatus', {
		data: [{ 'RowId': 'A', 'Description': '使用' }, { 'RowId': 'S', 'Description': '停用' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var Status = $HUI.combobox('#Status', {
		data: [{ 'RowId': 'A', 'Description': '使用' }, { 'RowId': 'S', 'Description': '停用' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var PicPersonType = $HUI.combobox('#PicPersonType', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPersonFileType&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	
	DealerCm = [[
		{
			title: '预览',
			field: 'Icon',
			width: 50,
			align: 'center',
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '<div class="icon-img col-icon" title="查看图片" href="#" onclick="ViewDealerWin(' + index + ')"></div>';
				return str;
			}
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '代码',
			field: 'DealerCode',
			width: 100
		}, {
			title: '名称',
			field: 'DealerDesc',
			width: 200
		}, {
			title: '电话',
			field: 'Tel',
			width: 100
		}, {
			title: '分类',
			field: 'DealerCat',
			width: 100
		}, {
			title: '账户',
			field: 'CtrlAcct',
			width: 150
		}, {
			title: '注册资金',
			field: 'CrAvail',
			align: 'right',
			width: 100
		}, {
			title: '合同日期',
			field: 'LstPoDate',
			width: 100
		}, {
			title: '传真',
			field: 'Fax',
			width: 100
		}, {
			title: '法人',
			field: 'President',
			width: 100
		}, {
			title: '法人身份证',
			field: 'PresidentCard',
			width: 100
		}, {
			title: '法人电话',
			field: 'PresidentTel',
			width: 100
		}, {
			title: '最后业务日期',
			field: 'LstBsDate',
			width: 100
		}, {
			title: '使用标志',
			field: 'Status',
			width: 100,
			formatter: function(value, row, index) {
				if (value == 'A') {
					return '使用';
				} else {
					return '停用';
				}
			}
		}
	]];

	DealerGrid = $UI.datagrid('#DealerGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCDealer',
			QueryName: 'Query',
			query2JsonStrict: 1
		},
		columns: DealerCm,
		showBar: true,
		onSelect: function(Index, Row) {
			Clear();
			Select(Row.RowId);
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				DealerGrid.selectRow(0);
			}
		}
	});

	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	
	$UI.linkbutton('#AddBT', {
		onClick: function() {
			AddDealer(HospId, Select, Query);
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			Save();
		}
	});
	
	function Select(DealerId) {
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCDealer',
			MethodName: 'Select',
			RowId: DealerId
		}, function(jsonData) {
			$UI.fillBlock('#BasicConditions', jsonData);
			QueryCertDetail(DealerId);
			QueryPersonDetail(DealerId);
		});
	}
	
	function Save() {
		var RowId = $('#RowId').val();
		if (RowId == '') {
			$UI.msg('alert', '请先选择或保存经销商信息!');
			return;
		}
		var BasicObj = $UI.loopBlock('#BasicConditions');
		var SessionParmas = addSessionParams({ BDPHospital: HospId });
		var Params = JSON.stringify(jQuery.extend(true, BasicObj, SessionParmas));
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCDealer',
			MethodName: 'jsSave',
			Params: Params
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Select(jsonData.rowid);
				Query(jsonData.rowid);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	// / 资质信息
	$UI.linkbutton('#AddCertBT', {
		onClick: function() {
			var RowId = $('#RowId').val();
			if (RowId == '') {
				$UI.msg('alert', '请先选择或保存经销商信息!');
				return;
			}
			AddCert(DefOrgType, RowId, '', QueryCertDetail);
		}
	});
	
	$UI.linkbutton('#SaveCertBT', {
		onClick: function() {
			var RowId = $('#RowId').val();
			if (RowId == '') {
				$UI.msg('alert', '请先选择或保存经销商信息!');
				return;
			}
			var Row = CertGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择修改的资质信息!');
				return;
			}
			var CertId = Row.RowId;
			AddCert(DefOrgType, RowId, CertId, QueryCertDetail);
		}
	});
	
	$UI.linkbutton('#CertUpLoadBT', {
		onClick: function() {
			var RowId = $('#RowId').val();
			if (RowId == '') {
				$UI.msg('alert', '请先选择或保存经销商信息!');
				return;
			}
			var Row = CertGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择一条资质信息!');
				return;
			}
			var CertId = Row.RowId;
			var CertType = Row.CertType;
			UpLoadFileWin(DefOrgType, RowId, 'Cert', CertType, CertId, '');
		}
	});

	$UI.linkbutton('#CertTakePhotoBT', {
		onClick: function() {
			var RowId = $('#RowId').val();
			if (RowId == '') {
				$UI.msg('alert', '请先选择或保存经销商信息!');
				return;
			}
			var Row = CertGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择一条资质信息!');
				return;
			}
			var CertId = Row.RowId;
			var CertType = Row.CertType;
			TakePhotoWin(DefOrgType, RowId, 'Cert', CertType, CertId, '');
		}
	});

	CertCm = [[
		{
			title: '预览',
			field: 'Icon',
			width: 50,
			align: 'center',
			allowExport: false,
			formatter: function(value, row, index) {
				var str = "<a href='#' onclick='ViewCertFile(" + index + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/img.png' title='查看图片' border='0'></a>";
				return str;
			}
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '证件类型',
			field: 'CertType',
			width: 100,
			hidden: true
		}, {
			title: '证件类型',
			field: 'CertTypeDesc',
			width: 150
		}, {
			title: '证件编号',
			field: 'CertText',
			width: 200
		}, {
			title: '效期开始',
			field: 'CertDateFrom',
			width: 100
		}, {
			title: '效期截止',
			field: 'CertDateTo',
			width: 100
		}, {
			title: '发证机关',
			field: 'CertIssuedDept',
			width: 100
		}, {
			title: '发证日期',
			field: 'CertIssuedDate',
			width: 100
		}, {
			title: '是否长期',
			field: 'CertBlankedFlag',
			width: 80,
			formatter: BoolFormatter
		}, {
			title: '延期至',
			field: 'CertDelayDateTo',
			width: 100
		}, {
			title: '是否展示',
			field: 'CertShowFlag',
			width: 80,
			formatter: BoolFormatter
		}
	]];
	
	CertGrid = $UI.datagrid('#CertGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCCertDetail',
			QueryName: 'QueryCertDetail',
			query2JsonStrict: 1
		},
		columns: CertCm
	});
	function QueryCertDetail(OrgId) {
		CertGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCCertDetail',
			QueryName: 'QueryCertDetail',
			query2JsonStrict: 1,
			Params: JSON.stringify(addSessionParams({ OrgType: DefOrgType, OrgId: OrgId, HospId: HospId }))
		});
	}
	
	// / 业务员信息
	$UI.linkbutton('#AddPersonBT', {
		onClick: function() {
			var RowId = $('#RowId').val();
			if (RowId == '') {
				$UI.msg('alert', '请先选择或保存经销商信息!');
				return;
			}
			AddPerson(DefOrgType, RowId, '', QueryPersonDetail);
		}
	});
	
	$UI.linkbutton('#SavePersonBT', {
		onClick: function() {
			var RowId = $('#RowId').val();
			if (RowId == '') {
				$UI.msg('alert', '请先选择或保存经销商信息!');
				return;
			}
			var Row = PersonGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择修改的业务员信息!');
				return;
			}
			var PersonId = Row.RowId;
			AddPerson(DefOrgType, RowId, PersonId, QueryPersonDetail);
		}
	});
	
	$UI.linkbutton('#PersonUpLoadBT', {
		onClick: function() {
			var RowId = $('#RowId').val();
			if (RowId == '') {
				$UI.msg('alert', '请先选择或保存经销商信息!');
				return;
			}
			var Row = PersonGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择一条业务员信息!');
				return;
			}
			var PersonId = Row.RowId;
			var PersonType = Row.PersonType;
			var SubType = $HUI.combobox('#PicPersonType').getValue();
			if (SubType == '') {
				$UI.msg('alert', '请选择图片类型!');
				return;
			}
			UpLoadFileWin(DefOrgType, RowId, 'Person', PersonType, PersonId, SubType);
		}
	});

	$UI.linkbutton('#PersonTakePhotoBT', {
		onClick: function() {
			var RowId = $('#RowId').val();
			if (RowId == '') {
				$UI.msg('alert', '请先选择或保存经销商信息!');
				return;
			}
			var Row = PersonGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择一条业务员信息!');
				return;
			}
			var PersonId = Row.RowId;
			var PersonType = Row.PersonType;
			var SubType = $HUI.combobox('#PicPersonType').getValue();
			if (SubType == '') {
				$UI.msg('alert', '请选择图片类型!');
				return;
			}
			TakePhotoWin(DefOrgType, RowId, 'Person', PersonType, PersonId, SubType);
		}
	});
	
	PersonCm = [[
		{
			title: '预览',
			field: 'Icon',
			width: 50,
			align: 'center',
			allowExport: false,
			formatter: function(value, row, index) {
				var str = "<a href='#' onclick='ViewPersonFile(" + index + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/img.png' title='查看图片' border='0'></a>";
				return str;
			}
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '人员类型',
			field: 'PersonType',
			width: 100,
			hidden: true
		}, {
			title: '姓名',
			field: 'PersonName',
			width: 100
		}, {
			title: '身份证',
			field: 'PersonCard',
			width: 150
		}, {
			title: '手机',
			field: 'PersonCarrTel',
			width: 100
		}, {
			title: '电话',
			field: 'PersonTel',
			width: 100
		}, {
			title: '邮箱',
			field: 'PersonEmail',
			width: 150
		}, {
			title: '传真',
			field: 'PersonFax',
			width: 100
		}, {
			title: '授权书开始效期',
			field: 'PersonStartDate',
			width: 110
		}, {
			title: '授权书截止效期',
			field: 'PersonEndDate',
			width: 110
		}, {
			title: '是否展示',
			field: 'PersonShowFlag',
			width: 80,
			formatter: BoolFormatter
		}
	]];
	
	PersonGrid = $UI.datagrid('#PersonGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCPersonDetail',
			QueryName: 'QueryPersonDetail',
			query2JsonStrict: 1
		},
		columns: PersonCm
	});
	function QueryPersonDetail(OrgId) {
		PersonGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCPersonDetail',
			QueryName: 'QueryPersonDetail',
			query2JsonStrict: 1,
			Params: JSON.stringify(addSessionParams({ OrgType: DefOrgType, OrgId: OrgId }))
		});
	}
	
	InitHosp();
};
$(init);

function Clear() {
	$UI.clearBlock('#BasicConditions');
	$UI.clearBlock('#BasicCheckConditions');
	$UI.clearBlock('#PersonConditions');
	var DefaultData = {
		Status: 'A'
	};
	$UI.fillBlock('#BasicConditions', DefaultData);
}
function ViewCertFile(index) {
	var RowData = CertGrid.getRows()[index];
	var OrgId = $('#RowId').val();
	var GrpType = 'Cert';
	var PointerType = RowData.CertType;
	var Pointer = RowData.RowId;
	var SubType = '';
	ViewFileWin(DefOrgType, OrgId, GrpType, PointerType, Pointer, SubType, HospId);
}
function ViewPersonFile(index) {
	var RowData = PersonGrid.getRows()[index];
	var OrgId = $('#RowId').val();
	var GrpType = 'Person';
	var PointerType = RowData.PersonType;
	var Pointer = RowData.RowId;
	var SubType = $HUI.combobox('#PicPersonType').getValue();
	ViewFileWin(DefOrgType, OrgId, GrpType, PointerType, Pointer, SubType, HospId);
}
function ViewDealerWin(index) {
	var RowData = DealerGrid.getRows()[index];
	var OrgId = RowData.RowId;
	ViewFileWin(DefOrgType, OrgId, '', '', '', '', HospId);
}