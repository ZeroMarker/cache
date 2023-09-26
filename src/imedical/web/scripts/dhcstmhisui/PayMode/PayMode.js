// ����:֧����ʽά��
// ��д����:2018-8-8
var init = function() {
	$UI.linkbutton('#AddBT', {
		onClick: function(){
			PayModeGrid.commonAddRow();
		}
	});

	$UI.linkbutton('#SaveBT', {
		onClick: function(){
			var Rows=PayModeGrid.getChangesData();
			if (Rows === false){	//δ��ɱ༭����ϸΪ��
				return;
			}
			if (isEmpty(Rows)){	//��ϸ����
				$UI.msg("alert", "û����Ҫ�������ϸ!");
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
			title: '����',
			field: 'Code',
			width:300,
			fitColumns:true,
			editor:{type:'validatebox',options:{required:true}}
		}, {
			title: '����',
			field: 'Description',
			width:300,
			fitColumns:true,
			editor:{type:'validatebox',options:{required:true}}
		}, {
			title: '�����ñ�־',
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