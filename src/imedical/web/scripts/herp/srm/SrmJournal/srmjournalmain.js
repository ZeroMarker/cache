
var itemGrid = new dhc.herp.Grid({
        title: '�ڿ�����',
        width: 400,
        //edit:false,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'herp.srm.srmJournalexe.csp',	  
		//tbar:delButton,
		atLoad : true, // �Ƿ��Զ�ˢ��
		selectOnFocus : true,
		forceSelection : true,
		loadmask:true,
        fields: [{
             id:'rowid',
            header: 'ID',
            dataIndex: 'rowid',
	    	editable:false,
            hidden: true
        },{
            id:'SN',
            header: '�ڿ�ISSN��',
			allowBlank: false,
			width:150,
			editable:false,
            dataIndex: 'SN'
        },{
            id:'CN',
            header: '�ڿ�CN��',
			allowBlank: false,
			width:150,
			editable:false,
            dataIndex: 'CN'
        },{
            id:'Name',
            header: '�ڿ�����',
			allowBlank: false,
			width:150,
			editable:false,
            dataIndex: 'Name'
        },{
           id:'IsValid',
            header: '�Ƿ���Ч',
			width:200,
			editable:false,
            dataIndex: 'IsValid',
            hidden: true
        }] 
});

///////////////////��Ӱ�ť///////////////////////
var addSrmJournalButton = new Ext.Toolbar.Button({
		text: '���',
    	tooltip: '����µ��ڿ�',        
    	iconCls: 'add',
		handler: function(){addFun();}
});

/////////////////�޸İ�ť/////////////////////////
var editSrmJournalButton  = new Ext.Toolbar.Button({
		text: '�޸�',        
		tooltip: '�޸�ѡ�����ڿ�',
		iconCls: 'option',
		handler: function(){editFun();}
});

////////////////ɾ����ť//////////////////////////
var delSrmJournalButton  = new Ext.Toolbar.Button({
		text: 'ɾ��',        
		tooltip: 'ɾ��ѡ�����ڿ�',
		iconCls: 'remove',
		handler: function(){delFun();}
});

