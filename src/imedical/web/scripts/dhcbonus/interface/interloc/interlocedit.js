editInterLocFun = function(dataStore,grid,pagingTool) {
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
    
	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	if(interLocSetField.getValue()==""){
	   Ext.Msg.show({title:'提示',msg:'请选择接口套',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	   return false;
	}
	else
	{
		myRowid = rowObj[0].get("rowid");
	}
    var jxUnitDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut'])
	});

	jxUnitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:InterLocUrl+'?action=getjxunit',method:'POST'})
	});

	var jxUnitField = new Ext.form.ComboBox({
		id: 'jxUnitField',
		fieldLabel:'考核单元',
		allowBlank: false,
		store: jxUnitDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'',
		valueNotFoundText:rowObj[0].get('jxUnitName'),
		//name: 'jxUnitField',
		minChars: 1,
		pageSize: 10,
		anchor: '90%',
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
	
	var orderField = new Ext.form.TextField({
		id: 'orderField',
		fieldLabel: '顺序号',
		allowBlank: false,
		emptyText: '',
		anchor: '90%'
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
    
	var patTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['I','住院'],['O','门诊'],['E','急诊']]
	});
	var patTypeField = new Ext.form.ComboBox({
		id: 'patTypeField',
		fieldLabel: '病人类型',
		selectOnFocus: true,
		allowBlank: false,
		store: patTypeStore,
		anchor: '90%',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'选择病人类型...',
		valueNotFoundText:rowObj[0].get('patType'),
		mode: 'local', //本地模式
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	
    var remarkField = new Ext.form.TextField({
            id: 'remarkField',
            fieldLabel: '描述',
            emptyText: '描述...',
            name: 'desc',
            anchor: '90%'
        });


	var tieOffField = new Ext.form.Checkbox({
		id: 'tieOffField',
		fieldLabel:'有效标志',
		disabled:false,
		allowBlank: false,
		checked: (rowObj[0].data['active']) == 'Y' ? true : false
        
	});



	var flagPanel = new Ext.Panel({
			layout: 'column',
			border: false,
			//labelWidth: 80,
			baseCls: 'x-plain',
			defaults: {
				border: false,
				layout: 'form',
				baseCls: 'x-plain',
				//labelSeparator: ':',
				columnWidth: .3
			},
			items: [
				
				{
					items: tieOffField
				}
			]
	});

	// create form panel
	var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			jxUnitField,
			orderField,
			codeField,
            nameField,
			//patTypeField,
			remarkField,
            flagPanel
			
		]
	});
	formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			jxUnitField.setValue(rowObj[0].get("jxUnitDr"));
			orderField.setValue(rowObj[0].get("order"));
			//patTypeField.setValue(rowObj[0].get("Type"));
			remarkField.setValue(rowObj[0].get("remark"));
		});
  
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '修改核算单元',
    width: 380,
    height:320,
    minWidth: 380,
    minHeight: 320,
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
      		var jxUnit = Ext.getCmp('jxUnitField').getValue();
			var order = orderField.getValue();
      		var code = codeField.getValue();
      		var name = nameField.getValue();
			var remark = remarkField.getValue();
		    //var patType = patTypeField.getValue();
			var tieOff = (tieOffField.getValue()==true)?'Y':'N';
			
      		code = code.trim();
      		name = name.trim();
			remark = remark.trim();   
            jxUnit = jxUnit.trim();
			order = order.trim();
			//patType = patType.trim();
    
			var data = code+'^'+name+'^'+order+'^'+jxUnit+'^'+interLocSetField.getValue()+'^'+remark+'^'+tieOff;
            //alert(data);
      		if(code=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'代码为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(name=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
//            if(tieOffField.getValue()==true)
//      		{
////      			codeField.disable();
////                nameField.disable();
////			    startDate.disable();
////			    endDate.disable();
////			    remarkField.disable();
//                Ext.Msg.show({title:'注意',msg:'已扎帐，不能修改数据',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
//      			return;
//      		};
			
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: InterLocUrl+'?action=edit&data='+data+'&rowid='+myRowid,
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