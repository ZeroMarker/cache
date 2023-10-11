

EditFun = function() {
	
    var rowObj=itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{	
		var rowid = rowObj[0].get("rowid");
		var SysNO =rowObj[0].get("SysNO");
		var Formula =rowObj[0].get("Formula");
	}
	
//年度
var eYearListDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
eYearListDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : CalcFieldFormulaURL+'?action=yearlist&str='+encodeURIComponent(Ext.getCmp('eYearField').getRawValue()),
						method : 'POST'
					});
		});
var eYearField = new Ext.form.ComboBox({
            id:'eYearField',
			name:'eYearField',
			fieldLabel : '年度',
			width : 180,
			listWidth : 250,
			selectOnFocus : true,
			//allowBlank : false,
			store : eYearListDs,
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
var eSysModListDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
eSysModListDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : FieldCoefficientUrl+'?action=sysmodelist&str='+encodeURIComponent(Ext.getCmp('eSysModListField').getRawValue()),
						method : 'POST'
					});
		});
var eSysModListField = new Ext.form.ComboBox({
            id:'eSysModListField',
			name:'eSysModListField',
			fieldLabel : '系统模块',
			width : 180,
			listWidth : 250,
			selectOnFocus : true,
			//allowBlank : false,
			store : eSysModListDs,
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
		width:180,
		listWidth : 250,
		triggerAction: 'all',
		emptyText:'',
		hidden:true,
		name: 'hiddenField',
		minChars: 1,
		pageSize: 10,
		labelSeparator:'',
		editable:true
	});
	
var eCalculateDescField = new Ext.form.TriggerField({
				fieldLabel : '公式设置',
				// disabled:true,
				editable : false,
				//hidden : true,
				width:180,
				labelSeparator:''
				// emptyText : '公式设置'
				//anchor : '100%'
			});

	eCalculateDescField.onTriggerClick = function() {
		formula(1, this);
	};
 var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 80,
			labelAlign:'right',
			items : [eYearField,eSysModListField, eCalculateDescField]
		});
    //面板加载
    formPanel.on('afterlayout', function(panel, layout) { 
                                                                                             
			this.getForm().loadRecord(rowObj[0]);
			eYearField.setRawValue(rowObj[0].get("Year"));
			eSysModListField.setRawValue(rowObj[0].get("SysNO"));	
			eCalculateDescField.setValue(rowObj[0].get("Formula"));			
    });   
    
	    //定义并初始化保存修改按钮
	    var editButton = new Ext.Toolbar.Button({
				text:'保存',
				iconCls: 'save'
			});                                                                                                                                            //
                    
		        //定义修改按钮响应函数
			    editHandler = function(){
		
		        var rowObj=itemGrid.getSelectionModel().getSelections();
		        var rowid = rowObj[0].get("rowid");          
				var sysno = eSysModListField.getValue();
				var formula = eCalculateDescField.getValue(); 
                var year = eYearField.getValue();
				var codeformula = hiddenField.getValue();
				
				var SysNO=rowObj[0].get("SysNO")
				var Formula=rowObj[0].get("Formula")
				var Year=rowObj[0].get("Year")
				var CodeFormula=rowObj[0].get("CodeFormula")
				//alert(SysNO);
				if(SysNO==sysno){sysno="";}
				if(Formula==formula){formula="";}
				if(Year==year){year="";}
				if(CodeFormula==codeformula){codeformula="";}
				
				if(eYearField.getRawValue()=="")
				{
					Ext.Msg.show({title:'错误',msg:'年度不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				}
				if(eSysModListField.getRawValue()=="")
				{
					Ext.Msg.show({title:'错误',msg:'系统模块不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				}
				if(eCalculateDescField.getRawValue()=="")
				{
					Ext.Msg.show({title:'错误',msg:'计算公式不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				}
					
                Ext.Ajax.request({
				url:CalcFieldFormulaURL+'?action=edit&rowid='+rowid+'&Year='+year+'&SysNO='+encodeURIComponent(sysno)+'&Formula='+encodeURIComponent(formula)+'&CodeFormula='+encodeURIComponent(codeformula),
				
				waitMsg:'保存中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGrid.load({params:{start:0, limit:25}});		
				}
				else
					{
					var message="重复添加";
					if(jsonData.info=='RepSysMod') message="系统模块重复！";
					Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				};
			},
				scope: this
			});
			editwin.close();
		};
		//添加保存修改按钮的监听事件
		editButton.addListener('click',editHandler,false);
	
		//定义并初始化取消修改按钮
		var cancelButton = new Ext.Toolbar.Button({
			text: '关闭',
			iconCls: 'cancel'
		});
	
		//定义取消修改按钮的响应函数
		cancelHandler = function(){
			editwin.close();
		};
	
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//定义并初始化窗口
		var editwin = new Ext.Window({
			title: '修改科研绩效公式',
			iconCls: 'pencil',
			width : 300,
			height : 200,    
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
		//窗口显示
		editwin.show();
	};
