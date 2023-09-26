
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
			
			var active = rowObj[0].get("active");
			var checkType =rowObj[0].get("checkType");
			var importType =rowObj[0].get("importType");
			var schemeType =rowObj[0].get("schemeType");
		}
		var rowField = new Ext.form.TextField({
			id: 'rowid',
			fieldLabel: 'ID',
			width:25,
			//listWidth : 220,
			triggerAction: 'all',
			emptyText:'',
			//name: 'CodeField',
			minChars: 1,
			pageSize: 10,
			editable:true
		});
		var CodeField = new Ext.form.TextField({
			id: 'CodeField',
			fieldLabel: '项目编码',
			width:325,
			//listWidth : 300,
			triggerAction: 'all',
			emptyText:'',
			//name: 'CodeField',
			minChars: 1,
			pageSize: 10,
			editable:true
		});
		var NameField = new Ext.form.TextField({
			id: 'NameField',
			fieldLabel: '项目名称',
			width:325,
			//listWidth : 300,
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
			width:305,
			listWidth : 305,
			//allowBlank: false,
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
			url:'dhc.qm.checkpointmakeexe.csp'+'?action=listleftedit&start='+0+'&limit='+99999+'&rowid='+rowid,
			method:'POST'}),
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['Rowid','name'])

			}),
			colModel: new Ext.grid.ColumnModel({
				defaults: {
					width: 50,
					sortable: true
				},
				columns: [
					{id: 'Rowid', header: '医嘱ID', width: 18, sortable: true, dataIndex: 'Rowid',hidden:true},
					{header: '医嘱名称', dataIndex: 'name',align:'center',width: 350}
				]
			}),
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			width: 408,
			height: 130,
			viewConfig:{
				forceFit:true
			}
	
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
		style:'margin-left:5px;padding:0 5px 0 5px;',
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
	//=====================2016-04-11 添加=====================//
	var activeRadioGroup=new Ext.form.RadioGroup({
		name:'activeRadio',
		columns: 4,
		fieldLabel:'项目是否启用',
		items:[{

			boxLabel:'启用',
			inputValue:'Y',
			style:'height:14px;',
			name:'activeRadio'
			
		},{
			boxLabel:'禁用',
			inputValue:'N',
			style:'height:14px;',
			name:'activeRadio'
		}]
	});
	var schemeTypeRadioGroup=new Ext.form.RadioGroup({
		name:'schemeTypeRadio',
		fieldLabel:'项目周期类型',
		columns: 4,
		items:[{
			boxLabel:'月份',
			inputValue:'M',
			style:'height:14px;',
			name:'schemeTypeRadio'
		
		},{
			boxLabel:'季度',
			inputValue:'Q',
			style:'height:14px;',
			name:'schemeTypeRadio'
		},{
			boxLabel:'半年',
			inputValue:'H',
			style:'height:14px;',
			name:'schemeTypeRadio'
			
		},{
			boxLabel:'全年',
			inputValue:'Y',
			style:'height:14px;',
			name:'schemeTypeRadio'
		}]
	});
	var importTypeRadioGroup=new Ext.form.RadioGroup({
		name:'importTypeRadio',
		fieldLabel:'数据来源类型',
		columns: 4,
		items:[{
			boxLabel:'电脑端',
			inputValue:'2',
			style:'height:14px;',
			name:'importTypeRadio'
			
		},{
			boxLabel:'移动端',
			inputValue:'1',
			style:'height:14px;',
			name:'importTypeRadio'
		}]
	});
	var checkTypeRadioGroup=new Ext.form.RadioGroup({
		name:'checkTypeRadio',
		fieldLabel:'项目记录类型',
		columns: 4,
		items:[{
			boxLabel:'不合格记录',
			inputValue:'1',
			style:'height:14px;',
			name:'checkTypeRadio'
			
		},{
			boxLabel:'全部记录',
			inputValue:'2',
			style:'height:14px;',
			name:'checkTypeRadio'
		},{
			boxLabel:'特殊检查点',
			inputValue:'3',
			style:'height:14px;',
			name:'checkTypeRadio'
		}]
	});
	var checkTypeBZ=new Ext.form.DisplayField({
		value:'<span style="color:red;"></span><span style="color:red;">“不合格记录”</span><span style="color:;">表示：一条记录中有一个为否，则整条记录不合格；'+
						'</br><span style="color:red;">“全部记录”&nbsp;&nbsp;&nbsp;</span>表示：导入的数据，均为不合格记录;</br><span style="color:red;">“特殊检查点”</span>表示：记录中满足特殊检查点条件时，为不会更记录。'
	});
	//========================================================//

	var colItems =[
			 CodeField,
			 NameField,
			 activeRadioGroup,
			 importTypeRadioGroup,
			 schemeTypeRadioGroup,
			 checkTypeRadioGroup,
			 {columnWidth : .9,
			 xtype: 'fieldset',
			 layout : "column",
			 title:'提示',
			 items : [
				checkTypeBZ
			 ]},
			 {//关联医嘱
				columnWidth:.9,
				xtype:'fieldset',
				title:'关联医嘱',
				items:[
					linkerField,
					{
					columnWidth : 1,
					xtype : 'panel',
					layout : "column",
					items : [
						addeParticipants,
						deleParticipants
					]
					},
					eChkUserGrid
				]	
				} 
		]


