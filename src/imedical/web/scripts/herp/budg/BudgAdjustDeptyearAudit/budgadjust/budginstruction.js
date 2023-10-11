
budginstructionFun = function(adjid,Year,adjustno, memo){
	var budginstructiontitle = "����˳��-����˵��";
	
	var schemeDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','Name'])
	});

	schemeDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:'herp.budg.budgadjustinstructionexe.csp'+'?action=listScheme&start='+0+'&limit='+25+'&str='+encodeURIComponent(Ext.getCmp('schemeField').getRawValue()),method:'POST'});
	});

	var schemeField = new Ext.form.ComboBox({
		id: 'schemeField',
		fieldLabel: '��Ӧ����',
		width:200,
		listWidth : 300,
		allowBlank: false,
		store: schemeDs,
		valueField: 'rowid',
		displayField: 'Name',
		triggerAction: 'all',
		emptyText:'��ѡ���Ӧ����...',
		name: 'schemeField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
		
	var budginstructionGrid = new dhc.herp.Gridsch({
				width : 400,
				region : 'center',
				url : 'herp.budg.budgadjustinstructionexe.csp',
				listeners:{
        		'cellclick' : function(grid, rowIndex, columnIndex, e) {
               		var record = grid.getStore().getAt(rowIndex);
               		// �����������õ�Ԫ�����༭�Ƿ����
               		if ((record.get('rowid') !== '') &&(columnIndex == 3)) {    
                     		 return false;
               		} else{ return true;}
        		},        
        		'celldblclick' : function(grid, rowIndex, columnIndex, e) {
           			var record = grid.getStore().getAt(rowIndex);
            		if ((record.get('rowid') !== '') &&(columnIndex == 3)) {      
                   		return false;
            		} else{return true;}
     				}
				},
				fields : [{
							header : '������ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'SchemDR',
							header : 'Ԥ����Ʒ���ID',
							dataIndex : 'SchemDR',
							width : 60,
							editable:false,
							hidden : true
						},{
							id : 'schemeCode',
							header : 'Ԥ����Ʒ������',
							dataIndex : 'schemeCode',
							width : 60,
							editable:false
						},{
							id : 'schemeName',
							header : 'Ԥ����Ʒ�������',
							dataIndex : 'schemeName',
							//align:'right',
							width : 60,
							type:schemeField,
							editable:true
						}
						],
						viewConfig : {forceFit : true},
						tbar : ['������ţ�',adjustno,'-','����˵����',memo ,'-']	
	});

	//budginstructionGrid.btnAddHide();  //�������Ӱ�ť
   	//budginstructionGrid.btnSaveHide();  //���ر��水ť
    budginstructionGrid.btnResetHide();  //�������ð�ť
    budginstructionGrid.btnDeleteHide(); //����ɾ����ť
    budginstructionGrid.btnPrintHide();  //���ش�ӡ��ť
	budginstructionGrid.load({params : {start : 0,limit : 25,Year:Year,AdjustNo:adjustno}});
	// ��ʼ��ȡ����ť
	cancelButton = new Ext.Toolbar.Button({ text : '�ر�'});
	// ����ȡ����ť����Ӧ����
	cancelHandler = function(){ 
	  window.close();
	};
	// ���ȡ����ť�ļ����¼�
	cancelButton.addListener('click', cancelHandler, false);
		
	// ��ʼ�����
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [budginstructionGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : budginstructiontitle,
				plain : true,
				width : 600,
				height : 350,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
};