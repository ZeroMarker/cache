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
	
	// 根据接口启用控制相关按钮展示
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
			title: '预览',
			field: 'Icon',
			width: 50,
			align: 'center',
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '<div class="icon-img col-icon" title="查看图片" href="#" onclick="ViewManfWin(' + index + ')"></div>';
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
			field: 'ManfCode',
			width: 100
		}, {
			title: '名称',
			field: 'ManfDesc',
			width: 150
		}, {
			title: '电话',
			field: 'Tel',
			width: 100
		}, {
			title: '地址',
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
				$UI.msg('alert', '请先选择或保存生产厂家信息!');
				return;
			}
			AddCert('Manf', RowId, '', QueryCertDetail);
		}
	});
	
	$UI.linkbutton('#SaveCertBT', {
		onClick: function() {
			var RowId = $('#RowId').val();
			if (RowId == '') {
				$UI.msg('alert', '请先选择或保存生产厂家信息!');
				return;
			}
			var Row = CertGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择修改的资质信息!');
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
				$UI.msg('alert', '请先选择或保存生产厂家信息!');
				return;
			}
			var Row = CertGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择一条资质信息!');
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
				$UI.msg('alert', '请先选择或保存生产厂家信息!');
				return;
			}
			var Row = CertGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择一条资质信息!');
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
				$UI.msg('alert', '请选择要推送的生产厂家!');
				return;
			}
			var ManfIdStr = '';
			for (var i = 0, Len = Rows.length; i < Len; i++) {
				var RowData = Rows[i];
				var ManfId = RowData['RowId'];
				if (ManfIdStr == '') { ManfIdStr = ManfId; } else { ManfIdStr = ManfIdStr + '^' + ManfId; }
			}
			if (ManfIdStr == '') {
				$UI.msg('alert', '请选择要推送的生产厂家!');
				return;
			}
			if (SerUseObj.ECS == 'Y') {
				$.cm({
					ClassName: 'web.DHCSTMHUI.ServiceForECS',
					MethodName: 'postFactories',
					ManfIdStr: ManfIdStr,
					HospId: HospId
				}, function(jsonData) {
					$UI.msg('success', '已发送!');
				});
			}
		}
	});
	
	// 资质信息
	CertCm = [[
		{
			title: '预览',
			field: 'Icon',
			width: 50,
			align: 'center',
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
				$UI.msg('alert', '请先选择或保存生产厂家信息!');
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
				$UI.msg('error', '查询有误!');
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
	var SunPurPlan=CommParObj.SunPurPlan;  //参数设置 公共
	/// 20221112 阳光采购
	$UI.linkbutton('#LinkBT', {
		onClick: function () {
			var Row=ManfGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择企业!');
				return;
			}
			var ManfId=Row.RowId;
			if (ManfId=="") {
				$UI.msg('alert', '请选择企业!');
				return;
			}
			if (isEmpty(SunPurPlan)){
				$UI.msg('alert', '请配置采购平台信息!');
				return;
			}
			if (SunPurPlan=="四川省"){
				SCQueryComany(ManfId,"M");
			}
			
		}
	});
	/// 阳光 end
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