
SRMSystemModEditFun = function() {
	
   var rowObj=itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{	
		var rowid = rowObj[0].get("Rowid");
		var code =rowObj[0].get("Cyclecode");
		var name =rowObj[0].get("Cyclename");
		var IsValid =rowObj[0].get("Cycleactive");

	}
	

	var CodeField = new Ext.form.TextField({
		id: 'CodeField',
		fieldLabel: '年度代码',
		width:100,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'CodeField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	var NameField = new Ext.form.TextField({
		id: 'NameField',
		fieldLabel: '年度名称',
		width:100,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'NameField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	var uTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['N', '否'], ['Y', '是']]
	});
	var uisStopField = new Ext.form.ComboBox({
	    id : 'uisStopField',
		fieldLabel : '是否有效',
		width : 100,
		listWidth : 245,
		store : uTypeDs,
		value:'Y',
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // 本地模式
		triggerAction: 'all',
		selectOnFocus:true,
		forceSelection : true
	});		
	/*
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
		               url: 'herp.srm.srmuserexe.csp'
		                     + '?action=caltypename&str='
		                     + encodeURIComponent(Ext.getCmp('uTypeField').getRawValue()),
		               method:'POST'
		              });
     	});
     
	var uTypeField = new Ext.form.ComboBox({
			id: 'uTypeField',
			fieldLabel: '用户类型',
			width:200,
			listWidth : 220,
			allowBlank: false,
			store: uTypeDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			triggerAction : 'all',
			emptyText : '',
			name: 'uTypeField',
			pageSize: 10,
			minChars: 1,
			forceSelection : true,
			selectOnFocus:true,
		    editable:true
	});*/
 var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 100,
			items : [CodeField, NameField,uisStopField]
		});
				                                                                                            //
    //面板加载
    formPanel.on('afterlayout', function(panel, layout) { 
                                                                                              //
			this.getForm().loadRecord(rowObj[0]);
			CodeField.setValue(rowObj[0].get("Cyclecode"));	
			NameField.setValue(rowObj[0].get("Cyclename"));
			 	
			//uTypeField.setValue(rowObj[0].get("Type"));
			var Cycleactive = rowObj[0].get("Cycleactive")
			if (Cycleactive=="否")
			{
				Cycleactive='N';
			} 
			else
			{
				Cycleactive='Y';	
			} 
			 uisStopField.setValue(Cycleactive);                                                                      //
    });   
    
	    //定义并初始化保存修改按钮
	    var editButton = new Ext.Toolbar.Button({
				text:'保存'
			});                                                                                                                                            //
                    
		        //定义修改按钮响应函数
			    editHandler = function(){
		
		        var rowObj=itemGrid.getSelectionModel().getSelections();
		        var rowId = rowObj[0].get("Rowid");          
				var code = CodeField.getValue();
				var name = NameField.getValue(); 
				//var type = uTypeField.getValue(); 
                var Cycleactive = uisStopField.getValue();
                Ext.Ajax.request({
				url:'dhc.qm.uCycleexe.csp?action=edit&rowId='+rowId+'&Cyclecode='+code
				+'&Cyclename='+encodeURIComponent(name)+'&Cycleactive='+encodeURIComponent(Cycleactive),
				
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
						var message="已存在相同记录";
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
			text:'取消'
		});
	
		//定义取消修改按钮的响应函数
		cancelHandler = function(){
			editwin.close();
		};
	
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//定义并初始化窗口
		var editwin = new Ext.Window({
			title: '修改记录',
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
