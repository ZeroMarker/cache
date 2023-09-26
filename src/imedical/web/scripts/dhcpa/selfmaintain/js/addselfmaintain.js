//��Ӻ���
addFun = function(node){
	if(node!=null){
		var end = node.attributes.isend;
		if(end=="Y"){
			Ext.Msg.show({title:'��ʾ',msg:'ĩ�˲�������ӽڵ�!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:250});
			return false;
		}else{
			//��ĩ�˽ڵ�,�������
			var parentname = node.attributes.name;
			var parentid = node.attributes.id;
			
			var nameField = new Ext.form.TextField({
				id:'nameField',
				fieldLabel: '��Ŀ����',
				allowBlank: false,
				width:150,
				anchor: '90%',
				emptyText:'����д��Ŀ����...',
				selectOnFocus:'true',
				listeners :{
					specialKey :function(field,e){
						if (e.getKey() == Ext.EventObject.ENTER){
							if(nameField.getValue()!=""){
								codeField.focus();
							}else{
								Handler = function(){nameField.focus();}
								Ext.Msg.show({title:'����',msg:'��Ŀ���Ʋ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
							}
						}
					}
				}
			});
			
			//���ɽڵ����code
		    Ext.Ajax.request({			
					url:'../csp/dhc.pa.selfmaintainexe.csp?action=lastcode&parent='+parentid,
					waitMsg:'������...',
					failure: function(result, request){
								Ext.Msg.show({title:'����',msg:'������������!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
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
				fieldLabel: '��Ŀ����',
				allowBlank: true,
				width:150,
				anchor: '90%',
				emptyText:'����д��Ŀ����...',
				selectOnFocus:true			
			});
			
			/*var shortcutField = new Ext.form.TextField({
				id:'shortcutField',
				fieldLabel: '��ݼ�',
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
				data : [["1",'���ı�����'],["2",'ѡ��'],["3",'���ı�����']]
			});
			var typeField = new Ext.form.ComboBox({
					id:'typeField',
					fieldLabel : '����',
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
					mode : 'local', // ����ģʽ
					editable : false,
					//pageSize : 10,
					minChars : 1,
					forceSelection : true
			});
			
			var descField = new Ext.form.TextField({
				id:'descField',
				fieldLabel: '��Ŀ����',
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
				fieldLabel: '��λ',
				width:150,
				anchor: '90%',
				allowBlank: true,
				store: calUnitDs,
				valueField: 'rowid',
				displayField: 'name',
				triggerAction: 'all',
				emptyText:'��ѡ��λ...',
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
								Ext.Msg.show({title:'����',msg:'��λ����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
							}
						}
					}
				}
			});

			
			
			var	levelField = new Ext.form.TextField({
				id:'levelField',
				fieldLabel: '�㼶',
				allowBlank: true,
				width:150,
				anchor: '90%',
				//value:node.attributes.level+1,
				emptyText:'����д�㼶...',
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
				data : [["Y",'��'],["N",'��']]
			});
			var isEndField = new Ext.form.ComboBox({
				id: 'isEndField',
				fieldLabel: '�Ƿ�ĩ��',
				width:150,
				anchor: '90%',
				selectOnFocus: true,
				allowBlank: true,
				store: isEndStore,
				value:"", //Ĭ��ֵ
				valueNotFoundText:'',
				displayField: 'keyValue',
				valueField: 'key',
				triggerAction: 'all',
				emptyText:'',
				mode: 'local', //����ģʽ
				editable:false,
				pageSize: 10,
				minChars: 1,
				selectOnFocus: true,
				forceSelection: true,
				listeners:{ 'select':function(){
										if(isEndField.getValue()=="Y"){
											calUnitField.enable(); //ֻ��ĩ��ڵ�������õ�λ
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
				fieldLabel:'�ϼ���Ŀ',
				width:150,
				anchor: '90%',
				disabled:true
			});
			if(node.attributes.id=="roo"){
				parentname="��Ŀ����";
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
			
			
			
			//������Ӱ�ť
			var addButton = new Ext.Toolbar.Button({
				text:'���'
			});
			//��Ӵ�����
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
					Ext.Msg.show({title:'����',msg:'���Ʋ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
					return false;
				}
				if(code==""){
					Ext.Msg.show({title:'����',msg:'���벻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
					return false;
				}
				if(isend==""){
					Ext.Msg.show({title:'����',msg:'�Ƿ�ĩ�㲻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
					return false;
				}			
				//var data = encodeURIComponent(name)+"^"+py+"^"+dimTypeDr+"^"+type+"^"+desc+"^"+calUnitDr+"^"+extreMum+"^"+expre+"^"+expreDesc+"^"+colTypeDr+"^"+scoreMethodCode+"^"+colDeptDr+"^"+dataSource+"^"+isHospKPI+"^"+isDeptKPI+"^"+isMedKPI+"^"+isNurKPI+"^"+isPostKPI+"^"+parent+"^"+level+"^"+isStop+"^"+isEnd+"^"+order+"^"+isKPI+"^"+code+"^"+calculation;
				Ext.Ajax.request({
					url:'../csp/dhc.pa.selfmaintainexe.csp?action=add&name='+encodeURIComponent(name)+'&code='+encodeURIComponent(code)+'&type='+encodeURIComponent(type)+'&desc='+encodeURIComponent(desc)+
						'&calunit='+encodeURIComponent(calunit)+'&level='+encodeURIComponent(level)+'&isend='+encodeURIComponent(isend)+'&parent='+encodeURIComponent(parent),
					waitMsg:'�����..',
					failure: function(result, request){
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'��ʾ',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,width:200});
							Ext.getCmp('detailReport').root.reload();
							//win.close();
						}else{
							if(jsonData.info=='RepName'){
								Handler = function(){nameField.focus();}
								Ext.Msg.show({title:'��ʾ',msg:'�����ظ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:200});
							}
							
							if(jsonData.info=='null'){
								Handler = function(){nameField.focus();}
								Ext.Msg.show({title:'��ʾ',msg:'����ǰ��ӹ���������,û���ϼ��ڵ�ID!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:400});
							}
						}
						globalStr3="";
					},
					scope: this
				});
			}

			//��Ӱ�ť����Ӧ�¼�
			addButton.addListener('click',addHandler,false);

			//����ȡ����ť
			var cancelButton = new Ext.Toolbar.Button({
				text:'ȡ��'
			});

			//ȡ��������
			var cancelHandler = function(){
				win.close();
			}

			//ȡ����ť����Ӧ�¼�
			cancelButton.addListener('click',cancelHandler,false);

			var win = new Ext.Window({
				title: '���',
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
		Ext.Msg.show({title:'����',msg:'��ѡ��Ҫ����ӽڵ�ļ�¼!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,width:250});
	}
};