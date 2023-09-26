// ����:�б��ִ�ά��
// ��д����:2018-8-8
var init = function() {
	
	var PbLevelAddRowBtn = {
		iconCls: 'icon-add',
		text: '����',
		handler: function(){
			PbLevelGrid.commonAddRow();
		}
	}
	
	var PbLevelSaveBtn = {
		iconCls: 'icon-save',
		text: '����',
		handler: function(){
			var Rows = PbLevelGrid.getChangesData();
			if (Rows === false){	//δ��ɱ༭����ϸΪ��
				return;
			}
			if (isEmpty(Rows)){	//��ϸ����
				$UI.msg("alert", "û����Ҫ�������ϸ!");
				return;
			}
			for(var i = 0; i < Rows.length;i++){
				if(Rows[i].DateFrom>Rows[i].DateTo){
					$UI.msg('alert', '��ʼ���ڴ��ڽ�ֹ����,�޷�����!');
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
			title: '�������',
			field: 'Code',
			width: 100,
			editor: {
				type: 'validatebox',
				options: {
					required: true
				}
			}
		}, {
			title: '��������',
			field: 'Desc',
			width: 150,
			editor: {
				type: 'validatebox',
				options: {
					required: true
				}
			}
		}, {
			title: '��ʼ����',
			field: 'DateFrom',
			width: 150,
			editor: {
				type: 'datebox',
				options: {
				}
			}
		}, {
			title: '��������',
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