///����ģ����ϸ��Ϣ
var itemDetail = new dhc.herp.Gridlyf({
    title: '����ģ����ϸ��Ϣ',
	iconCls:'list',
    region : 'south',
    url: 'herp.acct.reportempletitemexe.csp',
    fields: [
                   {
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
						id : 'RepItemCode1',
						header : '<div style="text-align:center">���������</div>',
						dataIndex : 'RepItemCode1',
						width : 80,
						editable:false,
						hidden : false

					}, {
						id : 'RepItemName1',
						header : '<div style="text-align:center">����������</div>',
						dataIndex : 'RepItemName1',
						width : 120,
						editable:false,
						hidden : false

					}, {
						id : 'Formula1',
						header : '<div style="text-align:center">���㹫ʽ</div>',
						width : 300,
						editable:false,
						allowBlank : false,
						dataIndex : 'Formula1'

				}, {
						id : 'Sequence1',
						header : '<div style="text-align:center">������</div>',
						width : 50,
						editable:false,
						align : 'center',
						hidden : false,
						dataIndex : 'Sequence1'

				}, {
						id : 'RepItemCode2',
						header : '<div style="text-align:center">���������</div>',
						width : 120,
						editable:false,
						hidden : false,
						dataIndex : 'RepItemCode2'

					}, {
						id : 'RepItemName2',
						header : '<div style="text-align:center">����������</div>',
						width : 140,
						editable:false,
						dataIndex : 'RepItemName2'

					}, {
						id : 'Formula2',
						header : '<div style="text-align:center">���㹫ʽ</div>',
						width : 300,
						editable : false,
						dataIndex : 'Formula2'
						
					},{
						id : 'Sequence2',
						header : '<div style="text-align:center">������</div>',
						width : 50,
						editable:false,
						align : 'center',
						dataIndex : 'Sequence2'

					},{
						id : 'RowNumber',
						header : '',
						width : 50,
						editable:false,
						align : 'right',
						hidden : true,
						dataIndex : 'RowNumber'

					}],
    
					xtype : 'grid',				
					height : 340
					
});
itemDetail.hiddenButton(0);
itemDetail.hiddenButton(1);
itemDetail.hiddenButton(2);
