copySchemFun = function(dataStore,grid,pagingTool) {
var StratagemTabUrl='dhc.pa.stratagemexe.csp'
var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

cycleDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:StratagemTabUrl+'?action=cycle&searchValue='+Ext.getCmp('cycleField').getRawValue()+'&active=Y',method:'POST'})
});

var cycleField = new Ext.form.ComboBox({
	id: 'cycleField',
	fieldLabel: '来源年度',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: cycleDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择需要复制年度...',
	name: 'cycleField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
	
	/////////////////////////////////////

var newcycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

newcycleDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:StratagemTabUrl+'?action=cycle&searchValue='+Ext.getCmp('cycleField').getRawValue()+'&active=Y',method:'POST'})
});

var newcycleField = new Ext.form.ComboBox({
	id: 'newcycleField',
	fieldLabel: '目的年度',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: newcycleDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择复制到的年度...',
	name: 'newcycleField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
	
	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
	        cycleField,
			newcycleField
			
		]
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '复制方案及其标准',
    width: 320,
    height:150,
    minWidth: 320,
    minHeight: 150,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
    	text: '复制',
		handler: function() {
      		// check form value
      		
			var cycleDr = cycleField.getValue();
			var newcycleDr = newcycleField.getValue();
			
      		cycleDr = cycleDr.trim();
			newcycleDr = newcycleDr.trim();
			
			
			//alert(upschem);
      		//alert(name);
            //alert(data);
			if (formPanel.form.isValid()) {
			
					if(cycleDr =="")
						{
							Ext.Msg.show({title:'提示',msg:'来源年份为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						}
					if(newcycleDr =="")
						{
							Ext.Msg.show({title:'提示',msg:'目的年份为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						}
					    //encodeURIComponent
							Ext.Ajax.request({
							url: 'dhc.pa.schemexe.csp?action=copy&cycleDr='+cycleDr+'&newcycleDr='+newcycleDr,
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'复制成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
									window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='NocurrStragem') message='所选年度没有战略！';
									if(jsonData.info=='NoSchem') message='所选年度没有方案！';
									if(jsonData.info=='NoSchemDetail') message='所选年度没有方案明细！';
									if(jsonData.info=='InsertStragemError') message='复制战略失败！';
									if(jsonData.info=='InsertStragemFlase') message='复制战略失败！';
									if(jsonData.info=='insertSchemError') message='复制方案失败！';
									if(jsonData.info=='insertSchemDetailError') message='复制方案明细失败！';
									if(jsonData.info=='insertAddError') message='复制加扣分标准失败！';
									if(jsonData.info=='insertDistError') message='复制区分法标准失败！';
								 
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