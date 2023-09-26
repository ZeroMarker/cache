
var FindWin = function(Fn, StatusFlag, HvFlag){
	
	if(StatusFlag == undefined){
		StatusFlag = '';
	}
	if(HvFlag == undefined){
		HvFlag = '';
	}

	$HUI.dialog('#FindWin',{width: gWinWidth, height: gWinHeight}).open();
	
	$UI.linkbutton('#FQueryBT',{
		onClick:function(){
			FindQuery();
		}
	});
	function FindQuery(){
		$UI.clear(FDetailGrid);
		$UI.clear(FMasterGrid);
		var ParamsObj = $UI.loopBlock('#FindConditions');
		ParamsObj.FrLoc = $('#InitFrLoc').combobox('getValue');
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return;
		}
		if(isEmpty(ParamsObj.EndDate)){
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return;
		}
		if(isEmpty(ParamsObj.FrLoc)){
			$UI.msg('alert', '������Ҳ���Ϊ��!');
			return;
		}
		if(isEmpty(ParamsObj.Status)){
			ParamsObj.Status = '10,11,20,30';
		}
		ParamsObj.HVFlag=HvFlag;
		var Params = JSON.stringify(ParamsObj);
		FMasterGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'DHCINIsTrfM',
			Params: Params
		});
	}
	
	$UI.linkbutton('#FComBT',{
		onClick: function(){
			var Row = FMasterGrid.getSelected();
			if(isEmpty(Row)){
				$UI.msg('alert', '��ѡ��Ҫ���صĵ���!');
			}
			Fn(Row['RowId']);
			$HUI.dialog('#FindWin').close();
		}
	});
	$UI.linkbutton('#FClearBT',{
		onClick:function(){
			Clear();
		}
	});
	function Clear(){
		$UI.clearBlock('#FindConditions');
		$UI.clear(FMasterGrid);
		$UI.clear(FDetailGrid);
		var Dafult = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate()
		};
		$UI.fillBlock('#FindConditions', Dafult);
	}

	var FReqLocParams=JSON.stringify(addSessionParams({Type:'All'}));
	var FReqLocBox = $HUI.combobox('#FReqLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+FReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var FStatusData;
	if(StatusFlag == 'Y'){
		FStatusData = [
			{RowId: '', Description: ''},
			{RowId: '10', Description: 'δ���'},
			{RowId: '11', Description: '�����'},
			{RowId: '20', Description: '������˲�ͨ��'},
			{RowId: '21', Description: '�������ͨ��'},
			{RowId: '30', Description: '�ܾ�����'},
			{RowId: '31', Description: '�ѽ���'}
		];
	}else{
		FStatusData = [
			{RowId: '', Description: ''},
			{RowId: '10', Description: 'δ���'},
			{RowId: '11', Description: '�����'},
			{RowId: '20', Description: '������˲�ͨ��'},
			{RowId: '30', Description: '�ܾ�����'}
		];
	}
	$('#FStatus').simplecombobox({
		data: FStatusData
	});
	
	var FMasterCm = [[{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '����',
			field: 'InitNo',
			align: 'left',
			editor : 'text',
			width: 150,
			sortable: true
		}, {
			title: '�������',
			field: 'FrLocDesc',
			width: 150,
			sortable: true
		}, {
			title: '���տ���',
			field: 'ToLocDesc',
			width: 150
		}, {
			title: '���󵥺�',
			field: 'ReqNo',
			width: 150
		}, {
			title: '�Ƶ�ʱ��',
			field: 'InitDateTime',
			width: 150
		}, {
			title: '��������',
			field: 'OperateTypeDesc',
			width: 80
		}, {
			title: '����״̬',
			field: 'StatusCode',
			width: 70
		}, {
			title: '�Ƶ���',
			field: 'UserName',
			width: 80
		}, {
			title: '���۽��',
			field: 'RpAmt',
			align: 'right',
			width: 100
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			align: 'right',
			width: 100
		}, {
			title: '������',
			field: 'MarginAmt',
			align: 'right',
			width: 100
		}, {
			title: '���ⱸע',
			field: 'Remark',
			width: 150
		}
	]];

	var FMasterGrid = $UI.datagrid('#FMasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'DHCINIsTrfM'
		},
		columns: FMasterCm,
		onSelect: function(index, row){
			var Init = row['RowId'];
			var ParamsObj = {Init:Init, InitType:'T'};
			$UI.clear(FDetailGrid);
			FDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
				QueryName: 'DHCINIsTrfD',
				Params: JSON.stringify(ParamsObj)
			});
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				FMasterGrid.selectRow(0);
			}
		},
		onDblClickRow: function(index, row){
			Fn(row['RowId']);
			$HUI.dialog('#FindWin').close();
		}
	});

	var FDetailCm = [[{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 120
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 180
		}, {
			title: '���',
			field: 'Spec',
			width: 80
		}, {
			title: '��ֵ����',
			field: 'HVBarCode',
			width: 150
		}, {
			title: '����~Ч��',
			field: 'BatExp',
			width: 200
		}, {
			title: '����',
			field: 'ManfDesc',
			width: 160
		}, {
			title: '���ο��',
			field: 'InclbQty',
			align: 'right',
			width: 80
		}, {
			title: '��������',
			field: 'Qty',
			align: 'right',
			width: 80
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 50
		}, {
			title: '����',
			field: 'Rp',
			align: 'right',
			width: 80
		}, {
			title: '�ۼ�',
			field: 'Sp',
			align: 'right',
			width: 80
		}, {
			title: '���۽��',
			field: 'RpAmt',
			align: 'right',
			width: 80
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			align: 'right',
			width: 80
		}, {
			title: '�������',
			field: 'SterilizedBat',
			width: 160
		}, {
			title: '��������',
			field: 'ReqQty',
			align: 'right',
			width: 80
		}, {
			title: '���󷽿��',
			field: 'ReqLocStkQty',
			align: 'right',
			width: 100
		}, {
			title: 'ռ������',
			field: 'InclbDirtyQty',
			align: 'right',
			width: 100
		}, {
			title: '��������',
			field: 'InclbAvaQty',
			align: 'right',
			width: 100
		}
	]];

	var FDetailGrid = $UI.datagrid('#FDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfD'
		},
		columns: FDetailCm,
		remoteSort: false
	});
	
	Clear();
	FindQuery();
}