var ContractCm, ContractGrid, ItmCm, ItmGrid, VendorItmCm, VendorItmGrid;
var HospId=gHospId;
var TableName="APC_Vendor";
var init = function () {
	function InitHosp() {
		var hospComp=InitHospCombo(TableName,gSessionStr);
		if (typeof hospComp ==='object'){
			HospId=$HUI.combogrid('#_HospList').getValue();
			Select();
			$('#_HospList').combogrid("options").onSelect=function(index,record){
				HospId=record.HOSPRowId;
				setStkGrpHospid(HospId);
				$HUI.combotree('#Scg').load(HospId);
				Select();
			};
		}
		setStkGrpHospid(HospId);
	}
	var VendorBox = $HUI.combobox('#Vendor', {
			valueField: 'RowId',
			textField: 'Description',
			onShowPanel: function(){
				var Params = JSON.stringify(addSessionParams({APCType: "M",RcFlag: "Y",BDPHospital:HospId}));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+Params;
				VendorBox.reload(url);
			}
		});

	ContractCm = [[{
				title: 'RowId',
				field: 'RowId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: "����",
				field: 'Icon',
				width: 80,
				align: 'center',
				formatter: function (value, row, index) {
					var str = "<a href='#' onclick='Update(" + row.RowId + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/pencil.png' title='�༭' border='0'></a>";
					str = str + "&nbsp;&nbsp;<a href='#' onclick='ViewPic(" + row.RowId + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/img.png' title='�鿴ͼƬ' border='0'></a>";
					return str;
				}
			}, {
				title: '��ͬ��',
				field: 'ContractNo',
				width: 150
			}, {
				title: '��ע',
				field: 'Remark',
				width: 100
			}, {
				title: '��Ӧ��',
				field: 'VendorDesc',
				width: 200
			}, {
				title: '��Ч����',
				field: 'StartDate',
				width: 150
			}, {
				title: "��ֹ����",
				field: 'EndDate',
				width: 150
			}, {
				title: "�ٲɱ�־",
				field: 'LcFlag',
				align: 'center',
				width: 80
			}, {
				title: "ͣ�ñ�־",
				field: 'StopFlag',
				align: 'center',
				width: 80
			}
		]];

	ContractGrid = $UI.datagrid('#ContractGrid', {
			lazy: false,
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
				QueryName: 'QueryCont'
			},
			columns: ContractCm,
			onSelect: function (index, row) {
				ItmGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
					QueryName: 'QueryItmCont',
					ContId: row.RowId
				});
			},
			onLoadSuccess: function (data) {
				if (data.rows.length > 0) {
					ContractGrid.selectRow(0);
				}
			}
		});

	ToolBar = [{
			text: '����',
			iconCls: 'icon-save',
			handler: function () {
				var Row = ContractGrid.getSelected();
				if (isEmpty(Row)) {
					$UI.msg('alert', '��ѡ���ͬ��Ϣ!');
					return;
				}
				var Detail = ItmGrid.getChangesData('InciId');
				if (Detail === false){	//δ��ɱ༭����ϸΪ��
					return;
				}
				if (isEmpty(Detail)){	//��ϸ����
					$UI.msg("alert", "û����Ҫ�������ϸ!");
					return;
				}
				showMask();
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
					MethodName: 'SaveItmCont',
					ContId: Row.RowId,
					Detail: JSON.stringify(Detail)
				}, function (jsonData) {
					hideMask();
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						Select();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}, '-', {
			text: '<div id="ScgBox"><label>����</label>&nbsp;&nbsp;&nbsp;&nbsp;<input id="Scg" name="Scg" class="hisui-stkscgcombotree" style="width:150px;"></div>'
		}
	];

	var HandlerParams = function () {
		var Scg = $("#Scg").combotree('getValue');
		var Obj = {
			StkGrpRowId: Scg,
			StkGrpType: "M",
			BDPHospital:HospId
		};
		return Obj;
	};

	var SelectRow = function (row) {
		ItmGrid.updateRow({
			index:ItmGrid.editIndex,
			row: {
				InciId:row.InciDr,
				InciCode:row.InciCode,
				InciDesc:row.InciDesc,
				Spec:row.Spec
			}
		});
		setTimeout(function () {
			ItmGrid.refreshRow();
			ItmGrid.startEditingNext('InciDesc');
		}, 0);
	};

	ItmCm = [[{
				field: 'ck',
				checkbox: true
			}, {
				title: 'RowId',
				field: 'RowId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: '����Id',
				field: 'InciId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: '���ʴ���',
				field: 'InciCode',
				width: 150
			}, {
				title: '��������',
				field: 'InciDesc',
				width: 200,
				editor: InciEditor(HandlerParams, SelectRow)
			}, {
				title: '���',
				field: 'Spec',
				width: 150
			}
		]];

	ItmGrid = $UI.datagrid('#ItmGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
				QueryName: 'QueryItmCont'
			},
			deleteRowParams: {
				ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
				MethodName: 'DelItmCont'
			},
			columns: ItmCm,
			fitColumns: true,
			singleSelect: false,
			showAddDelItems: true,
			toolbar: ToolBar,
			onClickCell: function (index, field, value) {
				ItmGrid.commonClickCell(index, field);
			}
		});

	VenToolBar = [{
			text: '<div id="VendorBox"><label>��Ӧ��</label>&nbsp;&nbsp;&nbsp;&nbsp;<select id="ItmVendor" name="Vendor" class="hisui-combobox" style="width:150px;"></select></div>'
		}, {
			text: '��ѯ',
			iconCls: 'icon-search',
			handler: function () {
				var Vendor = $("#ItmVendor").combo('getValue');
				if (Vendor == "" || Vendor == null) {
					$UI.msg('alert', '��ѡ��Ӧ��!');
					return;
				}
				var Row = ContractGrid.getSelected();
				if (isEmpty(Row)) {
					$UI.msg('alert', '��ѡ���ͬ��Ϣ!');
					return;
				}
				VendorItmGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
					QueryName: 'QueryItmByVendor',
					Vendor: Vendor,
					ContId: Row.RowId,
				});
			}
		}, {
			text: '����',
			iconCls: 'icon-save',
			handler: function () {
				var Row = ContractGrid.getSelected();
				if (isEmpty(Row)) {
					$UI.msg('alert', '��ѡ���ͬ��Ϣ!');
					return;
				}
				var Rows = VendorItmGrid.getSelections();
				if (Rows.length <= 0) {
					$UI.msg('alert', '��ѡ��Ҫ����Ĺ�Ӧ��������Ϣ!');
					return;
				}
				var Detail = VendorItmGrid.getSelectedData();
				showMask();
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
					MethodName: 'SaveItmCont',
					ContId: Row.RowId,
					Detail: JSON.stringify(Detail)
				}, function (jsonData) {
					hideMask();
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						Select();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		}
	];

	VendorItmCm = [[{
				field: 'ck',
				checkbox: true
			}, {
				title: '����Id',
				field: 'InciId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: '����',
				field: 'InciCode',
				width: 150
			}, {
				title: '����',
				field: 'InciDesc',
				width: 200
			}, {
				title: '���',
				field: 'Spec',
				width: 150
			}
		]];

	VendorItmGrid = $UI.datagrid('#VendorItmGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
				QueryName: 'QueryItmByVendor'
			},
			toolbar: VenToolBar,
			columns: VendorItmCm,
			fitColumns: true,
			singleSelect: false
		});

	var ItmVendorBox = $HUI.combobox('#ItmVendor', {
			valueField: 'RowId',
			textField: 'Description',
			onShowPanel: function(){
				var Params = JSON.stringify(addSessionParams({APCType: "M",RcFlag: "Y",BDPHospital:HospId}));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+Params;
				ItmVendorBox.reload(url);
			}
		});

	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			Select();
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			$("#ItmVendor").combobox('clear');
			$("#Scg").combobox('clear');
			$UI.clearBlock('#MainConditions');
			$UI.clear(ContractGrid);
			$UI.clear(ItmGrid);
			$UI.clear(VendorItmGrid);
		}
	});

	$UI.linkbutton('#AddBT', {
		onClick: function () {
			AddWin("", Select,HospId);
		}
	});
	$UI.linkbutton('#UpPicBT',{
		onClick:function(){
			UpLoader();
		}
	});	
	$.parser.parse('#VendorBox');
	$.parser.parse('#ScgBox');
	
	InitHosp();
};
$(init);

function Select() {
	var SessionParmas=addSessionParams({BDPHospital:HospId});
	var Paramsobj=$UI.loopBlock('#MainConditions');
	var Params=JSON.stringify(jQuery.extend(true,Paramsobj,SessionParmas));
	
	$UI.clear(ContractGrid);
	$UI.clear(ItmGrid);
	$UI.clear(VendorItmGrid);
	ContractGrid.load({
		ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
		QueryName: 'QueryCont',
		Params: Params
	});
}

function Update(ContId) {
	AddWin(ContId, Select,HospId);
}