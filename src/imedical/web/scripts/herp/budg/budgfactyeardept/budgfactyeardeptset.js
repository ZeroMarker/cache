setFun = function(data) {
	
	var bfincreaserateField = new Ext.form.NumberField({
			id: 'bfincreaserateField',
			fieldLabel: '增长比例%',
			allowBlank: false,
			emptyText: '增长比例%...',
			anchor: '90%'
		});


	var formPanel = new Ext.form.FormPanel({
	  	baseCls: 'x-plain',
	    labelWidth: 80,
	    items: [
				bfincreaserateField
			]
		});



	var window = new Ext.Window({
	  	title: '修改增长比例',
	    width: 250,
	    height:110,
	    minWidth: 250,
	    minHeight: 100,
	    layout: 'fit',
	    plain:true,
	    modal:true,
	    bodyStyle:'padding:5px;',
	    buttonAlign:'center',
	    items: formPanel,
	    buttons: [{
	    	text: '保存',
			handler: function() {
	      		var bfincreaserate = bfincreaserateField.getValue();
	   	    	//bfincreaserate = bfincreaserate.trim();
	      		if(bfincreaserate ==="")
	      		{
	      			Ext.Msg.show({title:'错误',msg:'增长比例为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	      			return;
	      		}else{		      		
		      			data=data+"^"+bfincreaserate
						Ext.Ajax.request({
									url: BudgFactYearDeptUrl+'?action=tyedit&data='+data,
									failure: function(result, request) {
										Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									},
									success: function(result, request) {
										var jsonData = Ext.util.JSON.decode( result.responseText );
									  	if (jsonData.success=='true') {
									  		Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										}else{
									  		var msg='修改失败!'+'SQLError:'+jsonData.info;
									  		Ext.Msg.show({title:'注意',msg:msg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										}
										itemGrid.load({params:{start:0, limit:25}});
										window.close();

						},
						scope: this
						});
				} 
	    	}
	    },{
			text: '取消',
		    handler: function(){window.close();}
	    }]
	});

	window.show();
};