var formPanel = new Ext.form.FormPanel({
				labelWidth:90,
				frame: true,
				items:colItems
			});
		                                                                                           //
    //面板加载
    formPanel.on('afterlayout', function(panel, layout) { 
			//this.getForm().loadRecord(rowObj[0]);
			CodeField.setValue(rowObj[0].get("schemcode"));	
			NameField.setValue(rowObj[0].get("schemname"));
			activeRadioGroup.setValue(active);
			schemeTypeRadioGroup.setValue(schemeType);
			importTypeRadioGroup.setValue(importType);
			checkTypeRadioGroup.setValue(checkType);

	 }); 		
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
		var schemeTypeRadio=formPanel.getForm().findField('schemeTypeRadio').getValue().inputValue;
		var importTypeRadio=formPanel.getForm().findField('importTypeRadio').getValue().inputValue;
		var checkTypeObj=formPanel.getForm().findField('checkTypeRadio').getValue();
		if(checkTypeObj==null || checkTypeObj==""){
			Ext.Msg.show({title:'错误',msg:'请选择项目记录类型!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		}else{
			var checkTypeRadio=formPanel.getForm().findField('checkTypeRadio').getValue().inputValue;
		}
		var activeRadio=formPanel.getForm().findField('activeRadio').getValue().inputValue;
		var utotal = eChkUserGrid.getStore().getCount();
		
		var urawValue="";
		if(utotal>0){
			 urawValue = eChkUserGrid.getStore().getAt(0).get('Rowid');
			//alert(urawValue);
			for(var i=1;i<utotal;i++){
			  var urow = eChkUserGrid.getStore().getAt(i).get('Rowid');//每行对象rowid的值
			  urawValue = urawValue+","+urow;
			}
		}
		var RelyUnit = urawValue;
		
	
			Ext.Ajax.request({
			url:'dhc.qm.checkpointmakeexe.csp?action=editproj&rowid='+rowId+'&schemcode='+code
				+'&schemname='+encodeURIComponent(name)+'&linker='+RelyUnit+'&schemeType='+schemeTypeRadio+'&importType='+importTypeRadio+'&checkType='+checkTypeRadio+'&active='+activeRadio,
			waitMsg:'保存中...',
			failure: function(result, request) {
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				//console.log(jsonData.info);
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGridDs.load({params:{start:0, limit:25}});		
					editwin.close();
				}else{
					/*添加编码重复和名称重复 20160517 cyl add
						jsonData=RefSchemCode^RefSchemName
						*/
						var message = "";
						//先分解jsonData
						var jsonInfo=jsonData.info;
						var errorObj=jsonInfo.split("^");
						for(var i=1;i<errorObj.length;i++){
							var errorStr=errorObj[i];
							if(errorStr=="RefSchemCode"){
								message = message+"项目编码重复！<br/>";
							}else if(errorStr=="RefSchemName"){
								message = message+"项目名称重复！<br/>";
							}else{
								var ti=importTypeRadio==1?'<span style="color:blue">采集或计算</span>':'<span style="color:blue">录入或Excel导入</span>';
								message =message+"请将以下检查点收集方式改为：<br/>&nbsp;&nbsp;&nbsp;&nbsp;"+ti+errorStr;
							}
						}
					//var message="已存在相同记录";
					Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,maxWidth:300});
				}
			},
			scope: this
		});
		
			
		
		//editwin.close();
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
		width : 470,
		height : 555,    
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		resizable:false,
		buttons: [
			editButton,
			cancelButton
		]
	});
	//窗口显示
	
	editwin.show();

};
