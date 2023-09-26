mainAddFun=function(){
	
	var checkAdd=function(formPanel){
	var tmpWrongName=''
	for(i=0;i<formPanel.items.length;i++) {
		//alert(i);
		if(!formPanel.items.items[i].isValid()){
			if(tmpWrongName==''){
				tmpWrongName=formPanel.items.items[i].fieldLabel;
			}else{
				//tmpWrongName=tmpWrongName+','+formPanel.items.items[i].fieldLabel;
			}
		}
	}
	return tmpWrongName
   }
   
  var calcNumField = new Ext.form.TextField({
		id: 'calcNumField',
		name:'calcNum',
		fieldLabel: '测算次数',
		allowBlank: false,
		emptyText: '必填',		
		anchor: '95%'
	}); 
   
 var TemplateDs = new Ext.data.Store({
			proxy:"",
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','templateName'])
	});

 TemplateDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:'../csp/dhc.bonus.rvstemplateexe.csp?action=templatelist&start=0&limit=25'+encodeURIComponent(Ext.getCmp('templateCombo').getRawValue()),
		     method:'POST'
		});
});

 var templateCombo = new Ext.form.ComboBox({
	id: 'templateCombo',
	fieldLabel : '模型名称',
	width : 120,
	selectOnFocus : true,
	store : TemplateDs,
	anchor : '95%',			
	displayField : 'templateName',                                
	valueField : 'rowid',
	triggerAction : 'all',
	emptyText : '',
	//mode : 'local', // 本地模式
	selectOnFocus : true,
	forceSelection : true,
	minChars: 1,
	pageSize: 25
});

var CalcDescField = new Ext.form.TextField({
		id: 'CalcDescField',
		name:'CalcDesc',
		fieldLabel: '测算描述',
		allowBlank: false,
		//emptyText: '必填',		
		anchor: '95%'
	});

 var ItemPriceField = new Ext.form.TextField({
		id: 'ItemPriceField',
		name:'ItemPrice',
		fieldLabel: '分值单价',
		allowBlank: false,
		emptyText: '必填',		
		anchor: '95%'
	}); 

var CalcTotalField = new Ext.form.TextField({
		id: 'CalcTotalField',
		name:'CalcTotal',
		fieldLabel: '分配总额',
		allowBlank: false,
		emptyText: '必填',		
		anchor: '95%'
	}); 

    calcNumField.setValue('');
	templateCombo.setValue('');
	CalcDescField.setValue('');
	ItemPriceField.setValue('');
	CalcTotalField.setValue('');
	
	//初始化面板
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 70,
		items: [
			calcNumField,
			templateCombo,
			CalcDescField,
			ItemPriceField,
			CalcTotalField		
		]
	});

	var addWin = new Ext.Window({
		title: '添加',
		width: 360,
		height: 270,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons:[{
			text:'保存',
			handler: function(){
				if (formPanel.form.isValid()){
					var tmpOperatePerson=session['LOGON.USERCODE'];
					var tmpOperateDate=new Date();
					tmpOperateDate=tmpOperateDate.format('Y-m-d');
					
					tmpData=calcNumField.getValue().trim()+"^"
					        +templateCombo.getValue().trim()+"^"
					        +tmpOperatePerson+"^"
					        +tmpOperateDate+"^"
					        +CalcDescField.getValue().trim()+"^"
					        +ItemPriceField.getValue().trim()+"^"
					        +CalcTotalField.getValue().trim();
					        
					alert(tmpData)
					Ext.Ajax.request({
						url: ModuleCalTabUrl+'?action=mainAdd&data='+tmpData,
						waitMsg:'保存中...',
						failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'操作成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									ModuleCalTabDs.load({
										params:{start:0, limit:ModuleCalTabPagingToolbar.pageSize},
										callback:function(r,o,s){
											new Ext.grid.RowSelectionModel({singleSelect:true}).selectFirstRow();
										}
									});
								}
							},
							scope: this
						});
					}
					else{
						var tmpWrongName=checkAdd(formPanel);
						Ext.Msg.show({title:'错误', msg:tmpWrongName+'不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
			}
		},
		{
			text: '取消',
			handler: function(){addWin.close();}
		}
		]
			
	});

	addWin.show();
	
	
};﻿