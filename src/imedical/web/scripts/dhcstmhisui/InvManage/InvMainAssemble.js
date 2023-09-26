var InvMainWin = function (IngrLoc, Fn) {
	$HUI.dialog('#InvMainWin').open();

	var FVMVendorParams = JSON.stringify(addSessionParams({
				APCType: "M",
				RcFlag: "Y"
			}));
	var FVMVendorBox = $HUI.combobox('#FVMVendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FVMVendorParams,
			valueField: 'RowId',
			textField: 'Description'
		});

	var GRMCm = [[{
				field: 'ck',
				checkbox: true
			}, {
				title: "RowId",
				field: 'RowId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: "����",
				field: 'GRNo',
				width: 200
			}, {
				title: "��Ӧ��",
				field: 'VendorDesc',
				width: 200
			}, {
				title: "����",
				field: 'Type',
				width: 100,
				saveCol: true,
				formatter: function(value,row,index){
					if (value=="G"){
						return "���";
					} else {
						return "�˻�";
					}
				}
			}, {
				title: "���۽��",
				field: 'RpAmt',
				width: 150,
				align: 'right'
			}, {
				title: "�ۼ۽��",
				field: 'SpAmt',
				width: 150,
				align: 'right'
			}
		]];

	var GRMGrid = $UI.datagrid('#GRMGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				QueryName: 'GetIngdRec'
			},
			columns: GRMCm,
			singleSelect: false,
			onCheck: function (Index, Row) {
				TotalAmt();
			},
			onUncheck: function (Index, Row) {
				TotalAmt();
			},
			onCheckAll: function (rows) {
				TotalAmt();
			},
			onUncheckAll: function (rows) {
				$('#TotalAmt').val('');
			}
		});

	$UI.linkbutton('#FVMQueryBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#FVMConditions');
			if (isEmpty(ParamsObj.StartDate)) {
				$UI.msg('alert','��ʼ���ڲ���Ϊ��!');
				return;
			}
			if (isEmpty(ParamsObj.EndDate)) {
				$UI.msg('alert','��ֹ���ڲ���Ϊ��!');
				return;
			}
			if (isEmpty(ParamsObj.Vendor)) {
				$UI.msg('alert','��Ӧ�̲���Ϊ��!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			GRMGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				QueryName: 'GetIngdRec',
				LocId: IngrLoc,
				Params: Params
			});
		}
	});
	
	$UI.linkbutton('#FVMSaveBT', {
		onClick: function () {
			var Rows = GRMGrid.getSelections();
			if (Rows.length <= 0) {
				$UI.msg('alert','��ѡ��Ҫ��ϵ�����˻���!');
				return;
			}
			var TotalAmt = $('#TotalAmt').val();
			if (TotalAmt==""||TotalAmt==0){
				$UI.msg('alert','��ϵ�����˻��������ܶ�Ϊ��!');
				return;
			}
			var ParamsObj = $UI.loopBlock('#FVMConditions');
			var Main = JSON.stringify(ParamsObj);
			var Detail = GRMGrid.getSelectedData();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				MethodName: 'Save',
				LocId: IngrLoc,
				Main: Main,
				Detail: JSON.stringify(Detail)
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					Fn(jsonData.rowid);
					$HUI.dialog('#InvMainWin').close();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
			
		}
	});
	
	$UI.linkbutton('#FVMClearBT', {
		onClick: function () {
			Clear();
		}
	});

	function Clear() {
		$UI.clearBlock('#FVMConditions');
		$UI.clear(GRMGrid);
		var Dafult = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
		}
		$UI.fillBlock('#FVMConditions', Dafult);
	}
	
	function TotalAmt() {
		var TotalAmt = 0;
		var Rows = GRMGrid.getChecked();
		for (var i = 0; i < Rows.length; i++) {
			var RpAmt = Rows[i].RpAmt;
			TotalAmt = Number(TotalAmt) + Number(RpAmt);
		}
		$('#TotalAmt').val(TotalAmt);
	}

	Clear();
}