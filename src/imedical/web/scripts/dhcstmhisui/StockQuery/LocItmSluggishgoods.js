/*����Ʒ������ѯ*/
var init = function() {
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			Query();
		}
	});
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear();
		}
	});
	var PhaLocParams=JSON.stringify(addSessionParams({Type:"Login"}));
	var PhaLocBox = $HUI.combobox('#PhaLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+PhaLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var StkQtyCm = [[
		{
			title : "inclb",
			field : 'inclb',
			width : 20,
			hidden : true
		}, {
			title : "���ʴ���",
			field : 'InciCode',
			width : 120
		}, {
			title : "��������",
			field : 'InciDesc',
			width : 200
		}, {
			title : "���",
			field : 'Spec',
			width : 200
		}, {
			title : '��λ',
			field : 'stkUom',
			width : 70
		}, {
			title : '���ÿ��',
			field : 'avaQty',
			width : 70,
			align: 'right'
		}, {
			title : "���ο��",
			field : 'stkQty',
			width : 70,
			align: 'right'
		}, {
			title : "�ۼ�",
			field : 'sp',
			width : 100,
			align: 'right'
		}, {
			title : "����",
			field : 'batNo',
			width : 100
		}, {
			title : "Ч��",
			field : 'expDate',
			width : 100
		}, {
			title : "����",
			field : 'manf',
			width : 100
		}, {
			title : "��Ӧ��",
			field : 'vendor',
			width : 100
		}, {
			title : "��λ",
			field : 'sbDesc',
			width : 100
		}, {
			title : "�����������",
			field : 'LastImpDate',
			width : 100
		}, {
			title : "���³�������",
			field : 'LastTrOutDate',
			width : 100
		}, {
			title : "����ת������",
			field : 'LastTrInDate',
			width : 100
		}, {
			title : "����סԺ��������",
			field : 'LastIpDate',
			width : 120
		}, {
			title : "����������������",
			field : 'LastOpDate',
			width : 120
		}
	]];
	
	var ParamsObj=$UI.loopBlock('#FindConditions');
	var StockQtyGrid = $UI.datagrid('#StockQtyGrid', {
		lazy:true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmSluggishGoods',
			QueryName: 'LocItmSluggishGoods'
		},
		columns: StkQtyCm,
		singleSelect:false,
		showBar: true,
		onClickCell: function(index, filed ,value){
			StockQtyGrid.commonClickCell(index,filed,value);
		}
	})
	function Query(){
		var ParamsObj=$UI.loopBlock('#FindConditions');
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg('alert','��ʼ���ڲ���Ϊ��!');
			return;
		}
		if(isEmpty(ParamsObj.EndDate)){
			$UI.msg('alert','��ֹ���ڲ���Ϊ��!');
			return;
		}
		if(isEmpty(ParamsObj.PhaLoc)){
			$UI.msg('alert','���Ҳ���Ϊ��!');
			return;
		}
		
		var ParamObj=$UI.loopBlock('#Conditions');
		var TransTypeArr = [];
		if(ParamObj.GFlag!=''){
			TransTypeArr.push(ParamObj.GFlag+'$'+ParamObj.GQty);
		}
		if(ParamObj.TFlag!=''){
			TransTypeArr.push(ParamObj.TFlag+'$'+ParamObj.TQty);
		}
		if(ParamObj.KFlag!=''){
			TransTypeArr.push(ParamObj.KFlag+'$'+ParamObj.KQty);
		}
		if(isEmpty(TransTypeArr)){
			$UI.msg('alert','��ѡ��ҵ������!');
			return;
		}
		var TransType = TransTypeArr.join();
		var Params=JSON.stringify(ParamsObj);
		StockQtyGrid.load({
			ClassName: 'web.DHCSTMHUI.LocItmSluggishGoods',
			QueryName: 'LocItmSluggishGoods',
			Params:Params,
			BusinessTypes:TransType
		});
	}
	function Clear() {
		$UI.clearBlock('#FindConditions');
		$UI.clearBlock('#Conditions');
		$UI.clear(StockQtyGrid);
		var Dafult={
			StartDate: DateFormatter(new Date()),
			EndDate:DateFormatter(new Date()),
			PhaLoc:gLocObj
		};
		$UI.fillBlock('#FindConditions',Dafult);
		$UI.fillBlock('#Conditions',{TFlag: true});
	}
	Clear();
}
$(init);