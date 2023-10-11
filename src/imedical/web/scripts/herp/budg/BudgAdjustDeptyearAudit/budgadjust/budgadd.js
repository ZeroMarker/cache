var addButton = new Ext.Toolbar.Button({
	text: '���',
	tooltip: '���',
	iconCls: 'add',
	handler: function() {
		var yearField = new Ext.form.TextField({
			id: 'yearField',
			fieldLabel: '������',
			allowBlank: false,
			emptyText: '������...',
			anchor: '90%'
		});
		var adjustNoField = new Ext.form.TextField({
			id: 'adjustNoField',
			fieldLabel: '�������',
			allowBlank: false,
			emptyText: '�������...',
			anchor: '90%'
		});
		var adjustDateField = new Ext.form.DateField({
			id:'adjustDateField',
			fieldLabel: '��������',
			//width:120,
			anchor: '90%',
			readonly:true ,
			value:new Date(),
			allowBlank:true,
			format:'Y-m-d',
			editable:false,
			selectOnFocus:'true'
		});
		var adjustFileField = new Ext.form.TextField({
			id: 'adjustFileField',
			fieldLabel: '�����ĺ�',
			allowBlank: true,
			emptyText: '�����ĺ�...',
			anchor: '90%'
		});	
		var memoField = new Ext.form.TextField({
			id: 'memoField',
			fieldLabel: '����˵��',
			allowBlank: true,
			emptyText: '����˵��...',
			anchor: '90%'
		});
		
		var schemeDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','Name'])
		});
		schemeDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
			url:'herp.budg.budgadjustinstructionexe.csp'+'?action=listScheme&Year='+yearField.getValue()+'&str='+encodeURIComponent(Ext.getCmp('schemeField').getRawValue()),method:'POST'});
		});
		var schemeField = new Ext.form.ComboBox({
			id: 'schemeField',
			fieldLabel: '��Ӧ����',
			//width:200,
			listWidth : 300,
			allowBlank: true,
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
			editable:true,
			anchor: '90%'
		});
		// create form panel
  		var formPanel = new Ext.form.FormPanel({
  			baseCls: 'x-plain',
    		labelWidth: 80,
    		items: [
    			yearField,
				adjustNoField,
     			//adjustDateField,
      			adjustFileField,
      			memoField,
      			schemeField
      		]
		});
  		// define window and show it in desktop
  		var window = new Ext.Window({
  			title: '���Ԥ�����',
    		width: 400,
    		height:300,
    		minWidth: 400,
    		minHeight: 300,
    		layout: 'fit',
    		plain:true,
    		modal:true,
    		bodyStyle:'padding:5px;',
    		buttonAlign:'center',
    		items: formPanel,
    		buttons: [{
    			text: '����',
				handler: function() {
      				// check form value
      				var Year = yearField.getValue();
      				var AdjustNo = adjustNoField.getValue();
      				var AdjustDate = adjustDateField.getRawValue();
					var AdjustFile = adjustFileField.getValue();
					var Memo = encodeURIComponent(memoField.getValue());
					var schemeID = schemeField.getValue();

					//alert(AdjustDate);	
      				AdjustNo = AdjustNo.trim();
					AdjustFile = AdjustFile.trim();
					Memo = Memo.trim();
					
					if(Year=="")
      				{
      					Ext.Msg.show({title:'����',msg:'������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      					return;
      				};
      				if(AdjustNo=="")
      				{
      					Ext.Msg.show({title:'����',msg:'�������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      					return;
      				};
      				if(AdjustDate=="")
      				{
      					Ext.Msg.show({title:'����',msg:'��������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      					return;
      				};
      				/*
      				if(AdjustFile=="")
      				{
      					Ext.Msg.show({title:'����',msg:'�����ĺ�Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      					return;
      				};
      				if(Memo=="")
      				{
      					Ext.Msg.show({title:'����',msg:'����˵��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      					return;
      				};
      				*/
      				if(schemeID==""&&AdjustNo!=="0")
      				{
      					Ext.Msg.show({title:'����',msg:'��Ӧ����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      					return;
      				};
        			//var data = adjustNo+'^'+adjustDate+'^'+adjustFile+'^'+meno;
					if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: adjustUrl+'?action=add&Year='+Year+'&AdjustNo='+AdjustNo+'&AdjustDate='+AdjustDate+'&AdjustFile='+AdjustFile+'&Memo='+Memo+'&schemeID='+schemeID,
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  		if (jsonData.success=='true') {
						  			Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params : {start: 0,limit: 25}});
									window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyRecData') message='���������Ϊ��!';
									if(jsonData.info=='RepCode') message='����ı���Ѿ�����!';
									if(jsonData.info=='RepName') message='����������Ѿ�����!';
									Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							}//,scope: this
						});
        			}
        			else{
						Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ�����ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
					window.close();
	    		}
    		},
    		{
				text: 'ȡ��',
        		handler: function(){window.close();}
      		}]
    	});
    	window.show();
	}					
});
