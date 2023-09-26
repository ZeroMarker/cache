

kpischemEditFun = function() {
	
    var rowObj=itemGrid.getSelectionModel().getSelections();
    
	var len = rowObj.length;
//	console.log(rowObj[0]);
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else if(len>1){
		Ext.Msg.show({title:'错误',msg:'只能修改单条记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		return;
	}else{	
		var rowid = rowObj[0].get("rowid");
		
		var code =rowObj[0].get("code");
		var name =rowObj[0].get("name");
		var shortcut =rowObj[0].get("shortcut");
		var frequency =rowObj[0].get("frequency");
		var desc =rowObj[0].get("desc");
		
	}
	

	var uCodeField = new Ext.form.TextField({
		id: 'uCodeField',
		fieldLabel: '编号',
		anchor: '90%',
		//width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'uCodeField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	
	var uNameField = new Ext.form.TextField({
		id: 'uNameField',
		fieldLabel: '名称',
		anchor: '90%',
		//width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'uNameField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	var uShortcutField = new Ext.form.TextField({
		id: 'uShortcutField',
		fieldLabel: '缩写',
		anchor: '90%',
		//width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'uShortcutField',
		minChars: 1,
		pageSize: 10,
		editable:true
		
	});
	var uFrequencyField = new Ext.form.ComboBox({
			id:'uFrequencyField',
			fieldLabel: '考核频率',
			anchor: '90%',
			editable:false,
			valueField: 'rowid',
			displayField:'name',
			name:'',
			mode:'local',
			valueNotFoundText:rowObj[0].get('periodTypeName'),
			triggerAction:'all',
			store:new Ext.data.SimpleStore({
				fields:['rowid','name'],
				data:[['M','月'],['Q','季'],['H','半年'],['Y','年']]
			})			
		});
	var uDescField = new Ext.form.TextField({
		id: 'uDescField',
		fieldLabel: '概述',
		anchor: '90%',
		//width:200,
		listWidth : 245,
		triggerAction: 'all',
		emptyText:'',
		name: 'uDescField',
		minChars: 1,
		pageSize: 10,
		editable:true
		
	});
	var isStopField = new Ext.form.Checkbox({  //2016-8-3 add cyl
		id: 'isStop',
		fieldLabel:'是否停用',
		allowBlank: false
	});
 var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 100,
			items : [uCodeField, uNameField,uShortcutField,uFrequencyField,uDescField,isStopField]
		});
				                                                                                            
    //面板加载
    formPanel.on('afterlayout', function(panel, layout) { 
                                                                                              
			this.getForm().loadRecord(rowObj[0]);
			uCodeField.setValue(rowObj[0].get("code"));	
			uNameField.setValue(rowObj[0].get("name"));	
			uShortcutField.setValue(rowObj[0].get("shortcut"));
			uFrequencyField.setValue(rowObj[0].get("frequency"));
			isStopField.setValue(rowObj[0].get("isStop")=="Y"?"on":"");
			uDescField.setValue(rowObj[0].get("desc"));                   
    });   
    
	    //定义并初始化保存修改按钮
	    var editButton = new Ext.Toolbar.Button({
				text:'保存'
			});                                                                                                                                            
                    
		        //定义修改按钮响应函数
			    editHandler = function(){
		
		        var rowObj=itemGrid.getSelectionModel().getSelections();
		        var rowid = rowObj[0].get("rowid");   
		               
				var code = uCodeField.getValue();
				var name = uNameField.getValue(); 
				var shortcut = uShortcutField.getValue();
				var frequency = uFrequencyField.getValue();
				var desc = uDescField.getValue();
				var isStop = (isStopField.getValue()==true)?'Y':'N';
                Ext.Ajax.request({
				url:'dhc.pa.Selfmanageexe.csp?action=editdept&rowid='+rowid+'&code='+code+'&name='+encodeURIComponent(name)+'&shortcut='+encodeURIComponent(shortcut)+'&isStop='+isStop
					+'&frequency='+encodeURIComponent(frequency)+'&desc='+encodeURIComponent(desc),
				
				waitMsg:'保存中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
			   	var jsonInfo=jsonData.info;
			   
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});		
				}
				else
					{
					var message="";
					var infoArr=jsonInfo.split("^");
					for(var i=1,len=infoArr.length;i<len;i++){
						var info=infoArr[i];
						if(info=='isCode') message=message+"编码重复！</br>";
						if(info=='isName') message=message+"名称重复！</br>";
					}
				
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
			width : 400,
			height : 250,    
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
