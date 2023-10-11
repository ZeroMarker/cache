//添加函数
addFun = function(node){
	if(node!=null){
		var end = node.attributes.islast;
		if(end=="Y"){
			Ext.Msg.show({title:'提示',msg:'末端不能添加子节点!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
			return false;
		}else{
			//非末端节点,允许添加
			var nameField = new Ext.form.TextField({
				id:'nameField',
				fieldLabel: '科室名称',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'请填写科室名称...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(nameField.getValue()!=""){
								codeField.focus();
							}else{
								Handler = function(){nameField.focus();}
								Ext.Msg.show({title:'错误',msg:'科室名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
							}
						}
					}
				}
			});
			
			var codeField = new Ext.form.TextField({
				id:'codeField',
				fieldLabel: '科室代码',
				allowBlank: true,
				width:180,
				listWidth : 180,
				emptyText:'请填写科室代码...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							pyField.focus();
						}
					}
				}
			});
			
			var pyField = new Ext.form.TextField({
				id:'pyField',
				fieldLabel: '拼 音 码',
				allowBlank: true,
				width:180,
				listWidth : 180,
				emptyText:'请填写拼音码...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							deptcom.focus();
						}
					}
				}
			});
						
					
////////////////////////科室类别//////////////////////////			
			var unitDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
			});
			unitDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
				url:'herp.budg.budgdeptsettreeexe.csp'+'?action=caldept&str='+encodeURIComponent(Ext.getCmp('deptcom').getRawValue()),method:'POST'});
			});
			var deptcom = new Ext.form.ComboBox({
				id: 'deptcom',
				fieldLabel: '科室类别',
				width:200,
				listWidth : 300,
				allowBlank: false,
				store: unitDs,
				valueField: 'rowid',
				displayField: 'name',
				triggerAction: 'all',
				emptyText:'请选择科室类别...',
				anchor: '90%',
				name: 'deptcom',
				minChars: 1,
				pageSize: 10,
				selectOnFocus:true,
				forceSelection:'true',
				editable:true,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							unitusercom.focus();
						}
					}
				}

			});

		
////////////////////////科主任//////////////////////////			
			var unituserDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
			});


			unituserDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
				url:'herp.budg.budgdeptsettreeexe.csp'+'?action=caluser&str='+encodeURIComponent(Ext.getCmp('unitusercom').getRawValue()),method:'POST'});
			});
			var unitusercom = new Ext.form.ComboBox({
				id: 'unitusercom',
				fieldLabel: '科主任',
				width:200,
				listWidth :300,
				allowBlank: false,
				store: unituserDs,
				valueField: 'rowid',
				displayField: 'name',
				triggerAction: 'all',
				emptyText:'请选择科主任名称...',
				anchor: '90%',
				name: 'unitusercom',
				minChars: 1,
				pageSize: 10,
				selectOnFocus:true,
				forceSelection:'true',
				editable:true,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							IOfield.focus();
						}
					}
				}
			});
//////////////////////门诊/住院/////////////////////////
			var IOfield = new Ext.form.TextField({
				id:'IOfield',
				fieldLabel: '门诊/住院',
				allowBlank: true,
				width:180,
				listWidth : 180,
				emptyText:'请填写说明...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							isProjField.focus();
						}
					}
				}
			});			
//////////////////////是否用于项目预算/////////////////////////
			var IsProjStore = new Ext.data.SimpleStore({
						fields : ['key', 'keyValue'],
						data : [['1', '是'], ['0', '否']]
					});
			var isProjField = new Ext.form.ComboBox({
						id : 'isProjField',
						fieldLabel : '参与项目预算',
						width : 200,
						listWidth : 245,
						selectOnFocus : true,
						allowBlank : false,
						store : IsProjStore,
						anchor : '90%',
						// value:'key', //默认值
						valueNotFoundText : '',
						displayField : 'keyValue',
						valueField : 'key',
						triggerAction : 'all',
						emptyText : '',
						mode : 'local', // 本地模式
						editable : false,
						pageSize : 10,
						minChars : 1,
						selectOnFocus : true,
						forceSelection : true
					});	
					
			var isLastField = new Ext.form.Checkbox({												
				fieldLabel: '末级'
			});
					
					
					
