// 名称:支付方式维护
// 编写日期:2018-8-8
var init = function() {
	$UI.linkbutton('#AddBT', {
		onClick: function(){
			PayModeGrid.commonAddRow();
		}
	});

	$UI.linkbutton('#SaveBT', {
		onClick: function(){
			var Rows=PayModeGrid.getChangesData();
			if (Rows === false){	//未完成编辑或明细为空
				return;
			}
			if (isEmpty(Rows)){	//明细不变
				$UI.msg("alert", "没有需要保存的明细!");
				return;
			}
			var MainObj=JSON.stringify(addSessionParams());
			$.cm({
				ClassName: 'web.DHCSTMHUI.PayMode',
				MethodName: 'Save',
				Main: MainObj,
				Params: JSON.stringify(Rows)
			},function(jsonData){
				$UI.msg('success',jsonData.msg);
				if(jsonData.success==0){
					PayModeGrid.commonReload();
				}
			});
		}
	});

	var PayModeCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '代码',
			field: 'Code',
			width:300,
			fitColumns:true,
			editor:{type:'validatebox',options:{required:true}}
		}, {
			title: '描述',
			field: 'Description',
			width:300,
			fitColumns:true,
			editor:{type:'validatebox',options:{required:true}}
		}, {
			title: '不可用标志',
			field: 'NotUseFlag',
			width:80,
			formatter: BoolFormatter,
			editor:{
				type:'checkbox',
				options: {
					on: 'Y',
					off: 'N'
					}
				}
		}
	]];
	
	var PayModeGrid = $UI.datagrid('#PayModeList', {
		url: $URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.PayMode',
			QueryName: 'SelectAll'
		},
		columns: PayModeCm,
		toolbar: '#PayModeTB',
		sortName: 'RowId',  
		sortOrder: 'Desc',
		lazy:false,
		onClickCell: function(index, filed ,value){
			PayModeGrid.commonClickCell(index,filed)
		}
	})
	
	
}
$(init);