function TransQuery(Incil,Date){	
	$UI.linkbutton('#FQueryBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#FindConditions');
			var Params=JSON.stringify(ParamsObj);
			FDetailInfoGrid.load({
				ClassName: 'web.DHCSTMHUI.LocItmTransMove',
				MethodName: 'LocItmStkMoveDetail',
				ParamStr:Params,
				INCIL:Incil
			});
		}
	});
	var DetailInfoCm = [[{
			title: 'TrId',
			field: 'TrId',
			width: 50,
			align: 'left',
			sortable: true,
			hidden: true
		}, {
			title: '业务RowId',
			field: 'TrPointer',
			width: 150,
			hidden: true
		}, {
			title: '日期',
			field: 'TrDate',
			width: 150,
			sortable: true
		}, {
			title: '批号效期',
			field: 'BatExp',
			width: 150
		}, {
			title: '单位',
			field: 'PurUom',
			width: 150
		}, {
			title: '售价',
			field: 'Sp',
			width: 150,
			align: 'right'
		}, {
			title: '进价',
			field: 'Rp',
			width: 80,
			align: 'right'
		}, {
			title: '结余数量',
			field: 'EndQtyUom',
			width: 70,
			align: 'right'
		}, {
			title: '数量',
			field: 'TrQtyUom',
			width: 80,
			align: 'right'
		}, {
			title: '进价金额',
			field: 'RpAmt',
			align: 'right',
			width: 100
		}, {
			title: '售价金额',
			field: 'SpAmt',
			align: 'right',
			width: 100
		}, {
			title: '处理号',
			field: 'TrNo',
			width: 100
		}, {
			title: '处理人',
			field: 'TrAdm',
			width: 150
		}, {
			title: '摘要',
			field: 'TrMsg',
			width: 150
		}, {
			title: '结余金额(进价)',
			field: 'EndRpAmt',
			width: 150,
			align: 'right'
		}, {
			title: '结余金额(售价)',
			field: 'EndSpAmt',
			width: 150,
			align: 'right'
		}, {
			title: '供应商',
			field: 'Vendor',
			width: 150
		}, {
			title: '厂商',
			field: 'Manf',
			width: 150
		}, {
			title: '操作人',
			field: 'OperateUser',
			width: 150
		}
	]];
	var FDetailInfoGrid = $UI.datagrid('#FDetailInfoGrid', {
		lazy:true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmTransMove',
			MethodName: 'LocItmStkMoveDetail'
		},
		columns: DetailInfoCm,
		showBar:true
	});
	$HUI.dialog('#TransMoveInfoWin',{
		onOpen: function(){
			var Dafult = {
			StartDate:Date,
			EndDate:Date			
			};
		$UI.fillBlock('#FindConditions', Dafult);
		var ParamsObj=$UI.loopBlock('#FindConditions');
		var Params=JSON.stringify(ParamsObj);
		FDetailInfoGrid.load({
			ClassName: 'web.DHCSTMHUI.LocItmTransMove',
			MethodName: 'LocItmStkMoveDetail',
			ParamStr:Params,
			INCIL:Incil
		});
	}
	}).open();
}
