editFun = function() {
	
	
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	
	var rowid="";
	//判断是否选择了要修改的数据
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择修改的的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else{
		var rowid = rowObj[0].get("rowid");
		var bidcode = rowObj[0].get("bidcode");
		var bidyear = rowObj[0].get("bidyear");
		var bidislast = rowObj[0].get("bidislast");
	}	


    var bssmsplitmethStore1 = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['2','历史数据*调节比例'],['3','比例系数']]  
	});
	
	var bssmsplitmethStore1Field = new Ext.form.ComboBox({
		id: 'bssmsplitmethStore1Field',
		fieldLabel: '分解方法',
		allowBlank: false,
		emptyText: '分解方法...',
		store: bssmsplitmethStore1,
		valueNotFoundText:'',
	    displayField: 'keyValue',
	    valueField: 'key',
	    triggerAction: 'all',
	    //emptyText:'选择模块名称...',
	    mode: 'local', //本地模式
	    editable:false,
	    pageSize: 10,
	    minChars: 1,
	    selectOnFocus:true,
	    forceSelection:true,
		anchor: '90%'
	});


	
	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			bssmsplitmethStore1Field
		]
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '修改分解方法',
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
    	text: '保存',
		handler: function() {
      		// check form value
      		var bssmsplitmeth = bssmsplitmethStore1Field.getValue();
		
			
      		//bssmsplitmeth = bssmsplitmeth.trim();

      		if(bssmsplitmeth=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'分解方法为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		
      		
      					
        	//var data = bssmsplitmeth;
//			if (formPanel.form.isValid()) {
      		for(var i = 0; i < len; i++){
      		        
      			
      					
						Ext.Ajax.request({
							url: BudgSchemSplitYearMonthUrl+'?action=edit&&rowid='+rowObj[i].get("rowid")+'&bidcode='+rowObj[i].get("bidcode")+'&bidyear='+rowObj[i].get("bidyear")+'&bidislast='+rowObj[i].get("bidislast")+'&bssmsplitmeth='+bssmsplitmeth,
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						  		itemGrid.load({params:{start:0, limit:25}});
									window.close();
								}
						  	else{
						  		window.close();
						  	}
							},
					  	scope: this
						});
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