//修改函数
updateFun = function(node){
	if(node==null){
		Ext.Msg.show({title:'提示',msg:'请选择要修改的数据!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
		return false;
	}else{
		if(node.attributes.id=="roo"){
			Ext.Msg.show({title:'提示',msg:'根节点不允许被修改!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
			return false;
		}else{
			//取该条记录的rowid
			var rowid = node.attributes.id;
			
			var isEnd = node.attributes.islast;
			if(isEnd=="Y"){
				var disabled=false;
			}else{
				var disabled=true;
			}
		
			var NameField = new Ext.form.TextField({
				id:'NameField',
				fieldLabel: '科室名称',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'请科室名称...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(NameField.getValue()!=""){
								CodeField.focus();
							}else{
								Handler = function(){NameField.focus();}
								Ext.Msg.show({title:'错误',msg:'指标名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
							}
						}
					}
				}
			});
			
			var CodeField = new Ext.form.TextField({
				id:'CodeField',
				fieldLabel: '科室代码',
				allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'请填写科室代码...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							PYField.focus();
						}
					}
				}
			});
			
			var PYField = new Ext.form.TextField({
				id:'PYField',
				fieldLabel: '拼 音 码',
				//allowBlank: false,
				width:180,
				listWidth : 180,
				emptyText:'请填写拼音码...',
				anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							DeptCom.focus();
						}
					}
				}
			});
			
			
////////////////////////科室类别//////////////////////////			
			var UnitDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
			});
			UnitDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
				url:'herp.budg.budgdeptsettreeexe.csp'+'?action=caldept',method:'POST'});
			});
			var DeptCom = new Ext.form.ComboBox({
				id: 'DeptCom',
				fieldLabel: '科室类别',
				width:200,
				listWidth : 300,
				allowBlank: false,
				store: UnitDs,
				valueField: 'rowid',
				displayField: 'name',
				triggerAction: 'all',
				emptyText:'请选择科室类别...',
				valueNotFoundText:node.attributes.classTypename,
				anchor: '90%',
				name: 'DeptCom',
				minChars: 1,
				pageSize: 10,
				selectOnFocus:true,
				forceSelection:'true',
				editable:true,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							UnitUserCom.focus();
						}
					}
				}

			});	
			
////////////////////////科主任//////////////////////////			
			var UnitUserDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
			});


			UnitUserDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
				url:'herp.budg.budgdeptsettreeexe.csp'+'?action=caluser',method:'POST'});
			});
			var UnitUserCom = new Ext.form.ComboBox({
				id: 'UnitUserCom',
				fieldLabel: '科主任',
				width:200,
				listWidth :300,
				allowBlank: true,
				store: UnitUserDs,
				valueField: 'rowid',
				displayField: 'name',
				triggerAction: 'all',
				emptyText:'请选择科主任名称...',
				valueNotFoundText:node.attributes.directname,
				anchor: '90%',
				name: 'UnitUserCom',
				minChars: 1,
				pageSize: 10,
				selectOnFocus:true,
				forceSelection:'true',
				editable:true,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							IOField.focus();
						}
					}
				}
			});	
			
//////////////////////门诊/住院/////////////////////////
			var IOField = new Ext.form.TextField({
				id:'IOField',
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
							IsProjField.focus();
						}
					}
				}
			});	
			
			
//////////////////////是否用于项目预算/////////////////////////
			var IsProjStore = new Ext.data.SimpleStore({
						fields : ['key', 'keyValue'],
						data : [['1', '是'], ['0', '否']]
					});
			var IsProjField = new Ext.form.ComboBox({
						id : 'IsProjField',
						fieldLabel : '参与项目预算',
						width : 200,
						listWidth : 245,
						selectOnFocus : true,
						//allowBlank : false,
						store : IsProjStore,
						anchor : '90%',
						// value:'key', //默认值
						valueNotFoundText:node.attributes.extreMumName,
						displayField : 'keyValue',
						valueField : 'key',
						triggerAction : 'all',
						emptyText : '',
						mode : 'local', // 本地模式
						editable : false,
						pageSize : 10,
						minChars : 1,
						selectOnFocus : true,
						forceSelection : true,
						listeners :{
							specialKey :function(field,e){
								if (e.getKey() == Ext.EventObject.ENTER){
									IsLastField.focus();
								}
							}
						}
					});	
					
			var IsLastField = new Ext.form.Checkbox({												
				id: 'IsLastField',
				fieldLabel:'末级',
				allowBlank: false,
				checked:node.attributes.islast=='Y'?true:false,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							editButton.focus();
						}
					}
				}
			});

