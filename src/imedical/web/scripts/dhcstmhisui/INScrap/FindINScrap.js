var FindWin = function(Fn,HvFlag){
	if(HvFlag == typeof(undefined)){
		HvFlag = '';
	}
	$HUI.dialog('#FindWin').open()
	$UI.linkbutton('#FQueryBT',{
		onClick:function(){
			Query();
		}	
	});
	function Query(){
			$UI.clear(INScrapMainGrid);
			$UI.clear(INScrapDetailGrid);
			var ParamsObj=$UI.loopBlock('#FindConditions')
			if(isEmpty(ParamsObj.StartDate)){
				$UI.msg('alert','��ʼ���ڲ���Ϊ��!');
				return;
			}
			if(isEmpty(ParamsObj.EndDate)){
				$UI.msg('alert','��ֹ���ڲ���Ϊ��!');
				return;
			}
			if(isEmpty(ParamsObj.SupLoc)){
				$UI.msg('alert','���Ҳ���Ϊ��!');
				return;
			}
			ParamsObj.HvFlag=HvFlag
			var Params=JSON.stringify(ParamsObj);
			$UI.setUrl(INScrapMainGrid)
			INScrapMainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINScrap',
				QueryName: 'DHCINSpM',
				Params:Params
			});
	}
	$UI.linkbutton('#FComBT',{
		onClick:function(){
			var Row=INScrapMainGrid.getSelected()
			if(isEmpty(Row)){
				$UI.msg('alert','��ѡ��Ҫ���صı���!');
				return;
			}
			Fn(Row.RowId);
			$HUI.dialog('#FindWin').close();
		}
	});
	$UI.linkbutton('#FClearBT',{
		onClick:function(){
			Dafult();
		}
	});
	var FSupLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var FSupLocBox = $HUI.combobox('#FSupLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+FSupLocParams,
			valueField: 'RowId',
			textField: 'Description'
		});		
	var INScrapMainCm=[[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		},{
			title: '���𵥺�',
			field: 'No',
			width: 150
		},{
			title: '����',
			field: 'LocDesc',
			width: 150
	
		},{
			title: "��������",
			field: 'Date',
			width: 150
		},{
			title: "ԭ��",
			field: 'ReasonDesc',
			width: 150
			
		},{
			title: "���״̬",
			field: 'Completed',
			width: 100,
			align:'center',
			formatter: BoolFormatter
		},{
			title: "���״̬",
			field: 'ChkFlag',
			width: 100,
			align:'center',
			formatter: BoolFormatter
		},{
			title: "��ע",
			field: 'Remark',
			width: 200
		}
	
	]];
	var INScrapMainGrid = $UI.datagrid('#INScrapMainGrid', {
		url: '',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINScrap',
			QueryName: 'DHCINSpM'
		},
		columns: INScrapMainCm,
		onSelect:function(index, row){
			$UI.setUrl(INScrapDetailGrid)
			INScrapDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINScrapItm',
				QueryName: 'DHCINSpD',
				Inscrap: row.RowId
			});
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				INScrapMainGrid.selectRow(0);
			}
		},
		onDblClickRow:function(index,row){
			Fn(row.RowId);
			$HUI.dialog('#FindWin').close();
		}
	})

	var INScrapDetailCm=[[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		},{
			title: '����RowId',
			field: 'Inclb',
			width:150,
			hidden:true
		},{
			title: '����RowId',
			field: 'Incil',
			width:150,
			hidden:true
		},{
			title: '���ʴ���',
			field: 'InciCode',
			width: 72
		},{
			title: '��������',
			field: 'InciDesc',
			width: 140
		},{
			title: '��ֵ����',
			field: 'HVBarCode',
			width: 150
		},{
			title: "����~Ч��",
			field: 'BatExp',
			width: 150
		},{
			title: "����",
			field: 'Manf',
			width: 150
		},{
			title: "��������",
			field: 'Qty',
			width: 72
		},{
			title:'��λ',
			field:'PurUomDesc',
			width:80
		},{
			title:'����',
			field:'Rp',
			width:80
		},{
			title:'���۽��',
			field:'RpAmt',
			width:80
		},{
			title:'���',
			field:'Spec',
			width:80
		},{
			title:'�ۼ�',
			field:'Sp',
			width:80
		},{
			title:'�ۼ۽��',
			field:'SpAmt',
			width:80
		},{
			title:'����',
			field:'Pp',
			width:80
		},{
			title:'���۽��',
			field:'PpAmt',
			width:80
		},{
			title:'���ο��ÿ��',
			field:'AvaQty',
			width:80
		}
	]];

	var INScrapDetailGrid = $UI.datagrid('#INScrapDetailGrid', {
		url: '',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINScrapItm',
			QueryName: 'DHCINSpD'
		},
		columns: INScrapDetailCm
	})
	/*--���ó�ʼֵ--*/
	var Dafult=function(){
		var StDate = DateAdd(new Date(), 'd', parseInt(-7));
		$UI.clearBlock('#FindConditions');
		$UI.clear(INScrapMainGrid);
		$UI.clear(INScrapDetailGrid);
		///���ó�ʼֵ ����ʹ������
		var DafultValue={
			StartDate:DateFormatter( StDate),
			EndDate:DateFormatter(new Date()),
			SupLoc:gLocObj,
			Audit: "N"
		}
		$UI.fillBlock('#FindConditions',DafultValue) //���
	}
	Dafult();
	Query();
}

