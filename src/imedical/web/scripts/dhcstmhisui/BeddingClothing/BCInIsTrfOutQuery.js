var init = function() {
	$UI.linkbutton('#SearchBT', {
		onClick: function(){
			Query();
		}
	});
	function Query(){
		$UI.clear(DetailGrid);
		$UI.clear(MasterGrid);
		var ParamsObj = $UI.loopBlock('Conditions');
		if(isEmpty(ParamsObj['FrLoc'])){
			$UI.msg('alert', '���Ҳ���Ϊ��!');
			return;
		}
		if(isEmpty(ParamsObj['StartDate'])){
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return;
		}
		if(isEmpty(ParamsObj['EndDate'])){
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return;
		}
		ParamsObj['DateType'] = '1';
		var Params = JSON.stringify(ParamsObj);
		MasterGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'DHCINIsTrfM',
			Params: Params
		});
	}
	$UI.linkbutton('#ClearBT', {
		onClick: function(){
			$UI.clearBlock('Conditions');
			$UI.clear(DetailGrid);
			$UI.clear(MasterGrid);
			SetDefaValues();
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function(){
			var SelectedRow = MasterGrid.getSelected();
			if(isEmpty(SelectedRow)){
				$UI.msg('alert', '��ѡ����Ҫ��ӡ�ĵ���!');
				return;
			}
			var RowId = SelectedRow['RowId'];
			PrintInIsTrfBC(RowId);
		}
	});

	var FrLoc = $HUI.combobox('#FrLoc',{
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({Type:'Login'})),
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record){
			var LocId = record['RowId'];
			$('#CreateUser').combobox('clear');  
			$('#CreateUser').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=Array&Params='
				+ JSON.stringify({LocDr:LocId})
			);
		}
	});
	$('#FrLoc').combobox('setValue', session['LOGON.CTLOCID']);
	
	var ToLoc = $HUI.combobox('#ToLoc',{
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({Type:'All'})),
		valueField: 'RowId',
		textField: 'Description'
	});

	var Status = $('#Status').simplecombobox({
		data: [
			{RowId: '10', Description: 'δ���'},
			{RowId: '11', Description: '�����'},
			{RowId: '20', Description: '������˲�ͨ��'},
			{RowId: '21', Description: '�������ͨ��'},
			{RowId: '30', Description: '�ܾ�����'},
			{RowId: '31', Description: '�ѽ���'}
		]
	});

	var MasterCm = [[{
			title: 'RowId',
			field: 'RowId',
			saveCol: true,
			width: 80,
			hidden: true
		}, {
			title: '����',
			field: 'InitNo',
			align: 'left',
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
			title: '��ע',
			field: 'Remark',
			width: 150
		}
	]];

	var MasterGrid = $UI.datagrid('#MasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'DHCINIsTrfM'
		},
		columns: MasterCm,
		showBar: true,
		onSelect: function(index, row){
			var Init = row['RowId'];
			var ParamsObj = {Init:Init, InitType:'T'};
			$UI.clear(DetailGrid);
			DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
				QueryName: 'DHCINIsTrfD',
				Params: JSON.stringify(ParamsObj),
				rows: 99999
			});
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				MasterGrid.selectRow(0);
			}
		}
	});

	var DetailCm = [[{
			title: 'RowId',
			field: 'RowId',
			width: 80,
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
			title: '����Id',
			field: 'Inclb',
			width: 120,
			hidden: true
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

	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfD',
			rows: 99999
		},
		pagination:false,
		columns: DetailCm,
		showBar: true,
		remoteSort: false
	});
	
	//����ȱʡֵ
	function SetDefaValues(){
		$('#FrLoc').combobox('setValue', gLocId);
		$('#StartDate').datebox('setValue', DefaultStDate());
		$('#EndDate').datebox('setValue',  DefaultEdDate());
	}
	
	SetDefaValues();
	Query();
}
$(init);