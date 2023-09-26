
editProjFun = function(dataStore,grid) {
	
   	//定义并初始化行对象
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	//判断是否选择了要修改的数据
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		
		var rowid = rowObj[0].get("rowid");
		var linker = rowObj[0].get("linker");
	}
			
	var nameDs = new Ext.data.Store({   //解析数据源
           
				proxy: "",
				reader: new Ext.data.JsonReader({
					totalProperty: 'results',
					root: 'rows'	
				},['Rowid','name']),
				remoteSort: true	
	});	

	nameDs.on('beforeload',function(ds,o){  //数据源监听函数调用后台类方法查询数据
    
	ds.proxy = new Ext.data.HttpProxy({
		url:'dhc.qm.checkpointmakeexe.csp'+'?action=listcheckproj&fuzzyquery='+encodeURIComponent(Ext.getCmp('linkerField').getRawValue()),method:'POST'
	 });	
   });	

   var rowObj=itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{	

		var rowid = rowObj[0].get("rowid");
		var code =rowObj[0].get("schemcode");
		var name =rowObj[0].get("schemname");
		var linker =rowObj[0].get("linker");

	}
	var rowField = new Ext.form.TextField({
		id: 'rowid',
		fieldLabel: 'ID',
		width:220,
		listWidth : 220,
		triggerAction: 'all',
		emptyText:'',
		//name: 'CodeField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	var CodeField = new Ext.form.TextField({
		id: 'CodeField',
		fieldLabel: '编码',
		width:260,
		listWidth : 300,
		triggerAction: 'all',
		emptyText:'',
		//name: 'CodeField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	var NameField = new Ext.form.TextField({
		id: 'NameField',
		fieldLabel: '名称',
		width:260,
		listWidth : 300,
		triggerAction: 'all',
		emptyText:'',
		//name: 'NameField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	var linkerField = new Ext.form.ComboBox({
		id: 'linkerField',
		fieldLabel: '关联医嘱',
		width:260,
		listWidth : 300,
		allowBlank: false,
		store: nameDs,
		valueField: 'Rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择医嘱...',
		//name: 'linkerField',
		minChars: 1,
		pageSize: 500,
		selectOnFocus:true,
		forceSelection:'true',
		//showSelectAll :false,
		//typeAhead : true
		editable:true
					
	});
	
	var eChkUserGrid = new Ext.grid.GridPanel({
		id:'eChkUserGrid',
        store: new Ext.data.Store({
        autoLoad:true,
		proxy: new Ext.data.HttpProxy({
		url:'dhc.qm.checkpointmakeexe.csp'+'?action=listleftedit&start='+0+'&limit='+25+'&rowid='+rowid,
		method:'POST'}),
	    reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['Rowid','name'])

    }),
    colModel: new Ext.grid.ColumnModel({
        defaults: {
            width: 300,
            sortable: true
        },
        columns: [
            {id: 'Rowid', header: '医嘱ID', width: 129, sortable: true, dataIndex: 'Rowid',hidden:true},
            {header: '医嘱名称', dataIndex: 'name',align:'center',width: 300}
        ]
    }),
    sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
    width: 330,
    height: 130
	//plugins:[rowEditing]
	//tbar:[{text:'添加',handler:function(){var data=[{'rowid':'4','Name':'InventorName'}];store.loadData(data,true);}}]
});
///////////////添加多个医嘱按钮////////////////
var addeParticipants  = new Ext.Button({
		text: '添加关联医嘱',
		handler: function(){
			var ChkUserId;
			var id = Ext.getCmp('linkerField').getValue();
			var ChkName = Ext.getCmp('linkerField').getRawValue();
			//alert("id:"+id);
			var ptotal = eChkUserGrid.getStore().getCount();
			if(ptotal>0){	
				for(var i=0;i<ptotal;i++){
					var erow = eChkUserGrid.getStore().getAt(i).get('Rowid');
					if(id!=""){
						if(id==erow){
							Ext.Msg.show({title:'错误',msg:'您选择了相同项!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							return;
						}
						else{
						    ChkUserId=id;
						}
					}else{
						Ext.Msg.show({title:'提示',msg:'请选择您要添加的医嘱!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}	
				}
			}else{
				if(id==""){
					Ext.Msg.show({title:'提示',msg:'请选择要添加的医嘱!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}
				else{		
						ChkUserId=id;	
				}	
			}
			var data = new Ext.data.Record({'Rowid':ChkUserId,'name':ChkName});
			eChkUserGrid.stopEditing(); 
			eChkUserGrid.getStore().insert(0,data);
		}
	});	
var deleParticipants = new Ext.Button({
		text:'删除关联医嘱',
		handler: function() {  
			var rows = eChkUserGrid.getSelectionModel().getSelections();
			var length = rows.length;
			//alert(rowObj[0].get("remark"));
			if(length < 1)
			{
				Ext.Msg.show({title:'注意',msg:'请选择需要删除的医嘱!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			else
			{
				var rRowid = eChkUserGrid.getStore().indexOf(rows[0]); //获得行号，而不是rowid
				eChkUserGrid.getStore().removeAt(rRowid);//移除所选中的一行
			}		
		}
	});
	
var colItems =[{
						layout: 'column',
						border: false,
						defaults: {
							columnWidth: '1',
							bodyStyle:'padding:5px 5px 0',
							border: false
						},            
						items: [{
							 xtype: 'fieldset',
							 autoHeight: true,
							 items: [
							 //rowField,
							 CodeField,
							 NameField,
							 eChkUserGrid,
					         linkerField,
					        {
						         columnWidth : 1,
						         xtype : 'panel',
						         layout : "column",
						         items : [
						         {
							       xtype : 'displayfield',
							       columnWidth : .05
							     },
							     addeParticipants,
							     {
							       xtype : 'displayfield',
							       columnWidth : .07
							     },
							    deleParticipants
					            ]							    
						    }				 
								]
							 }]
				}]		

var formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				labelWidth: 60,
				//layout: 'form',
				frame: true,
				items:colItems
				//items: [CodeField,NameField,eChkUserGrid,linkerField,addeParticipants,deleParticipants]
		        //items:	[CodeField,NameField,eChkUserGrid, linkerField,{ items: [ {xtype : 'displayfield', columnWidth : .05,align:'left'},addeParticipants,{ xtype : 'displayfield',columnWidth : .07,align:'right' },deleParticipants]}] 
							       
			});
		                                                                                           //
    //面板加载
    formPanel.on('afterlayout', function(panel, layout) { 
     
	    
			//this.getForm().loadRecord(rowObj[0]);
			CodeField.setValue(rowObj[0].get("schemcode"));	
			NameField.setValue(rowObj[0].get("schemname"));
			//linkerField.setValue(rowObj[0].get("linker")); 	
	 }); 		
    //var euser="";
	    //定义并初始化保存修改按钮
	    var editButton = new Ext.Toolbar.Button({
				text:'保存'
			});                                                                                                                                            //
                    
		        //定义修改按钮响应函数
			    editHandler = function(){
		
		        var rowObj=itemGrid.getSelectionModel().getSelections();
		        var rowId = rowObj[0].get("rowid");          
				var code = CodeField.getValue();
				var name = NameField.getValue(); 
                //var edesc = linkerField.getValue();
				
			var utotal = eChkUserGrid.getStore().getCount();
			//alert(utotal);
			if(utotal>0){
				urawValue = eChkUserGrid.getStore().getAt(0).get('Rowid');
				//alert(urawValue);
				for(var i=1;i<utotal;i++){
				  var urow = eChkUserGrid.getStore().getAt(i).get('Rowid');//每行对象rowid的值
				  urawValue = urawValue+","+urow;
				};
			}
			var RelyUnit = urawValue;
			//alert(RelyUnit);
          
                Ext.Ajax.request({
				url:'dhc.qm.checkpointmakeexe.csp?action=editproj&rowid='+rowId+'&schemcode='+code
				+'&schemname='+encodeURIComponent(name)+'&linker='+RelyUnit,
				
				waitMsg:'保存中...',
				failure: function(result, request) {
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGridDs.load({params:{start:0, limit:25}});		
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
			width : 400,
			height : 340,    
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