//=====================================================================================				
	
			formPanel = new Ext.form.FormPanel({
				baseCls: 'x-plain',
				labelWidth: 80,
				items: [
					NameField,     //名称
					CodeField,     //代码
					PYField,  	   //拼音码
					DeptCom,       //科室类别
					UnitUserCom,   //科主任
					IOField,       //门诊/住院说明
					IsProjField,   //是否用于项目预算
					IsLastField    //末级

					
				]
			});	
		
			formPanel.on('afterlayout', function(panel,layout) {
				this.getForm().loadRecord(node);
				
				NameField.setValue(node.attributes.name);
				CodeField.setValue(node.attributes.code);
				PYField.setValue(node.attributes.Pym);				
				DeptCom.setValue(node.attributes.classType);       //科室类别
				UnitUserCom.setValue(node.attributes.directdr);    //科主任
				IOField.setValue(node.attributes.IOflag);          //门诊/住院说明
				IsProjField.setValue(node.attributes.isitem);      //是否用于项目预算
				
				
				
			});	
			
			editButton = new Ext.Toolbar.Button({
				text:'修改'
			});

			editHandler = function(){
				var code = CodeField.getValue();
				var name = NameField.getValue();
				var py = PYField.getValue();
				var depttypedr = DeptCom.getValue();
				var director = UnitUserCom.getValue();
				var iodesc = IOField.getValue();
				var isproj = IsProjField.getValue();
				var islast = (IsLastField.getValue()==true)?'1':'0';												
				var level  = node.attributes.level;
											
				name = trim(name);
				code = trim(code);
				if(name==""){
					Ext.Msg.show({title:'提示',msg:'科室名称为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:150});
					return false;
				};
				if(code==""){
					Ext.Msg.show({title:'提示',msg:'科室名称为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:150});
					return false;
				};
				
				var data =name+"^"+code+"^"+py+"^"+depttypedr+"^"+director+"^"+iodesc+"^"+isproj+"^"+islast+"^"+level;
				
				
				//alert(data);
				data = trim(data);
				if(data==""){
					Ext.Msg.show({title:'提示',msg:'空数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return false;
				};
		
				Ext.Ajax.request({
					url: '../csp/herp.budg.budgdeptsettreeexe.csp?action=edit&data='+encodeURIComponent(data)+'&rowid='+rowid,
					waitMsg: '修改中...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接?',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'提示',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:150});
							
											
							if(node.attributes.supdeptid==0){
								node.attributes.supdeptid="roo";
							}
							Ext.getCmp('detailReport').getNodeById(node.attributes.supdeptid).reload();
							window.close();
						}else{
							var message = "";
							if(jsonData.info=='RepName') message='科室名称重复!';
							if(jsonData.info=='dataEmpt') message='空数据!';
							if(jsonData.info=='rowidEmpt') message='数据有错!';
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:150});
						}
						
						
						
					},
					scope: this
				});
			};
	
			editButton.addListener('click',editHandler,false);
		
			cancel = new Ext.Toolbar.Button({
				text:'退出'
			});
			
			cancelHandler1 = function(){
				window.close();
			}

			cancel.addListener('click',cancelHandler1,false);
			
			var window = new Ext.Window({
				title: '修改科室信息',
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
				buttons:[editButton,cancel]
			});
			window.show();
		}
	}
};