
var itemGrid = new dhc.herp.Grid({
        title: '期刊定义',
        width: 400,
        //edit:false,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'herp.srm.srmJournalexe.csp',	  
		//tbar:delButton,
		atLoad : true, // 是否自动刷新
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
            header: '期刊ISSN码',
			allowBlank: false,
			width:150,
			editable:false,
            dataIndex: 'SN'
        },{
            id:'CN',
            header: '期刊CN码',
			allowBlank: false,
			width:150,
			editable:false,
            dataIndex: 'CN'
        },{
            id:'Name',
            header: '期刊名称',
			allowBlank: false,
			width:150,
			editable:false,
            dataIndex: 'Name'
        },{
           id:'IsValid',
            header: '是否有效',
			width:200,
			editable:false,
            dataIndex: 'IsValid',
            hidden: true
        }] 
});

///////////////////添加按钮///////////////////////
var addSrmJournalButton = new Ext.Toolbar.Button({
		text: '添加',
    	tooltip: '添加新的期刊',        
    	iconCls: 'add',
		handler: function(){addFun();}
});

/////////////////修改按钮/////////////////////////
var editSrmJournalButton  = new Ext.Toolbar.Button({
		text: '修改',        
		tooltip: '修改选定的期刊',
		iconCls: 'option',
		handler: function(){editFun();}
});

////////////////删除按钮//////////////////////////
var delSrmJournalButton  = new Ext.Toolbar.Button({
		text: '删除',        
		tooltip: '删除选定的期刊',
		iconCls: 'remove',
		handler: function(){delFun();}
});

////////////////添加功能/////////////////////////
addFun = function() {

	var SNField = new Ext.form.TextField({
		id:'SNField',
    fieldLabel: '期刊ISSN码',
    allowBlank: false,
    emptyText:'期刊ISSN码...',
    anchor: '95%'
	});
	
	var CNField = new Ext.form.TextField({
		id:'CNField',
    fieldLabel: '期刊CN码',
    allowBlank: false,
    emptyText:'期刊CN码...',
    anchor: '95%'
	});

	var nameField = new Ext.form.TextField({
		id:'nameField',
    fieldLabel: '期刊名称',
    allowBlank: false,
    emptyText:'期刊名称...',
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
  	title: '添加期刊',
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
    	text: '保存', 
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
      			Ext.Msg.show({title:'错误',msg:'期刊ISSN码为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(Name=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'期刊名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(CN=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'期刊CN码为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		
      		
        	if (addFormPanel.form.isValid()) {
						Ext.Ajax.request({
							url: 'herp.srm.srmJournalexe.csp?action=add&SN='+encodeURIComponent(SN)+'&Name='+encodeURIComponent(Name)+'&CN='+encodeURIComponent(CN),
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								  itemGrid.load({params:{start:0, limit:25}});
									//window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='RepCode') message='输入的期刊已经存在!';								
								  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
        	}
        	else{
						Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}             
	    	}
    	},
    	{
				text: '取消',
        handler: function(){addWindow.close();}
      }]
    });

    addWindow.show();
};

/////////////////////修改功能/////////////////////
editFun = function() {
	var rowObj = itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	//alert(rowObj[0].get("remark"));
	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		myRowid = rowObj[0].get("rowid"); 
	}

	var SNField = new Ext.form.TextField({
	id: 'SNField',
    fieldLabel: '期刊ISSN码',
    allowBlank: false,
    emptyText: '期刊ISSN码...',
    name: 'SN',
    anchor: '90%'
	});
	
	var CNField = new Ext.form.TextField({
	id: 'CNField',
    fieldLabel: '期刊CN码',
    allowBlank: false,
    emptyText: '期刊CN码...',
    name: 'CN',
    anchor: '90%'
	});
	
	var nameField = new Ext.form.TextField({
	id: 'nameField',
    fieldLabel: '期刊名称',
    allowBlank: false,
    emptyText: '期刊名称...',
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
  	title: '修改期刊信息',
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
    	text: '保存', 
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
      			Ext.Msg.show({title:'错误',msg:'期刊ISSN为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(CN=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'期刊CN为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(Name=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'期刊名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		  		
        	if (editFormPanel.form.isValid()) {
						Ext.Ajax.request({
							url: 'herp.srm.srmJournalexe.csp?action=edit&rowid='+myRowid+'&SN='+encodeURIComponent(SN)+'&Name='+encodeURIComponent(Name)+'&CN='+encodeURIComponent(CN),
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {				
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:25}});
									editWindow.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='RepCode') message='输入的期刊已经存在!';
								  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
        	}
        	else{
						Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}             
	    	}
    	},
    	{
			text: '取消',
        handler: function(){editWindow.close();}
      }]
    });
    editWindow.show();
};

////////////////////删除功能///////////////////
delFun = function() {
    var rowObj = itemGrid.getSelectionModel().getSelections();     // get the selected items
    var len = rowObj.length;
    if(len > 0)
    {
    	Ext.MessageBox.confirm('提示', 
    	    '确定要删除选定的行?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {	
				        for(var i = 0; i < len; i++){     		
					          Ext.Ajax.request({
					              url: 'herp.srm.srmJournalexe.csp?action=del&rowid='+rowObj[i].get("rowid"),
												waitMsg:'删除中...',
						            failure: function(result, request) {
						            		Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
												},
												success: function(result, request) {
														var jsonData = Ext.util.JSON.decode( result.responseText );
						                if (jsonData.success=='true') { 
						                		if (i==len-1) Ext.MessageBox.alert('提示', '删除完成');
											    			itemGrid.load({params:{start:0, limit:25}});
									    			}
									    			else {
									    					var message = "SQLErr: " + jsonData.info;
									    					Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
    	Ext.Msg.show({title:'错误',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
    }       

};

  itemGrid.addButton('-');
  itemGrid.addButton(addSrmJournalButton);
  itemGrid.addButton('-');
  itemGrid.addButton(editSrmJournalButton);
  itemGrid.addButton('-');
  itemGrid.addButton(delSrmJournalButton);
  
  itemGrid.btnResetHide(); 	//隐藏重置按钮
  itemGrid.btnDeleteHide(); //隐藏删除按钮
  itemGrid.btnPrintHide(); 	//隐藏打印按钮
  itemGrid.btnAddHide(); 	//隐藏添加按钮
  itemGrid.btnSaveHide(); 	//隐藏保存按钮

 
  itemGrid.load({params:{start:0, limit:25}});