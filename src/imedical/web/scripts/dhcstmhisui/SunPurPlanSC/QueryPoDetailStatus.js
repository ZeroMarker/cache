/* �Ĵ�����ɹ� ����״̬��ѯ*/
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
			title: 'ƽ̨�������',
			field: 'orderId',
			width: 180,
			sortable: true
		}, {
			title: '�ύ����',
			field: 'subDate',
			width: 180
		}, {
			title: '�ύʱ��',
			field: 'subTime',
			width: 100
		}, {
			title: '������ϸ���',
			field: 'orderDetailID',
			width: 150
		}, {
			title: '�ܾ�����',
			field: 'refuseReason',
			width: 150,
			align: 'left'
		}, {
			title: '״̬',
			field: 'orderDetailState',
			width: 200
		}, {
			title: '��ע',
			field: 'orderDetailRemark',
			width: 150
		}, {
			title: '��ҳ��',
			field: 'totalPageCount',
			width: 200,
			hidden:true
		}, {
			title: '������',
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
			$UI.msg('alert','��ǰҳ�벻��Ϊ��');
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

