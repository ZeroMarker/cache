/* �Ĵ�����ɹ� ��֧������ϸ״̬*/
/// ��֧������ϸ״̬
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
			title: 'ƽ̨��ϸ���',
			field: 'orderDetailId',
			width: 220,
			sortable: true
		}, {
			title: '������ϸ���',
			field: 'distributeId',
			width: 220
		}, {
			title: '��ƷID',
			field: 'procurecatalogId',
			width: 100,
			sortable: true
		}, {
			title: '������ҵ���',
			field: 'companyIdPs',
			width: 150
		}, {
			title: '������ҵ����',
			field: 'companyNamePs',
			width: 150
		}, {
			title: '������ҵ����',
			field: 'companyNameSc',
			width: 150,
			align: 'left'
		}, {
			title: '��������',
			field: 'realQuantity',
			width: 200
		}, {
			title: '������',
			field: 'realAmount',
			width: 150
		}, {
			title: '��Ʊ��',
			field: 'invoiceId',
			width: 150
		}, {
			title: '���˻�����',
			field: 'storageDate',
			width: 150
		}, {
			title: '��������',
			field: 'orderName',
			width: 150
		}, {
			title: 'HIS����',
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
			$UI.msg('alert','��ǰҳ�벻��Ϊ��');
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

