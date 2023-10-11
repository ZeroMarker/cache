var projUrl="herp.acct.acctdepartmentincomeexe.csp";

   var itemGridf = new dhc.herp.Gridff({
    title: '����������ϸ��',
	iconCls : 'list',
	region: 'south',
    layout:"fit",
    split : true,
    collapsible : true,
    xtype : 'grid',
    trackMouseOver : true,
    stripeRows : true,
    loadMask : true,
    height : 280,
    trackMouseOver: true,
    stripeRows: true,
    //atLoad : true, // �Ƿ��Զ�ˢ��
    url: projUrl,
    fields: [
     //  new Ext.grid.CheckboxSelectionModel({editable:false}),
                   {
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					},{
						id : 'BillNo',
						header : '<div style="text-align:center">ҵ�����</div>',
						dataIndex : 'BillNo',
						width :150,
						editable:false
					},{
						id : 'DeptType',
						header : '<div style="text-align:center">��������</div>',
						width : 150,
						editable:false,
						align : 'left',
						hidden : false,
						dataIndex : 'DeptType'
					},{
						id : 'DeptCode',
						header : '<div style="text-align:center">���ұ���</div>',
						dataIndex : 'DeptCode',
						width :200,
						editable:false,
						hidden : true
					},{
						id : 'DeptName',
						header : '<div style="text-align:center">��������</div>',
						dataIndex : 'DeptName',
						width :250,
						editable:false,
						hidden : false,
						renderer: function formatQtip(data,metadata){
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					},{
						id : 'TARECCode',
						header : '<div style="text-align:center">�շѱ���</div>',
						dataIndex : 'TARECCode',
						width : 180,
						editable:false,
						hidden : true
					},{
						id : 'TARECName',
						header : '<div style="text-align:center">�շ����</div>',
						dataIndex : 'TARECName',
						width : 180,
						editable:false
					},{
						id : 'AcctAmount',
						header : '<div style="text-align:center">�շѽ��</div>',
						width : 150,
						editable:false,
						hidden : false,
						align : 'right',						
						dataIndex : 'AcctAmount'
					} ]
	
});
