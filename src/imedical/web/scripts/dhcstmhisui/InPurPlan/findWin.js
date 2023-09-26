var FindWin=function(Fn){
	$HUI.dialog('#FindWin').open()
	
	/*--��ť����--*/
	$UI.linkbutton('#FQueryBT',{
		onClick:function(){
			$UI.clear(PurMainGrid);
			$UI.clear(PurDetailGrid);
			var ParamsObj=$UI.loopBlock('#FindConditions')
			if(isEmpty(ParamsObj.StartDate)){
				$UI.msg("alert","��ʼ���ڲ���Ϊ��");
				return;
			}
			if(isEmpty(ParamsObj.EndDate)){
				$UI.msg("alert","��ֹ���ڲ���Ϊ��");
				return;
			}
			if(isEmpty(ParamsObj.PurLoc)){
				$UI.msg("alert","�ɹ����Ҳ���Ϊ��");
				return;
			}
			ParamsObj.AuditFlag="N"
			var Params=JSON.stringify(ParamsObj);
			PurMainGrid.load({
				ClassName: 'web.DHCSTMHUI.INPurPlan',
				QueryName: 'Query',
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
		var Row=PurMainGrid.getSelected()
		if(isEmpty(Row)){
			$UI.msg("alert","��ѡ��Ҫѡȡ�Ĳɹ��ƻ���");
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
	var FPurLocBox = $HUI.combobox('#FPurLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+PurLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var FVendorBox = $HUI.combobox('#FVendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams=function(){
		var StkScg=$("#FStkScg").combotree('getValue');
		var PurLoc=$("#FPurLoc").combo('getValue');
		var Obj={StkGrpRowId:StkScg,StkGrpType:"M",Locdr:PurLoc};
		return Obj
	}
	$("#FInciDesc").lookup(InciLookUpOp(HandlerParams,'#FInciDesc','#FInci'));
	
	var CompBox = $HUI.combobox('#FCompFlag', {
		data:[{'RowId':'','Description':'ȫ��'},{'RowId':'N','Description':'δ���'},{'RowId':'Y','Description':'�����'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	
	/*--Grid--*/
	var PurDetailCm = [[{
			title:"RowId",
			field:'RowId',
			hidden:true
		}, {
			title:"����",
			field:'InciCode',
			width:100
		}, {
			title:"����",
			field:'InciDesc',
			width:100
		},{
			title:"���",
			field:'Spec',
			width:100
		}, {
			title:"������",
			field:'SpecDesc',
			width:100
		}, {
			title:"�ɹ�����",
			field:'Qty',
			width:100,
			align:'right'
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
			title:"�ۼ�",
			field:'Sp',
			width:100,
			align:'right'
		}, {
			title:"���۽��",
			field:'RpAmt',
			width:100,
			align:'right'
		}, {
			title:"�ۼ۽��",
			field:'SpAmt',
			width:100,
			align:'right'
		}, {
			title:"����",
			field:'ManfDesc',
			width:100
		}, {
			title:"��Ӧ��",
			field:'VendorDesc',
			width:100
		}, {
			title:"������",
			field:'CarrierDesc',
			width:100
		}, {
			title:"�������",
			field:'ReqLocDesc',
			width:100
		}, {
			title:"������ҿ��",
			field:'StkQty',
			width:100,
			align:'right'
		}, {
			title:"�������",
			field:'MaxQty',
			width:100,
			align:'right'
		}, {
			title:"�������",
			field:'MinQty',
			width:100,
			align:'right'
		}
	]];
	
	var PurDetailGrid = $UI.datagrid('#PurDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPurPlanItm',
			QueryName: 'Query'
		},
		columns: PurDetailCm,
		sortName: 'RowId',
		sortOrder: 'Desc'
	})
	
	var PurMainCm = [[{
			title:"RowId",
			field:'RowId',
			hidden:true
		}, {
			title:"�ƻ�����",
			field:'PurNo',
			width:100
		}, {
			title:"�ɹ�����",
			field:'PurLoc',
			width:100
		}, {
			title:"�Ƶ�����",
			field:'CreateDate',
			width:150
		}, {
			title:"�Ƶ���",
			field:'CreateUser',
			width:100
		}, {
			title:"��������",
			field:'PoFlag',
			width:100
		}, {
			title:"�ɹ������",
			field:'CompFlag',
			width:100,
			align:'right'
		}, {
			title:"�ܾ�ԭ��",
			field:'RefuseCase',
			width:100,
			align:'right'
		}
	]];
	
	var PurMainGrid = $UI.datagrid('#PurMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INPurPlan',
			QueryName: 'Query'
		},
		columns: PurMainCm,
		/*toolbar:[{
			text: 'ѡȡ',
			iconCls: 'icon-accept',
			handler: function () {
				FSelect();
			}
		}],*/
		onSelect:function(index, row){
			PurDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INPurPlanItm',
				QueryName: 'Query',
				PurId: row.RowId
			});
		},
		onLoadSuccess: function(data){
			if(data.rows.length > 0){
				PurMainGrid.selectRow(0);
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
		$UI.clear(PurMainGrid);
		$UI.clear(PurDetailGrid);
		///���ó�ʼֵ ����ʹ������
		var FDafultValue={
			StartDate:DefaultStDate(),
			EndDate:DefaultEdDate(),
			PurLoc:gLocObj,
			CompFlag:'N'
		}
		$UI.fillBlock('#FindConditions',FDafultValue)
	}
	FDafult()
}