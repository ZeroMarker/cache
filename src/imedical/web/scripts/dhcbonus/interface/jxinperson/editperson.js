editFun = function(jxUnitDr,personDs,personGrid,personPagingToolbar){
	var rowObj = personGrid.getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的内部记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}else{
		var uDs = new Ext.data.Store({
			autoLoad:true,
			proxy:"",
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
		});

		uDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
				url:'dhc.pa.jxinpersonexe.csp?action=user&str='+Ext.getCmp('UserField').getRawValue(),method:'POST'})
		});

		var UserField = new Ext.form.ComboBox({
			id: 'UserField',
			fieldLabel: '内部人员',
			width:213,
			listWidth : 213,
			allowBlank: false,
			store: uDs,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			emptyText:'请选择内部人员...',
			name: 'UserField',
			minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			valueNotFoundText:rowObj[0].get("userName"),
			editable:true,
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(UserField.getValue()!=""){
							RemarkField.focus();
						}else{
							Handler = function(){UserField.focus();}
							Ext.Msg.show({title:'错误',msg:'内部人员不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var RemarkField = new Ext.form.TextField({
			id:'RemarkField',
			fieldLabel: '人员备注',
			allowBlank: true,
			width:150,
			listWidth : 150,
			emptyText:'人员备注...',
			anchor: '90%',
			name:'remark',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						activeField.focus();
					}
				}
			}
		});
	
		var activeField = new Ext.form.Checkbox({
			id: 'activeField',
			labelSeparator: '有效标志:',
			allowBlank: false,
			checked: (rowObj[0].data['active'])=='Y'?true:false,
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						editButton.focus();
					}
				}
			}
		});
		
		var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth:100,
			items: [
				UserField,
				RemarkField,
				activeField
			]
		});
		
		formPanel.on('afterlayout', function(panel,layout) {
			this.getForm().loadRecord(rowObj[0]);
			UserField.setValue(rowObj[0].get('userDr'));
		});	
		
		var editButton = new Ext.Toolbar.Button({
			text:'修改'
		});
				
		//添加处理函数
		var editHandler = function(){
			var userDr = Ext.getCmp('UserField').getValue();
			var remark = Ext.getCmp('RemarkField').getValue();
			var active = (activeField.getValue()==true)?'Y':'N';
			var rowid=rowObj[0].get("rowid");
			Ext.Ajax.request({
				url:'dhc.pa.jxinpersonexe.csp?action=edit&jxUnitDr='+jxUnitDr+'&remark='+remark+'&userDr='+userDr+'&active='+active+'&rowid='+rowid,
				waitMsg:'添加中..',
				failure: function(result, request){
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'提示',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						personDs.load({params:{start:personPagingToolbar.cursor,limit:personPagingToolbar.pageSize,jxUnitDr:jxUnitDr,dir:'asc',sort:'rowid'}});
						win.close();
					}else{
						if(jsonData.info=='RepRecode'){
							Handler = function(){UserField.focus();}
							Ext.Msg.show({title:'提示',msg:'数据记录重复!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
						if(jsonData.info=='rowidEmpt'){
							Handler = function(){UserField.focus();}
							Ext.Msg.show({title:'提示',msg:'错误数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
						}
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
			title: '修改内部人员',
			width: 380,
			height:200,
			minWidth: 380,
			minHeight: 200,
			layout:'fit',
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