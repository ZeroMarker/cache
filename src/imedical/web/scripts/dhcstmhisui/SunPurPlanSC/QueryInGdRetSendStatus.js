/* 四川阳光采购 退货状态查询*/
function SCUpIngrtStatusQuery(IngdRet){
	$HUI.dialog('#SCUpIngrtStatusWin',{width: gWinWidth, height: gWinHeight}).open();
	$UI.linkbutton('#SCIngrtStatusSearchBT',{
		onClick:function(){
			SCIngrtStatusSearch();
		}
	});
	
	
	
	function SCIngrtStatusClear(){
		$UI.clearBlock('#SCIngrtStatusConditions');
		$UI.clear(SCUpIngrtStatusGrid);
		var DistrDafult = {
			SCIngrtStatusCurPageNumber:1
		};
		$UI.fillBlock('#SCIngrtStatusConditions', DistrDafult);
	}
	var SCUpIngrtStatusCm = [[{
			title: '退货明细编号',
			field: 'returnID',
			width: 220,
			sortable: true
		}, {
			title: '配送明细编号',
			field: 'distributionSerialID',
			width: 220
		}, {
			title: '退货类型',
			field: 'returnType',
			width: 100,
			sortable: true
		}, {
			title: '退货响应时间',
			field: 'returnResponseTime',
			width: 150
		}, {
			title: '是否响应',
			field: 'isResponse',
			width: 150
		}, {
			title: '拒绝原因',
			field: 'refuseReason',
			width: 150,
			align: 'left'
		}, {
			title: '发票号',
			field: 'returnInvoiceId',
			width: 200
		}, {
			title: '维护发票时间',
			field: 'returnMaintenanceInvoiceTime',
			width: 150
		}
	]];
	var SCUpIngrtStatusGrid = $UI.datagrid('#SCUpIngrtStatusGrid', {
		lazy:true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
			MethodName: 'JSQueryRetInfo',
			rows:99999
		},
		columns: SCUpIngrtStatusCm,
		showBar:true,
		idField: 'returnID',
		pagination: false
	});
	function SCIngrtStatusSearch(){
		var Row=SCUpIngrtStatusGrid.getSelected();
		if(!isEmpty(Row)){
			$UI.clear(SCUpIngrtStatusGrid);
		}
		
		var ParamsObj = $UI.loopBlock('#SCIngrtStatusConditions');
		var Page=ParamsObj.SCIngrtStatusCurPageNumber;
		if((Page=="")||(isEmpty(Page))){
			$UI.msg('alert','当前页码不能为空');
			return;
		}
		SCUpIngrtStatusGrid.load({
				ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
				MethodName: 'JSQueryRetInfo',
				rows:99999,
				Page:Page,
				IngdRet:IngdRet
			});
	}
	SCIngrtStatusClear();
	SCIngrtStatusSearch();
}

