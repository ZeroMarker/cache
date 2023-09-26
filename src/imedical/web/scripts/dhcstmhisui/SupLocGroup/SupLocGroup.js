var init = function () {
	var HospId="";
	function InitHosp() {
		var hospComp=InitHospCombo("CT_Loc",gSessionStr);
		if (typeof hospComp ==='object'){
			HospId=$HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid("options").onSelect=function(index,record){
				HospId=record.HOSPRowId;
				$UI.clearBlock('UnAuthorLocTB');
				$UI.clearBlock('StkLocTB');
				SearchBT();
			};
		}else{
			HospId=gHospId;
		}
	}
	var GroupBox = $HUI.combobox('#Group', {
			//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetGroup&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			onShowPanel:function(){
				GroupBox.clear();
				var Params=JSON.stringify(addSessionParams({BDPHospital:HospId}));
				var url=$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetGroup&ResultSetType=array&Params='+Params;
				GroupBox.reload(url);
			}
		});
	$('#Group').combobox({
		onChange: function (TGroupId, FGroupId) {
			Query();
		}
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			Query()
		}
	});
	function Query() {
		$UI.clear(UnAuthorLocGrid);
		var ParamsObj = $UI.loopBlock('StkLocTB');
		if (isEmpty(ParamsObj.Group)) {
			$UI.msg('alert', '安全组不能为空!')
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		StkLocGroupGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCTransferLocConf',
			QueryName: 'AuthorizedLoc',
			Params: Params
		});
		SearchBT();
	}
	$UI.linkbutton('#SaveBT', {
		onClick: function () {
			Save();
		}
	});
	function Save() {
		var Rows = StkLocGroupGrid.getChangesData();
		if (Rows === false){	//未完成编辑或明细为空
			return;
		}
		if (isEmpty(Rows)){	//明细不变
			$UI.msg("alert", "没有需要保存的明细!");
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCTransferLocConf',
			MethodName: 'SaveDefat',
			Rows: JSON.stringify(Rows)
		}, function (jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Query();
				SearchBT();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#DeleteBT', {
		onClick: function () {
			Delete();
		}
	});
	function Delete() {
		var Rows = StkLocGroupGrid.getSelectedData();
		if (isEmpty(Rows)) {
			$UI.msg('alert', '没有选中的信息!')
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCTransferLocConf',
			MethodName: 'Delete',
			Params: JSON.stringify(Rows)
		}, function (jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Query()
				SearchBT();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});

	}
	var StkLocGroupGridCm = [[{
				title: 'RowId',
				field: 'RowId',
				hidden: true
			}, {
				title: 'LocId',
				field: 'LocId',
				hidden: true
			}, {
				title: '代码',
				field: 'LocCode',
				width: 200
			}, {
				title: '描述',
				field: 'LocDesc',
				width: 200
			}, {
				title: '缺省标志',
				field: 'DefaultFlag',
				width: 130,
				align: 'center',
				formatter: BoolFormatter,
				editor: {
					type: 'checkbox',
					options: {
						on: 'Y',
						off: 'N'
					}
				}
			}
		]];
	var StkLocGroupGrid = $UI.datagrid('#StkLocGroupGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCTransferLocConf',
				QueryName: 'AuthorizedLoc'
			},
			columns: StkLocGroupGridCm,
			onClickCell: function (index, filed, value) {
				var Row = StkLocGroupGrid.getRows()[index];
				var Id = Row.RowId;
				if (!isEmpty(Id)) {}
				StkLocGroupGrid.commonClickCell(index, filed)
			}
		});
	$UI.linkbutton('#SearchBT', {
		onClick: function () {
			SearchBT();
		}
	});
	function SearchBT() {
		$UI.clear(StkLocGroupGrid);
		$UI.clear(UnAuthorLocGrid);
		var ParamstmpObj = $UI.loopBlock('StkLocTB');
		var ParamsObj = $UI.loopBlock('UnAuthorLocTB');
		ParamsObj = jQuery.extend(true, ParamsObj, {
				Group: ParamstmpObj.Group,
				Hospital:HospId
			});
		if (isEmpty(ParamsObj.Group)) {
			$UI.msg('alert', '安全组不能为空!')
			return;
		}
		var Params = JSON.stringify(addSessionParams(ParamsObj));
		$UI.clear(UnAuthorLocGrid);
		UnAuthorLocGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCTransferLocConf',
			QueryName: 'UnAuthorizedLoc',
			Params: Params
		});
	}
	var UnAuthorLocGridCm = [[{
				title: 'LocId',
				field: 'LocId',
				hidden: true
			}, {
				title: '科室代码',
				field: 'LocCode',
				width: 250
			}, {
				title: '科室描述',
				field: 'LocDesc',
				width: 250
			}
		]];
	var UnAuthorLocGrid = $UI.datagrid('#UnAuthorLocGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCTransferLocConf',
				QueryName: 'UnAuthorizedLoc'
			},
			columns: UnAuthorLocGridCm,
			onDblClickRow: function (index, row) {
				AddLocStkGrp(row.LocId)

			}
		});
	function AddLocStkGrp(LocId) {
		if (LocId == "") {
			$UI.msg('alert', '科室不能为空!')
			return;
		}
		var ParamsObj = $UI.loopBlock('StkLocTB');
		var Group = ParamsObj.Group;
		if (isEmpty(Group)) {
			$UI.msg('alert', '安全组不能为空!')
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCTransferLocConf',
			MethodName: 'Insert',
			Frloc: LocId,
			GroupId: Group
		}, function (jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				StatusGrpGrid.reload()
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
		Query();
		SearchBT();
	}
	InitHosp();
}
$(init);
