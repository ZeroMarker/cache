////wyy
var accPeriodsEditor = function(grid){
	var rowObj = grid.getSelections();
	var parRef = rowObj[0].get("rowid");
		
	var accPeriodDs = new Ext.data.Store({
		autoLoad: true,
		proxy:"",                                                        
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','active'])
	});

	accPeriodDs.on('beforeload',function(ds, o){           
		ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.accperiodexe.csp?action=list&searchField=shortcut&searchValue='+Ext.getCmp('accPeriodSelecter').getRawValue()+'&active=Y', method:'GET'});
	});

	var accPeriodSelecter = new Ext.form.ComboBox({
		id:'accPeriodSelecter',
		fieldLabel:'��������',
		store: accPeriodDs,
		valueField:'rowId',
		displayField:'shortcut',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		anchor: '30%',
		listWidth:250,
		triggerAction:'all',
		emptyText:'��������...',
		allowBlank: false,
		name:'accPeriodSelecter',
		selectOnFocus: true,
		forceSelection: true 
	});
	
	accPeriodSelecter.on("focus",function(field){
		field.setValue('');
	});

	accPeriodSelecter.on("select",function(cmb,rec,id ){	
		accPeriodsSelectedDs.proxy=new Ext.data.HttpProxy({url: 'dhc.ca.accperiodsexe.csp?action=list&parRef='+parRef+'&periodDr='+accPeriodSelecter.getValue()});
		accPeriodsSelectedDs.load({params:{start:0, limit:25}});
		accPeriodsUnselectedDs.proxy=new Ext.data.HttpProxy({url: 'dhc.ca.accperiodsexe.csp?action=listUn&parRef='+parRef+'&periodDr='+accPeriodSelecter.getValue()});
		accPeriodsUnselectedDs.load({params:{start:0, limit:25}});		
	});
	
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		region:'north',
		height:23,
		labelWidth: 70,
		items: accPeriodSelecter					       
	});	
		
		
	var accPeriodsCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '����',
			dataIndex: 'monthCode',
			width: 60,
			align: 'left',
			sortable: true
		},
		{
			header: '����',
			dataIndex: 'monthName',
			width: 200,
			align: 'left',
			sortable: true
		}
	]);	
	
	var accPeriodsSelectedDs = new Ext.data.Store({
		proxy: '',
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, [
				'rowid',
				'parRef',
				'periodDr',
				'monthDr',
				'monthCode',
				'monthName'
			]),
		remoteSort: true
	});
	accPeriodsSelectedDs.setDefaultSort('rowid', 'DESC');

	var accPeriodsSelectedPT= new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: accPeriodsSelectedDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������"
	});
	
	var monSelectedGP = new Ext.grid.GridPanel({//���
		title: '��ѡ������(���ɾ��)',
		store: accPeriodsSelectedDs,
		cm: accPeriodsCm,
		width:400,
		region:'east',
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		bbar: accPeriodsSelectedPT
	});
	
	monSelectedGP.on('rowclick',function(grid,rowIndex,e){
		var selectedRowObj = grid.getSelections();
		var rowid = selectedRowObj[0].get("rowid");
		//alert(rowid);
		Ext.Ajax.request({
							url: 'dhc.ca.accperiodsexe.csp?action=del&id='+rowid,
							//waitMsg:'ɾ����...',
							failure: function(result, request) {
									Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') { 
									accPeriodsSelectedDs.load({params:{start:accPeriodsSelectedPT.cursor, limit:accPeriodsSelectedPT.pageSize}});
									accPeriodsUnselectedDs.load({params:{start:accPeriodsUnselectedPT.cursor, limit:accPeriodsUnselectedPT.pageSize}});
								}
							},
							scope: this
						});
	})
	
	var accPeriodsUnCm = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
		{
			header: '����',
			dataIndex: 'monthCode',
			width: 60,
			align: 'left',
			sortable: true
		},
		{
			header: '����',
			dataIndex: 'monthName',
			width: 200,
			align: 'left',
			sortable: true
		}
	]);	
	
	var accPeriodsUnselectedDs = new Ext.data.Store({
		proxy: '',
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, [
				'monthDr',
				'monthCode',
				'monthName'
			]),
		remoteSort: true
	});
	accPeriodsUnselectedDs.setDefaultSort('monthDr', 'DESC');

	var accPeriodsUnselectedPT= new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: accPeriodsUnselectedDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������"
	});
	
	var monUnselectedGP = new Ext.grid.GridPanel({//���
		title: 'δѡ������(������)',
		store: accPeriodsUnselectedDs,
		cm: accPeriodsUnCm,
		
		region:'center',
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		bbar: accPeriodsUnselectedPT
	});

	monUnselectedGP.on('rowclick',function(grid,rowIndex,e){
		var unSelectedRowObj = grid.getSelections();
		var monthDr = unSelectedRowObj[0].get("monthDr");
		//alert(rowid);
		Ext.Ajax.request({
							url: 'dhc.ca.accperiodsexe.csp?action=add&parRef='+parRef+'&monthDr='+monthDr+'&periodDr='+accPeriodSelecter.getValue(),
							failure: function(result, request) {
									Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') { 
									accPeriodsSelectedDs.load({params:{start:accPeriodsSelectedPT.cursor, limit:accPeriodsSelectedPT.pageSize}});
									accPeriodsUnselectedDs.load({params:{start:accPeriodsUnselectedPT.cursor, limit:accPeriodsUnselectedPT.pageSize}});
								}
								else{
									Ext.Msg.show({title:'��ʾ',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									}
								
							},
							scope: this
						});
	})
	
	var accWindow = new Ext.Window({
	  	title: '�������䶨���',
	    width: 800,
	    height:600,
	    minWidth: 800,
	    minHeight: 600,
	    layout: 'border',
	    plain:true,
	    modal:true,
	    bodyStyle:'padding:5px;',
	    buttonAlign:'center',
	    items:[formPanel,monSelectedGP,monUnselectedGP],
		buttons: [{
			text: 'ȷ��',
			handler: function(){accWindow.close();}
		}]
	});
	accWindow.show();
};

