

SystemInfoEditFun = function() {
	
    var rowObj=SystemMessageGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{	
		var rowid = rowObj[0].get("rowid");
		var title =rowObj[0].get("title");
		var message =rowObj[0].get("message");
		var IsAttachment =rowObj[0].get("IsAttachment");
	}
	

	var eTextField = new Ext.form.TextField({
		id: 'eTextField',
		fieldLabel: '题目',
		width:200,
		allowBlank: false,
		listWidth : 260,
		triggerAction: 'all',
		emptyText:'',
		name: 'eTextField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	var eMessageField = new Ext.form.TextArea({
		id: 'eMessageField',
		fieldLabel: '内容',
		width:200,
		allowBlank: false,
		//listWidth : 260,
		triggerAction: 'all',
		name: 'eMessageField',
		grow: true,
        growMin:60,//显示的高度
        growMax:100//最大的显示高度
	});
	
/////////////////////是否有附件/////////////////////////////
var eIsAttachmentField = new Ext.form.Checkbox({
                        id:'eIsAttachmentField',
						name:'eIsAttachmentField',
						fieldLabel : '是否有附件',
						renderer : function(v, p, record){
        	               p.css += ' x-grid3-check-col-td'; 
        	               return '<div class="x-grid3-check-col'+(v=='1'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}
	});
	
	
	var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 50,
			frame: true,
			//items: colItems
			items : [eTextField,eMessageField,eIsAttachmentField]
		});
				                                                                                            //
    //面板加载
    formPanel.on('afterlayout', function(panel, layout) { 
                                                                                              //
			this.getForm().loadRecord(rowObj[0]);	
			eTextField.setValue(rowObj[0].get("title"));
			eMessageField.setValue(rowObj[0].get("message"));
			if(rowObj[0].get("IsAttachment")=="1"){eIsAttachmentField.setValue(true);}
    });   
    
	    //定义并初始化保存修改按钮
	    var editButton = new Ext.Toolbar.Button({
				text:'保存'
			});                                                                                                                                            //
                    
		        //定义修改按钮响应函数
			    editHandler = function(){
		
		        var rowObj=SystemMessageGrid.getSelectionModel().getSelections();
		        var rowid = rowObj[0].get("rowid");     

				var esysteminfotitle = eTextField.getValue();
				var esysteminfomessage = eMessageField.getValue();
				
				var eIsValid = "";
			    if (Ext.getCmp('eIsAttachmentField').checked) {eIsValid="1";}
			    else { eIsValid="0";}
				
				
				var etitle = rowObj[0].get("title");     
				var emessage = rowObj[0].get("message");     
				var isvalid = rowObj[0].get("IsAttachment"); 
				
				if(esysteminfotitle==etitle){esysteminfotitle="";}
				if(esysteminfomessage==emessage){message="";}
				if(isvalid==eIsValid){eIsValid="";}
				
			  // var data=rowid+"^"+code+"^"+name+"^"+type+"^"+sex+"^"+birthday+"^"+idnum+"^"+titledr+"^"+phone+"^"+email+"^"+degree+"^"+compdr+"^"+monographnum+"^"+papernum+"^"+patentnum+"^"+invincustomstanNum+"^"+trainnum+"^"+holdtrainnum+"^"+intrainingnum
           
                Ext.Ajax.request({
				url:HomePageUrl+'?action=edit&rowid='+rowid+'&title='+encodeURIComponent(esysteminfotitle)
					+'&message='+encodeURIComponent(esysteminfomessage)+'&subuser='+subuser+'&IsAttachment='+encodeURIComponent(eIsValid),
				
				waitMsg:'保存中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					SystemMessageDs.load({params:{start:0, limit:10}});		
				}
				else
					{
					var message="重复添加";
					if(jsonData.info=='RepCode') message="编号重复！";
					if(jsonData.info=='RepName') message="名称重复！";
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
			title: '修改系统消息',
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
