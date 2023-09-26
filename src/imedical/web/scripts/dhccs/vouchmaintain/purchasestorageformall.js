purchasestorageformallFun = function(grid, rowIndex, columnIndex, e) {

	//var tmpText1='10-080001';
	//var tmpText2='';
	//var tmpText3='2010年1月23日';
	
	var selectedRec = grid.getStore().getAt(rowIndex);
	
	var fieldNO = grid.getColumnModel().getDataIndex(6);
	var fieldDate = grid.getColumnModel().getDataIndex(3);
	//var fieldWH = grid.getColumnModel().getDataIndex(6);
	
	var dataNO = selectedRec.get(fieldNO);
	var dataDate = selectedRec.get(fieldDate);
	//var dataWH = selectedRec.get(fieldWH);
	
	dataNO=(dataNO==undefined)?"":dataNO;
	dataDate=(dataDate==undefined)?"":dataDate;
	//dataWH=(dataWH==undefined)?"":dataWH;

	//alert(dataNO+","+dataDate+","+dataWH);
	
	//var getDhcDataDetailST = new Ext.data.Store({
	//		proxy: new Ext.data.HttpProxy({url:'dhc.cs.autohisoutexe.csp?action=GetDhcDataDetailJson'}),
	//		reader: new Ext.data.JsonReader({
	//			root: 'rows',
	//			totalProperty: 'results'
	//			}, [
	//				'InvNo',
	//				'InvDate',
	//				'ItmDesc',
	//				'Spec',
	//				'TrUom',
	//				'TrQty',
	//				'Rp',
	//				'RpAmt',
	//				'Sp',
	//				'SpAmt'
	//			]),
	//		remoteSort: true
	//	});
		
	var autoHisOutMedCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '物资类别',
			//dataIndex: 'InvNo',
			width: 240,
			align: 'center',
			sortable: true
		},
		{
			header: "科室领用",
			//dataIndex: 'ItmDesc',
			width: 240,
			align: 'center',
			sortable: true
		},
		{
			header: "盘亏",
			//dataIndex: 'Spec',
			width: 240,
			align: 'center',
			sortable: true
		},
			{
			header: '盘盈',
			//dataIndex: 'TrUom',
			width: 240,
			align: 'center',
			sortable: true
		}
	]);
	
	var autohisoutmedvouchForm = new Ext.form.FormPanel({
			//title:	'记账凭证',
			region:	'north',
			frame:	true,
			height:	60,
			items:	[	
						{
							xtype: 'panel',
							layout:"column",
							hideLabel:true,
							isFormField:true,
							items: [
								{
									columnWidth:.9,
									xtype:'displayfield'
								},
								{
									columnWidth:.1,
									xtype:'button',
									text: '明细查询',
									name: 'bc',
									tooltip: '明细查询',  
									handler:function(b){
									
										},
									iconCls: 'add'
								}
							]
						},
						{
							xtype: 'panel',
							layout:"column",
							hideLabel:true,
							isFormField:true,
							items: [
								{
									columnWidth:.05,
									xtype:'displayfield'
								},
								{
									columnWidth:.23,
									xtype:'displayfield',
									value: '会计期间：'//+dataNO//+tmpText1
								},
								{
									columnWidth:.23,
									xtype:'displayfield',
									value: '临时凭证号：'//+dataWH//+tmpText2
								},
								{
									columnWidth:.23,
									xtype:'displayfield',
									value: '正式凭证号：'//+dataDate//+tmpText3
								},
								{
									columnWidth:.23,
									xtype:'displayfield',
									value: '制单人：'//+dataWH//+tmpText2
								}
							]
						}
					]
		});
	
	var autohisoutmedvouchMain = new Ext.grid.EditorGridPanel({
			store: new Ext.data.Store(), 
			cm: autoHisOutMedCm,
			region:'center',
			clicksToEdit:'auto',
			trackMouseOver: true,
			stripeRows: true,
			loadMask: true
		});
	
	var purchasestorageformWin = new Ext.Window({
			title:'汇总表',
			width:1050,
			height:600,
			minWidth:1050,
			minHeight:600,
			layout:'border',
			plain:true,
			modal:true,
			//bodyStyle:'padding:5px;',
			items: [autohisoutmedvouchForm,autohisoutmedvouchMain]
		});
		
	//getDhcDataDetailST.load();
    purchasestorageformWin.show();

};