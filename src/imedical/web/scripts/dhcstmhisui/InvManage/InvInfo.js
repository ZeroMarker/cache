var init = function () {
	var VendorParams = JSON.stringify(addSessionParams({
		APCType: "M",
		RcFlag: "Y"
	}));
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var VendorBox_1 = $HUI.combobox('#Vendor_1', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	var InvCm = [[{
		title: "RowId",
		field: 'RowId',
		width: 50,
		saveCol: true,
		hidden: true
	}, {
		title: "发票ID",
		field: 'InvId',
		width: 100
	}, {
		title: "发票代码",
		field: 'InvCode',
		width: 100
	}, {
		title: "发票号",
		field: 'InvNo',
		width: 100
	}, {
		title: "Vendor",
		field: 'Vendor',
		width: 50,
		saveCol: true,
		hidden: true
	}, {
		title: "供应商",
		field: 'VendorDesc',
		width: 200
	}, {
		title: "发票金额",
		field: 'InvAmt',
		width: 80,
		align: 'right'
	}, {
		title: "发票日期",
		field: 'InvDate',
		width: 100
	}, {
		title: "录入人",
		field: 'CreateUser',
		width: 100
	}, {
		title: "录入日期",
		field: 'CreateDate',
		width: 100
	}, {
		title: "验收标志",
		field: 'CheckFlag',
		width: 80
	}
	]];

	var InvGrid = $UI.datagrid('#InvGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.InvInfo',
			QueryName: 'GetInvInfo'
		},
		singleSelect: true,
		columns: InvCm,
		onCheck: function (rowIndex, rowData) {
			Select(rowData.RowId);
		},
		onLoadSuccess: function (data) {
			if (data.rows.length > 0) {
				InvGrid.checkRow(0);
			}
		}
	});

	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			Query();
		}
	});
	
	function Query(){
		var ParamsObj = $UI.loopBlock('#MainConditions');
		var Params = JSON.stringify(ParamsObj);
		InvGrid.load({
			ClassName: 'web.DHCSTMHUI.InvInfo',
			QueryName: 'GetInvInfo',
			Params: Params
		});
	}
	
	$UI.linkbutton('#AddBT', {
		onClick: function () {
			$UI.clearBlock('#Conditions');
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function () {
			Save();
		}
	});
	$UI.linkbutton('#UpLoadBT', {
		onClick: function () {
			var RowId = $('#RowId').val();
			if (RowId == "") {
				$UI.msg('alert', '请先选择或保存发票信息!');
				return;
			}
			UpLoadWin(RowId);
		}
	});

	$UI.linkbutton('#TakePhotoBT', {
		onClick: function () {
			var RowId = $('#RowId').val();
			if (RowId == "") {
				$UI.msg('alert', '请先选择或保存发票信息!');
				return;
			}
			TakePhotoWin(RowId);
		}
	});
	function Save() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var Params = JSON.stringify(ParamsObj);
		$.cm({
			ClassName: 'web.DHCSTMHUI.InvInfo',
			MethodName: 'Save',
			Params: Params
		}, function (jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Query();
				Select(jsonData.rowid);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	function Select(RowId) {
		$.cm({
			ClassName: 'web.DHCSTMHUI.InvInfo',
			MethodName: 'Select',
			RowId: RowId
		}, function (jsonData) {
			$UI.fillBlock('#Conditions', jsonData);
			$('#Vendor_1').validatebox("validate");
			$('#InvId').validatebox("validate");
			$('#InvCode_1').validatebox("validate");
			$('#InvNo_1').validatebox("validate");
			$('#InvAmt').validatebox("validate");
		});
	}
	// 发票图片拍照窗口
	var TakePicWindow;
	var TakePhotoWin = function (RowId) {
		var AppName = 'DHCSTPHMANFM';
		if ((!TakePicWindow) || (TakePicWindow.closed)) {
			var lnk = 'dhcstmhui.takepiccommon.csp';
			lnk = lnk + "?AppName=" + AppName;
			lnk = lnk + "&RowId=" + RowId;
			lnk = lnk + "&typeCode=" + "";
			lnk = lnk + "&typeDesc=" + "";
			lnk = lnk + "&GroupId=" + session['LOGON.GROUPID'];
			lnk = lnk + "&LocId=" + session['LOGON.CTLOCID'];
			lnk = lnk + "&UserId=" + session['LOGON.USERID'];
			TakePicWindow = window.open(lnk, "take_photo", "height=600,width=800,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=yes");
		} else {
			TakePicWindow.SetType(AppName, RowId, "", "", session['LOGON.GROUPID'], session['LOGON.CTLOCID'], session['LOGON.USERID']);
			TakePicWindow.focus();
		}
	}
}
$(init);