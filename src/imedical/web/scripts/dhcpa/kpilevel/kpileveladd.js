var addKPILvelFun = function(dataStore,grid,pagingTool) {
	
	
	var kpicomDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['KPIDr','shortCut'])
	});

	kpicomDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:KPILvelUrl+'?action=kpi&str='+Ext.getCmp('kpicom').getRawValue(),method:'POST'})
	});

	var kpicom = new Ext.form.ComboBox({
		id:'kpicom',
		fieldLabel:'KPI 指标',
		width:250,
		listWidth : 250,
		allowBlank:true,
		store:kpicomDs,
		valueField:'KPIDr',
		displayField:'shortCut',
		triggerAction:'all',
		emptyText:'',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:false,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(kpicom.getValue()!=""){
						actualValueField.focus();
					}else{
						Handler = function(){kpicom.focus();}
						Ext.Msg.show({title:'错误',msg:'KPI 指标不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});

	var LevelDs = new Ext.data.Store({
			proxy:'',
			reader: new Ext.data.JsonReader({
				root: 'rows',
				totalProperty: 'results'
			}, [
					'scoreLevel','shortCut'
		 
				]),
			remoteSort: true
		});
LevelDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:KPILvelUrl+'?action=level&start=0&limit=999'});
});

var LevelField = new Ext.ux.form.LovCombo({
	id: 'LevelField',
	fieldLabel: '结果指标',
	width:250,
	listWidth : 250,
	//allowBlank: false,
	store: LevelDs,
	valueField: 'scoreLevel',
	displayField: 'shortCut',
	triggerAction: 'all',
	emptyText:'请选择指标...',
	name: 'LevelField',
	minChars: 1,
	//pageSize: 10,
	//selectOnFocus:true,
	//forceSelection:true,
	editable:false
});	

	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			kpicom,
            LevelField
		]
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '添加等级表',
    width: 400,
    height:200,
    minWidth: 400,
    minHeight: 200,
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
      		var code = kpicom.getValue();
      		var name = LevelField.getValue();
			
      		code = code.trim();
      		name = name.trim();
		
      		if(code=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'指标不能为空为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(name=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'等级为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
        	var data = code+'^'+name;
			if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: KPILvelUrl+'?action=add&data='+data,
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
									//window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyRecData') message='输入的数据为空!';
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