

srmdeptuserAddFun = function() {


	var uCodeField = new Ext.form.TextField({
		id: 'uCodeField',
		fieldLabel: '科室编码',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		////emptyText:'',
		name: 'uCodeField',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var uNameField = new Ext.form.TextField({
		id: 'uNameField',
		fieldLabel: '科室名称',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		////emptyText:'',
		name: 'uNameField',
		minChars: 1,
		pageSize: 10,
		editable:true,
		labelSeparator:''
	});
	var uTypeDs = new Ext.data.Store({
		      autoLoad:true,
		      proxy : "",
		      reader : new Ext.data.JsonReader({
		                 totalProperty : 'results',
		                 root : 'rows'
		              }, ['rowid','name'])
     });


	uTypeDs.on('beforeload', function(ds, o){

		     ds.proxy=new Ext.data.HttpProxy({
		               url: 'herp.srm.srmdeptexe.csp'
		                     + '?action=caltypename&str='
		                     + encodeURIComponent(Ext.getCmp('uTypeField').getRawValue()),
		               method:'POST'
		              });
     	});
     
	var uTypeField = new Ext.form.ComboBox({
			id: 'uTypeField',
			fieldLabel: '科室类型',
			width:200,
			listWidth : 225,
			allowBlank: true,
			store: uTypeDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			triggerAction : 'all',
			////emptyText : '',
			name: 'uTypeField',
			//暂时为空
			disabled:true,
			pageSize: 10,
			minChars: 1,
			forceSelection : false,
			selectOnFocus:true,
		    editable:true,
		    labelSeparator:''
	});
/////////////////////是否有效/////////////////////////////
var aIsdriectField = new Ext.form.Checkbox({
                        id:'aIsdriectField',
						name:'aIsdriectField',
						fieldLabel : '是否有效',
						labelSeparator:''
					});

/////////////////////科室级别/////////////////////////////					
var uDeptClassDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '一级科室'], ['2', '二级科室'], ['3', '三级科室'],['4','四级科室']]
	});
	var uDeptClassField = new Ext.form.ComboBox({
	    id : 'uDeptClassField',
		fieldLabel : '科室级别',
		width : 200,
		listWidth : 200,
		store : uDeptClassDs,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // 本地模式
		triggerAction: 'all',
		////emptyText:'请选择...',
		selectOnFocus:true,
		forceSelection : true,
		labelSeparator:''
	});	
/////////////////////上级科室/////////////////////////////					
	var uSuperDeptDs = new Ext.data.Store({
		      autoLoad:true,
		      proxy : "",
		      reader : new Ext.data.JsonReader({
		                 totalProperty : 'results',
		                 root : 'rows'
		              }, ['rowid','name'])
     });

	uSuperDeptDs.on('beforeload', function(ds, o){

		     ds.proxy=new Ext.data.HttpProxy({
		               url: 'herp.srm.srmdeptexe.csp'
		                     + '?action=caldeptname&str='
		                     + encodeURIComponent(Ext.getCmp('uSuperDeptField').getRawValue()),
		               method:'POST'
		              });
     	});
     
	var uSuperDeptField = new Ext.form.ComboBox({
			id: 'uSuperDeptField',
			fieldLabel: '上级科室',
			width:200,
			listWidth : 250,
			allowBlank: true,
			store: uSuperDeptDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			triggerAction : 'all',
			////emptyText : '',
			name: 'uSuperDeptField',
			//暂时为空
			//disabled:true,
			pageSize: 10,
			minChars: 1,
			forceSelection : false,
			selectOnFocus:true,
		    editable:true,
		    labelSeparator:''
	});
	var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 80,
			labelAlign: 'right',
			items : [uCodeField, uNameField,uDeptClassField,uSuperDeptField,aIsdriectField]
		});
	
	var addWin = new Ext.Window({
		    
			title : '新增科室信息',
			iconCls: 'edit_add',
			width : 350,
			height : 210,
			layout : 'fit',
			plain : true,
			modal : true,
			bodyStyle : 'padding:5px;',
			buttonAlign : 'center',
			items : formPanel,
			buttons : [{		 
				text : '保存',
				iconCls: 'save',
				handler : function() {
					if (formPanel.form.isValid()) {
					var code = uCodeField.getValue();
					var name = uNameField.getValue();
					//var type = uTypeField.getValue();
					var type=""
					
					var IsValid = "";
			        if (Ext.getCmp('aIsdriectField').checked) {IsValid="Y";}
			        else { IsValid="N";}
			        var deptclass = uDeptClassField.getValue();
					var superdept = uSuperDeptField.getValue();
					
					if(code=="")
					{
						Ext.Msg.show({title:'错误',msg:'科室代码不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					};
					if(name=="")
					{
						Ext.Msg.show({title:'错误',msg:'科室名称不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					};
					if(IsValid=="")
					{
						Ext.Msg.show({title:'错误',msg:'请选择数据是否有效',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					};
					Ext.Ajax.request({
					url:'herp.srm.srmdeptexe.csp?action=add&code='+encodeURIComponent(code)+'&name='+encodeURIComponent(name)
					+'&type='+type+'&IsValid='+IsValid+'&deptclass='+deptclass+'&superdept='+superdept,
					waitMsg:'保存中...',
					failure: function(result, request){		
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							itemGridDs.load({params:{start:0, limit:25}});
						}
						else
						{
							var message=jsonData.info;
							
							if(jsonData.info=='RecordExist') message="记录重复";
							if(jsonData.info=='RepCode') message="编号重复！";
							if(jsonData.info=='RepName') message="名称重复！";
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this			
				  });
				  addWin.close();
				} 
				}					
			},
			{
				text : '关闭',
				iconCls : 'cancel',
				handler : function() {
					addWin.close();
				}
			}]
		});
		addWin.show();
	};
