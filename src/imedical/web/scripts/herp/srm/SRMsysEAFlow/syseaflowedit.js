

syseaflowEditFun = function() {
	
    var rowObj=itemGrid.getSelectionModel().getSelections(); //选中行的记录
	var len = rowObj.length; //判断选中多少行
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{	
		var rowid = rowObj[0].get("rowid");
		var tmpTypeID = rowObj[0].get("TypeID");
		var tmpSysModuleID =rowObj[0].get("SysModuleID");
		var tmpEAFMDr =rowObj[0].get("EAFMDr");
	}
//-----------------	
///////////////////类型/////////////////////////////  
var TypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '科研'],['2', '教学']]
	});		
		
var TypeCombox = new Ext.form.ComboBox({
	                   id : 'TypeCombox',
		           fieldLabel : '类型',
	                   width : 200,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : TypeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
		           value:tmpTypeID,
		           selectOnFocus : true,
		           forceSelection : true,
		           labelSeparator:''
						  });	
TypeCombox.on('select',function(combo, record, index){
		 tmpTypeID = combo.getValue();
	});
///////////////////////////////////////////
var SysModuleDs = new Ext.data.Store({
	      autoLoad:true,
	      proxy : "",
	      reader : new Ext.data.JsonReader({
	                 totalProperty : 'results',
	                 root : 'rows'
	              }, ['rowid','name'])  //需跟后台程序中while中获取的字段一样
});


SysModuleDs.on('beforeload', function(ds, o){

	     ds.proxy=new Ext.data.HttpProxy({
	               url: 'herp.srm.syseaflowexe.csp'
	                     + '?action=listSysModule&str='
	                     + encodeURIComponent(Ext.getCmp('SysModuleDsField').getRawValue()),
	               method:'POST'
	              });
	});

var SysModuleDsField = new Ext.form.ComboBox({
		id: 'SysModuleDsField',
		fieldLabel: '系统模块',
		width:200,
		listWidth : 250,
		allowBlank: false,
		store: SysModuleDs,
		displayField: 'name',
		valueField: 'rowid',
		typeAhead : true,
		triggerAction : 'all',
		emptyText : '',
		name: 'SysModuleDsField',
		pageSize: 10,
		minChars: 1,
		forceSelection : true,
		selectOnFocus:true,
	    editable:true,
	    labelSeparator:''
});

SysModuleDsField.on('select',function(combo, record, index){
		 tmpSysModuleID = combo.getValue();
	});

//---------------------
	var EAFMDrDS = new Ext.data.Store({
		      autoLoad:true,
		      proxy : "",
		      reader : new Ext.data.JsonReader({
		                 totalProperty : 'results',
		                 root : 'rows'
		              }, ['rowid','name'])
   });


	EAFMDrDS.on('beforeload', function(ds, o){

		     ds.proxy=new Ext.data.HttpProxy({
		               url: 'herp.srm.syseaflowexe.csp'
		                     + '?action=listEAFMain&str='
		                     + encodeURIComponent(Ext.getCmp('EAFMDrDSField').getRawValue()),
		               method:'POST'
		              });
   	});
   
	var EAFMDrDSField = new Ext.form.ComboBox({
			id: 'EAFMDrDSField',
			fieldLabel: '主审批流',
			width:200,
			listWidth : 250,
			allowBlank: false,
			store: EAFMDrDS,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			emptyText : '',
			name: 'EAFMDrDSField',
			pageSize: 10,
			minChars: 1,
			forceSelection : true,
			selectOnFocus:true,
		    editable:true,
		    labelSeparator:''
	});
	
EAFMDrDSField.on('select',function(combo, record, index){
		 tmpEAFMDr = combo.getValue();
	});
//--------------------------			                                                                                            //
    //点击按钮后的面板加载	
 var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 100,
			labelAlign: 'right',
			items : [TypeCombox,SysModuleDsField,EAFMDrDSField]
		});

     formPanel.on('afterlayout', function(panel, layout) { 
                                                                                             
			this.getForm().loadRecord(rowObj[0]);
			TypeCombox.setRawValue(rowObj[0].get("Type"));	
			SysModuleDsField.setRawValue(rowObj[0].get("SysModuleName"));	
			EAFMDrDSField.setRawValue(rowObj[0].get("EAFMName"));	

			                                                                      
    });   
    
	    //定义并初始化保存修改按钮
 var editButton = new Ext.Toolbar.Button({
				text:'保存',
				iconCls: 'save'
			});                                                                                                                                            //
                    
		 //定义修改按钮响应函数方法
	 editHandler = function(){
		
		        var rowObj=itemGrid.getSelectionModel().getSelections();
		        var rowid = rowObj[0].get("rowid");          
				//var SysModuleID = SysModuleDsField.getValue();
				var SysModuleID =tmpSysModuleID;
				//alert(SysModuleID);
				//var EAFMDr = EAFMDrDSField.getValue(); 
				var EAFMDr = tmpEAFMDr;
		        var Type=tmpTypeID;
                
                Ext.Ajax.request({
				url:'herp.srm.syseaflowexe.csp?action=edit&rowid='+rowid+'&Type='+Type+'&SysModuleID='+SysModuleID
				+'&EAFMDr='+EAFMDr,
				
				waitMsg:'保存中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});		
				}
				else
					{
						var message="同一类型模块只能对应一个审批流！";
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
			text:'关闭',
			iconCls : 'cancel'
		});
	
		//定义取消修改按钮的响应函数
		cancelHandler = function(){
			editwin.close();
		};
	
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//定义并初始化窗口
		var editwin = new Ext.Window({
			title: '修改业务审批流信息',
  			iconCls: 'pencil',
			width : 400,
			height : 180,    
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
