addFun = function(store,pagingToolbar){
	var KPIDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['KPIDr','shortCut'])
	});

	KPIDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:KPIProTabUrl+'?action=kpi&str='+Ext.getCmp('KPI').getRawValue()+'&userCode='+userCode,method:'POST'})
	});

	var KPI = new Ext.form.ComboBox({
		id:'KPI',
		fieldLabel:'指标',
		width:213,
		listWidth : 213,
		allowBlank:true,
		store:KPIDs,
		valueField:'KPIDr',
		displayField:'shortCut',
		emptyText:'请选择指标...',
		triggerAction:'all',
		name: 'KPI',
		emptyText:'',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(KPI.getValue()!=""){
						userField.focus();
					}else{
						Handler = function(){KPI.focus();}
						Ext.Msg.show({title:'错误',msg:'指标不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	
	
	formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth:70,
		items: [
			KPI
		]
	});
	
	//定义添加按钮
	var addButton = new Ext.Toolbar.Button({
		text:'添加'
	});
			
	//添加处理函数
	var addHandler = function(){
		var kpidr = Ext.getCmp('KPI').getValue();
		if(kpidr==""){
			Ext.Msg.show({title:'提示',msg:'指标为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		var data = kpidr;
		
		Ext.Ajax.request({
			url:KPIProTabUrl+'?action=add&data='+data,
			waitMsg:'添加中..',
			failure: function(result, request){
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'提示',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					store.load({params:{start:0, limit:pagingToolbar.pageSize,kpidr:kpidr,dir:'asc',sort:'rowid'}});
				}else{
					if(jsonData.info=='RepRecode'){
						Handler = function(){KPI.focus();}
						Ext.Msg.show({title:'提示',msg:'已存有该指标!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
					}
					if(jsonData.info=='dataEmpt'){
						Handler = function(){KPI.focus();}
						Ext.Msg.show({title:'错误',msg:'数据为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			},
			scope: this
		});
	}

	//添加按钮的响应事件
	addButton.addListener('click',addHandler,false);

	//定义取消按钮
	var cancelButton = new Ext.Toolbar.Button({
		text:'取消'
	});

	//取消处理函数
	var cancelHandler = function(){
		win.close();
	}

	//取消按钮的响应事件
	cancelButton.addListener('click',cancelHandler,false);

	var win = new Ext.Window({
		title: '添加平均值指标管理',
		width: 350,
		height:200,
		minWidth: 350,
		minHeight: 200,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [
			addButton,
			cancelButton
		]
	});
	win.show();
}