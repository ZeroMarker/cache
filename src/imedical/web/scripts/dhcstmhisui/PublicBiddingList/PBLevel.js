// 名称:招标轮次维护
// 编写日期:2018-8-8
var init = function() {
	
	var PbLevelAddRowBtn = {
		iconCls: 'icon-add',
		text: '新增',
		handler: function(){
			PbLevelGrid.commonAddRow();
		}
	}
	
	var PbLevelSaveBtn = {
		iconCls: 'icon-save',
		text: '保存',
		handler: function(){
			var Rows = PbLevelGrid.getChangesData();
			if (Rows === false){	//未完成编辑或明细为空
				return;
			}
			if (isEmpty(Rows)){	//明细不变
				$UI.msg("alert", "没有需要保存的明细!");
				return;
			}
			for(var i = 0; i < Rows.length;i++){
				if(Rows[i].DateFrom>Rows[i].DateTo){
					$UI.msg('alert', '开始日期大于截止日期,无法保存!');
					return;
				}
			}
			var ListDetail = JSON.stringify(Rows);
			var MainObj=JSON.stringify(addSessionParams());
			$.cm({
				ClassName: 'web.DHCSTMHUI.ITMPBLEVEL',
				MethodName: 'Save',
				Main: MainObj,
				Params: ListDetail
			},function(jsonData){
				if(jsonData.success === 0){
					$UI.msg('success', jsonData.msg);
					PbLevelGrid.commonReload();
				}else{
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	};
	
	
/*	$('#DeleteBT').on('click', function(){
		var Rows=PublicBiddingListGrid.getSelectedData();
		$.cm({
			ClassName: 'web.DHCSTMHUI.PayMode',
			MethodName: 'Delete',
			Params: Rows
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				PublicBiddingListGrid.commonReload();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	});
*/
	
	var PbLevelCm = [[{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '级别代码',
			field: 'Code',
			width: 100,
			editor: {
				type: 'validatebox',
				options: {
					required: true
				}
			}
		}, {
			title: '级别名称',
			field: 'Desc',
			width: 150,
			editor: {
				type: 'validatebox',
				options: {
					required: true
				}
			}
		}, {
			title: '开始日期',
			field: 'DateFrom',
			width: 150,
			editor: {
				type: 'datebox',
				options: {
				}
			}
		}, {
			title: '结束日期',
			field: 'DateTo',
			width: 150,
			editor: {
				type: 'datebox',
				options: {
				}
			}
		}
	]];
	
	var PbLevelGrid = $UI.datagrid('#PbLevelGrid', {
		lazy: false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ITMPBLEVEL',
			MethodName: 'SelectAll'
		},
		columns: PbLevelCm,
		toolbar: [PbLevelAddRowBtn, PbLevelSaveBtn],
		onClickCell: function(index, filed ,value){
			PbLevelGrid.commonClickCell(index, filed);
		}
	});
	
}
$(init);