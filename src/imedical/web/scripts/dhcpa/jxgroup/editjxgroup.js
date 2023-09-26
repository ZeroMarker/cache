editFun = function(typeValue,ds,grid,pagingToolbar){
	//定义并初始化行对象
	var rowObj=grid.getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	//判断是否选择了要修改的数据
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}else{
		var rowid = rowObj[0].get("rowid");
		var CodeField = new Ext.form.TextField({
			id:'CodeField',
			fieldLabel: '分组代码',
			allowBlank: false,
			width:150,
			listWidth : 150,
			emptyText:'分组代码...',
			anchor: '90%',
			selectOnFocus:'true',
			name:'code',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(CodeField.getValue()!=""){
							NameField.focus();
						}else{
							Handler = function(){CodeField.focus();}
							Ext.Msg.show({title:'错误',msg:'分组代码不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}




		});
		

		var NameField = new Ext.form.TextField({
			id:'NameField',
			fieldLabel: '分组名称',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'分组名称...',
			anchor: '90%',
			selectOnFocus:'true',
			name:'name',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(NameField.getValue()!=""){
							TYField.focus();
						}else{
							Handler = function(){NameField.focus();}
							Ext.Msg.show({title:'错误',msg:'分组名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}




		});
		
		


		var TypeDs = new Ext.data.SimpleStore({
			fields: ['key','keyValue'],
			data : [['1','1-指标'],['2','2-绩效单元']]
		});
		var TYField = new Ext.form.ComboBox({
			id: 'TYField',
			fieldLabel: '分组类别',
			selectOnFocus: true,
			allowBlank: false,
			store: TypeDs,
			anchor: '90%',
			valueNotFoundText:rowObj[0].get("typeName"),
			displayField: 'keyValue',
			valueField: 'key',
			triggerAction: 'all',
			emptyText:'选择分组类别...',
			mode: 'local', //本地模式
			editable:false,
			pageSize: 10,
			minChars: 1,
			selectOnFocus: true,
			forceSelection: true,
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(TYField.getValue()!=""){
							IsInputField.focus();
						}else{
							Handler = function(){TYField.focus();}
							Ext.Msg.show({title:'错误',msg:'分组类别不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}




		});
		

		IDSet = new Ext.form.TextArea({
			id:'IDSet',
			width:355,
			height:60,
			labelWidth:20,
			fieldLabel: '指标或绩效单元',
			readOnly:true,
			name:'NameStr',
			itemCls:'sex-female', //向左浮动,处理控件横排
			clearCls:'allow-float' //允许两边浮动
		});
		

		var editbutton = new Ext.Toolbar.Button({
			text:'编辑',
			itemCls:'age-field',
			handler:function(){
				var type=Ext.getCmp('TYField').getValue();
				selection(type);
			}

		});
		
		var IsInputDs = new Ext.data.SimpleStore({
            fields: ['key','keyValue'],
            data : [['0','是'],['1','否']]
       });





		 var IsInputField = new Ext.form.ComboBox({
			id:'IsInputField',
			 width : 180,
            listWidth : 180,
            fieldLabel:'是否录入',
            selectOnFocus: true,
            allowBlank: false,
            store: IsInputDs,
            emptyText:'是否录入...',
            anchor: '90%',
			value:'1', //默认值
            valueNotFoundText : '否',
            displayField: 'keyValue',
            valueField: 'key',
            triggerAction: 'all',
            mode: 'local', //本地模式
            editable:false,
            pageSize: 10,
            minChars: 1,
            itemCls:'sex-male', //向左浮动,处理控件横排
            clearCls:'allow-float', //允许两边浮动
            selectOnFocus: true,
            forceSelection: true,
	
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(isInputField.getValue()!=""){
                            descField.focus();
                        }else{
                            Handler = function(){isInputField.focus();}
                            Ext.Msg.show({title:'错误',msg:'是否录入不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
                        }
					}
				}
			}




		});
		
		


		var DescField = new Ext.form.TextField({
			id:'DescField',
			fieldLabel: '分组描述',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'分组描述...',
			anchor: '90%',
			selectOnFocus:'true',
			name:'desc',
			itemCls:'sex-male', //向左浮动,处理控件横排
            clearCls:'allow-float' ,//允许两边浮动

			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}



		});
		//定义并初始化面板
		var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			items: [
				CodeField,
				NameField,
				TYField,
				IDSet,
				editbutton,
				IsInputField,
				DescField
			]

		});
	

		//面板加载
		formPanel.on('afterlayout', function(panel, layout){
			this.getForm().loadRecord(rowObj[0]);
			TYField.setValue(rowObj[0].get("type"));
			//IDSet.setValue(rowObj[0].get("IDSet"));
			idSet=rowObj[0].get("IDSet");
		});
		

		//定义并初始化保存修改按钮
		var editButton = new Ext.Toolbar.Button({
			text:'保存修改'
		});
	

		//定义修改按钮响应函数
		editHandler = function(){
			var code = CodeField.getValue();
			var name = NameField.getValue();
			var type = Ext.getCmp('TYField').getValue();
			var IDSet="";
			if(type==1){
				IDSet=KPIDrStr;
			}else{
				IDSet=deptIDStr;
			}

			var isInput = Ext.getCmp('IsInputField').getValue();//是否录入
			var desc = DescField.getValue();
			

			code = trim(code);
			if(code==""){
				Ext.Msg.show({title:'错误',msg:'分组代码为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			name = trim(name);
			if(name==""){
				Ext.Msg.show({title:'错误',msg:'分组名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			type = trim(type);
			if(type==""){
				Ext.Msg.show({title:'错误',msg:'分组类别为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			var data = code+"^"+name+"^"+IDSet+"^"+isInput+"^"+type+"^"+desc;
			

			data = trim(data);
			if(data==""){
				Ext.Msg.show({title:'错误',msg:'数据为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			

			Ext.Ajax.request({
				url: '../csp/dhc.pa.jxgroupexe.csp?action=edit&rowid='+rowid+'&data='+data,
				waitMsg:'保存中...',
				failure: function(result, request){
					Handler = function(){codeField.focus();}
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},

				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'注意',msg:'修改成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						ds.load({params:{start:0,limit:pagingToolbar.pageSize,type:typeValue}});
						editwin.close();
					}else{
						if(jsonData.info=='RepCode'){
							Handler = function(){CodeField.focus();}
							Ext.Msg.show({title:'错误',msg:'分组代码已经存在!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}

						if(jsonData.info=='RepName'){
							Handler = function(){NameField.focus();}
							Ext.Msg.show({title:'错误',msg:'分组名称已经存在!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				},



				scope: this
			});
		}
	


		//添加保存修改按钮的监听事件
		editButton.addListener('click',editHandler,false);
	

		//定义并初始化取消修改按钮
		var cancelButton = new Ext.Toolbar.Button({
			text:'取消修改'
		});
	

		//定义取消修改按钮的响应函数
		cancelHandler = function(){
			editwin.close();
		}
	


		//添加取消按钮的监听事件
		cancelButton.addListener('click',cancelHandler,false);
	

		//定义并初始化窗口
		var editwin = new Ext.Window({
			title: '修改分组记录',
			width: 580,
			height:300,
			minWidth: 600, 
			minHeight: 300,
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
	}
}