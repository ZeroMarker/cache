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
	// ���ݽӿ����ÿ�����ذ�ťչʾ
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
			title: 'Ԥ��',
			field: 'Icon',
			width: 50,
			align: 'center',
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '<div class="icon-img col-icon" title="�鿴ͼƬ" href="#" onclick="ViewVendorWin(' + index + ')"></div>';
				return str;
			}
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '����',
			field: 'VendorCode',
			width: 100
		}, {
			title: '����',
			field: 'VendorDesc',
			width: 200
		}, {
			title: '�绰',
			field: 'Tel',
			width: 100
		}, {
			title: '����',
			field: 'VendorCat',
			width: 100
		}, {
			title: '�˻�',
			field: 'CtrlAcct',
			width: 150
		}, {
			title: 'ע���ʽ�',
			field: 'CrAvail',
			align: 'right',
			width: 100
		}, {
			title: '��ͬ����',
			field: 'LstPoDate',
			width: 100
		}, {
			title: '����',
			field: 'Fax',
			width: 100
		}, {
			title: '����',
			field: 'President',
			width: 100
		}, {
			title: '�������֤',
			field: 'PresidentCard',
			width: 100
		}, {
			title: '���˵绰',
			field: 'PresidentTel',
			width: 100
		}, {
			title: '���ҵ������',
			field: 'LstBsDate',
			width: 100
		}, {
			title: 'ʹ�ñ�־',
			field: 'Status',
			width: 100,
			formatter: function(value, row, index) {
				if (value == 'A') {
					return 'ʹ��';
				} else {
					return 'ͣ��';
				}
			}
		}, {
			title: '����',
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
				$UI.msg('alert', '����ѡ��򱣴湩Ӧ����Ϣ!');
				return;
			}
			var BasicObj = $UI.loopBlock('#BasicConditions');
			var UseFlag = BasicObj.Status;
			var VendorStock = tkMakeServerCall('web.DHCSTMHUI.APCVenNew', 'GetVendorStock', RowId);
			if (UseFlag == 'S' && VendorStock == 'Y') {
				$UI.confirm('�ù�Ӧ�̴��ڿ��,�Ƿ����ͣ�ã�', 'warning', '', Save, '', '', '����', false);
			} else {
				Save();
			}
		}
	});
	var SunPurPlan=CommParObj.SunPurPlan;  //�������� ����
	/// 20221112 ����ɹ�
	$UI.linkbutton('#LinkBT', {
		onClick: function () {
			var Row=VendorGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ����ҵ!');
				return;
			}
			var Vendid=Row.RowId;
			if (Vendid=="") {
				$UI.msg('alert', '��ѡ����ҵ!');
				return;
			}
			if (isEmpty(SunPurPlan)){
				$UI.msg('alert', '�����òɹ�ƽ̨��Ϣ!');
				return;
			}
			if (SunPurPlan=="�Ĵ�ʡ"){
				SCQueryComany(Vendid,"V");
			}
		}
	});
	/// ���� end
	$('#SendVenSCIBT').on('click', SendVenSCI);
	function SendVenSCI() {
		var Rows = VendorGrid.getSelections();
		if (Rows.length <= 0) {
			$UI.msg('alert', '��ѡ��Ҫ���͵Ĺ�Ӧ��!');
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
			$UI.msg('alert', '��ѡ��Ҫ���͵Ĺ�Ӧ��!');
			return;
		}
		if (SerUseObj.ECS == 'Y') {
			$.cm({
				ClassName: 'web.DHCSTMHUI.ServiceForECS',
				MethodName: 'saveSupDict',
				VendorIdStr: venstr,
				HospId: HospId
			}, function(jsonData) {
				$UI.msg('success', '�ѷ���!');
			});
		} else if (SerUseObj.SCI == 'Y') {
			$.cm({
				ClassName: 'web.DHCSTMHUI.ServiceForSCI',
				MethodName: 'getHopVendor',
				VenIdStr: venstr
			}, function(jsonData) {
				$UI.msg('success', '�ѷ���!');
			});
		}
		if (SerUseObj.LIS == 'Y') {
			$.cm({
				ClassName: 'web.DHCSTMHUI.ServiceForLis',
				MethodName: 'SynVendorInfo',
				VendorId: venstr,
				HospId: HospId
			}, function(jsonData) {
				$UI.msg('success', '�ѷ���!');
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
				$UI.msg('error', '��Ӧ����Ϣ��ѯ����!');
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
	
	// / ������Ϣ
	$UI.linkbutton('#AddCertBT', {
		onClick: function() {
			var RowId = $('#RowId').val();
			if (RowId == '') {
				$UI.msg('alert', '����ѡ��򱣴湩Ӧ����Ϣ!');
				return;
			}
			AddCert('Vendor', RowId, '', QueryCertDetail, HospId);
		}
	});
	
	$UI.linkbutton('#SaveCertBT', {
		onClick: function() {
			var RowId = $('#RowId').val();
			if (RowId == '') {
				$UI.msg('alert', '����ѡ��򱣴湩Ӧ����Ϣ!');
				return;
			}
			var Row = CertGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ���޸ĵ�������Ϣ!');
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
				$UI.msg('alert', '����ѡ��򱣴湩Ӧ����Ϣ!');
				return;
			}
			var Row = CertGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��һ��������Ϣ!');
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
				$UI.msg('alert', '����ѡ��򱣴湩Ӧ����Ϣ!');
				return;
			}
			var Row = CertGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��һ��������Ϣ!');
				return;
			}
			var CertId = Row.RowId;
			var CertType = Row.CertType;
			TakePhotoWin('Vendor', RowId, 'Cert', CertType, CertId, '');
		}
	});

	CertCm = [[
		{
			title: 'Ԥ��',
			field: 'Icon',
			width: 50,
			align: 'center',
			allowExport: false,
			formatter: function(value, row, index) {
				var str = "<a href='#' onclick='ViewCertFile(" + index + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/img.png' title='�鿴ͼƬ' border='0'></a>";
				return str;
			}
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '֤������',
			field: 'CertType',
			width: 100,
			hidden: true
		}, {
			title: '֤������',
			field: 'CertTypeDesc',
			width: 150
		}, {
			title: '֤�����',
			field: 'CertText',
			width: 200
		}, {
			title: 'Ч�ڿ�ʼ',
			field: 'CertDateFrom',
			width: 100
		}, {
			title: 'Ч�ڽ�ֹ',
			field: 'CertDateTo',
			width: 100
		}, {
			title: '��֤����',
			field: 'CertIssuedDept',
			width: 100
		}, {
			title: '��֤����',
			field: 'CertIssuedDate',
			width: 100
		}, {
			title: '�Ƿ���',
			field: 'CertBlankedFlag',
			width: 80,
			formatter: BoolFormatter
		}, {
			title: '������',
			field: 'CertDelayDateTo',
			width: 100
		}, {
			title: '�Ƿ�չʾ',
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
				$UI.msg('alert', '����ѡ��򱣴湩Ӧ����Ϣ!');
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
	
	// / ҵ��Ա��Ϣ
	$UI.linkbutton('#AddPersonBT', {
		onClick: function() {
			var RowId = $('#RowId').val();
			if (RowId == '') {
				$UI.msg('alert', '����ѡ��򱣴湩Ӧ����Ϣ!');
				return;
			}
			AddPerson('Vendor', RowId, '', QueryPersonDetail);
		}
	});
	
	$UI.linkbutton('#SavePersonBT', {
		onClick: function() {
			var RowId = $('#RowId').val();
			if (RowId == '') {
				$UI.msg('alert', '����ѡ��򱣴湩Ӧ����Ϣ!');
				return;
			}
			var Row = PersonGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ���޸ĵ�ҵ��Ա��Ϣ!');
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
				$UI.msg('alert', '����ѡ��򱣴湩Ӧ����Ϣ!');
				return;
			}
			var Row = PersonGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��һ��ҵ��Ա��Ϣ!');
				return;
			}
			var PersonId = Row.RowId;
			var PersonType = Row.PersonType;
			var SubType = $HUI.combobox('#PicPersonType').getValue();
			if (SubType == '') {
				$UI.msg('alert', '��ѡ��ͼƬ����!');
				return;
			}
			UpLoadFileWin('Vendor', RowId, 'Person', PersonType, PersonId, SubType);
		}
	});

	$UI.linkbutton('#PersonTakePhotoBT', {
		onClick: function() {
			var RowId = $('#RowId').val();
			if (RowId == '') {
				$UI.msg('alert', '����ѡ��򱣴湩Ӧ����Ϣ!');
				return;
			}
			var Row = PersonGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��һ��������Ϣ!');
				return;
			}
			var PersonId = Row.RowId;
			var PersonType = Row.PersonType;
			var SubType = $HUI.combobox('#PicPersonType').getValue();
			if (SubType == '') {
				$UI.msg('alert', '��ѡ��ͼƬ����!');
				return;
			}
			TakePhotoWin('Vendor', RowId, 'Person', PersonType, PersonId, SubType);
		}
	});
	
	PersonCm = [[
		{
			title: 'Ԥ��',
			field: 'Icon',
			width: 50,
			align: 'center',
			allowExport: false,
			formatter: function(value, row, index) {
				var str = "<a href='#' onclick='ViewPersonFile(" + index + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/img.png' title='�鿴ͼƬ' border='0'></a>";
				return str;
			}
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '��Ա����',
			field: 'PersonType',
			width: 100,
			hidden: true
		}, {
			title: '����',
			field: 'PersonName',
			width: 100
		}, {
			title: '���֤',
			field: 'PersonCard',
			width: 150
		}, {
			title: '�ֻ�',
			field: 'PersonCarrTel',
			width: 100
		}, {
			title: '�绰',
			field: 'PersonTel',
			width: 100
		}, {
			title: '����',
			field: 'PersonEmail',
			width: 150
		}, {
			title: '����',
			field: 'PersonFax',
			width: 100
		}, {
			title: '��Ȩ�鿪ʼЧ��',
			field: 'PersonStartDate',
			width: 110
		}, {
			title: '��Ȩ���ֹЧ��',
			field: 'PersonEndDate',
			width: 110
		}, {
			title: '�Ƿ�չʾ',
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