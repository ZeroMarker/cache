/* 四川阳光采购 订单状态查询*/
function SCQueryPoDetailStatus(PoId){
	$HUI.dialog('#SCInpostatusWin',{width: gWinWidth, height: gWinHeight}).open();
	$UI.linkbutton('#SCPoSearchBT',{
		onClick:function(){
			SCOrderQuery();
		}
	});
	function SCOrderClear(){
		$UI.clearBlock('#SCOrderConditions');
		$UI.clear(SCPoDetailStatusGrid);
		var DistrDafult = {
			SCCurPageNumber:1
		};
		$UI.fillBlock('#SCOrderConditions', DistrDafult);
	}
	var SCPoDetailStatusCm = [[{
			title: '平台订单编号',
			field: 'orderId',
			width: 180,
			sortable: true
		}, {
			title: '提交日期',
			field: 'subDate',
			width: 180
		}, {
			title: '提交时间',
			field: 'subTime',
			width: 100
		}, {
			title: '订单明细编号',
			field: 'orderDetailID',
			width: 150
		}, {
			title: '拒绝理由',
			field: 'refuseReason',
			width: 150,
			align: 'left'
		}, {
			title: '状态',
			field: 'orderDetailState',
			width: 200
		}, {
			title: '备注',
			field: 'orderDetailRemark',
			width: 150
		}, {
			title: '总页数',
			field: 'totalPageCount',
			width: 200,
			hidden:true
		}, {
			title: '总行数',
			field: 'totalRecordCount',
			width: 200,
			hidden:true
		}
	]];
	var SCPoDetailStatusGrid = $UI.datagrid('#SCPoDetailStatusGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
			MethodName: 'JSQueryPoItmInfo',
			rows:99999
			
		},
		columns: SCPoDetailStatusCm,
		showBar:true,
		idField: 'orderDetailID',
		pagination: false,
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				SCPoDetailStatusGrid.selectRow(0);
				var SelectedRow = SCPoDetailStatusGrid.getSelected();
				var SCTotalPageCount=SelectedRow.totalPageCount;
				var SCTotalRecordCount=SelectedRow.totalRecordCount;
				$("#SCTotalPageCount").val(SCTotalPageCount);
				$("#SCTotalRecordCount").val(SCTotalRecordCount);
			}
		}
	});
	function SCOrderQuery(){
		var Row=SCPoDetailStatusGrid.getSelected();
		if(!isEmpty(Row)){
			$UI.clear(SCPoDetailStatusGrid);
		}
		var ParamsObj = $UI.loopBlock('#SCOrderConditions');
		var Page=ParamsObj.SCCurPageNumber;
		if((Page=="")||(isEmpty(Page))){
			$UI.msg('alert','当前页码不能为空');
			return;
		}
		SCPoDetailStatusGrid.load({
			ClassName: 'web.DHCSTMHUI.ServiceForSCYGCG',
			MethodName: 'JSQueryPoItmInfo',
			rows:99999,
			Page:Page,
			PoId:PoId
		});
	}
	SCOrderClear();
	SCOrderQuery();
}

