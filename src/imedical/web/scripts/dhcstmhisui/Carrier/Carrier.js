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
				title: '代码',
				field: 'Code',
				width: 150,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				title: '名称',
				field: 'Description',
				width: 150,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				title: '手机号',
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
				text: '新增',
				iconCls: 'icon-add',
				handler: function () {
					Add();
				}
			},{
				text: '保存',
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
		if (Rows === false){	//未完成编辑或明细为空
			return;
		}
		if (isEmpty(Rows)){	//明细不变
			$UI.msg("alert", "没有需要保存的明细!");
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
				title: '物资Id',
				field: 'Inci',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: '物资代码',
				field: 'InciCode',
				width: 100
			}, {
				title: '物资名称',
				field: 'InciDesc',
				width: 150
			}, {
				title: '规格',
				field: 'Spec',
				width: 100
			}, {
				title: '库存分类',
				field: 'StkCatDesc',
				width: 100
			}, {
				title: '基本单位',
				field: 'BuomDesc',
				width: 80
			}, {
				title: '入库单位',
				field: 'PurUomDesc',
				width: 80
			}, {
				title: '进价',
				field: 'Rp',
				width: 80,
				align: 'right'
			}, {
				title: '售价',
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