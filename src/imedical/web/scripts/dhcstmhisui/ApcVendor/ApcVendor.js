var VendorCm, VendorGrid;
var init = function () {
	var VendorCat = $HUI.combobox('#VendorCat', {
			url: $URL + '?ClassName=web.DHCSTMHUI.APCVendCat&QueryName=GetVendorCat&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description'
		});

	var VendorCat_1 = $HUI.combobox('#VendorCat_1', {
			url: $URL + '?ClassName=web.DHCSTMHUI.APCVendCat&QueryName=GetVendorCat&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description'
		});

	VendorCm = [[{
				title: "����",
				field: 'Icon',
				width: 50,
				align: 'center',
				formatter: function (value, row, index) {
					var str = "<a href='#' onclick='VendorPicWin(" + row.RowId + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/img.png' title='�鿴ͼƬ' border='0'></a>";
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
				title: "ע���ʽ�",
				field: 'CrAvail',
				align: 'right',
				width: 100
			}, {
				title: "��ͬ����",
				field: 'LstPoDate',
				width: 100
			}, {
				title: "����",
				field: 'Fax',
				width: 100
			}, {
				title: "����",
				field: 'President',
				width: 100
			}, {
				title: "�������֤",
				field: 'PresidentCard',
				width: 100
			}, {
				title: "���˵绰",
				field: 'PresidentTel',
				width: 100
			}, {
				title: "���ҵ������",
				field: 'LstBsDate',
				width: 100
			}, {
				title: "ʹ�ñ�־",
				field: 'Status',
				width: 100,
				formatter: function (value, row, index) {
					if (value == "A") {
						return "ʹ��";
					} else {
						return "ͣ��";
					}
				}
			}
		]];

	VendorGrid = $UI.datagrid('#VendorGrid', {
			lazy: false,
			queryParams: {
				ClassName: 'web.DHCSTMHUI.APCVendor',
				QueryName: 'APCVendor'
			},
			columns: VendorCm,
			onSelect: function (Index, Row) {
				Clear();
				Select(Row.RowId);
			},
			onLoadSuccess: function (data) {
				if (data.rows.length > 0) {
					VendorGrid.selectRow(0);
				}
			}
		});

	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#MainConditions');
			var Params = JSON.stringify(ParamsObj);
			VendorGrid.load({
				ClassName: 'web.DHCSTMHUI.APCVendor',
				QueryName: 'APCVendor',
				Params: Params
			});
		}
	});

	$UI.linkbutton('#AddBT_1', {
		onClick: function () {
			Clear();
		}
	});
	$UI.linkbutton('#AddBT_2', {
		onClick: function () {
			Clear();
		}
	});
	$UI.linkbutton('#AddBT_3', {
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
	$UI.linkbutton('#SaveBT_3', {
		onClick: function () {
			Save();
		}
	});
	$UI.linkbutton('#UpLoadBT', {
		onClick: function () {
			var RowId = $('#RowId').val();
			if (RowId == "") {
				$UI.msg('alert', '����ѡ��򱣴湩Ӧ����Ϣ!');
				return;
			}
			var Qualifications = $("#Qualifications").combo('getValue');
			if (Qualifications == "" || Qualifications == null) {
				$UI.msg('alert', '��ѡ��������Ϣ!');
				return;
			}
			UpLoadWin(RowId,Qualifications);
		}
	});

	$UI.linkbutton('#TakePhotoBT', {
		onClick: function () {
			var RowId = $('#RowId').val();
			if (RowId == "") {
				$UI.msg('alert', '����ѡ��򱣴湩Ӧ����Ϣ!');
				return;
			}
			var Qualifications = $("#Qualifications").combo('getValue');
			if (Qualifications == "" || Qualifications == null) {
				$UI.msg('alert', '��ѡ��������Ϣ!');
				return;
			}
			TakePhotoWin(RowId,Qualifications);
		}
	});
}
$(init);

function Select(Vendor) {
	$.cm({
		ClassName: 'web.DHCSTMHUI.APCVendor',
		MethodName: 'Select',
		Vendor: Vendor
	}, function (jsonData) {
		$UI.fillBlock('#BasicConditions', jsonData);
		$UI.fillBlock('#BasicCheckConditions', jsonData);
		$UI.fillBlock('#QualifyConditions', jsonData);
		$UI.fillBlock('#SalesManConditions', jsonData);
	});
}
function Clear() {
	$UI.clearBlock('#BasicConditions');
	$UI.clearBlock('#BasicCheckConditions');
	$UI.clearBlock('#QualifyConditions');
	$UI.clearBlock('#SalesManConditions');
	$('#VendorDesc_1').focus();
	var Dafult = {
			Status: "A"
		}
	$UI.fillBlock('#BasicConditions', Dafult)
}
function Save() {
	var BasicObj = $UI.loopBlock('#BasicConditions');
	var CheckObj = $UI.loopBlock('#BasicCheckConditions');
	var QualifyObj = $UI.loopBlock('#QualifyConditions');
	var SalesManObj = $UI.loopBlock('#SalesManConditions');
	var Basic = JSON.stringify(BasicObj);
	var Check = JSON.stringify(CheckObj);
	var Qualify = JSON.stringify(QualifyObj);
	var SalesMan = JSON.stringify(SalesManObj);
	$.cm({
		ClassName: 'web.DHCSTMHUI.APCVendor',
		MethodName: 'Save',
		Basic: Basic,
		Check: Check,
		Qualify: Qualify,
		SalesMan: SalesMan
	}, function (jsonData) {
		if (jsonData.success == 0) {
			$UI.msg('success', jsonData.msg);
			Select(jsonData.rowid);
		} else {
			$UI.msg('error', jsonData.msg);
		}
	});
}
