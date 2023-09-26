/*��汨��(��������)*/
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
			textField: 'Description',
			onChange:function(e){
				init(e)
			}
	});
	$('#StkGrpId').stkscgcombotree({
	onSelect:function(node){
		$.cm({
			ClassName:'web.DHCSTMHUI.Common.Dicts',
			QueryName:'GetStkCat',
			ResultSetType:'array',
			StkGrpId:node.id
		},function(data){
			StkCatBox.clear();
			StkCatBox.loadData(data);
			})
		}
	});
	var StkCatBox = $HUI.combobox('#StkCat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});

	function init(LocId){
		var StkBinParams=JSON.stringify(addSessionParams({LocDr:LocId}));
		var StkBinBox = $HUI.combobox('#StkBin', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocStkBin&ResultSetType=array&Params='+StkBinParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	}
	var StkQtyCm = [[
		 {
			title : "incil",
			field : 'incil',
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
			field : 'StkUom',
			width : 70
		}, {
			title : '���ÿ��',
			field : 'AvaQty',
			width : 70,
			align: 'right'
		}, {
			title : "�������",
			field : 'MaxQty',
			width : 70,
			align: 'right'
		}, {
			title : "�������",
			field : 'MinQty',
			width : 100,
			align: 'right'
		}, {
			title : "��׼���",
			field : 'RepQty',
			width : 100,
			align: 'right'
		}, {
			title : "����",
			field : 'Manf',
			width : 100
		}, {
			title : "������",
			field : 'IncscDesc',
			width : 100
		}	
	]];
	
	var ParamsObj=$UI.loopBlock('#Conditions')
	var StockQtyGrid = $UI.datagrid('#StockQtyGrid', {
		lazy:false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmStkQtyWarn',
			MethodName: 'jsLocItmStkQtyLimitWarn'
		},
		columns: StkQtyCm,
		singleSelect:false,
		showBar: true,
		onClickCell: function(index, filed ,value){
			StockQtyGrid.commonClickCell(index,filed,value);
		},
		onLoadSuccess: function(data){
			$.each(data.rows, function(index, row){
			ChangeColor(StockQtyGrid, index, 'incil',row);
			});
		}

	})
	function ChangeColor(Grid, RowIndex, Field,row){
		var Incil = Grid.getRows()[RowIndex][Field];
		var ColorField = 'AvaQty';
		var AvaQty = row['AvaQty'];
		var MaxQty = row['MaxQty'];
		var MinQty = row['MinQty'];
		if(parseFloat(AvaQty)>MaxQty){
			var Color = '#ee4f38';
			SetGridBgColor(Grid, RowIndex, Field, Color, ColorField);
		}
		if(parseFloat(AvaQty)<MinQty){
			var Color = '#a4c703';
			SetGridBgColor(Grid, RowIndex, Field, Color, ColorField);
		}
	}
	
	function Query(){
		var ParamsObj=$UI.loopBlock('#Conditions')
		if(isEmpty(ParamsObj.PhaLoc)){
			$UI.msg('alert','���Ҳ���Ϊ��!');
			return;
		}	
		var Params=JSON.stringify(ParamsObj);
		StockQtyGrid.load({
			ClassName: 'web.DHCSTMHUI.LocItmStkQtyWarn',
			MethodName: 'jsLocItmStkQtyLimitWarn',
			StrPar:Params
		})
	}
	function Clear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(StockQtyGrid);
		var Dafult={PhaLoc:gLocObj
					}
		$UI.fillBlock('#Conditions',Dafult);
	
	}
	Clear();
	}	
	
$(init);