/*
//备用--当末端标志为"Y"的时候,才可编辑科主任、科室类别、门诊/住院、是否项目预算

			var isEndField = new Ext.form.Checkbox({
				id: 'isEndField',
				fieldLabel:'末端标志',
				allowBlank: false,
				clearCls:'stop-float',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							orderField.focus();
						}
					},
					'check':function(checked){
                        if(checked.checked){
							//dimTypeField.enable();
							scoreMethodField.enable();
							orderField.enable();
							extreMumField.enable();
							calUnitField.enable();
							colDeptField.enable();
							dataSourceField.enable();
                        }else{
                           // dimTypeField.disable();
							scoreMethodField.disable();
							extreMumField.disable();
							calUnitField.disable();
							colDeptField.disable();
                        }
                    }
				}
			});
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////					
			
			formPanel = new Ext.form.FormPanel({
				baseCls: 'x-plain',
				labelWidth: 80,
				items: [
					nameField,     //名称
					codeField,     //代码
					pyField,  	   //拼音码
					deptcom,       //科室类别
					unitusercom,   //科主任
					IOfield,       //门诊/住院说明
					isProjField,   //是否用于项目预算
					isLastField    //末级
					
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
				var py = pyField.getValue();
				var depttypedr = deptcom.getValue();
				var director = unitusercom.getValue();
				var IOdesc = IOfield.getValue();
				var isproj = isProjField.getValue();
				var islast = (isLastField.getValue()==true)?'1':'0';
				

				var parent = 0;
				var level = 0;
				if(node.attributes.id!="roo"){
					parent = node.attributes.id;
					level = node.attributes.level;
				}
								
				//alert(Ext.getCmp('expreField').getValue());
															
				name = trim(name);
				code = trim(code);
				py = trim(py);
				if(name==""){
					Ext.Msg.show({title:'提示',msg:'科室名称为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
					return false;
				};
				
				if(code==""){					
					Ext.Msg.show({title:'提示',msg:'科室代码为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:150});
					return false;
				};
				
								
				var data = name+"^"+code+"^"+py+"^"+depttypedr+"^"+director+"^"+IOdesc+"^"+isproj+"^"+islast+"^"+parent+"^"+level;
				
				Ext.Ajax.request({
					url:'../csp/herp.budg.budgdeptsettreeexe.csp?action=add&data='+encodeURIComponent(data),
					waitMsg:'添加中..',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'提示',msg:'添加成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,width:200});
							Ext.getCmp('detailReport').getNodeById(node.attributes.id).reload();
						}else{
							if(jsonData.info=='RepName'){
								Handler = function(){nameField.focus();}
								Ext.Msg.show({title:'提示',msg:'名称重复!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:200});
							}
							if(jsonData.info=='dataEmpt'){
								Handler = function(){nameField.focus();}
								Ext.Msg.show({title:'提示',msg:'数据为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:200});
							}
							if(jsonData.info=='ParamErr'){
								Handler = function(){nameField.focus();}
								Ext.Msg.show({title:'提示',msg:'参数数据有错,请修改参数表指标深度!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:400});
							}
							if(jsonData.info=='null'){
								Handler = function(){nameField.focus();}
								Ext.Msg.show({title:'提示',msg:'你以前添加过错误数据,没有上级节点ID!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:400});
							}
							
							if(jsonData.info=='RepCode'){
								Handler = function(){codeField.focus();}
								Ext.Msg.show({title:'提示',msg:'编码重复!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:200});
							}
							if(jsonData.info=='dataEmpt'){
								Handler = function(){codeField.focus();}
								Ext.Msg.show({title:'提示',msg:'编码为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:200});
							}
							if(jsonData.info=='ParamErr'){
								Handler = function(){codeField.focus();}
								Ext.Msg.show({title:'提示',msg:'参数数据有错,请修改参数表指标深度!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:400});
							}
							if(jsonData.info=='null'){
								Handler = function(){codeField.focus();}
								Ext.Msg.show({title:'提示',msg:'你以前添加过错误数据,没有上级节点ID!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:400});
							}
						}
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
				title: '添加科室信息',
				width: 350,
				height:400,
				//minWidth: 420,
				//minHeight: 650,
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