var FindWin=function(Fn){
	$HUI.dialog('#FindWin').open()
	
	/*--��ť����--*/
	$UI.linkbutton('#FQueryBT',{
		onClick:function(){
			$UI.clear(PoMainGrid);
			$UI.clear(PoDetailGrid);
			var ParamsObj=$UI.loopBlock('#FindConditions')
			if(isEmpty(ParamsObj.StartDate)){
				$UI.msg("alert","��ʼ���ڲ���Ϊ��");
				return;
			}
			if(isEmpty(ParamsObj.EndDate)){
				$UI.msg("alert","��ֹ���ڲ���Ϊ��");
				return;
			}
			if(isEmpty(ParamsObj.PoLoc)){
				$UI.msg("alert","�������Ҳ���Ϊ��");
				return;
			}
			ParamsObj.ApproveFlag="N"
			var Params=JSON.stringify(ParamsObj);
			PoMainGrid.load({
				ClassName: 'web.DHCSTMHUI.INPO',
				QueryName: 'QueryMain',
				Params:Params
			});
		}
	});
	
	$UI.linkbutton('#FSelectBT',{
		onClick:function(){
			FSelect()
		}
	});
	function FSelect(){
		var Row=PoMainGrid.getSelected()
		if(isEmpty(Row)){
			$UI.msg("alert","��ѡ��Ҫѡȡ�Ķ���");
			return;
		}
		Fn(Row.RowId);
		$HUI.dialog('#FindWin').close();
	}
	$UI.linkbutton('#FClearBT',{
		onClick:function(){
			FDafult()
		}
	});
	
	/*--�󶨿ؼ�--*/
	var FPoLocBox = $HUI.combobox('#FPoLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+PoLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var FVendorBox = $HUI.combobox('#FVendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams=function(){
		var PoLoc=$("#FPoLoc").combo('getValue');
		var Obj={StkGrpRowId:"",StkGrpType:"M",Locdr:PoLoc};
		return Obj
	}
	$("#FInciDesc").lookup(InciLookUpOp(HandlerParams,'#FInciDesc','#FInci'));
	
	var CompBox = $HUI.combobox('#FCompFlag', {
		data:[{'RowId':'','Description':'ȫ��'},{'RowId':'N','Description':'δ���'},{'RowId':'Y','Description':'�����'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	/*--Grid--*/
	var PoDetailCm = [[{
			title:"RowId",
			field:'RowId',
			hidden:true
		}, {
			title:"����RowId",
			field:'InciId',
			width:100,
			hidden:true
		}, {
			title:"����",
			field:'InciCode',
			width:100
		},{
			title:"����",
			field:'InciDesc',
			width:100
		}, {
			title:"��λ",
			field:'UomDesc',
			width:100
		}, {
			title:"����",
			field:'Rp',
			width:100,
			align:'right'
		}, {
			title:"��������",
			field:'PurQty',
			width:100,
			align:'right'
		}, {
			title:"���۽��",
			field:'RpAmt',
			width:100,
			align:'right'
		}, {
			title:"��������",
			field:'ImpQty',
			width:100,
			align:'right'
		}, {
			title:"δ��������",
			field:'AvaQty',
			width:100,
			align:'right'
		}, {
			title:"�Ƿ���",
			field:'CancleFlag',
			width:100
		}
	]];
	
	var PoDetailGrid = $UI.datagrid('#PoDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPOItm',
			QueryName: 'Query'
		},
		columns: PoDetailCm,
		sortName: 'RowId',
		sortOrder: 'Desc'
	})
	
	var PoMainCm = [[{
			title:"RowId",
			field:'RowId',
			hidden:true
		}, {
			title:"������",
			field:'PoNo',
			width:100
		}, {
			title:"��������",
			field:'PoLocDesc',
			width:100
		}, {
			title:"��Ӧ��",
			field:'VendorDesc',
			width:150
		}, {
			title:"����״̬",
			field:'PoStatus',
			width:100,
			formatter:function(value){
				var PoStatus='';
				if(value==0){
					PoStatus='δ���';
				}else if(value==1){
					PoStatus='�������';
				}else if(value==2){
					PoStatus='ȫ�����';
				}
				return PoStatus;
			}
		}, {
			title:"��������",
			field:'CreateDate',
			width:100
		}, {
			title:"���",
			field:'CompFlag',
			width:100
		}
	]];
	
	var PoMainGrid = $UI.datagrid('#PoMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPO',
			QueryName: 'QueryMain'
		},
		columns: PoMainCm,
		/*toolbar:[{
			text: 'ѡȡ',
			iconCls: 'icon-accept',
			handler: function () {
				FSelect();
			}
		}],*/
		onSelect:function(index, row){
			PoDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INPOItm',
				QueryName: 'Query',
				PoId: row.RowId
			});
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				PoMainGrid.selectRow(0);
			}
		},
		onDblClickRow:function(index, row){
			Fn(row.RowId);
			$HUI.dialog('#FindWin').close();
		}
	})
	
	/*--���ó�ʼֵ--*/
	var FDafult=function(){
		$UI.clearBlock('#FindConditions');
		$UI.clear(PoMainGrid);
		$UI.clear(PoDetailGrid);
		///���ó�ʼֵ ����ʹ������
		var FDafultValue={
			StartDate:DateAdd(new Date(), 'd', parseInt(-7)),
			EndDate:new Date(),
			PoLoc:gLocObj,
			CompFlag:'N'
		}
		$UI.fillBlock('#FindConditions',FDafultValue)
	}
	FDafult()
}