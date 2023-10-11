

AddFun = function() {
//年度
var aYearListDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
aYearListDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : CalcFieldFormulaURL+'?action=yearlist&str='+encodeURIComponent(Ext.getCmp('aYearField').getRawValue()),
						method : 'POST'
					});
		});
var aYearField = new Ext.form.ComboBox({
            id:'aYearField',
			name:'aYearField',
			fieldLabel : '年度',
			width : 180,
			listWidth : 250,
			selectOnFocus : true,
			//allowBlank : false,
			store : aYearListDs,
			//anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			//mode : 'local', // 本地模式
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:'',
			forceSelection : true
		});

	//系统模块号
var aSysModListDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
aSysModListDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : FieldCoefficientUrl+'?action=sysmodelist&str='+encodeURIComponent(Ext.getCmp('aSysModListField').getRawValue()),
						method : 'POST'
					});
		});
var aSysModListField = new Ext.form.ComboBox({
            id:'aSysModListField',
			name:'aSysModListField',
			fieldLabel : '系统模块',
			width : 180,
			listWidth : 250,
			selectOnFocus : true,
			//allowBlank : false,
			store : aSysModListDs,
			//anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			//mode : 'local', // 本地模式
			editable : true,
			pageSize : 10,
			minChars : 1,
			labelSeparator:'',
			selectOnFocus : true,
			forceSelection : true
		});
	var hiddenField = new Ext.form.TextField({
		id: 'hiddenField',
		fieldLabel: '存储公式',
		width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		hidden:true,
		name: 'hiddenField',
		minChars: 1,
		pageSize: 10,
		labelSeparator:'',
		editable:true
	});
	
	var aCalculateDescField = new Ext.form.TriggerField({
				fieldLabel : '公式设置',
				// disabled:true,
				editable : false,
				//hidden : true,
				width : 180,
				labelSeparator:''
				// emptyText : '公式设置'
				//anchor : '100%'
			});

	aCalculateDescField.onTriggerClick = function() {
		formula(1, this);
		//hiddenField.setValue(formu);
		 Ext.getCmp("hiddenField").setValue(formu);
	};
	
	
	//hiddenField.setValue(formu);
	var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 80,
			labelAlign:'right',
			items : [aYearField,aSysModListField, aCalculateDescField]
		});
	
	var addWin = new Ext.Window({
		    
			title : '新增科研绩效公式',
			iconCls: 'edit_add',
			width : 300,
			height : 200,
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
					var year=aYearField.getValue();
					var sysno= aSysModListField.getValue();
					var formula = aCalculateDescField.getValue();
					var codeformula = hiddenField.getValue();
					
					if(year=="")
					{
						Ext.Msg.show({title:'错误',msg:'年度不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					if(sysno=="")
					{
						Ext.Msg.show({title:'错误',msg:'系统模块不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					if(formula=="")
					{
						Ext.Msg.show({title:'错误',msg:'计算公式不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					
					Ext.Ajax.request({
					url:CalcFieldFormulaURL+'?action=add&Year='+year+'&SysNO='+encodeURIComponent(sysno)+'&Formula='+encodeURIComponent(formula)+'&CodeFormula='+encodeURIComponent(codeformula),
					waitMsg:'保存中...',
					failure: function(result, request){		
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							itemGrid.load({params:{start:0, limit:25}});
						}
						else
						{
							var message="重复添加";
							
							if(jsonData.info=='RepSysMod') message="系统模块重复";
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
				text: '关闭',
				iconCls: 'cancel',
				handler : function() {
					addWin.close();
				}
			}]
		});
		addWin.show();
	};
