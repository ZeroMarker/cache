/* �Ĵ�����ɹ� �˻�״̬��ѯ*/
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
			title: '�˻���ϸ���',
			field: 'returnID',
			width: 220,
			sortable: true
		}, {
			title: '������ϸ���',
			field: 'distributionSerialID',
			width: 220
		}, {
			title: '�˻�����',
			field: 'returnType',
			width: 100,
			sortable: true
		}, {
			title: '�˻���Ӧʱ��',
			field: 'returnResponseTime',
			width: 150
		}, {
			title: '�Ƿ���Ӧ',
			field: 'isResponse',
			width: 150
		}, {
			title: '�ܾ�ԭ��',
			field: 'refuseReason',
			width: 150,
			align: 'left'
		}, {
			title: '��Ʊ��',
			field: 'returnInvoiceId',
			width: 200
		}, {
			title: 'ά����Ʊʱ��',
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
			$UI.msg('alert','��ǰҳ�벻��Ϊ��');
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

