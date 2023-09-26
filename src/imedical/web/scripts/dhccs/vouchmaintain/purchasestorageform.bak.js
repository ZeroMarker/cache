purchasestorageformFun = function(grid, rowIndex, columnIndex, e) {

	//var tmpText1='10-080001';
	//var tmpText2='';
	//var tmpText3='2010年1月23日';
	
	var selectedRec = grid.getStore().getAt(rowIndex);
	
	var fieldNO = grid.getColumnModel().getDataIndex(5);
	var fieldDate = grid.getColumnModel().getDataIndex(3);
	//var fieldWH = grid.getColumnModel().getDataIndex(6);
	
	var dataNO = selectedRec.get(fieldNO);
	var dataDate = selectedRec.get(fieldDate);
	//var dataWH = selectedRec.get(fieldWH);
	
	dataNO=(dataNO==undefined)?"":dataNO;
	dataDate=(dataDate==undefined)?"":dataDate;
	//dataWH=(dataWH==undefined)?"":dataWH;

	//alert(dataNO+","+dataDate+","+dataWH);
	
	var getDhcDataDetailST = new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({url:'dhc.cs.autohisoutexe.csp?action=GetDhcDataDetailJson'}),
			reader: new Ext.data.JsonReader({
				root: 'rows',
				totalProperty: 'results'
				}, [
					'InvNo',
					'InvDate',
					'ItmDesc',
					'Spec',
					'TrUom',
					'TrQty',
					'Rp',
					'RpAmt',
					'Sp',
					'SpAmt'
				]),
			remoteSort: true
		});
		
	var autoHisOutMedCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '药品编码',
			dataIndex: 'InvNo',
			width: 150,
			align: 'right',
			sortable: true
		},
		{
			header: "药品名称",
			dataIndex: 'ItmDesc',
			width: 200,
			align: 'left',
			sortable: true
		},
		{
			header: "规格型号",
			dataIndex: 'Spec',
			width: 100,
			align: 'right',
			sortable: true
		},
			{
			header: '计量单位',
			dataIndex: 'TrUom',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: "供应商",
			dataIndex: 'Suppliers',
			width: 150,
			align: 'left',
			sortable: true
		},
		{
			header: "数量",
			dataIndex: 'TrQty',
			width: 100,
			align: 'right',
			sortable: true
		},
		{
			header: '单价',
			dataIndex: 'Rp',
			width: 100,
			align: 'right',
			sortable: true
		},
		{
			header: "总价",
			dataIndex: 'RpAmt',
			width: 100,
			align: 'right',
			sortable: true
		}
	]);
	
	var autohisoutmedvouchForm = new Ext.form.FormPanel({
			//title:	'记账凭证',
			region:	'north',
			frame:	true,
			height:	80,
			items:	[	
						{
							xtype: 'panel',
							layout:"column",
							hideLabel:true,
							isFormField:true,
							items: [
								{
									columnWidth:.9,
									xtype: 'displayfield', 
									value: '<font size="6px"><center>采购入库单</center></font>'
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
									columnWidth:.1,
									xtype:'displayfield'
								},
								{
									columnWidth:.3,
									xtype:'displayfield',
									value: '单据编号：'+dataNO//+tmpText1
								},
								{
									columnWidth:.3,
									xtype:'displayfield',
									value: '仓库：'//+dataWH//+tmpText2
								},
								{
									columnWidth:.3,
									xtype:'displayfield',
									value: '制单时间：'+dataDate//+tmpText3
								}
							]
						}
					]
		});
	
	var autohisoutmedvouchMain = new Ext.grid.EditorGridPanel({
			store: getDhcDataDetailST , 
			cm: autoHisOutMedCm,
			region:'center',
			clicksToEdit:'auto',
			trackMouseOver: true,
			stripeRows: true,
			bbar:['采购员：李风','-','科主任审批：王通','-','库管员:李华','-','记账员：于丽'],////////////////temp
			loadMask: true
		});
	
	var purchasestorageformWin = new Ext.Window({
			//title:'采购入库单',
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
		
	getDhcDataDetailST.load();
    purchasestorageformWin.show();

};