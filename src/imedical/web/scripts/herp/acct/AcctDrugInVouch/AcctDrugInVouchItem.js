var projUrl="herp.acct.acctdruginvouchexe.csp";

   var itemGridf = new dhc.herp.Gridff({
    title: 'ҩƷ�����Ϣ',
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
						id : 'kf',
						header : '<div style="text-align:center">�����ⷿ</div>',
						dataIndex : 'kf',
						width :200,
						editable : false,
						allowBlank : true,
						hidden : false

					},{
						id : 'ym',
						header : '<div style="text-align:center">�����·�</div>',
						dataIndex : 'ym',
						width : 100,
						editable : false,
						align:'center',
						allowBlank : true,
						hidden : false

					},{
						id : 'ctlocdr',
						header : '<div style="text-align:center">����id</div>',
						width : 200,
						editable : false,
						allowBlank : true,
						dataIndex : 'ctlocdr',
						hidden : true

					},{
						id : 'ctlocdesc',
						header : '<div style="text-align:center">��������</div>',
						width : 200,
						editable : false,
						allowBlank : true,
						dataIndex : 'ctlocdesc'

					},{
						id : 'cat',
						header : '<div style="text-align:center">ҩƷ���</div>',
						width : 150,
						editable : false,
						allowBlank : true,
						align : 'left',
						hidden : false,
						dataIndex : 'cat',
						renderer:function(value,cellmeta,record,rowIndex,columnIndex,store){
							return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>'	
						}

				}, {
						id : 'RpAmt',
						header : '<div style="text-align:center">�����</div>',
						width : 150,
						editable : false,
						allowBlank : true,
						hidden : false,
						align : 'right',
						type:'numberField',
						dataIndex : 'RpAmt'
					} ]				
});

 itemGridf.on('cellclick',function(g, rowIndex, columnIndex, e){
	 //alert(columnIndex)
	if(columnIndex=='6'){
		var mainSelect=itemGrid.getSelectionModel().getSelections(); 
		var detailScore=itemGridf.getSelectionModel().getSelections(); 		 
		var rowid=mainSelect[0].get("rowid");
		var cat=detailScore[0].get("cat");
		var ctlocdr=detailScore[0].get("ctlocdr");
		window.open("herp.acct.acctdruginvouchdetail.csp?rowid="+rowid+"&cat="+cat+"&ctlocdr="+ctlocdr);  		 
	 }
 });

 