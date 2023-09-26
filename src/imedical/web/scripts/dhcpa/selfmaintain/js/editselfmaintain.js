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
			
			//console.log(node.attributes);
			var flag = 0;
			var rowid = node.attributes.id;
			var name = node.attributes.name;
			var code = node.attributes.code;
			var unit = node.attributes.unit;
			var type = node.attributes.type;
			var desc = node.attributes.desc;
			var level = node.attributes.level;
			var isend = node.attributes.isend;
			var parentid = node.attributes.parentid;
			if(isend=="Y"){
				var isend="是";
			}else{
				var isend="否";
			}
			//取得上级项目名称
		    Ext.Ajax.request({			
					url:'../csp/dhc.pa.selfmaintainexe.csp?action=Getparentname&parent='+encodeURIComponent(parentid),
					waitMsg:'生成中...',
					failure: function(result, request){
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
							},
					success: function(result, request){	
									var json = Ext.util.JSON.decode(result.responseText)
									//var arr = new Array();
									//arr = json.info.split(","),
									if(json.info==""){
										parentField.setValue("项目管理");
									}else{
										parentField.setValue(json.info);
									}
									
																	
							},
							scope: this
			});
			var parentDs = new Ext.data.Store({
				autoLoad:true,
				proxy:"",
				reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
			});

			parentDs.on('beforeload', function(ds, o){
				ds.proxy=new Ext.data.HttpProxy({
					url:'../csp/dhc.pa.selfmaintainexe.csp?action=Getparent',method:'POST'})
			});
			var tmp = new Ext.form.TextField({
				id:'tmp'		
			});
			var parentField = new Ext.form.ComboBox({
				id: 'parentField',
				fieldLabel: '上级项目',
				width:150,
				anchor: '90%',
				allowBlank: true,
				store: parentDs,
				disabled:true,
				valueField: 'rowid',
				displayField: 'name',
				triggerAction: 'all',
				emptyText:'请选择单位...',
				name: 'parentField',
				minChars: 1,
				pageSize: 10,
				selectOnFocus:true,
				forceSelection:'true',
				editable:true,
				listeners:{
					'change':function(){
							flag = 1;
							//生成节点编码code
		   					 Ext.Ajax.request({			
								url:'../csp/dhc.pa.selfmaintainexe.csp?action=lastcode&parent='+parentField.getValue(),
								waitMsg:'生成中...',
								failure: function(result, request){
											Ext.Msg.show({title:'错误',msg:'请检查网络连接!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
								},
								success: function(result, request){
											if(result.responseText==001){
												Ext.Ajax.request({
													url:'../csp/dhc.pa.selfmaintainexe.csp?action=parentcode&parent='+parentField.getValue(),
													waitMsg:'查询中...',
													failure:function(result,request){
														Ext.Msg.show({title:'错误',msg:'请检查网络连接!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
													},
													success:function(result,request){
														CodeField.setValue(result.responseText+'01');
													}
												});
											}else{
												CodeField.setValue(result.responseText);
											}		
								},
							scope: this
						});
					}
				}
			});

			var NameField = new Ext.form.TextField({
				id:'NameField',
				fieldLabel: '项目名称',
				allowBlank: false,
				//width:150,
				anchor: '90%',
				valueNotFoundText:name,
				emptyText:'请填写项目名称...',
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
				fieldLabel: '项目代码',
				allowBlank: false,
				
				anchor: '90%',
				valueNotFoundText:code,
				emptyText:'请填写项目代码...',
				//anchor: '90%',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							PYField.focus();
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

			var UnitField = new Ext.form.ComboBox({
				id: 'UnitField',
				fieldLabel: '单位',
				//width:150,
				anchor: '90%',
				allowBlank: true,
				store: calUnitDs,
				valueNotFoundText:unit,
				valueField: 'rowid',
				displayField: 'name',
				triggerAction: 'all',
				emptyText:'请选择单位...',
				name: 'UnitField',
				minChars: 1,
				pageSize: 10,
				selectOnFocus:true,
				forceSelection:'true',
				disabled:node.attributes.isend=='Y'?false:true,
				editable:true
			});
			
			var TypeStore = new Ext.data.SimpleStore({
				fields: ['key','keyValue'],
				data : [["1",'多文本描述'],["2",'选项'],["3",'单文本描述']]
			});
			var TypeField = new Ext.form.ComboBox({
					id:'TypeField',
					fieldLabel : '类别',
					//width : 150,
					anchor: '90%',
					selectOnFocus : true,
					allowBlank : false,
					store : TypeStore,
					name:'typeField',
					valueNotFoundText : '',
					displayField : 'keyValue',
					valueNotFoundText:type,
					valueField : 'key',
					triggerAction : 'all',
					emptyText : '',
					mode : 'local', // 本地模式
					editable : false,
					//pageSize : 10,
					minChars : 1,
					forceSelection : true
			});
			
			var DescField = new Ext.form.TextField({
				id:'DescField',
				fieldLabel: '项目描述',
				//allowBlank: false,
				//width:150,
				anchor: '90%',
				valueNotFoundText:desc,
				emptyText:'请填写项目描述...',
				//anchor: '90%',
				selectOnFocus:'true'
			});
			var levelField = new Ext.form.TextField({
				id:'levelField',
				fieldLabel: '层级',
				//allowBlank: false,
				//width:150,
				anchor: '90%',
				valueNotFoundText:level,
				emptyText:'请填写层级...',
				//anchor: '90%',
				disabled:true,
				selectOnFocus:'true'
			});							
			var isEnd = new Ext.form.TextField({
				id: 'isEnd',
				fieldLabel:'是否末层',
				//width:150,
				anchor: '90%',
				allowBlank: false,
				//clearCls:'stop-float',
				disabled:true,
				valueNotFoundText:isend
				/*checked:isend=='Y'?true:false,
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							OrderField.focus();
						}
					},
					'check':function(checked){
                        if(checked.checked){
							UnitField.enable();
                        }else{
							UnitField.disable();
                        }
                    }
				}*/
			});
		
			formPanel = new Ext.form.FormPanel({
				//baseCls: 'x-plain',
				frame:true,
				labelWidth: 60,
				items: [
					parentField,
					NameField,
					CodeField,
					UnitField,
					TypeField,
					DescField,
					levelField,
					isEnd			
				]
			});	
		formPanel.on('afterlayout', function(panel,layout) {
				this.getForm().loadRecord(node);
				//parentField.setValue(node.attributes.name);
				NameField.setValue(name);
				CodeField.setValue(code);
				
				UnitField.setValue(unit);
				TypeField.setValue(type);
				DescField.setValue(desc);
				levelField.setValue(level);
				isEnd=isend;
				
			});	
		
			editButton = new Ext.Toolbar.Button({
				text:'修改'
			});

			editHandler = function(){
				var flag = 0;
				var rowid = node.attributes.id;
				var parent = parentField.getValue();
				if(parentField.getRawValue()=="项目管理"){
					parent = 0;
				}
				var newcode = CodeField.getValue();
				var newname = NameField.getValue();
				var newunit = UnitField.getValue();
			
				var newtype = TypeField.getValue();
				var newdesc = DescField.getValue();
//					alert(newunit+"  "+newtype);
				if(newname==""){
					Ext.Msg.show({title:'提示',msg:'名称为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:150});
					return false;
				};
				if(newname==node.attributes.name){
					flag=1;
				}
				
				/*var data =code+"^"+name+"^"+py+"^"+dimTypeDr+"^"+target+"^"+desc+"^"+calUnitDr+"^"+extreMum+"^"+expre+"^"+expreDesc+"^"+colTypeDr+"^"+scoreMethodCode+"^"+colDeptDr+"^"+dataSource+"^"+IsHospKPI+"^"+IsDeptKPI+"^"+IsMedKPI+"^"+IsNurKPI+"^"+IsPostKPI+"^"+parent+"^"+level+"^"+IsStop+"^"+IsEnd+"^"+order+"^"+IsKPI+"^"+calculation;
				alert(data);
				data = trim(data);
				if(data==""){
					Ext.Msg.show({title:'提示',msg:'空数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return false;
				};*/
				Ext.Ajax.request({
					url: '../csp/dhc.pa.selfmaintainexe.csp?action=edit&rowid='+rowid+'&newcode='+newcode+'&newname='+encodeURIComponent(newname)+'&newunit='+newunit+'&newdesc='+encodeURIComponent(newdesc)+'&parent='+encodeURIComponent(parent)+'&flag='+flag+'&newtype='+newtype,
					waitMsg: '修改中...',
					failure: function(result, request) {
						Ext.Msg.show({title:'错误',msg:'请检查网络连接?',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'提示',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:150});
							//Ext.getCmp('detailReport').getNodeById(node.attributes.parent).reload();
							Ext.getCmp('detailReport').root.reload();
							window.close();
						}else{
							var message = "";
							if(jsonData.info=='RepName') message='名称重复!';
							//if(jsonData.info=='dataEmpt') message='空数据!';
							//if(jsonData.info=='rowidEmpt') message='数据有错!';
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
				title: '修改指标记录',
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
				buttons:[editButton,cancel]
			});
			window.show();
		}
	}
};