//添加函数
addFun = function(node){
	if(node!=null){
		var end = node.attributes.isend;
		if(end=="Y"){
			Ext.Msg.show({title:'提示',msg:'末端不能添加子节点!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
			return false;
		}else{
			//非末端节点,允许添加
			var parentname = node.attributes.name;
			var parentid = node.attributes.id;
			
			var nameField = new Ext.form.TextField({
				id:'nameField',
				fieldLabel: '项目名称',
				allowBlank: false,
				width:150,
				anchor: '90%',
				emptyText:'请填写项目名称...',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(nameField.getValue()!=""){
								codeField.focus();
							}else{
								Handler = function(){nameField.focus();}
								Ext.Msg.show({title:'错误',msg:'项目名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
							}
						}
					}
				}
			});
			
			//生成节点编码code
		    Ext.Ajax.request({			
					url:'../csp/dhc.pa.selfmaintainexe.csp?action=lastcode&parent='+parentid,
					waitMsg:'生成中...',
					failure: function(result, request){
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
							},
					success: function(result, request){
								if(result.responseText==001){
									if(parentid=="roo"){
										codeField.setValue(result.responseText)
									}else{
										codeField.setValue(node.attributes.code+'01');
									}
									
								}else{		
									codeField.setValue(result.responseText);
								}			
							},
							scope: this
						});
			var codeField = new Ext.form.TextField({
				id:'codeField',
				fieldLabel: '项目代码',
				allowBlank: true,
				width:150,
				anchor: '90%',
				emptyText:'请填写项目代码...',
				selectOnFocus:true			
			});
			
			/*var shortcutField = new Ext.form.TextField({
				id:'shortcutField',
				fieldLabel: '快捷键',
				allowBlank: true,
				width:150,
				listWidth : 150,
				emptyText:'',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							typeField.focus();
						}
					}
				}
			});*/
			
			var typeStore = new Ext.data.SimpleStore({
				fields: ['key','keyValue'],
				data : [["1",'多文本描述'],["2",'选项'],["3",'单文本描述']]
			});
			var typeField = new Ext.form.ComboBox({
					id:'typeField',
					fieldLabel : '类型',
					width : 150,
					anchor: '90%',
					selectOnFocus : true,
					allowBlank : false,
					store : typeStore,
					name:'typeField',
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : false,
					//pageSize : 10,
					minChars : 1,
					forceSelection : true
			});
			
			var descField = new Ext.form.TextField({
				id:'descField',
				fieldLabel: '项目描述',
				allowBlank: true,
				width:150,
				anchor: '90%',
				emptyText:'',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							calUnitField.focus();
						}
					}
				}
			});
			
			var calUnitDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
			});

			calUnitDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
					url:'../csp/dhc.pa.selfmaintainexe.csp?action=GetCalUnit',method:'POST'})
			});

			var calUnitField = new Ext.form.ComboBox({
				id: 'calUnitField',
				fieldLabel: '单位',
				width:150,
				anchor: '90%',
				allowBlank: true,
				store: calUnitDs,
				valueField: 'rowid',
				displayField: 'name',
				triggerAction: 'all',
				emptyText:'请选择单位...',
				name: 'calUnitField',
				minChars: 1,
				pageSize: 10,
				selectOnFocus:true,
				forceSelection:'true',
				disabled:true,
				editable:true,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(calUnitField.getValue()!=""){
								levelField.focus();
							}else{
								Handler = function(){calUnitField.focus();}
								Ext.Msg.show({title:'错误',msg:'单位不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
							}
						}
					}
				}
			});

			
			
			var	levelField = new Ext.form.TextField({
				id:'levelField',
				fieldLabel: '层级',
				allowBlank: true,
				width:150,
				anchor: '90%',
				//value:node.attributes.level+1,
				emptyText:'请填写层级...',
				selectOnFocus:'true',
				disabled:true,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							isEndField.focus();
						}
					}
				}
			});
			if(node.attributes.id=="roo"){
				levelField.setValue("0");
			}else{
				levelField.setValue(node.attributes.level-0+1);
			};
			
			var isEndStore = new Ext.data.SimpleStore({
				fields: ['key','keyValue'],
				data : [["Y",'是'],["N",'否']]
			});
			var isEndField = new Ext.form.ComboBox({
				id: 'isEndField',
				fieldLabel: '是否末层',
				width:150,
				anchor: '90%',
				selectOnFocus: true,
				allowBlank: true,
				store: isEndStore,
				value:"", //默认值
				valueNotFoundText:'',
				displayField: 'keyValue',
				valueField: 'key',
				triggerAction: 'all',
				emptyText:'',
				mode: 'local', //本地模式
				editable:false,
				pageSize: 10,
				minChars: 1,
				selectOnFocus: true,
				forceSelection: true,
				listeners:{ 'select':function(){
										if(isEndField.getValue()=="Y"){
											calUnitField.enable(); //只有末层节点才能设置单位
										}
										else {
											calUnitField.setValue("");
											calUnitField.disable();
										}
							}	
				}
			});
			
			
			var parentField = new Ext.form.TextField({
				id:'parentField',
				fieldLabel:'上级项目',
				width:150,
				anchor: '90%',
				disabled:true
			});
			if(node.attributes.id=="roo"){
				parentname="项目管理";
				parentField.setValue(parentname);
			}else{
				parentField.setValue(parentname);
			};
			
			
							
			formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				frame: true,
				labelWidth: 90,
				items: [
					nameField,
					codeField,
					typeField,
					descField,
					calUnitField,
					levelField,
					isEndField,
					parentField	
				]
			});	
			
			
			
			//定义添加按钮
			var addButton = new Ext.Toolbar.Button({
				text:'添加'
			});
			//添加处理函数
			var addHandler = function(){	
				var name = nameField.getValue();
				var code = codeField.getValue();
				//var shortcut = shortcutField.getValue();
				var type = typeField.getValue();
				var desc = descField.getValue();
				var calunit = calUnitField.getValue();
				var level = levelField.getValue();
				var isend = isEndField.getValue();
				var parent = node.attributes.id;
				if(node.attributes.id=="roo"){
					parent = 0;
				}
				if(name==""){
					Ext.Msg.show({title:'错误',msg:'名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
					return false;
				}
				if(code==""){
					Ext.Msg.show({title:'错误',msg:'编码不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
					return false;
				}
				if(isend==""){
					Ext.Msg.show({title:'错误',msg:'是否末层不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
					return false;
				}			
				//var data = encodeURIComponent(name)+"^"+py+"^"+dimTypeDr+"^"+type+"^"+desc+"^"+calUnitDr+"^"+extreMum+"^"+expre+"^"+expreDesc+"^"+colTypeDr+"^"+scoreMethodCode+"^"+colDeptDr+"^"+dataSource+"^"+isHospKPI+"^"+isDeptKPI+"^"+isMedKPI+"^"+isNurKPI+"^"+isPostKPI+"^"+parent+"^"+level+"^"+isStop+"^"+isEnd+"^"+order+"^"+isKPI+"^"+code+"^"+calculation;
				Ext.Ajax.request({
					url:'../csp/dhc.pa.selfmaintainexe.csp?action=add&name='+encodeURIComponent(name)+'&code='+encodeURIComponent(code)+'&type='+encodeURIComponent(type)+'&desc='+encodeURIComponent(desc)+
						'&calunit='+encodeURIComponent(calunit)+'&level='+encodeURIComponent(level)+'&isend='+encodeURIComponent(isend)+'&parent='+encodeURIComponent(parent),
					waitMsg:'添加中..',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'提示',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,width:200});
							Ext.getCmp('detailReport').root.reload();
							//win.close();
						}else{
							if(jsonData.info=='RepName'){
								Handler = function(){nameField.focus();}
								Ext.Msg.show({title:'提示',msg:'名称重复!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:200});
							}
							
							if(jsonData.info=='null'){
								Handler = function(){nameField.focus();}
								Ext.Msg.show({title:'提示',msg:'你以前添加过错误数据,没有上级节点ID!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:400});
							}
						}
						globalStr3="";
					},
					scope: this
				});
			}

			//添加按钮的响应事件
			addButton.addListener('click',addHandler,false);

			//定义取消按钮
			var cancelButton = new Ext.Toolbar.Button({
				text:'取消'
			});

			//取消处理函数
			var cancelHandler = function(){
				win.close();
			}

			//取消按钮的响应事件
			cancelButton.addListener('click',cancelHandler,false);

			var win = new Ext.Window({
				title: '添加',
				width: 400,
				height:400,
				minWidth: 400,
				minHeight: 400,
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
			win.show();
		}
	}else{
		Ext.Msg.show({title:'错误',msg:'请选择要添加子节点的记录!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
	}
};