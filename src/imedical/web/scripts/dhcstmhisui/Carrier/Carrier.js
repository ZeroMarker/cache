var CarrierCm, CarrierGrid, CarryItmCm, CarryItmGrid;
var init = function () {
	var HospId=gHospId;
	var TableName="DHC_Carrier";
	function InitHosp() {
		var hospComp=InitHospCombo(TableName,gSessionStr);
		if (typeof hospComp ==='object'){
			HospId=$HUI.combogrid('#_HospList').getValue();
			Query();
			$('#_HospList').combogrid("options").onSelect=function(index,record){
				HospId=record.HOSPRowId;
				$UI.clearBlock('#Conditions');
				Query();
			};
		}
	}
	function Query(){
		var SessionParmas=addSessionParams({BDPHospital:HospId});
		var Paramsobj=$UI.loopBlock('Conditions');
		var Params=JSON.stringify(jQuery.extend(true,Paramsobj,SessionParmas));
		$UI.clear(CarrierGrid);
		$UI.clear(CarryItmGrid);
		CarrierGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCCarrier',
			QueryName: 'DHCCarrier',
			Params: Params
		});
	}
	
	CarrierCm = [[{
				title: 'RowId',
				field: 'RowId',
				hidden: true
			}, {
				title: '����',
				field: 'Code',
				width: 150,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				title: '����',
				field: 'Description',
				width: 150,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				title: '�ֻ���',
				field: 'Phone',
				width: 150,
				editor: {
					type: 'validatebox'
				}
			}
		]];

	CarrierGrid = $UI.datagrid('#CarrierGrid', {
			lazy: false,
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCCarrier',
				QueryName: 'DHCCarrier'
			},
			columns: CarrierCm,
			fitColumns: true,
			sortName: 'RowId',
			sortOrder: 'Desc',
			toolbar:[{
				text: '����',
				iconCls: 'icon-add',
				handler: function () {
					Add();
				}
			},{
				text: '����',
				iconCls: 'icon-save',
				handler: function () {
					Save();
				}
			}],
			onSelect: function (Index, Row) {
				CarryItmGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCCarrier',
					QueryName: 'CarryItm',
					Carrier: Row.RowId
				});
			},
			onClickCell: function (index, filed, value) {
				CarrierGrid.commonClickCell(index, filed);
			},
			onLoadSuccess: function (data) {
				if (data.rows.length > 0) {
					CarrierGrid.selectRow(0);
				}
			}
		});
		
	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			Query();
		}
	});
	
	function Add(){
		CarrierGrid.commonAddRow();
	}
	
	function Save(){
		var Rows = CarrierGrid.getChangesData();
		if (Rows === false){	//δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Rows)){	//��ϸ����
			$UI.msg("alert", "û����Ҫ�������ϸ!");
			return;
		}
		var MainObj=JSON.stringify(addSessionParams({BDPHospital:HospId}));
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCCarrier',
			MethodName: 'Save',
			Main: MainObj,
			Params: JSON.stringify(Rows)
		}, function (jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				CarrierGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	CarryItmCm = [[{
				title: '����Id',
				field: 'Inci',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: '���ʴ���',
				field: 'InciCode',
				width: 100
			}, {
				title: '��������',
				field: 'InciDesc',
				width: 150
			}, {
				title: '���',
				field: 'Spec',
				width: 100
			}, {
				title: '������',
				field: 'StkCatDesc',
				width: 100
			}, {
				title: '������λ',
				field: 'BuomDesc',
				width: 80
			}, {
				title: '��ⵥλ',
				field: 'PurUomDesc',
				width: 80
			}, {
				title: '����',
				field: 'Rp',
				width: 80,
				align: 'right'
			}, {
				title: '�ۼ�',
				field: 'Sp',
				width: 80,
				align: 'right'
			}
		]];

	CarryItmGrid = $UI.datagrid('#CarryItmGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCCarrier',
				QueryName: 'CarryItm'
			},
			columns: CarryItmCm
		});
	InitHosp();
}
$(init);