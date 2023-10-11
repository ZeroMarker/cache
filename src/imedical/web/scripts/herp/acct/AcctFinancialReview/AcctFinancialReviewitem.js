
//var acctbookid=GetAcctBookID();

   var itemGridf = new dhc.herp.Gridff({
    title: '资产折旧明细表',
	iconCls:'list',
	region: 'south',
    layout:"fit",
    split : true,
    collapsible : true,
    xtype : 'grid',
    trackMouseOver : true,
    stripeRows : true,
    loadMask : true,
    height : 330,
    trackMouseOver: true,
    stripeRows: true,
	//style:'text-align:center;',
	//viewConfig:{forceFit:true},
    atLoad : true, // 是否自动刷新
    url: 'herp.acct.acctfinancialreviewitemexe.csp',
    fields: [
     //  new Ext.grid.CheckboxSelectionModel({editable:false}),
                   {
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					}, 
					{
						id : 'Code',
						header : '<div style="text-align:center">科室编码</div>',
						dataIndex : 'Code',
						width :150,
						editable:false,
						hidden : true

					},{
						id : 'Loc',
						header : '<div style="text-align:center">所属科室</div>',
						width : 280,
						editable:false,
						align : 'left',
						hidden : false,
						dataIndex : 'Loc'

				},
					/*
					{
						id : 'EquipName',
						header : '<div style="text-align:center">设备名称</div>',
						dataIndex : 'EquipName',
						width :150,
						//editable:true,
						hidden : false

					}, */
					{
						id : 'EquipTypeDR',
						header : '<div style="text-align:center">设备类组ID</div>',
						dataIndex : 'EquipTypeDR',
						width : 180,
						editable:false,
						
						//allowBlank:true,
						hidden : true

					},
					{
						id : 'EquipType',
						header : '<div style="text-align:center">设备类组</div>',
						dataIndex : 'EquipType',
						width : 180,
						editable:false,
						//allowBlank:true,
						renderer:function(value,cellmeta,record,rowIndex,columnIndex,store){
							return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>'	
						},
						hidden : false

					}, /*{
						id : 'StatCat',
						header : '<div style="text-align:center">设备类型</div>',
						width : 150,
						//editable:true,
						//allowBlank : true,
						dataIndex : 'StatCat'

				}, */
				 {
						id : 'Amount',
						header : '<div style="text-align:center">折旧金额</div>',
						width : 150,
						editable:false,
						hidden : false,
						align : 'right',
						
						dataIndex : 'Amount'
					}  /*{
						id : 'Remark',
						header : '<div style="text-align:center">备注</div>',
						width : 300,
						//editable : true,
						//allowBlank:true,
						dataIndex : 'Remark'
						
					}*/]
    
				
					
});

 itemGridf.on('cellclick',function(g, rowIndex, columnIndex, e){
	if(columnIndex=='5'){
		 var mainSelect=itemGrid.getSelectionModel().getSelections(); 
		 var detailScore=itemGridf.getSelectionModel().getSelections(); 
		 
		 var mainid=mainSelect[0].get("rowid");
		 var typeID=detailScore[0].get("EquipTypeDR");
		 var code=detailScore[0].get("Code");
		 
	     window.open("herp.acct.acctfinancialdetail.csp?mainid="+mainid+"&typeID="+typeID+"&code="+code);  
		 
	}
 });