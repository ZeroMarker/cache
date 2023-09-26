addFun = function() {


////////////////////////////////////////////////////

		var userDs = new Ext.data.Store({
			proxy: "",
			reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','desc'])
		});

		userDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({url:'dhc.pa.userschemauditexe.csp?action=user',method:'GET'});
		});
	
		var userCombo = new Ext.form.ComboBox({
			fieldLabel:'用户',
			store: userDs,
			displayField:'name',
			valueField:'rowid',
			typeAhead: true,
			forceSelection: true,
			triggerAction: 'all',
			emptyText:'选择...',
			listWidth : 260,
			pageSize: 10,
			minChars: 1,
			anchor: '90%',
			selectOnFocus:true
			
		});

////////////////////////////////////////////////////
var schemProxy = new Ext.data.HttpProxy({url: 'dhc.pa.userschemauditexe.csp?action=schem&start=0&limit=25'});
		var schemDs = new Ext.data.Store({
			proxy: schemProxy,
			reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','desc'])
		});

		schemDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({url:'dhc.pa.userschemauditexe.csp?action=schem&&schemCombo='+encodeURIComponent(Ext.getCmp('schemCombo').getRawValue()),method:'GET'});
		});
	
		var schemCombo = new Ext.form.ComboBox({
			id: 'schemCombo',
			fieldLabel:'方案',
			store: schemDs,
			displayField:'name',
			valueField:'rowid',
			//typeAhead: true,
			forceSelection: true,
			triggerAction: 'all',
			emptyText:'选择...',
			listWidth : 230,
			pageSize: 10,
			minChars: 1,
			anchor: '90%',
			selectOnFocus:true
			
		});

////////////////////////////////////////////////////



  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			userCombo,
            schemCombo
		
		]
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '添加方案权限用户',
    width: 400,
    height:250,
    minWidth: 400,
    minHeight: 250,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
    	text: '保存',
		handler: function() {
      		
      		var userDr = userCombo.getValue();
      		var schemDr = schemCombo.getValue();

      		

      		if(userDr=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'用户为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(schemDr=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'方案为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
        	
			if (formPanel.form.isValid()) {
			
						Ext.Ajax.request({
							url: '../csp/dhc.pa.userschemauditexe.csp?action=add&user='+userDr+'&schem='+schemDr,
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load();
									//window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									
									if(jsonData.info=='RepCode') message='输入的代码已经存在!';
									if(jsonData.info=='RepName') message='该用户下的方案已经存在!';
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
        handler: function(){window.close();}
      }]
    });

    window.show();
};