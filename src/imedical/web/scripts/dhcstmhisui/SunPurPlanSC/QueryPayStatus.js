/* 四川阳光采购 待支付单明细状态*/
/// 待支付单明细状态
/// 20221129 lihui
function SCPayStatusQuery(PayId){
	$HUI.dialog('#SCPayStatusWin',{width: gWinWidth, height: gWinHeight}).open();
	$UI.linkbutton('#SCPayStatusSearchBT',{
		onClick:function(){
			SCPayStatusSearch();
		}
	});
	
	function SCPayStatusClear(){
		$UI.clearBlock('#SCPayStatusConditions');
		$UI.clear(SCPayStatusGrid);
		var PayStatusDafult = {
			SCPayStatusCurPageNumber:1
		};
		$UI.fillBlock('#SCPayStatusConditions', PayStatusDafult);
	}
	var SCPayStatusCm = [[{
			title: '平台明细编号',
			field: 'orderDetailId',
			width: 220,
			sortable: true
		}, {
			title: '配送明细编号',
			field: 'distributeId',
			width: 220
		}, {
			title: '商品ID',
			field: 'procurecatalogId',
			width: 100,
			sortable: true
		}, {
			title: '配送企业编号',
			field: 'companyIdPs',
			width: 150
		}, {
			title: '配送企业名称',
			field: 'companyNamePs',
			width: 150
		}, {
			title: '生产企业名称',
			field: 'companyNameSc',
			width: 150,
			align: 'left'
		}, {
			title: '结算数量',
			field: 'realQuantity',
			width: 200
		}, {
			title: '结算金额',
			field: 'realAmount',
			width: 150
		}, {
			title: '发票号',
			field: 'invoiceId',
			width: 150
		}, {
			title: '收退货日期',
			field: 'storageDate',
			width: 150
		}, {
			title: '订单名称',
			field: 'orderName',
			width: 150
		}, {
			title: 'HIS单号',
			field: 'hosIngdNo',
			width: 150
		}
	]];
	var SCPayStatusGrid = $UI.datagrid('#SCPayStatusGrid', {
		lazy:true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
			MethodName: 'JSQueryInpoPayItmInfo',
			rows:99999
		},
		columns: SCPayStatusCm,
		showBar:true,
		idField: 'orderDetailId',
		pagination: false
	});
	function SCPayStatusSearch(){
		var Row=SCPayStatusGrid.getSelected();
		if(!isEmpty(Row)){
			$UI.clear(SCPayStatusGrid);
		}
		
		var ParamsObj = $UI.loopBlock('#SCPayStatusConditions');
		var Page=ParamsObj.SCPayStatusCurPageNumber;
		if((Page=="")||(isEmpty(Page))){
			$UI.msg('alert','当前页码不能为空');
			return;
		}
		SCPayStatusGrid.load({
				ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
				MethodName: 'JSQueryInpoPayItmInfo',
				rows:99999,
				Page:Page,
				PayId:PayId
			});
	}
	SCPayStatusClear();
	SCPayStatusSearch();
}

