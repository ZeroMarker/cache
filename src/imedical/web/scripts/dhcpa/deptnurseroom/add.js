addFun = function() {


////////////////////////////////////////////////////

		var deptDs = new Ext.data.Store({
			proxy: "",
			reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','desc'])
		});

		deptDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({url:'dhc.pa.deptnurseroomexe.csp?action=dept',method:'GET'});
		});
	
		var deptCombo = new Ext.form.ComboBox({
			fieldLabel:'科室',
			store: deptDs,
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

		var nurseroomDs = new Ext.data.Store({
			proxy: "",
			reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','desc'])
		});

		nurseroomDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({url:'dhc.pa.deptnurseroomexe.csp?action=nurseroom&str='+encodeURIComponent(nurseroomCombo.getRawValue()),method:'GET'});
		});
	
		var nurseroomCombo = new Ext.form.ComboBox({
			fieldLabel:'病区',
			store: nurseroomDs,
			displayField:'name',
			valueField:'rowid',
			typeAhead: true,
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
			deptCombo,
            nurseroomCombo
		
		]
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '科室病区映射关系',
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
      		
      		var deptDr = deptCombo.getValue();
      		var nurseroomDr = nurseroomCombo.getValue();

      		

      		if(deptDr=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'科室为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(nurseroomDr=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'病区为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
        	
			if (formPanel.form.isValid()) {
			
						Ext.Ajax.request({
							url: '../csp/dhc.pa.deptnurseroomexe.csp?action=add&dept='+deptDr+'&nurseroom='+nurseroomDr,
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
									if(jsonData.info=='RepName') message='输入的名称已经存在!';
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