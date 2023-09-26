purchasestorageformFun = function(grid, rowIndex, columnIndex, e) {

	//var tmpText1='10-080001';
	//var tmpText2='';
	//var tmpText3='2010��1��23��';
	
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
			header: 'ҩƷ����',
			dataIndex: 'InvNo',
			width: 150,
			align: 'right',
			sortable: true
		},
		{
			header: "ҩƷ����",
			dataIndex: 'ItmDesc',
			width: 200,
			align: 'left',
			sortable: true
		},
		{
			header: "����ͺ�",
			dataIndex: 'Spec',
			width: 100,
			align: 'right',
			sortable: true
		},
			{
			header: '������λ',
			dataIndex: 'TrUom',
			width: 100,
			align: 'left',
			sortable: true
		},
		{
			header: "��Ӧ��",
			dataIndex: 'Suppliers',
			width: 150,
			align: 'left',
			sortable: true
		},
		{
			header: "����",
			dataIndex: 'TrQty',
			width: 100,
			align: 'right',
			sortable: true
		},
		{
			header: '����',
			dataIndex: 'Rp',
			width: 100,
			align: 'right',
			sortable: true
		},
		{
			header: "�ܼ�",
			dataIndex: 'RpAmt',
			width: 100,
			align: 'right',
			sortable: true
		}
	]);
	
	var autohisoutmedvouchForm = new Ext.form.FormPanel({
			//title:	'����ƾ֤',
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
									value: '<font size="6px"><center>�ɹ���ⵥ</center></font>'
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
									value: '���ݱ�ţ�'+dataNO//+tmpText1
								},
								{
									columnWidth:.3,
									xtype:'displayfield',
									value: '�ֿ⣺'//+dataWH//+tmpText2
								},
								{
									columnWidth:.3,
									xtype:'displayfield',
									value: '�Ƶ�ʱ�䣺'+dataDate//+tmpText3
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
			bbar:['�ɹ�Ա�����','-','��������������ͨ','-','���Ա:�','-','����Ա������'],////////////////temp
			loadMask: true
		});
	
	var purchasestorageformWin = new Ext.Window({
			//title:'�ɹ���ⵥ',
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