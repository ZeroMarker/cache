var userid = session['LOGON.USERID'];



//添加按钮
var addButtons = new Ext.Toolbar.Button({
    text: '添加',
    tooltip:'添加',        
    iconCls:'add',
	handler:function(){
               var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
	        var rowid     = rowObj[0].get("rowid");
		var cField = new Ext.form.TextField({
			id:'cField',
			fieldLabel: '核算科目编码',
			allowBlank: false,
			width:100,
			listWidth : 100,
			emptyText:'核算科目编码...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(cField.getValue()!==""){
							nField.focus();
						}else{
							Handler = function(){cField.focus();};
							Ext.Msg.show({title:'错误',msg:'编号不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var nField = new Ext.form.TextField({
			id:'nField',
			fieldLabel: '核算科目名称',
			allowBlank: false,
			width:100,
			listWidth : 180,
			emptyText:'核算科目名称...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(nField.getValue()!==""){
							aField.focus();
						}else{
							Handler = function(){nField.focus();};
							Ext.Msg.show({title:'错误',msg:'名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		

	var direct = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data : [[1,'是'],[0,'否']]
	});
	var aField = new Ext.form.ComboBox({
		id: 'aField',
		fieldLabel: '是否有效',
		//listWidth : 130,
		selectOnFocus: true,
		allowBlank: false,
		store: direct ,
		anchor: '90%',
		value:1, //默认值
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'系统...',
		mode: 'local', //本地模式
		editable:false,
		selectOnFocus: true,
		forceSelection: true,
		listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
	});

		//初始化面板
		formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 150,
			items: [
				cField,
				nField,
				aField
			]
		});
		
		//初始化添加按钮
		addButton = new Ext.Toolbar.Button({
			text:'添 加'
		});
		
		//定义添加按钮响应函数
		addHandler = function(){
            //alert("wwww")
                         
			var code = cField.getValue();
			var name = nField.getValue();
		        var IsValid = aField.getValue();
                  
			if(code==""){
				Ext.Msg.show({title:'错误',msg:'编码为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
			if(name==""){
				Ext.Msg.show({title:'错误',msg:'名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
                        /*
			if(IsValid==""){
				Ext.Msg.show({title:'错误',msg:'是否有效为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
                         */
			Ext.Ajax.request({
				url: encodeURI('../csp/herp.acct.acctsubjvindicdetail.csp?action=add&code='+code+'&name='+name+'&rowid='+rowid+'&userid='+userid+'&IsValid='+IsValid),
				waitMsg:'保存中...',
				failure: function(result, request){
					Handler = function(){aField.focus();};
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){aField.focus();};
						Ext.Msg.show({title:'注意',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
					
						detailGrid.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
					}
					else
							{
								var message="";

								Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
				},
				scope: this
			});
			addwin.close();
		};
	
		//添加保存按钮的监听事件
		addButton.addListener('click',addHandler,false);
	
		//初始化取消按钮
		cancelButton = new Ext.Toolbar.Button({
			text:'取消'
		});
	
		//定义取消按钮的响应函数
		cancelHandler = function(){
			addwin.close();
		};
	
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//初始化窗口
		addwin = new Ext.Window({
			title: '添加记录',
			width: 400,
			height:200,
			minWidth: 400, 
			minHeight: 200,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				addButton,
				cancelButton
			]
		});
	
		//窗口显示
		addwin.show();

      
	}	
});



//修改按钮
var editButtons = new Ext.Toolbar.Button({
  text: '修改',
    tooltip:'修改',        
    iconCls:'add',
	handler:function(){
               var rowObj=detailGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
		   Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		   return;
		}
                else
               {
                   var rowid     = rowObj[0].get("rowid");
                   var CheckCode = rowObj[0].get("CheckTypeCode");
                   var CheckName = rowObj[0].get("CheckTypeName");
                }
	      
		var cField = new Ext.form.TextField({
			id:'cField',
			fieldLabel: '核算科目编码',
			allowBlank: false,
			width:100,
                        value:CheckCode,
			listWidth : 100,
			emptyText:'核算科目编码...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(cField.getValue()!==""){
							nField.focus();
						}else{
							Handler = function(){cField.focus();};
							Ext.Msg.show({title:'错误',msg:'编号不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var nField = new Ext.form.TextField({
			id:'nField',
			fieldLabel: '核算科目名称',
			allowBlank: false,
			width:100,
                        value:CheckName,
			listWidth : 180,
			emptyText:'核算科目名称...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(nField.getValue()!==""){
							aField.focus();
						}else{
							Handler = function(){nField.focus();};
							Ext.Msg.show({title:'错误',msg:'名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		

	var direct = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data : [[1,'是'],[0,'否']]
	});
	var aField = new Ext.form.ComboBox({
		id: 'aField',
		fieldLabel: '是否有效',
		//listWidth : 130,
		selectOnFocus: true,
		allowBlank: false,
		store: direct ,
		anchor: '90%',
		value:1, //默认值
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'系统...',
		mode: 'local', //本地模式
		editable:false,
		selectOnFocus: true,
		forceSelection: true,
		listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}
	});

		//初始化面板
		formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 150,
			items: [
				cField,
				nField,
				aField
			]
		});
		
		//初始化修改按钮
		addButton = new Ext.Toolbar.Button({
			text:'修改'
		});
		
		//定义修改按钮响应函数
		addHandler = function(){
                        
			var code = cField.getValue();
			var name = nField.getValue();
			var IsValid = aField.getValue();

			if(code==""){
				Ext.Msg.show({title:'错误',msg:'编码为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
			if(name==""){
				Ext.Msg.show({title:'错误',msg:'名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}

			Ext.Ajax.request({
				url: encodeURI('../csp/herp.acct.acctsubjvindicdetail.csp?action=edit&code='+code+'&name='+name+'&rowid='+rowid+'&userid='+userid+'&IsValid='+IsValid),
				waitMsg:'保存中...',
				failure: function(result, request){
					Handler = function(){aField.focus();};
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){aField.focus();};
						Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
					
						detailGrid.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
					}
					else
					{
					 var message="";
                                         Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				},
				scope: this
			});
			addwin.close();
		};
	
		//添加保存按钮的监听事件
		addButton.addListener('click',addHandler,false);
	
		//初始化取消按钮
		cancelButton = new Ext.Toolbar.Button({
			text:'取消'
		});
	
		//定义取消按钮的响应函数
		cancelHandler = function(){
			addwin.close();
		};
	
		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	
		//初始化窗口
		addwin = new Ext.Window({
			title: '添加记录',
			width: 400,
			height:200,
			minWidth: 400, 
			minHeight: 200,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				addButton,
				cancelButton
			]
		});
	
		//窗口显示
		addwin.show();

      
	}	

});




///删除按钮
var delButtons = new Ext.Toolbar.Button({
	text: '删除',
   // tooltip:'删除',       
    id:'delButton', 
    iconCls:'remove',
	handler:function(){
		//定义并初始化行对象
		var rowObj       = itemGrid.getSelectionModel().getSelections();
		var detailrowObj = detailGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = detailrowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			var rowid = rowObj[0].get("rowid");
                        var detailrowid = detailrowObj[0].get("rowid");
		}
		function handler(id){
			if(id=="yes"){
			
				  Ext.each(detailrowObj, function(record) {
				  if (Ext.isEmpty(record.get("rowid"))) {
				  detailGrid.getStore().remove(record);
				  return;}
					Ext.Ajax.request({
						url:'herp.acct.acctsubjvindicdetail.csp?action=del&rowid='+rowid+'&detailrowid='+detailrowid,
						waitMsg:'删除中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
								detailGrid.load({params:{start:0, limit:20,checkmainid:rowid}});
							}else{
								Ext.Msg.show({title:'错误',msg:'删除失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				});
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要删除该条记录吗?',handler);
	}
});

var detailGrid = new dhc.herp.Gridlyf({
        title:'辅助核算项目',
        region: 'east',
        layout:'fit',
        width:300,
        readerModel:'remote',
        url: 'herp.acct.acctsubjvindicdetail.csp',
        tbar:[addButtons,'-',editButtons,'-',delButtons],
		atLoad : true, // 是否自动刷新
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
	    editable:false,
            hidden: true
        },{
            id:'CheckTypeCode',
            header: '核算项目编码',
	    editable:false,
	    hidden:false,
            dataIndex: 'CheckTypeCode'
        
        },{
            id:'CheckTypeName',
            header: '核算项目名称',
	    allowBlank: false,
	    width:170,
	    editable:false,
            dataIndex: 'CheckTypeName'
        }]
  
   });

