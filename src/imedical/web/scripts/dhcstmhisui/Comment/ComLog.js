/*
������־��ѯ
*/
var ComLogSearch=function(DetailId){
	$HUI.dialog('#LogWin').open();
	var ComLogCm = [[{
			title:"������־��ϸid",
			field:'RowId',
			hidden:true
		}, {
			title:"��������",
			field:'ComNo',
			width:120
		}, {
			title:"ҽ������",
			field:'Arcim',
			width:140
		}, {
			title:"�������",
			field:'ComResult',
			width:100
		}, {
			title:"������",
			field:'ComUser',
			width:100
		}, {
			title:"��������",
			field:'ComDate',
			width:100
		}, {
			title:"����ʱ��",
			field:'ComTime',
			width:100
		}, {
			title:"���ϸ�ԭ��",
			field:'ComReason',
			width:100
		}, {
			title:"��������",
			field:'ComAdvice',
			width:100
		}
	]];	
	
	var ComLogGrid = $UI.datagrid('#ComLogGrid', {
		lazy:false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.CommentComPlain',
			QueryName: 'QueryLog',
			DetailId:DetailId,			
		},
		onClickCell: function(index, filed ,value){	
			ComLogGrid.commonClickCell(index,filed,value)
		},
		columns: ComLogCm
	})
}