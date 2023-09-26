var ManfCm, ManfGrid;
var init = function () {
	
	var ManfParams=JSON.stringify(addSessionParams({}));
	var ManfBox = $HUI.combobox('#ParManf', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params='+ManfParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	ManfCm = [[{
				title: "操作",
				field: 'Icon',
				width: 50,
				align: 'center',
				formatter: function (value, row, index) {
					var str = "<a href='#' onclick='ManfPicWin(" + row.RowId + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/img.png' title='查看图片' border='0'></a>";
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
			lazy: false,
			queryParams: {
				ClassName: 'web.DHCSTMHUI.ItmManf',
				QueryName: 'ItmManf'
			},
			columns: ManfCm,
			fitColumns: true,
			onSelect: function (Index, Row) {
				Clear();
				Select(Row.RowId);
			},
			onLoadSuccess: function (data) {
				if (data.rows.length > 0) {
					ManfGrid.selectRow(0);
				}
			}
		});
	
	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#MainConditions');
			var Params = JSON.stringify(ParamsObj);
			ManfGrid.load({
				ClassName: 'web.DHCSTMHUI.ItmManf',
				QueryName: 'ItmManf',
				Params: Params
			});
		}
	});
	
	$UI.linkbutton('#AddBT_1', {
		onClick: function () {
			Clear();
			$("#Status_1").combobox('setValue', "Y");
		}
	});
	$UI.linkbutton('#AddBT_2', {
		onClick: function () {
			Clear();
		}
	});
	$UI.linkbutton('#SaveBT_1', {
		onClick: function () {
			Save();
		}
	});
	$UI.linkbutton('#SaveBT_2', {
		onClick: function () {
			Save();
		}
	});
	$UI.linkbutton('#UpLoadBT', {
		onClick: function () {
			var RowId = $('#RowId').val();
			if (RowId == "") {
				$UI.msg('alert', '请先选择或保存厂商信息!');
				return;
			}
			var Qualifications = $("#Qualifications").combo('getValue');
			if (Qualifications == "" || Qualifications == null) {
				$UI.msg('alert', '请选择资质信息!');
				return;
			}
			UpLoadWin(RowId, Qualifications);
		}
	});

	$UI.linkbutton('#TakePhotoBT', {
		onClick: function () {
			var RowId = $('#RowId').val();
			if (RowId == "") {
				$UI.msg('alert', '请先选择或保存厂商信息!');
				return;
			}
			var Qualifications = $("#Qualifications").combo('getValue');
			if (Qualifications == "" || Qualifications == null) {
				$UI.msg('alert', '请选择资质信息!');
				return;
			}
			TakePhotoWin(RowId, Qualifications);
		}
	});

}
$(init);

function Select(Manf) {
	$.cm({
		ClassName: 'web.DHCSTMHUI.ItmManf',
		MethodName: 'Select',
		Manf: Manf
	}, function (jsonData) {
		$UI.fillBlock('#BasicConditions', jsonData);
		$UI.fillBlock('#QualifyConditions', jsonData);
	});
}
function Clear() {
	$UI.clearBlock('#BasicConditions');
	$UI.clearBlock('#QualifyConditions');
	$('#ManfDesc_1').focus();
	var Dafult = {
			Status: "A"
		}
	$UI.fillBlock('#BasicConditions', Dafult)
}
function Save() {
	var BasicObj = $UI.loopBlock('#BasicConditions');
	var QualifyObj = $UI.loopBlock('#QualifyConditions');
	var Basic = JSON.stringify(BasicObj);
	var Qualify = JSON.stringify(QualifyObj);
	$.cm({
		ClassName: 'web.DHCSTMHUI.ItmManf',
		MethodName: 'Save',
		Basic: Basic,
		Qualify: Qualify
	}, function (jsonData) {
		if (jsonData.success == 0) {
			$UI.msg('success', jsonData.msg);
			Select(jsonData.rowid);
		} else {
			$UI.msg('error', jsonData.msg);
		}
	});
}
