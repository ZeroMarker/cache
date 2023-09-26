var FindWin = function(Fn,HvFlag){
	$HUI.dialog('#FindWin').open()
	$UI.linkbutton('#FQueryBT',{
		onClick:function(){
			FindQuery();
		}
	});
	if(HvFlag == undefined){
		HvFlag = '';
	}
	function FindQuery(){
		var ParamsObj=$UI.loopBlock('#FindConditions')
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg('alert','��ʼ���ڲ���Ϊ��!');
			return;
		}
		if(isEmpty(ParamsObj.EndDate)){
			$UI.msg('alert','��ֹ���ڲ���Ϊ��!');
			return;
		}
		if(isEmpty(ParamsObj.AdjLoc)){
			$UI.msg('alert','���Ҳ���Ϊ��!');
			return;
		}	
		ParamsObj.HVFlag=HvFlag;
		var Params=JSON.stringify(ParamsObj);
		$UI.setUrl(INAdjMainGrid)
		$UI.clear(INAdjDetailGrid)
		INAdjMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINAdj',
			QueryName: 'DHCINAdjM',
			Params:Params
		});
	}
	$UI.linkbutton('#FComBT',{
		onClick:function(){
			var Row=INAdjMainGrid.getSelected()
			if(isEmpty(Row)){
				$UI.msg('alert','��ѡ��Ҫ���صĵ�����!');
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
	var AdjLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var FAdjLocBox = $HUI.combobox('#FAdjLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+AdjLocParams,
			valueField: 'RowId',
			textField: 'Description'
		});		
	var INAdjMainCm=[[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		},{
			title: '��������',
			field: 'No',
			width: 150
		},{
			title: '����',
			field: 'AdjLocDesc',
			width: 150
	
		},{
			title: "��������",
			field: 'AdjDate',
			width: 150
		},{
			title: "ԭ��",
			field: 'ReasonDesc',
			width: 150
			
		},{
			title: "���״̬",
			field: 'Completed',
			width: 100	
		},{
			title: "���״̬",
			field: 'chkFlag',
			width: 100
		},{
			title: "��ע",
			field: 'remarks',
			width: 200
		}
	
	]];
	var INAdjMainGrid = $UI.datagrid('#INAdjMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINAdj',
			QueryName: 'jsSelect'
		},
		columns: INAdjMainCm,
		onSelect:function(index, row){
			$UI.setUrl(INAdjDetailGrid)
			var Adjrowid = row['RowId'];
			var ParamsObj = {InAdj:Adjrowid};
			INAdjDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINAdjItm',
				QueryName: 'DHCINAdjD',
				Params: JSON.stringify(ParamsObj)
			});
		},
		onDblClickRow:function(index,row){
			Fn(row.RowId);
			$HUI.dialog('#FindWin').close();
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				INAdjMainGrid.selectRow(0);
			}
		}
	})

	var INAdjDetailCm=[[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		},{
			title: 'Inclb',
			field: 'Inclb',
			width:150,
			hidden:true
		},{
			title: 'InciId',
			field: 'InciId',
			width:150,
			hidden:true
		},{
			title: '���ʴ���',
			field: 'Code',
			width: 72
		},{
			title: '��������',
			field: 'InciDesc',
			width: 140
		},{
			title: "����~Ч��",
			field: 'BatExp',
			width: 150
		},{
			title: "����",
			field: 'ManfDesc',
			width: 150
		},{
			title: "��������",
			field: 'Qty',
			width: 72
		},{
			title:'��λ',
			field:'uomDesc',
			width:80
		},{
			title:'����',
			field:'Rp',
			width:80
		},{
			title:'���',
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

	var INAdjDetailGrid = $UI.datagrid('#INAdjDetailGrid', {
		url: '',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINAdjItm',
			QueryName: 'DHCINAdjD'
		},
		columns: INAdjDetailCm,
		remoteSort: false
	})
	/*--���ó�ʼֵ--*/
	var Dafult=function(){
		$UI.clearBlock('#FindConditions');
		$UI.clear(INAdjMainGrid);
		$UI.clear(INAdjDetailGrid);
		///���ó�ʼֵ ����ʹ������
		var DafultValue={
			StartDate:DateFormatter(new Date()),
			EndDate:DateFormatter(new Date()),
			AdjLoc:gLocObj,
			CompleteFlag : "N", 
			Audit : "N"
		}
		$UI.fillBlock('#FindConditions',DafultValue) //���
	}
	Dafult();
	FindQuery();
}

