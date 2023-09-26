//�޸ĺ���
updateFun = function(node){
	if(node==null){
		Ext.Msg.show({title:'��ʾ',msg:'��ѡ��Ҫ�޸ĵ�����!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
		return false;
	}else{
		if(node.attributes.id=="roo"){
			Ext.Msg.show({title:'��ʾ',msg:'���ڵ㲻�����޸�!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
			return false;
		}else{
			//ȡ������¼��rowid
			
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
				var isend="��";
			}else{
				var isend="��";
			}
			//ȡ���ϼ���Ŀ����
		    Ext.Ajax.request({			
					url:'../csp/dhc.pa.selfmaintainexe.csp?action=Getparentname&parent='+encodeURIComponent(parentid),
					waitMsg:'������...',
					failure: function(result, request){
								Ext.Msg.show({title:'����',msg:'������������!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
							},
					success: function(result, request){	
									var json = Ext.util.JSON.decode(result.responseText)
									//var arr = new Array();
									//arr = json.info.split(","),
									if(json.info==""){
										parentField.setValue("��Ŀ����");
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
				fieldLabel: '�ϼ���Ŀ',
				width:150,
				anchor: '90%',
				allowBlank: true,
				store: parentDs,
				disabled:true,
				valueField: 'rowid',
				displayField: 'name',
				triggerAction: 'all',
				emptyText:'��ѡ��λ...',
				name: 'parentField',
				minChars: 1,
				pageSize: 10,
				selectOnFocus:true,
				forceSelection:'true',
				editable:true,
				listeners:{
					'change':function(){
							flag = 1;
							//���ɽڵ����code
		   					 Ext.Ajax.request({			
								url:'../csp/dhc.pa.selfmaintainexe.csp?action=lastcode&parent='+parentField.getValue(),
								waitMsg:'������...',
								failure: function(result, request){
											Ext.Msg.show({title:'����',msg:'������������!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
								},
								success: function(result, request){
											if(result.responseText==001){
												Ext.Ajax.request({
													url:'../csp/dhc.pa.selfmaintainexe.csp?action=parentcode&parent='+parentField.getValue(),
													waitMsg:'��ѯ��...',
													failure:function(result,request){
														Ext.Msg.show({title:'����',msg:'������������!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
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
				fieldLabel: '��Ŀ����',
				allowBlank: false,
				//width:150,
				anchor: '90%',
				valueNotFoundText:name,
				emptyText:'����д��Ŀ����...',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(NameField.getValue()!=""){
								CodeField.focus();
							}else{
								Handler = function(){NameField.focus();}
								Ext.Msg.show({title:'����',msg:'ָ�����Ʋ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
							}
						}
					}
				}
			});
			
			var CodeField = new Ext.form.TextField({
				id:'CodeField',
				fieldLabel: '��Ŀ����',
				allowBlank: false,
				
				anchor: '90%',
				valueNotFoundText:code,
				emptyText:'����д��Ŀ����...',
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
				fieldLabel: '��λ',
				//width:150,
				anchor: '90%',
				allowBlank: true,
				store: calUnitDs,
				valueNotFoundText:unit,
				valueField: 'rowid',
				displayField: 'name',
				triggerAction: 'all',
				emptyText:'��ѡ��λ...',
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
				data : [["1",'���ı�����'],["2",'ѡ��'],["3",'���ı�����']]
			});
			var TypeField = new Ext.form.ComboBox({
					id:'TypeField',
					fieldLabel : '���',
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
					mode : 'local', // ����ģʽ
					editable : false,
					//pageSize : 10,
					minChars : 1,
					forceSelection : true
			});
			
			var DescField = new Ext.form.TextField({
				id:'DescField',
				fieldLabel: '��Ŀ����',
				//allowBlank: false,
				//width:150,
				anchor: '90%',
				valueNotFoundText:desc,
				emptyText:'����д��Ŀ����...',
				//anchor: '90%',
				selectOnFocus:'true'
			});
			var levelField = new Ext.form.TextField({
				id:'levelField',
				fieldLabel: '�㼶',
				//allowBlank: false,
				//width:150,
				anchor: '90%',
				valueNotFoundText:level,
				emptyText:'����д�㼶...',
				//anchor: '90%',
				disabled:true,
				selectOnFocus:'true'
			});							
			var isEnd = new Ext.form.TextField({
				id: 'isEnd',
				fieldLabel:'�Ƿ�ĩ��',
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
				text:'�޸�'
			});

			editHandler = function(){
				var flag = 0;
				var rowid = node.attributes.id;
				var parent = parentField.getValue();
				if(parentField.getRawValue()=="��Ŀ����"){
					parent = 0;
				}
				var newcode = CodeField.getValue();
				var newname = NameField.getValue();
				var newunit = UnitField.getValue();
			
				var newtype = TypeField.getValue();
				var newdesc = DescField.getValue();
//					alert(newunit+"  "+newtype);
				if(newname==""){
					Ext.Msg.show({title:'��ʾ',msg:'����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:150});
					return false;
				};
				if(newname==node.attributes.name){
					flag=1;
				}
				
				/*var data =code+"^"+name+"^"+py+"^"+dimTypeDr+"^"+target+"^"+desc+"^"+calUnitDr+"^"+extreMum+"^"+expre+"^"+expreDesc+"^"+colTypeDr+"^"+scoreMethodCode+"^"+colDeptDr+"^"+dataSource+"^"+IsHospKPI+"^"+IsDeptKPI+"^"+IsMedKPI+"^"+IsNurKPI+"^"+IsPostKPI+"^"+parent+"^"+level+"^"+IsStop+"^"+IsEnd+"^"+order+"^"+IsKPI+"^"+calculation;
				alert(data);
				data = trim(data);
				if(data==""){
					Ext.Msg.show({title:'��ʾ',msg:'������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return false;
				};*/
				Ext.Ajax.request({
					url: '../csp/dhc.pa.selfmaintainexe.csp?action=edit&rowid='+rowid+'&newcode='+newcode+'&newname='+encodeURIComponent(newname)+'&newunit='+newunit+'&newdesc='+encodeURIComponent(newdesc)+'&parent='+encodeURIComponent(parent)+'&flag='+flag+'&newtype='+newtype,
					waitMsg: '�޸���...',
					failure: function(result, request) {
						Ext.Msg.show({title:'����',msg:'������������?',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'��ʾ',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:150});
							//Ext.getCmp('detailReport').getNodeById(node.attributes.parent).reload();
							Ext.getCmp('detailReport').root.reload();
							window.close();
						}else{
							var message = "";
							if(jsonData.info=='RepName') message='�����ظ�!';
							//if(jsonData.info=='dataEmpt') message='������!';
							//if(jsonData.info=='rowidEmpt') message='�����д�!';
							Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:150});
						}
						
						
						
					},
					scope: this
				});
			};
	
			editButton.addListener('click',editHandler,false);
		
			cancel = new Ext.Toolbar.Button({
				text:'�˳�'
			});
			
			cancelHandler1 = function(){
				window.close();
			}

			cancel.addListener('click',cancelHandler1,false);
			
			var window = new Ext.Window({
				title: '�޸�ָ���¼',
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