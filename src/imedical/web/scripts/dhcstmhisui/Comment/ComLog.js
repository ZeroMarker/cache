/*
点评日志查询
*/
var ComLogSearch=function(DetailId){
	$HUI.dialog('#LogWin').open();
	var ComLogCm = [[{
			title:"点评日志明细id",
			field:'RowId',
			hidden:true
		}, {
			title:"点评单号",
			field:'ComNo',
			width:120
		}, {
			title:"医嘱名称",
			field:'Arcim',
			width:140
		}, {
			title:"点评结果",
			field:'ComResult',
			width:100
		}, {
			title:"点评人",
			field:'ComUser',
			width:100
		}, {
			title:"点评日期",
			field:'ComDate',
			width:100
		}, {
			title:"点评时间",
			field:'ComTime',
			width:100
		}, {
			title:"不合格原因",
			field:'ComReason',
			width:100
		}, {
			title:"点评建议",
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