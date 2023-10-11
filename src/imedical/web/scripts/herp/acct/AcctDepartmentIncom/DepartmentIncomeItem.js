var projUrl="herp.acct.acctdepartmentincomeexe.csp";

   var itemGridf = new dhc.herp.Gridff({
    title: '科室收入明细表',
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
    //atLoad : true, // 是否自动刷新
    url: projUrl,
    fields: [
     //  new Ext.grid.CheckboxSelectionModel({editable:false}),
                   {
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					},{
						id : 'BillNo',
						header : '<div style="text-align:center">业务编码</div>',
						dataIndex : 'BillNo',
						width :150,
						editable:false
					},{
						id : 'DeptType',
						header : '<div style="text-align:center">就诊类型</div>',
						width : 150,
						editable:false,
						align : 'left',
						hidden : false,
						dataIndex : 'DeptType'
					},{
						id : 'DeptCode',
						header : '<div style="text-align:center">科室编码</div>',
						dataIndex : 'DeptCode',
						width :200,
						editable:false,
						hidden : true
					},{
						id : 'DeptName',
						header : '<div style="text-align:center">科室名称</div>',
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
						header : '<div style="text-align:center">收费编码</div>',
						dataIndex : 'TARECCode',
						width : 180,
						editable:false,
						hidden : true
					},{
						id : 'TARECName',
						header : '<div style="text-align:center">收费类别</div>',
						dataIndex : 'TARECName',
						width : 180,
						editable:false
					},{
						id : 'AcctAmount',
						header : '<div style="text-align:center">收费金额</div>',
						width : 150,
						editable:false,
						hidden : false,
						align : 'right',						
						dataIndex : 'AcctAmount'
					} ]
	
});
