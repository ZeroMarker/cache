var init = function(){
	function QueryItm(){
		var Params = JSON.stringify($UI.loopBlock('ItmcomapareTB'));
		ItmcomapareGrid.load({
			ClassName: 'web.DHCSTMHUI.ItmCompare',
			QueryName: 'SelectAll',
			Params: Params
		});
	}
	$('#SearchBT').on('click', function () {
		QueryItm();
	});
	$('#FStkGrpBox').stkscgcombotree({
		onSelect:function(node){
			$.cm({
				ClassName: 'web.DHCSTMHUI.Common.Dicts',
				QueryName: 'GetStkCat',
				ResultSetType: 'array',
				StkGrpId: node.id
			},function(data){
				FStkCatBox.clear();
				FStkCatBox.loadData(data);
			});
		}
	})
	var FStkCatBox = $HUI.combobox('#FStkCatBox', {
			valueField: 'RowId',
			textField: 'Description'
		});
		var HandlerParams=function(){
		var Scg=$("#FStkGrpBox").combotree('getValue');
		var Obj={StkGrpRowId:Scg,StkGrpType:"M"};
		return Obj
	}
	$("#FInciDesc").lookup(InciLookUpOp(HandlerParams,'#FInciDesc','#FInci'));
	$('#AddBT').on('click', function(){
		ItmcomapareGrid.commonAddRow();
	});
	$('#SaveBT').on('click', function(){
		var Rows=ItmcomapareGrid.getChangesData();
		if (Rows === false){	//δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Rows)){	//��ϸ����
			$UI.msg("alert", "û����Ҫ�������ϸ!");
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.ItmCompare',
			MethodName: 'Save',
			Params: JSON.stringify(Rows)
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success', jsonData.msg);
				ItmcomapareGrid.reload();
			}else {
				$UI.msg('error', jsonData.msg);
			}
		});
	});
	$('#DeleteBT').on('click', function(){
		var Rows = ItmcomapareGrid.getSelections();
		$.cm({
			ClassName: 'web.DHCSTMHUI.ItmCompare',
			MethodName: 'Delete',
			Params: JSON.stringify(Rows)
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success', jsonData.msg);
				ItmcomapareGrid.reload();
			}else {
				$UI.msg('error', jsonData.msg);
			}
		});
	});
	
	var HandlerParams=function(){
		var Scg=$("#FStkGrpBox").combotree('getValue');
		var Obj={StkGrpRowId:Scg,StkGrpType:"M"};
		return Obj
	}
	var SelectRow=function(row){
		var Rows = ItmcomapareGrid.getRows();
		var Row = Rows[ItmcomapareGrid.editIndex];
		Row.RowId = row.InciDr;
		Row.Code = row.InciCode;
		Row.Description = row.InciDesc;
		Row.spec = row.Spec;
		
		setTimeout(function () {
			ItmcomapareGrid.refreshRow();
			ItmcomapareGrid.startEditingNext('Description');
		}, 0);
	}
	
	var ItmcomapareCm=[[{
			title: 'RowId',
			field: 'rowId',
			hidden: true
		},{
			title: '���ʴ���',
			field: 'Code',
			width: 130
		},{
			title: '��������',
			field: 'Description',
			width: 150,
			editor:InciEditor(HandlerParams,SelectRow)
		},{
			title: '���',
			field: 'spec',
			width: 150
		},{
			title: 'HIS���ʴ���',
			field: 'HISCode',
			width: 150,
			editor:{type:'validatebox',options:{required:true}}
		},{
			title: 'HIS��������',
			field: 'HISDesc',
			width: 150,
			editor:{type:'validatebox',options:{required:true}}
		}
	]];
	
	var ItmcomapareGrid= $UI.datagrid('#Itmcomapare',{
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ItmCompare',
			QueryName: 'SelectAll'
		},
		columns: ItmcomapareCm,
		toolbar: '#ItmcomapareTB',
		sortName: 'RowId',
		sortOrder: 'Desc',
		onClickCell: function(index, filed ,value){
			ItmcomapareGrid.commonClickCell(index,filed)
		}
	})
	QueryItm();
}
$(init);