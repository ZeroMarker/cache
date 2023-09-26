purchasestorageformallFun = function(grid, rowIndex, columnIndex, e) {

	//var tmpText1='10-080001';
	//var tmpText2='';
	//var tmpText3='2010��1��23��';
	
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
			header: '�������',
			//dataIndex: 'InvNo',
			width: 240,
			align: 'center',
			sortable: true
		},
		{
			header: "��������",
			//dataIndex: 'ItmDesc',
			width: 240,
			align: 'center',
			sortable: true
		},
		{
			header: "�̿�",
			//dataIndex: 'Spec',
			width: 240,
			align: 'center',
			sortable: true
		},
			{
			header: '��ӯ',
			//dataIndex: 'TrUom',
			width: 240,
			align: 'center',
			sortable: true
		}
	]);
	
	var autohisoutmedvouchForm = new Ext.form.FormPanel({
			//title:	'����ƾ֤',
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
									text: '��ϸ��ѯ',
									name: 'bc',
									tooltip: '��ϸ��ѯ',  
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
									value: '����ڼ䣺'//+dataNO//+tmpText1
								},
								{
									columnWidth:.23,
									xtype:'displayfield',
									value: '��ʱƾ֤�ţ�'//+dataWH//+tmpText2
								},
								{
									columnWidth:.23,
									xtype:'displayfield',
									value: '��ʽƾ֤�ţ�'//+dataDate//+tmpText3
								},
								{
									columnWidth:.23,
									xtype:'displayfield',
									value: '�Ƶ��ˣ�'//+dataWH//+tmpText2
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
			title:'���ܱ�',
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