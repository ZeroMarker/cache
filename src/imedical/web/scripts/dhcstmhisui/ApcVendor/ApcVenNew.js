var VendorCm, VendorGrid, CertCm, CertGrid, PersonCm, PersonGrid, PicPersonType;
var HospId = gHospId;
var TableName = 'APC_Vendor';
var init = function() {
	function InitHosp() {
		var hospComp = InitHospCombo(TableName, gSessionStr, VendorGrid);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				$UI.clearBlock('#MainConditions');
				SetServiceInfo(HospId);
				SelectDefa();
			};
		}
		SelectDefa();
		SetServiceInfo();
	}
	function SelectDefa() {
		var RowIdStr = '',RowId = '';
		if (!isEmpty(gTabParams)) {
			var TalParamsObj = JSON.parse(gTabParams);
			var TabType = TalParamsObj.TabType;
			RowIdStr = TalParamsObj.TabId;
			RowId = RowIdStr.split(',')[1];
			if ((TabType == 'Search') && (!isEmpty(RowId))) {
				Select(RowId);
			}
		}
		Query(RowIdStr);
		CheckLocationHref(1);
	}
	// 根据接口启用控制相关按钮展示
	function SetServiceInfo(HospId) {
		if (!isEmpty(HospId)) {
			SerUseObj = GetSerUseObj(HospId);
		}
		if ((SerUseObj.ECS == 'Y') || (SerUseObj.SCI == 'Y') || (SerUseObj.LIS == 'Y')) {
			$('.SCIShow').show();
		} else {
			$('.SCIShow').hide();
		}
	}

	function Query(RowId) {
		var SessionParmas = addSessionParams({ BDPHospital: HospId });
		var Paramsobj = $UI.loopBlock('MainConditions');
		if (!isEmpty(RowId)) {
			Paramsobj.RowId = RowId;
		}
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		$UI.clearBlock('#BasicConditions');
		$UI.clearBlock('#BasicCheckConditions');
		$UI.clear(VendorGrid);
		VendorGrid.load({
			ClassName: 'web.DHCSTMHUI.APCVenNew',
			QueryName: 'APCVendor',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	var VendorCat = $HUI.combobox('#VendorCat', {
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			VendorCat.clear();
			var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.APCVendCat&QueryName=GetVendorCat&ResultSetType=array&Params=' + Params;
			VendorCat.reload(url);
		}
	});
	
	var VendorCat_1 = $HUI.combobox('#VendorCat_1', {
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			VendorCat_1.clear();
			var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.APCVendCat&QueryName=GetVendorCat&ResultSetType=array&Params=' + Params;
			VendorCat_1.reload(url);
		}
	});
	
	var PicPersonType = $HUI.combobox('#PicPersonType', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPersonFileType&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	
	VendorCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: '预览',
			field: 'Icon',
			width: 50,
			align: 'center',
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '<div class="icon-img col-icon" title="查看图片" href="#" onclick="ViewVendorWin(' + index + ')"></div>';
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
			field: 'VendorCode',
			width: 100
		}, {
			title: '名称',
			field: 'VendorDesc',
			width: 200
		}, {
			title: '电话',
			field: 'Tel',
			width: 100
		}, {
			title: '分类',
			field: 'VendorCat',
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
		}, {
			title: '别名',
			field: 'Alias',
			sortable: true,
			width: 100
		}
	]];

	VendorGrid = $UI.datagrid('#VendorGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.APCVenNew',
			QueryName: 'APCVendor',
			query2JsonStrict: 1
		},
		columns: VendorCm,
		showBar: true,
		remoteSort: true,
		singleSelect: false,
		onSelect: function(Index, Row) {
			Clear();
			Select(Row.RowId);
		},
		onLoadSuccess: function(data) {
			if ((data.rows.length > 0) && (CommParObj.IfSelFirstRow == 'Y')) {
				$(this).datagrid('selectRow', 0);
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
			AddVendor(HospId, Select, Query);
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var RowId = $('#RowId').val();
			if (RowId == '') {
				$UI.msg('alert', '请先选择或保存供应商信息!');
				return;
			}
			var BasicObj = $UI.loopBlock('#BasicConditions');
			var UseFlag = BasicObj.Status;
			var VendorStock = tkMakeServerCall('web.DHCSTMHUI.APCVenNew', 'GetVendorStock', RowId);
			if (UseFlag == 'S' && VendorStock == 'Y') {
				$UI.confirm('该供应商存在库存,是否继续停用！', 'warning', '', Save, '', '', '警告', false);
			} else {
				Save();
			}
		}
	});
	var SunPurPlan=CommParObj.SunPurPlan;  //参数设置 公共
	/// 20221112 阳光采购
	$UI.linkbutton('#LinkBT', {
		onClick: function () {
			var Row=VendorGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择企业!');
				return;
			}
			var Vendid=Row.RowId;
			if (Vendid=="") {
				$UI.msg('alert', '请选择企业!');
				return;
			}
			if (isEmpty(SunPurPlan)){
				$UI.msg('alert', '请配置采购平台信息!');
				return;
			}
			if (SunPurPlan=="四川省"){
				SCQueryComany(Vendid,"V");
			}
		}
	});
	/// 阳光 end
	$('#SendVenSCIBT').on('click', SendVenSCI);
	function SendVenSCI() {
		var Rows = VendorGrid.getSelections();
		if (Rows.length <= 0) {
			$UI.msg('alert', '请选择要推送的供应商!');
			return;
		}
		var venstr = '';
		for (var i = 0, Len = Rows.length; i < Len; i++) {
			var RowData = Rows[i];
			var RowIndex = VendorGrid.getRowIndex(RowData);
			var venid = RowData['RowId'];
			if (venstr == '') { venstr = venid; } else { venstr = venstr + '^' + venid; }
		}
		if (venstr == '') {
			$UI.msg('alert', '请选择要推送的供应商!');
			return;
		}
		if (SerUseObj.ECS == 'Y') {
			$.cm({
				ClassName: 'web.DHCSTMHUI.ServiceForECS',
				MethodName: 'saveSupDict',
				VendorIdStr: venstr,
				HospId: HospId
			}, function(jsonData) {
				$UI.msg('success', '已发送!');
			});
		} else if (SerUseObj.SCI == 'Y') {
			$.cm({
				ClassName: 'web.DHCSTMHUI.ServiceForSCI',
				MethodName: 'getHopVendor',
				VenIdStr: venstr
			}, function(jsonData) {
				$UI.msg('success', '已发送!');
			});
		}
		if (SerUseObj.LIS == 'Y') {
			$.cm({
				ClassName: 'web.DHCSTMHUI.ServiceForLis',
				MethodName: 'SynVendorInfo',
				VendorId: venstr,
				HospId: HospId
			}, function(jsonData) {
				$UI.msg('success', '已发送!');
			});
		}
	}
	function Select(Vendor) {
		$.cm({
			ClassName: 'web.DHCSTMHUI.APCVenNew',
			MethodName: 'Select',
			Vendor: Vendor
		}, function(jsonData) {
			if (jsonData.success != 0) {
				$UI.msg('error', '供应商信息查询有误!');
				return;
			}
			$UI.fillBlock('#BasicConditions', jsonData.BasicData);
			$UI.fillBlock('#BasicCheckConditions', jsonData.BasicData);
			$('#VendorDesc_1').validatebox('validate');
			QueryCertDetail(Vendor);
			QueryPersonDetail(Vendor);
		});
	}
	
	function Save() {
		var RowId = $('#RowId').val();
		var BasicObj = $UI.loopBlock('#BasicConditions');
		var CheckObj = $UI.loopBlock('#BasicCheckConditions');

		var SessionParmas = addSessionParams({ BDPHospital: HospId });
		var Basic = JSON.stringify(jQuery.extend(true, BasicObj, SessionParmas));
		var Check = JSON.stringify(CheckObj);
		
		$.cm({
			ClassName: 'web.DHCSTMHUI.APCVenNew',
			MethodName: 'Save',
			Basic: Basic,
			Check: Check
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Select(jsonData.rowid);
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
				$UI.msg('alert', '请先选择或保存供应商信息!');
				return;
			}
			AddCert('Vendor', RowId, '', QueryCertDetail, HospId);
		}
	});
	
	$UI.linkbutton('#SaveCertBT', {
		onClick: function() {
			var RowId = $('#RowId').val();
			if (RowId == '') {
				$UI.msg('alert', '请先选择或保存供应商信息!');
				return;
			}
			var Row = CertGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择修改的资质信息!');
				return;
			}
			var CertId = Row.RowId;
			AddCert('Vendor', RowId, CertId, QueryCertDetail, HospId);
		}
	});
	
	$UI.linkbutton('#CertUpLoadBT', {
		onClick: function() {
			var RowId = $('#RowId').val();
			if (RowId == '') {
				$UI.msg('alert', '请先选择或保存供应商信息!');
				return;
			}
			var Row = CertGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择一条资质信息!');
				return;
			}
			var CertId = Row.RowId;
			var CertType = Row.CertType;
			UpLoadFileWin('Vendor', RowId, 'Cert', CertType, CertId, '');
		}
	});

	$UI.linkbutton('#CertTakePhotoBT', {
		onClick: function() {
			var RowId = $('#RowId').val();
			if (RowId == '') {
				$UI.msg('alert', '请先选择或保存供应商信息!');
				return;
			}
			var Row = CertGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择一条资质信息!');
				return;
			}
			var CertId = Row.RowId;
			var CertType = Row.CertType;
			TakePhotoWin('Vendor', RowId, 'Cert', CertType, CertId, '');
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
		columns: CertCm,
		onDblClickRow: function(index, row) {
			var RowId = $('#RowId').val();
			if (RowId == '') {
				$UI.msg('alert', '请先选择或保存供应商信息!');
				return;
			}
			var CertId = row['RowId'];
			AddCert('Vendor', RowId, CertId, QueryCertDetail, HospId);
		}
	});
	function QueryCertDetail(OrgId) {
		CertGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCCertDetail',
			QueryName: 'QueryCertDetail',
			query2JsonStrict: 1,
			Params: JSON.stringify(addSessionParams({ OrgType: 'Vendor', OrgId: OrgId, HospId: HospId }))
		});
	}
	
	// / 业务员信息
	$UI.linkbutton('#AddPersonBT', {
		onClick: function() {
			var RowId = $('#RowId').val();
			if (RowId == '') {
				$UI.msg('alert', '请先选择或保存供应商信息!');
				return;
			}
			AddPerson('Vendor', RowId, '', QueryPersonDetail);
		}
	});
	
	$UI.linkbutton('#SavePersonBT', {
		onClick: function() {
			var RowId = $('#RowId').val();
			if (RowId == '') {
				$UI.msg('alert', '请先选择或保存供应商信息!');
				return;
			}
			var Row = PersonGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择修改的业务员信息!');
				return;
			}
			var PersonId = Row.RowId;
			AddPerson('Vendor', RowId, PersonId, QueryPersonDetail);
		}
	});
	
	$UI.linkbutton('#PersonUpLoadBT', {
		onClick: function() {
			var RowId = $('#RowId').val();
			if (RowId == '') {
				$UI.msg('alert', '请先选择或保存供应商信息!');
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
			UpLoadFileWin('Vendor', RowId, 'Person', PersonType, PersonId, SubType);
		}
	});

	$UI.linkbutton('#PersonTakePhotoBT', {
		onClick: function() {
			var RowId = $('#RowId').val();
			if (RowId == '') {
				$UI.msg('alert', '请先选择或保存供应商信息!');
				return;
			}
			var Row = PersonGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择一条资质信息!');
				return;
			}
			var PersonId = Row.RowId;
			var PersonType = Row.PersonType;
			var SubType = $HUI.combobox('#PicPersonType').getValue();
			if (SubType == '') {
				$UI.msg('alert', '请选择图片类型!');
				return;
			}
			TakePhotoWin('Vendor', RowId, 'Person', PersonType, PersonId, SubType);
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
			Params: JSON.stringify(addSessionParams({ OrgType: 'Vendor', OrgId: OrgId }))
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
	var OrgType = 'Vendor';
	var OrgId = $('#RowId').val();
	var GrpType = 'Cert';
	var PointerType = RowData.CertType;
	var Pointer = RowData.RowId;
	var SubType = '';
	ViewFileWin(OrgType, OrgId, GrpType, PointerType, Pointer, SubType, HospId);
}
function ViewPersonFile(index) {
	var RowData = PersonGrid.getRows()[index];
	var OrgType = 'Vendor';
	var OrgId = $('#RowId').val();
	var GrpType = 'Person';
	var PointerType = RowData.PersonType;
	var Pointer = RowData.RowId;
	var SubType = $HUI.combobox('#PicPersonType').getValue();
	ViewFileWin(OrgType, OrgId, GrpType, PointerType, Pointer, SubType, HospId);
}
function ViewVendorWin(index) {
	var RowData = VendorGrid.getRows()[index];
	var OrgType = 'Vendor';
	var OrgId = RowData.RowId;
	ViewFileWin(OrgType, OrgId, '', '', '', '', HospId);
}