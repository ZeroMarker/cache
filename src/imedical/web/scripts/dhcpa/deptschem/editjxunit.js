editJXUnitFun = function(schemGrid,jxUnitDs,jxUnitGrid,pagingToolbar){
	var rowObj = jxUnitGrid.getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的基本数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}else{
		var userCode = session['LOGON.USERCODE'];
	
		var UnitDs = new Ext.data.Store({
			autoLoad:true,
			proxy:"",
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['jxUnitDr','jxUnitCode','jxUnitName','jxLocTypeName'])
		});

		UnitDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
				url:'../csp/dhc.pa.deptschemexe.csp?action=jxunit&userCode='+userCode+'&str='+Ext.getCmp('UnitField').getRawValue(),method:'POST'})
		});

		var UnitField = new Ext.form.ComboBox({
			id: 'UnitField',
			fieldLabel: '绩效单元',
			width:230,
			listWidth : 230,
			allowBlank: false,
			store: UnitDs,
			valueField: 'jxUnitDr',
			displayField: 'jxUnitName',
			triggerAction: 'all',
			emptyText:'请选择绩效单元...',
			valueNotFoundText:rowObj[0].get("parRefName"),
			name: 'UnitField',
			minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true
		});
		//UnitDs.load({params:{start:0, limit:UnitField.pageSize}});
		var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth:60,
			items: [
				UnitField
			]
		});
		
		formPanel.on('afterlayout', function(panel,layout) {
			this.getForm().loadRecord(rowObj[0]);
			UnitField.setValue(rowObj[0].get("parRef"));
			
		});	
		
		var editButton = new Ext.Toolbar.Button({
			text:'修改'
		});
				
		//添加处理函数
		var editHandler = function(){
			var jxunitdr = Ext.getCmp('UnitField').getValue();
			jxunitdr = trim(jxunitdr);
			if(jxunitdr==""){
				Ext.Msg.show({title:'提示',msg:'绩效单元为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			var schemDr=schemGrid.getSelections()[0].get("rowid");
			schemDr = trim(schemDr);
			if(schemDr==""){
				Ext.Msg.show({title:'提示',msg:'绩效方案为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			Ext.Ajax.request({
				url:'../csp/dhc.pa.deptschemexe.csp?action=edit&schemDr='+schemDr+'&jxunitdr='+jxunitdr+'&rowid='+rowObj[0].get("rowid"),
				waitMsg:'修改中..',
				failure: function(result, request){
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'提示',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						jxUnitDs.load({params:{start:pagingToolbar.cursor, limit:pagingToolbar.pageSize,schemDr:schemGrid.getSelections()[0].get("rowid"),dir:'asc',sort:'rowid'}});
						win.close();
					}else{
						var message = "";
						message = "SQLErr: " + jsonData.info;
						if(jsonData.info=='RepRecode'){
							Handler = function(){UnitField.focus();}
							Ext.Msg.show({title:'提示',msg:'数据记录重复!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
						if(jsonData.info=='rowidEmpt'){
							Handler = function(){UnitField.focus();}
							Ext.Msg.show({title:'提示',msg:'错误数据,请检查!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
						
							Ext.Msg.show({title:'错误',msg:'修改失败!',icon:Ext.MessageBox.ERROR,buttons:Ext.Msg.OK,msg:message});
					
						
					}
				},
				scope: this
			});
		}

		//添加按钮的响应事件
		editButton.addListener('click',editHandler,false);

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
			title: '修改绩效单元',
			width: 380,
			height:120,
			minWidth: 380,
			minHeight: 120,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				editButton,
				cancelButton
			]
		});
		win.show();	
	}
}