////////////////��ӹ���/////////////////////////
addFun = function() {

	var SNField = new Ext.form.TextField({
		id:'SNField',
    fieldLabel: '�ڿ�ISSN��',
    allowBlank: false,
    emptyText:'�ڿ�ISSN��...',
    anchor: '95%'
	});
	
	var CNField = new Ext.form.TextField({
		id:'CNField',
    fieldLabel: '�ڿ�CN��',
    allowBlank: false,
    emptyText:'�ڿ�CN��...',
    anchor: '95%'
	});

	var nameField = new Ext.form.TextField({
		id:'nameField',
    fieldLabel: '�ڿ�����',
    allowBlank: false,
    emptyText:'�ڿ�����...',
    anchor: '95%'
	});
	
	// create form panel
  var addFormPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 70,
    items: [
    		SNField,
    		CNField,
            nameField
            
		]
	});
    
  // define window and show it in desktop
  var addWindow = new Ext.Window({
  	title: '����ڿ�',
    width: 400,
    height:300,
    minWidth: 400,
    minHeight: 300,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: addFormPanel,
    buttons: [{
    	text: '����', 
      handler: function() {
      		// check form value
      		var SN = SNField.getValue();
      		var Name = nameField.getValue();
      		var CN = CNField.getValue();
        	SN = SN.trim();
      		Name = Name.trim();
      		CN = CN.trim();
      		
      		if(SN=="")
      		{
      			Ext.Msg.show({title:'����',msg:'�ڿ�ISSN��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(Name=="")
      		{
      			Ext.Msg.show({title:'����',msg:'�ڿ�����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(CN=="")
      		{
      			Ext.Msg.show({title:'����',msg:'�ڿ�CN��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		
      		
        	if (addFormPanel.form.isValid()) {
						Ext.Ajax.request({
							url: 'herp.srm.srmJournalexe.csp?action=add&SN='+encodeURIComponent(SN)+'&Name='+encodeURIComponent(Name)+'&CN='+encodeURIComponent(CN),
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								  itemGrid.load({params:{start:0, limit:25}});
									//window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='RepCode') message='������ڿ��Ѿ�����!';								
								  Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
        	}
        	else{
						Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ�����ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}             
	    	}
    	},
    	{
				text: 'ȡ��',
        handler: function(){addWindow.close();}
      }]
    });

    addWindow.show();
};

/////////////////////�޸Ĺ���/////////////////////
editFun = function() {
	var rowObj = itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	//alert(rowObj[0].get("remark"));
	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		myRowid = rowObj[0].get("rowid"); 
	}

	var SNField = new Ext.form.TextField({
	id: 'SNField',
    fieldLabel: '�ڿ�ISSN��',
    allowBlank: false,
    emptyText: '�ڿ�ISSN��...',
    name: 'SN',
    anchor: '90%'
	});
	
	var CNField = new Ext.form.TextField({
	id: 'CNField',
    fieldLabel: '�ڿ�CN��',
    allowBlank: false,
    emptyText: '�ڿ�CN��...',
    name: 'CN',
    anchor: '90%'
	});
	
	var nameField = new Ext.form.TextField({
	id: 'nameField',
    fieldLabel: '�ڿ�����',
    allowBlank: false,
    emptyText: '�ڿ�����...',
    name: 'Name',
    anchor: '90%'
	});
	
	
	// create form panel
  var editFormPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 70,
    items: [
            	SNField,
            	CNField,
            	nameField
		]
	});
	
	editFormPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);/////////////////////////////////
		});

  // define window and show it in desktop
  var editWindow = new Ext.Window({
  	title: '�޸��ڿ���Ϣ',
    width: 400,
    height:300,
    minWidth: 400,
    minHeight: 300,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: editFormPanel,
    buttons: [{
    	text: '����', 
      handler: function() {
      	// check form value
      		var SN = SNField.getValue();
      		var Name = nameField.getValue();
      		var CN = CNField.getValue();
      		
      		SN = SN.trim();
      		Name = Name.trim();
			CN = CN.trim();
      		if(SN=="")
      		{
      			Ext.Msg.show({title:'����',msg:'�ڿ�ISSNΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(CN=="")
      		{
      			Ext.Msg.show({title:'����',msg:'�ڿ�CNΪ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(Name=="")
      		{
      			Ext.Msg.show({title:'����',msg:'�ڿ�����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		  		
        	if (editFormPanel.form.isValid()) {
						Ext.Ajax.request({
							url: 'herp.srm.srmJournalexe.csp?action=edit&rowid='+myRowid+'&SN='+encodeURIComponent(SN)+'&Name='+encodeURIComponent(Name)+'&CN='+encodeURIComponent(CN),
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {				
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:25}});
									editWindow.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='RepCode') message='������ڿ��Ѿ�����!';
								  Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
        	}
        	else{
						Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ�����ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}             
	    	}
    	},
    	{
			text: 'ȡ��',
        handler: function(){editWindow.close();}
      }]
    });
    editWindow.show();
};

////////////////////ɾ������///////////////////
delFun = function() {
    var rowObj = itemGrid.getSelectionModel().getSelections();     // get the selected items
    var len = rowObj.length;
    if(len > 0)
    {
    	Ext.MessageBox.confirm('��ʾ', 
    	    'ȷ��Ҫɾ��ѡ������?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {	
				        for(var i = 0; i < len; i++){     		
					          Ext.Ajax.request({
					              url: 'herp.srm.srmJournalexe.csp?action=del&rowid='+rowObj[i].get("rowid"),
												waitMsg:'ɾ����...',
						            failure: function(result, request) {
						            		Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
												success: function(result, request) {
														var jsonData = Ext.util.JSON.decode( result.responseText );
						                if (jsonData.success=='true') { 
						                		if (i==len-1) Ext.MessageBox.alert('��ʾ', 'ɾ�����');
											    			itemGrid.load({params:{start:0, limit:25}});
									    			}
									    			else {
									    					var message = "SQLErr: " + jsonData.info;
									    					Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									    			}
												},
					               scope: this
					          });
			        }	
			    }
		    } 
		);	
    }
    else
    {
    	Ext.Msg.show({title:'����',msg:'��ѡ����Ҫɾ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
    }       

};

  itemGrid.addButton('-');
  itemGrid.addButton(addSrmJournalButton);
  itemGrid.addButton('-');
  itemGrid.addButton(editSrmJournalButton);
  itemGrid.addButton('-');
  itemGrid.addButton(delSrmJournalButton);
  
  itemGrid.btnResetHide(); 	//�������ð�ť
  itemGrid.btnDeleteHide(); //����ɾ����ť
  itemGrid.btnPrintHide(); 	//���ش�ӡ��ť
  itemGrid.btnAddHide(); 	//������Ӱ�ť
  itemGrid.btnSaveHide(); 	//���ر��水ť

 
  itemGrid.load({params:{start:0, limit:25}});