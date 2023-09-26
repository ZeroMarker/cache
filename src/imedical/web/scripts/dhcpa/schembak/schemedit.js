editSchemFun = function(dataStore,grid,pagingTool) {
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;

	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		myRowid = rowObj[0].get("rowid");
	}

var monthField = new Ext.form.ComboBox({
			id:'monthField',
			fieldLabel: '考核频率',
			width:230,
			listWidth : 230,
			editable:false,
			name:'frequency',
			valueField: 'rowid',
			displayField:'name',
			mode:'local',
			triggerAction:'all',
			valueNotFoundText:rowObj[0].get('frequency'),
			store:new Ext.data.SimpleStore({
				fields:['rowid','name'],
				data:[['M','月'],['Q','季'],['H','半年'],['Y','年']]
			})			
		});

		var schemFlagField = new Ext.form.ComboBox({
			id:'schemFlagField',
			fieldLabel: '方案类型',
			width:230,
			listWidth : 230,
			editable:false,
			name:'schemFlag',
			valueField: 'rowid',
			displayField:'name',
			mode:'local',
			triggerAction:'all',
			valueNotFoundText:rowObj[0].get('schemFlag'),
			store:new Ext.data.SimpleStore({
				fields:['rowid','name'],
				data:[['Y','调查问卷'],['N','一般方案']]
			})			
		});

var appSysDs = new Ext.data.SimpleStore({
				fields:['rowid','name'],
				data:[['1','全院'],['2','科室'],['3','护理'],['4','医疗'],['5','个人']]
			});		
var appSysField = new Ext.form.ComboBox({
			id:'appSysField',
			fieldLabel: '应用系统号',
			name:'appSysDr',
			editable:false,
			width:230,
			listWidth : 230,
			valueField: 'rowid',
			displayField:'name',
			mode:'local',
			triggerAction:'all',
			forceSelection: true,
			valueNotFoundText:rowObj[0].get('appSysDr'),
			selectOnFocus: true,
			store:appSysDs	
		});

var KPIIndexDs = new Ext.data.Store({
	proxy:KPIIndexProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','name'
 
		]),
    remoteSort: true
});
KPIIndexDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:KPIIndexUrl+'?action=kpi&&start=0&limit=25'});
});

var KPIIndexField = new Ext.form.ComboBox({
	id: 'KPIIndexField',
	fieldLabel: '结果指标',width:230,
			listWidth : 230,
	//allowBlank: false,
	store: KPIIndexDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	valueNotFoundText:rowObj[0].get('KPIName'),
	emptyText:'请选择指标...',
	name: 'KPIName',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

	var codeField = new Ext.form.TextField({
		id: 'codeField',
		fieldLabel: '代码',
		allowBlank: false,
		emptyText: '代码...',
		name: 'code',
		anchor: '90%'
	});

	var nameField = new Ext.form.TextField({
		id: 'nameField',
		fieldLabel: '名称',
		allowBlank: false,
		emptyText: '名称...',
		name: 'name',
		anchor: '90%'
	});


	// create form panel
	var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			codeField,
            nameField,
			monthField,
            appSysField,
			KPIIndexField,
			schemFlagField
		]
	});

	formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			appSysField.setValue(rowObj[0].get("appSys"));
			monthField.setValue(rowObj[0].get("quency"));
			KPIIndexField.setValue(rowObj[0].get("KPIDr"));
			schemFlagField.setValue(rowObj[0].get("schemType"));
			
		});
  
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '修改绩效方案',
    width: 380,
    height:250,
    minWidth: 380,
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
      	// check form value
      		var code = codeField.getValue();
			var name = nameField.getValue();
			var appSys = appSysField.getValue();
			var month = monthField.getValue();
			var kpi = KPIIndexField.getValue();
			var schemFlag= schemFlagField.getValue();
		
		
      		code = code.trim();
			name = name.trim();
      		
        	var data = code+'^'+name+'^'+appSys+'^'+month+'^'+kpi+"^"+schemFlag;
     	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: 'dhc.pa.schemexe.csp?action=edit&data='+encodeURIComponent(data)+'&rowid='+myRowid,
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								    dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
									window.close();
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