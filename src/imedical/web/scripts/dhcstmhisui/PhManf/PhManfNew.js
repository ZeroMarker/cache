var ManfCm, ManfGrid, CertCm, CertGrid;
var HospId = gHospId;
var TableName = 'PH_Manufacturer';
var init = function() {
	var ManfBox = $HUI.combobox('#ParManf', {
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			ManfBox.clear();
			var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + Params;
			ManfBox.reload(url);
		}
	});
	
	function InitHosp() {
		var hospComp = InitHospCombo(TableName, gSessionStr, ManfGrid);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				$UI.clearBlock('#MainConditions');
				SetServiceInfo(HospId);
				SelectDefa();
			};
		}
		SetServiceInfo();
		SelectDefa();
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
		if (SerUseObj.ECS == 'Y') {
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
		$UI.clear(ManfGrid);
		ManfGrid.load({
			ClassName: 'web.DHCSTMHUI.ItmManfNew',
			QueryName: 'ItmManf',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	ManfCm = [[
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
				var str = '<div class="icon-img col-icon" title="�鿴ͼƬ" href="#" onclick="ViewManfWin(' + index + ')"></div>';
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
			field: 'ManfCode',
			width: 100
		}, {
			title: '����',
			field: 'ManfDesc',
			width: 150
		}, {
			title: '�绰',
			field: 'Tel',
			width: 100
		}, {
			title: '��ַ',
			field: 'Address',
			width: 150
		}
	]];

	ManfGrid = $UI.datagrid('#ManfGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ItmManfNew',
			QueryName: 'ItmManf',
			query2JsonStrict: 1
		},
		columns: ManfCm,
		showBar: true,
		fitColumns: true,
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
			Clear();
			$('#Status_1').combobox('setValue', 'Y');
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			Save();
		}
	});
	$UI.linkbutton('#AddCertBT', {
		onClick: function() {
			var RowId = $('#RowId').val();
			if (RowId == '') {
				$UI.msg('alert', '����ѡ��򱣴�����������Ϣ!');
				return;
			}
			AddCert('Manf', RowId, '', QueryCertDetail);
		}
	});
	
	$UI.linkbutton('#SaveCertBT', {
		onClick: function() {
			var RowId = $('#RowId').val();
			if (RowId == '') {
				$UI.msg('alert', '����ѡ��򱣴�����������Ϣ!');
				return;
			}
			var Row = CertGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ���޸ĵ�������Ϣ!');
				return;
			}
			var CertId = Row.RowId;
			AddCert('Manf', RowId, CertId, QueryCertDetail);
		}
	});
	
	$UI.linkbutton('#CertUpLoadBT', {
		onClick: function() {
			var RowId = $('#RowId').val();
			if (RowId == '') {
				$UI.msg('alert', '����ѡ��򱣴�����������Ϣ!');
				return;
			}
			var Row = CertGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��һ��������Ϣ!');
				return;
			}
			var CertId = Row.RowId;
			var CertType = Row.CertType;
			UpLoadFileWin('Manf', RowId, 'Cert', CertType, CertId, '');
		}
	});

	$UI.linkbutton('#CertTakePhotoBT', {
		onClick: function() {
			var RowId = $('#RowId').val();
			if (RowId == '') {
				$UI.msg('alert', '����ѡ��򱣴�����������Ϣ!');
				return;
			}
			var Row = CertGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��һ��������Ϣ!');
				return;
			}
			var CertId = Row.RowId;
			var CertType = Row.CertType;
			TakePhotoWin('Manf', RowId, 'Cert', CertType, CertId, '');
		}
	});
	
	$UI.linkbutton('#SendBT', {
		onClick: function() {
			var Rows = ManfGrid.getSelections();
			if (Rows.length <= 0) {
				$UI.msg('alert', '��ѡ��Ҫ���͵���������!');
				return;
			}
			var ManfIdStr = '';
			for (var i = 0, Len = Rows.length; i < Len; i++) {
				var RowData = Rows[i];
				var ManfId = RowData['RowId'];
				if (ManfIdStr == '') { ManfIdStr = ManfId; } else { ManfIdStr = ManfIdStr + '^' + ManfId; }
			}
			if (ManfIdStr == '') {
				$UI.msg('alert', '��ѡ��Ҫ���͵���������!');
				return;
			}
			if (SerUseObj.ECS == 'Y') {
				$.cm({
					ClassName: 'web.DHCSTMHUI.ServiceForECS',
					MethodName: 'postFactories',
					ManfIdStr: ManfIdStr,
					HospId: HospId
				}, function(jsonData) {
					$UI.msg('success', '�ѷ���!');
				});
			}
		}
	});
	
	// ������Ϣ
	CertCm = [[
		{
			title: 'Ԥ��',
			field: 'Icon',
			width: 50,
			align: 'center',
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
				$UI.msg('alert', '����ѡ��򱣴�����������Ϣ!');
				return;
			}
			var CertId = row['RowId'];
			AddCert('Manf', RowId, CertId, QueryCertDetail);
		}
	});
	function QueryCertDetail(OrgId) {
		CertGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCCertDetail',
			QueryName: 'QueryCertDetail',
			query2JsonStrict: 1,
			Params: JSON.stringify(addSessionParams({ OrgType: 'Manf', OrgId: OrgId, HospId: HospId }))
		});
	}
	function Select(Manf) {
		$.cm({
			ClassName: 'web.DHCSTMHUI.ItmManfNew',
			MethodName: 'Select',
			Manf: Manf
		}, function(jsonData) {
			if (jsonData.success != 0) {
				$UI.msg('error', '��ѯ����!');
				return;
			}
			$UI.fillBlock('#BasicConditions', jsonData.BasicData);
			$('#ManfDesc_1').validatebox('validate');
			QueryCertDetail(Manf);
		});
	}
	function Save() {
		var BasicObj = $UI.loopBlock('#BasicConditions');
		var SessionParmas = addSessionParams({ BDPHospital: HospId });
		var Basic = JSON.stringify(jQuery.extend(true, BasicObj, SessionParmas));
		$.cm({
			ClassName: 'web.DHCSTMHUI.ItmManfNew',
			MethodName: 'Save',
			Basic: Basic
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Select(jsonData.rowid);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var SunPurPlan=CommParObj.SunPurPlan;  //�������� ����
	/// 20221112 ����ɹ�
	$UI.linkbutton('#LinkBT', {
		onClick: function () {
			var Row=ManfGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ����ҵ!');
				return;
			}
			var ManfId=Row.RowId;
			if (ManfId=="") {
				$UI.msg('alert', '��ѡ����ҵ!');
				return;
			}
			if (isEmpty(SunPurPlan)){
				$UI.msg('alert', '�����òɹ�ƽ̨��Ϣ!');
				return;
			}
			if (SunPurPlan=="�Ĵ�ʡ"){
				SCQueryComany(ManfId,"M");
			}
			
		}
	});
	/// ���� end
	InitHosp();
	Clear();
};
$(init);

function Clear() {
	$UI.clearBlock('#BasicConditions');
	$UI.clearBlock('#QualifyConditions');
	var DefaultData = {
		Status: 'Y'
	};
	$UI.fillBlock('#BasicConditions', DefaultData);
}

function ViewCertFile(index) {
	var RowData = CertGrid.getRows()[index];
	var OrgType = 'Manf';
	var OrgId = $('#RowId').val();
	var GrpType = 'Cert';
	var PointerType = RowData.CertType;
	var Pointer = RowData.RowId;
	var SubType = '';
	ViewFileWin(OrgType, OrgId, GrpType, PointerType, Pointer, SubType, HospId);
}

function ViewManfWin(index) {
	var RowData = ManfGrid.getRows()[index];
	var OrgType = 'Manf';
	var OrgId = RowData.RowId;
	ViewFileWin(OrgType, OrgId, '', '', '', '', HospId);
}