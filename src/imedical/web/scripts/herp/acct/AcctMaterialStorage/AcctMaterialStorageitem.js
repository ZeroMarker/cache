var projUrl="herp.acct.acctmaterialstorageexe.csp";

   var itemGridf = new dhc.herp.Gridff({
    title: '物资科室入库信息',
	iconCls:'list',
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
						id : 'kf',
						header : '<div style="text-align:center">入库科室</div>',
						dataIndex : 'kf',
						width :200,
						editable : false,
						allowBlank : true,
						hidden : false

					},{
						id : 'ym',
						header : '<div style="text-align:center">所属月份</div>',
						dataIndex : 'ym',
						width : 100,
						editable : false,
						align:'center',
						allowBlank : true,
						hidden : false

					},{
						id : 'APCVMId',
						header : '<div style="text-align:center">供应商id</div>',
						width : 100,
						editable : false,
						allowBlank : true,
						dataIndex : 'APCVMId',
						hidden : true

					},{
						id : 'APCVMCode',
						header : '<div style="text-align:center">供应商编码</div>',
						width : 100,
						editable : false,
						allowBlank : true,
						dataIndex : 'APCVMCode',
						hidden : true

					},{
						id : 'APCVMName',
						header : '<div style="text-align:center">供应商</div>',
						width : 280,
						editable : false,
						allowBlank : true,
						dataIndex : 'APCVMName'

					},{
						id : 'scgcode',
						header : '<div style="text-align:center">物资编码</div>',
						width : 200,
						editable : false,
						allowBlank : true,
						dataIndex : 'scgcode',
						hidden : true
					},{
						id : 'cat',
						header : '<div style="text-align:center">物资分类</div>',
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
						header : '<div style="text-align:center">入库金额</div>',
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
	if(columnIndex=='8'){
		var mainSelect=itemGrid.getSelectionModel().getSelections(); 
		var detailScore=itemGridf.getSelectionModel().getSelections(); 		 
		var rowid=mainSelect[0].get("rowid");
		var cat=detailScore[0].get("cat");
		var ctlocID=detailScore[0].get("APCVMId");
	window.open("herp.acct.acctmaterialstoragedetail.csp?rowid="+rowid+"&cat="+cat+"&ctlocID="+ctlocID);  		 
	 }
 });

 