var MainGridList;
var init = function() {
	var frm = dhcsys_getmenuform();
	var Adm = frm.EpisodeID.value;
	function Default() {
		if (!isEmpty(Adm)) {
			var PatInfo = tkMakeServerCall('web.CSSDHUI.PackageRegister.PkgRegister', 'ByAdmGetPatInfo', Adm);
			if (!isEmpty(PatInfo)) {
				$('#RegNo').text(PatInfo.split('^')[0]);
				$('#patientname').text(PatInfo.split('^')[1]);
				$('#LocName').text(PatInfo.split('^')[2]);
				$('#Code').focus();
			}
		} else {
			$UI.msg('alert', '请选择患者!');
			$('#Code').attr('disabled', 'disabled');
			return;
		}
	}
	function query() {
		MainGridList.load({
			ClassName: 'web.CSSDHUI.PackageRegister.PkgRegister',
			QueryName: 'GetPatientInfo',
			Adm: Adm,
			rows: 99999
		});
	}

	var ItemCm = [[
		{
			field: 'RowId',
			title: 'RowId',
			width: 100,
			hidden: true
		}, {
			field: 'opt',
			title: '操作',
			width: 50,
			frozen: true,
			allowExport: false,
			formatter: function(val, row, index) {
				var btn = '<div class="col-icon icon-cancel" href="#" title="删除" onclick="MainGridList.commonDeleteRow(false,' + index + ')"></div>';
				return btn;
			}
		}, {
			field: 'RegNo',
			title: '登记号',
			width: 100
		}, {
			field: 'PatName',
			title: '患者',
			width: 100
		}, {
			field: 'PatLoc',
			title: '科室',
			width: 100
		}, {
			field: 'Label',
			title: '标签',
			width: 100
		}, {
			field: 'PkgDesc',
			title: '包名',
			width: 100
		}, {
			field: 'CountNurseName',
			title: '操作人',
			width: 100
		}, {
			field: 'CountNurseTime',
			title: '操作时间',
			width: 100
		}
	]];
	MainGridList = $UI.datagrid('#RegData', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageRegister.PkgRegister',
			QueryName: 'GetPatientInfo',
			Adm: Adm,
			rows: 99999
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.PackageRegister.PkgRegister',
			MethodName: 'jsDelete'
		},
		columns: ItemCm,
		sortName: 'RowId',
		sortOrder: 'asc',
		fitColumns: true,
		pagination: true
	});

	$('#Code').keyup(function(e) {
		var curKey = e.which;
		var Label = $('#Code').val();
		var Params = JSON.stringify(addSessionParams({ Adm: Adm, Label: Label }));
		if (curKey == 13) {
			if ($('#Code').val() !== '') {
				$.cm({
					ClassName: 'web.CSSDHUI.PackageRegister.PkgRegister',
					MethodName: 'jsSaveRegister',
					Params: Params
				}, function(jsonData) {
					if (jsonData.success == 0) {
						$('#Code').val('');
						$('#Code').focus();
						MainGridList.commonReload();
					} else {
						$UI.msg('alert', jsonData.msg);
						$('#Code').val('');
						$('#Code').focus();
						return;
					}
				});
			}
		}
	});
	Default();
	query();
};
$(init);